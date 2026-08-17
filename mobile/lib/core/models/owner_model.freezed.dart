// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'owner_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OwnerPropertySummaryModel _$OwnerPropertySummaryModelFromJson(
  Map<String, dynamic> json,
) {
  return _OwnerPropertySummaryModel.fromJson(json);
}

/// @nodoc
mixin _$OwnerPropertySummaryModel {
  String get id => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get unitsCount => throw _privateConstructorUsedError;

  /// Serializes this OwnerPropertySummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OwnerPropertySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OwnerPropertySummaryModelCopyWith<OwnerPropertySummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OwnerPropertySummaryModelCopyWith<$Res> {
  factory $OwnerPropertySummaryModelCopyWith(
    OwnerPropertySummaryModel value,
    $Res Function(OwnerPropertySummaryModel) then,
  ) = _$OwnerPropertySummaryModelCopyWithImpl<$Res, OwnerPropertySummaryModel>;
  @useResult
  $Res call({String id, String reference, String title, int unitsCount});
}

/// @nodoc
class _$OwnerPropertySummaryModelCopyWithImpl<
  $Res,
  $Val extends OwnerPropertySummaryModel
>
    implements $OwnerPropertySummaryModelCopyWith<$Res> {
  _$OwnerPropertySummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OwnerPropertySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reference = null,
    Object? title = null,
    Object? unitsCount = null,
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
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            unitsCount: null == unitsCount
                ? _value.unitsCount
                : unitsCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OwnerPropertySummaryModelImplCopyWith<$Res>
    implements $OwnerPropertySummaryModelCopyWith<$Res> {
  factory _$$OwnerPropertySummaryModelImplCopyWith(
    _$OwnerPropertySummaryModelImpl value,
    $Res Function(_$OwnerPropertySummaryModelImpl) then,
  ) = __$$OwnerPropertySummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String reference, String title, int unitsCount});
}

/// @nodoc
class __$$OwnerPropertySummaryModelImplCopyWithImpl<$Res>
    extends
        _$OwnerPropertySummaryModelCopyWithImpl<
          $Res,
          _$OwnerPropertySummaryModelImpl
        >
    implements _$$OwnerPropertySummaryModelImplCopyWith<$Res> {
  __$$OwnerPropertySummaryModelImplCopyWithImpl(
    _$OwnerPropertySummaryModelImpl _value,
    $Res Function(_$OwnerPropertySummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OwnerPropertySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reference = null,
    Object? title = null,
    Object? unitsCount = null,
  }) {
    return _then(
      _$OwnerPropertySummaryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        reference: null == reference
            ? _value.reference
            : reference // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        unitsCount: null == unitsCount
            ? _value.unitsCount
            : unitsCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OwnerPropertySummaryModelImpl implements _OwnerPropertySummaryModel {
  const _$OwnerPropertySummaryModelImpl({
    required this.id,
    required this.reference,
    required this.title,
    required this.unitsCount,
  });

  factory _$OwnerPropertySummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OwnerPropertySummaryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String reference;
  @override
  final String title;
  @override
  final int unitsCount;

  @override
  String toString() {
    return 'OwnerPropertySummaryModel(id: $id, reference: $reference, title: $title, unitsCount: $unitsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OwnerPropertySummaryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.unitsCount, unitsCount) ||
                other.unitsCount == unitsCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, reference, title, unitsCount);

  /// Create a copy of OwnerPropertySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OwnerPropertySummaryModelImplCopyWith<_$OwnerPropertySummaryModelImpl>
  get copyWith =>
      __$$OwnerPropertySummaryModelImplCopyWithImpl<
        _$OwnerPropertySummaryModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OwnerPropertySummaryModelImplToJson(this);
  }
}

abstract class _OwnerPropertySummaryModel implements OwnerPropertySummaryModel {
  const factory _OwnerPropertySummaryModel({
    required final String id,
    required final String reference,
    required final String title,
    required final int unitsCount,
  }) = _$OwnerPropertySummaryModelImpl;

  factory _OwnerPropertySummaryModel.fromJson(Map<String, dynamic> json) =
      _$OwnerPropertySummaryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get reference;
  @override
  String get title;
  @override
  int get unitsCount;

  /// Create a copy of OwnerPropertySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OwnerPropertySummaryModelImplCopyWith<_$OwnerPropertySummaryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

OwnerModel _$OwnerModelFromJson(Map<String, dynamic> json) {
  return _OwnerModel.fromJson(json);
}

/// @nodoc
mixin _$OwnerModel {
  String get id => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  int? get propertiesCount => throw _privateConstructorUsedError;
  num? get totalRevenue => throw _privateConstructorUsedError;
  List<OwnerPropertySummaryModel>? get properties =>
      throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this OwnerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OwnerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OwnerModelCopyWith<OwnerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OwnerModelCopyWith<$Res> {
  factory $OwnerModelCopyWith(
    OwnerModel value,
    $Res Function(OwnerModel) then,
  ) = _$OwnerModelCopyWithImpl<$Res, OwnerModel>;
  @useResult
  $Res call({
    String id,
    String fullName,
    String phone,
    String? email,
    String? address,
    String? userId,
    int? propertiesCount,
    num? totalRevenue,
    List<OwnerPropertySummaryModel>? properties,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$OwnerModelCopyWithImpl<$Res, $Val extends OwnerModel>
    implements $OwnerModelCopyWith<$Res> {
  _$OwnerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OwnerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? phone = null,
    Object? email = freezed,
    Object? address = freezed,
    Object? userId = freezed,
    Object? propertiesCount = freezed,
    Object? totalRevenue = freezed,
    Object? properties = freezed,
    Object? createdAt = freezed,
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
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String?,
            propertiesCount: freezed == propertiesCount
                ? _value.propertiesCount
                : propertiesCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalRevenue: freezed == totalRevenue
                ? _value.totalRevenue
                : totalRevenue // ignore: cast_nullable_to_non_nullable
                      as num?,
            properties: freezed == properties
                ? _value.properties
                : properties // ignore: cast_nullable_to_non_nullable
                      as List<OwnerPropertySummaryModel>?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OwnerModelImplCopyWith<$Res>
    implements $OwnerModelCopyWith<$Res> {
  factory _$$OwnerModelImplCopyWith(
    _$OwnerModelImpl value,
    $Res Function(_$OwnerModelImpl) then,
  ) = __$$OwnerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String fullName,
    String phone,
    String? email,
    String? address,
    String? userId,
    int? propertiesCount,
    num? totalRevenue,
    List<OwnerPropertySummaryModel>? properties,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$OwnerModelImplCopyWithImpl<$Res>
    extends _$OwnerModelCopyWithImpl<$Res, _$OwnerModelImpl>
    implements _$$OwnerModelImplCopyWith<$Res> {
  __$$OwnerModelImplCopyWithImpl(
    _$OwnerModelImpl _value,
    $Res Function(_$OwnerModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OwnerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? phone = null,
    Object? email = freezed,
    Object? address = freezed,
    Object? userId = freezed,
    Object? propertiesCount = freezed,
    Object? totalRevenue = freezed,
    Object? properties = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$OwnerModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
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
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        propertiesCount: freezed == propertiesCount
            ? _value.propertiesCount
            : propertiesCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalRevenue: freezed == totalRevenue
            ? _value.totalRevenue
            : totalRevenue // ignore: cast_nullable_to_non_nullable
                  as num?,
        properties: freezed == properties
            ? _value._properties
            : properties // ignore: cast_nullable_to_non_nullable
                  as List<OwnerPropertySummaryModel>?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OwnerModelImpl implements _OwnerModel {
  const _$OwnerModelImpl({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
    this.address,
    this.userId,
    this.propertiesCount,
    this.totalRevenue,
    final List<OwnerPropertySummaryModel>? properties,
    this.createdAt,
  }) : _properties = properties;

  factory _$OwnerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OwnerModelImplFromJson(json);

  @override
  final String id;
  @override
  final String fullName;
  @override
  final String phone;
  @override
  final String? email;
  @override
  final String? address;
  @override
  final String? userId;
  @override
  final int? propertiesCount;
  @override
  final num? totalRevenue;
  final List<OwnerPropertySummaryModel>? _properties;
  @override
  List<OwnerPropertySummaryModel>? get properties {
    final value = _properties;
    if (value == null) return null;
    if (_properties is EqualUnmodifiableListView) return _properties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'OwnerModel(id: $id, fullName: $fullName, phone: $phone, email: $email, address: $address, userId: $userId, propertiesCount: $propertiesCount, totalRevenue: $totalRevenue, properties: $properties, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OwnerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.propertiesCount, propertiesCount) ||
                other.propertiesCount == propertiesCount) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            const DeepCollectionEquality().equals(
              other._properties,
              _properties,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    fullName,
    phone,
    email,
    address,
    userId,
    propertiesCount,
    totalRevenue,
    const DeepCollectionEquality().hash(_properties),
    createdAt,
  );

  /// Create a copy of OwnerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OwnerModelImplCopyWith<_$OwnerModelImpl> get copyWith =>
      __$$OwnerModelImplCopyWithImpl<_$OwnerModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OwnerModelImplToJson(this);
  }
}

abstract class _OwnerModel implements OwnerModel {
  const factory _OwnerModel({
    required final String id,
    required final String fullName,
    required final String phone,
    final String? email,
    final String? address,
    final String? userId,
    final int? propertiesCount,
    final num? totalRevenue,
    final List<OwnerPropertySummaryModel>? properties,
    final DateTime? createdAt,
  }) = _$OwnerModelImpl;

  factory _OwnerModel.fromJson(Map<String, dynamic> json) =
      _$OwnerModelImpl.fromJson;

  @override
  String get id;
  @override
  String get fullName;
  @override
  String get phone;
  @override
  String? get email;
  @override
  String? get address;
  @override
  String? get userId;
  @override
  int? get propertiesCount;
  @override
  num? get totalRevenue;
  @override
  List<OwnerPropertySummaryModel>? get properties;
  @override
  DateTime? get createdAt;

  /// Create a copy of OwnerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OwnerModelImplCopyWith<_$OwnerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
