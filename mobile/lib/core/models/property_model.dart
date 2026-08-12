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

@freezed
class PropertyModel with _$PropertyModel {
  const factory PropertyModel({
    required String id,
    required String organizationId,
    required String reference,
    required String title,
    String? description,
    required PropertyType type,
    required PropertyStatus status,
    required String addressLine,
    required String city,
    String? district,
    double? latitude,
    double? longitude,
    int? rooms,
    double? surfaceM2,
    required num monthlyRent,
    num? monthlyCharges,
    required String ownerId,
    List<PropertyImageModel>? images,
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
}
