// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TenantSummaryModelImpl _$$TenantSummaryModelImplFromJson(
  Map<String, dynamic> json,
) => _$TenantSummaryModelImpl(
  id: json['id'] as String,
  fullName: json['fullName'] as String,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$$TenantSummaryModelImplToJson(
  _$TenantSummaryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'phone': instance.phone,
};

_$MaintenancePropertySummaryModelImpl
_$$MaintenancePropertySummaryModelImplFromJson(Map<String, dynamic> json) =>
    _$MaintenancePropertySummaryModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      reference: json['reference'] as String,
      addressLine: json['addressLine'] as String?,
      city: json['city'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$MaintenancePropertySummaryModelImplToJson(
  _$MaintenancePropertySummaryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'reference': instance.reference,
  'addressLine': instance.addressLine,
  'city': instance.city,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};

_$MaintenanceAttachmentModelImpl _$$MaintenanceAttachmentModelImplFromJson(
  Map<String, dynamic> json,
) => _$MaintenanceAttachmentModelImpl(
  id: json['id'] as String,
  url: json['url'] as String,
  phase: json['phase'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$MaintenanceAttachmentModelImplToJson(
  _$MaintenanceAttachmentModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'url': instance.url,
  'phase': instance.phase,
  'createdAt': instance.createdAt.toIso8601String(),
};

_$MaintenanceRequestModelImpl _$$MaintenanceRequestModelImplFromJson(
  Map<String, dynamic> json,
) => _$MaintenanceRequestModelImpl(
  id: json['id'] as String,
  organizationId: json['organizationId'] as String,
  propertyId: json['propertyId'] as String,
  property: json['property'] == null
      ? null
      : MaintenancePropertySummaryModel.fromJson(
          json['property'] as Map<String, dynamic>,
        ),
  tenantId: json['tenantId'] as String?,
  tenant: json['tenant'] == null
      ? null
      : TenantSummaryModel.fromJson(json['tenant'] as Map<String, dynamic>),
  category: json['category'] as String,
  description: json['description'] as String,
  priority: $enumDecode(_$MaintenancePriorityEnumMap, json['priority']),
  status: $enumDecode(_$MaintenanceStatusEnumMap, json['status']),
  assignedToId: json['assignedToId'] as String?,
  estimatedCost: json['estimatedCost'] as num?,
  actualCost: json['actualCost'] as num?,
  scheduledAt: json['scheduledAt'] == null
      ? null
      : DateTime.parse(json['scheduledAt'] as String),
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  attachments: (json['attachments'] as List<dynamic>?)
      ?.map(
        (e) => MaintenanceAttachmentModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$MaintenanceRequestModelImplToJson(
  _$MaintenanceRequestModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'organizationId': instance.organizationId,
  'propertyId': instance.propertyId,
  'property': instance.property,
  'tenantId': instance.tenantId,
  'tenant': instance.tenant,
  'category': instance.category,
  'description': instance.description,
  'priority': _$MaintenancePriorityEnumMap[instance.priority]!,
  'status': _$MaintenanceStatusEnumMap[instance.status]!,
  'assignedToId': instance.assignedToId,
  'estimatedCost': instance.estimatedCost,
  'actualCost': instance.actualCost,
  'scheduledAt': instance.scheduledAt?.toIso8601String(),
  'startedAt': instance.startedAt?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'attachments': instance.attachments,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$MaintenancePriorityEnumMap = {
  MaintenancePriority.BASSE: 'BASSE',
  MaintenancePriority.NORMALE: 'NORMALE',
  MaintenancePriority.HAUTE: 'HAUTE',
  MaintenancePriority.URGENTE: 'URGENTE',
};

const _$MaintenanceStatusEnumMap = {
  MaintenanceStatus.NOUVELLE: 'NOUVELLE',
  MaintenanceStatus.VALIDEE: 'VALIDEE',
  MaintenanceStatus.ASSIGNEE: 'ASSIGNEE',
  MaintenanceStatus.EN_COURS: 'EN_COURS',
  MaintenanceStatus.TERMINEE: 'TERMINEE',
  MaintenanceStatus.CLOTUREE: 'CLOTUREE',
};
