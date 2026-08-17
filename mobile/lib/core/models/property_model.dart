import 'package:freezed_annotation/freezed_annotation.dart';

part 'property_model.freezed.dart';
part 'property_model.g.dart';

// ignore_for_file: constant_identifier_names

enum PropertyType { MAISON, APPARTEMENT, STUDIO, BUREAU, TERRAIN, BOUTIQUE }

enum PropertyStatus { DISPONIBLE, OCCUPE, RESERVE, MAINTENANCE }

extension PropertyTypeLabel on PropertyType {
  String get label => switch (this) {
        PropertyType.MAISON => 'Maison',
        PropertyType.APPARTEMENT => 'Appartement',
        PropertyType.STUDIO => 'Studio',
        PropertyType.BUREAU => 'Bureau',
        PropertyType.TERRAIN => 'Terrain',
        PropertyType.BOUTIQUE => 'Boutique',
      };
}

extension PropertyStatusLabel on PropertyStatus {
  String get label => switch (this) {
        PropertyStatus.DISPONIBLE => 'Disponible',
        PropertyStatus.OCCUPE => 'Occupé',
        PropertyStatus.RESERVE => 'Réservé',
        PropertyStatus.MAINTENANCE => 'Maintenance',
      };
}

@freezed
class PropertyImageModel with _$PropertyImageModel {
  const factory PropertyImageModel({
    required String id,
    required String url,
    required bool isCover,
    required int order,
  }) = _PropertyImageModel;

  factory PropertyImageModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyImageModelFromJson(json);
}

/// The tenant currently occupying a [PropertyUnitModel], as embedded by
/// `PropertyUnitsMapper.toResponse`'s `currentTenant` (only present/non-null
/// when the unit is OCCUPE and has an active lease).
@freezed
class PropertyUnitCurrentTenantModel with _$PropertyUnitCurrentTenantModel {
  const factory PropertyUnitCurrentTenantModel({
    required String id,
    required String fullName,
    String? phone,
  }) = _PropertyUnitCurrentTenantModel;

  factory PropertyUnitCurrentTenantModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyUnitCurrentTenantModelFromJson(json);
}

/// A single leasable unit within a [PropertyModel] "building". Carries all
/// the fields that used to live directly on Property (status, rent, rooms,
/// surface, ...) - see `PropertyUnitsMapper.toResponse` on the backend.
@freezed
class PropertyUnitModel with _$PropertyUnitModel {
  const factory PropertyUnitModel({
    required String id,
    required String organizationId,
    required String propertyId,
    required String reference,
    String? label,
    String? floor,
    required PropertyType type,
    int? rooms,
    double? surfaceM2,
    required num monthlyRent,
    num? monthlyCharges,
    required PropertyStatus status,
    String? description,
    PropertyUnitCurrentTenantModel? currentTenant,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PropertyUnitModel;

  factory PropertyUnitModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyUnitModelFromJson(json);
}

extension PropertyUnitModelX on PropertyUnitModel {
  /// Display label: falls back to the reference when no label is set.
  String get displayLabel => label ?? reference;
}

@freezed
class PropertyModel with _$PropertyModel {
  const factory PropertyModel({
    required String id,
    required String organizationId,
    required String reference,
    required String title,
    String? description,
    required PropertyType type,
    required String addressLine,
    required String city,
    String? district,
    double? latitude,
    double? longitude,
    required String ownerId,
    List<PropertyImageModel>? images,
    List<PropertyUnitModel>? units,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PropertyModel;

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);
}

extension PropertyModelX on PropertyModel {
  PropertyImageModel? get coverImage {
    final imgs = images;
    if (imgs == null || imgs.isEmpty) return null;
    return imgs.firstWhere((i) => i.isCover, orElse: () => imgs.first);
  }

  /// Lowest monthly rent among this property's units, or null if it has no
  /// units yet - used for a compact "à partir de ..." summary on list cards.
  num? get minMonthlyRent {
    final u = units;
    if (u == null || u.isEmpty) return null;
    return u.map((unit) => unit.monthlyRent).reduce((a, b) => a < b ? a : b);
  }

  int get availableUnitsCount =>
      units?.where((u) => u.status == PropertyStatus.DISPONIBLE).length ?? 0;
}
