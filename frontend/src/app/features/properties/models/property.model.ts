import { PaginationQuery } from '../../../core/models';
import { PropertyStatus, PropertyType } from '../../../core/models/enums';

export interface PropertyImage {
  id: string;
  propertyId: string;
  url: string;
  isCover: boolean;
  order: number;
  createdAt: string;
}

export interface PropertyOwnerSummary {
  id: string;
  fullName: string;
  phone: string;
}

export interface Property {
  id: string;
  organizationId: string;
  reference: string;
  title: string;
  description?: string | null;
  type: PropertyType;
  status: PropertyStatus;
  addressLine: string;
  city: string;
  district?: string | null;
  latitude?: number | null;
  longitude?: number | null;
  rooms?: number | null;
  surfaceM2?: number | null;
  monthlyRent: number;
  monthlyCharges?: number | null;
  ownerId: string;
  owner?: PropertyOwnerSummary;
  images?: PropertyImage[];
  createdAt: string;
  updatedAt: string;
}

export interface PropertyHistoryEntry {
  id: string;
  propertyId: string;
  changedById: string;
  field: string;
  oldValue?: string | null;
  newValue?: string | null;
  createdAt: string;
}

export interface CreatePropertyDto {
  title: string;
  description?: string;
  type: PropertyType;
  addressLine: string;
  city: string;
  district?: string;
  latitude?: number;
  longitude?: number;
  rooms?: number;
  surfaceM2?: number;
  monthlyRent: number;
  monthlyCharges?: number;
  ownerId: string;
}

export interface UpdatePropertyDto extends Partial<CreatePropertyDto> {
  status?: PropertyStatus;
}

export interface PropertyFilters {
  type?: PropertyType;
  status?: PropertyStatus;
  city?: string;
  minRent?: number;
  maxRent?: number;
  search?: string;
}

export type PropertyQuery = PaginationQuery & PropertyFilters;
