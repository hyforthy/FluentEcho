// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detected_language.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DetectedLanguage {
  String get language =>
      throw _privateConstructorUsedError; // 'zh' | 'en' | 'mixed'
  double get confidence => throw _privateConstructorUsedError; // 0.0 - 1.0
  DetectionSource get source => throw _privateConstructorUsedError;

  /// Create a copy of DetectedLanguage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DetectedLanguageCopyWith<DetectedLanguage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetectedLanguageCopyWith<$Res> {
  factory $DetectedLanguageCopyWith(
          DetectedLanguage value, $Res Function(DetectedLanguage) then) =
      _$DetectedLanguageCopyWithImpl<$Res, DetectedLanguage>;
  @useResult
  $Res call({String language, double confidence, DetectionSource source});
}

/// @nodoc
class _$DetectedLanguageCopyWithImpl<$Res, $Val extends DetectedLanguage>
    implements $DetectedLanguageCopyWith<$Res> {
  _$DetectedLanguageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DetectedLanguage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = null,
    Object? confidence = null,
    Object? source = null,
  }) {
    return _then(_value.copyWith(
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as DetectionSource,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DetectedLanguageImplCopyWith<$Res>
    implements $DetectedLanguageCopyWith<$Res> {
  factory _$$DetectedLanguageImplCopyWith(_$DetectedLanguageImpl value,
          $Res Function(_$DetectedLanguageImpl) then) =
      __$$DetectedLanguageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String language, double confidence, DetectionSource source});
}

/// @nodoc
class __$$DetectedLanguageImplCopyWithImpl<$Res>
    extends _$DetectedLanguageCopyWithImpl<$Res, _$DetectedLanguageImpl>
    implements _$$DetectedLanguageImplCopyWith<$Res> {
  __$$DetectedLanguageImplCopyWithImpl(_$DetectedLanguageImpl _value,
      $Res Function(_$DetectedLanguageImpl) _then)
      : super(_value, _then);

  /// Create a copy of DetectedLanguage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = null,
    Object? confidence = null,
    Object? source = null,
  }) {
    return _then(_$DetectedLanguageImpl(
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as DetectionSource,
    ));
  }
}

/// @nodoc

class _$DetectedLanguageImpl implements _DetectedLanguage {
  const _$DetectedLanguageImpl(
      {required this.language, required this.confidence, required this.source});

  @override
  final String language;
// 'zh' | 'en' | 'mixed'
  @override
  final double confidence;
// 0.0 - 1.0
  @override
  final DetectionSource source;

  @override
  String toString() {
    return 'DetectedLanguage(language: $language, confidence: $confidence, source: $source)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetectedLanguageImpl &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.source, source) || other.source == source));
  }

  @override
  int get hashCode => Object.hash(runtimeType, language, confidence, source);

  /// Create a copy of DetectedLanguage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DetectedLanguageImplCopyWith<_$DetectedLanguageImpl> get copyWith =>
      __$$DetectedLanguageImplCopyWithImpl<_$DetectedLanguageImpl>(
          this, _$identity);
}

abstract class _DetectedLanguage implements DetectedLanguage {
  const factory _DetectedLanguage(
      {required final String language,
      required final double confidence,
      required final DetectionSource source}) = _$DetectedLanguageImpl;

  @override
  String get language; // 'zh' | 'en' | 'mixed'
  @override
  double get confidence; // 0.0 - 1.0
  @override
  DetectionSource get source;

  /// Create a copy of DetectedLanguage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DetectedLanguageImplCopyWith<_$DetectedLanguageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
