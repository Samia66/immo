import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { addDays, addMonths, monthKey, startOfDay } from '../../common/utils/date-helpers.util';

const OPEN_MAINTENANCE_STATUSES = ['NOUVELLE', 'VALIDEE', 'ASSIGNEE', 'EN_COURS'] as const;

@Injectable()
export class DashboardService {
  constructor(private readonly prisma: PrismaService) {}

  async adminDashboard(organizationId: string) {
    const now = new Date();
    const monthStart = new Date(now.getFullYear(), now.getMonth(), 1);
    const monthEnd = new Date(now.getFullYear(), now.getMonth() + 1, 0, 23, 59, 59, 999);
    const in30Days = addDays(now, 30);

    const [
      totalProperties,
      occupiedCount,
      statusGroups,
      overdue,
      openMaintenanceCount,
      expiringLeases,
      openMaintenance,
      monthlyRevenueAgg,
    ] = await Promise.all([
      this.prisma.property.count({ where: { organizationId, deletedAt: null } }),
      this.prisma.property.count({ where: { organizationId, deletedAt: null, status: 'OCCUPE' } }),
      this.prisma.property.groupBy({
        by: ['status'],
        where: { organizationId, deletedAt: null },
        _count: { _all: true },
      }),
      this.prisma.payment.findMany({ where: { organizationId, status: 'EN_RETARD', deletedAt: null } }),
      this.prisma.maintenanceRequest.count({
        where: { organizationId, deletedAt: null, status: { in: [...OPEN_MAINTENANCE_STATUSES] } },
      }),
      this.prisma.lease.findMany({
        where: { organizationId, status: 'ACTIF', endDate: { gte: startOfDay(now), lte: in30Days } },
        include: { property: { select: { title: true } } },
        orderBy: { endDate: 'asc' },
        take: 5,
      }),
      this.prisma.maintenanceRequest.findMany({
        where: { organizationId, deletedAt: null, status: { in: [...OPEN_MAINTENANCE_STATUSES] } },
        include: { property: { select: { title: true } } },
        orderBy: { createdAt: 'desc' },
        take: 5,
      }),
      this.prisma.payment.aggregate({
        where: { organizationId, paidAt: { gte: monthStart, lte: monthEnd }, deletedAt: null },
        _sum: { amountPaid: true },
      }),
    ]);

    const revenueByMonth = await this.revenueByMonth(organizationId, 12);

    return {
      kpis: {
        totalProperties,
        occupancyRate: totalProperties > 0 ? Math.round((occupiedCount / totalProperties) * 100) / 100 : 0,
        monthlyRevenue: Number(monthlyRevenueAgg._sum.amountPaid ?? 0),
        overduePaymentsCount: overdue.length,
        overduePaymentsAmount: overdue.reduce((sum, p) => sum + (Number(p.amountDue) - Number(p.amountPaid)), 0),
        openMaintenanceCount,
        expiringLeasesCount: expiringLeases.length,
      },
      revenueByMonth,
      propertiesByStatus: statusGroups.map((g) => ({ status: g.status, count: g._count._all })),
      expiringLeases: expiringLeases.map((l) => ({
        leaseId: l.id,
        propertyTitle: l.property.title,
        endDate: l.endDate,
      })),
      openMaintenance: openMaintenance.map((m) => ({
        id: m.id,
        propertyTitle: m.property.title,
        priority: m.priority,
        status: m.status,
      })),
    };
  }

  /** GESTIONNAIRE view: same operational KPIs as admin, financial figures scoped to what a manager needs day-to-day. */
  async managerDashboard(organizationId: string) {
    return this.adminDashboard(organizationId);
  }

  async tenantDashboard(userId: string) {
    const tenant = await this.prisma.tenant.findFirst({ where: { userId } });
    if (!tenant) {
      return { activeLease: null, nextPayment: null, recentPayments: [] };
    }

    const activeLease = await this.prisma.lease.findFirst({
      where: { tenantId: tenant.id, status: 'ACTIF' },
      include: { property: { select: { id: true, title: true, reference: true, addressLine: true, city: true } } },
    });

    const nextPayment = activeLease
      ? await this.prisma.payment.findFirst({
          where: { leaseId: activeLease.id, status: { in: ['EN_ATTENTE', 'EN_RETARD', 'PARTIEL'] } },
          orderBy: { dueDate: 'asc' },
        })
      : null;

    const recentPayments = activeLease
      ? await this.prisma.payment.findMany({
          where: { leaseId: activeLease.id },
          orderBy: { dueDate: 'desc' },
          take: 5,
        })
      : [];

    return {
      activeLease: activeLease
        ? {
            id: activeLease.id,
            property: activeLease.property,
            startDate: activeLease.startDate,
            endDate: activeLease.endDate,
            rentAmount: Number(activeLease.rentAmount),
          }
        : null,
      nextPayment: nextPayment
        ? {
            id: nextPayment.id,
            amountDue: Number(nextPayment.amountDue),
            amountPaid: Number(nextPayment.amountPaid),
            dueDate: nextPayment.dueDate,
            status: nextPayment.status,
          }
        : null,
      recentPayments: recentPayments.map((p) => ({
        id: p.id,
        amountDue: Number(p.amountDue),
        amountPaid: Number(p.amountPaid),
        dueDate: p.dueDate,
        status: p.status,
      })),
    };
  }

  async superAdminDashboard() {
    const [totalOrganizations, activeOrganizations, totalUsers, totalProperties, planGroups, revenueAgg] =
      await Promise.all([
        this.prisma.organization.count({ where: { deletedAt: null } }),
        this.prisma.organization.count({ where: { deletedAt: null, isActive: true } }),
        this.prisma.user.count({ where: { deletedAt: null } }),
        this.prisma.property.count({ where: { deletedAt: null } }),
        this.prisma.organization.groupBy({
          by: ['subscriptionPlan'],
          where: { deletedAt: null },
          _count: { _all: true },
        }),
        this.prisma.payment.aggregate({ where: { deletedAt: null }, _sum: { amountPaid: true } }),
      ]);

    return {
      kpis: {
        totalOrganizations,
        activeOrganizations,
        totalUsers,
        totalProperties,
        totalRevenueAllOrganizations: Number(revenueAgg._sum.amountPaid ?? 0),
      },
      organizationsByPlan: planGroups.map((g) => ({ plan: g.subscriptionPlan, count: g._count._all })),
    };
  }

  private async revenueByMonth(organizationId: string, months: number) {
    const now = new Date();
    const results: { month: string; amount: number }[] = [];

    for (let i = months - 1; i >= 0; i--) {
      const monthDate = addMonths(new Date(now.getFullYear(), now.getMonth(), 1), -i);
      const start = new Date(monthDate.getFullYear(), monthDate.getMonth(), 1);
      const end = new Date(monthDate.getFullYear(), monthDate.getMonth() + 1, 0, 23, 59, 59, 999);

      const agg = await this.prisma.payment.aggregate({
        where: { organizationId, paidAt: { gte: start, lte: end }, deletedAt: null },
        _sum: { amountPaid: true },
      });

      results.push({ month: monthKey(monthDate), amount: Number(agg._sum.amountPaid ?? 0) });
    }

    return results;
  }
}
