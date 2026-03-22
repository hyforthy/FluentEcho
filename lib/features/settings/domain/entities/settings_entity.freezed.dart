// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SettingsEntity _$SettingsEntityFromJson(Map<String, dynamic> json) {
  return _SettingsEntity.fromJson(json);
}

/// @nodoc
mixin _$SettingsEntity {
  double get ttsPlaybackSpeed => throw _privateConstructorUsedError;
  bool get hasCompletedSetup => throw _privateConstructorUsedError;
  bool get autoDeleteTempAudioOnClear => throw _privateConstructorUsedError;

  /// Serializes this SettingsEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SettingsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettingsEntityCopyWith<SettingsEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsEntityCopyWith<$Res> {
  factory $SettingsEntityCopyWith(
          SettingsEntity value, $Res Function(SettingsEntity) then) =
      _$SettingsEntityCopyWithImpl<$Res, SettingsEntity>;
  @useResult
  $Res call(
      {double ttsPlaybackSpeed,
      bool hasCompletedSetup,
      bool autoDeleteTempAudioOnClear});
}

/// @nodoc
class _$SettingsEntityCopyWithImpl<$Res, $Val extends SettingsEntity>
    implements $SettingsEntityCopyWith<$Res> {
  _$SettingsEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettingsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ttsPlaybackSpeed = null,
    Object? hasCompletedSetup = null,
    Object? autoDeleteTempAudioOnClear = null,
  }) {
    return _then(_value.copyWith(
      ttsPlaybackSpeed: null == ttsPlaybackSpeed
          ? _value.ttsPlaybackSpeed
          : ttsPlaybackSpeed // ignore: cast_nullable_to_non_nullable
              as double,
      hasCompletedSetup: null == hasCompletedSetup
          ? _value.hasCompletedSetup
          : hasCompletedSetup // ignore: cast_nullable_to_non_nullable
              as bool,
      autoDeleteTempAudioOnClear: null == autoDeleteTempAudioOnClear
          ? _value.autoDeleteTempAudioOnClear
          : autoDeleteTempAudioOnClear // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SettingsEntityImplCopyWith<$Res>
    implements $SettingsEntityCopyWith<$Res> {
  factory _$$SettingsEntityImplCopyWith(_$SettingsEntityImpl value,
          $Res Function(_$SettingsEntityImpl) then) =
      __$$SettingsEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double ttsPlaybackSpeed,
      bool hasCompletedSetup,
      bool autoDeleteTempAudioOnClear});
}

/// @nodoc
class __$$SettingsEntityImplCopyWithImpl<$Res>
    extends _$SettingsEntityCopyWithImpl<$Res, _$SettingsEntityImpl>
    implements _$$SettingsEntityImplCopyWith<$Res> {
  __$$SettingsEntityImplCopyWithImpl(
      _$SettingsEntityImpl _value, $Res Function(_$SettingsEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of SettingsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ttsPlaybackSpeed = null,
    Object? hasCompletedSetup = null,
    Object? autoDeleteTempAudioOnClear = null,
  }) {
    return _then(_$SettingsEntityImpl(
      ttsPlaybackSpeed: null == ttsPlaybackSpeed
          ? _value.ttsPlaybackSpeed
          : ttsPlaybackSpeed // ignore: cast_nullable_to_non_nullable
              as double,
      hasCompletedSetup: null == hasCompletedSetup
          ? _value.hasCompletedSetup
          : hasCompletedSetup // ignore: cast_nullable_to_non_nullable
              as bool,
      autoDeleteTempAudioOnClear: null == autoDeleteTempAudioOnClear
          ? _value.autoDeleteTempAudioOnClear
          : autoDeleteTempAudioOnClear // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SettingsEntityImpl implements _SettingsEntity {
  const _$SettingsEntityImpl(
      {this.ttsPlaybackSpeed = 1.0,
      this.hasCompletedSetup = false,
      this.autoDeleteTempAudioOnClear = true});

  factory _$SettingsEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettingsEntityImplFromJson(json);

  @override
  @JsonKey()
  final double ttsPlaybackSpeed;
  @override
  @JsonKey()
  final bool hasCompletedSetup;
  @override
  @JsonKey()
  final bool autoDeleteTempAudioOnClear;

  @override
  String toString() {
    return 'SettingsEntity(ttsPlaybackSpeed: $ttsPlaybackSpeed, hasCompletedSetup: $hasCompletedSetup, autoDeleteTempAudioOnClear: $autoDeleteTempAudioOnClear)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsEntityImpl &&
            (identical(other.ttsPlaybackSpeed, ttsPlaybackSpeed) ||
                other.ttsPlaybackSpeed == ttsPlaybackSpeed) &&
            (identical(other.hasCompletedSetup, hasCompletedSetup) ||
                other.hasCompletedSetup == hasCompletedSetup) &&
            (identical(other.autoDeleteTempAudioOnClear,
                    autoDeleteTempAudioOnClear) ||
                other.autoDeleteTempAudioOnClear ==
                    autoDeleteTempAudioOnClear));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ttsPlaybackSpeed,
      hasCompletedSetup, autoDeleteTempAudioOnClear);

  /// Create a copy of SettingsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsEntityImplCopyWith<_$SettingsEntityImpl> get copyWith =>
      __$$SettingsEntityImplCopyWithImpl<_$SettingsEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SettingsEntityImplToJson(
      this,
    );
  }
}

abstract class _SettingsEntity implements SettingsEntity {
  const factory _SettingsEntity(
      {final double ttsPlaybackSpeed,
      final bool hasCompletedSetup,
      final bool autoDeleteTempAudioOnClear}) = _$SettingsEntityImpl;

  factory _SettingsEntity.fromJson(Map<String, dynamic> json) =
      _$SettingsEntityImpl.fromJson;

  @override
  double get ttsPlaybackSpeed;
  @override
  bool get hasCompletedSetup;
  @override
  bool get autoDeleteTempAudioOnClear;

  /// Create a copy of SettingsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettingsEntityImplCopyWith<_$SettingsEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
