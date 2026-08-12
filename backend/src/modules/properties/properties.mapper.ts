import { Property, PropertyImage } from '@prisma/client';

type PropertyWithImages = Property & { images?: PropertyImage[] };

export class PropertiesMapper {
  static toResponse(property: PropertyWithImages) {
    return {
      id: property.id,
      organizationId: property.organizationId,
      reference: property.reference,
      title: property.title,
      description: property.description,
      type: property.type,
      status: property.status,
      addressLine: property.addressLine,
      city: property.city,
      district: property.district,
      latitude: property.latitude,
      longitude: property.longitude,
      rooms: property.rooms,
      surfaceM2: property.surfaceM2,
      monthlyRent: Number(property.monthlyRent),
      monthlyCharges: property.monthlyCharges != null ? Number(property.monthlyCharges) : null,
      ownerId: property.ownerId,
      images:
        property.images?.map((img) => ({ id: img.id, url: img.url, isCover: img.isCover, order: img.order })) ??
        undefined,
      createdAt: property.createdAt,
      updatedAt: property.updatedAt,
    };
  }
}
