import { Worker } from '@prisma/client';

export class WorkersMapper {
  static toResponse(worker: Worker) {
    return {
      id: worker.id,
      organizationId: worker.organizationId,
      fullName: worker.fullName,
      trade: worker.trade,
      phone: worker.phone,
      email: worker.email,
      notes: worker.notes,
      isActive: worker.isActive,
      propertyId: worker.propertyId,
      createdAt: worker.createdAt,
      updatedAt: worker.updatedAt,
    };
  }
}
