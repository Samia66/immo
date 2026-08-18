import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Prisma, RoleName } from '@prisma/client';
import { PaymentsRepository } from './payments.repository';
import { PaymentsMapper } from './payments.mapper';
import { CreatePaymentDto, RecordPaymentDto, QueryPaymentDto } from './dto';
import { PaginatedResponseDto } from '../../common/dto';
import { PrismaService } from '../../prisma/prisma.service';
import { AuthenticatedUser } from '../../common/interfaces';
import { generatePaymentReceiptPdf } from '../../common/utils/pdf-generator.util';
import { monthKey } from '../../common/utils/date-helpers.util';
import { NotificationsService } from '../notifications/notifications.service';

@Injectable()
export class PaymentsService {
  constructor(
    private readonly repo: PaymentsRepository,
    private readonly prisma: PrismaService,
    private readonly notifications: NotificationsService,
  ) {}

  async findAll(organizationId: string, query: QueryPaymentDto) {
    const where: Prisma.PaymentWhereInput = { organizationId, deletedAt: null };
    if (query.status) where.status = query.status;
    if (query.propertyUnitId) where.lease = { propertyUnitId: query.propertyUnitId };
    if (query.fromDate || query.toDate) {
      where.dueDate = {};
      if (query.fromDate) where.dueDate.gte = new Date(query.fromDate);
      if (query.toDate) where.dueDate.lte = new Date(query.toDate);
    }

    const [items, total] = await Promise.all([
      this.repo.findMany(where, (query.page - 1) * query.limit, query.limit, {
        [query.sortBy ?? 'dueDate']: query.sortOrder ?? 'desc',
      }),
      this.repo.count(where),
    ]);

    return new PaginatedResponseDto(items.map(PaymentsMapper.toResponse), total, query.page, query.limit);
  }

  async findOne(id: string, user: AuthenticatedUser) {
    const payment = await this.getOwnedOrThrow(id, user);
    return PaymentsMapper.toResponse(payment);
  }

  async create(organizationId: string, dto: CreatePaymentDto) {
    const lease = await this.prisma.lease.findFirst({ where: { id: dto.leaseId, organizationId, deletedAt: null } });
    if (!lease) throw new BadRequestException('Bail invalide pour cette organisation.');
    if (lease.status !== 'ACTIF')
      throw new ConflictException('Impossible de générer une échéance pour un bail non actif.');

    const payment = await this.repo.create({
      organization: { connect: { id: organizationId } },
      lease: { connect: { id: dto.leaseId } },
      amountDue: dto.amountDue,
      dueDate: new Date(dto.dueDate),
      status: 'EN_ATTENTE',
    });

    return PaymentsMapper.toResponse(payment);
  }

  async record(id: string, dto: RecordPaymentDto) {
    const payment = await this.repo.findById(id);
    if (!payment) throw new NotFoundException('Paiement introuvable.');
    if (payment.status === 'ANNULE') throw new ConflictException('Ce paiement a été annulé.');
    if (payment.status === 'PAYE') throw new ConflictException('Ce paiement est déjà soldé.');

    const newAmountPaid = Number(payment.amountPaid) + dto.amountPaid;
    const status = newAmountPaid >= Number(payment.amountDue) ? 'PAYE' : 'PARTIEL';
    const receiptUrl = status === 'PAYE' ? `/generated/payments/${id}/receipt.json` : payment.receiptUrl;

    const updated = await this.repo.update(id, {
      amountPaid: newAmountPaid,
      status,
      paidAt: new Date(dto.paidAt),
      method: dto.method,
      transactionRef: dto.transactionRef,
      receiptUrl,
    });

    // Receipt (explicit model, spec §3): created alongside receiptUrl the moment a payment is
    // fully settled. record() rejects any further call on an already-PAYE payment (see the
    // guard above), so this can never run twice for the same payment.
    if (status === 'PAYE') {
      await this.prisma.receipt.create({
        data: {
          organization: { connect: { id: payment.organizationId } },
          payment: { connect: { id } },
          url: receiptUrl!,
          period: monthKey(payment.dueDate),
          amount: newAmountPaid,
        },
      });
    }

    const lease = await this.prisma.lease.findUnique({ where: { id: payment.leaseId }, include: { tenant: true } });
    if (lease?.tenant.userId) {
      await this.notifications.notify({
        organizationId: payment.organizationId,
        userId: lease.tenant.userId,
        type: 'CONFIRMATION_PAIEMENT',
        title: 'Paiement enregistré',
        message: `Votre paiement de ${dto.amountPaid} a bien été enregistré (statut: ${status}).`,
      });
    }

    return PaymentsMapper.toResponse(updated);
  }

  async receipt(id: string, user: AuthenticatedUser): Promise<Buffer> {
    const payment = await this.getOwnedOrThrow(id, user);
    if (payment.status !== 'PAYE' && payment.status !== 'PARTIEL') {
      throw new BadRequestException("Aucune quittance disponible: le paiement n'a pas encore été enregistré.");
    }
    return generatePaymentReceiptPdf({
      reference: payment.id,
      organizationName: payment.organization.name,
      tenantName: payment.lease.tenant.fullName,
      propertyTitle: payment.lease.propertyUnit.property.title,
      unitLabel: payment.lease.propertyUnit.label ?? payment.lease.propertyUnit.reference,
      amountDue: Number(payment.amountDue),
      amountPaid: Number(payment.amountPaid),
      dueDate: payment.dueDate,
      paidAt: payment.paidAt,
      method: payment.method,
      status: payment.status,
    });
  }

  async overdue(organizationId: string, query: QueryPaymentDto) {
    return this.findAll(organizationId, Object.assign(new QueryPaymentDto(), query, { status: 'EN_RETARD' as const }));
  }

  async myPayments(userId: string, query: QueryPaymentDto) {
    const tenant = await this.prisma.tenant.findFirst({ where: { userId } });
    if (!tenant) return new PaginatedResponseDto([], 0, query.page, query.limit);

    const where: Prisma.PaymentWhereInput = { lease: { tenantId: tenant.id }, deletedAt: null };
    if (query.status) where.status = query.status;

    const [items, total] = await Promise.all([
      this.repo.findMany(where, (query.page - 1) * query.limit, query.limit, { dueDate: 'desc' }),
      this.repo.count(where),
    ]);

    return new PaginatedResponseDto(items.map(PaymentsMapper.toResponse), total, query.page, query.limit);
  }

  private async getOwnedOrThrow(id: string, user: AuthenticatedUser) {
    const payment = await this.repo.findById(id);
    if (!payment) throw new NotFoundException('Paiement introuvable.');

    if (user.roleName === RoleName.LOCATAIRE) {
      const tenant = await this.prisma.tenant.findFirst({ where: { id: payment.lease?.tenant?.id } });
      if (!tenant || tenant.userId !== user.id) {
        throw new ForbiddenException("Vous n'avez pas accès à ce paiement.");
      }
    }

    return payment;
  }
}
