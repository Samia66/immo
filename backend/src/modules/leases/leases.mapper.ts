import { Lease, LeaseDocument, LeaseAmendment } from '@prisma/client';

type LeaseWithRelations = Lease & {
  documents?: LeaseDocument[];
  amendments?: LeaseAmendment[];
  property?: { id: string; title: string; reference: string } | null;
  tenant?: { id: string; fullName: string } | null;
};

export class LeasesMapper {
  static toResponse(lease: LeaseWithRelations) {
    return {
      id: lease.id,
      organizationId: lease.organizationId,
      propertyId: lease.propertyId,
      property: lease.property,
      ownerId: lease.ownerId,
      tenantId: lease.tenantId,
      tenant: lease.tenant,
      startDate: lease.startDate,
      endDate: lease.endDate,
      rentAmount: Number(lease.rentAmount),
      depositAmount: Number(lease.depositAmount),
      paymentFrequency: lease.paymentFrequency,
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
