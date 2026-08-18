import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class WorkersRepository {
  constructor(private readonly prisma: PrismaService) {}

  findMany(where: Prisma.WorkerWhereInput, skip: number, take: number, orderBy: Prisma.WorkerOrderByWithRelationInput) {
    return this.prisma.worker.findMany({ where, skip, take, orderBy });
  }

  count(where: Prisma.WorkerWhereInput) {
    return this.prisma.worker.count({ where });
  }

  findById(id: string) {
    return this.prisma.worker.findUnique({ where: { id } });
  }

  create(data: Prisma.WorkerCreateInput) {
    return this.prisma.worker.create({ data });
  }

  update(id: string, data: Prisma.WorkerUpdateInput) {
    return this.prisma.worker.update({ where: { id }, data });
  }

  softDelete(id: string) {
    return this.prisma.worker.update({ where: { id }, data: { deletedAt: new Date() } });
  }
}
