// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tenant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TenantModel _$TenantModelFromJson(Map<String, dynamic> json) {
  return _TenantModel.fromJson(json);
}

/// @nodoc
mixin _$TenantModel {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get profession => throw _privateConstructorUsedError;
  String? get employer => throw _privateConstructorUsedError;
  num? get monthlyIncome => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TenantModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TenantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TenantModelCopyWith<TenantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TenantModelCopyWith<$Res> {
  factory $TenantModelCopyWith(
    TenantModel value,
    $Res Function(TenantModel) then,
  ) = _$TenantModelCopyWithImpl<$Res, TenantModel>;
  @useResult
  $Res call({
    String id,
    String organizationId,
    String? userId,
    String fullName,
    String phone,
    String? email,
    String? profession,
    String? employer,
    num? monthlyIncome,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$TenantModelCopyWithImpl<$Res, $Val extends TenantModel>
    implements $TenantModelCopyWith<$Res> {
  _$TenantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TenantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? userId = freezed,
    Object? fullName = null,
    Object? phone = null,
    Object? email = freezed,
    Object? profession = freezed,
    Object? employer = freezed,
    Object? monthlyIncome = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
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
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String?,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            profession: freezed == profession
                ? _value.profession
                : profession // ignore: cast_nullable_to_non_nullable
                      as String?,
            employer: freezed == employer
                ? _value.employer
                : employer // ignore: cast_nullable_to_non_nullable
                      as String?,
            monthlyIncome: freezed == monthlyIncome
                ? _value.monthlyIncome
                : monthlyIncome // ignore: cast_nullable_to_non_nullable
                      as num?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TenantModelImplCopyWith<$Res>
    implements $TenantModelCopyWith<$Res> {
  factory _$$TenantModelImplCopyWith(
    _$TenantModelImpl value,
    $Res Function(_$TenantModelImpl) then,
  ) = __$$TenantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String organizationId,
    String? userId,
    String fullName,
    String phone,
    String? email,
    String? profession,
    String? employer,
    num? monthlyIncome,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$TenantModelImplCopyWithImpl<$Res>
    extends _$TenantModelCopyWithImpl<$Res, _$TenantModelImpl>
    implements _$$TenantModelImplCopyWith<$Res> {
  __$$TenantModelImplCopyWithImpl(
    _$TenantModelImpl _value,
    $Res Function(_$TenantModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TenantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? userId = freezed,
    Object? fullName = null,
    Object? phone = null,
    Object? email = freezed,
    Object? profession = freezed,
    Object? employer = freezed,
    Object? monthlyIncome = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$TenantModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        organizationId: null == organizationId
            ? _value.organizationId
            : organizationId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        profession: freezed == profession
            ? _value.profession
            : profession // ignore: cast_nullable_to_non_nullable
                  as String?,
        employer: freezed == employer
            ? _value.employer
            : employer // ignore: cast_nullable_to_non_nullable
                  as String?,
        monthlyIncome: freezed == monthlyIncome
            ? _value.monthlyIncome
            : monthlyIncome // ignore: cast_nullable_to_non_nullable
                  as num?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TenantModelImpl implements _TenantModel {
  const _$TenantModelImpl({
    required this.id,
    required this.organizationId,
    this.userId,
    required this.fullName,
    required this.phone,
    this.email,
    this.profession,
    this.employer,
    this.monthlyIncome,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$TenantModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TenantModelImplFromJson(json);

  @override
  final String id;
  @override
  final String organizationId;
  @override
  final String? userId;
  @override
  final String fullName;
  @override
  final String phone;
  @override
  final String? email;
  @override
  final String? profession;
  @override
  final String? employer;
  @override
  final num? monthlyIncome;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'TenantModel(id: $id, organizationId: $organizationId, userId: $userId, fullName: $fullName, phone: $phone, email: $email, profession: $profession, employer: $employer, monthlyIncome: $monthlyIncome, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TenantModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.profession, profession) ||
                other.profession == profession) &&
            (identical(other.employer, employer) ||
                other.employer == employer) &&
            (identical(other.monthlyIncome, monthlyIncome) ||
                other.monthlyIncome == monthlyIncome) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    organizationId,
    userId,
    fullName,
    phone,
    email,
    profession,
    employer,
    monthlyIncome,
    createdAt,
    updatedAt,
  );

  /// Create a copy of TenantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TenantModelImplCopyWith<_$TenantModelImpl> get copyWith =>
      __$$TenantModelImplCopyWithImpl<_$TenantModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TenantModelImplToJson(this);
  }
}

abstract class _TenantModel implements TenantModel {
  const factory _TenantModel({
    required final String id,
    required final String organizationId,
    final String? userId,
    required final String fullName,
    required final String phone,
    final String? email,
    final String? profession,
    final String? employer,
    final num? monthlyIncome,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$TenantModelImpl;

  factory _TenantModel.fromJson(Map<String, dynamic> json) =
      _$TenantModelImpl.fromJson;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String? get userId;
  @override
  String get fullName;
  @override
  String get phone;
  @override
  String? get email;
  @override
  String? get profession;
  @override
  String? get employer;
  @override
  num? get monthlyIncome;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of TenantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TenantModelImplCopyWith<_$TenantModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
