// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PropertyImageModel _$PropertyImageModelFromJson(Map<String, dynamic> json) {
  return _PropertyImageModel.fromJson(json);
}

/// @nodoc
mixin _$PropertyImageModel {
  String get id => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  bool get isCover => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

  /// Serializes this PropertyImageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PropertyImageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PropertyImageModelCopyWith<PropertyImageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertyImageModelCopyWith<$Res> {
  factory $PropertyImageModelCopyWith(
    PropertyImageModel value,
    $Res Function(PropertyImageModel) then,
  ) = _$PropertyImageModelCopyWithImpl<$Res, PropertyImageModel>;
  @useResult
  $Res call({String id, String url, bool isCover, int order});
}

/// @nodoc
class _$PropertyImageModelCopyWithImpl<$Res, $Val extends PropertyImageModel>
    implements $PropertyImageModelCopyWith<$Res> {
  _$PropertyImageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PropertyImageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? isCover = null,
    Object? order = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            isCover: null == isCover
                ? _value.isCover
                : isCover // ignore: cast_nullable_to_non_nullable
                      as bool,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PropertyImageModelImplCopyWith<$Res>
    implements $PropertyImageModelCopyWith<$Res> {
  factory _$$PropertyImageModelImplCopyWith(
    _$PropertyImageModelImpl value,
    $Res Function(_$PropertyImageModelImpl) then,
  ) = __$$PropertyImageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String url, bool isCover, int order});
}

/// @nodoc
class __$$PropertyImageModelImplCopyWithImpl<$Res>
    extends _$PropertyImageModelCopyWithImpl<$Res, _$PropertyImageModelImpl>
    implements _$$PropertyImageModelImplCopyWith<$Res> {
  __$$PropertyImageModelImplCopyWithImpl(
    _$PropertyImageModelImpl _value,
    $Res Function(_$PropertyImageModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PropertyImageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? isCover = null,
    Object? order = null,
  }) {
    return _then(
      _$PropertyImageModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        isCover: null == isCover
            ? _value.isCover
            : isCover // ignore: cast_nullable_to_non_nullable
                  as bool,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PropertyImageModelImpl implements _PropertyImageModel {
  const _$PropertyImageModelImpl({
    required this.id,
    required this.url,
    required this.isCover,
    required this.order,
  });

  factory _$PropertyImageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PropertyImageModelImplFromJson(json);

  @override
  final String id;
  @override
  final String url;
  @override
  final bool isCover;
  @override
  final int order;

  @override
  String toString() {
    return 'PropertyImageModel(id: $id, url: $url, isCover: $isCover, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PropertyImageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.isCover, isCover) || other.isCover == isCover) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, url, isCover, order);

  /// Create a copy of PropertyImageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PropertyImageModelImplCopyWith<_$PropertyImageModelImpl> get copyWith =>
      __$$PropertyImageModelImplCopyWithImpl<_$PropertyImageModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PropertyImageModelImplToJson(this);
  }
}

abstract class _PropertyImageModel implements PropertyImageModel {
  const factory _PropertyImageModel({
    required final String id,
    required final String url,
    required final bool isCover,
    required final int order,
  }) = _$PropertyImageModelImpl;

  factory _PropertyImageModel.fromJson(Map<String, dynamic> json) =
      _$PropertyImageModelImpl.fromJson;

  @override
  String get id;
  @override
  String get url;
  @override
  bool get isCover;
  @override
  int get order;

  /// Create a copy of PropertyImageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PropertyImageModelImplCopyWith<_$PropertyImageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PropertyUnitCurrentTenantModel _$PropertyUnitCurrentTenantModelFromJson(
  Map<String, dynamic> json,
) {
  return _PropertyUnitCurrentTenantModel.fromJson(json);
}

/// @nodoc
mixin _$PropertyUnitCurrentTenantModel {
  String get id => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;

  /// Serializes this PropertyUnitCurrentTenantModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PropertyUnitCurrentTenantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PropertyUnitCurrentTenantModelCopyWith<PropertyUnitCurrentTenantModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertyUnitCurrentTenantModelCopyWith<$Res> {
  factory $PropertyUnitCurrentTenantModelCopyWith(
    PropertyUnitCurrentTenantModel value,
    $Res Function(PropertyUnitCurrentTenantModel) then,
  ) =
      _$PropertyUnitCurrentTenantModelCopyWithImpl<
        $Res,
        PropertyUnitCurrentTenantModel
      >;
  @useResult
  $Res call({String id, String fullName, String? phone});
}

/// @nodoc
class _$PropertyUnitCurrentTenantModelCopyWithImpl<
  $Res,
  $Val extends PropertyUnitCurrentTenantModel
>
    implements $PropertyUnitCurrentTenantModelCopyWith<$Res> {
  _$PropertyUnitCurrentTenantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PropertyUnitCurrentTenantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? phone = freezed,
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
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PropertyUnitCurrentTenantModelImplCopyWith<$Res>
    implements $PropertyUnitCurrentTenantModelCopyWith<$Res> {
  factory _$$PropertyUnitCurrentTenantModelImplCopyWith(
    _$PropertyUnitCurrentTenantModelImpl value,
    $Res Function(_$PropertyUnitCurrentTenantModelImpl) then,
  ) = __$$PropertyUnitCurrentTenantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String fullName, String? phone});
}

/// @nodoc
class __$$PropertyUnitCurrentTenantModelImplCopyWithImpl<$Res>
    extends
        _$PropertyUnitCurrentTenantModelCopyWithImpl<
          $Res,
          _$PropertyUnitCurrentTenantModelImpl
        >
    implements _$$PropertyUnitCurrentTenantModelImplCopyWith<$Res> {
  __$$PropertyUnitCurrentTenantModelImplCopyWithImpl(
    _$PropertyUnitCurrentTenantModelImpl _value,
    $Res Function(_$PropertyUnitCurrentTenantModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PropertyUnitCurrentTenantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? phone = freezed,
  }) {
    return _then(
      _$PropertyUnitCurrentTenantModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PropertyUnitCurrentTenantModelImpl
    implements _PropertyUnitCurrentTenantModel {
  const _$PropertyUnitCurrentTenantModelImpl({
    required this.id,
    required this.fullName,
    this.phone,
  });

  factory _$PropertyUnitCurrentTenantModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$PropertyUnitCurrentTenantModelImplFromJson(json);

  @override
  final String id;
  @override
  final String fullName;
  @override
  final String? phone;

  @override
  String toString() {
    return 'PropertyUnitCurrentTenantModel(id: $id, fullName: $fullName, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PropertyUnitCurrentTenantModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, fullName, phone);

  /// Create a copy of PropertyUnitCurrentTenantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PropertyUnitCurrentTenantModelImplCopyWith<
    _$PropertyUnitCurrentTenantModelImpl
  >
  get copyWith =>
      __$$PropertyUnitCurrentTenantModelImplCopyWithImpl<
        _$PropertyUnitCurrentTenantModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PropertyUnitCurrentTenantModelImplToJson(this);
  }
}

abstract class _PropertyUnitCurrentTenantModel
    implements PropertyUnitCurrentTenantModel {
  const factory _PropertyUnitCurrentTenantModel({
    required final String id,
    required final String fullName,
    final String? phone,
  }) = _$PropertyUnitCurrentTenantModelImpl;

  factory _PropertyUnitCurrentTenantModel.fromJson(Map<String, dynamic> json) =
      _$PropertyUnitCurrentTenantModelImpl.fromJson;

  @override
  String get id;
  @override
  String get fullName;
  @override
  String? get phone;

  /// Create a copy of PropertyUnitCurrentTenantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PropertyUnitCurrentTenantModelImplCopyWith<
    _$PropertyUnitCurrentTenantModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

PropertyUnitModel _$PropertyUnitModelFromJson(Map<String, dynamic> json) {
  return _PropertyUnitModel.fromJson(json);
}

/// @nodoc
mixin _$PropertyUnitModel {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get propertyId => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;
  String? get floor => throw _privateConstructorUsedError;
  PropertyType get type => throw _privateConstructorUsedError;
  int? get rooms => throw _privateConstructorUsedError;
  double? get surfaceM2 => throw _privateConstructorUsedError;
  num get monthlyRent => throw _privateConstructorUsedError;
  num? get monthlyCharges => throw _privateConstructorUsedError;
  PropertyStatus get status => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  PropertyUnitCurrentTenantModel? get currentTenant =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PropertyUnitModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PropertyUnitModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PropertyUnitModelCopyWith<PropertyUnitModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertyUnitModelCopyWith<$Res> {
  factory $PropertyUnitModelCopyWith(
    PropertyUnitModel value,
    $Res Function(PropertyUnitModel) then,
  ) = _$PropertyUnitModelCopyWithImpl<$Res, PropertyUnitModel>;
  @useResult
  $Res call({
    String id,
    String organizationId,
    String propertyId,
    String reference,
    String? label,
    String? floor,
    PropertyType type,
    int? rooms,
    double? surfaceM2,
    num monthlyRent,
    num? monthlyCharges,
    PropertyStatus status,
    String? description,
    PropertyUnitCurrentTenantModel? currentTenant,
    DateTime createdAt,
    DateTime updatedAt,
  });

  $PropertyUnitCurrentTenantModelCopyWith<$Res>? get currentTenant;
}

/// @nodoc
class _$PropertyUnitModelCopyWithImpl<$Res, $Val extends PropertyUnitModel>
    implements $PropertyUnitModelCopyWith<$Res> {
  _$PropertyUnitModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PropertyUnitModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? propertyId = null,
    Object? reference = null,
    Object? label = freezed,
    Object? floor = freezed,
    Object? type = null,
    Object? rooms = freezed,
    Object? surfaceM2 = freezed,
    Object? monthlyRent = null,
    Object? monthlyCharges = freezed,
    Object? status = null,
    Object? description = freezed,
    Object? currentTenant = freezed,
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
            reference: null == reference
                ? _value.reference
                : reference // ignore: cast_nullable_to_non_nullable
                      as String,
            label: freezed == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String?,
            floor: freezed == floor
                ? _value.floor
                : floor // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as PropertyType,
            rooms: freezed == rooms
                ? _value.rooms
                : rooms // ignore: cast_nullable_to_non_nullable
                      as int?,
            surfaceM2: freezed == surfaceM2
                ? _value.surfaceM2
                : surfaceM2 // ignore: cast_nullable_to_non_nullable
                      as double?,
            monthlyRent: null == monthlyRent
                ? _value.monthlyRent
                : monthlyRent // ignore: cast_nullable_to_non_nullable
                      as num,
            monthlyCharges: freezed == monthlyCharges
                ? _value.monthlyCharges
                : monthlyCharges // ignore: cast_nullable_to_non_nullable
                      as num?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as PropertyStatus,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentTenant: freezed == currentTenant
                ? _value.currentTenant
                : currentTenant // ignore: cast_nullable_to_non_nullable
                      as PropertyUnitCurrentTenantModel?,
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

  /// Create a copy of PropertyUnitModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PropertyUnitCurrentTenantModelCopyWith<$Res>? get currentTenant {
    if (_value.currentTenant == null) {
      return null;
    }

    return $PropertyUnitCurrentTenantModelCopyWith<$Res>(
      _value.currentTenant!,
      (value) {
        return _then(_value.copyWith(currentTenant: value) as $Val);
      },
    );
  }
}

/// @nodoc
abstract class _$$PropertyUnitModelImplCopyWith<$Res>
    implements $PropertyUnitModelCopyWith<$Res> {
  factory _$$PropertyUnitModelImplCopyWith(
    _$PropertyUnitModelImpl value,
    $Res Function(_$PropertyUnitModelImpl) then,
  ) = __$$PropertyUnitModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String organizationId,
    String propertyId,
    String reference,
    String? label,
    String? floor,
    PropertyType type,
    int? rooms,
    double? surfaceM2,
    num monthlyRent,
    num? monthlyCharges,
    PropertyStatus status,
    String? description,
    PropertyUnitCurrentTenantModel? currentTenant,
    DateTime createdAt,
    DateTime updatedAt,
  });

  @override
  $PropertyUnitCurrentTenantModelCopyWith<$Res>? get currentTenant;
}

/// @nodoc
class __$$PropertyUnitModelImplCopyWithImpl<$Res>
    extends _$PropertyUnitModelCopyWithImpl<$Res, _$PropertyUnitModelImpl>
    implements _$$PropertyUnitModelImplCopyWith<$Res> {
  __$$PropertyUnitModelImplCopyWithImpl(
    _$PropertyUnitModelImpl _value,
    $Res Function(_$PropertyUnitModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PropertyUnitModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? propertyId = null,
    Object? reference = null,
    Object? label = freezed,
    Object? floor = freezed,
    Object? type = null,
    Object? rooms = freezed,
    Object? surfaceM2 = freezed,
    Object? monthlyRent = null,
    Object? monthlyCharges = freezed,
    Object? status = null,
    Object? description = freezed,
    Object? currentTenant = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$PropertyUnitModelImpl(
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
        reference: null == reference
            ? _value.reference
            : reference // ignore: cast_nullable_to_non_nullable
                  as String,
        label: freezed == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String?,
        floor: freezed == floor
            ? _value.floor
            : floor // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as PropertyType,
        rooms: freezed == rooms
            ? _value.rooms
            : rooms // ignore: cast_nullable_to_non_nullable
                  as int?,
        surfaceM2: freezed == surfaceM2
            ? _value.surfaceM2
            : surfaceM2 // ignore: cast_nullable_to_non_nullable
                  as double?,
        monthlyRent: null == monthlyRent
            ? _value.monthlyRent
            : monthlyRent // ignore: cast_nullable_to_non_nullable
                  as num,
        monthlyCharges: freezed == monthlyCharges
            ? _value.monthlyCharges
            : monthlyCharges // ignore: cast_nullable_to_non_nullable
                  as num?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PropertyStatus,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentTenant: freezed == currentTenant
            ? _value.currentTenant
            : currentTenant // ignore: cast_nullable_to_non_nullable
                  as PropertyUnitCurrentTenantModel?,
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
class _$PropertyUnitModelImpl implements _PropertyUnitModel {
  const _$PropertyUnitModelImpl({
    required this.id,
    required this.organizationId,
    required this.propertyId,
    required this.reference,
    this.label,
    this.floor,
    required this.type,
    this.rooms,
    this.surfaceM2,
    required this.monthlyRent,
    this.monthlyCharges,
    required this.status,
    this.description,
    this.currentTenant,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$PropertyUnitModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PropertyUnitModelImplFromJson(json);

  @override
  final String id;
  @override
  final String organizationId;
  @override
  final String propertyId;
  @override
  final String reference;
  @override
  final String? label;
  @override
  final String? floor;
  @override
  final PropertyType type;
  @override
  final int? rooms;
  @override
  final double? surfaceM2;
  @override
  final num monthlyRent;
  @override
  final num? monthlyCharges;
  @override
  final PropertyStatus status;
  @override
  final String? description;
  @override
  final PropertyUnitCurrentTenantModel? currentTenant;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PropertyUnitModel(id: $id, organizationId: $organizationId, propertyId: $propertyId, reference: $reference, label: $label, floor: $floor, type: $type, rooms: $rooms, surfaceM2: $surfaceM2, monthlyRent: $monthlyRent, monthlyCharges: $monthlyCharges, status: $status, description: $description, currentTenant: $currentTenant, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PropertyUnitModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.floor, floor) || other.floor == floor) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.rooms, rooms) || other.rooms == rooms) &&
            (identical(other.surfaceM2, surfaceM2) ||
                other.surfaceM2 == surfaceM2) &&
            (identical(other.monthlyRent, monthlyRent) ||
                other.monthlyRent == monthlyRent) &&
            (identical(other.monthlyCharges, monthlyCharges) ||
                other.monthlyCharges == monthlyCharges) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.currentTenant, currentTenant) ||
                other.currentTenant == currentTenant) &&
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
    reference,
    label,
    floor,
    type,
    rooms,
    surfaceM2,
    monthlyRent,
    monthlyCharges,
    status,
    description,
    currentTenant,
    createdAt,
    updatedAt,
  );

  /// Create a copy of PropertyUnitModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PropertyUnitModelImplCopyWith<_$PropertyUnitModelImpl> get copyWith =>
      __$$PropertyUnitModelImplCopyWithImpl<_$PropertyUnitModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PropertyUnitModelImplToJson(this);
  }
}

abstract class _PropertyUnitModel implements PropertyUnitModel {
  const factory _PropertyUnitModel({
    required final String id,
    required final String organizationId,
    required final String propertyId,
    required final String reference,
    final String? label,
    final String? floor,
    required final PropertyType type,
    final int? rooms,
    final double? surfaceM2,
    required final num monthlyRent,
    final num? monthlyCharges,
    required final PropertyStatus status,
    final String? description,
    final PropertyUnitCurrentTenantModel? currentTenant,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$PropertyUnitModelImpl;

  factory _PropertyUnitModel.fromJson(Map<String, dynamic> json) =
      _$PropertyUnitModelImpl.fromJson;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get propertyId;
  @override
  String get reference;
  @override
  String? get label;
  @override
  String? get floor;
  @override
  PropertyType get type;
  @override
  int? get rooms;
  @override
  double? get surfaceM2;
  @override
  num get monthlyRent;
  @override
  num? get monthlyCharges;
  @override
  PropertyStatus get status;
  @override
  String? get description;
  @override
  PropertyUnitCurrentTenantModel? get currentTenant;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of PropertyUnitModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PropertyUnitModelImplCopyWith<_$PropertyUnitModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) {
  return _PropertyModel.fromJson(json);
}

/// @nodoc
mixin _$PropertyModel {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  PropertyType get type => throw _privateConstructorUsedError;
  String get addressLine => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String? get district => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  List<PropertyImageModel>? get images => throw _privateConstructorUsedError;
  List<PropertyUnitModel>? get units => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PropertyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PropertyModelCopyWith<PropertyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertyModelCopyWith<$Res> {
  factory $PropertyModelCopyWith(
    PropertyModel value,
    $Res Function(PropertyModel) then,
  ) = _$PropertyModelCopyWithImpl<$Res, PropertyModel>;
  @useResult
  $Res call({
    String id,
    String organizationId,
    String reference,
    String title,
    String? description,
    PropertyType type,
    String addressLine,
    String city,
    String? district,
    double? latitude,
    double? longitude,
    String ownerId,
    List<PropertyImageModel>? images,
    List<PropertyUnitModel>? units,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$PropertyModelCopyWithImpl<$Res, $Val extends PropertyModel>
    implements $PropertyModelCopyWith<$Res> {
  _$PropertyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? reference = null,
    Object? title = null,
    Object? description = freezed,
    Object? type = null,
    Object? addressLine = null,
    Object? city = null,
    Object? district = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? ownerId = null,
    Object? images = freezed,
    Object? units = freezed,
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
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as PropertyType,
            addressLine: null == addressLine
                ? _value.addressLine
                : addressLine // ignore: cast_nullable_to_non_nullable
                      as String,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
            district: freezed == district
                ? _value.district
                : district // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            ownerId: null == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String,
            images: freezed == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<PropertyImageModel>?,
            units: freezed == units
                ? _value.units
                : units // ignore: cast_nullable_to_non_nullable
                      as List<PropertyUnitModel>?,
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
abstract class _$$PropertyModelImplCopyWith<$Res>
    implements $PropertyModelCopyWith<$Res> {
  factory _$$PropertyModelImplCopyWith(
    _$PropertyModelImpl value,
    $Res Function(_$PropertyModelImpl) then,
  ) = __$$PropertyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String organizationId,
    String reference,
    String title,
    String? description,
    PropertyType type,
    String addressLine,
    String city,
    String? district,
    double? latitude,
    double? longitude,
    String ownerId,
    List<PropertyImageModel>? images,
    List<PropertyUnitModel>? units,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$PropertyModelImplCopyWithImpl<$Res>
    extends _$PropertyModelCopyWithImpl<$Res, _$PropertyModelImpl>
    implements _$$PropertyModelImplCopyWith<$Res> {
  __$$PropertyModelImplCopyWithImpl(
    _$PropertyModelImpl _value,
    $Res Function(_$PropertyModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? reference = null,
    Object? title = null,
    Object? description = freezed,
    Object? type = null,
    Object? addressLine = null,
    Object? city = null,
    Object? district = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? ownerId = null,
    Object? images = freezed,
    Object? units = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$PropertyModelImpl(
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
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as PropertyType,
        addressLine: null == addressLine
            ? _value.addressLine
            : addressLine // ignore: cast_nullable_to_non_nullable
                  as String,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        district: freezed == district
            ? _value.district
            : district // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        ownerId: null == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        images: freezed == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<PropertyImageModel>?,
        units: freezed == units
            ? _value._units
            : units // ignore: cast_nullable_to_non_nullable
                  as List<PropertyUnitModel>?,
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
class _$PropertyModelImpl implements _PropertyModel {
  const _$PropertyModelImpl({
    required this.id,
    required this.organizationId,
    required this.reference,
    required this.title,
    this.description,
    required this.type,
    required this.addressLine,
    required this.city,
    this.district,
    this.latitude,
    this.longitude,
    required this.ownerId,
    final List<PropertyImageModel>? images,
    final List<PropertyUnitModel>? units,
    required this.createdAt,
    required this.updatedAt,
  }) : _images = images,
       _units = units;

  factory _$PropertyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PropertyModelImplFromJson(json);

  @override
  final String id;
  @override
  final String organizationId;
  @override
  final String reference;
  @override
  final String title;
  @override
  final String? description;
  @override
  final PropertyType type;
  @override
  final String addressLine;
  @override
  final String city;
  @override
  final String? district;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String ownerId;
  final List<PropertyImageModel>? _images;
  @override
  List<PropertyImageModel>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<PropertyUnitModel>? _units;
  @override
  List<PropertyUnitModel>? get units {
    final value = _units;
    if (value == null) return null;
    if (_units is EqualUnmodifiableListView) return _units;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PropertyModel(id: $id, organizationId: $organizationId, reference: $reference, title: $title, description: $description, type: $type, addressLine: $addressLine, city: $city, district: $district, latitude: $latitude, longitude: $longitude, ownerId: $ownerId, images: $images, units: $units, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PropertyModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.addressLine, addressLine) ||
                other.addressLine == addressLine) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.district, district) ||
                other.district == district) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(other._units, _units) &&
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
    reference,
    title,
    description,
    type,
    addressLine,
    city,
    district,
    latitude,
    longitude,
    ownerId,
    const DeepCollectionEquality().hash(_images),
    const DeepCollectionEquality().hash(_units),
    createdAt,
    updatedAt,
  );

  /// Create a copy of PropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PropertyModelImplCopyWith<_$PropertyModelImpl> get copyWith =>
      __$$PropertyModelImplCopyWithImpl<_$PropertyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PropertyModelImplToJson(this);
  }
}

abstract class _PropertyModel implements PropertyModel {
  const factory _PropertyModel({
    required final String id,
    required final String organizationId,
    required final String reference,
    required final String title,
    final String? description,
    required final PropertyType type,
    required final String addressLine,
    required final String city,
    final String? district,
    final double? latitude,
    final double? longitude,
    required final String ownerId,
    final List<PropertyImageModel>? images,
    final List<PropertyUnitModel>? units,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$PropertyModelImpl;

  factory _PropertyModel.fromJson(Map<String, dynamic> json) =
      _$PropertyModelImpl.fromJson;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get reference;
  @override
  String get title;
  @override
  String? get description;
  @override
  PropertyType get type;
  @override
  String get addressLine;
  @override
  String get city;
  @override
  String? get district;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String get ownerId;
  @override
  List<PropertyImageModel>? get images;
  @override
  List<PropertyUnitModel>? get units;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of PropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PropertyModelImplCopyWith<_$PropertyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
