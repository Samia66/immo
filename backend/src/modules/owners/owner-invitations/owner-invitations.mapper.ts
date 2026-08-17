import { OwnerInvitation } from '@prisma/client';

export class OwnerInvitationsMapper {
  static toResponse(invitation: OwnerInvitation, extra?: { shareMessage?: string }) {
    return {
      id: invitation.id,
      organizationId: invitation.organizationId,
      managerId: invitation.managerId,
      firstName: invitation.firstName,
      lastName: invitation.lastName,
      email: invitation.email,
      phone: invitation.phone,
      code: invitation.code,
      status: invitation.status,
      expiresAt: invitation.expiresAt,
      acceptedAt: invitation.acceptedAt,
      ownerId: invitation.ownerId,
      shareMessage: extra?.shareMessage,
      createdAt: invitation.createdAt,
    };
  }
}
