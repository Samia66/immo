// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OwnerPropertySummaryModelImpl _$$OwnerPropertySummaryModelImplFromJson(
  Map<String, dynamic> json,
) => _$OwnerPropertySummaryModelImpl(
  id: json['id'] as String,
  reference: json['reference'] as String,
  title: json['title'] as String,
  unitsCount: (json['unitsCount'] as num).toInt(),
);

Map<String, dynamic> _$$OwnerPropertySummaryModelImplToJson(
  _$OwnerPropertySummaryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'reference': instance.reference,
  'title': instance.title,
  'unitsCount': instance.unitsCount,
};

_$OwnerModelImpl _$$OwnerModelImplFromJson(Map<String, dynamic> json) =>
    _$OwnerModelImpl(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      address: json['address'] as String?,
      userId: json['userId'] as String?,
      propertiesCount: (json['propertiesCount'] as num?)?.toInt(),
      totalRevenue: json['totalRevenue'] as num?,
      properties: (json['properties'] as List<dynamic>?)
          ?.map(
            (e) =>
                OwnerPropertySummaryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$OwnerModelImplToJson(_$OwnerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'userId': instance.userId,
      'propertiesCount': instance.propertiesCount,
      'totalRevenue': instance.totalRevenue,
      'properties': instance.properties,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
