// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tenant_dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ActiveLeaseSummaryModel _$ActiveLeaseSummaryModelFromJson(
  Map<String, dynamic> json,
) {
  return _ActiveLeaseSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$ActiveLeaseSummaryModel {
  String get id => throw _privateConstructorUsedError;
  PropertySummaryModel get property => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  num get rentAmount => throw _privateConstructorUsedError;

  /// Serializes this ActiveLeaseSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActiveLeaseSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActiveLeaseSummaryModelCopyWith<ActiveLeaseSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActiveLeaseSummaryModelCopyWith<$Res> {
  factory $ActiveLeaseSummaryModelCopyWith(
    ActiveLeaseSummaryModel value,
    $Res Function(ActiveLeaseSummaryModel) then,
  ) = _$ActiveLeaseSummaryModelCopyWithImpl<$Res, ActiveLeaseSummaryModel>;
  @useResult
  $Res call({
    String id,
    PropertySummaryModel property,
    DateTime startDate,
    DateTime? endDate,
    num rentAmount,
  });

  $PropertySummaryModelCopyWith<$Res> get property;
}

/// @nodoc
class _$ActiveLeaseSummaryModelCopyWithImpl<
  $Res,
  $Val extends ActiveLeaseSummaryModel
>
    implements $ActiveLeaseSummaryModelCopyWith<$Res> {
  _$ActiveLeaseSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActiveLeaseSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? property = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? rentAmount = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            property: null == property
                ? _value.property
                : property // ignore: cast_nullable_to_non_nullable
                      as PropertySummaryModel,
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
          )
          as $Val,
    );
  }

  /// Create a copy of ActiveLeaseSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PropertySummaryModelCopyWith<$Res> get property {
    return $PropertySummaryModelCopyWith<$Res>(_value.property, (value) {
      return _then(_value.copyWith(property: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActiveLeaseSummaryModelImplCopyWith<$Res>
    implements $ActiveLeaseSummaryModelCopyWith<$Res> {
  factory _$$ActiveLeaseSummaryModelImplCopyWith(
    _$ActiveLeaseSummaryModelImpl value,
    $Res Function(_$ActiveLeaseSummaryModelImpl) then,
  ) = __$$ActiveLeaseSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    PropertySummaryModel property,
    DateTime startDate,
    DateTime? endDate,
    num rentAmount,
  });

  @override
  $PropertySummaryModelCopyWith<$Res> get property;
}

/// @nodoc
class __$$ActiveLeaseSummaryModelImplCopyWithImpl<$Res>
    extends
        _$ActiveLeaseSummaryModelCopyWithImpl<
          $Res,
          _$ActiveLeaseSummaryModelImpl
        >
    implements _$$ActiveLeaseSummaryModelImplCopyWith<$Res> {
  __$$ActiveLeaseSummaryModelImplCopyWithImpl(
    _$ActiveLeaseSummaryModelImpl _value,
    $Res Function(_$ActiveLeaseSummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActiveLeaseSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? property = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? rentAmount = null,
  }) {
    return _then(
      _$ActiveLeaseSummaryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        property: null == property
            ? _value.property
            : property // ignore: cast_nullable_to_non_nullable
                  as PropertySummaryModel,
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActiveLeaseSummaryModelImpl implements _ActiveLeaseSummaryModel {
  const _$ActiveLeaseSummaryModelImpl({
    required this.id,
    required this.property,
    required this.startDate,
    this.endDate,
    required this.rentAmount,
  });

  factory _$ActiveLeaseSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActiveLeaseSummaryModelImplFromJson(json);

  @override
  final String id;
  @override
  final PropertySummaryModel property;
  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;
  @override
  final num rentAmount;

  @override
  String toString() {
    return 'ActiveLeaseSummaryModel(id: $id, property: $property, startDate: $startDate, endDate: $endDate, rentAmount: $rentAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActiveLeaseSummaryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.property, property) ||
                other.property == property) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.rentAmount, rentAmount) ||
                other.rentAmount == rentAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, property, startDate, endDate, rentAmount);

  /// Create a copy of ActiveLeaseSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActiveLeaseSummaryModelImplCopyWith<_$ActiveLeaseSummaryModelImpl>
  get copyWith =>
      __$$ActiveLeaseSummaryModelImplCopyWithImpl<
        _$ActiveLeaseSummaryModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActiveLeaseSummaryModelImplToJson(this);
  }
}

abstract class _ActiveLeaseSummaryModel implements ActiveLeaseSummaryModel {
  const factory _ActiveLeaseSummaryModel({
    required final String id,
    required final PropertySummaryModel property,
    required final DateTime startDate,
    final DateTime? endDate,
    required final num rentAmount,
  }) = _$ActiveLeaseSummaryModelImpl;

  factory _ActiveLeaseSummaryModel.fromJson(Map<String, dynamic> json) =
      _$ActiveLeaseSummaryModelImpl.fromJson;

  @override
  String get id;
  @override
  PropertySummaryModel get property;
  @override
  DateTime get startDate;
  @override
  DateTime? get endDate;
  @override
  num get rentAmount;

  /// Create a copy of ActiveLeaseSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActiveLeaseSummaryModelImplCopyWith<_$ActiveLeaseSummaryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

TenantDashboardModel _$TenantDashboardModelFromJson(Map<String, dynamic> json) {
  return _TenantDashboardModel.fromJson(json);
}

/// @nodoc
mixin _$TenantDashboardModel {
  ActiveLeaseSummaryModel? get activeLease =>
      throw _privateConstructorUsedError;
  PaymentSummaryModel? get nextPayment => throw _privateConstructorUsedError;
  List<PaymentSummaryModel> get recentPayments =>
      throw _privateConstructorUsedError;

  /// Serializes this TenantDashboardModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TenantDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TenantDashboardModelCopyWith<TenantDashboardModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TenantDashboardModelCopyWith<$Res> {
  factory $TenantDashboardModelCopyWith(
    TenantDashboardModel value,
    $Res Function(TenantDashboardModel) then,
  ) = _$TenantDashboardModelCopyWithImpl<$Res, TenantDashboardModel>;
  @useResult
  $Res call({
    ActiveLeaseSummaryModel? activeLease,
    PaymentSummaryModel? nextPayment,
    List<PaymentSummaryModel> recentPayments,
  });

  $ActiveLeaseSummaryModelCopyWith<$Res>? get activeLease;
  $PaymentSummaryModelCopyWith<$Res>? get nextPayment;
}

/// @nodoc
class _$TenantDashboardModelCopyWithImpl<
  $Res,
  $Val extends TenantDashboardModel
>
    implements $TenantDashboardModelCopyWith<$Res> {
  _$TenantDashboardModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TenantDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeLease = freezed,
    Object? nextPayment = freezed,
    Object? recentPayments = null,
  }) {
    return _then(
      _value.copyWith(
            activeLease: freezed == activeLease
                ? _value.activeLease
                : activeLease // ignore: cast_nullable_to_non_nullable
                      as ActiveLeaseSummaryModel?,
            nextPayment: freezed == nextPayment
                ? _value.nextPayment
                : nextPayment // ignore: cast_nullable_to_non_nullable
                      as PaymentSummaryModel?,
            recentPayments: null == recentPayments
                ? _value.recentPayments
                : recentPayments // ignore: cast_nullable_to_non_nullable
                      as List<PaymentSummaryModel>,
          )
          as $Val,
    );
  }

  /// Create a copy of TenantDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActiveLeaseSummaryModelCopyWith<$Res>? get activeLease {
    if (_value.activeLease == null) {
      return null;
    }

    return $ActiveLeaseSummaryModelCopyWith<$Res>(_value.activeLease!, (value) {
      return _then(_value.copyWith(activeLease: value) as $Val);
    });
  }

  /// Create a copy of TenantDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaymentSummaryModelCopyWith<$Res>? get nextPayment {
    if (_value.nextPayment == null) {
      return null;
    }

    return $PaymentSummaryModelCopyWith<$Res>(_value.nextPayment!, (value) {
      return _then(_value.copyWith(nextPayment: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TenantDashboardModelImplCopyWith<$Res>
    implements $TenantDashboardModelCopyWith<$Res> {
  factory _$$TenantDashboardModelImplCopyWith(
    _$TenantDashboardModelImpl value,
    $Res Function(_$TenantDashboardModelImpl) then,
  ) = __$$TenantDashboardModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ActiveLeaseSummaryModel? activeLease,
    PaymentSummaryModel? nextPayment,
    List<PaymentSummaryModel> recentPayments,
  });

  @override
  $ActiveLeaseSummaryModelCopyWith<$Res>? get activeLease;
  @override
  $PaymentSummaryModelCopyWith<$Res>? get nextPayment;
}

/// @nodoc
class __$$TenantDashboardModelImplCopyWithImpl<$Res>
    extends _$TenantDashboardModelCopyWithImpl<$Res, _$TenantDashboardModelImpl>
    implements _$$TenantDashboardModelImplCopyWith<$Res> {
  __$$TenantDashboardModelImplCopyWithImpl(
    _$TenantDashboardModelImpl _value,
    $Res Function(_$TenantDashboardModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TenantDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeLease = freezed,
    Object? nextPayment = freezed,
    Object? recentPayments = null,
  }) {
    return _then(
      _$TenantDashboardModelImpl(
        activeLease: freezed == activeLease
            ? _value.activeLease
            : activeLease // ignore: cast_nullable_to_non_nullable
                  as ActiveLeaseSummaryModel?,
        nextPayment: freezed == nextPayment
            ? _value.nextPayment
            : nextPayment // ignore: cast_nullable_to_non_nullable
                  as PaymentSummaryModel?,
        recentPayments: null == recentPayments
            ? _value._recentPayments
            : recentPayments // ignore: cast_nullable_to_non_nullable
                  as List<PaymentSummaryModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TenantDashboardModelImpl implements _TenantDashboardModel {
  const _$TenantDashboardModelImpl({
    this.activeLease,
    this.nextPayment,
    required final List<PaymentSummaryModel> recentPayments,
  }) : _recentPayments = recentPayments;

  factory _$TenantDashboardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TenantDashboardModelImplFromJson(json);

  @override
  final ActiveLeaseSummaryModel? activeLease;
  @override
  final PaymentSummaryModel? nextPayment;
  final List<PaymentSummaryModel> _recentPayments;
  @override
  List<PaymentSummaryModel> get recentPayments {
    if (_recentPayments is EqualUnmodifiableListView) return _recentPayments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentPayments);
  }

  @override
  String toString() {
    return 'TenantDashboardModel(activeLease: $activeLease, nextPayment: $nextPayment, recentPayments: $recentPayments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TenantDashboardModelImpl &&
            (identical(other.activeLease, activeLease) ||
                other.activeLease == activeLease) &&
            (identical(other.nextPayment, nextPayment) ||
                other.nextPayment == nextPayment) &&
            const DeepCollectionEquality().equals(
              other._recentPayments,
              _recentPayments,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    activeLease,
    nextPayment,
    const DeepCollectionEquality().hash(_recentPayments),
  );

  /// Create a copy of TenantDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TenantDashboardModelImplCopyWith<_$TenantDashboardModelImpl>
  get copyWith =>
      __$$TenantDashboardModelImplCopyWithImpl<_$TenantDashboardModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TenantDashboardModelImplToJson(this);
  }
}

abstract class _TenantDashboardModel implements TenantDashboardModel {
  const factory _TenantDashboardModel({
    final ActiveLeaseSummaryModel? activeLease,
    final PaymentSummaryModel? nextPayment,
    required final List<PaymentSummaryModel> recentPayments,
  }) = _$TenantDashboardModelImpl;

  factory _TenantDashboardModel.fromJson(Map<String, dynamic> json) =
      _$TenantDashboardModelImpl.fromJson;

  @override
  ActiveLeaseSummaryModel? get activeLease;
  @override
  PaymentSummaryModel? get nextPayment;
  @override
  List<PaymentSummaryModel> get recentPayments;

  /// Create a copy of TenantDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TenantDashboardModelImplCopyWith<_$TenantDashboardModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
