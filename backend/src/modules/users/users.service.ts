import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcrypt';
import { randomBytes } from 'crypto';
import { Prisma } from '@prisma/client';
import { UsersRepository } from './users.repository';
import { UsersMapper } from './users.mapper';
import { CreateUserDto, UpdateUserDto, UpdateUserRoleDto, QueryUserDto } from './dto';
import { PaginatedResponseDto } from '../../common/dto';
import { PrismaService } from '../../prisma/prisma.service';
import { AppConfig } from '../../config/configuration';
import { logStubEmail } from '../../common/utils/mailer.util';
import { publicUrlFor } from '../../common/utils/file-storage.util';

@Injectable()
export class UsersService {
  constructor(
    private readonly repo: UsersRepository,
    private readonly prisma: PrismaService,
    private readonly config: ConfigService<AppConfig, true>,
  ) {}

  async findAll(organizationId: string, query: QueryUserDto) {
    const where: Prisma.UserWhereInput = { organizationId, deletedAt: null };
    if (query.role) where.role = { name: query.role };
    if (query.isActive !== undefined) where.isActive = query.isActive === 'true';
    if (query.search) {
      where.OR = [
        { firstName: { contains: query.search, mode: 'insensitive' } },
        { lastName: { contains: query.search, mode: 'insensitive' } },
        { email: { contains: query.search, mode: 'insensitive' } },
      ];
    }

    const [items, total] = await Promise.all([
      this.repo.findMany(where, (query.page - 1) * query.limit, query.limit, {
        [query.sortBy ?? 'createdAt']: query.sortOrder ?? 'desc',
      }),
      this.repo.count(where),
    ]);

    return new PaginatedResponseDto(items.map(UsersMapper.toResponse), total, query.page, query.limit);
  }

  async findOne(id: string) {
    const user = await this.repo.findById(id);
    if (!user) throw new NotFoundException('Utilisateur introuvable.');
    return UsersMapper.toResponse(user);
  }

  async create(organizationId: string, dto: CreateUserDto) {
    const existing = await this.prisma.user.findFirst({
      where: { organizationId, email: dto.email.toLowerCase().trim() },
    });
    if (existing) throw new ConflictException('Un utilisateur avec cet email existe déjà dans cette organisation.');

    const role = await this.prisma.role.findFirst({ where: { id: dto.roleId, organizationId } });
    if (!role) throw new BadRequestException('Rôle invalide pour cette organisation.');

    const tempPassword = randomBytes(9).toString('base64url');
    const passwordHash = await bcrypt.hash(tempPassword, this.config.get('security.bcryptSaltRounds', { infer: true }));

    const user = await this.repo.create({
      organization: { connect: { id: organizationId } },
      email: dto.email.toLowerCase().trim(),
      firstName: dto.firstName,
      lastName: dto.lastName,
      phone: dto.phone,
      passwordHash,
      role: { connect: { id: role.id } },
    });

    logStubEmail(
      user.email,
      'Invitation à rejoindre la plateforme',
      `Un compte a été créé pour vous. Email: ${user.email} / Mot de passe temporaire: ${tempPassword}\nConnectez-vous puis changez votre mot de passe.`,
    );

    // Email delivery is a logged stub for now (see mailer.util.ts) rather than a real SMTP send,
    // so the temporary password has no other channel to reach the admin who just created the
    // account — surface it once, directly in the creation response, purely for this MVP dev
    // workflow. Never returned by any other endpoint (findAll/findOne/update all use the plain
    // mapper), and it stops being valid the moment a real mailer replaces logStubEmail.
    return { ...UsersMapper.toResponse(user), tempPassword };
  }

  async update(id: string, dto: UpdateUserDto) {
    await this.ensureExists(id);
    const user = await this.repo.update(id, dto);
    return UsersMapper.toResponse(user);
  }

  async updateRole(organizationId: string, id: string, dto: UpdateUserRoleDto) {
    await this.ensureExists(id);
    const role = await this.prisma.role.findFirst({ where: { id: dto.roleId, organizationId } });
    if (!role) throw new BadRequestException('Rôle invalide pour cette organisation.');
    const user = await this.repo.update(id, { role: { connect: { id: role.id } } });
    return UsersMapper.toResponse(user);
  }

  async toggleActive(id: string) {
    const user = await this.ensureExists(id);
    const updated = await this.repo.update(id, { isActive: !user.isActive });
    return UsersMapper.toResponse(updated);
  }

  async remove(id: string) {
    await this.ensureExists(id);
    const user = await this.repo.softDelete(id);
    return UsersMapper.toResponse(user);
  }

  async uploadAvatar(currentUserId: string, canManageOthers: boolean, targetId: string, file: Express.Multer.File) {
    if (targetId !== currentUserId && !canManageOthers) {
      throw new ForbiddenException('Vous ne pouvez modifier que votre propre avatar.');
    }
    await this.ensureExists(targetId);
    const url = publicUrlFor('avatars', file.filename);
    const user = await this.repo.update(targetId, { avatarUrl: url });
    return UsersMapper.toResponse(user);
  }

  private async ensureExists(id: string) {
    const user = await this.repo.findById(id);
    if (!user) throw new NotFoundException('Utilisateur introuvable.');
    return user;
  }
}
