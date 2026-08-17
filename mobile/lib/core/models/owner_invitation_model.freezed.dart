// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'owner_invitation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OwnerInvitationModel _$OwnerInvitationModelFromJson(Map<String, dynamic> json) {
  return _OwnerInvitationModel.fromJson(json);
}

/// @nodoc
mixin _$OwnerInvitationModel {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get managerId => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  OwnerInvitationStatus get status => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;
  DateTime? get acceptedAt => throw _privateConstructorUsedError;
  String? get ownerId => throw _privateConstructorUsedError;
  String? get shareMessage => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this OwnerInvitationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OwnerInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OwnerInvitationModelCopyWith<OwnerInvitationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OwnerInvitationModelCopyWith<$Res> {
  factory $OwnerInvitationModelCopyWith(
    OwnerInvitationModel value,
    $Res Function(OwnerInvitationModel) then,
  ) = _$OwnerInvitationModelCopyWithImpl<$Res, OwnerInvitationModel>;
  @useResult
  $Res call({
    String id,
    String organizationId,
    String managerId,
    String firstName,
    String lastName,
    String? email,
    String? phone,
    String code,
    OwnerInvitationStatus status,
    DateTime expiresAt,
    DateTime? acceptedAt,
    String? ownerId,
    String? shareMessage,
    DateTime createdAt,
  });
}

/// @nodoc
class _$OwnerInvitationModelCopyWithImpl<
  $Res,
  $Val extends OwnerInvitationModel
>
    implements $OwnerInvitationModelCopyWith<$Res> {
  _$OwnerInvitationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OwnerInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? managerId = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? code = null,
    Object? status = null,
    Object? expiresAt = null,
    Object? acceptedAt = freezed,
    Object? ownerId = freezed,
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
            managerId: null == managerId
                ? _value.managerId
                : managerId // ignore: cast_nullable_to_non_nullable
                      as String,
            firstName: null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String,
            lastName: null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as OwnerInvitationStatus,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            acceptedAt: freezed == acceptedAt
                ? _value.acceptedAt
                : acceptedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            ownerId: freezed == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$OwnerInvitationModelImplCopyWith<$Res>
    implements $OwnerInvitationModelCopyWith<$Res> {
  factory _$$OwnerInvitationModelImplCopyWith(
    _$OwnerInvitationModelImpl value,
    $Res Function(_$OwnerInvitationModelImpl) then,
  ) = __$$OwnerInvitationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String organizationId,
    String managerId,
    String firstName,
    String lastName,
    String? email,
    String? phone,
    String code,
    OwnerInvitationStatus status,
    DateTime expiresAt,
    DateTime? acceptedAt,
    String? ownerId,
    String? shareMessage,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$OwnerInvitationModelImplCopyWithImpl<$Res>
    extends _$OwnerInvitationModelCopyWithImpl<$Res, _$OwnerInvitationModelImpl>
    implements _$$OwnerInvitationModelImplCopyWith<$Res> {
  __$$OwnerInvitationModelImplCopyWithImpl(
    _$OwnerInvitationModelImpl _value,
    $Res Function(_$OwnerInvitationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OwnerInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? managerId = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? code = null,
    Object? status = null,
    Object? expiresAt = null,
    Object? acceptedAt = freezed,
    Object? ownerId = freezed,
    Object? shareMessage = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$OwnerInvitationModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        organizationId: null == organizationId
            ? _value.organizationId
            : organizationId // ignore: cast_nullable_to_non_nullable
                  as String,
        managerId: null == managerId
            ? _value.managerId
            : managerId // ignore: cast_nullable_to_non_nullable
                  as String,
        firstName: null == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String,
        lastName: null == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as OwnerInvitationStatus,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        acceptedAt: freezed == acceptedAt
            ? _value.acceptedAt
            : acceptedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        ownerId: freezed == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$OwnerInvitationModelImpl implements _OwnerInvitationModel {
  const _$OwnerInvitationModelImpl({
    required this.id,
    required this.organizationId,
    required this.managerId,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    required this.code,
    required this.status,
    required this.expiresAt,
    this.acceptedAt,
    this.ownerId,
    this.shareMessage,
    required this.createdAt,
  });

  factory _$OwnerInvitationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OwnerInvitationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String organizationId;
  @override
  final String managerId;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String code;
  @override
  final OwnerInvitationStatus status;
  @override
  final DateTime expiresAt;
  @override
  final DateTime? acceptedAt;
  @override
  final String? ownerId;
  @override
  final String? shareMessage;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'OwnerInvitationModel(id: $id, organizationId: $organizationId, managerId: $managerId, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, code: $code, status: $status, expiresAt: $expiresAt, acceptedAt: $acceptedAt, ownerId: $ownerId, shareMessage: $shareMessage, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OwnerInvitationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.managerId, managerId) ||
                other.managerId == managerId) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
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
    managerId,
    firstName,
    lastName,
    email,
    phone,
    code,
    status,
    expiresAt,
    acceptedAt,
    ownerId,
    shareMessage,
    createdAt,
  );

  /// Create a copy of OwnerInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OwnerInvitationModelImplCopyWith<_$OwnerInvitationModelImpl>
  get copyWith =>
      __$$OwnerInvitationModelImplCopyWithImpl<_$OwnerInvitationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OwnerInvitationModelImplToJson(this);
  }
}

abstract class _OwnerInvitationModel implements OwnerInvitationModel {
  const factory _OwnerInvitationModel({
    required final String id,
    required final String organizationId,
    required final String managerId,
    required final String firstName,
    required final String lastName,
    final String? email,
    final String? phone,
    required final String code,
    required final OwnerInvitationStatus status,
    required final DateTime expiresAt,
    final DateTime? acceptedAt,
    final String? ownerId,
    final String? shareMessage,
    required final DateTime createdAt,
  }) = _$OwnerInvitationModelImpl;

  factory _OwnerInvitationModel.fromJson(Map<String, dynamic> json) =
      _$OwnerInvitationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get managerId;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String get code;
  @override
  OwnerInvitationStatus get status;
  @override
  DateTime get expiresAt;
  @override
  DateTime? get acceptedAt;
  @override
  String? get ownerId;
  @override
  String? get shareMessage;
  @override
  DateTime get createdAt;

  /// Create a copy of OwnerInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OwnerInvitationModelImplCopyWith<_$OwnerInvitationModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

OwnerInvitationPreviewModel _$OwnerInvitationPreviewModelFromJson(
  Map<String, dynamic> json,
) {
  return _OwnerInvitationPreviewModel.fromJson(json);
}

/// @nodoc
mixin _$OwnerInvitationPreviewModel {
  String get managerFirstName => throw _privateConstructorUsedError;
  String get managerLastName => throw _privateConstructorUsedError;
  String get organizationName => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this OwnerInvitationPreviewModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OwnerInvitationPreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OwnerInvitationPreviewModelCopyWith<OwnerInvitationPreviewModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OwnerInvitationPreviewModelCopyWith<$Res> {
  factory $OwnerInvitationPreviewModelCopyWith(
    OwnerInvitationPreviewModel value,
    $Res Function(OwnerInvitationPreviewModel) then,
  ) =
      _$OwnerInvitationPreviewModelCopyWithImpl<
        $Res,
        OwnerInvitationPreviewModel
      >;
  @useResult
  $Res call({
    String managerFirstName,
    String managerLastName,
    String organizationName,
    DateTime expiresAt,
  });
}

/// @nodoc
class _$OwnerInvitationPreviewModelCopyWithImpl<
  $Res,
  $Val extends OwnerInvitationPreviewModel
>
    implements $OwnerInvitationPreviewModelCopyWith<$Res> {
  _$OwnerInvitationPreviewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OwnerInvitationPreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? managerFirstName = null,
    Object? managerLastName = null,
    Object? organizationName = null,
    Object? expiresAt = null,
  }) {
    return _then(
      _value.copyWith(
            managerFirstName: null == managerFirstName
                ? _value.managerFirstName
                : managerFirstName // ignore: cast_nullable_to_non_nullable
                      as String,
            managerLastName: null == managerLastName
                ? _value.managerLastName
                : managerLastName // ignore: cast_nullable_to_non_nullable
                      as String,
            organizationName: null == organizationName
                ? _value.organizationName
                : organizationName // ignore: cast_nullable_to_non_nullable
                      as String,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OwnerInvitationPreviewModelImplCopyWith<$Res>
    implements $OwnerInvitationPreviewModelCopyWith<$Res> {
  factory _$$OwnerInvitationPreviewModelImplCopyWith(
    _$OwnerInvitationPreviewModelImpl value,
    $Res Function(_$OwnerInvitationPreviewModelImpl) then,
  ) = __$$OwnerInvitationPreviewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String managerFirstName,
    String managerLastName,
    String organizationName,
    DateTime expiresAt,
  });
}

/// @nodoc
class __$$OwnerInvitationPreviewModelImplCopyWithImpl<$Res>
    extends
        _$OwnerInvitationPreviewModelCopyWithImpl<
          $Res,
          _$OwnerInvitationPreviewModelImpl
        >
    implements _$$OwnerInvitationPreviewModelImplCopyWith<$Res> {
  __$$OwnerInvitationPreviewModelImplCopyWithImpl(
    _$OwnerInvitationPreviewModelImpl _value,
    $Res Function(_$OwnerInvitationPreviewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OwnerInvitationPreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? managerFirstName = null,
    Object? managerLastName = null,
    Object? organizationName = null,
    Object? expiresAt = null,
  }) {
    return _then(
      _$OwnerInvitationPreviewModelImpl(
        managerFirstName: null == managerFirstName
            ? _value.managerFirstName
            : managerFirstName // ignore: cast_nullable_to_non_nullable
                  as String,
        managerLastName: null == managerLastName
            ? _value.managerLastName
            : managerLastName // ignore: cast_nullable_to_non_nullable
                  as String,
        organizationName: null == organizationName
            ? _value.organizationName
            : organizationName // ignore: cast_nullable_to_non_nullable
                  as String,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OwnerInvitationPreviewModelImpl
    implements _OwnerInvitationPreviewModel {
  const _$OwnerInvitationPreviewModelImpl({
    required this.managerFirstName,
    required this.managerLastName,
    required this.organizationName,
    required this.expiresAt,
  });

  factory _$OwnerInvitationPreviewModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$OwnerInvitationPreviewModelImplFromJson(json);

  @override
  final String managerFirstName;
  @override
  final String managerLastName;
  @override
  final String organizationName;
  @override
  final DateTime expiresAt;

  @override
  String toString() {
    return 'OwnerInvitationPreviewModel(managerFirstName: $managerFirstName, managerLastName: $managerLastName, organizationName: $organizationName, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OwnerInvitationPreviewModelImpl &&
            (identical(other.managerFirstName, managerFirstName) ||
                other.managerFirstName == managerFirstName) &&
            (identical(other.managerLastName, managerLastName) ||
                other.managerLastName == managerLastName) &&
            (identical(other.organizationName, organizationName) ||
                other.organizationName == organizationName) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    managerFirstName,
    managerLastName,
    organizationName,
    expiresAt,
  );

  /// Create a copy of OwnerInvitationPreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OwnerInvitationPreviewModelImplCopyWith<_$OwnerInvitationPreviewModelImpl>
  get copyWith =>
      __$$OwnerInvitationPreviewModelImplCopyWithImpl<
        _$OwnerInvitationPreviewModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OwnerInvitationPreviewModelImplToJson(this);
  }
}

abstract class _OwnerInvitationPreviewModel
    implements OwnerInvitationPreviewModel {
  const factory _OwnerInvitationPreviewModel({
    required final String managerFirstName,
    required final String managerLastName,
    required final String organizationName,
    required final DateTime expiresAt,
  }) = _$OwnerInvitationPreviewModelImpl;

  factory _OwnerInvitationPreviewModel.fromJson(Map<String, dynamic> json) =
      _$OwnerInvitationPreviewModelImpl.fromJson;

  @override
  String get managerFirstName;
  @override
  String get managerLastName;
  @override
  String get organizationName;
  @override
  DateTime get expiresAt;

  /// Create a copy of OwnerInvitationPreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OwnerInvitationPreviewModelImplCopyWith<_$OwnerInvitationPreviewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
