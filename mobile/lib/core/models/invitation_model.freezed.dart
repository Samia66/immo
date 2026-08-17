// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invitation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

InvitationPreviewModel _$InvitationPreviewModelFromJson(
  Map<String, dynamic> json,
) {
  return _InvitationPreviewModel.fromJson(json);
}

/// @nodoc
mixin _$InvitationPreviewModel {
  String get leaseReference => throw _privateConstructorUsedError;
  String get unitLabel => throw _privateConstructorUsedError;
  String get propertyTitle => throw _privateConstructorUsedError;
  String get organizationName => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this InvitationPreviewModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InvitationPreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvitationPreviewModelCopyWith<InvitationPreviewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvitationPreviewModelCopyWith<$Res> {
  factory $InvitationPreviewModelCopyWith(
    InvitationPreviewModel value,
    $Res Function(InvitationPreviewModel) then,
  ) = _$InvitationPreviewModelCopyWithImpl<$Res, InvitationPreviewModel>;
  @useResult
  $Res call({
    String leaseReference,
    String unitLabel,
    String propertyTitle,
    String organizationName,
    DateTime expiresAt,
  });
}

/// @nodoc
class _$InvitationPreviewModelCopyWithImpl<
  $Res,
  $Val extends InvitationPreviewModel
>
    implements $InvitationPreviewModelCopyWith<$Res> {
  _$InvitationPreviewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InvitationPreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leaseReference = null,
    Object? unitLabel = null,
    Object? propertyTitle = null,
    Object? organizationName = null,
    Object? expiresAt = null,
  }) {
    return _then(
      _value.copyWith(
            leaseReference: null == leaseReference
                ? _value.leaseReference
                : leaseReference // ignore: cast_nullable_to_non_nullable
                      as String,
            unitLabel: null == unitLabel
                ? _value.unitLabel
                : unitLabel // ignore: cast_nullable_to_non_nullable
                      as String,
            propertyTitle: null == propertyTitle
                ? _value.propertyTitle
                : propertyTitle // ignore: cast_nullable_to_non_nullable
                      as String,
            organizationName: null == organizationName
                ? _value.organizationName
                : organizationName // ignore: cast_nullable_to_non_nullable
                      as String,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InvitationPreviewModelImplCopyWith<$Res>
    implements $InvitationPreviewModelCopyWith<$Res> {
  factory _$$InvitationPreviewModelImplCopyWith(
    _$InvitationPreviewModelImpl value,
    $Res Function(_$InvitationPreviewModelImpl) then,
  ) = __$$InvitationPreviewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String leaseReference,
    String unitLabel,
    String propertyTitle,
    String organizationName,
    DateTime expiresAt,
  });
}

/// @nodoc
class __$$InvitationPreviewModelImplCopyWithImpl<$Res>
    extends
        _$InvitationPreviewModelCopyWithImpl<$Res, _$InvitationPreviewModelImpl>
    implements _$$InvitationPreviewModelImplCopyWith<$Res> {
  __$$InvitationPreviewModelImplCopyWithImpl(
    _$InvitationPreviewModelImpl _value,
    $Res Function(_$InvitationPreviewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InvitationPreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leaseReference = null,
    Object? unitLabel = null,
    Object? propertyTitle = null,
    Object? organizationName = null,
    Object? expiresAt = null,
  }) {
    return _then(
      _$InvitationPreviewModelImpl(
        leaseReference: null == leaseReference
            ? _value.leaseReference
            : leaseReference // ignore: cast_nullable_to_non_nullable
                  as String,
        unitLabel: null == unitLabel
            ? _value.unitLabel
            : unitLabel // ignore: cast_nullable_to_non_nullable
                  as String,
        propertyTitle: null == propertyTitle
            ? _value.propertyTitle
            : propertyTitle // ignore: cast_nullable_to_non_nullable
                  as String,
        organizationName: null == organizationName
            ? _value.organizationName
            : organizationName // ignore: cast_nullable_to_non_nullable
                  as String,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InvitationPreviewModelImpl implements _InvitationPreviewModel {
  const _$InvitationPreviewModelImpl({
    required this.leaseReference,
    required this.unitLabel,
    required this.propertyTitle,
    required this.organizationName,
    required this.expiresAt,
  });

  factory _$InvitationPreviewModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvitationPreviewModelImplFromJson(json);

  @override
  final String leaseReference;
  @override
  final String unitLabel;
  @override
  final String propertyTitle;
  @override
  final String organizationName;
  @override
  final DateTime expiresAt;

  @override
  String toString() {
    return 'InvitationPreviewModel(leaseReference: $leaseReference, unitLabel: $unitLabel, propertyTitle: $propertyTitle, organizationName: $organizationName, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvitationPreviewModelImpl &&
            (identical(other.leaseReference, leaseReference) ||
                other.leaseReference == leaseReference) &&
            (identical(other.unitLabel, unitLabel) ||
                other.unitLabel == unitLabel) &&
            (identical(other.propertyTitle, propertyTitle) ||
                other.propertyTitle == propertyTitle) &&
            (identical(other.organizationName, organizationName) ||
                other.organizationName == organizationName) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    leaseReference,
    unitLabel,
    propertyTitle,
    organizationName,
    expiresAt,
  );

  /// Create a copy of InvitationPreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvitationPreviewModelImplCopyWith<_$InvitationPreviewModelImpl>
  get copyWith =>
      __$$InvitationPreviewModelImplCopyWithImpl<_$InvitationPreviewModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InvitationPreviewModelImplToJson(this);
  }
}

abstract class _InvitationPreviewModel implements InvitationPreviewModel {
  const factory _InvitationPreviewModel({
    required final String leaseReference,
    required final String unitLabel,
    required final String propertyTitle,
    required final String organizationName,
    required final DateTime expiresAt,
  }) = _$InvitationPreviewModelImpl;

  factory _InvitationPreviewModel.fromJson(Map<String, dynamic> json) =
      _$InvitationPreviewModelImpl.fromJson;

  @override
  String get leaseReference;
  @override
  String get unitLabel;
  @override
  String get propertyTitle;
  @override
  String get organizationName;
  @override
  DateTime get expiresAt;

  /// Create a copy of InvitationPreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvitationPreviewModelImplCopyWith<_$InvitationPreviewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
