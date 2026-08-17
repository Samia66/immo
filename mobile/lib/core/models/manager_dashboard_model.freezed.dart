// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manager_dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ManagerDashboardModel _$ManagerDashboardModelFromJson(
  Map<String, dynamic> json,
) {
  return _ManagerDashboardModel.fromJson(json);
}

/// @nodoc
mixin _$ManagerDashboardModel {
  int get ownersCount => throw _privateConstructorUsedError;
  int get propertiesCount => throw _privateConstructorUsedError;
  int get unitsCount => throw _privateConstructorUsedError;
  List<PropertyStatusCount> get unitsByStatus =>
      throw _privateConstructorUsedError;
  num get expectedRent => throw _privateConstructorUsedError;
  num get collectedRent => throw _privateConstructorUsedError;
  int get pendingCount => throw _privateConstructorUsedError;
  num get pendingAmount => throw _privateConstructorUsedError;
  int get overdueCount => throw _privateConstructorUsedError;
  num get overdueAmount => throw _privateConstructorUsedError;

  /// Serializes this ManagerDashboardModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ManagerDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManagerDashboardModelCopyWith<ManagerDashboardModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagerDashboardModelCopyWith<$Res> {
  factory $ManagerDashboardModelCopyWith(
    ManagerDashboardModel value,
    $Res Function(ManagerDashboardModel) then,
  ) = _$ManagerDashboardModelCopyWithImpl<$Res, ManagerDashboardModel>;
  @useResult
  $Res call({
    int ownersCount,
    int propertiesCount,
    int unitsCount,
    List<PropertyStatusCount> unitsByStatus,
    num expectedRent,
    num collectedRent,
    int pendingCount,
    num pendingAmount,
    int overdueCount,
    num overdueAmount,
  });
}

/// @nodoc
class _$ManagerDashboardModelCopyWithImpl<
  $Res,
  $Val extends ManagerDashboardModel
>
    implements $ManagerDashboardModelCopyWith<$Res> {
  _$ManagerDashboardModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManagerDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ownersCount = null,
    Object? propertiesCount = null,
    Object? unitsCount = null,
    Object? unitsByStatus = null,
    Object? expectedRent = null,
    Object? collectedRent = null,
    Object? pendingCount = null,
    Object? pendingAmount = null,
    Object? overdueCount = null,
    Object? overdueAmount = null,
  }) {
    return _then(
      _value.copyWith(
            ownersCount: null == ownersCount
                ? _value.ownersCount
                : ownersCount // ignore: cast_nullable_to_non_nullable
                      as int,
            propertiesCount: null == propertiesCount
                ? _value.propertiesCount
                : propertiesCount // ignore: cast_nullable_to_non_nullable
                      as int,
            unitsCount: null == unitsCount
                ? _value.unitsCount
                : unitsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            unitsByStatus: null == unitsByStatus
                ? _value.unitsByStatus
                : unitsByStatus // ignore: cast_nullable_to_non_nullable
                      as List<PropertyStatusCount>,
            expectedRent: null == expectedRent
                ? _value.expectedRent
                : expectedRent // ignore: cast_nullable_to_non_nullable
                      as num,
            collectedRent: null == collectedRent
                ? _value.collectedRent
                : collectedRent // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ManagerDashboardModelImplCopyWith<$Res>
    implements $ManagerDashboardModelCopyWith<$Res> {
  factory _$$ManagerDashboardModelImplCopyWith(
    _$ManagerDashboardModelImpl value,
    $Res Function(_$ManagerDashboardModelImpl) then,
  ) = __$$ManagerDashboardModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int ownersCount,
    int propertiesCount,
    int unitsCount,
    List<PropertyStatusCount> unitsByStatus,
    num expectedRent,
    num collectedRent,
    int pendingCount,
    num pendingAmount,
    int overdueCount,
    num overdueAmount,
  });
}

/// @nodoc
class __$$ManagerDashboardModelImplCopyWithImpl<$Res>
    extends
        _$ManagerDashboardModelCopyWithImpl<$Res, _$ManagerDashboardModelImpl>
    implements _$$ManagerDashboardModelImplCopyWith<$Res> {
  __$$ManagerDashboardModelImplCopyWithImpl(
    _$ManagerDashboardModelImpl _value,
    $Res Function(_$ManagerDashboardModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ManagerDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ownersCount = null,
    Object? propertiesCount = null,
    Object? unitsCount = null,
    Object? unitsByStatus = null,
    Object? expectedRent = null,
    Object? collectedRent = null,
    Object? pendingCount = null,
    Object? pendingAmount = null,
    Object? overdueCount = null,
    Object? overdueAmount = null,
  }) {
    return _then(
      _$ManagerDashboardModelImpl(
        ownersCount: null == ownersCount
            ? _value.ownersCount
            : ownersCount // ignore: cast_nullable_to_non_nullable
                  as int,
        propertiesCount: null == propertiesCount
            ? _value.propertiesCount
            : propertiesCount // ignore: cast_nullable_to_non_nullable
                  as int,
        unitsCount: null == unitsCount
            ? _value.unitsCount
            : unitsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        unitsByStatus: null == unitsByStatus
            ? _value._unitsByStatus
            : unitsByStatus // ignore: cast_nullable_to_non_nullable
                  as List<PropertyStatusCount>,
        expectedRent: null == expectedRent
            ? _value.expectedRent
            : expectedRent // ignore: cast_nullable_to_non_nullable
                  as num,
        collectedRent: null == collectedRent
            ? _value.collectedRent
            : collectedRent // ignore: cast_nullable_to_non_nullable
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
class _$ManagerDashboardModelImpl implements _ManagerDashboardModel {
  const _$ManagerDashboardModelImpl({
    required this.ownersCount,
    required this.propertiesCount,
    required this.unitsCount,
    required final List<PropertyStatusCount> unitsByStatus,
    required this.expectedRent,
    required this.collectedRent,
    required this.pendingCount,
    required this.pendingAmount,
    required this.overdueCount,
    required this.overdueAmount,
  }) : _unitsByStatus = unitsByStatus;

  factory _$ManagerDashboardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ManagerDashboardModelImplFromJson(json);

  @override
  final int ownersCount;
  @override
  final int propertiesCount;
  @override
  final int unitsCount;
  final List<PropertyStatusCount> _unitsByStatus;
  @override
  List<PropertyStatusCount> get unitsByStatus {
    if (_unitsByStatus is EqualUnmodifiableListView) return _unitsByStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unitsByStatus);
  }

  @override
  final num expectedRent;
  @override
  final num collectedRent;
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
    return 'ManagerDashboardModel(ownersCount: $ownersCount, propertiesCount: $propertiesCount, unitsCount: $unitsCount, unitsByStatus: $unitsByStatus, expectedRent: $expectedRent, collectedRent: $collectedRent, pendingCount: $pendingCount, pendingAmount: $pendingAmount, overdueCount: $overdueCount, overdueAmount: $overdueAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagerDashboardModelImpl &&
            (identical(other.ownersCount, ownersCount) ||
                other.ownersCount == ownersCount) &&
            (identical(other.propertiesCount, propertiesCount) ||
                other.propertiesCount == propertiesCount) &&
            (identical(other.unitsCount, unitsCount) ||
                other.unitsCount == unitsCount) &&
            const DeepCollectionEquality().equals(
              other._unitsByStatus,
              _unitsByStatus,
            ) &&
            (identical(other.expectedRent, expectedRent) ||
                other.expectedRent == expectedRent) &&
            (identical(other.collectedRent, collectedRent) ||
                other.collectedRent == collectedRent) &&
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
    ownersCount,
    propertiesCount,
    unitsCount,
    const DeepCollectionEquality().hash(_unitsByStatus),
    expectedRent,
    collectedRent,
    pendingCount,
    pendingAmount,
    overdueCount,
    overdueAmount,
  );

  /// Create a copy of ManagerDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagerDashboardModelImplCopyWith<_$ManagerDashboardModelImpl>
  get copyWith =>
      __$$ManagerDashboardModelImplCopyWithImpl<_$ManagerDashboardModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ManagerDashboardModelImplToJson(this);
  }
}

abstract class _ManagerDashboardModel implements ManagerDashboardModel {
  const factory _ManagerDashboardModel({
    required final int ownersCount,
    required final int propertiesCount,
    required final int unitsCount,
    required final List<PropertyStatusCount> unitsByStatus,
    required final num expectedRent,
    required final num collectedRent,
    required final int pendingCount,
    required final num pendingAmount,
    required final int overdueCount,
    required final num overdueAmount,
  }) = _$ManagerDashboardModelImpl;

  factory _ManagerDashboardModel.fromJson(Map<String, dynamic> json) =
      _$ManagerDashboardModelImpl.fromJson;

  @override
  int get ownersCount;
  @override
  int get propertiesCount;
  @override
  int get unitsCount;
  @override
  List<PropertyStatusCount> get unitsByStatus;
  @override
  num get expectedRent;
  @override
  num get collectedRent;
  @override
  int get pendingCount;
  @override
  num get pendingAmount;
  @override
  int get overdueCount;
  @override
  num get overdueAmount;

  /// Create a copy of ManagerDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManagerDashboardModelImplCopyWith<_$ManagerDashboardModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
