// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_service_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AIServiceConfig _$AIServiceConfigFromJson(Map<String, dynamic> json) {
  return _AIServiceConfig.fromJson(json);
}

/// @nodoc
mixin _$AIServiceConfig {
  String get id => throw _privateConstructorUsedError;
  AIServiceType get serviceType => throw _privateConstructorUsedError;
  String get providerKey => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  String? get customBaseUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AIServiceConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIServiceConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIServiceConfigCopyWith<AIServiceConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIServiceConfigCopyWith<$Res> {
  factory $AIServiceConfigCopyWith(
          AIServiceConfig value, $Res Function(AIServiceConfig) then) =
      _$AIServiceConfigCopyWithImpl<$Res, AIServiceConfig>;
  @useResult
  $Res call(
      {String id,
      AIServiceType serviceType,
      String providerKey,
      String displayName,
      String model,
      String? customBaseUrl,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$AIServiceConfigCopyWithImpl<$Res, $Val extends AIServiceConfig>
    implements $AIServiceConfigCopyWith<$Res> {
  _$AIServiceConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIServiceConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceType = null,
    Object? providerKey = null,
    Object? displayName = null,
    Object? model = null,
    Object? customBaseUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      serviceType: null == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as AIServiceType,
      providerKey: null == providerKey
          ? _value.providerKey
          : providerKey // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      customBaseUrl: freezed == customBaseUrl
          ? _value.customBaseUrl
          : customBaseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AIServiceConfigImplCopyWith<$Res>
    implements $AIServiceConfigCopyWith<$Res> {
  factory _$$AIServiceConfigImplCopyWith(_$AIServiceConfigImpl value,
          $Res Function(_$AIServiceConfigImpl) then) =
      __$$AIServiceConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      AIServiceType serviceType,
      String providerKey,
      String displayName,
      String model,
      String? customBaseUrl,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$AIServiceConfigImplCopyWithImpl<$Res>
    extends _$AIServiceConfigCopyWithImpl<$Res, _$AIServiceConfigImpl>
    implements _$$AIServiceConfigImplCopyWith<$Res> {
  __$$AIServiceConfigImplCopyWithImpl(
      _$AIServiceConfigImpl _value, $Res Function(_$AIServiceConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of AIServiceConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceType = null,
    Object? providerKey = null,
    Object? displayName = null,
    Object? model = null,
    Object? customBaseUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$AIServiceConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      serviceType: null == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as AIServiceType,
      providerKey: null == providerKey
          ? _value.providerKey
          : providerKey // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      customBaseUrl: freezed == customBaseUrl
          ? _value.customBaseUrl
          : customBaseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AIServiceConfigImpl implements _AIServiceConfig {
  const _$AIServiceConfigImpl(
      {required this.id,
      required this.serviceType,
      required this.providerKey,
      required this.displayName,
      required this.model,
      this.customBaseUrl,
      required this.createdAt,
      required this.updatedAt});

  factory _$AIServiceConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIServiceConfigImplFromJson(json);

  @override
  final String id;
  @override
  final AIServiceType serviceType;
  @override
  final String providerKey;
  @override
  final String displayName;
  @override
  final String model;
  @override
  final String? customBaseUrl;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'AIServiceConfig(id: $id, serviceType: $serviceType, providerKey: $providerKey, displayName: $displayName, model: $model, customBaseUrl: $customBaseUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIServiceConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            (identical(other.providerKey, providerKey) ||
                other.providerKey == providerKey) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.customBaseUrl, customBaseUrl) ||
                other.customBaseUrl == customBaseUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, serviceType, providerKey,
      displayName, model, customBaseUrl, createdAt, updatedAt);

  /// Create a copy of AIServiceConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIServiceConfigImplCopyWith<_$AIServiceConfigImpl> get copyWith =>
      __$$AIServiceConfigImplCopyWithImpl<_$AIServiceConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIServiceConfigImplToJson(
      this,
    );
  }
}

abstract class _AIServiceConfig implements AIServiceConfig {
  const factory _AIServiceConfig(
      {required final String id,
      required final AIServiceType serviceType,
      required final String providerKey,
      required final String displayName,
      required final String model,
      final String? customBaseUrl,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$AIServiceConfigImpl;

  factory _AIServiceConfig.fromJson(Map<String, dynamic> json) =
      _$AIServiceConfigImpl.fromJson;

  @override
  String get id;
  @override
  AIServiceType get serviceType;
  @override
  String get providerKey;
  @override
  String get displayName;
  @override
  String get model;
  @override
  String? get customBaseUrl;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of AIServiceConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIServiceConfigImplCopyWith<_$AIServiceConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
