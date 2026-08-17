import { Lease, LeaseDocument, LeaseAmendment, PropertyStatus } from '@prisma/client';

type LeaseWithRelations = Lease & {
  documents?: LeaseDocument[];
  amendments?: LeaseAmendment[];
  propertyUnit?: {
    id: string;
    reference: string;
    label: string | null;
    status: PropertyStatus;
    property: { id: string; title: string; reference: string; addressLine: string; city: string };
  } | null;
  tenant?: { id: string; fullName: string } | null;
};

export class LeasesMapper {
  static toResponse(lease: LeaseWithRelations) {
    return {
      id: lease.id,
      organizationId: lease.organizationId,
      reference: lease.reference,
      propertyUnitId: lease.propertyUnitId,
      propertyUnit: lease.propertyUnit,
      ownerId: lease.ownerId,
      managerId: lease.managerId,
      tenantId: lease.tenantId,
      tenant: lease.tenant,
      startDate: lease.startDate,
      endDate: lease.endDate,
      rentAmount: Number(lease.rentAmount),
      depositAmount: Number(lease.depositAmount),
      paymentFrequency: lease.paymentFrequency,
      rentDueDay: lease.rentDueDay,
      indexationRate: lease.indexationRate,
      status: lease.status,
      documents: lease.documents?.map((d) => ({ id: d.id, type: d.type, url: d.url, createdAt: d.createdAt })),
      amendments: lease.amendments?.map((a) => ({
        id: a.id,
        description: a.description,
        effectiveDate: a.effectiveDate,
        createdAt: a.createdAt,
      })),
      createdAt: lease.createdAt,
      updatedAt: lease.updatedAt,
    };
  }
}
