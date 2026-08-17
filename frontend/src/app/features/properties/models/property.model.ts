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

export interface PropertyUnitCurrentTenant {
  id: string;
  fullName: string;
  phone: string;
}

/** A single rentable unit within a `Property` — carries all the rental-specific data. */
export interface PropertyUnit {
  id: string;
  organizationId: string;
  propertyId: string;
  reference: string;
  label?: string | null;
  floor?: string | null;
  type: PropertyType;
  rooms?: number | null;
  surfaceM2?: number | null;
  monthlyRent: number;
  monthlyCharges?: number | null;
  status: PropertyStatus;
  description?: string | null;
  currentTenant: PropertyUnitCurrentTenant | null;
  createdAt: string;
  updatedAt: string;
}

export interface CreatePropertyUnitDto {
  reference: string;
  label?: string;
  floor?: string;
  type: PropertyType;
  rooms?: number;
  surfaceM2?: number;
  monthlyRent: number;
  monthlyCharges?: number;
  description?: string;
}

export interface UpdatePropertyUnitDto extends Partial<CreatePropertyUnitDto> {
  status?: PropertyStatus;
}

export interface PropertyUnitFilters {
  type?: PropertyType;
  status?: PropertyStatus;
  minRent?: number;
  maxRent?: number;
  search?: string;
}

export type PropertyUnitQuery = PaginationQuery & PropertyUnitFilters;

/** `Property` is now just the building/listing container — rental details live on `PropertyUnit`. */
export interface Property {
  id: string;
  organizationId: string;
  reference: string;
  title: string;
  description?: string | null;
  type: PropertyType;
  addressLine: string;
  city: string;
  district?: string | null;
  latitude?: number | null;
  longitude?: number | null;
  ownerId: string;
  owner?: PropertyOwnerSummary;
  images?: PropertyImage[];
  units?: PropertyUnit[];
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
  ownerId: string;
}

export type UpdatePropertyDto = Partial<CreatePropertyDto>;

export interface PropertyFilters {
  type?: PropertyType;
  city?: string;
  search?: string;
  /** Only returns properties having at least one unit in this status (relational filter). */
  unitStatus?: PropertyStatus;
  /** Only returns properties having at least one unit with a rent >= this value. */
  minRent?: number;
  /** Only returns properties having at least one unit with a rent <= this value. */
  maxRent?: number;
}

export type PropertyQuery = PaginationQuery & PropertyFilters;
