import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

const includeRole = { role: true } as const;

@Injectable()
export class UsersRepository {
  constructor(private readonly prisma: PrismaService) {}

  findMany(where: Prisma.UserWhereInput, skip: number, take: number, orderBy: Prisma.UserOrderByWithRelationInput) {
    return this.prisma.user.findMany({ where, skip, take, orderBy, include: includeRole });
  }

  count(where: Prisma.UserWhereInput) {
    return this.prisma.user.count({ where });
  }

  findById(id: string) {
    return this.prisma.user.findUnique({ where: { id }, include: includeRole });
  }

  findByEmail(email: string) {
    return this.prisma.user.findFirst({ where: { email } });
  }

  create(data: Prisma.UserCreateInput) {
    return this.prisma.user.create({ data, include: includeRole });
  }

  update(id: string, data: Prisma.UserUpdateInput) {
    return this.prisma.user.update({ where: { id }, data, include: includeRole });
  }

  softDelete(id: string) {
    return this.prisma.user.update({
      where: { id },
      data: { deletedAt: new Date(), isActive: false },
      include: includeRole,
    });
  }
}
