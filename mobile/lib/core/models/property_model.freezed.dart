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
  PropertyStatus get status => throw _privateConstructorUsedError;
  String get addressLine => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String? get district => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  int? get rooms => throw _privateConstructorUsedError;
  double? get surfaceM2 => throw _privateConstructorUsedError;
  num get monthlyRent => throw _privateConstructorUsedError;
  num? get monthlyCharges => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  List<PropertyImageModel>? get images => throw _privateConstructorUsedError;
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
    PropertyStatus status,
    String addressLine,
    String city,
    String? district,
    double? latitude,
    double? longitude,
    int? rooms,
    double? surfaceM2,
    num monthlyRent,
    num? monthlyCharges,
    String ownerId,
    List<PropertyImageModel>? images,
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
    Object? status = null,
    Object? addressLine = null,
    Object? city = null,
    Object? district = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? rooms = freezed,
    Object? surfaceM2 = freezed,
    Object? monthlyRent = null,
    Object? monthlyCharges = freezed,
    Object? ownerId = null,
    Object? images = freezed,
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
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as PropertyStatus,
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
            ownerId: null == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String,
            images: freezed == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<PropertyImageModel>?,
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
    PropertyStatus status,
    String addressLine,
    String city,
    String? district,
    double? latitude,
    double? longitude,
    int? rooms,
    double? surfaceM2,
    num monthlyRent,
    num? monthlyCharges,
    String ownerId,
    List<PropertyImageModel>? images,
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
    Object? status = null,
    Object? addressLine = null,
    Object? city = null,
    Object? district = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? rooms = freezed,
    Object? surfaceM2 = freezed,
    Object? monthlyRent = null,
    Object? monthlyCharges = freezed,
    Object? ownerId = null,
    Object? images = freezed,
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
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PropertyStatus,
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
        ownerId: null == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        images: freezed == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<PropertyImageModel>?,
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
    required this.status,
    required this.addressLine,
    required this.city,
    this.district,
    this.latitude,
    this.longitude,
    this.rooms,
    this.surfaceM2,
    required this.monthlyRent,
    this.monthlyCharges,
    required this.ownerId,
    final List<PropertyImageModel>? images,
    required this.createdAt,
    required this.updatedAt,
  }) : _images = images;

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
  final PropertyStatus status;
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
  final int? rooms;
  @override
  final double? surfaceM2;
  @override
  final num monthlyRent;
  @override
  final num? monthlyCharges;
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

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PropertyModel(id: $id, organizationId: $organizationId, reference: $reference, title: $title, description: $description, type: $type, status: $status, addressLine: $addressLine, city: $city, district: $district, latitude: $latitude, longitude: $longitude, rooms: $rooms, surfaceM2: $surfaceM2, monthlyRent: $monthlyRent, monthlyCharges: $monthlyCharges, ownerId: $ownerId, images: $images, createdAt: $createdAt, updatedAt: $updatedAt)';
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
            (identical(other.status, status) || other.status == status) &&
            (identical(other.addressLine, addressLine) ||
                other.addressLine == addressLine) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.district, district) ||
                other.district == district) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.rooms, rooms) || other.rooms == rooms) &&
            (identical(other.surfaceM2, surfaceM2) ||
                other.surfaceM2 == surfaceM2) &&
            (identical(other.monthlyRent, monthlyRent) ||
                other.monthlyRent == monthlyRent) &&
            (identical(other.monthlyCharges, monthlyCharges) ||
                other.monthlyCharges == monthlyCharges) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
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
    title,
    description,
    type,
    status,
    addressLine,
    city,
    district,
    latitude,
    longitude,
    rooms,
    surfaceM2,
    monthlyRent,
    monthlyCharges,
    ownerId,
    const DeepCollectionEquality().hash(_images),
    createdAt,
    updatedAt,
  ]);

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
    required final PropertyStatus status,
    required final String addressLine,
    required final String city,
    final String? district,
    final double? latitude,
    final double? longitude,
    final int? rooms,
    final double? surfaceM2,
    required final num monthlyRent,
    final num? monthlyCharges,
    required final String ownerId,
    final List<PropertyImageModel>? images,
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
  PropertyStatus get status;
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
  int? get rooms;
  @override
  double? get surfaceM2;
  @override
  num get monthlyRent;
  @override
  num? get monthlyCharges;
  @override
  String get ownerId;
  @override
  List<PropertyImageModel>? get images;
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
