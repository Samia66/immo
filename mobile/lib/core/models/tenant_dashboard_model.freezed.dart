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

DashboardPropertyUnitSummaryModel _$DashboardPropertyUnitSummaryModelFromJson(
  Map<String, dynamic> json,
) {
  return _DashboardPropertyUnitSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$DashboardPropertyUnitSummaryModel {
  String get id => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;
  LeasePropertySummaryModel get property => throw _privateConstructorUsedError;

  /// Serializes this DashboardPropertyUnitSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardPropertyUnitSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardPropertyUnitSummaryModelCopyWith<DashboardPropertyUnitSummaryModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardPropertyUnitSummaryModelCopyWith<$Res> {
  factory $DashboardPropertyUnitSummaryModelCopyWith(
    DashboardPropertyUnitSummaryModel value,
    $Res Function(DashboardPropertyUnitSummaryModel) then,
  ) =
      _$DashboardPropertyUnitSummaryModelCopyWithImpl<
        $Res,
        DashboardPropertyUnitSummaryModel
      >;
  @useResult
  $Res call({
    String id,
    String reference,
    String? label,
    LeasePropertySummaryModel property,
  });

  $LeasePropertySummaryModelCopyWith<$Res> get property;
}

/// @nodoc
class _$DashboardPropertyUnitSummaryModelCopyWithImpl<
  $Res,
  $Val extends DashboardPropertyUnitSummaryModel
>
    implements $DashboardPropertyUnitSummaryModelCopyWith<$Res> {
  _$DashboardPropertyUnitSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardPropertyUnitSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reference = null,
    Object? label = freezed,
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
            property: null == property
                ? _value.property
                : property // ignore: cast_nullable_to_non_nullable
                      as LeasePropertySummaryModel,
          )
          as $Val,
    );
  }

  /// Create a copy of DashboardPropertyUnitSummaryModel
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
abstract class _$$DashboardPropertyUnitSummaryModelImplCopyWith<$Res>
    implements $DashboardPropertyUnitSummaryModelCopyWith<$Res> {
  factory _$$DashboardPropertyUnitSummaryModelImplCopyWith(
    _$DashboardPropertyUnitSummaryModelImpl value,
    $Res Function(_$DashboardPropertyUnitSummaryModelImpl) then,
  ) = __$$DashboardPropertyUnitSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String reference,
    String? label,
    LeasePropertySummaryModel property,
  });

  @override
  $LeasePropertySummaryModelCopyWith<$Res> get property;
}

/// @nodoc
class __$$DashboardPropertyUnitSummaryModelImplCopyWithImpl<$Res>
    extends
        _$DashboardPropertyUnitSummaryModelCopyWithImpl<
          $Res,
          _$DashboardPropertyUnitSummaryModelImpl
        >
    implements _$$DashboardPropertyUnitSummaryModelImplCopyWith<$Res> {
  __$$DashboardPropertyUnitSummaryModelImplCopyWithImpl(
    _$DashboardPropertyUnitSummaryModelImpl _value,
    $Res Function(_$DashboardPropertyUnitSummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardPropertyUnitSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reference = null,
    Object? label = freezed,
    Object? property = null,
  }) {
    return _then(
      _$DashboardPropertyUnitSummaryModelImpl(
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
class _$DashboardPropertyUnitSummaryModelImpl
    implements _DashboardPropertyUnitSummaryModel {
  const _$DashboardPropertyUnitSummaryModelImpl({
    required this.id,
    required this.reference,
    this.label,
    required this.property,
  });

  factory _$DashboardPropertyUnitSummaryModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$DashboardPropertyUnitSummaryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String reference;
  @override
  final String? label;
  @override
  final LeasePropertySummaryModel property;

  @override
  String toString() {
    return 'DashboardPropertyUnitSummaryModel(id: $id, reference: $reference, label: $label, property: $property)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardPropertyUnitSummaryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.property, property) ||
                other.property == property));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, reference, label, property);

  /// Create a copy of DashboardPropertyUnitSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardPropertyUnitSummaryModelImplCopyWith<
    _$DashboardPropertyUnitSummaryModelImpl
  >
  get copyWith =>
      __$$DashboardPropertyUnitSummaryModelImplCopyWithImpl<
        _$DashboardPropertyUnitSummaryModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardPropertyUnitSummaryModelImplToJson(this);
  }
}

abstract class _DashboardPropertyUnitSummaryModel
    implements DashboardPropertyUnitSummaryModel {
  const factory _DashboardPropertyUnitSummaryModel({
    required final String id,
    required final String reference,
    final String? label,
    required final LeasePropertySummaryModel property,
  }) = _$DashboardPropertyUnitSummaryModelImpl;

  factory _DashboardPropertyUnitSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) = _$DashboardPropertyUnitSummaryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get reference;
  @override
  String? get label;
  @override
  LeasePropertySummaryModel get property;

  /// Create a copy of DashboardPropertyUnitSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardPropertyUnitSummaryModelImplCopyWith<
    _$DashboardPropertyUnitSummaryModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

ActiveLeaseSummaryModel _$ActiveLeaseSummaryModelFromJson(
  Map<String, dynamic> json,
) {
  return _ActiveLeaseSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$ActiveLeaseSummaryModel {
  String get id => throw _privateConstructorUsedError;
  DashboardPropertyUnitSummaryModel get propertyUnit =>
      throw _privateConstructorUsedError;
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
    DashboardPropertyUnitSummaryModel propertyUnit,
    DateTime startDate,
    DateTime? endDate,
    num rentAmount,
  });

  $DashboardPropertyUnitSummaryModelCopyWith<$Res> get propertyUnit;
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
    Object? propertyUnit = null,
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
            propertyUnit: null == propertyUnit
                ? _value.propertyUnit
                : propertyUnit // ignore: cast_nullable_to_non_nullable
                      as DashboardPropertyUnitSummaryModel,
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
  $DashboardPropertyUnitSummaryModelCopyWith<$Res> get propertyUnit {
    return $DashboardPropertyUnitSummaryModelCopyWith<$Res>(
      _value.propertyUnit,
      (value) {
        return _then(_value.copyWith(propertyUnit: value) as $Val);
      },
    );
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
    DashboardPropertyUnitSummaryModel propertyUnit,
    DateTime startDate,
    DateTime? endDate,
    num rentAmount,
  });

  @override
  $DashboardPropertyUnitSummaryModelCopyWith<$Res> get propertyUnit;
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
    Object? propertyUnit = null,
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
        propertyUnit: null == propertyUnit
            ? _value.propertyUnit
            : propertyUnit // ignore: cast_nullable_to_non_nullable
                  as DashboardPropertyUnitSummaryModel,
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
    required this.propertyUnit,
    required this.startDate,
    this.endDate,
    required this.rentAmount,
  });

  factory _$ActiveLeaseSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActiveLeaseSummaryModelImplFromJson(json);

  @override
  final String id;
  @override
  final DashboardPropertyUnitSummaryModel propertyUnit;
  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;
  @override
  final num rentAmount;

  @override
  String toString() {
    return 'ActiveLeaseSummaryModel(id: $id, propertyUnit: $propertyUnit, startDate: $startDate, endDate: $endDate, rentAmount: $rentAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActiveLeaseSummaryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.propertyUnit, propertyUnit) ||
                other.propertyUnit == propertyUnit) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.rentAmount, rentAmount) ||
                other.rentAmount == rentAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    propertyUnit,
    startDate,
    endDate,
    rentAmount,
  );

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
    required final DashboardPropertyUnitSummaryModel propertyUnit,
    required final DateTime startDate,
    final DateTime? endDate,
    required final num rentAmount,
  }) = _$ActiveLeaseSummaryModelImpl;

  factory _ActiveLeaseSummaryModel.fromJson(Map<String, dynamic> json) =
      _$ActiveLeaseSummaryModelImpl.fromJson;

  @override
  String get id;
  @override
  DashboardPropertyUnitSummaryModel get propertyUnit;
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
