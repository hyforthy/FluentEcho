// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'optimization_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$OptimizationResult {
  String get optimizedText => throw _privateConstructorUsedError;
  String? get translatedText => throw _privateConstructorUsedError;
  DetectedLanguage get detectedLanguage => throw _privateConstructorUsedError;
  bool get parseWarning => throw _privateConstructorUsedError;

  /// Create a copy of OptimizationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OptimizationResultCopyWith<OptimizationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OptimizationResultCopyWith<$Res> {
  factory $OptimizationResultCopyWith(
          OptimizationResult value, $Res Function(OptimizationResult) then) =
      _$OptimizationResultCopyWithImpl<$Res, OptimizationResult>;
  @useResult
  $Res call(
      {String optimizedText,
      String? translatedText,
      DetectedLanguage detectedLanguage,
      bool parseWarning});

  $DetectedLanguageCopyWith<$Res> get detectedLanguage;
}

/// @nodoc
class _$OptimizationResultCopyWithImpl<$Res, $Val extends OptimizationResult>
    implements $OptimizationResultCopyWith<$Res> {
  _$OptimizationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OptimizationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? optimizedText = null,
    Object? translatedText = freezed,
    Object? detectedLanguage = null,
    Object? parseWarning = null,
  }) {
    return _then(_value.copyWith(
      optimizedText: null == optimizedText
          ? _value.optimizedText
          : optimizedText // ignore: cast_nullable_to_non_nullable
              as String,
      translatedText: freezed == translatedText
          ? _value.translatedText
          : translatedText // ignore: cast_nullable_to_non_nullable
              as String?,
      detectedLanguage: null == detectedLanguage
          ? _value.detectedLanguage
          : detectedLanguage // ignore: cast_nullable_to_non_nullable
              as DetectedLanguage,
      parseWarning: null == parseWarning
          ? _value.parseWarning
          : parseWarning // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of OptimizationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DetectedLanguageCopyWith<$Res> get detectedLanguage {
    return $DetectedLanguageCopyWith<$Res>(_value.detectedLanguage, (value) {
      return _then(_value.copyWith(detectedLanguage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OptimizationResultImplCopyWith<$Res>
    implements $OptimizationResultCopyWith<$Res> {
  factory _$$OptimizationResultImplCopyWith(_$OptimizationResultImpl value,
          $Res Function(_$OptimizationResultImpl) then) =
      __$$OptimizationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String optimizedText,
      String? translatedText,
      DetectedLanguage detectedLanguage,
      bool parseWarning});

  @override
  $DetectedLanguageCopyWith<$Res> get detectedLanguage;
}

/// @nodoc
class __$$OptimizationResultImplCopyWithImpl<$Res>
    extends _$OptimizationResultCopyWithImpl<$Res, _$OptimizationResultImpl>
    implements _$$OptimizationResultImplCopyWith<$Res> {
  __$$OptimizationResultImplCopyWithImpl(_$OptimizationResultImpl _value,
      $Res Function(_$OptimizationResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of OptimizationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? optimizedText = null,
    Object? translatedText = freezed,
    Object? detectedLanguage = null,
    Object? parseWarning = null,
  }) {
    return _then(_$OptimizationResultImpl(
      optimizedText: null == optimizedText
          ? _value.optimizedText
          : optimizedText // ignore: cast_nullable_to_non_nullable
              as String,
      translatedText: freezed == translatedText
          ? _value.translatedText
          : translatedText // ignore: cast_nullable_to_non_nullable
              as String?,
      detectedLanguage: null == detectedLanguage
          ? _value.detectedLanguage
          : detectedLanguage // ignore: cast_nullable_to_non_nullable
              as DetectedLanguage,
      parseWarning: null == parseWarning
          ? _value.parseWarning
          : parseWarning // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$OptimizationResultImpl implements _OptimizationResult {
  const _$OptimizationResultImpl(
      {required this.optimizedText,
      this.translatedText,
      required this.detectedLanguage,
      this.parseWarning = false});

  @override
  final String optimizedText;
  @override
  final String? translatedText;
  @override
  final DetectedLanguage detectedLanguage;
  @override
  @JsonKey()
  final bool parseWarning;

  @override
  String toString() {
    return 'OptimizationResult(optimizedText: $optimizedText, translatedText: $translatedText, detectedLanguage: $detectedLanguage, parseWarning: $parseWarning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OptimizationResultImpl &&
            (identical(other.optimizedText, optimizedText) ||
                other.optimizedText == optimizedText) &&
            (identical(other.translatedText, translatedText) ||
                other.translatedText == translatedText) &&
            (identical(other.detectedLanguage, detectedLanguage) ||
                other.detectedLanguage == detectedLanguage) &&
            (identical(other.parseWarning, parseWarning) ||
                other.parseWarning == parseWarning));
  }

  @override
  int get hashCode => Object.hash(runtimeType, optimizedText, translatedText,
      detectedLanguage, parseWarning);

  /// Create a copy of OptimizationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OptimizationResultImplCopyWith<_$OptimizationResultImpl> get copyWith =>
      __$$OptimizationResultImplCopyWithImpl<_$OptimizationResultImpl>(
          this, _$identity);
}

abstract class _OptimizationResult implements OptimizationResult {
  const factory _OptimizationResult(
      {required final String optimizedText,
      final String? translatedText,
      required final DetectedLanguage detectedLanguage,
      final bool parseWarning}) = _$OptimizationResultImpl;

  @override
  String get optimizedText;
  @override
  String? get translatedText;
  @override
  DetectedLanguage get detectedLanguage;
  @override
  bool get parseWarning;

  /// Create a copy of OptimizationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OptimizationResultImplCopyWith<_$OptimizationResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
