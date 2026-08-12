import { Owner } from '@prisma/client';

export class OwnersMapper {
  static toResponse(owner: Owner, extra?: { propertiesCount?: number; totalRevenue?: number }) {
    return {
      id: owner.id,
      organizationId: owner.organizationId,
      fullName: owner.fullName,
      phone: owner.phone,
      email: owner.email,
      address: owner.address,
      idDocumentUrl: owner.idDocumentUrl,
      bankName: owner.bankName,
      bankAccountIban: owner.bankAccountIban,
      propertiesCount: extra?.propertiesCount,
      totalRevenue: extra?.totalRevenue,
      createdAt: owner.createdAt,
      updatedAt: owner.updatedAt,
    };
  }
}
