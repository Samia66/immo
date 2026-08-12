import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';
import { publicUrlFor } from '../../../common/utils/file-storage.util';

@Injectable()
export class PropertyImagesService {
  constructor(private readonly prisma: PrismaService) {}

  async addImages(propertyId: string, files: Express.Multer.File[]) {
    const property = await this.prisma.property.findUnique({ where: { id: propertyId }, include: { images: true } });
    if (!property) throw new NotFoundException('Bien introuvable.');

    const hasCover = property.images.some((img) => img.isCover);
    const nextOrder = property.images.length;

    const created = await this.prisma.$transaction(
      files.map((file, index) =>
        this.prisma.propertyImage.create({
          data: {
            propertyId,
            url: publicUrlFor('properties', file.filename),
            isCover: !hasCover && index === 0,
            order: nextOrder + index,
          },
        }),
      ),
    );

    return created.map((img) => ({ id: img.id, url: img.url, isCover: img.isCover, order: img.order }));
  }

  async removeImage(propertyId: string, imageId: string) {
    const image = await this.prisma.propertyImage.findFirst({ where: { id: imageId, propertyId } });
    if (!image) throw new NotFoundException('Image introuvable.');

    await this.prisma.propertyImage.delete({ where: { id: imageId } });

    if (image.isCover) {
      const next = await this.prisma.propertyImage.findFirst({ where: { propertyId }, orderBy: { order: 'asc' } });
      if (next) await this.prisma.propertyImage.update({ where: { id: next.id }, data: { isCover: true } });
    }

    return { success: true };
  }
}
