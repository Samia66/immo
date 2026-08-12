import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class OrganizationsRepository {
  constructor(private readonly prisma: PrismaService) {}

  findMany(
    where: Prisma.OrganizationWhereInput,
    skip: number,
    take: number,
    orderBy: Prisma.OrganizationOrderByWithRelationInput,
  ) {
    return this.prisma.organization.findMany({ where, skip, take, orderBy });
  }

  count(where: Prisma.OrganizationWhereInput) {
    return this.prisma.organization.count({ where });
  }

  findById(id: string) {
    return this.prisma.organization.findUnique({ where: { id } });
  }

  findByCode(code: string) {
    return this.prisma.organization.findUnique({ where: { code } });
  }

  create(data: Prisma.OrganizationCreateInput) {
    return this.prisma.organization.create({ data });
  }

  update(id: string, data: Prisma.OrganizationUpdateInput) {
    return this.prisma.organization.update({ where: { id }, data });
  }
}
