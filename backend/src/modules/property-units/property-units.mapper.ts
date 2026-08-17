import { PropertyUnit } from '@prisma/client';

export interface UnitCurrentTenant {
  id: string;
  fullName: string;
  phone: string;
}

export class PropertyUnitsMapper {
  static toResponse(unit: PropertyUnit, extra?: { currentTenant?: UnitCurrentTenant | null }) {
    return {
      id: unit.id,
      organizationId: unit.organizationId,
      propertyId: unit.propertyId,
      reference: unit.reference,
      label: unit.label,
      floor: unit.floor,
      type: unit.type,
      rooms: unit.rooms,
      surfaceM2: unit.surfaceM2,
      monthlyRent: Number(unit.monthlyRent),
      monthlyCharges: unit.monthlyCharges != null ? Number(unit.monthlyCharges) : null,
      status: unit.status,
      description: unit.description,
      currentTenant: extra?.currentTenant ?? null,
      createdAt: unit.createdAt,
      updatedAt: unit.updatedAt,
    };
  }
}
