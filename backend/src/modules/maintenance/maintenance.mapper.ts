import { MaintenanceRequest, MaintenanceAttachment } from '@prisma/client';

type MaintenanceWithRelations = MaintenanceRequest & {
  attachments?: MaintenanceAttachment[];
  property?: { id: string; title: string; reference: string } | null;
  tenant?: { id: string; fullName: string } | null;
  assignedTo?: { id: string; firstName: string; lastName: string } | null;
};

export class MaintenanceMapper {
  static toResponse(request: MaintenanceWithRelations) {
    return {
      id: request.id,
      organizationId: request.organizationId,
      propertyId: request.propertyId,
      property: request.property,
      tenantId: request.tenantId,
      tenant: request.tenant,
      category: request.category,
      description: request.description,
      priority: request.priority,
      status: request.status,
      assignedToId: request.assignedToId,
      assignedTo: request.assignedTo,
      estimatedCost: request.estimatedCost != null ? Number(request.estimatedCost) : null,
      actualCost: request.actualCost != null ? Number(request.actualCost) : null,
      scheduledAt: request.scheduledAt,
      startedAt: request.startedAt,
      completedAt: request.completedAt,
      attachments: request.attachments?.map((a) => ({ id: a.id, url: a.url, phase: a.phase, createdAt: a.createdAt })),
      createdAt: request.createdAt,
      updatedAt: request.updatedAt,
    };
  }
}
