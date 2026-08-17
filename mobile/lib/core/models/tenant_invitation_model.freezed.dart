// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tenant_invitation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TenantInvitationModel _$TenantInvitationModelFromJson(
  Map<String, dynamic> json,
) {
  return _TenantInvitationModel.fromJson(json);
}

/// @nodoc
mixin _$TenantInvitationModel {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get leaseId => throw _privateConstructorUsedError;
  String get leaseReference => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  TenantInvitationStatus get status => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;
  String? get shareMessage => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TenantInvitationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TenantInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TenantInvitationModelCopyWith<TenantInvitationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TenantInvitationModelCopyWith<$Res> {
  factory $TenantInvitationModelCopyWith(
    TenantInvitationModel value,
    $Res Function(TenantInvitationModel) then,
  ) = _$TenantInvitationModelCopyWithImpl<$Res, TenantInvitationModel>;
  @useResult
  $Res call({
    String id,
    String organizationId,
    String leaseId,
    String leaseReference,
    String code,
    TenantInvitationStatus status,
    DateTime expiresAt,
    String? shareMessage,
    DateTime createdAt,
  });
}

/// @nodoc
class _$TenantInvitationModelCopyWithImpl<
  $Res,
  $Val extends TenantInvitationModel
>
    implements $TenantInvitationModelCopyWith<$Res> {
  _$TenantInvitationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TenantInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? leaseId = null,
    Object? leaseReference = null,
    Object? code = null,
    Object? status = null,
    Object? expiresAt = null,
    Object? shareMessage = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            organizationId: null == organizationId
                ? _value.organizationId
                : organizationId // ignore: cast_nullable_to_non_nullable
                      as String,
            leaseId: null == leaseId
                ? _value.leaseId
                : leaseId // ignore: cast_nullable_to_non_nullable
                      as String,
            leaseReference: null == leaseReference
                ? _value.leaseReference
                : leaseReference // ignore: cast_nullable_to_non_nullable
                      as String,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TenantInvitationStatus,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            shareMessage: freezed == shareMessage
                ? _value.shareMessage
                : shareMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TenantInvitationModelImplCopyWith<$Res>
    implements $TenantInvitationModelCopyWith<$Res> {
  factory _$$TenantInvitationModelImplCopyWith(
    _$TenantInvitationModelImpl value,
    $Res Function(_$TenantInvitationModelImpl) then,
  ) = __$$TenantInvitationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String organizationId,
    String leaseId,
    String leaseReference,
    String code,
    TenantInvitationStatus status,
    DateTime expiresAt,
    String? shareMessage,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$TenantInvitationModelImplCopyWithImpl<$Res>
    extends
        _$TenantInvitationModelCopyWithImpl<$Res, _$TenantInvitationModelImpl>
    implements _$$TenantInvitationModelImplCopyWith<$Res> {
  __$$TenantInvitationModelImplCopyWithImpl(
    _$TenantInvitationModelImpl _value,
    $Res Function(_$TenantInvitationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TenantInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? leaseId = null,
    Object? leaseReference = null,
    Object? code = null,
    Object? status = null,
    Object? expiresAt = null,
    Object? shareMessage = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$TenantInvitationModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        organizationId: null == organizationId
            ? _value.organizationId
            : organizationId // ignore: cast_nullable_to_non_nullable
                  as String,
        leaseId: null == leaseId
            ? _value.leaseId
            : leaseId // ignore: cast_nullable_to_non_nullable
                  as String,
        leaseReference: null == leaseReference
            ? _value.leaseReference
            : leaseReference // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TenantInvitationStatus,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        shareMessage: freezed == shareMessage
            ? _value.shareMessage
            : shareMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TenantInvitationModelImpl implements _TenantInvitationModel {
  const _$TenantInvitationModelImpl({
    required this.id,
    required this.organizationId,
    required this.leaseId,
    required this.leaseReference,
    required this.code,
    required this.status,
    required this.expiresAt,
    this.shareMessage,
    required this.createdAt,
  });

  factory _$TenantInvitationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TenantInvitationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String organizationId;
  @override
  final String leaseId;
  @override
  final String leaseReference;
  @override
  final String code;
  @override
  final TenantInvitationStatus status;
  @override
  final DateTime expiresAt;
  @override
  final String? shareMessage;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'TenantInvitationModel(id: $id, organizationId: $organizationId, leaseId: $leaseId, leaseReference: $leaseReference, code: $code, status: $status, expiresAt: $expiresAt, shareMessage: $shareMessage, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TenantInvitationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.leaseId, leaseId) || other.leaseId == leaseId) &&
            (identical(other.leaseReference, leaseReference) ||
                other.leaseReference == leaseReference) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.shareMessage, shareMessage) ||
                other.shareMessage == shareMessage) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    organizationId,
    leaseId,
    leaseReference,
    code,
    status,
    expiresAt,
    shareMessage,
    createdAt,
  );

  /// Create a copy of TenantInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TenantInvitationModelImplCopyWith<_$TenantInvitationModelImpl>
  get copyWith =>
      __$$TenantInvitationModelImplCopyWithImpl<_$TenantInvitationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TenantInvitationModelImplToJson(this);
  }
}

abstract class _TenantInvitationModel implements TenantInvitationModel {
  const factory _TenantInvitationModel({
    required final String id,
    required final String organizationId,
    required final String leaseId,
    required final String leaseReference,
    required final String code,
    required final TenantInvitationStatus status,
    required final DateTime expiresAt,
    final String? shareMessage,
    required final DateTime createdAt,
  }) = _$TenantInvitationModelImpl;

  factory _TenantInvitationModel.fromJson(Map<String, dynamic> json) =
      _$TenantInvitationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get leaseId;
  @override
  String get leaseReference;
  @override
  String get code;
  @override
  TenantInvitationStatus get status;
  @override
  DateTime get expiresAt;
  @override
  String? get shareMessage;
  @override
  DateTime get createdAt;

  /// Create a copy of TenantInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TenantInvitationModelImplCopyWith<_$TenantInvitationModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
