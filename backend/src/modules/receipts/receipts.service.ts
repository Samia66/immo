import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { Prisma, RoleName } from '@prisma/client';
import { ReceiptsRepository } from './receipts.repository';
import { ReceiptsMapper } from './receipts.mapper';
import { QueryReceiptDto } from './dto';
import { PaginatedResponseDto } from '../../common/dto';
import { AuthenticatedUser } from '../../common/interfaces';
import { generatePdfStub } from '../../common/utils/pdf-generator.util';

@Injectable()
export class ReceiptsService {
  constructor(private readonly repo: ReceiptsRepository) {}

  async findAll(organizationId: string, query: QueryReceiptDto) {
    const where: Prisma.ReceiptWhereInput = { organizationId };

    const [items, total] = await Promise.all([
      this.repo.findMany(where, (query.page - 1) * query.limit, query.limit, {
        [query.sortBy ?? 'generatedAt']: query.sortOrder ?? 'desc',
      }),
      this.repo.count(where),
    ]);

    return new PaginatedResponseDto(items.map(ReceiptsMapper.toResponse), total, query.page, query.limit);
  }

  /** Mirrors PaymentsService.receipt(): a logged/stubbed PDF stand-in (see pdf-generator.util.ts). */
  async download(id: string, user: AuthenticatedUser) {
    const receipt = await this.getOwnedOrThrow(id, user);
    return generatePdfStub('payment-receipt', {
      receiptId: receipt.id,
      paymentId: receipt.paymentId,
      period: receipt.period,
      amount: Number(receipt.amount),
      lease: receipt.payment?.lease,
      generatedAt: receipt.generatedAt,
    });
  }

  private async getOwnedOrThrow(id: string, user: AuthenticatedUser) {
    const receipt = await this.repo.findById(id);
    if (!receipt) throw new NotFoundException('Quittance introuvable.');

    if (user.roleName === RoleName.LOCATAIRE) {
      const tenantUserId = receipt.payment?.lease?.tenant?.userId;
      if (!tenantUserId || tenantUserId !== user.id) {
        throw new ForbiddenException("Vous n'avez pas accès à cette quittance.");
      }
    }

    return receipt;
  }
}
