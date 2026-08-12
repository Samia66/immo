// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) {
  return _PaymentModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentModel {
  String get id => throw _privateConstructorUsedError;
  String get leaseId => throw _privateConstructorUsedError;
  num get amountDue => throw _privateConstructorUsedError;
  num get amountPaid => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  DateTime? get paidAt => throw _privateConstructorUsedError;
  num? get lateFee => throw _privateConstructorUsedError;
  PaymentMethod? get method => throw _privateConstructorUsedError;
  String? get transactionRef => throw _privateConstructorUsedError;
  PaymentStatus get status => throw _privateConstructorUsedError;
  String? get receiptUrl => throw _privateConstructorUsedError;

  /// Serializes this PaymentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentModelCopyWith<PaymentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentModelCopyWith<$Res> {
  factory $PaymentModelCopyWith(
    PaymentModel value,
    $Res Function(PaymentModel) then,
  ) = _$PaymentModelCopyWithImpl<$Res, PaymentModel>;
  @useResult
  $Res call({
    String id,
    String leaseId,
    num amountDue,
    num amountPaid,
    DateTime dueDate,
    DateTime? paidAt,
    num? lateFee,
    PaymentMethod? method,
    String? transactionRef,
    PaymentStatus status,
    String? receiptUrl,
  });
}

/// @nodoc
class _$PaymentModelCopyWithImpl<$Res, $Val extends PaymentModel>
    implements $PaymentModelCopyWith<$Res> {
  _$PaymentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? leaseId = null,
    Object? amountDue = null,
    Object? amountPaid = null,
    Object? dueDate = null,
    Object? paidAt = freezed,
    Object? lateFee = freezed,
    Object? method = freezed,
    Object? transactionRef = freezed,
    Object? status = null,
    Object? receiptUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            leaseId: null == leaseId
                ? _value.leaseId
                : leaseId // ignore: cast_nullable_to_non_nullable
                      as String,
            amountDue: null == amountDue
                ? _value.amountDue
                : amountDue // ignore: cast_nullable_to_non_nullable
                      as num,
            amountPaid: null == amountPaid
                ? _value.amountPaid
                : amountPaid // ignore: cast_nullable_to_non_nullable
                      as num,
            dueDate: null == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            paidAt: freezed == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lateFee: freezed == lateFee
                ? _value.lateFee
                : lateFee // ignore: cast_nullable_to_non_nullable
                      as num?,
            method: freezed == method
                ? _value.method
                : method // ignore: cast_nullable_to_non_nullable
                      as PaymentMethod?,
            transactionRef: freezed == transactionRef
                ? _value.transactionRef
                : transactionRef // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as PaymentStatus,
            receiptUrl: freezed == receiptUrl
                ? _value.receiptUrl
                : receiptUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentModelImplCopyWith<$Res>
    implements $PaymentModelCopyWith<$Res> {
  factory _$$PaymentModelImplCopyWith(
    _$PaymentModelImpl value,
    $Res Function(_$PaymentModelImpl) then,
  ) = __$$PaymentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String leaseId,
    num amountDue,
    num amountPaid,
    DateTime dueDate,
    DateTime? paidAt,
    num? lateFee,
    PaymentMethod? method,
    String? transactionRef,
    PaymentStatus status,
    String? receiptUrl,
  });
}

/// @nodoc
class __$$PaymentModelImplCopyWithImpl<$Res>
    extends _$PaymentModelCopyWithImpl<$Res, _$PaymentModelImpl>
    implements _$$PaymentModelImplCopyWith<$Res> {
  __$$PaymentModelImplCopyWithImpl(
    _$PaymentModelImpl _value,
    $Res Function(_$PaymentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? leaseId = null,
    Object? amountDue = null,
    Object? amountPaid = null,
    Object? dueDate = null,
    Object? paidAt = freezed,
    Object? lateFee = freezed,
    Object? method = freezed,
    Object? transactionRef = freezed,
    Object? status = null,
    Object? receiptUrl = freezed,
  }) {
    return _then(
      _$PaymentModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        leaseId: null == leaseId
            ? _value.leaseId
            : leaseId // ignore: cast_nullable_to_non_nullable
                  as String,
        amountDue: null == amountDue
            ? _value.amountDue
            : amountDue // ignore: cast_nullable_to_non_nullable
                  as num,
        amountPaid: null == amountPaid
            ? _value.amountPaid
            : amountPaid // ignore: cast_nullable_to_non_nullable
                  as num,
        dueDate: null == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        paidAt: freezed == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lateFee: freezed == lateFee
            ? _value.lateFee
            : lateFee // ignore: cast_nullable_to_non_nullable
                  as num?,
        method: freezed == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
                  as PaymentMethod?,
        transactionRef: freezed == transactionRef
            ? _value.transactionRef
            : transactionRef // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PaymentStatus,
        receiptUrl: freezed == receiptUrl
            ? _value.receiptUrl
            : receiptUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentModelImpl implements _PaymentModel {
  const _$PaymentModelImpl({
    required this.id,
    required this.leaseId,
    required this.amountDue,
    required this.amountPaid,
    required this.dueDate,
    this.paidAt,
    this.lateFee,
    this.method,
    this.transactionRef,
    required this.status,
    this.receiptUrl,
  });

  factory _$PaymentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String leaseId;
  @override
  final num amountDue;
  @override
  final num amountPaid;
  @override
  final DateTime dueDate;
  @override
  final DateTime? paidAt;
  @override
  final num? lateFee;
  @override
  final PaymentMethod? method;
  @override
  final String? transactionRef;
  @override
  final PaymentStatus status;
  @override
  final String? receiptUrl;

  @override
  String toString() {
    return 'PaymentModel(id: $id, leaseId: $leaseId, amountDue: $amountDue, amountPaid: $amountPaid, dueDate: $dueDate, paidAt: $paidAt, lateFee: $lateFee, method: $method, transactionRef: $transactionRef, status: $status, receiptUrl: $receiptUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.leaseId, leaseId) || other.leaseId == leaseId) &&
            (identical(other.amountDue, amountDue) ||
                other.amountDue == amountDue) &&
            (identical(other.amountPaid, amountPaid) ||
                other.amountPaid == amountPaid) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.lateFee, lateFee) || other.lateFee == lateFee) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.transactionRef, transactionRef) ||
                other.transactionRef == transactionRef) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.receiptUrl, receiptUrl) ||
                other.receiptUrl == receiptUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    leaseId,
    amountDue,
    amountPaid,
    dueDate,
    paidAt,
    lateFee,
    method,
    transactionRef,
    status,
    receiptUrl,
  );

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentModelImplCopyWith<_$PaymentModelImpl> get copyWith =>
      __$$PaymentModelImplCopyWithImpl<_$PaymentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentModelImplToJson(this);
  }
}

abstract class _PaymentModel implements PaymentModel {
  const factory _PaymentModel({
    required final String id,
    required final String leaseId,
    required final num amountDue,
    required final num amountPaid,
    required final DateTime dueDate,
    final DateTime? paidAt,
    final num? lateFee,
    final PaymentMethod? method,
    final String? transactionRef,
    required final PaymentStatus status,
    final String? receiptUrl,
  }) = _$PaymentModelImpl;

  factory _PaymentModel.fromJson(Map<String, dynamic> json) =
      _$PaymentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get leaseId;
  @override
  num get amountDue;
  @override
  num get amountPaid;
  @override
  DateTime get dueDate;
  @override
  DateTime? get paidAt;
  @override
  num? get lateFee;
  @override
  PaymentMethod? get method;
  @override
  String? get transactionRef;
  @override
  PaymentStatus get status;
  @override
  String? get receiptUrl;

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentModelImplCopyWith<_$PaymentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentSummaryModel _$PaymentSummaryModelFromJson(Map<String, dynamic> json) {
  return _PaymentSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentSummaryModel {
  String get id => throw _privateConstructorUsedError;
  num get amountDue => throw _privateConstructorUsedError;
  num get amountPaid => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  PaymentStatus get status => throw _privateConstructorUsedError;

  /// Serializes this PaymentSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentSummaryModelCopyWith<PaymentSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentSummaryModelCopyWith<$Res> {
  factory $PaymentSummaryModelCopyWith(
    PaymentSummaryModel value,
    $Res Function(PaymentSummaryModel) then,
  ) = _$PaymentSummaryModelCopyWithImpl<$Res, PaymentSummaryModel>;
  @useResult
  $Res call({
    String id,
    num amountDue,
    num amountPaid,
    DateTime dueDate,
    PaymentStatus status,
  });
}

/// @nodoc
class _$PaymentSummaryModelCopyWithImpl<$Res, $Val extends PaymentSummaryModel>
    implements $PaymentSummaryModelCopyWith<$Res> {
  _$PaymentSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amountDue = null,
    Object? amountPaid = null,
    Object? dueDate = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            amountDue: null == amountDue
                ? _value.amountDue
                : amountDue // ignore: cast_nullable_to_non_nullable
                      as num,
            amountPaid: null == amountPaid
                ? _value.amountPaid
                : amountPaid // ignore: cast_nullable_to_non_nullable
                      as num,
            dueDate: null == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as PaymentStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentSummaryModelImplCopyWith<$Res>
    implements $PaymentSummaryModelCopyWith<$Res> {
  factory _$$PaymentSummaryModelImplCopyWith(
    _$PaymentSummaryModelImpl value,
    $Res Function(_$PaymentSummaryModelImpl) then,
  ) = __$$PaymentSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    num amountDue,
    num amountPaid,
    DateTime dueDate,
    PaymentStatus status,
  });
}

/// @nodoc
class __$$PaymentSummaryModelImplCopyWithImpl<$Res>
    extends _$PaymentSummaryModelCopyWithImpl<$Res, _$PaymentSummaryModelImpl>
    implements _$$PaymentSummaryModelImplCopyWith<$Res> {
  __$$PaymentSummaryModelImplCopyWithImpl(
    _$PaymentSummaryModelImpl _value,
    $Res Function(_$PaymentSummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amountDue = null,
    Object? amountPaid = null,
    Object? dueDate = null,
    Object? status = null,
  }) {
    return _then(
      _$PaymentSummaryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        amountDue: null == amountDue
            ? _value.amountDue
            : amountDue // ignore: cast_nullable_to_non_nullable
                  as num,
        amountPaid: null == amountPaid
            ? _value.amountPaid
            : amountPaid // ignore: cast_nullable_to_non_nullable
                  as num,
        dueDate: null == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PaymentStatus,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentSummaryModelImpl implements _PaymentSummaryModel {
  const _$PaymentSummaryModelImpl({
    required this.id,
    required this.amountDue,
    required this.amountPaid,
    required this.dueDate,
    required this.status,
  });

  factory _$PaymentSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentSummaryModelImplFromJson(json);

  @override
  final String id;
  @override
  final num amountDue;
  @override
  final num amountPaid;
  @override
  final DateTime dueDate;
  @override
  final PaymentStatus status;

  @override
  String toString() {
    return 'PaymentSummaryModel(id: $id, amountDue: $amountDue, amountPaid: $amountPaid, dueDate: $dueDate, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentSummaryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amountDue, amountDue) ||
                other.amountDue == amountDue) &&
            (identical(other.amountPaid, amountPaid) ||
                other.amountPaid == amountPaid) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, amountDue, amountPaid, dueDate, status);

  /// Create a copy of PaymentSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentSummaryModelImplCopyWith<_$PaymentSummaryModelImpl> get copyWith =>
      __$$PaymentSummaryModelImplCopyWithImpl<_$PaymentSummaryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentSummaryModelImplToJson(this);
  }
}

abstract class _PaymentSummaryModel implements PaymentSummaryModel {
  const factory _PaymentSummaryModel({
    required final String id,
    required final num amountDue,
    required final num amountPaid,
    required final DateTime dueDate,
    required final PaymentStatus status,
  }) = _$PaymentSummaryModelImpl;

  factory _PaymentSummaryModel.fromJson(Map<String, dynamic> json) =
      _$PaymentSummaryModelImpl.fromJson;

  @override
  String get id;
  @override
  num get amountDue;
  @override
  num get amountPaid;
  @override
  DateTime get dueDate;
  @override
  PaymentStatus get status;

  /// Create a copy of PaymentSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentSummaryModelImplCopyWith<_$PaymentSummaryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
