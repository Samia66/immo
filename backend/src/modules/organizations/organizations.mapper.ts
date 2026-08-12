import { Organization } from '@prisma/client';

export class OrganizationsMapper {
  static toResponse(org: Organization) {
    return {
      id: org.id,
      name: org.name,
      code: org.code,
      address: org.address,
      phone: org.phone,
      email: org.email,
      subscriptionPlan: org.subscriptionPlan,
      isActive: org.isActive,
      createdAt: org.createdAt,
      updatedAt: org.updatedAt,
    };
  }
}
