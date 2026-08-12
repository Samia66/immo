import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class VisitsRepository {
  constructor(private readonly prisma: PrismaService) {}

  findMany(where: Prisma.VisitWhereInput, skip: number, take: number, orderBy: Prisma.VisitOrderByWithRelationInput) {
    return this.prisma.visit.findMany({ where, skip, take, orderBy });
  }

  count(where: Prisma.VisitWhereInput) {
    return this.prisma.visit.count({ where });
  }

  findById(id: string) {
    return this.prisma.visit.findUnique({ where: { id } });
  }

  create(data: Prisma.VisitCreateInput) {
    return this.prisma.visit.create({ data });
  }

  update(id: string, data: Prisma.VisitUpdateInput) {
    return this.prisma.visit.update({ where: { id }, data });
  }
}
