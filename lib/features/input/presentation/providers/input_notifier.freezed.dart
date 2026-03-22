// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'input_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InputState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(String originalText) detecting,
    required TResult Function(
            String originalText, DetectedLanguage detectedLanguage)
        preparing,
    required TResult Function(
            String originalText,
            DetectedLanguage detectedLanguage,
            StreamingSection section,
            String optimizedText,
            String translatedText)
        streaming,
    required TResult Function(ConversationEntry entry) done,
    required TResult Function(String message, String originalText) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String originalText)? detecting,
    TResult? Function(String originalText, DetectedLanguage detectedLanguage)?
        preparing,
    TResult? Function(
            String originalText,
            DetectedLanguage detectedLanguage,
            StreamingSection section,
            String optimizedText,
            String translatedText)?
        streaming,
    TResult? Function(ConversationEntry entry)? done,
    TResult? Function(String message, String originalText)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String originalText)? detecting,
    TResult Function(String originalText, DetectedLanguage detectedLanguage)?
        preparing,
    TResult Function(
            String originalText,
            DetectedLanguage detectedLanguage,
            StreamingSection section,
            String optimizedText,
            String translatedText)?
        streaming,
    TResult Function(ConversationEntry entry)? done,
    TResult Function(String message, String originalText)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Detecting value) detecting,
    required TResult Function(_Preparing value) preparing,
    required TResult Function(_Streaming value) streaming,
    required TResult Function(_Done value) done,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Detecting value)? detecting,
    TResult? Function(_Preparing value)? preparing,
    TResult? Function(_Streaming value)? streaming,
    TResult? Function(_Done value)? done,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Detecting value)? detecting,
    TResult Function(_Preparing value)? preparing,
    TResult Function(_Streaming value)? streaming,
    TResult Function(_Done value)? done,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InputStateCopyWith<$Res> {
  factory $InputStateCopyWith(
          InputState value, $Res Function(InputState) then) =
      _$InputStateCopyWithImpl<$Res, InputState>;
}

/// @nodoc
class _$InputStateCopyWithImpl<$Res, $Val extends InputState>
    implements $InputStateCopyWith<$Res> {
  _$InputStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InputState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$IdleImplCopyWith<$Res> {
  factory _$$IdleImplCopyWith(
          _$IdleImpl value, $Res Function(_$IdleImpl) then) =
      __$$IdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$IdleImplCopyWithImpl<$Res>
    extends _$InputStateCopyWithImpl<$Res, _$IdleImpl>
    implements _$$IdleImplCopyWith<$Res> {
  __$$IdleImplCopyWithImpl(_$IdleImpl _value, $Res Function(_$IdleImpl) _then)
      : super(_value, _then);

  /// Create a copy of InputState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$IdleImpl implements _Idle {
  const _$IdleImpl();

  @override
  String toString() {
    return 'InputState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$IdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(String originalText) detecting,
    required TResult Function(
            String originalText, DetectedLanguage detectedLanguage)
        preparing,
    required TResult Function(
            String originalText,
            DetectedLanguage detectedLanguage,
            StreamingSection section,
            String optimizedText,
            String translatedText)
        streaming,
    required TResult Function(ConversationEntry entry) done,
    required TResult Function(String message, String originalText) error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String originalText)? detecting,
    TResult? Function(String originalText, DetectedLanguage detectedLanguage)?
        preparing,
    TResult? Function(
            String originalText,
            DetectedLanguage detectedLanguage,
            StreamingSection section,
            String optimizedText,
            String translatedText)?
        streaming,
    TResult? Function(ConversationEntry entry)? done,
    TResult? Function(String message, String originalText)? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String originalText)? detecting,
    TResult Function(String originalText, DetectedLanguage detectedLanguage)?
        preparing,
    TResult Function(
            String originalText,
            DetectedLanguage detectedLanguage,
            StreamingSection section,
            String optimizedText,
            String translatedText)?
        streaming,
    TResult Function(ConversationEntry entry)? done,
    TResult Function(String message, String originalText)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Detecting value) detecting,
    required TResult Function(_Preparing value) preparing,
    required TResult Function(_Streaming value) streaming,
    required TResult Function(_Done value) done,
    required TResult Function(_Error value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Detecting value)? detecting,
    TResult? Function(_Preparing value)? preparing,
    TResult? Function(_Streaming value)? streaming,
    TResult? Function(_Done value)? done,
    TResult? Function(_Error value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Detecting value)? detecting,
    TResult Function(_Preparing value)? preparing,
    TResult Function(_Streaming value)? streaming,
    TResult Function(_Done value)? done,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class _Idle implements InputState {
  const factory _Idle() = _$IdleImpl;
}

/// @nodoc
abstract class _$$DetectingImplCopyWith<$Res> {
  factory _$$DetectingImplCopyWith(
          _$DetectingImpl value, $Res Function(_$DetectingImpl) then) =
      __$$DetectingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String originalText});
}

/// @nodoc
class __$$DetectingImplCopyWithImpl<$Res>
    extends _$InputStateCopyWithImpl<$Res, _$DetectingImpl>
    implements _$$DetectingImplCopyWith<$Res> {
  __$$DetectingImplCopyWithImpl(
      _$DetectingImpl _value, $Res Function(_$DetectingImpl) _then)
      : super(_value, _then);

  /// Create a copy of InputState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalText = null,
  }) {
    return _then(_$DetectingImpl(
      originalText: null == originalText
          ? _value.originalText
          : originalText // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DetectingImpl implements _Detecting {
  const _$DetectingImpl({required this.originalText});

  @override
  final String originalText;

  @override
  String toString() {
    return 'InputState.detecting(originalText: $originalText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetectingImpl &&
            (identical(other.originalText, originalText) ||
                other.originalText == originalText));
  }

  @override
  int get hashCode => Object.hash(runtimeType, originalText);

  /// Create a copy of InputState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DetectingImplCopyWith<_$DetectingImpl> get copyWith =>
      __$$DetectingImplCopyWithImpl<_$DetectingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(String originalText) detecting,
    required TResult Function(
            String originalText, DetectedLanguage detectedLanguage)
        preparing,
    required TResult Function(
            String originalText,
            DetectedLanguage detectedLanguage,
            StreamingSection section,
            String optimizedText,
            String translatedText)
        streaming,
    required TResult Function(ConversationEntry entry) done,
    required TResult Function(String message, String originalText) error,
  }) {
    return detecting(originalText);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String originalText)? detecting,
    TResult? Function(String originalText, DetectedLanguage detectedLanguage)?
        preparing,
    TResult? Function(
            String originalText,
            DetectedLanguage detectedLanguage,
            StreamingSection section,
            String optimizedText,
            String translatedText)?
        streaming,
    TResult? Function(ConversationEntry entry)? done,
    TResult? Function(String message, String originalText)? error,
  }) {
    return detecting?.call(originalText);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String originalText)? detecting,
    TResult Function(String originalText, DetectedLanguage detectedLanguage)?
        preparing,
    TResult Function(
            String originalText,
            DetectedLanguage detectedLanguage,
            StreamingSection section,
            String optimizedText,
            String translatedText)?
        streaming,
    TResult Function(ConversationEntry entry)? done,
    TResult Function(String message, String originalText)? error,
    required TResult orElse(),
  }) {
    if (detecting != null) {
      return detecting(originalText);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Detecting value) detecting,
    required TResult Function(_Preparing value) preparing,
    required TResult Function(_Streaming value) streaming,
    required TResult Function(_Done value) done,
    required TResult Function(_Error value) error,
  }) {
    return detecting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Detecting value)? detecting,
    TResult? Function(_Preparing value)? preparing,
    TResult? Function(_Streaming value)? streaming,
    TResult? Function(_Done value)? done,
    TResult? Function(_Error value)? error,
  }) {
    return detecting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Detecting value)? detecting,
    TResult Function(_Preparing value)? preparing,
    TResult Function(_Streaming value)? streaming,
    TResult Function(_Done value)? done,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (detecting != null) {
      return detecting(this);
    }
    return orElse();
  }
}

abstract class _Detecting implements InputState {
  const factory _Detecting({required final String originalText}) =
      _$DetectingImpl;

  String get originalText;

  /// Create a copy of InputState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DetectingImplCopyWith<_$DetectingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PreparingImplCopyWith<$Res> {
  factory _$$PreparingImplCopyWith(
          _$PreparingImpl value, $Res Function(_$PreparingImpl) then) =
      __$$PreparingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String originalText, DetectedLanguage detectedLanguage});

  $DetectedLanguageCopyWith<$Res> get detectedLanguage;
}

/// @nodoc
class __$$PreparingImplCopyWithImpl<$Res>
    extends _$InputStateCopyWithImpl<$Res, _$PreparingImpl>
    implements _$$PreparingImplCopyWith<$Res> {
  __$$PreparingImplCopyWithImpl(
      _$PreparingImpl _value, $Res Function(_$PreparingImpl) _then)
      : super(_value, _then);

  /// Create a copy of InputState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalText = null,
    Object? detectedLanguage = null,
  }) {
    return _then(_$PreparingImpl(
      originalText: null == originalText
          ? _value.originalText
          : originalText // ignore: cast_nullable_to_non_nullable
              as String,
      detectedLanguage: null == detectedLanguage
          ? _value.detectedLanguage
          : detectedLanguage // ignore: cast_nullable_to_non_nullable
              as DetectedLanguage,
    ));
  }

  /// Create a copy of InputState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DetectedLanguageCopyWith<$Res> get detectedLanguage {
    return $DetectedLanguageCopyWith<$Res>(_value.detectedLanguage, (value) {
      return _then(_value.copyWith(detectedLanguage: value));
    });
  }
}

/// @nodoc

class _$PreparingImpl implements _Preparing {
  const _$PreparingImpl(
      {required this.originalText, required this.detectedLanguage});

  @override
  final String originalText;
  @override
  final DetectedLanguage detectedLanguage;

  @override
  String toString() {
    return 'InputState.preparing(originalText: $originalText, detectedLanguage: $detectedLanguage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PreparingImpl &&
            (identical(other.originalText, originalText) ||
                other.originalText == originalText) &&
            (identical(other.detectedLanguage, detectedLanguage) ||
                other.detectedLanguage == detectedLanguage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, originalText, detectedLanguage);

  /// Create a copy of InputState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PreparingImplCopyWith<_$PreparingImpl> get copyWith =>
      __$$PreparingImplCopyWithImpl<_$PreparingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(String originalText) detecting,
    required TResult Function(
            String originalText, DetectedLanguage detectedLanguage)
        preparing,
    required TResult Function(
            String originalText,
            DetectedLanguage detectedLanguage,
            StreamingSection section,
            String optimizedText,
            String translatedText)
        streaming,
    required TResult Function(ConversationEntry entry) done,
    required TResult Function(String message, String originalText) error,
  }) {
    return preparing(originalText, detectedLanguage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String originalText)? detecting,
    TResult? Function(String originalText, DetectedLanguage detectedLanguage)?
        preparing,
    TResult? Function(
            String originalText,
            DetectedLanguage detectedLanguage,
            StreamingSection section,
            String optimizedText,
            String translatedText)?
        streaming,
    TResult? Function(ConversationEntry entry)? done,
    TResult? Function(String message, String originalText)? error,
  }) {
    return preparing?.call(originalText, detectedLanguage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String originalText)? detecting,
    TResult Function(String originalText, DetectedLanguage detectedLanguage)?
        preparing,
    TResult Function(
            String originalText,
            DetectedLanguage detectedLanguage,
            StreamingSection section,
            String optimizedText,
            String translatedText)?
        streaming,
    TResult Function(ConversationEntry entry)? done,
    TResult Function(String message, String originalText)? error,
    required TResult orElse(),
  }) {
    if (preparing != null) {
      return preparing(originalText, detectedLanguage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Detecting value) detecting,
    required TResult Function(_Preparing value) preparing,
    required TResult Function(_Streaming value) streaming,
    required TResult Function(_Done value) done,
    required TResult Function(_Error value) error,
  }) {
    return preparing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Detecting value)? detecting,
    TResult? Function(_Preparing value)? preparing,
    TResult? Function(_Streaming value)? streaming,
    TResult? Function(_Done value)? done,
    TResult? Function(_Error value)? error,
  }) {
    return preparing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Detecting value)? detecting,
    TResult Function(_Preparing value)? preparing,
    TResult Function(_Streaming value)? streaming,
    TResult Function(_Done value)? done,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (preparing != null) {
      return preparing(this);
    }
    return orElse();
  }
}

abstract class _Preparing implements InputState {
  const factory _Preparing(
      {required final String originalText,
      required final DetectedLanguage detectedLanguage}) = _$PreparingImpl;

  String get originalText;
  DetectedLanguage get detectedLanguage;

  /// Create a copy of InputState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PreparingImplCopyWith<_$PreparingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamingImplCopyWith<$Res> {
  factory _$$StreamingImplCopyWith(
          _$StreamingImpl value, $Res Function(_$StreamingImpl) then) =
      __$$StreamingImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String originalText,
      DetectedLanguage detectedLanguage,
      StreamingSection section,
      String optimizedText,
      String translatedText});

  $DetectedLanguageCopyWith<$Res> get detectedLanguage;
}

/// @nodoc
class __$$StreamingImplCopyWithImpl<$Res>
    extends _$InputStateCopyWithImpl<$Res, _$StreamingImpl>
    implements _$$StreamingImplCopyWith<$Res> {
  __$$StreamingImplCopyWithImpl(
      _$StreamingImpl _value, $Res Function(_$StreamingImpl) _then)
      : super(_value, _then);

  /// Create a copy of InputState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalText = null,
    Object? detectedLanguage = null,
    Object? section = null,
    Object? optimizedText = null,
    Object? translatedText = null,
  }) {
    return _then(_$StreamingImpl(
      originalText: null == originalText
          ? _value.originalText
          : originalText // ignore: cast_nullable_to_non_nullable
              as String,
      detectedLanguage: null == detectedLanguage
          ? _value.detectedLanguage
          : detectedLanguage // ignore: cast_nullable_to_non_nullable
              as DetectedLanguage,
      section: null == section
          ? _value.section
          : section // ignore: cast_nullable_to_non_nullable
              as StreamingSection,
      optimizedText: null == optimizedText
          ? _value.optimizedText
          : optimizedText // ignore: cast_nullable_to_non_nullable
              as String,
      translatedText: null == translatedText
          ? _value.translatedText
          : translatedText // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of InputState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DetectedLanguageCopyWith<$Res> get detectedLanguage {
    return $DetectedLanguageCopyWith<$Res>(_value.detectedLanguage, (value) {
      return _then(_value.copyWith(detectedLanguage: value));
    });
  }
}

/// @nodoc

class _$StreamingImpl implements _Streaming {
  const _$StreamingImpl(
      {required this.originalText,
      required this.detectedLanguage,
      required this.section,
      required this.optimizedText,
      required this.translatedText});

  @override
  final String originalText;
  @override
  final DetectedLanguage detectedLanguage;
  @override
  final StreamingSection section;
  @override
  final String optimizedText;
  @override
  final String translatedText;

  @override
  String toString() {
    return 'InputState.streaming(originalText: $originalText, detectedLanguage: $detectedLanguage, section: $section, optimizedText: $optimizedText, translatedText: $translatedText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamingImpl &&
            (identical(other.originalText, originalText) ||
                other.originalText == originalText) &&
            (identical(other.detectedLanguage, detectedLanguage) ||
                other.detectedLanguage == detectedLanguage) &&
            (identical(other.section, section) || other.section == section) &&
            (identical(other.optimizedText, optimizedText) ||
                other.optimizedText == optimizedText) &&
            (identical(other.translatedText, translatedText) ||
                other.translatedText == translatedText));
  }

  @override
  int get hashCode => Object.hash(runtimeType, originalText, detectedLanguage,
      section, optimizedText, translatedText);

  /// Create a copy of InputState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StreamingImplCopyWith<_$StreamingImpl> get copyWith =>
      __$$StreamingImplCopyWithImpl<_$StreamingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(String originalText) detecting,
    required TResult Function(
            String originalText, DetectedLanguage detectedLanguage)
        preparing,
    required TResult Function(
            String originalText,
            DetectedLanguage detectedLanguage,
            StreamingSection section,
            String optimizedText,
            String translatedText)
        streaming,
    required TResult Function(ConversationEntry entry) done,
    required TResult Function(String message, String originalText) error,
  }) {
    return streaming(
        originalText, detectedLanguage, section, optimizedText, translatedText);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String originalText)? detecting,
    TResult? Function(String originalText, DetectedLanguage detectedLanguage)?
        preparing,
    TResult? Function(
            String originalText,
            DetectedLanguage detectedLanguage,
            StreamingSection section,
            String optimizedText,
            String translatedText)?
        streaming,
    TResult? Function(ConversationEntry entry)? done,
    TResult? Function(String message, String originalText)? error,
  }) {
    return streaming?.call(
        originalText, detectedLanguage, section, optimizedText, translatedText);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String originalText)? detecting,
    TResult Function(String originalText, DetectedLanguage detectedLanguage)?
        preparing,
    TResult Function(
            String originalText,
            DetectedLanguage detectedLanguage,
            StreamingSection section,
            String optimizedText,
            String translatedText)?
        streaming,
    TResult Function(ConversationEntry entry)? done,
    TResult Function(String message, String originalText)? error,
    required TResult orElse(),
  }) {
    if (streaming != null) {
      return streaming(originalText, detectedLanguage, section, optimizedText,
          translatedText);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Detecting value) detecting,
    required TResult Function(_Preparing value) preparing,
    required TResult Function(_Streaming value) streaming,
    required TResult Function(_Done value) done,
    required TResult Function(_Error value) error,
  }) {
    return streaming(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Detecting value)? detecting,
    TResult? Function(_Preparing value)? preparing,
    TResult? Function(_Streaming value)? streaming,
    TResult? Function(_Done value)? done,
    TResult? Function(_Error value)? error,
  }) {
    return streaming?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Detecting value)? detecting,
    TResult Function(_Preparing value)? preparing,
    TResult Function(_Streaming value)? streaming,
    TResult Function(_Done value)? done,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (streaming != null) {
      return streaming(this);
    }
    return orElse();
  }
}

abstract class _Streaming implements InputState {
  const factory _Streaming(
      {required final String originalText,
      required final DetectedLanguage detectedLanguage,
      required final StreamingSection section,
      required final String optimizedText,
      required final String translatedText}) = _$StreamingImpl;

  String get originalText;
  DetectedLanguage get detectedLanguage;
  StreamingSection get section;
  String get optimizedText;
  String get translatedText;

  /// Create a copy of InputState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StreamingImplCopyWith<_$StreamingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DoneImplCopyWith<$Res> {
  factory _$$DoneImplCopyWith(
          _$DoneImpl value, $Res Function(_$DoneImpl) then) =
      __$$DoneImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ConversationEntry entry});

  $ConversationEntryCopyWith<$Res> get entry;
}

/// @nodoc
class __$$DoneImplCopyWithImpl<$Res>
    extends _$InputStateCopyWithImpl<$Res, _$DoneImpl>
    implements _$$DoneImplCopyWith<$Res> {
  __$$DoneImplCopyWithImpl(_$DoneImpl _value, $Res Function(_$DoneImpl) _then)
      : super(_value, _then);

  /// Create a copy of InputState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entry = null,
  }) {
    return _then(_$DoneImpl(
      entry: null == entry
          ? _value.entry
          : entry // ignore: cast_nullable_to_non_nullable
              as ConversationEntry,
    ));
  }

  /// Create a copy of InputState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConversationEntryCopyWith<$Res> get entry {
    return $ConversationEntryCopyWith<$Res>(_value.entry, (value) {
      return _then(_value.copyWith(entry: value));
    });
  }
}

/// @nodoc

class _$DoneImpl implements _Done {
  const _$DoneImpl({required this.entry});

  @override
  final ConversationEntry entry;

  @override
  String toString() {
    return 'InputState.done(entry: $entry)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoneImpl &&
            (identical(other.entry, entry) || other.entry == entry));
  }

  @override
  int get hashCode => Object.hash(runtimeType, entry);

  /// Create a copy of InputState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DoneImplCopyWith<_$DoneImpl> get copyWith =>
      __$$DoneImplCopyWithImpl<_$DoneImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(String originalText) detecting,
    required TResult Function(
            String originalText, DetectedLanguage detectedLanguage)
        preparing,
    required TResult Function(
            String originalText,
            DetectedLanguage detectedLanguage,
            StreamingSection section,
            String optimizedText,
            String translatedText)
        streaming,
    required TResult Function(ConversationEntry entry) done,
    required TResult Function(String message, String originalText) error,
  }) {
    return done(entry);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String originalText)? detecting,
    TResult? Function(String originalText, DetectedLanguage detectedLanguage)?
        preparing,
    TResult? Function(
            String originalText,
            DetectedLanguage detectedLanguage,
            StreamingSection section,
            String optimizedText,
            String translatedText)?
        streaming,
    TResult? Function(ConversationEntry entry)? done,
    TResult? Function(String message, String originalText)? error,
  }) {
    return done?.call(entry);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String originalText)? detecting,
    TResult Function(String originalText, DetectedLanguage detectedLanguage)?
        preparing,
    TResult Function(
            String originalText,
            DetectedLanguage detectedLanguage,
            StreamingSection section,
            String optimizedText,
            String translatedText)?
        streaming,
    TResult Function(ConversationEntry entry)? done,
    TResult Function(String message, String originalText)? error,
    required TResult orElse(),
  }) {
    if (done != null) {
      return done(entry);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Detecting value) detecting,
    required TResult Function(_Preparing value) preparing,
    required TResult Function(_Streaming value) streaming,
    required TResult Function(_Done value) done,
    required TResult Function(_Error value) error,
  }) {
    return done(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Detecting value)? detecting,
    TResult? Function(_Preparing value)? preparing,
    TResult? Function(_Streaming value)? streaming,
    TResult? Function(_Done value)? done,
    TResult? Function(_Error value)? error,
  }) {
    return done?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Detecting value)? detecting,
    TResult Function(_Preparing value)? preparing,
    TResult Function(_Streaming value)? streaming,
    TResult Function(_Done value)? done,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (done != null) {
      return done(this);
    }
    return orElse();
  }
}

abstract class _Done implements InputState {
  const factory _Done({required final ConversationEntry entry}) = _$DoneImpl;

  ConversationEntry get entry;

  /// Create a copy of InputState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DoneImplCopyWith<_$DoneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, String originalText});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$InputStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of InputState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? originalText = null,
  }) {
    return _then(_$ErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      originalText: null == originalText
          ? _value.originalText
          : originalText // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl({required this.message, required this.originalText});

  @override
  final String message;
  @override
  final String originalText;

  @override
  String toString() {
    return 'InputState.error(message: $message, originalText: $originalText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.originalText, originalText) ||
                other.originalText == originalText));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, originalText);

  /// Create a copy of InputState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(String originalText) detecting,
    required TResult Function(
            String originalText, DetectedLanguage detectedLanguage)
        preparing,
    required TResult Function(
            String originalText,
            DetectedLanguage detectedLanguage,
            StreamingSection section,
            String optimizedText,
            String translatedText)
        streaming,
    required TResult Function(ConversationEntry entry) done,
    required TResult Function(String message, String originalText) error,
  }) {
    return error(message, originalText);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String originalText)? detecting,
    TResult? Function(String originalText, DetectedLanguage detectedLanguage)?
        preparing,
    TResult? Function(
            String originalText,
            DetectedLanguage detectedLanguage,
            StreamingSection section,
            String optimizedText,
            String translatedText)?
        streaming,
    TResult? Function(ConversationEntry entry)? done,
    TResult? Function(String message, String originalText)? error,
  }) {
    return error?.call(message, originalText);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String originalText)? detecting,
    TResult Function(String originalText, DetectedLanguage detectedLanguage)?
        preparing,
    TResult Function(
            String originalText,
            DetectedLanguage detectedLanguage,
            StreamingSection section,
            String optimizedText,
            String translatedText)?
        streaming,
    TResult Function(ConversationEntry entry)? done,
    TResult Function(String message, String originalText)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, originalText);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Detecting value) detecting,
    required TResult Function(_Preparing value) preparing,
    required TResult Function(_Streaming value) streaming,
    required TResult Function(_Done value) done,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Detecting value)? detecting,
    TResult? Function(_Preparing value)? preparing,
    TResult? Function(_Streaming value)? streaming,
    TResult? Function(_Done value)? done,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Detecting value)? detecting,
    TResult Function(_Preparing value)? preparing,
    TResult Function(_Streaming value)? streaming,
    TResult Function(_Done value)? done,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements InputState {
  const factory _Error(
      {required final String message,
      required final String originalText}) = _$ErrorImpl;

  String get message;
  String get originalText;

  /// Create a copy of InputState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
