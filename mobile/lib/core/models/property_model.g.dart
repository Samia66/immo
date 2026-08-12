// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PropertyImageModelImpl _$$PropertyImageModelImplFromJson(
  Map<String, dynamic> json,
) => _$PropertyImageModelImpl(
  id: json['id'] as String,
  url: json['url'] as String,
  isCover: json['isCover'] as bool,
  order: (json['order'] as num).toInt(),
);

Map<String, dynamic> _$$PropertyImageModelImplToJson(
  _$PropertyImageModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'url': instance.url,
  'isCover': instance.isCover,
  'order': instance.order,
};

_$PropertyModelImpl _$$PropertyModelImplFromJson(Map<String, dynamic> json) =>
    _$PropertyModelImpl(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      reference: json['reference'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: $enumDecode(_$PropertyTypeEnumMap, json['type']),
      status: $enumDecode(_$PropertyStatusEnumMap, json['status']),
      addressLine: json['addressLine'] as String,
      city: json['city'] as String,
      district: json['district'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      rooms: (json['rooms'] as num?)?.toInt(),
      surfaceM2: (json['surfaceM2'] as num?)?.toDouble(),
      monthlyRent: json['monthlyRent'] as num,
      monthlyCharges: json['monthlyCharges'] as num?,
      ownerId: json['ownerId'] as String,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => PropertyImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$PropertyModelImplToJson(_$PropertyModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'reference': instance.reference,
      'title': instance.title,
      'description': instance.description,
      'type': _$PropertyTypeEnumMap[instance.type]!,
      'status': _$PropertyStatusEnumMap[instance.status]!,
      'addressLine': instance.addressLine,
      'city': instance.city,
      'district': instance.district,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'rooms': instance.rooms,
      'surfaceM2': instance.surfaceM2,
      'monthlyRent': instance.monthlyRent,
      'monthlyCharges': instance.monthlyCharges,
      'ownerId': instance.ownerId,
      'images': instance.images,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$PropertyTypeEnumMap = {
  PropertyType.MAISON: 'MAISON',
  PropertyType.APPARTEMENT: 'APPARTEMENT',
  PropertyType.STUDIO: 'STUDIO',
  PropertyType.BUREAU: 'BUREAU',
  PropertyType.TERRAIN: 'TERRAIN',
  PropertyType.BOUTIQUE: 'BOUTIQUE',
};

const _$PropertyStatusEnumMap = {
  PropertyStatus.DISPONIBLE: 'DISPONIBLE',
  PropertyStatus.OCCUPE: 'OCCUPE',
  PropertyStatus.RESERVE: 'RESERVE',
  PropertyStatus.MAINTENANCE: 'MAINTENANCE',
};
