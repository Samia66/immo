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

PropertySummaryModel _$PropertySummaryModelFromJson(Map<String, dynamic> json) {
  return _PropertySummaryModel.fromJson(json);
}

/// @nodoc
mixin _$PropertySummaryModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  String? get addressLine => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;

  /// Serializes this PropertySummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PropertySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PropertySummaryModelCopyWith<PropertySummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertySummaryModelCopyWith<$Res> {
  factory $PropertySummaryModelCopyWith(
    PropertySummaryModel value,
    $Res Function(PropertySummaryModel) then,
  ) = _$PropertySummaryModelCopyWithImpl<$Res, PropertySummaryModel>;
  @useResult
  $Res call({
    String id,
    String title,
    String reference,
    String? addressLine,
    String? city,
  });
}

/// @nodoc
class _$PropertySummaryModelCopyWithImpl<
  $Res,
  $Val extends PropertySummaryModel
>
    implements $PropertySummaryModelCopyWith<$Res> {
  _$PropertySummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PropertySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? reference = null,
    Object? addressLine = freezed,
    Object? city = freezed,
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
            addressLine: freezed == addressLine
                ? _value.addressLine
                : addressLine // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PropertySummaryModelImplCopyWith<$Res>
    implements $PropertySummaryModelCopyWith<$Res> {
  factory _$$PropertySummaryModelImplCopyWith(
    _$PropertySummaryModelImpl value,
    $Res Function(_$PropertySummaryModelImpl) then,
  ) = __$$PropertySummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String reference,
    String? addressLine,
    String? city,
  });
}

/// @nodoc
class __$$PropertySummaryModelImplCopyWithImpl<$Res>
    extends _$PropertySummaryModelCopyWithImpl<$Res, _$PropertySummaryModelImpl>
    implements _$$PropertySummaryModelImplCopyWith<$Res> {
  __$$PropertySummaryModelImplCopyWithImpl(
    _$PropertySummaryModelImpl _value,
    $Res Function(_$PropertySummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PropertySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? reference = null,
    Object? addressLine = freezed,
    Object? city = freezed,
  }) {
    return _then(
      _$PropertySummaryModelImpl(
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
        addressLine: freezed == addressLine
            ? _value.addressLine
            : addressLine // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PropertySummaryModelImpl implements _PropertySummaryModel {
  const _$PropertySummaryModelImpl({
    required this.id,
    required this.title,
    required this.reference,
    this.addressLine,
    this.city,
  });

  factory _$PropertySummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PropertySummaryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String reference;
  @override
  final String? addressLine;
  @override
  final String? city;

  @override
  String toString() {
    return 'PropertySummaryModel(id: $id, title: $title, reference: $reference, addressLine: $addressLine, city: $city)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PropertySummaryModelImpl &&
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

  /// Create a copy of PropertySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PropertySummaryModelImplCopyWith<_$PropertySummaryModelImpl>
  get copyWith =>
      __$$PropertySummaryModelImplCopyWithImpl<_$PropertySummaryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PropertySummaryModelImplToJson(this);
  }
}

abstract class _PropertySummaryModel implements PropertySummaryModel {
  const factory _PropertySummaryModel({
    required final String id,
    required final String title,
    required final String reference,
    final String? addressLine,
    final String? city,
  }) = _$PropertySummaryModelImpl;

  factory _PropertySummaryModel.fromJson(Map<String, dynamic> json) =
      _$PropertySummaryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get reference;
  @override
  String? get addressLine;
  @override
  String? get city;

  /// Create a copy of PropertySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PropertySummaryModelImplCopyWith<_$PropertySummaryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

LeaseModel _$LeaseModelFromJson(Map<String, dynamic> json) {
  return _LeaseModel.fromJson(json);
}

/// @nodoc
mixin _$LeaseModel {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get propertyId => throw _privateConstructorUsedError;
  PropertySummaryModel? get property => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get tenantId => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  num get rentAmount => throw _privateConstructorUsedError;
  num get depositAmount => throw _privateConstructorUsedError;
  PaymentFrequency get paymentFrequency => throw _privateConstructorUsedError;
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
    String propertyId,
    PropertySummaryModel? property,
    String ownerId,
    String tenantId,
    DateTime startDate,
    DateTime? endDate,
    num rentAmount,
    num depositAmount,
    PaymentFrequency paymentFrequency,
    double? indexationRate,
    LeaseStatus status,
    DateTime createdAt,
    DateTime updatedAt,
  });

  $PropertySummaryModelCopyWith<$Res>? get property;
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
    Object? propertyId = null,
    Object? property = freezed,
    Object? ownerId = null,
    Object? tenantId = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? rentAmount = null,
    Object? depositAmount = null,
    Object? paymentFrequency = null,
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
            propertyId: null == propertyId
                ? _value.propertyId
                : propertyId // ignore: cast_nullable_to_non_nullable
                      as String,
            property: freezed == property
                ? _value.property
                : property // ignore: cast_nullable_to_non_nullable
                      as PropertySummaryModel?,
            ownerId: null == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String,
            tenantId: null == tenantId
                ? _value.tenantId
                : tenantId // ignore: cast_nullable_to_non_nullable
                      as String,
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
  $PropertySummaryModelCopyWith<$Res>? get property {
    if (_value.property == null) {
      return null;
    }

    return $PropertySummaryModelCopyWith<$Res>(_value.property!, (value) {
      return _then(_value.copyWith(property: value) as $Val);
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
    String propertyId,
    PropertySummaryModel? property,
    String ownerId,
    String tenantId,
    DateTime startDate,
    DateTime? endDate,
    num rentAmount,
    num depositAmount,
    PaymentFrequency paymentFrequency,
    double? indexationRate,
    LeaseStatus status,
    DateTime createdAt,
    DateTime updatedAt,
  });

  @override
  $PropertySummaryModelCopyWith<$Res>? get property;
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
    Object? propertyId = null,
    Object? property = freezed,
    Object? ownerId = null,
    Object? tenantId = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? rentAmount = null,
    Object? depositAmount = null,
    Object? paymentFrequency = null,
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
        propertyId: null == propertyId
            ? _value.propertyId
            : propertyId // ignore: cast_nullable_to_non_nullable
                  as String,
        property: freezed == property
            ? _value.property
            : property // ignore: cast_nullable_to_non_nullable
                  as PropertySummaryModel?,
        ownerId: null == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        tenantId: null == tenantId
            ? _value.tenantId
            : tenantId // ignore: cast_nullable_to_non_nullable
                  as String,
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
    required this.propertyId,
    this.property,
    required this.ownerId,
    required this.tenantId,
    required this.startDate,
    this.endDate,
    required this.rentAmount,
    required this.depositAmount,
    required this.paymentFrequency,
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
  final String propertyId;
  @override
  final PropertySummaryModel? property;
  @override
  final String ownerId;
  @override
  final String tenantId;
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
  final double? indexationRate;
  @override
  final LeaseStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'LeaseModel(id: $id, organizationId: $organizationId, propertyId: $propertyId, property: $property, ownerId: $ownerId, tenantId: $tenantId, startDate: $startDate, endDate: $endDate, rentAmount: $rentAmount, depositAmount: $depositAmount, paymentFrequency: $paymentFrequency, indexationRate: $indexationRate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.property, property) ||
                other.property == property) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.rentAmount, rentAmount) ||
                other.rentAmount == rentAmount) &&
            (identical(other.depositAmount, depositAmount) ||
                other.depositAmount == depositAmount) &&
            (identical(other.paymentFrequency, paymentFrequency) ||
                other.paymentFrequency == paymentFrequency) &&
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
  int get hashCode => Object.hash(
    runtimeType,
    id,
    organizationId,
    propertyId,
    property,
    ownerId,
    tenantId,
    startDate,
    endDate,
    rentAmount,
    depositAmount,
    paymentFrequency,
    indexationRate,
    status,
    createdAt,
    updatedAt,
  );

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
    required final String propertyId,
    final PropertySummaryModel? property,
    required final String ownerId,
    required final String tenantId,
    required final DateTime startDate,
    final DateTime? endDate,
    required final num rentAmount,
    required final num depositAmount,
    required final PaymentFrequency paymentFrequency,
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
  String get propertyId;
  @override
  PropertySummaryModel? get property;
  @override
  String get ownerId;
  @override
  String get tenantId;
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
