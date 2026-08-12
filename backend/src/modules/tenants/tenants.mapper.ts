import { Tenant, TenantDocument } from '@prisma/client';

type TenantWithDocs = Tenant & { documents?: TenantDocument[] };

export class TenantsMapper {
  static toResponse(tenant: TenantWithDocs) {
    return {
      id: tenant.id,
      organizationId: tenant.organizationId,
      userId: tenant.userId,
      fullName: tenant.fullName,
      phone: tenant.phone,
      email: tenant.email,
      profession: tenant.profession,
      employer: tenant.employer,
      monthlyIncome: tenant.monthlyIncome != null ? Number(tenant.monthlyIncome) : null,
      documents: tenant.documents?.map((d) => ({ id: d.id, type: d.type, url: d.url, createdAt: d.createdAt })),
      createdAt: tenant.createdAt,
      updatedAt: tenant.updatedAt,
    };
  }
}
