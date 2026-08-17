import { Injectable, Logger } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { PrismaService } from '../../prisma/prisma.service';
import { NotificationsService } from './notifications.service';
import {
  addDays,
  addMonthsSnapToDay,
  endOfDay,
  frequencyToMonths,
  startOfDay,
} from '../../common/utils/date-helpers.util';

/**
 * Platform-wide scheduled jobs (spec §8.5). These run OUTSIDE any HTTP request, so no
 * AsyncLocalStorage tenant context is set — PrismaService's tenant middleware is therefore a
 * deliberate no-op here (see prisma.service.ts), and every query below filters explicitly by
 * organizationId/relations instead of relying on it.
 */
@Injectable()
export class NotificationsScheduler {
  private readonly logger = new Logger(NotificationsScheduler.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly notifications: NotificationsService,
  ) {}

  /** Rappels loyers à J-2 — quotidien 08:00 */
  @Cron('0 8 * * *')
  async rentReminderJob() {
    const target = addDays(new Date(), 2);
    const payments = await this.prisma.payment.findMany({
      where: { status: 'EN_ATTENTE', dueDate: { gte: startOfDay(target), lte: endOfDay(target) } },
      include: { lease: { include: { tenant: true } } },
    });

    for (const payment of payments) {
      if (!payment.lease.tenant.userId) continue;
      await this.notifications.notify({
        organizationId: payment.organizationId,
        userId: payment.lease.tenant.userId,
        type: 'RAPPEL_LOYER',
        title: 'Rappel de loyer',
        message: `Votre loyer de ${payment.amountDue} est à régler avant le ${payment.dueDate.toISOString().slice(0, 10)}.`,
      });
    }
    this.logger.log(`rentReminderJob: ${payments.length} rappel(s) envoyé(s).`);
  }

  /** Rappel le jour même de l'échéance, si le loyer n'est toujours pas payé — quotidien 08:15 */
  @Cron('15 8 * * *')
  async dueTodayReminderJob() {
    const today = new Date();
    const payments = await this.prisma.payment.findMany({
      where: { status: 'EN_ATTENTE', dueDate: { gte: startOfDay(today), lte: endOfDay(today) } },
      include: { lease: { include: { tenant: true } } },
    });

    for (const payment of payments) {
      if (!payment.lease.tenant.userId) continue;
      await this.notifications.notify({
        organizationId: payment.organizationId,
        userId: payment.lease.tenant.userId,
        type: 'RAPPEL_LOYER',
        title: "Loyer à régler aujourd'hui",
        message: `Votre loyer de ${payment.amountDue} est dû aujourd'hui.`,
      });
    }
    this.logger.log(`dueTodayReminderJob: ${payments.length} rappel(s) envoyé(s).`);
  }

  /** Marque EN_RETARD les paiements échus non payés — quotidien 09:00 */
  @Cron('0 9 * * *')
  async overduePaymentJob() {
    const overdue = await this.prisma.payment.findMany({
      where: { status: 'EN_ATTENTE', dueDate: { lt: startOfDay(new Date()) } },
      include: { lease: { include: { tenant: true, organization: true } } },
    });

    for (const payment of overdue) {
      await this.prisma.payment.update({ where: { id: payment.id }, data: { status: 'EN_RETARD' } });

      if (payment.lease.tenant.userId) {
        await this.notifications.notify({
          organizationId: payment.organizationId,
          userId: payment.lease.tenant.userId,
          type: 'RETARD_PAIEMENT',
          title: 'Paiement en retard',
          message: `Votre loyer dû le ${payment.dueDate.toISOString().slice(0, 10)} est désormais en retard.`,
        });
      }

      const managers = await this.prisma.user.findMany({
        where: {
          organizationId: payment.organizationId,
          isActive: true,
          role: { name: { in: ['ADMIN_AGENCE', 'GESTIONNAIRE'] } },
        },
      });
      for (const manager of managers) {
        await this.notifications.notify({
          organizationId: payment.organizationId,
          userId: manager.id,
          type: 'RETARD_PAIEMENT',
          title: 'Impayé détecté',
          message: `Un paiement du bail ${payment.leaseId} est en retard depuis le ${payment.dueDate.toISOString().slice(0, 10)}.`,
        });
      }
    }
    this.logger.log(`overduePaymentJob: ${overdue.length} paiement(s) marqué(s) EN_RETARD.`);
  }

  /** Alerte contrats expirant sous 30j — quotidien 08:30 */
  @Cron('30 8 * * *')
  async leaseExpirationJob() {
    const from = startOfDay(new Date());
    const to = endOfDay(addDays(from, 30));

    const leases = await this.prisma.lease.findMany({
      where: { status: 'ACTIF', endDate: { gte: from, lte: to } },
      include: { tenant: true },
    });

    for (const lease of leases) {
      if (lease.tenant.userId) {
        await this.notifications.notify({
          organizationId: lease.organizationId,
          userId: lease.tenant.userId,
          type: 'EXPIRATION_CONTRAT',
          title: 'Contrat arrivant à échéance',
          message: `Votre contrat expire le ${lease.endDate?.toISOString().slice(0, 10)}.`,
        });
      }

      const managers = await this.prisma.user.findMany({
        where: {
          organizationId: lease.organizationId,
          isActive: true,
          role: { name: { in: ['ADMIN_AGENCE', 'GESTIONNAIRE'] } },
        },
      });
      for (const manager of managers) {
        await this.notifications.notify({
          organizationId: lease.organizationId,
          userId: manager.id,
          type: 'EXPIRATION_CONTRAT',
          title: 'Contrat arrivant à échéance',
          message: `Le contrat ${lease.id} expire le ${lease.endDate?.toISOString().slice(0, 10)}.`,
        });
      }
    }
    this.logger.log(`leaseExpirationJob: ${leases.length} contrat(s) proche(s) de l'échéance.`);
  }

  /**
   * Flips ACTIF leases whose endDate has actually passed to EXPIRE and frees their unit back to
   * DISPONIBLE (mirrors `terminate()`'s unit flip, see leases.service.ts) — quotidien 08:45.
   */
  @Cron('45 8 * * *')
  async expireLeasesJob() {
    const overdue = await this.prisma.lease.findMany({
      where: { status: 'ACTIF', endDate: { lt: startOfDay(new Date()) } },
    });

    for (const lease of overdue) {
      await this.prisma.$transaction([
        this.prisma.lease.update({ where: { id: lease.id }, data: { status: 'EXPIRE' } }),
        this.prisma.propertyUnit.update({ where: { id: lease.propertyUnitId }, data: { status: 'DISPONIBLE' } }),
        this.prisma.leaseStatusHistory.create({
          data: { leaseId: lease.id, fromStatus: 'ACTIF', toStatus: 'EXPIRE', note: 'Expiration automatique (cron).' },
        }),
      ]);
    }
    this.logger.log(`expireLeasesJob: ${overdue.length} contrat(s) expiré(s).`);
  }

  /** Génère les échéances du mois pour chaque bail actif — 1er du mois 00:30 */
  @Cron('30 0 1 * *')
  async generateMonthlyPaymentsJob() {
    const activeLeases = await this.prisma.lease.findMany({
      where: { status: 'ACTIF' },
      include: { payments: { orderBy: { dueDate: 'desc' }, take: 1 } },
    });

    let created = 0;
    const now = new Date();
    const monthEnd = endOfDay(new Date(now.getFullYear(), now.getMonth() + 1, 0));

    for (const lease of activeLeases) {
      const lastPayment = lease.payments[0];
      const nextDueDate = lastPayment
        ? addMonthsSnapToDay(lastPayment.dueDate, frequencyToMonths(lease.paymentFrequency), lease.rentDueDay)
        : lease.startDate;

      if (nextDueDate > monthEnd) continue;

      const existing = lastPayment && lastPayment.dueDate.getTime() === nextDueDate.getTime() ? lastPayment : null;
      if (existing) continue;

      await this.prisma.payment.create({
        data: {
          organization: { connect: { id: lease.organizationId } },
          lease: { connect: { id: lease.id } },
          amountDue: lease.rentAmount,
          dueDate: nextDueDate,
          status: 'EN_ATTENTE',
        },
      });
      created += 1;
    }
    this.logger.log(`generateMonthlyPaymentsJob: ${created} échéance(s) générée(s).`);
  }

  /** Alerte admin sur demandes de maintenance non traitées > 48h — quotidien 10:00 */
  @Cron('0 10 * * *')
  async staleMaintenanceJob() {
    const threshold = addDays(new Date(), -2);
    const stale = await this.prisma.maintenanceRequest.findMany({
      where: { status: 'NOUVELLE', createdAt: { lt: threshold } },
    });

    for (const request of stale) {
      const managers = await this.prisma.user.findMany({
        where: {
          organizationId: request.organizationId,
          isActive: true,
          role: { name: { in: ['ADMIN_AGENCE', 'GESTIONNAIRE'] } },
        },
      });
      for (const manager of managers) {
        await this.notifications.notify({
          organizationId: request.organizationId,
          userId: manager.id,
          type: 'ALERTE_ADMIN',
          title: 'Demande de maintenance en attente',
          message: `La demande "${request.category}" (créée le ${request.createdAt.toISOString().slice(0, 10)}) n'a toujours pas été validée.`,
        });
      }
    }
    this.logger.log(`staleMaintenanceJob: ${stale.length} demande(s) en attente signalée(s).`);
  }
}
