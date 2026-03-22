// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_config_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ActiveConfigResult {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AIServiceConfig config, String apiKey) configured,
    required TResult Function() noActiveConfig,
    required TResult Function(AIServiceConfig config) missingKey,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AIServiceConfig config, String apiKey)? configured,
    TResult? Function()? noActiveConfig,
    TResult? Function(AIServiceConfig config)? missingKey,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AIServiceConfig config, String apiKey)? configured,
    TResult Function()? noActiveConfig,
    TResult Function(AIServiceConfig config)? missingKey,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ConfiguredResult value) configured,
    required TResult Function(NoActiveConfigResult value) noActiveConfig,
    required TResult Function(MissingKeyResult value) missingKey,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ConfiguredResult value)? configured,
    TResult? Function(NoActiveConfigResult value)? noActiveConfig,
    TResult? Function(MissingKeyResult value)? missingKey,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ConfiguredResult value)? configured,
    TResult Function(NoActiveConfigResult value)? noActiveConfig,
    TResult Function(MissingKeyResult value)? missingKey,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActiveConfigResultCopyWith<$Res> {
  factory $ActiveConfigResultCopyWith(
          ActiveConfigResult value, $Res Function(ActiveConfigResult) then) =
      _$ActiveConfigResultCopyWithImpl<$Res, ActiveConfigResult>;
}

/// @nodoc
class _$ActiveConfigResultCopyWithImpl<$Res, $Val extends ActiveConfigResult>
    implements $ActiveConfigResultCopyWith<$Res> {
  _$ActiveConfigResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActiveConfigResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ConfiguredResultImplCopyWith<$Res> {
  factory _$$ConfiguredResultImplCopyWith(_$ConfiguredResultImpl value,
          $Res Function(_$ConfiguredResultImpl) then) =
      __$$ConfiguredResultImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AIServiceConfig config, String apiKey});

  $AIServiceConfigCopyWith<$Res> get config;
}

/// @nodoc
class __$$ConfiguredResultImplCopyWithImpl<$Res>
    extends _$ActiveConfigResultCopyWithImpl<$Res, _$ConfiguredResultImpl>
    implements _$$ConfiguredResultImplCopyWith<$Res> {
  __$$ConfiguredResultImplCopyWithImpl(_$ConfiguredResultImpl _value,
      $Res Function(_$ConfiguredResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActiveConfigResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? config = null,
    Object? apiKey = null,
  }) {
    return _then(_$ConfiguredResultImpl(
      config: null == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as AIServiceConfig,
      apiKey: null == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of ActiveConfigResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AIServiceConfigCopyWith<$Res> get config {
    return $AIServiceConfigCopyWith<$Res>(_value.config, (value) {
      return _then(_value.copyWith(config: value));
    });
  }
}

/// @nodoc

class _$ConfiguredResultImpl implements ConfiguredResult {
  const _$ConfiguredResultImpl({required this.config, required this.apiKey});

  @override
  final AIServiceConfig config;
  @override
  final String apiKey;

  @override
  String toString() {
    return 'ActiveConfigResult.configured(config: $config, apiKey: $apiKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfiguredResultImpl &&
            (identical(other.config, config) || other.config == config) &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey));
  }

  @override
  int get hashCode => Object.hash(runtimeType, config, apiKey);

  /// Create a copy of ActiveConfigResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfiguredResultImplCopyWith<_$ConfiguredResultImpl> get copyWith =>
      __$$ConfiguredResultImplCopyWithImpl<_$ConfiguredResultImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AIServiceConfig config, String apiKey) configured,
    required TResult Function() noActiveConfig,
    required TResult Function(AIServiceConfig config) missingKey,
  }) {
    return configured(config, apiKey);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AIServiceConfig config, String apiKey)? configured,
    TResult? Function()? noActiveConfig,
    TResult? Function(AIServiceConfig config)? missingKey,
  }) {
    return configured?.call(config, apiKey);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AIServiceConfig config, String apiKey)? configured,
    TResult Function()? noActiveConfig,
    TResult Function(AIServiceConfig config)? missingKey,
    required TResult orElse(),
  }) {
    if (configured != null) {
      return configured(config, apiKey);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ConfiguredResult value) configured,
    required TResult Function(NoActiveConfigResult value) noActiveConfig,
    required TResult Function(MissingKeyResult value) missingKey,
  }) {
    return configured(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ConfiguredResult value)? configured,
    TResult? Function(NoActiveConfigResult value)? noActiveConfig,
    TResult? Function(MissingKeyResult value)? missingKey,
  }) {
    return configured?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ConfiguredResult value)? configured,
    TResult Function(NoActiveConfigResult value)? noActiveConfig,
    TResult Function(MissingKeyResult value)? missingKey,
    required TResult orElse(),
  }) {
    if (configured != null) {
      return configured(this);
    }
    return orElse();
  }
}

abstract class ConfiguredResult implements ActiveConfigResult {
  const factory ConfiguredResult(
      {required final AIServiceConfig config,
      required final String apiKey}) = _$ConfiguredResultImpl;

  AIServiceConfig get config;
  String get apiKey;

  /// Create a copy of ActiveConfigResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfiguredResultImplCopyWith<_$ConfiguredResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NoActiveConfigResultImplCopyWith<$Res> {
  factory _$$NoActiveConfigResultImplCopyWith(_$NoActiveConfigResultImpl value,
          $Res Function(_$NoActiveConfigResultImpl) then) =
      __$$NoActiveConfigResultImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NoActiveConfigResultImplCopyWithImpl<$Res>
    extends _$ActiveConfigResultCopyWithImpl<$Res, _$NoActiveConfigResultImpl>
    implements _$$NoActiveConfigResultImplCopyWith<$Res> {
  __$$NoActiveConfigResultImplCopyWithImpl(_$NoActiveConfigResultImpl _value,
      $Res Function(_$NoActiveConfigResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActiveConfigResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NoActiveConfigResultImpl implements NoActiveConfigResult {
  const _$NoActiveConfigResultImpl();

  @override
  String toString() {
    return 'ActiveConfigResult.noActiveConfig()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoActiveConfigResultImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AIServiceConfig config, String apiKey) configured,
    required TResult Function() noActiveConfig,
    required TResult Function(AIServiceConfig config) missingKey,
  }) {
    return noActiveConfig();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AIServiceConfig config, String apiKey)? configured,
    TResult? Function()? noActiveConfig,
    TResult? Function(AIServiceConfig config)? missingKey,
  }) {
    return noActiveConfig?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AIServiceConfig config, String apiKey)? configured,
    TResult Function()? noActiveConfig,
    TResult Function(AIServiceConfig config)? missingKey,
    required TResult orElse(),
  }) {
    if (noActiveConfig != null) {
      return noActiveConfig();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ConfiguredResult value) configured,
    required TResult Function(NoActiveConfigResult value) noActiveConfig,
    required TResult Function(MissingKeyResult value) missingKey,
  }) {
    return noActiveConfig(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ConfiguredResult value)? configured,
    TResult? Function(NoActiveConfigResult value)? noActiveConfig,
    TResult? Function(MissingKeyResult value)? missingKey,
  }) {
    return noActiveConfig?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ConfiguredResult value)? configured,
    TResult Function(NoActiveConfigResult value)? noActiveConfig,
    TResult Function(MissingKeyResult value)? missingKey,
    required TResult orElse(),
  }) {
    if (noActiveConfig != null) {
      return noActiveConfig(this);
    }
    return orElse();
  }
}

abstract class NoActiveConfigResult implements ActiveConfigResult {
  const factory NoActiveConfigResult() = _$NoActiveConfigResultImpl;
}

/// @nodoc
abstract class _$$MissingKeyResultImplCopyWith<$Res> {
  factory _$$MissingKeyResultImplCopyWith(_$MissingKeyResultImpl value,
          $Res Function(_$MissingKeyResultImpl) then) =
      __$$MissingKeyResultImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AIServiceConfig config});

  $AIServiceConfigCopyWith<$Res> get config;
}

/// @nodoc
class __$$MissingKeyResultImplCopyWithImpl<$Res>
    extends _$ActiveConfigResultCopyWithImpl<$Res, _$MissingKeyResultImpl>
    implements _$$MissingKeyResultImplCopyWith<$Res> {
  __$$MissingKeyResultImplCopyWithImpl(_$MissingKeyResultImpl _value,
      $Res Function(_$MissingKeyResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActiveConfigResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? config = null,
  }) {
    return _then(_$MissingKeyResultImpl(
      config: null == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as AIServiceConfig,
    ));
  }

  /// Create a copy of ActiveConfigResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AIServiceConfigCopyWith<$Res> get config {
    return $AIServiceConfigCopyWith<$Res>(_value.config, (value) {
      return _then(_value.copyWith(config: value));
    });
  }
}

/// @nodoc

class _$MissingKeyResultImpl implements MissingKeyResult {
  const _$MissingKeyResultImpl({required this.config});

  @override
  final AIServiceConfig config;

  @override
  String toString() {
    return 'ActiveConfigResult.missingKey(config: $config)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MissingKeyResultImpl &&
            (identical(other.config, config) || other.config == config));
  }

  @override
  int get hashCode => Object.hash(runtimeType, config);

  /// Create a copy of ActiveConfigResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MissingKeyResultImplCopyWith<_$MissingKeyResultImpl> get copyWith =>
      __$$MissingKeyResultImplCopyWithImpl<_$MissingKeyResultImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AIServiceConfig config, String apiKey) configured,
    required TResult Function() noActiveConfig,
    required TResult Function(AIServiceConfig config) missingKey,
  }) {
    return missingKey(config);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AIServiceConfig config, String apiKey)? configured,
    TResult? Function()? noActiveConfig,
    TResult? Function(AIServiceConfig config)? missingKey,
  }) {
    return missingKey?.call(config);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AIServiceConfig config, String apiKey)? configured,
    TResult Function()? noActiveConfig,
    TResult Function(AIServiceConfig config)? missingKey,
    required TResult orElse(),
  }) {
    if (missingKey != null) {
      return missingKey(config);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ConfiguredResult value) configured,
    required TResult Function(NoActiveConfigResult value) noActiveConfig,
    required TResult Function(MissingKeyResult value) missingKey,
  }) {
    return missingKey(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ConfiguredResult value)? configured,
    TResult? Function(NoActiveConfigResult value)? noActiveConfig,
    TResult? Function(MissingKeyResult value)? missingKey,
  }) {
    return missingKey?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ConfiguredResult value)? configured,
    TResult Function(NoActiveConfigResult value)? noActiveConfig,
    TResult Function(MissingKeyResult value)? missingKey,
    required TResult orElse(),
  }) {
    if (missingKey != null) {
      return missingKey(this);
    }
    return orElse();
  }
}

abstract class MissingKeyResult implements ActiveConfigResult {
  const factory MissingKeyResult({required final AIServiceConfig config}) =
      _$MissingKeyResultImpl;

  AIServiceConfig get config;

  /// Create a copy of ActiveConfigResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MissingKeyResultImplCopyWith<_$MissingKeyResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
