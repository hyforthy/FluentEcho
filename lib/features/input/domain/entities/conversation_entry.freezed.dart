// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ConversationEntry {
  String get id => throw _privateConstructorUsedError;
  String get originalText => throw _privateConstructorUsedError;
  String get optimizedText => throw _privateConstructorUsedError;
  String? get translatedText => throw _privateConstructorUsedError;
  DetectedLanguage get detectedLanguage => throw _privateConstructorUsedError;
  String? get audioFilePath => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get isFromVoice => throw _privateConstructorUsedError;
  bool get parseWarning => throw _privateConstructorUsedError;
  bool get skipOptimization => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  int? get savedNoteId => throw _privateConstructorUsedError;

  /// Create a copy of ConversationEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationEntryCopyWith<ConversationEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationEntryCopyWith<$Res> {
  factory $ConversationEntryCopyWith(
          ConversationEntry value, $Res Function(ConversationEntry) then) =
      _$ConversationEntryCopyWithImpl<$Res, ConversationEntry>;
  @useResult
  $Res call(
      {String id,
      String originalText,
      String optimizedText,
      String? translatedText,
      DetectedLanguage detectedLanguage,
      String? audioFilePath,
      DateTime createdAt,
      bool isFromVoice,
      bool parseWarning,
      bool skipOptimization,
      String? errorMessage,
      int? savedNoteId});

  $DetectedLanguageCopyWith<$Res> get detectedLanguage;
}

/// @nodoc
class _$ConversationEntryCopyWithImpl<$Res, $Val extends ConversationEntry>
    implements $ConversationEntryCopyWith<$Res> {
  _$ConversationEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? originalText = null,
    Object? optimizedText = null,
    Object? translatedText = freezed,
    Object? detectedLanguage = null,
    Object? audioFilePath = freezed,
    Object? createdAt = null,
    Object? isFromVoice = null,
    Object? parseWarning = null,
    Object? skipOptimization = null,
    Object? errorMessage = freezed,
    Object? savedNoteId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      originalText: null == originalText
          ? _value.originalText
          : originalText // ignore: cast_nullable_to_non_nullable
              as String,
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
      audioFilePath: freezed == audioFilePath
          ? _value.audioFilePath
          : audioFilePath // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isFromVoice: null == isFromVoice
          ? _value.isFromVoice
          : isFromVoice // ignore: cast_nullable_to_non_nullable
              as bool,
      parseWarning: null == parseWarning
          ? _value.parseWarning
          : parseWarning // ignore: cast_nullable_to_non_nullable
              as bool,
      skipOptimization: null == skipOptimization
          ? _value.skipOptimization
          : skipOptimization // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      savedNoteId: freezed == savedNoteId
          ? _value.savedNoteId
          : savedNoteId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of ConversationEntry
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
abstract class _$$ConversationEntryImplCopyWith<$Res>
    implements $ConversationEntryCopyWith<$Res> {
  factory _$$ConversationEntryImplCopyWith(_$ConversationEntryImpl value,
          $Res Function(_$ConversationEntryImpl) then) =
      __$$ConversationEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String originalText,
      String optimizedText,
      String? translatedText,
      DetectedLanguage detectedLanguage,
      String? audioFilePath,
      DateTime createdAt,
      bool isFromVoice,
      bool parseWarning,
      bool skipOptimization,
      String? errorMessage,
      int? savedNoteId});

  @override
  $DetectedLanguageCopyWith<$Res> get detectedLanguage;
}

/// @nodoc
class __$$ConversationEntryImplCopyWithImpl<$Res>
    extends _$ConversationEntryCopyWithImpl<$Res, _$ConversationEntryImpl>
    implements _$$ConversationEntryImplCopyWith<$Res> {
  __$$ConversationEntryImplCopyWithImpl(_$ConversationEntryImpl _value,
      $Res Function(_$ConversationEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversationEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? originalText = null,
    Object? optimizedText = null,
    Object? translatedText = freezed,
    Object? detectedLanguage = null,
    Object? audioFilePath = freezed,
    Object? createdAt = null,
    Object? isFromVoice = null,
    Object? parseWarning = null,
    Object? skipOptimization = null,
    Object? errorMessage = freezed,
    Object? savedNoteId = freezed,
  }) {
    return _then(_$ConversationEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      originalText: null == originalText
          ? _value.originalText
          : originalText // ignore: cast_nullable_to_non_nullable
              as String,
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
      audioFilePath: freezed == audioFilePath
          ? _value.audioFilePath
          : audioFilePath // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isFromVoice: null == isFromVoice
          ? _value.isFromVoice
          : isFromVoice // ignore: cast_nullable_to_non_nullable
              as bool,
      parseWarning: null == parseWarning
          ? _value.parseWarning
          : parseWarning // ignore: cast_nullable_to_non_nullable
              as bool,
      skipOptimization: null == skipOptimization
          ? _value.skipOptimization
          : skipOptimization // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      savedNoteId: freezed == savedNoteId
          ? _value.savedNoteId
          : savedNoteId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$ConversationEntryImpl implements _ConversationEntry {
  const _$ConversationEntryImpl(
      {required this.id,
      required this.originalText,
      required this.optimizedText,
      this.translatedText,
      required this.detectedLanguage,
      this.audioFilePath,
      required this.createdAt,
      this.isFromVoice = false,
      this.parseWarning = false,
      this.skipOptimization = false,
      this.errorMessage,
      this.savedNoteId});

  @override
  final String id;
  @override
  final String originalText;
  @override
  final String optimizedText;
  @override
  final String? translatedText;
  @override
  final DetectedLanguage detectedLanguage;
  @override
  final String? audioFilePath;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final bool isFromVoice;
  @override
  @JsonKey()
  final bool parseWarning;
  @override
  @JsonKey()
  final bool skipOptimization;
  @override
  final String? errorMessage;
  @override
  final int? savedNoteId;

  @override
  String toString() {
    return 'ConversationEntry(id: $id, originalText: $originalText, optimizedText: $optimizedText, translatedText: $translatedText, detectedLanguage: $detectedLanguage, audioFilePath: $audioFilePath, createdAt: $createdAt, isFromVoice: $isFromVoice, parseWarning: $parseWarning, skipOptimization: $skipOptimization, errorMessage: $errorMessage, savedNoteId: $savedNoteId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.originalText, originalText) ||
                other.originalText == originalText) &&
            (identical(other.optimizedText, optimizedText) ||
                other.optimizedText == optimizedText) &&
            (identical(other.translatedText, translatedText) ||
                other.translatedText == translatedText) &&
            (identical(other.detectedLanguage, detectedLanguage) ||
                other.detectedLanguage == detectedLanguage) &&
            (identical(other.audioFilePath, audioFilePath) ||
                other.audioFilePath == audioFilePath) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isFromVoice, isFromVoice) ||
                other.isFromVoice == isFromVoice) &&
            (identical(other.parseWarning, parseWarning) ||
                other.parseWarning == parseWarning) &&
            (identical(other.skipOptimization, skipOptimization) ||
                other.skipOptimization == skipOptimization) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.savedNoteId, savedNoteId) ||
                other.savedNoteId == savedNoteId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      originalText,
      optimizedText,
      translatedText,
      detectedLanguage,
      audioFilePath,
      createdAt,
      isFromVoice,
      parseWarning,
      skipOptimization,
      errorMessage,
      savedNoteId);

  /// Create a copy of ConversationEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationEntryImplCopyWith<_$ConversationEntryImpl> get copyWith =>
      __$$ConversationEntryImplCopyWithImpl<_$ConversationEntryImpl>(
          this, _$identity);
}

abstract class _ConversationEntry implements ConversationEntry {
  const factory _ConversationEntry(
      {required final String id,
      required final String originalText,
      required final String optimizedText,
      final String? translatedText,
      required final DetectedLanguage detectedLanguage,
      final String? audioFilePath,
      required final DateTime createdAt,
      final bool isFromVoice,
      final bool parseWarning,
      final bool skipOptimization,
      final String? errorMessage,
      final int? savedNoteId}) = _$ConversationEntryImpl;

  @override
  String get id;
  @override
  String get originalText;
  @override
  String get optimizedText;
  @override
  String? get translatedText;
  @override
  DetectedLanguage get detectedLanguage;
  @override
  String? get audioFilePath;
  @override
  DateTime get createdAt;
  @override
  bool get isFromVoice;
  @override
  bool get parseWarning;
  @override
  bool get skipOptimization;
  @override
  String? get errorMessage;
  @override
  int? get savedNoteId;

  /// Create a copy of ConversationEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationEntryImplCopyWith<_$ConversationEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
