import { TenantInvitation } from '@prisma/client';

export class TenantInvitationsMapper {
  static toResponse(invitation: TenantInvitation, extra: { shareMessage: string; leaseReference: string }) {
    return {
      id: invitation.id,
      organizationId: invitation.organizationId,
      leaseId: invitation.leaseId,
      leaseReference: extra.leaseReference,
      code: invitation.code,
      status: invitation.status,
      expiresAt: invitation.expiresAt,
      shareMessage: extra.shareMessage,
      createdAt: invitation.createdAt,
    };
  }
}
