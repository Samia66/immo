// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'owner_dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PropertyStatusCount _$PropertyStatusCountFromJson(Map<String, dynamic> json) {
  return _PropertyStatusCount.fromJson(json);
}

/// @nodoc
mixin _$PropertyStatusCount {
  PropertyStatus get status => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this PropertyStatusCount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PropertyStatusCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PropertyStatusCountCopyWith<PropertyStatusCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertyStatusCountCopyWith<$Res> {
  factory $PropertyStatusCountCopyWith(
    PropertyStatusCount value,
    $Res Function(PropertyStatusCount) then,
  ) = _$PropertyStatusCountCopyWithImpl<$Res, PropertyStatusCount>;
  @useResult
  $Res call({PropertyStatus status, int count});
}

/// @nodoc
class _$PropertyStatusCountCopyWithImpl<$Res, $Val extends PropertyStatusCount>
    implements $PropertyStatusCountCopyWith<$Res> {
  _$PropertyStatusCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PropertyStatusCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? count = null}) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as PropertyStatus,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PropertyStatusCountImplCopyWith<$Res>
    implements $PropertyStatusCountCopyWith<$Res> {
  factory _$$PropertyStatusCountImplCopyWith(
    _$PropertyStatusCountImpl value,
    $Res Function(_$PropertyStatusCountImpl) then,
  ) = __$$PropertyStatusCountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PropertyStatus status, int count});
}

/// @nodoc
class __$$PropertyStatusCountImplCopyWithImpl<$Res>
    extends _$PropertyStatusCountCopyWithImpl<$Res, _$PropertyStatusCountImpl>
    implements _$$PropertyStatusCountImplCopyWith<$Res> {
  __$$PropertyStatusCountImplCopyWithImpl(
    _$PropertyStatusCountImpl _value,
    $Res Function(_$PropertyStatusCountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PropertyStatusCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? count = null}) {
    return _then(
      _$PropertyStatusCountImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PropertyStatus,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PropertyStatusCountImpl implements _PropertyStatusCount {
  const _$PropertyStatusCountImpl({required this.status, required this.count});

  factory _$PropertyStatusCountImpl.fromJson(Map<String, dynamic> json) =>
      _$$PropertyStatusCountImplFromJson(json);

  @override
  final PropertyStatus status;
  @override
  final int count;

  @override
  String toString() {
    return 'PropertyStatusCount(status: $status, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PropertyStatusCountImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, count);

  /// Create a copy of PropertyStatusCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PropertyStatusCountImplCopyWith<_$PropertyStatusCountImpl> get copyWith =>
      __$$PropertyStatusCountImplCopyWithImpl<_$PropertyStatusCountImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PropertyStatusCountImplToJson(this);
  }
}

abstract class _PropertyStatusCount implements PropertyStatusCount {
  const factory _PropertyStatusCount({
    required final PropertyStatus status,
    required final int count,
  }) = _$PropertyStatusCountImpl;

  factory _PropertyStatusCount.fromJson(Map<String, dynamic> json) =
      _$PropertyStatusCountImpl.fromJson;

  @override
  PropertyStatus get status;
  @override
  int get count;

  /// Create a copy of PropertyStatusCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PropertyStatusCountImplCopyWith<_$PropertyStatusCountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OwnerDashboardModel _$OwnerDashboardModelFromJson(Map<String, dynamic> json) {
  return _OwnerDashboardModel.fromJson(json);
}

/// @nodoc
mixin _$OwnerDashboardModel {
  int get totalUnits => throw _privateConstructorUsedError;
  List<PropertyStatusCount> get byStatus => throw _privateConstructorUsedError;
  num get monthlyRevenue => throw _privateConstructorUsedError;
  int get pendingCount => throw _privateConstructorUsedError;
  num get pendingAmount => throw _privateConstructorUsedError;
  int get overdueCount => throw _privateConstructorUsedError;
  num get overdueAmount => throw _privateConstructorUsedError;

  /// Serializes this OwnerDashboardModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OwnerDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OwnerDashboardModelCopyWith<OwnerDashboardModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OwnerDashboardModelCopyWith<$Res> {
  factory $OwnerDashboardModelCopyWith(
    OwnerDashboardModel value,
    $Res Function(OwnerDashboardModel) then,
  ) = _$OwnerDashboardModelCopyWithImpl<$Res, OwnerDashboardModel>;
  @useResult
  $Res call({
    int totalUnits,
    List<PropertyStatusCount> byStatus,
    num monthlyRevenue,
    int pendingCount,
    num pendingAmount,
    int overdueCount,
    num overdueAmount,
  });
}

/// @nodoc
class _$OwnerDashboardModelCopyWithImpl<$Res, $Val extends OwnerDashboardModel>
    implements $OwnerDashboardModelCopyWith<$Res> {
  _$OwnerDashboardModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OwnerDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUnits = null,
    Object? byStatus = null,
    Object? monthlyRevenue = null,
    Object? pendingCount = null,
    Object? pendingAmount = null,
    Object? overdueCount = null,
    Object? overdueAmount = null,
  }) {
    return _then(
      _value.copyWith(
            totalUnits: null == totalUnits
                ? _value.totalUnits
                : totalUnits // ignore: cast_nullable_to_non_nullable
                      as int,
            byStatus: null == byStatus
                ? _value.byStatus
                : byStatus // ignore: cast_nullable_to_non_nullable
                      as List<PropertyStatusCount>,
            monthlyRevenue: null == monthlyRevenue
                ? _value.monthlyRevenue
                : monthlyRevenue // ignore: cast_nullable_to_non_nullable
                      as num,
            pendingCount: null == pendingCount
                ? _value.pendingCount
                : pendingCount // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingAmount: null == pendingAmount
                ? _value.pendingAmount
                : pendingAmount // ignore: cast_nullable_to_non_nullable
                      as num,
            overdueCount: null == overdueCount
                ? _value.overdueCount
                : overdueCount // ignore: cast_nullable_to_non_nullable
                      as int,
            overdueAmount: null == overdueAmount
                ? _value.overdueAmount
                : overdueAmount // ignore: cast_nullable_to_non_nullable
                      as num,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OwnerDashboardModelImplCopyWith<$Res>
    implements $OwnerDashboardModelCopyWith<$Res> {
  factory _$$OwnerDashboardModelImplCopyWith(
    _$OwnerDashboardModelImpl value,
    $Res Function(_$OwnerDashboardModelImpl) then,
  ) = __$$OwnerDashboardModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalUnits,
    List<PropertyStatusCount> byStatus,
    num monthlyRevenue,
    int pendingCount,
    num pendingAmount,
    int overdueCount,
    num overdueAmount,
  });
}

/// @nodoc
class __$$OwnerDashboardModelImplCopyWithImpl<$Res>
    extends _$OwnerDashboardModelCopyWithImpl<$Res, _$OwnerDashboardModelImpl>
    implements _$$OwnerDashboardModelImplCopyWith<$Res> {
  __$$OwnerDashboardModelImplCopyWithImpl(
    _$OwnerDashboardModelImpl _value,
    $Res Function(_$OwnerDashboardModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OwnerDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUnits = null,
    Object? byStatus = null,
    Object? monthlyRevenue = null,
    Object? pendingCount = null,
    Object? pendingAmount = null,
    Object? overdueCount = null,
    Object? overdueAmount = null,
  }) {
    return _then(
      _$OwnerDashboardModelImpl(
        totalUnits: null == totalUnits
            ? _value.totalUnits
            : totalUnits // ignore: cast_nullable_to_non_nullable
                  as int,
        byStatus: null == byStatus
            ? _value._byStatus
            : byStatus // ignore: cast_nullable_to_non_nullable
                  as List<PropertyStatusCount>,
        monthlyRevenue: null == monthlyRevenue
            ? _value.monthlyRevenue
            : monthlyRevenue // ignore: cast_nullable_to_non_nullable
                  as num,
        pendingCount: null == pendingCount
            ? _value.pendingCount
            : pendingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingAmount: null == pendingAmount
            ? _value.pendingAmount
            : pendingAmount // ignore: cast_nullable_to_non_nullable
                  as num,
        overdueCount: null == overdueCount
            ? _value.overdueCount
            : overdueCount // ignore: cast_nullable_to_non_nullable
                  as int,
        overdueAmount: null == overdueAmount
            ? _value.overdueAmount
            : overdueAmount // ignore: cast_nullable_to_non_nullable
                  as num,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OwnerDashboardModelImpl implements _OwnerDashboardModel {
  const _$OwnerDashboardModelImpl({
    required this.totalUnits,
    required final List<PropertyStatusCount> byStatus,
    required this.monthlyRevenue,
    required this.pendingCount,
    required this.pendingAmount,
    required this.overdueCount,
    required this.overdueAmount,
  }) : _byStatus = byStatus;

  factory _$OwnerDashboardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OwnerDashboardModelImplFromJson(json);

  @override
  final int totalUnits;
  final List<PropertyStatusCount> _byStatus;
  @override
  List<PropertyStatusCount> get byStatus {
    if (_byStatus is EqualUnmodifiableListView) return _byStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byStatus);
  }

  @override
  final num monthlyRevenue;
  @override
  final int pendingCount;
  @override
  final num pendingAmount;
  @override
  final int overdueCount;
  @override
  final num overdueAmount;

  @override
  String toString() {
    return 'OwnerDashboardModel(totalUnits: $totalUnits, byStatus: $byStatus, monthlyRevenue: $monthlyRevenue, pendingCount: $pendingCount, pendingAmount: $pendingAmount, overdueCount: $overdueCount, overdueAmount: $overdueAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OwnerDashboardModelImpl &&
            (identical(other.totalUnits, totalUnits) ||
                other.totalUnits == totalUnits) &&
            const DeepCollectionEquality().equals(other._byStatus, _byStatus) &&
            (identical(other.monthlyRevenue, monthlyRevenue) ||
                other.monthlyRevenue == monthlyRevenue) &&
            (identical(other.pendingCount, pendingCount) ||
                other.pendingCount == pendingCount) &&
            (identical(other.pendingAmount, pendingAmount) ||
                other.pendingAmount == pendingAmount) &&
            (identical(other.overdueCount, overdueCount) ||
                other.overdueCount == overdueCount) &&
            (identical(other.overdueAmount, overdueAmount) ||
                other.overdueAmount == overdueAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalUnits,
    const DeepCollectionEquality().hash(_byStatus),
    monthlyRevenue,
    pendingCount,
    pendingAmount,
    overdueCount,
    overdueAmount,
  );

  /// Create a copy of OwnerDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OwnerDashboardModelImplCopyWith<_$OwnerDashboardModelImpl> get copyWith =>
      __$$OwnerDashboardModelImplCopyWithImpl<_$OwnerDashboardModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OwnerDashboardModelImplToJson(this);
  }
}

abstract class _OwnerDashboardModel implements OwnerDashboardModel {
  const factory _OwnerDashboardModel({
    required final int totalUnits,
    required final List<PropertyStatusCount> byStatus,
    required final num monthlyRevenue,
    required final int pendingCount,
    required final num pendingAmount,
    required final int overdueCount,
    required final num overdueAmount,
  }) = _$OwnerDashboardModelImpl;

  factory _OwnerDashboardModel.fromJson(Map<String, dynamic> json) =
      _$OwnerDashboardModelImpl.fromJson;

  @override
  int get totalUnits;
  @override
  List<PropertyStatusCount> get byStatus;
  @override
  num get monthlyRevenue;
  @override
  int get pendingCount;
  @override
  num get pendingAmount;
  @override
  int get overdueCount;
  @override
  num get overdueAmount;

  /// Create a copy of OwnerDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OwnerDashboardModelImplCopyWith<_$OwnerDashboardModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
