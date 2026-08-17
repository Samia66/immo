import { Injectable } from '@nestjs/common';
import { PropertyStatus } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { addDays, addMonths, monthKey, startOfDay } from '../../common/utils/date-helpers.util';
import { getManagedOwnerIds, getManagedPropertyIds } from '../../common/utils/manager-scope.util';

const OPEN_MAINTENANCE_STATUSES = ['NOUVELLE', 'VALIDEE', 'ASSIGNEE', 'EN_COURS'] as const;
const ALL_PROPERTY_STATUSES: PropertyStatus[] = ['DISPONIBLE', 'OCCUPE', 'RESERVE', 'MAINTENANCE'];

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
      totalUnits,
      occupiedUnitsCount,
      unitStatusGroups,
      overdue,
      openMaintenanceCount,
      expiringLeases,
      openMaintenance,
      monthlyRevenueAgg,
    ] = await Promise.all([
      this.prisma.property.count({ where: { organizationId, deletedAt: null } }),
      this.prisma.propertyUnit.count({ where: { organizationId, deletedAt: null } }),
      this.prisma.propertyUnit.count({ where: { organizationId, deletedAt: null, status: 'OCCUPE' } }),
      this.prisma.propertyUnit.groupBy({
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
        include: { propertyUnit: { select: { label: true, reference: true, property: { select: { title: true } } } } },
        orderBy: { endDate: 'asc' },
        take: 5,
      }),
      this.prisma.maintenanceRequest.findMany({
        where: { organizationId, deletedAt: null, status: { in: [...OPEN_MAINTENANCE_STATUSES] } },
        include: { propertyUnit: { select: { label: true, reference: true, property: { select: { title: true } } } } },
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
        totalUnits,
        occupancyRate: totalUnits > 0 ? Math.round((occupiedUnitsCount / totalUnits) * 100) / 100 : 0,
        monthlyRevenue: Number(monthlyRevenueAgg._sum.amountPaid ?? 0),
        overduePaymentsCount: overdue.length,
        overduePaymentsAmount: overdue.reduce((sum, p) => sum + (Number(p.amountDue) - Number(p.amountPaid)), 0),
        openMaintenanceCount,
        expiringLeasesCount: expiringLeases.length,
      },
      revenueByMonth,
      unitsByStatus: unitStatusGroups.map((g) => ({ status: g.status, count: g._count._all })),
      expiringLeases: expiringLeases.map((l) => ({
        leaseId: l.id,
        unitLabel: l.propertyUnit.label ?? l.propertyUnit.reference,
        propertyTitle: l.propertyUnit.property.title,
        endDate: l.endDate,
      })),
      openMaintenance: openMaintenance.map((m) => ({
        id: m.id,
        unitLabel: m.propertyUnit.label ?? m.propertyUnit.reference,
        propertyTitle: m.propertyUnit.property.title,
        priority: m.priority,
        status: m.status,
      })),
    };
  }

  /**
   * GESTIONNAIRE view (spec §6): aggregates only across owners/properties/units under this
   * manager's ACTIVE ManagerOwner/PropertyManagement rows — mirrors ownerDashboard()'s query
   * style, just scoped by PropertyManagement.managerId instead of Owner.userId.
   */
  async managerDashboard(userId: string) {
    const emptyResponse = {
      ownersCount: 0,
      propertiesCount: 0,
      unitsCount: 0,
      unitsByStatus: ALL_PROPERTY_STATUSES.map((status) => ({ status, count: 0 })),
      expectedRent: 0,
      collectedRent: 0,
      pendingCount: 0,
      pendingAmount: 0,
      overdueCount: 0,
      overdueAmount: 0,
    };

    const [ownerIds, propertyIds] = await Promise.all([
      getManagedOwnerIds(this.prisma, userId),
      getManagedPropertyIds(this.prisma, userId),
    ]);

    if (propertyIds.length === 0) {
      return { ...emptyResponse, ownersCount: ownerIds.length };
    }

    const units = await this.prisma.propertyUnit.findMany({
      where: { propertyId: { in: propertyIds }, deletedAt: null },
      select: { id: true, status: true, monthlyRent: true },
    });
    const unitIds = units.map((u) => u.id);

    const countByStatus = new Map<PropertyStatus, number>();
    for (const u of units) countByStatus.set(u.status, (countByStatus.get(u.status) ?? 0) + 1);
    const unitsByStatus = ALL_PROPERTY_STATUSES.map((status) => ({ status, count: countByStatus.get(status) ?? 0 }));
    const expectedRent = units.filter((u) => u.status === 'OCCUPE').reduce((sum, u) => sum + Number(u.monthlyRent), 0);

    if (unitIds.length === 0) {
      return { ...emptyResponse, ownersCount: ownerIds.length, propertiesCount: propertyIds.length, unitsByStatus };
    }

    const now = new Date();
    const monthStart = new Date(now.getFullYear(), now.getMonth(), 1);
    const monthEnd = new Date(now.getFullYear(), now.getMonth() + 1, 0, 23, 59, 59, 999);

    const [monthlyRevenueAgg, pending, overdue] = await Promise.all([
      this.prisma.payment.aggregate({
        where: {
          lease: { propertyUnitId: { in: unitIds } },
          status: 'PAYE',
          paidAt: { gte: monthStart, lte: monthEnd },
          deletedAt: null,
        },
        _sum: { amountPaid: true },
      }),
      this.prisma.payment.findMany({
        where: {
          lease: { propertyUnitId: { in: unitIds } },
          status: { in: ['EN_ATTENTE', 'PARTIEL'] },
          deletedAt: null,
        },
      }),
      this.prisma.payment.findMany({
        where: { lease: { propertyUnitId: { in: unitIds } }, status: 'EN_RETARD', deletedAt: null },
      }),
    ]);

    return {
      ownersCount: ownerIds.length,
      propertiesCount: propertyIds.length,
      unitsCount: units.length,
      unitsByStatus,
      expectedRent,
      collectedRent: Number(monthlyRevenueAgg._sum.amountPaid ?? 0),
      pendingCount: pending.length,
      pendingAmount: pending.reduce((sum, p) => sum + (Number(p.amountDue) - Number(p.amountPaid)), 0),
      overdueCount: overdue.length,
      overdueAmount: overdue.reduce((sum, p) => sum + (Number(p.amountDue) - Number(p.amountPaid)), 0),
    };
  }

  async tenantDashboard(userId: string) {
    const tenant = await this.prisma.tenant.findFirst({ where: { userId } });
    if (!tenant) {
      return { activeLease: null, nextPayment: null, recentPayments: [] };
    }

    const activeLease = await this.prisma.lease.findFirst({
      where: { tenantId: tenant.id, status: 'ACTIF' },
      include: {
        propertyUnit: {
          select: {
            id: true,
            reference: true,
            label: true,
            property: { select: { id: true, title: true, reference: true, addressLine: true, city: true } },
          },
        },
      },
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
            propertyUnit: activeLease.propertyUnit,
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

  /** PROPRIETAIRE portal: occupancy + revenue KPIs scoped to the authenticated owner's own units. */
  async ownerDashboard(userId: string) {
    const emptyResponse = {
      totalUnits: 0,
      byStatus: ALL_PROPERTY_STATUSES.map((status) => ({ status, count: 0 })),
      monthlyRevenue: 0,
      pendingCount: 0,
      pendingAmount: 0,
      overdueCount: 0,
      overdueAmount: 0,
    };

    const owner = await this.prisma.owner.findFirst({ where: { userId } });
    if (!owner) return emptyResponse;

    const units = await this.prisma.propertyUnit.findMany({
      where: { property: { ownerId: owner.id, deletedAt: null }, deletedAt: null },
      select: { id: true, status: true },
    });
    const unitIds = units.map((u) => u.id);

    const countByStatus = new Map<PropertyStatus, number>();
    for (const u of units) countByStatus.set(u.status, (countByStatus.get(u.status) ?? 0) + 1);
    const byStatus = ALL_PROPERTY_STATUSES.map((status) => ({ status, count: countByStatus.get(status) ?? 0 }));

    if (unitIds.length === 0) {
      return { ...emptyResponse, byStatus };
    }

    const now = new Date();
    const monthStart = new Date(now.getFullYear(), now.getMonth(), 1);
    const monthEnd = new Date(now.getFullYear(), now.getMonth() + 1, 0, 23, 59, 59, 999);

    const [monthlyRevenueAgg, pending, overdue] = await Promise.all([
      this.prisma.payment.aggregate({
        where: {
          lease: { propertyUnitId: { in: unitIds } },
          status: 'PAYE',
          paidAt: { gte: monthStart, lte: monthEnd },
          deletedAt: null,
        },
        _sum: { amountPaid: true },
      }),
      this.prisma.payment.findMany({
        where: {
          lease: { propertyUnitId: { in: unitIds } },
          status: { in: ['EN_ATTENTE', 'PARTIEL'] },
          deletedAt: null,
        },
      }),
      this.prisma.payment.findMany({
        where: { lease: { propertyUnitId: { in: unitIds } }, status: 'EN_RETARD', deletedAt: null },
      }),
    ]);

    return {
      totalUnits: units.length,
      byStatus,
      monthlyRevenue: Number(monthlyRevenueAgg._sum.amountPaid ?? 0),
      pendingCount: pending.length,
      pendingAmount: pending.reduce((sum, p) => sum + (Number(p.amountDue) - Number(p.amountPaid)), 0),
      overdueCount: overdue.length,
      overdueAmount: overdue.reduce((sum, p) => sum + (Number(p.amountDue) - Number(p.amountPaid)), 0),
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
