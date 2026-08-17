// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maintenance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TenantSummaryModel _$TenantSummaryModelFromJson(Map<String, dynamic> json) {
  return _TenantSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$TenantSummaryModel {
  String get id => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;

  /// Serializes this TenantSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TenantSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TenantSummaryModelCopyWith<TenantSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TenantSummaryModelCopyWith<$Res> {
  factory $TenantSummaryModelCopyWith(
    TenantSummaryModel value,
    $Res Function(TenantSummaryModel) then,
  ) = _$TenantSummaryModelCopyWithImpl<$Res, TenantSummaryModel>;
  @useResult
  $Res call({String id, String fullName, String? phone});
}

/// @nodoc
class _$TenantSummaryModelCopyWithImpl<$Res, $Val extends TenantSummaryModel>
    implements $TenantSummaryModelCopyWith<$Res> {
  _$TenantSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TenantSummaryModel
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
abstract class _$$TenantSummaryModelImplCopyWith<$Res>
    implements $TenantSummaryModelCopyWith<$Res> {
  factory _$$TenantSummaryModelImplCopyWith(
    _$TenantSummaryModelImpl value,
    $Res Function(_$TenantSummaryModelImpl) then,
  ) = __$$TenantSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String fullName, String? phone});
}

/// @nodoc
class __$$TenantSummaryModelImplCopyWithImpl<$Res>
    extends _$TenantSummaryModelCopyWithImpl<$Res, _$TenantSummaryModelImpl>
    implements _$$TenantSummaryModelImplCopyWith<$Res> {
  __$$TenantSummaryModelImplCopyWithImpl(
    _$TenantSummaryModelImpl _value,
    $Res Function(_$TenantSummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TenantSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? phone = freezed,
  }) {
    return _then(
      _$TenantSummaryModelImpl(
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
class _$TenantSummaryModelImpl implements _TenantSummaryModel {
  const _$TenantSummaryModelImpl({
    required this.id,
    required this.fullName,
    this.phone,
  });

  factory _$TenantSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TenantSummaryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String fullName;
  @override
  final String? phone;

  @override
  String toString() {
    return 'TenantSummaryModel(id: $id, fullName: $fullName, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TenantSummaryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, fullName, phone);

  /// Create a copy of TenantSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TenantSummaryModelImplCopyWith<_$TenantSummaryModelImpl> get copyWith =>
      __$$TenantSummaryModelImplCopyWithImpl<_$TenantSummaryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TenantSummaryModelImplToJson(this);
  }
}

abstract class _TenantSummaryModel implements TenantSummaryModel {
  const factory _TenantSummaryModel({
    required final String id,
    required final String fullName,
    final String? phone,
  }) = _$TenantSummaryModelImpl;

  factory _TenantSummaryModel.fromJson(Map<String, dynamic> json) =
      _$TenantSummaryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get fullName;
  @override
  String? get phone;

  /// Create a copy of TenantSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TenantSummaryModelImplCopyWith<_$TenantSummaryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MaintenancePropertySummaryModel _$MaintenancePropertySummaryModelFromJson(
  Map<String, dynamic> json,
) {
  return _MaintenancePropertySummaryModel.fromJson(json);
}

/// @nodoc
mixin _$MaintenancePropertySummaryModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;

  /// Serializes this MaintenancePropertySummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MaintenancePropertySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MaintenancePropertySummaryModelCopyWith<MaintenancePropertySummaryModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MaintenancePropertySummaryModelCopyWith<$Res> {
  factory $MaintenancePropertySummaryModelCopyWith(
    MaintenancePropertySummaryModel value,
    $Res Function(MaintenancePropertySummaryModel) then,
  ) =
      _$MaintenancePropertySummaryModelCopyWithImpl<
        $Res,
        MaintenancePropertySummaryModel
      >;
  @useResult
  $Res call({String id, String title});
}

/// @nodoc
class _$MaintenancePropertySummaryModelCopyWithImpl<
  $Res,
  $Val extends MaintenancePropertySummaryModel
>
    implements $MaintenancePropertySummaryModelCopyWith<$Res> {
  _$MaintenancePropertySummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MaintenancePropertySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? title = null}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MaintenancePropertySummaryModelImplCopyWith<$Res>
    implements $MaintenancePropertySummaryModelCopyWith<$Res> {
  factory _$$MaintenancePropertySummaryModelImplCopyWith(
    _$MaintenancePropertySummaryModelImpl value,
    $Res Function(_$MaintenancePropertySummaryModelImpl) then,
  ) = __$$MaintenancePropertySummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String title});
}

/// @nodoc
class __$$MaintenancePropertySummaryModelImplCopyWithImpl<$Res>
    extends
        _$MaintenancePropertySummaryModelCopyWithImpl<
          $Res,
          _$MaintenancePropertySummaryModelImpl
        >
    implements _$$MaintenancePropertySummaryModelImplCopyWith<$Res> {
  __$$MaintenancePropertySummaryModelImplCopyWithImpl(
    _$MaintenancePropertySummaryModelImpl _value,
    $Res Function(_$MaintenancePropertySummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MaintenancePropertySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? title = null}) {
    return _then(
      _$MaintenancePropertySummaryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MaintenancePropertySummaryModelImpl
    implements _MaintenancePropertySummaryModel {
  const _$MaintenancePropertySummaryModelImpl({
    required this.id,
    required this.title,
  });

  factory _$MaintenancePropertySummaryModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$MaintenancePropertySummaryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;

  @override
  String toString() {
    return 'MaintenancePropertySummaryModel(id: $id, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MaintenancePropertySummaryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title);

  /// Create a copy of MaintenancePropertySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MaintenancePropertySummaryModelImplCopyWith<
    _$MaintenancePropertySummaryModelImpl
  >
  get copyWith =>
      __$$MaintenancePropertySummaryModelImplCopyWithImpl<
        _$MaintenancePropertySummaryModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MaintenancePropertySummaryModelImplToJson(this);
  }
}

abstract class _MaintenancePropertySummaryModel
    implements MaintenancePropertySummaryModel {
  const factory _MaintenancePropertySummaryModel({
    required final String id,
    required final String title,
  }) = _$MaintenancePropertySummaryModelImpl;

  factory _MaintenancePropertySummaryModel.fromJson(Map<String, dynamic> json) =
      _$MaintenancePropertySummaryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;

  /// Create a copy of MaintenancePropertySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MaintenancePropertySummaryModelImplCopyWith<
    _$MaintenancePropertySummaryModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

MaintenanceUnitSummaryModel _$MaintenanceUnitSummaryModelFromJson(
  Map<String, dynamic> json,
) {
  return _MaintenanceUnitSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$MaintenanceUnitSummaryModel {
  String get id => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;
  MaintenancePropertySummaryModel get property =>
      throw _privateConstructorUsedError;

  /// Serializes this MaintenanceUnitSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MaintenanceUnitSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MaintenanceUnitSummaryModelCopyWith<MaintenanceUnitSummaryModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MaintenanceUnitSummaryModelCopyWith<$Res> {
  factory $MaintenanceUnitSummaryModelCopyWith(
    MaintenanceUnitSummaryModel value,
    $Res Function(MaintenanceUnitSummaryModel) then,
  ) =
      _$MaintenanceUnitSummaryModelCopyWithImpl<
        $Res,
        MaintenanceUnitSummaryModel
      >;
  @useResult
  $Res call({
    String id,
    String reference,
    String? label,
    MaintenancePropertySummaryModel property,
  });

  $MaintenancePropertySummaryModelCopyWith<$Res> get property;
}

/// @nodoc
class _$MaintenanceUnitSummaryModelCopyWithImpl<
  $Res,
  $Val extends MaintenanceUnitSummaryModel
>
    implements $MaintenanceUnitSummaryModelCopyWith<$Res> {
  _$MaintenanceUnitSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MaintenanceUnitSummaryModel
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
                      as MaintenancePropertySummaryModel,
          )
          as $Val,
    );
  }

  /// Create a copy of MaintenanceUnitSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MaintenancePropertySummaryModelCopyWith<$Res> get property {
    return $MaintenancePropertySummaryModelCopyWith<$Res>(_value.property, (
      value,
    ) {
      return _then(_value.copyWith(property: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MaintenanceUnitSummaryModelImplCopyWith<$Res>
    implements $MaintenanceUnitSummaryModelCopyWith<$Res> {
  factory _$$MaintenanceUnitSummaryModelImplCopyWith(
    _$MaintenanceUnitSummaryModelImpl value,
    $Res Function(_$MaintenanceUnitSummaryModelImpl) then,
  ) = __$$MaintenanceUnitSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String reference,
    String? label,
    MaintenancePropertySummaryModel property,
  });

  @override
  $MaintenancePropertySummaryModelCopyWith<$Res> get property;
}

/// @nodoc
class __$$MaintenanceUnitSummaryModelImplCopyWithImpl<$Res>
    extends
        _$MaintenanceUnitSummaryModelCopyWithImpl<
          $Res,
          _$MaintenanceUnitSummaryModelImpl
        >
    implements _$$MaintenanceUnitSummaryModelImplCopyWith<$Res> {
  __$$MaintenanceUnitSummaryModelImplCopyWithImpl(
    _$MaintenanceUnitSummaryModelImpl _value,
    $Res Function(_$MaintenanceUnitSummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MaintenanceUnitSummaryModel
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
      _$MaintenanceUnitSummaryModelImpl(
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
                  as MaintenancePropertySummaryModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MaintenanceUnitSummaryModelImpl
    implements _MaintenanceUnitSummaryModel {
  const _$MaintenanceUnitSummaryModelImpl({
    required this.id,
    required this.reference,
    this.label,
    required this.property,
  });

  factory _$MaintenanceUnitSummaryModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$MaintenanceUnitSummaryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String reference;
  @override
  final String? label;
  @override
  final MaintenancePropertySummaryModel property;

  @override
  String toString() {
    return 'MaintenanceUnitSummaryModel(id: $id, reference: $reference, label: $label, property: $property)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MaintenanceUnitSummaryModelImpl &&
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

  /// Create a copy of MaintenanceUnitSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MaintenanceUnitSummaryModelImplCopyWith<_$MaintenanceUnitSummaryModelImpl>
  get copyWith =>
      __$$MaintenanceUnitSummaryModelImplCopyWithImpl<
        _$MaintenanceUnitSummaryModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MaintenanceUnitSummaryModelImplToJson(this);
  }
}

abstract class _MaintenanceUnitSummaryModel
    implements MaintenanceUnitSummaryModel {
  const factory _MaintenanceUnitSummaryModel({
    required final String id,
    required final String reference,
    final String? label,
    required final MaintenancePropertySummaryModel property,
  }) = _$MaintenanceUnitSummaryModelImpl;

  factory _MaintenanceUnitSummaryModel.fromJson(Map<String, dynamic> json) =
      _$MaintenanceUnitSummaryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get reference;
  @override
  String? get label;
  @override
  MaintenancePropertySummaryModel get property;

  /// Create a copy of MaintenanceUnitSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MaintenanceUnitSummaryModelImplCopyWith<_$MaintenanceUnitSummaryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

MaintenanceAttachmentModel _$MaintenanceAttachmentModelFromJson(
  Map<String, dynamic> json,
) {
  return _MaintenanceAttachmentModel.fromJson(json);
}

/// @nodoc
mixin _$MaintenanceAttachmentModel {
  String get id => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String get phase => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this MaintenanceAttachmentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MaintenanceAttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MaintenanceAttachmentModelCopyWith<MaintenanceAttachmentModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MaintenanceAttachmentModelCopyWith<$Res> {
  factory $MaintenanceAttachmentModelCopyWith(
    MaintenanceAttachmentModel value,
    $Res Function(MaintenanceAttachmentModel) then,
  ) =
      _$MaintenanceAttachmentModelCopyWithImpl<
        $Res,
        MaintenanceAttachmentModel
      >;
  @useResult
  $Res call({String id, String url, String phase, DateTime createdAt});
}

/// @nodoc
class _$MaintenanceAttachmentModelCopyWithImpl<
  $Res,
  $Val extends MaintenanceAttachmentModel
>
    implements $MaintenanceAttachmentModelCopyWith<$Res> {
  _$MaintenanceAttachmentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MaintenanceAttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? phase = null,
    Object? createdAt = null,
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
            phase: null == phase
                ? _value.phase
                : phase // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MaintenanceAttachmentModelImplCopyWith<$Res>
    implements $MaintenanceAttachmentModelCopyWith<$Res> {
  factory _$$MaintenanceAttachmentModelImplCopyWith(
    _$MaintenanceAttachmentModelImpl value,
    $Res Function(_$MaintenanceAttachmentModelImpl) then,
  ) = __$$MaintenanceAttachmentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String url, String phase, DateTime createdAt});
}

/// @nodoc
class __$$MaintenanceAttachmentModelImplCopyWithImpl<$Res>
    extends
        _$MaintenanceAttachmentModelCopyWithImpl<
          $Res,
          _$MaintenanceAttachmentModelImpl
        >
    implements _$$MaintenanceAttachmentModelImplCopyWith<$Res> {
  __$$MaintenanceAttachmentModelImplCopyWithImpl(
    _$MaintenanceAttachmentModelImpl _value,
    $Res Function(_$MaintenanceAttachmentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MaintenanceAttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? phase = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$MaintenanceAttachmentModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        phase: null == phase
            ? _value.phase
            : phase // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MaintenanceAttachmentModelImpl implements _MaintenanceAttachmentModel {
  const _$MaintenanceAttachmentModelImpl({
    required this.id,
    required this.url,
    required this.phase,
    required this.createdAt,
  });

  factory _$MaintenanceAttachmentModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$MaintenanceAttachmentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String url;
  @override
  final String phase;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'MaintenanceAttachmentModel(id: $id, url: $url, phase: $phase, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MaintenanceAttachmentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.phase, phase) || other.phase == phase) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, url, phase, createdAt);

  /// Create a copy of MaintenanceAttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MaintenanceAttachmentModelImplCopyWith<_$MaintenanceAttachmentModelImpl>
  get copyWith =>
      __$$MaintenanceAttachmentModelImplCopyWithImpl<
        _$MaintenanceAttachmentModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MaintenanceAttachmentModelImplToJson(this);
  }
}

abstract class _MaintenanceAttachmentModel
    implements MaintenanceAttachmentModel {
  const factory _MaintenanceAttachmentModel({
    required final String id,
    required final String url,
    required final String phase,
    required final DateTime createdAt,
  }) = _$MaintenanceAttachmentModelImpl;

  factory _MaintenanceAttachmentModel.fromJson(Map<String, dynamic> json) =
      _$MaintenanceAttachmentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get url;
  @override
  String get phase;
  @override
  DateTime get createdAt;

  /// Create a copy of MaintenanceAttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MaintenanceAttachmentModelImplCopyWith<_$MaintenanceAttachmentModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

MaintenanceRequestModel _$MaintenanceRequestModelFromJson(
  Map<String, dynamic> json,
) {
  return _MaintenanceRequestModel.fromJson(json);
}

/// @nodoc
mixin _$MaintenanceRequestModel {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get propertyUnitId => throw _privateConstructorUsedError;
  MaintenanceUnitSummaryModel? get propertyUnit =>
      throw _privateConstructorUsedError;
  String? get tenantId => throw _privateConstructorUsedError;
  TenantSummaryModel? get tenant => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  MaintenancePriority get priority => throw _privateConstructorUsedError;
  MaintenanceStatus get status => throw _privateConstructorUsedError;
  String? get assignedToId => throw _privateConstructorUsedError;
  num? get estimatedCost => throw _privateConstructorUsedError;
  num? get actualCost => throw _privateConstructorUsedError;
  DateTime? get scheduledAt => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  List<MaintenanceAttachmentModel>? get attachments =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MaintenanceRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MaintenanceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MaintenanceRequestModelCopyWith<MaintenanceRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MaintenanceRequestModelCopyWith<$Res> {
  factory $MaintenanceRequestModelCopyWith(
    MaintenanceRequestModel value,
    $Res Function(MaintenanceRequestModel) then,
  ) = _$MaintenanceRequestModelCopyWithImpl<$Res, MaintenanceRequestModel>;
  @useResult
  $Res call({
    String id,
    String organizationId,
    String propertyUnitId,
    MaintenanceUnitSummaryModel? propertyUnit,
    String? tenantId,
    TenantSummaryModel? tenant,
    String category,
    String description,
    MaintenancePriority priority,
    MaintenanceStatus status,
    String? assignedToId,
    num? estimatedCost,
    num? actualCost,
    DateTime? scheduledAt,
    DateTime? startedAt,
    DateTime? completedAt,
    List<MaintenanceAttachmentModel>? attachments,
    DateTime createdAt,
    DateTime updatedAt,
  });

  $MaintenanceUnitSummaryModelCopyWith<$Res>? get propertyUnit;
  $TenantSummaryModelCopyWith<$Res>? get tenant;
}

/// @nodoc
class _$MaintenanceRequestModelCopyWithImpl<
  $Res,
  $Val extends MaintenanceRequestModel
>
    implements $MaintenanceRequestModelCopyWith<$Res> {
  _$MaintenanceRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MaintenanceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? propertyUnitId = null,
    Object? propertyUnit = freezed,
    Object? tenantId = freezed,
    Object? tenant = freezed,
    Object? category = null,
    Object? description = null,
    Object? priority = null,
    Object? status = null,
    Object? assignedToId = freezed,
    Object? estimatedCost = freezed,
    Object? actualCost = freezed,
    Object? scheduledAt = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? attachments = freezed,
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
            propertyUnitId: null == propertyUnitId
                ? _value.propertyUnitId
                : propertyUnitId // ignore: cast_nullable_to_non_nullable
                      as String,
            propertyUnit: freezed == propertyUnit
                ? _value.propertyUnit
                : propertyUnit // ignore: cast_nullable_to_non_nullable
                      as MaintenanceUnitSummaryModel?,
            tenantId: freezed == tenantId
                ? _value.tenantId
                : tenantId // ignore: cast_nullable_to_non_nullable
                      as String?,
            tenant: freezed == tenant
                ? _value.tenant
                : tenant // ignore: cast_nullable_to_non_nullable
                      as TenantSummaryModel?,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as MaintenancePriority,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as MaintenanceStatus,
            assignedToId: freezed == assignedToId
                ? _value.assignedToId
                : assignedToId // ignore: cast_nullable_to_non_nullable
                      as String?,
            estimatedCost: freezed == estimatedCost
                ? _value.estimatedCost
                : estimatedCost // ignore: cast_nullable_to_non_nullable
                      as num?,
            actualCost: freezed == actualCost
                ? _value.actualCost
                : actualCost // ignore: cast_nullable_to_non_nullable
                      as num?,
            scheduledAt: freezed == scheduledAt
                ? _value.scheduledAt
                : scheduledAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            startedAt: freezed == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            attachments: freezed == attachments
                ? _value.attachments
                : attachments // ignore: cast_nullable_to_non_nullable
                      as List<MaintenanceAttachmentModel>?,
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

  /// Create a copy of MaintenanceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MaintenanceUnitSummaryModelCopyWith<$Res>? get propertyUnit {
    if (_value.propertyUnit == null) {
      return null;
    }

    return $MaintenanceUnitSummaryModelCopyWith<$Res>(_value.propertyUnit!, (
      value,
    ) {
      return _then(_value.copyWith(propertyUnit: value) as $Val);
    });
  }

  /// Create a copy of MaintenanceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TenantSummaryModelCopyWith<$Res>? get tenant {
    if (_value.tenant == null) {
      return null;
    }

    return $TenantSummaryModelCopyWith<$Res>(_value.tenant!, (value) {
      return _then(_value.copyWith(tenant: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MaintenanceRequestModelImplCopyWith<$Res>
    implements $MaintenanceRequestModelCopyWith<$Res> {
  factory _$$MaintenanceRequestModelImplCopyWith(
    _$MaintenanceRequestModelImpl value,
    $Res Function(_$MaintenanceRequestModelImpl) then,
  ) = __$$MaintenanceRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String organizationId,
    String propertyUnitId,
    MaintenanceUnitSummaryModel? propertyUnit,
    String? tenantId,
    TenantSummaryModel? tenant,
    String category,
    String description,
    MaintenancePriority priority,
    MaintenanceStatus status,
    String? assignedToId,
    num? estimatedCost,
    num? actualCost,
    DateTime? scheduledAt,
    DateTime? startedAt,
    DateTime? completedAt,
    List<MaintenanceAttachmentModel>? attachments,
    DateTime createdAt,
    DateTime updatedAt,
  });

  @override
  $MaintenanceUnitSummaryModelCopyWith<$Res>? get propertyUnit;
  @override
  $TenantSummaryModelCopyWith<$Res>? get tenant;
}

/// @nodoc
class __$$MaintenanceRequestModelImplCopyWithImpl<$Res>
    extends
        _$MaintenanceRequestModelCopyWithImpl<
          $Res,
          _$MaintenanceRequestModelImpl
        >
    implements _$$MaintenanceRequestModelImplCopyWith<$Res> {
  __$$MaintenanceRequestModelImplCopyWithImpl(
    _$MaintenanceRequestModelImpl _value,
    $Res Function(_$MaintenanceRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MaintenanceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? propertyUnitId = null,
    Object? propertyUnit = freezed,
    Object? tenantId = freezed,
    Object? tenant = freezed,
    Object? category = null,
    Object? description = null,
    Object? priority = null,
    Object? status = null,
    Object? assignedToId = freezed,
    Object? estimatedCost = freezed,
    Object? actualCost = freezed,
    Object? scheduledAt = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? attachments = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$MaintenanceRequestModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        organizationId: null == organizationId
            ? _value.organizationId
            : organizationId // ignore: cast_nullable_to_non_nullable
                  as String,
        propertyUnitId: null == propertyUnitId
            ? _value.propertyUnitId
            : propertyUnitId // ignore: cast_nullable_to_non_nullable
                  as String,
        propertyUnit: freezed == propertyUnit
            ? _value.propertyUnit
            : propertyUnit // ignore: cast_nullable_to_non_nullable
                  as MaintenanceUnitSummaryModel?,
        tenantId: freezed == tenantId
            ? _value.tenantId
            : tenantId // ignore: cast_nullable_to_non_nullable
                  as String?,
        tenant: freezed == tenant
            ? _value.tenant
            : tenant // ignore: cast_nullable_to_non_nullable
                  as TenantSummaryModel?,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as MaintenancePriority,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as MaintenanceStatus,
        assignedToId: freezed == assignedToId
            ? _value.assignedToId
            : assignedToId // ignore: cast_nullable_to_non_nullable
                  as String?,
        estimatedCost: freezed == estimatedCost
            ? _value.estimatedCost
            : estimatedCost // ignore: cast_nullable_to_non_nullable
                  as num?,
        actualCost: freezed == actualCost
            ? _value.actualCost
            : actualCost // ignore: cast_nullable_to_non_nullable
                  as num?,
        scheduledAt: freezed == scheduledAt
            ? _value.scheduledAt
            : scheduledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        startedAt: freezed == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        attachments: freezed == attachments
            ? _value._attachments
            : attachments // ignore: cast_nullable_to_non_nullable
                  as List<MaintenanceAttachmentModel>?,
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
class _$MaintenanceRequestModelImpl implements _MaintenanceRequestModel {
  const _$MaintenanceRequestModelImpl({
    required this.id,
    required this.organizationId,
    required this.propertyUnitId,
    this.propertyUnit,
    this.tenantId,
    this.tenant,
    required this.category,
    required this.description,
    required this.priority,
    required this.status,
    this.assignedToId,
    this.estimatedCost,
    this.actualCost,
    this.scheduledAt,
    this.startedAt,
    this.completedAt,
    final List<MaintenanceAttachmentModel>? attachments,
    required this.createdAt,
    required this.updatedAt,
  }) : _attachments = attachments;

  factory _$MaintenanceRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MaintenanceRequestModelImplFromJson(json);

  @override
  final String id;
  @override
  final String organizationId;
  @override
  final String propertyUnitId;
  @override
  final MaintenanceUnitSummaryModel? propertyUnit;
  @override
  final String? tenantId;
  @override
  final TenantSummaryModel? tenant;
  @override
  final String category;
  @override
  final String description;
  @override
  final MaintenancePriority priority;
  @override
  final MaintenanceStatus status;
  @override
  final String? assignedToId;
  @override
  final num? estimatedCost;
  @override
  final num? actualCost;
  @override
  final DateTime? scheduledAt;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? completedAt;
  final List<MaintenanceAttachmentModel>? _attachments;
  @override
  List<MaintenanceAttachmentModel>? get attachments {
    final value = _attachments;
    if (value == null) return null;
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'MaintenanceRequestModel(id: $id, organizationId: $organizationId, propertyUnitId: $propertyUnitId, propertyUnit: $propertyUnit, tenantId: $tenantId, tenant: $tenant, category: $category, description: $description, priority: $priority, status: $status, assignedToId: $assignedToId, estimatedCost: $estimatedCost, actualCost: $actualCost, scheduledAt: $scheduledAt, startedAt: $startedAt, completedAt: $completedAt, attachments: $attachments, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MaintenanceRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.propertyUnitId, propertyUnitId) ||
                other.propertyUnitId == propertyUnitId) &&
            (identical(other.propertyUnit, propertyUnit) ||
                other.propertyUnit == propertyUnit) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.tenant, tenant) || other.tenant == tenant) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.assignedToId, assignedToId) ||
                other.assignedToId == assignedToId) &&
            (identical(other.estimatedCost, estimatedCost) ||
                other.estimatedCost == estimatedCost) &&
            (identical(other.actualCost, actualCost) ||
                other.actualCost == actualCost) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            const DeepCollectionEquality().equals(
              other._attachments,
              _attachments,
            ) &&
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
    propertyUnitId,
    propertyUnit,
    tenantId,
    tenant,
    category,
    description,
    priority,
    status,
    assignedToId,
    estimatedCost,
    actualCost,
    scheduledAt,
    startedAt,
    completedAt,
    const DeepCollectionEquality().hash(_attachments),
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of MaintenanceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MaintenanceRequestModelImplCopyWith<_$MaintenanceRequestModelImpl>
  get copyWith =>
      __$$MaintenanceRequestModelImplCopyWithImpl<
        _$MaintenanceRequestModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MaintenanceRequestModelImplToJson(this);
  }
}

abstract class _MaintenanceRequestModel implements MaintenanceRequestModel {
  const factory _MaintenanceRequestModel({
    required final String id,
    required final String organizationId,
    required final String propertyUnitId,
    final MaintenanceUnitSummaryModel? propertyUnit,
    final String? tenantId,
    final TenantSummaryModel? tenant,
    required final String category,
    required final String description,
    required final MaintenancePriority priority,
    required final MaintenanceStatus status,
    final String? assignedToId,
    final num? estimatedCost,
    final num? actualCost,
    final DateTime? scheduledAt,
    final DateTime? startedAt,
    final DateTime? completedAt,
    final List<MaintenanceAttachmentModel>? attachments,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$MaintenanceRequestModelImpl;

  factory _MaintenanceRequestModel.fromJson(Map<String, dynamic> json) =
      _$MaintenanceRequestModelImpl.fromJson;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get propertyUnitId;
  @override
  MaintenanceUnitSummaryModel? get propertyUnit;
  @override
  String? get tenantId;
  @override
  TenantSummaryModel? get tenant;
  @override
  String get category;
  @override
  String get description;
  @override
  MaintenancePriority get priority;
  @override
  MaintenanceStatus get status;
  @override
  String? get assignedToId;
  @override
  num? get estimatedCost;
  @override
  num? get actualCost;
  @override
  DateTime? get scheduledAt;
  @override
  DateTime? get startedAt;
  @override
  DateTime? get completedAt;
  @override
  List<MaintenanceAttachmentModel>? get attachments;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of MaintenanceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MaintenanceRequestModelImplCopyWith<_$MaintenanceRequestModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
