import { Visit } from '@prisma/client';

export class VisitsMapper {
  static toResponse(visit: Visit) {
    return {
      id: visit.id,
      organizationId: visit.organizationId,
      propertyId: visit.propertyId,
      agentId: visit.agentId,
      clientName: visit.clientName,
      clientPhone: visit.clientPhone,
      clientEmail: visit.clientEmail,
      scheduledAt: visit.scheduledAt,
      status: visit.status,
      notes: visit.notes,
      outcome: visit.outcome,
      createdAt: visit.createdAt,
      updatedAt: visit.updatedAt,
    };
  }
}
