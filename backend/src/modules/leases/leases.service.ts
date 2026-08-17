import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { LeaseStatus, Prisma, RoleName } from '@prisma/client';
import { LeasesRepository } from './leases.repository';
import { LeasesMapper } from './leases.mapper';
import {
  CreateLeaseDto,
  UpdateLeaseDto,
  TerminateLeaseDto,
  RenewLeaseDto,
  AddAmendmentDto,
  QueryLeaseDto,
  RefuseLeaseDto,
} from './dto';
import { PaginatedResponseDto } from '../../common/dto';
import { PrismaService } from '../../prisma/prisma.service';
import { AuthenticatedUser } from '../../common/interfaces';
import { addDays, firstDueDateOnOrAfter } from '../../common/utils/date-helpers.util';
import { generatePdfStub } from '../../common/utils/pdf-generator.util';
import { NotificationsService } from '../notifications/notifications.service';
import {
  isLeaseTransitionAllowed,
  NON_TERMINAL_LEASE_STATUSES,
} from '../../common/constants/lease-transitions.constant';

@Injectable()
export class LeasesService {
  constructor(
    private readonly repo: LeasesRepository,
    private readonly prisma: PrismaService,
    private readonly notifications: NotificationsService,
  ) {}

  /**
   * V2 pivot (spec §0/§6/§49): scoped by managerId for GESTIONNAIRE, by ownerId (via their linked
   * Owner record) for PROPRIETAIRE, by tenantId for LOCATAIRE — never by a client-supplied value.
   * ADMIN_AGENCE/SUPER_ADMIN keep the unscoped org-wide view.
   */
  async findAll(organizationId: string, user: AuthenticatedUser, query: QueryLeaseDto) {
    const where: Prisma.LeaseWhereInput = { organizationId, deletedAt: null };
    if (query.status) where.status = query.status;
    if (query.propertyUnitId) where.propertyUnitId = query.propertyUnitId;

    if (user.roleName === RoleName.LOCATAIRE) {
      where.tenantId = user.tenantProfileId ?? '__none__';
    } else if (query.tenantId) {
      where.tenantId = query.tenantId;
    }

    if (user.roleName === RoleName.GESTIONNAIRE) {
      where.managerId = user.id;
    } else if (user.roleName === RoleName.PROPRIETAIRE) {
      const owner = await this.prisma.owner.findFirst({ where: { userId: user.id } });
      where.ownerId = owner?.id ?? '__none__';
    }

    const [items, total] = await Promise.all([
      this.repo.findMany(where, (query.page - 1) * query.limit, query.limit, {
        [query.sortBy ?? 'createdAt']: query.sortOrder ?? 'desc',
      }),
      this.repo.count(where),
    ]);

    return new PaginatedResponseDto(items.map(LeasesMapper.toResponse), total, query.page, query.limit);
  }

  async findOne(id: string, user: AuthenticatedUser) {
    const lease = await this.getOwnedOrThrow(id, user);
    return LeasesMapper.toResponse(lease);
  }

  /** Creates a lease as a BROUILLON (draft): the unit is not occupied until `accept()` cascades it to ACTIF. */
  async create(organizationId: string, user: AuthenticatedUser, dto: CreateLeaseDto) {
    const unit = await this.prisma.propertyUnit.findFirst({
      where: { id: dto.propertyUnitId, organizationId, deletedAt: null },
      include: { property: { select: { id: true, ownerId: true } } },
    });
    if (!unit) throw new BadRequestException('Lot invalide pour cette organisation.');

    const conflicting = await this.prisma.lease.findFirst({
      where: { propertyUnitId: dto.propertyUnitId, status: { in: NON_TERMINAL_LEASE_STATUSES }, deletedAt: null },
    });
    if (conflicting)
      throw new ConflictException('Ce lot a déjà un contrat en cours (envoyé, consulté, accepté ou actif).');

    const tenant = await this.prisma.tenant.findFirst({ where: { id: dto.tenantId, organizationId, deletedAt: null } });
    if (!tenant) throw new BadRequestException('Locataire invalide pour cette organisation.');

    // managerId is denormalized from the property's ACTIVE PropertyManagement row (spec §2/§15) —
    // never from the caller's own id — so authorization always traces back to the source relation.
    // For a GESTIONNAIRE caller that relation must point back to them (403 otherwise); other
    // callers (e.g. ADMIN_AGENCE's dormant path) simply require SOME active manager to exist.
    const activeManagement = await this.prisma.propertyManagement.findFirst({
      where: { propertyId: unit.property.id, status: 'ACTIVE' },
      orderBy: { createdAt: 'desc' },
    });

    if (user.roleName === RoleName.GESTIONNAIRE) {
      if (!activeManagement || activeManagement.managerId !== user.id) {
        throw new ForbiddenException('Vous ne gérez pas ce bien, impossible de créer un contrat.');
      }
    }
    if (!activeManagement) {
      throw new BadRequestException("Ce bien n'a pas de gestionnaire actif assigné; impossible de créer un contrat.");
    }

    const startDate = new Date(dto.startDate);
    const reference = await this.generateReference(organizationId);

    const lease = await this.prisma.$transaction(async (tx) => {
      const created = await tx.lease.create({
        data: {
          organization: { connect: { id: organizationId } },
          propertyUnit: { connect: { id: dto.propertyUnitId } },
          owner: { connect: { id: unit.property.ownerId } },
          manager: { connect: { id: activeManagement.managerId } },
          tenant: { connect: { id: dto.tenantId } },
          reference,
          startDate,
          endDate: dto.endDate ? new Date(dto.endDate) : null,
          rentAmount: dto.rentAmount,
          depositAmount: dto.depositAmount,
          paymentFrequency: dto.paymentFrequency,
          rentDueDay: dto.rentDueDay ?? 5,
          indexationRate: dto.indexationRate,
          status: 'BROUILLON',
        },
      });

      await tx.leaseStatusHistory.create({ data: { leaseId: created.id, toStatus: 'BROUILLON' } });

      return created;
    });

    const full = await this.repo.findById(lease.id);
    return LeasesMapper.toResponse(full!);
  }

  async update(id: string, dto: UpdateLeaseDto) {
    await this.ensureExists(id);
    const lease = await this.repo.update(id, {
      ...dto,
      endDate: dto.endDate !== undefined ? new Date(dto.endDate) : undefined,
    });
    return LeasesMapper.toResponse(lease);
  }

  // ---------------------------------------------------------------------
  // Status workflow (spec Part B): BROUILLON -> ENVOYE -> CONSULTE -> ACCEPTE -> ACTIF,
  // with REFUSE/ANNULE off-ramps. See common/constants/lease-transitions.constant.ts.
  // ---------------------------------------------------------------------

  /** Manager sends the draft contract to the tenant. */
  async send(id: string, changedById: string) {
    return this.applyTransition(id, 'ENVOYE', changedById);
  }

  /** Tenant app calls this the first time the tenant opens the lease. */
  async acknowledge(id: string, user: AuthenticatedUser) {
    await this.getOwnedOrThrow(id, user);
    return this.applyTransition(id, 'CONSULTE', user.id);
  }

  /**
   * Tenant accepts the contract (from ENVOYE directly, or CONSULTE if they acknowledged first).
   * Design choice: ACCEPTE cascades straight into ACTIF within the same call — the unit is
   * marked OCCUPE and the initial rent Payment row is generated here, mirroring what the OLD
   * `create()` used to do on the spot. See report for why a separate `activate` step was not used.
   */
  async accept(id: string, user: AuthenticatedUser) {
    const lease = await this.getOwnedOrThrow(id, user);
    this.assertTransition(lease.status, 'ACCEPTE');
    this.assertTransition('ACCEPTE', 'ACTIF');

    await this.prisma.$transaction(async (tx) => {
      await tx.leaseStatusHistory.create({
        data: { leaseId: id, fromStatus: lease.status, toStatus: 'ACCEPTE', changedById: user.id },
      });
      await tx.leaseStatusHistory.create({
        data: {
          leaseId: id,
          fromStatus: 'ACCEPTE',
          toStatus: 'ACTIF',
          changedById: user.id,
          note: 'Cascade automatique ACCEPTE -> ACTIF.',
        },
      });
      await tx.lease.update({ where: { id }, data: { status: 'ACTIF' } });
      await tx.propertyUnit.update({ where: { id: lease.propertyUnitId }, data: { status: 'OCCUPE' } });

      await tx.leaseDocument.create({
        data: { leaseId: id, type: 'CONTRAT_PDF', url: `/generated/leases/${id}/contract.json` },
      });

      // First rent installment aligned to the lease's rentDueDay (the manager-configured day of
      // the month rent is due, e.g. "the 5th"), not the raw lease start date; subsequent ones are
      // generated by the monthly cron job (generateMonthlyPaymentsJob, see notifications.scheduler.ts).
      await tx.payment.create({
        data: {
          organization: { connect: { id: lease.organizationId } },
          lease: { connect: { id } },
          amountDue: lease.rentAmount,
          dueDate: firstDueDateOnOrAfter(lease.startDate, lease.rentDueDay),
          status: 'EN_ATTENTE',
        },
      });
    });

    const updated = await this.repo.findById(id);
    return LeasesMapper.toResponse(updated!);
  }

  /** Tenant refuses the proposed contract. */
  async refuse(id: string, user: AuthenticatedUser, dto: RefuseLeaseDto) {
    await this.getOwnedOrThrow(id, user);
    return this.applyTransition(id, 'REFUSE', user.id, dto.reason);
  }

  /** Manager cancels a draft/sent/consulted contract before it's ever activated. */
  async cancel(id: string, changedById: string) {
    return this.applyTransition(id, 'ANNULE', changedById);
  }

  private async applyTransition(id: string, to: LeaseStatus, changedById?: string, note?: string) {
    const lease = await this.ensureExists(id);
    this.assertTransition(lease.status, to);

    await this.prisma.$transaction([
      this.prisma.lease.update({ where: { id }, data: { status: to } }),
      this.prisma.leaseStatusHistory.create({
        data: { leaseId: id, fromStatus: lease.status, toStatus: to, changedById, note },
      }),
    ]);

    const updated = await this.repo.findById(id);
    return LeasesMapper.toResponse(updated!);
  }

  private assertTransition(from: LeaseStatus, to: LeaseStatus) {
    if (!isLeaseTransitionAllowed(from, to)) {
      throw new ConflictException(`Transition de statut invalide: ${from} -> ${to}.`);
    }
  }

  // ---------------------------------------------------------------------

  async renew(id: string, dto: RenewLeaseDto) {
    const lease = await this.ensureExists(id);
    if (lease.status !== 'ACTIF') throw new ConflictException('Seul un contrat actif peut être renouvelé.');

    const updated = await this.repo.update(id, { endDate: new Date(dto.newEndDate) });
    if (dto.amendmentDescription) {
      await this.repo.addAmendment(id, dto.amendmentDescription, new Date());
    }

    await this.notifications.notify({
      organizationId: lease.organizationId,
      userId: await this.tenantUserId(lease.tenantId),
      type: 'EXPIRATION_CONTRAT',
      title: 'Contrat renouvelé',
      message: `Votre contrat a été renouvelé jusqu'au ${dto.newEndDate}.`,
    });

    return LeasesMapper.toResponse(updated);
  }

  /** Ends an ACTIF tenancy early, freeing the unit back up. */
  async terminate(id: string, dto: TerminateLeaseDto) {
    const lease = await this.ensureExists(id);
    if (lease.status !== 'ACTIF') throw new ConflictException('Seul un contrat actif peut être résilié.');

    const [updated] = await this.prisma.$transaction([
      this.prisma.lease.update({
        where: { id },
        data: { status: 'RESILIE', endDate: new Date(dto.terminationDate) },
        include: {
          documents: true,
          amendments: true,
          propertyUnit: {
            select: {
              id: true,
              reference: true,
              label: true,
              status: true,
              property: { select: { id: true, title: true, reference: true, addressLine: true, city: true } },
            },
          },
          tenant: true,
        },
      }),
      this.prisma.propertyUnit.update({ where: { id: lease.propertyUnitId }, data: { status: 'DISPONIBLE' } }),
      this.prisma.payment.updateMany({
        where: { leaseId: id, status: 'EN_ATTENTE', dueDate: { gt: new Date(dto.terminationDate) } },
        data: { status: 'ANNULE' },
      }),
      this.prisma.leaseStatusHistory.create({
        data: { leaseId: id, fromStatus: 'ACTIF', toStatus: 'RESILIE', note: dto.reason },
      }),
    ]);

    await this.prisma.auditLog.create({
      data: {
        organizationId: lease.organizationId,
        action: 'LEASE_TERMINATED',
        entity: 'Lease',
        entityId: id,
        metadata: { reason: dto.reason ?? null, terminationDate: dto.terminationDate },
      },
    });

    const tenantUserId = await this.tenantUserId(lease.tenantId);
    await this.notifications.notify({
      organizationId: lease.organizationId,
      userId: tenantUserId,
      type: 'EXPIRATION_CONTRAT',
      title: 'Contrat résilié',
      message: `Votre contrat de location a été résilié à compter du ${dto.terminationDate}.`,
    });

    return LeasesMapper.toResponse(updated);
  }

  async addAmendment(id: string, dto: AddAmendmentDto) {
    await this.ensureExists(id);
    await this.repo.addAmendment(id, dto.description, new Date(dto.effectiveDate));
    const updated = await this.repo.findById(id);
    return LeasesMapper.toResponse(updated!);
  }

  async contractPdf(id: string, user: AuthenticatedUser) {
    const lease = await this.getOwnedOrThrow(id, user);
    return generatePdfStub('lease-contract', {
      leaseId: lease.id,
      propertyUnit: lease.propertyUnit,
      tenant: lease.tenant,
      startDate: lease.startDate,
      endDate: lease.endDate,
      rentAmount: Number(lease.rentAmount),
      depositAmount: Number(lease.depositAmount),
    });
  }

  async expiringSoon(organizationId: string, days: number) {
    const from = new Date();
    const to = addDays(from, days);
    const leases = await this.repo.expiringSoon(organizationId, from, to);
    return leases.map(LeasesMapper.toResponse);
  }

  /** Human-readable contract reference (ex: CTR-2026-0042), mirrors PropertiesService.generateReference. */
  private async generateReference(organizationId: string): Promise<string> {
    const year = new Date().getFullYear();
    for (let attempt = 0; attempt < 5; attempt++) {
      const count = await this.prisma.lease.count({
        where: { organizationId, reference: { startsWith: `CTR-${year}-` } },
      });
      const seq = `${count + 1 + attempt}`.padStart(4, '0');
      const candidate = `CTR-${year}-${seq}`;
      const existing = await this.prisma.lease.findFirst({ where: { organizationId, reference: candidate } });
      if (!existing) return candidate;
    }
    return `CTR-${year}-${Date.now()}`;
  }

  private async getOwnedOrThrow(id: string, user: AuthenticatedUser) {
    const lease = await this.repo.findById(id);
    if (!lease) throw new NotFoundException('Contrat introuvable.');

    if (user.roleName === RoleName.LOCATAIRE) {
      const tenant = await this.prisma.tenant.findUnique({ where: { id: lease.tenantId } });
      if (!tenant || tenant.userId !== user.id) {
        throw new ForbiddenException("Vous n'avez pas accès à ce contrat.");
      }
    }

    // Spec §49: a PROPRIETAIRE only ever reaches their own leases, checked against the source
    // relation (their linked Owner record), not the denormalized ownerId alone.
    if (user.roleName === RoleName.PROPRIETAIRE) {
      const owner = await this.prisma.owner.findFirst({ where: { userId: user.id } });
      if (!owner || lease.ownerId !== owner.id) {
        throw new ForbiddenException("Vous n'avez pas accès à ce contrat.");
      }
    }

    return lease;
  }

  private async tenantUserId(tenantId: string): Promise<string | undefined> {
    const tenant = await this.prisma.tenant.findUnique({ where: { id: tenantId } });
    return tenant?.userId ?? undefined;
  }

  private async ensureExists(id: string) {
    const lease = await this.repo.findById(id);
    if (!lease) throw new NotFoundException('Contrat introuvable.');
    return lease;
  }
}
