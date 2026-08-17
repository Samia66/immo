import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { RoleName } from '@prisma/client';
import { PrismaService } from '../../../prisma/prisma.service';
import { publicUrlFor } from '../../../common/utils/file-storage.util';
import { AuthenticatedUser } from '../../../common/interfaces';

@Injectable()
export class MaintenanceAttachmentsService {
  constructor(private readonly prisma: PrismaService) {}

  async addAttachments(
    requestId: string,
    phase: 'AVANT' | 'APRES',
    files: Express.Multer.File[],
    user: AuthenticatedUser,
  ) {
    const request = await this.prisma.maintenanceRequest.findFirst({
      where: { id: requestId, organizationId: user.organizationId },
      include: { tenant: { select: { userId: true } } },
    });
    if (!request) throw new NotFoundException('Demande de maintenance introuvable.');

    // LOCATAIRE just got `maintenance:manage_attachments` so tenants can attach
    // their own "avant" photos - without this check that permission would let
    // any tenant attach files to any request in the organization, not just
    // their own.
    if (user.roleName === RoleName.LOCATAIRE && request.tenant?.userId !== user.id) {
      throw new ForbiddenException("Vous ne pouvez pas modifier les photos d'une autre demande.");
    }

    const created = await this.prisma.$transaction(
      files.map((file) =>
        this.prisma.maintenanceAttachment.create({
          data: { requestId, url: publicUrlFor('maintenance', file.filename), phase },
        }),
      ),
    );

    return created.map((a) => ({ id: a.id, url: a.url, phase: a.phase, createdAt: a.createdAt }));
  }
}
