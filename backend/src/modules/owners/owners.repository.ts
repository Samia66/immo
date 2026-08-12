import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class OwnersRepository {
  constructor(private readonly prisma: PrismaService) {}

  findMany(where: Prisma.OwnerWhereInput, skip: number, take: number, orderBy: Prisma.OwnerOrderByWithRelationInput) {
    return this.prisma.owner.findMany({ where, skip, take, orderBy });
  }

  count(where: Prisma.OwnerWhereInput) {
    return this.prisma.owner.count({ where });
  }

  findById(id: string) {
    return this.prisma.owner.findUnique({ where: { id } });
  }

  create(data: Prisma.OwnerCreateInput) {
    return this.prisma.owner.create({ data });
  }

  update(id: string, data: Prisma.OwnerUpdateInput) {
    return this.prisma.owner.update({ where: { id }, data });
  }

  softDelete(id: string) {
    return this.prisma.owner.update({ where: { id }, data: { deletedAt: new Date() } });
  }
}
