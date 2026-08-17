// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lease_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LeasePropertySummaryModel _$LeasePropertySummaryModelFromJson(
  Map<String, dynamic> json,
) {
  return _LeasePropertySummaryModel.fromJson(json);
}

/// @nodoc
mixin _$LeasePropertySummaryModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  String get addressLine => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;

  /// Serializes this LeasePropertySummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeasePropertySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeasePropertySummaryModelCopyWith<LeasePropertySummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeasePropertySummaryModelCopyWith<$Res> {
  factory $LeasePropertySummaryModelCopyWith(
    LeasePropertySummaryModel value,
    $Res Function(LeasePropertySummaryModel) then,
  ) = _$LeasePropertySummaryModelCopyWithImpl<$Res, LeasePropertySummaryModel>;
  @useResult
  $Res call({
    String id,
    String title,
    String reference,
    String addressLine,
    String city,
  });
}

/// @nodoc
class _$LeasePropertySummaryModelCopyWithImpl<
  $Res,
  $Val extends LeasePropertySummaryModel
>
    implements $LeasePropertySummaryModelCopyWith<$Res> {
  _$LeasePropertySummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeasePropertySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? reference = null,
    Object? addressLine = null,
    Object? city = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            reference: null == reference
                ? _value.reference
                : reference // ignore: cast_nullable_to_non_nullable
                      as String,
            addressLine: null == addressLine
                ? _value.addressLine
                : addressLine // ignore: cast_nullable_to_non_nullable
                      as String,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LeasePropertySummaryModelImplCopyWith<$Res>
    implements $LeasePropertySummaryModelCopyWith<$Res> {
  factory _$$LeasePropertySummaryModelImplCopyWith(
    _$LeasePropertySummaryModelImpl value,
    $Res Function(_$LeasePropertySummaryModelImpl) then,
  ) = __$$LeasePropertySummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String reference,
    String addressLine,
    String city,
  });
}

/// @nodoc
class __$$LeasePropertySummaryModelImplCopyWithImpl<$Res>
    extends
        _$LeasePropertySummaryModelCopyWithImpl<
          $Res,
          _$LeasePropertySummaryModelImpl
        >
    implements _$$LeasePropertySummaryModelImplCopyWith<$Res> {
  __$$LeasePropertySummaryModelImplCopyWithImpl(
    _$LeasePropertySummaryModelImpl _value,
    $Res Function(_$LeasePropertySummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LeasePropertySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? reference = null,
    Object? addressLine = null,
    Object? city = null,
  }) {
    return _then(
      _$LeasePropertySummaryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        reference: null == reference
            ? _value.reference
            : reference // ignore: cast_nullable_to_non_nullable
                  as String,
        addressLine: null == addressLine
            ? _value.addressLine
            : addressLine // ignore: cast_nullable_to_non_nullable
                  as String,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LeasePropertySummaryModelImpl implements _LeasePropertySummaryModel {
  const _$LeasePropertySummaryModelImpl({
    required this.id,
    required this.title,
    required this.reference,
    required this.addressLine,
    required this.city,
  });

  factory _$LeasePropertySummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeasePropertySummaryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String reference;
  @override
  final String addressLine;
  @override
  final String city;

  @override
  String toString() {
    return 'LeasePropertySummaryModel(id: $id, title: $title, reference: $reference, addressLine: $addressLine, city: $city)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeasePropertySummaryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.addressLine, addressLine) ||
                other.addressLine == addressLine) &&
            (identical(other.city, city) || other.city == city));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, reference, addressLine, city);

  /// Create a copy of LeasePropertySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeasePropertySummaryModelImplCopyWith<_$LeasePropertySummaryModelImpl>
  get copyWith =>
      __$$LeasePropertySummaryModelImplCopyWithImpl<
        _$LeasePropertySummaryModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeasePropertySummaryModelImplToJson(this);
  }
}

abstract class _LeasePropertySummaryModel implements LeasePropertySummaryModel {
  const factory _LeasePropertySummaryModel({
    required final String id,
    required final String title,
    required final String reference,
    required final String addressLine,
    required final String city,
  }) = _$LeasePropertySummaryModelImpl;

  factory _LeasePropertySummaryModel.fromJson(Map<String, dynamic> json) =
      _$LeasePropertySummaryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get reference;
  @override
  String get addressLine;
  @override
  String get city;

  /// Create a copy of LeasePropertySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeasePropertySummaryModelImplCopyWith<_$LeasePropertySummaryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

PropertyUnitSummaryModel _$PropertyUnitSummaryModelFromJson(
  Map<String, dynamic> json,
) {
  return _PropertyUnitSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$PropertyUnitSummaryModel {
  String get id => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;
  PropertyStatus get status => throw _privateConstructorUsedError;
  LeasePropertySummaryModel get property => throw _privateConstructorUsedError;

  /// Serializes this PropertyUnitSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PropertyUnitSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PropertyUnitSummaryModelCopyWith<PropertyUnitSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertyUnitSummaryModelCopyWith<$Res> {
  factory $PropertyUnitSummaryModelCopyWith(
    PropertyUnitSummaryModel value,
    $Res Function(PropertyUnitSummaryModel) then,
  ) = _$PropertyUnitSummaryModelCopyWithImpl<$Res, PropertyUnitSummaryModel>;
  @useResult
  $Res call({
    String id,
    String reference,
    String? label,
    PropertyStatus status,
    LeasePropertySummaryModel property,
  });

  $LeasePropertySummaryModelCopyWith<$Res> get property;
}

/// @nodoc
class _$PropertyUnitSummaryModelCopyWithImpl<
  $Res,
  $Val extends PropertyUnitSummaryModel
>
    implements $PropertyUnitSummaryModelCopyWith<$Res> {
  _$PropertyUnitSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PropertyUnitSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reference = null,
    Object? label = freezed,
    Object? status = null,
    Object? property = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            reference: null == reference
                ? _value.reference
                : reference // ignore: cast_nullable_to_non_nullable
                      as String,
            label: freezed == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as PropertyStatus,
            property: null == property
                ? _value.property
                : property // ignore: cast_nullable_to_non_nullable
                      as LeasePropertySummaryModel,
          )
          as $Val,
    );
  }

  /// Create a copy of PropertyUnitSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LeasePropertySummaryModelCopyWith<$Res> get property {
    return $LeasePropertySummaryModelCopyWith<$Res>(_value.property, (value) {
      return _then(_value.copyWith(property: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PropertyUnitSummaryModelImplCopyWith<$Res>
    implements $PropertyUnitSummaryModelCopyWith<$Res> {
  factory _$$PropertyUnitSummaryModelImplCopyWith(
    _$PropertyUnitSummaryModelImpl value,
    $Res Function(_$PropertyUnitSummaryModelImpl) then,
  ) = __$$PropertyUnitSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String reference,
    String? label,
    PropertyStatus status,
    LeasePropertySummaryModel property,
  });

  @override
  $LeasePropertySummaryModelCopyWith<$Res> get property;
}

/// @nodoc
class __$$PropertyUnitSummaryModelImplCopyWithImpl<$Res>
    extends
        _$PropertyUnitSummaryModelCopyWithImpl<
          $Res,
          _$PropertyUnitSummaryModelImpl
        >
    implements _$$PropertyUnitSummaryModelImplCopyWith<$Res> {
  __$$PropertyUnitSummaryModelImplCopyWithImpl(
    _$PropertyUnitSummaryModelImpl _value,
    $Res Function(_$PropertyUnitSummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PropertyUnitSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reference = null,
    Object? label = freezed,
    Object? status = null,
    Object? property = null,
  }) {
    return _then(
      _$PropertyUnitSummaryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        reference: null == reference
            ? _value.reference
            : reference // ignore: cast_nullable_to_non_nullable
                  as String,
        label: freezed == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PropertyStatus,
        property: null == property
            ? _value.property
            : property // ignore: cast_nullable_to_non_nullable
                  as LeasePropertySummaryModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PropertyUnitSummaryModelImpl implements _PropertyUnitSummaryModel {
  const _$PropertyUnitSummaryModelImpl({
    required this.id,
    required this.reference,
    this.label,
    required this.status,
    required this.property,
  });

  factory _$PropertyUnitSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PropertyUnitSummaryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String reference;
  @override
  final String? label;
  @override
  final PropertyStatus status;
  @override
  final LeasePropertySummaryModel property;

  @override
  String toString() {
    return 'PropertyUnitSummaryModel(id: $id, reference: $reference, label: $label, status: $status, property: $property)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PropertyUnitSummaryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.property, property) ||
                other.property == property));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, reference, label, status, property);

  /// Create a copy of PropertyUnitSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PropertyUnitSummaryModelImplCopyWith<_$PropertyUnitSummaryModelImpl>
  get copyWith =>
      __$$PropertyUnitSummaryModelImplCopyWithImpl<
        _$PropertyUnitSummaryModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PropertyUnitSummaryModelImplToJson(this);
  }
}

abstract class _PropertyUnitSummaryModel implements PropertyUnitSummaryModel {
  const factory _PropertyUnitSummaryModel({
    required final String id,
    required final String reference,
    final String? label,
    required final PropertyStatus status,
    required final LeasePropertySummaryModel property,
  }) = _$PropertyUnitSummaryModelImpl;

  factory _PropertyUnitSummaryModel.fromJson(Map<String, dynamic> json) =
      _$PropertyUnitSummaryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get reference;
  @override
  String? get label;
  @override
  PropertyStatus get status;
  @override
  LeasePropertySummaryModel get property;

  /// Create a copy of PropertyUnitSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PropertyUnitSummaryModelImplCopyWith<_$PropertyUnitSummaryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

LeaseTenantSummaryModel _$LeaseTenantSummaryModelFromJson(
  Map<String, dynamic> json,
) {
  return _LeaseTenantSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$LeaseTenantSummaryModel {
  String get id => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;

  /// Serializes this LeaseTenantSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeaseTenantSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeaseTenantSummaryModelCopyWith<LeaseTenantSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaseTenantSummaryModelCopyWith<$Res> {
  factory $LeaseTenantSummaryModelCopyWith(
    LeaseTenantSummaryModel value,
    $Res Function(LeaseTenantSummaryModel) then,
  ) = _$LeaseTenantSummaryModelCopyWithImpl<$Res, LeaseTenantSummaryModel>;
  @useResult
  $Res call({String id, String fullName, String? userId});
}

/// @nodoc
class _$LeaseTenantSummaryModelCopyWithImpl<
  $Res,
  $Val extends LeaseTenantSummaryModel
>
    implements $LeaseTenantSummaryModelCopyWith<$Res> {
  _$LeaseTenantSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeaseTenantSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? userId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LeaseTenantSummaryModelImplCopyWith<$Res>
    implements $LeaseTenantSummaryModelCopyWith<$Res> {
  factory _$$LeaseTenantSummaryModelImplCopyWith(
    _$LeaseTenantSummaryModelImpl value,
    $Res Function(_$LeaseTenantSummaryModelImpl) then,
  ) = __$$LeaseTenantSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String fullName, String? userId});
}

/// @nodoc
class __$$LeaseTenantSummaryModelImplCopyWithImpl<$Res>
    extends
        _$LeaseTenantSummaryModelCopyWithImpl<
          $Res,
          _$LeaseTenantSummaryModelImpl
        >
    implements _$$LeaseTenantSummaryModelImplCopyWith<$Res> {
  __$$LeaseTenantSummaryModelImplCopyWithImpl(
    _$LeaseTenantSummaryModelImpl _value,
    $Res Function(_$LeaseTenantSummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LeaseTenantSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? userId = freezed,
  }) {
    return _then(
      _$LeaseTenantSummaryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LeaseTenantSummaryModelImpl implements _LeaseTenantSummaryModel {
  const _$LeaseTenantSummaryModelImpl({
    required this.id,
    required this.fullName,
    this.userId,
  });

  factory _$LeaseTenantSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaseTenantSummaryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String fullName;
  @override
  final String? userId;

  @override
  String toString() {
    return 'LeaseTenantSummaryModel(id: $id, fullName: $fullName, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaseTenantSummaryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, fullName, userId);

  /// Create a copy of LeaseTenantSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaseTenantSummaryModelImplCopyWith<_$LeaseTenantSummaryModelImpl>
  get copyWith =>
      __$$LeaseTenantSummaryModelImplCopyWithImpl<
        _$LeaseTenantSummaryModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaseTenantSummaryModelImplToJson(this);
  }
}

abstract class _LeaseTenantSummaryModel implements LeaseTenantSummaryModel {
  const factory _LeaseTenantSummaryModel({
    required final String id,
    required final String fullName,
    final String? userId,
  }) = _$LeaseTenantSummaryModelImpl;

  factory _LeaseTenantSummaryModel.fromJson(Map<String, dynamic> json) =
      _$LeaseTenantSummaryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get fullName;
  @override
  String? get userId;

  /// Create a copy of LeaseTenantSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaseTenantSummaryModelImplCopyWith<_$LeaseTenantSummaryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

LeaseModel _$LeaseModelFromJson(Map<String, dynamic> json) {
  return _LeaseModel.fromJson(json);
}

/// @nodoc
mixin _$LeaseModel {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  String get propertyUnitId => throw _privateConstructorUsedError;
  PropertyUnitSummaryModel? get propertyUnit =>
      throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get managerId => throw _privateConstructorUsedError;
  String get tenantId => throw _privateConstructorUsedError;
  LeaseTenantSummaryModel? get tenant => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  num get rentAmount => throw _privateConstructorUsedError;
  num get depositAmount => throw _privateConstructorUsedError;
  PaymentFrequency get paymentFrequency => throw _privateConstructorUsedError;
  int get rentDueDay => throw _privateConstructorUsedError;
  double? get indexationRate => throw _privateConstructorUsedError;
  LeaseStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this LeaseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeaseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeaseModelCopyWith<LeaseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaseModelCopyWith<$Res> {
  factory $LeaseModelCopyWith(
    LeaseModel value,
    $Res Function(LeaseModel) then,
  ) = _$LeaseModelCopyWithImpl<$Res, LeaseModel>;
  @useResult
  $Res call({
    String id,
    String organizationId,
    String reference,
    String propertyUnitId,
    PropertyUnitSummaryModel? propertyUnit,
    String ownerId,
    String managerId,
    String tenantId,
    LeaseTenantSummaryModel? tenant,
    DateTime startDate,
    DateTime? endDate,
    num rentAmount,
    num depositAmount,
    PaymentFrequency paymentFrequency,
    int rentDueDay,
    double? indexationRate,
    LeaseStatus status,
    DateTime createdAt,
    DateTime updatedAt,
  });

  $PropertyUnitSummaryModelCopyWith<$Res>? get propertyUnit;
  $LeaseTenantSummaryModelCopyWith<$Res>? get tenant;
}

/// @nodoc
class _$LeaseModelCopyWithImpl<$Res, $Val extends LeaseModel>
    implements $LeaseModelCopyWith<$Res> {
  _$LeaseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeaseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? reference = null,
    Object? propertyUnitId = null,
    Object? propertyUnit = freezed,
    Object? ownerId = null,
    Object? managerId = null,
    Object? tenantId = null,
    Object? tenant = freezed,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? rentAmount = null,
    Object? depositAmount = null,
    Object? paymentFrequency = null,
    Object? rentDueDay = null,
    Object? indexationRate = freezed,
    Object? status = null,
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
            reference: null == reference
                ? _value.reference
                : reference // ignore: cast_nullable_to_non_nullable
                      as String,
            propertyUnitId: null == propertyUnitId
                ? _value.propertyUnitId
                : propertyUnitId // ignore: cast_nullable_to_non_nullable
                      as String,
            propertyUnit: freezed == propertyUnit
                ? _value.propertyUnit
                : propertyUnit // ignore: cast_nullable_to_non_nullable
                      as PropertyUnitSummaryModel?,
            ownerId: null == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String,
            managerId: null == managerId
                ? _value.managerId
                : managerId // ignore: cast_nullable_to_non_nullable
                      as String,
            tenantId: null == tenantId
                ? _value.tenantId
                : tenantId // ignore: cast_nullable_to_non_nullable
                      as String,
            tenant: freezed == tenant
                ? _value.tenant
                : tenant // ignore: cast_nullable_to_non_nullable
                      as LeaseTenantSummaryModel?,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            rentAmount: null == rentAmount
                ? _value.rentAmount
                : rentAmount // ignore: cast_nullable_to_non_nullable
                      as num,
            depositAmount: null == depositAmount
                ? _value.depositAmount
                : depositAmount // ignore: cast_nullable_to_non_nullable
                      as num,
            paymentFrequency: null == paymentFrequency
                ? _value.paymentFrequency
                : paymentFrequency // ignore: cast_nullable_to_non_nullable
                      as PaymentFrequency,
            rentDueDay: null == rentDueDay
                ? _value.rentDueDay
                : rentDueDay // ignore: cast_nullable_to_non_nullable
                      as int,
            indexationRate: freezed == indexationRate
                ? _value.indexationRate
                : indexationRate // ignore: cast_nullable_to_non_nullable
                      as double?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as LeaseStatus,
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

  /// Create a copy of LeaseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PropertyUnitSummaryModelCopyWith<$Res>? get propertyUnit {
    if (_value.propertyUnit == null) {
      return null;
    }

    return $PropertyUnitSummaryModelCopyWith<$Res>(_value.propertyUnit!, (
      value,
    ) {
      return _then(_value.copyWith(propertyUnit: value) as $Val);
    });
  }

  /// Create a copy of LeaseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LeaseTenantSummaryModelCopyWith<$Res>? get tenant {
    if (_value.tenant == null) {
      return null;
    }

    return $LeaseTenantSummaryModelCopyWith<$Res>(_value.tenant!, (value) {
      return _then(_value.copyWith(tenant: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LeaseModelImplCopyWith<$Res>
    implements $LeaseModelCopyWith<$Res> {
  factory _$$LeaseModelImplCopyWith(
    _$LeaseModelImpl value,
    $Res Function(_$LeaseModelImpl) then,
  ) = __$$LeaseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String organizationId,
    String reference,
    String propertyUnitId,
    PropertyUnitSummaryModel? propertyUnit,
    String ownerId,
    String managerId,
    String tenantId,
    LeaseTenantSummaryModel? tenant,
    DateTime startDate,
    DateTime? endDate,
    num rentAmount,
    num depositAmount,
    PaymentFrequency paymentFrequency,
    int rentDueDay,
    double? indexationRate,
    LeaseStatus status,
    DateTime createdAt,
    DateTime updatedAt,
  });

  @override
  $PropertyUnitSummaryModelCopyWith<$Res>? get propertyUnit;
  @override
  $LeaseTenantSummaryModelCopyWith<$Res>? get tenant;
}

/// @nodoc
class __$$LeaseModelImplCopyWithImpl<$Res>
    extends _$LeaseModelCopyWithImpl<$Res, _$LeaseModelImpl>
    implements _$$LeaseModelImplCopyWith<$Res> {
  __$$LeaseModelImplCopyWithImpl(
    _$LeaseModelImpl _value,
    $Res Function(_$LeaseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LeaseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? reference = null,
    Object? propertyUnitId = null,
    Object? propertyUnit = freezed,
    Object? ownerId = null,
    Object? managerId = null,
    Object? tenantId = null,
    Object? tenant = freezed,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? rentAmount = null,
    Object? depositAmount = null,
    Object? paymentFrequency = null,
    Object? rentDueDay = null,
    Object? indexationRate = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$LeaseModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        organizationId: null == organizationId
            ? _value.organizationId
            : organizationId // ignore: cast_nullable_to_non_nullable
                  as String,
        reference: null == reference
            ? _value.reference
            : reference // ignore: cast_nullable_to_non_nullable
                  as String,
        propertyUnitId: null == propertyUnitId
            ? _value.propertyUnitId
            : propertyUnitId // ignore: cast_nullable_to_non_nullable
                  as String,
        propertyUnit: freezed == propertyUnit
            ? _value.propertyUnit
            : propertyUnit // ignore: cast_nullable_to_non_nullable
                  as PropertyUnitSummaryModel?,
        ownerId: null == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        managerId: null == managerId
            ? _value.managerId
            : managerId // ignore: cast_nullable_to_non_nullable
                  as String,
        tenantId: null == tenantId
            ? _value.tenantId
            : tenantId // ignore: cast_nullable_to_non_nullable
                  as String,
        tenant: freezed == tenant
            ? _value.tenant
            : tenant // ignore: cast_nullable_to_non_nullable
                  as LeaseTenantSummaryModel?,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        rentAmount: null == rentAmount
            ? _value.rentAmount
            : rentAmount // ignore: cast_nullable_to_non_nullable
                  as num,
        depositAmount: null == depositAmount
            ? _value.depositAmount
            : depositAmount // ignore: cast_nullable_to_non_nullable
                  as num,
        paymentFrequency: null == paymentFrequency
            ? _value.paymentFrequency
            : paymentFrequency // ignore: cast_nullable_to_non_nullable
                  as PaymentFrequency,
        rentDueDay: null == rentDueDay
            ? _value.rentDueDay
            : rentDueDay // ignore: cast_nullable_to_non_nullable
                  as int,
        indexationRate: freezed == indexationRate
            ? _value.indexationRate
            : indexationRate // ignore: cast_nullable_to_non_nullable
                  as double?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as LeaseStatus,
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
class _$LeaseModelImpl implements _LeaseModel {
  const _$LeaseModelImpl({
    required this.id,
    required this.organizationId,
    required this.reference,
    required this.propertyUnitId,
    this.propertyUnit,
    required this.ownerId,
    required this.managerId,
    required this.tenantId,
    this.tenant,
    required this.startDate,
    this.endDate,
    required this.rentAmount,
    required this.depositAmount,
    required this.paymentFrequency,
    this.rentDueDay = 5,
    this.indexationRate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$LeaseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaseModelImplFromJson(json);

  @override
  final String id;
  @override
  final String organizationId;
  @override
  final String reference;
  @override
  final String propertyUnitId;
  @override
  final PropertyUnitSummaryModel? propertyUnit;
  @override
  final String ownerId;
  @override
  final String managerId;
  @override
  final String tenantId;
  @override
  final LeaseTenantSummaryModel? tenant;
  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;
  @override
  final num rentAmount;
  @override
  final num depositAmount;
  @override
  final PaymentFrequency paymentFrequency;
  @override
  @JsonKey()
  final int rentDueDay;
  @override
  final double? indexationRate;
  @override
  final LeaseStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'LeaseModel(id: $id, organizationId: $organizationId, reference: $reference, propertyUnitId: $propertyUnitId, propertyUnit: $propertyUnit, ownerId: $ownerId, managerId: $managerId, tenantId: $tenantId, tenant: $tenant, startDate: $startDate, endDate: $endDate, rentAmount: $rentAmount, depositAmount: $depositAmount, paymentFrequency: $paymentFrequency, rentDueDay: $rentDueDay, indexationRate: $indexationRate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.propertyUnitId, propertyUnitId) ||
                other.propertyUnitId == propertyUnitId) &&
            (identical(other.propertyUnit, propertyUnit) ||
                other.propertyUnit == propertyUnit) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.managerId, managerId) ||
                other.managerId == managerId) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.tenant, tenant) || other.tenant == tenant) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.rentAmount, rentAmount) ||
                other.rentAmount == rentAmount) &&
            (identical(other.depositAmount, depositAmount) ||
                other.depositAmount == depositAmount) &&
            (identical(other.paymentFrequency, paymentFrequency) ||
                other.paymentFrequency == paymentFrequency) &&
            (identical(other.rentDueDay, rentDueDay) ||
                other.rentDueDay == rentDueDay) &&
            (identical(other.indexationRate, indexationRate) ||
                other.indexationRate == indexationRate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    organizationId,
    reference,
    propertyUnitId,
    propertyUnit,
    ownerId,
    managerId,
    tenantId,
    tenant,
    startDate,
    endDate,
    rentAmount,
    depositAmount,
    paymentFrequency,
    rentDueDay,
    indexationRate,
    status,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of LeaseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaseModelImplCopyWith<_$LeaseModelImpl> get copyWith =>
      __$$LeaseModelImplCopyWithImpl<_$LeaseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaseModelImplToJson(this);
  }
}

abstract class _LeaseModel implements LeaseModel {
  const factory _LeaseModel({
    required final String id,
    required final String organizationId,
    required final String reference,
    required final String propertyUnitId,
    final PropertyUnitSummaryModel? propertyUnit,
    required final String ownerId,
    required final String managerId,
    required final String tenantId,
    final LeaseTenantSummaryModel? tenant,
    required final DateTime startDate,
    final DateTime? endDate,
    required final num rentAmount,
    required final num depositAmount,
    required final PaymentFrequency paymentFrequency,
    final int rentDueDay,
    final double? indexationRate,
    required final LeaseStatus status,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$LeaseModelImpl;

  factory _LeaseModel.fromJson(Map<String, dynamic> json) =
      _$LeaseModelImpl.fromJson;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get reference;
  @override
  String get propertyUnitId;
  @override
  PropertyUnitSummaryModel? get propertyUnit;
  @override
  String get ownerId;
  @override
  String get managerId;
  @override
  String get tenantId;
  @override
  LeaseTenantSummaryModel? get tenant;
  @override
  DateTime get startDate;
  @override
  DateTime? get endDate;
  @override
  num get rentAmount;
  @override
  num get depositAmount;
  @override
  PaymentFrequency get paymentFrequency;
  @override
  int get rentDueDay;
  @override
  double? get indexationRate;
  @override
  LeaseStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of LeaseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaseModelImplCopyWith<_$LeaseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
