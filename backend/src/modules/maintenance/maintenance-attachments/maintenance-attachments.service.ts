import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';
import { publicUrlFor } from '../../../common/utils/file-storage.util';

@Injectable()
export class MaintenanceAttachmentsService {
  constructor(private readonly prisma: PrismaService) {}

  async addAttachments(requestId: string, phase: 'AVANT' | 'APRES', files: Express.Multer.File[]) {
    const request = await this.prisma.maintenanceRequest.findUnique({ where: { id: requestId } });
    if (!request) throw new NotFoundException('Demande de maintenance introuvable.');

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
