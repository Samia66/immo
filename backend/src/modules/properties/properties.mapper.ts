import { Property, PropertyImage, PropertyUnit } from '@prisma/client';
import { PropertyUnitsMapper } from '../property-units/property-units.mapper';

type PropertyWithRelations = Property & { images?: PropertyImage[]; units?: PropertyUnit[] };

type MappedUnit = ReturnType<typeof PropertyUnitsMapper.toResponse>;

export class PropertiesMapper {
  static toResponse(property: PropertyWithRelations, extra?: { units?: MappedUnit[] }) {
    return {
      id: property.id,
      organizationId: property.organizationId,
      reference: property.reference,
      title: property.title,
      description: property.description,
      type: property.type,
      addressLine: property.addressLine,
      city: property.city,
      district: property.district,
      latitude: property.latitude,
      longitude: property.longitude,
      ownerId: property.ownerId,
      images:
        property.images?.map((img) => ({ id: img.id, url: img.url, isCover: img.isCover, order: img.order })) ??
        undefined,
      units: extra?.units ?? property.units?.map((u) => PropertyUnitsMapper.toResponse(u)) ?? undefined,
      createdAt: property.createdAt,
      updatedAt: property.updatedAt,
    };
  }
}
