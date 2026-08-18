import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { Prisma, RoleName } from '@prisma/client';
import { ReceiptsRepository } from './receipts.repository';
import { ReceiptsMapper } from './receipts.mapper';
import { QueryReceiptDto } from './dto';
import { PaginatedResponseDto } from '../../common/dto';
import { AuthenticatedUser } from '../../common/interfaces';
import { generatePaymentReceiptPdf } from '../../common/utils/pdf-generator.util';

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

  /** Mirrors PaymentsService.receipt() - same PDF renderer, see pdf-generator.util.ts. */
  async download(id: string, user: AuthenticatedUser): Promise<Buffer> {
    const receipt = await this.getOwnedOrThrow(id, user);
    const payment = receipt.payment;
    return generatePaymentReceiptPdf({
      reference: receipt.id,
      organizationName: receipt.organization.name,
      tenantName: payment.lease.tenant.fullName,
      propertyTitle: payment.lease.propertyUnit.property.title,
      unitLabel: payment.lease.propertyUnit.label ?? payment.lease.propertyUnit.reference,
      amountDue: Number(payment.amountDue),
      amountPaid: Number(payment.amountPaid),
      dueDate: payment.dueDate,
      paidAt: payment.paidAt,
      method: payment.method,
      status: payment.status,
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
