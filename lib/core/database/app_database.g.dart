// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $NotesTable extends Notes with TableInfo<$NotesTable, NoteData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _originalTextMeta =
      const VerificationMeta('originalText');
  @override
  late final GeneratedColumn<String> originalText = GeneratedColumn<String>(
      'original_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _optimizedTextMeta =
      const VerificationMeta('optimizedText');
  @override
  late final GeneratedColumn<String> optimizedText = GeneratedColumn<String>(
      'optimized_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _translatedTextMeta =
      const VerificationMeta('translatedText');
  @override
  late final GeneratedColumn<String> translatedText = GeneratedColumn<String>(
      'translated_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _detectedLanguageMeta =
      const VerificationMeta('detectedLanguage');
  @override
  late final GeneratedColumn<String> detectedLanguage = GeneratedColumn<String>(
      'detected_language', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('zh'));
  static const VerificationMeta _detectionConfidenceMeta =
      const VerificationMeta('detectionConfidence');
  @override
  late final GeneratedColumn<double> detectionConfidence =
      GeneratedColumn<double>('detection_confidence', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(1.0));
  static const VerificationMeta _audioFilePathMeta =
      const VerificationMeta('audioFilePath');
  @override
  late final GeneratedColumn<String> audioFilePath = GeneratedColumn<String>(
      'audio_file_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _audioFileSizeBytesMeta =
      const VerificationMeta('audioFileSizeBytes');
  @override
  late final GeneratedColumn<int> audioFileSizeBytes = GeneratedColumn<int>(
      'audio_file_size_bytes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        originalText,
        optimizedText,
        translatedText,
        detectedLanguage,
        detectionConfidence,
        audioFilePath,
        audioFileSizeBytes,
        createdAt,
        updatedAt,
        isFavorite
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(Insertable<NoteData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('original_text')) {
      context.handle(
          _originalTextMeta,
          originalText.isAcceptableOrUnknown(
              data['original_text']!, _originalTextMeta));
    } else if (isInserting) {
      context.missing(_originalTextMeta);
    }
    if (data.containsKey('optimized_text')) {
      context.handle(
          _optimizedTextMeta,
          optimizedText.isAcceptableOrUnknown(
              data['optimized_text']!, _optimizedTextMeta));
    }
    if (data.containsKey('translated_text')) {
      context.handle(
          _translatedTextMeta,
          translatedText.isAcceptableOrUnknown(
              data['translated_text']!, _translatedTextMeta));
    }
    if (data.containsKey('detected_language')) {
      context.handle(
          _detectedLanguageMeta,
          detectedLanguage.isAcceptableOrUnknown(
              data['detected_language']!, _detectedLanguageMeta));
    }
    if (data.containsKey('detection_confidence')) {
      context.handle(
          _detectionConfidenceMeta,
          detectionConfidence.isAcceptableOrUnknown(
              data['detection_confidence']!, _detectionConfidenceMeta));
    }
    if (data.containsKey('audio_file_path')) {
      context.handle(
          _audioFilePathMeta,
          audioFilePath.isAcceptableOrUnknown(
              data['audio_file_path']!, _audioFilePathMeta));
    }
    if (data.containsKey('audio_file_size_bytes')) {
      context.handle(
          _audioFileSizeBytesMeta,
          audioFileSizeBytes.isAcceptableOrUnknown(
              data['audio_file_size_bytes']!, _audioFileSizeBytesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      originalText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}original_text'])!,
      optimizedText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}optimized_text']),
      translatedText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}translated_text']),
      detectedLanguage: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}detected_language'])!,
      detectionConfidence: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}detection_confidence'])!,
      audioFilePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_file_path']),
      audioFileSizeBytes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}audio_file_size_bytes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class NoteData extends DataClass implements Insertable<NoteData> {
  final int id;
  final String originalText;
  final String? optimizedText;
  final String? translatedText;
  final String detectedLanguage;
  final double detectionConfidence;
  final String? audioFilePath;
  final int? audioFileSizeBytes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;
  const NoteData(
      {required this.id,
      required this.originalText,
      this.optimizedText,
      this.translatedText,
      required this.detectedLanguage,
      required this.detectionConfidence,
      this.audioFilePath,
      this.audioFileSizeBytes,
      required this.createdAt,
      required this.updatedAt,
      required this.isFavorite});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['original_text'] = Variable<String>(originalText);
    if (!nullToAbsent || optimizedText != null) {
      map['optimized_text'] = Variable<String>(optimizedText);
    }
    if (!nullToAbsent || translatedText != null) {
      map['translated_text'] = Variable<String>(translatedText);
    }
    map['detected_language'] = Variable<String>(detectedLanguage);
    map['detection_confidence'] = Variable<double>(detectionConfidence);
    if (!nullToAbsent || audioFilePath != null) {
      map['audio_file_path'] = Variable<String>(audioFilePath);
    }
    if (!nullToAbsent || audioFileSizeBytes != null) {
      map['audio_file_size_bytes'] = Variable<int>(audioFileSizeBytes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      originalText: Value(originalText),
      optimizedText: optimizedText == null && nullToAbsent
          ? const Value.absent()
          : Value(optimizedText),
      translatedText: translatedText == null && nullToAbsent
          ? const Value.absent()
          : Value(translatedText),
      detectedLanguage: Value(detectedLanguage),
      detectionConfidence: Value(detectionConfidence),
      audioFilePath: audioFilePath == null && nullToAbsent
          ? const Value.absent()
          : Value(audioFilePath),
      audioFileSizeBytes: audioFileSizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(audioFileSizeBytes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isFavorite: Value(isFavorite),
    );
  }

  factory NoteData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteData(
      id: serializer.fromJson<int>(json['id']),
      originalText: serializer.fromJson<String>(json['originalText']),
      optimizedText: serializer.fromJson<String?>(json['optimizedText']),
      translatedText: serializer.fromJson<String?>(json['translatedText']),
      detectedLanguage: serializer.fromJson<String>(json['detectedLanguage']),
      detectionConfidence:
          serializer.fromJson<double>(json['detectionConfidence']),
      audioFilePath: serializer.fromJson<String?>(json['audioFilePath']),
      audioFileSizeBytes: serializer.fromJson<int?>(json['audioFileSizeBytes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'originalText': serializer.toJson<String>(originalText),
      'optimizedText': serializer.toJson<String?>(optimizedText),
      'translatedText': serializer.toJson<String?>(translatedText),
      'detectedLanguage': serializer.toJson<String>(detectedLanguage),
      'detectionConfidence': serializer.toJson<double>(detectionConfidence),
      'audioFilePath': serializer.toJson<String?>(audioFilePath),
      'audioFileSizeBytes': serializer.toJson<int?>(audioFileSizeBytes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  NoteData copyWith(
          {int? id,
          String? originalText,
          Value<String?> optimizedText = const Value.absent(),
          Value<String?> translatedText = const Value.absent(),
          String? detectedLanguage,
          double? detectionConfidence,
          Value<String?> audioFilePath = const Value.absent(),
          Value<int?> audioFileSizeBytes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? isFavorite}) =>
      NoteData(
        id: id ?? this.id,
        originalText: originalText ?? this.originalText,
        optimizedText:
            optimizedText.present ? optimizedText.value : this.optimizedText,
        translatedText:
            translatedText.present ? translatedText.value : this.translatedText,
        detectedLanguage: detectedLanguage ?? this.detectedLanguage,
        detectionConfidence: detectionConfidence ?? this.detectionConfidence,
        audioFilePath:
            audioFilePath.present ? audioFilePath.value : this.audioFilePath,
        audioFileSizeBytes: audioFileSizeBytes.present
            ? audioFileSizeBytes.value
            : this.audioFileSizeBytes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isFavorite: isFavorite ?? this.isFavorite,
      );
  NoteData copyWithCompanion(NotesCompanion data) {
    return NoteData(
      id: data.id.present ? data.id.value : this.id,
      originalText: data.originalText.present
          ? data.originalText.value
          : this.originalText,
      optimizedText: data.optimizedText.present
          ? data.optimizedText.value
          : this.optimizedText,
      translatedText: data.translatedText.present
          ? data.translatedText.value
          : this.translatedText,
      detectedLanguage: data.detectedLanguage.present
          ? data.detectedLanguage.value
          : this.detectedLanguage,
      detectionConfidence: data.detectionConfidence.present
          ? data.detectionConfidence.value
          : this.detectionConfidence,
      audioFilePath: data.audioFilePath.present
          ? data.audioFilePath.value
          : this.audioFilePath,
      audioFileSizeBytes: data.audioFileSizeBytes.present
          ? data.audioFileSizeBytes.value
          : this.audioFileSizeBytes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteData(')
          ..write('id: $id, ')
          ..write('originalText: $originalText, ')
          ..write('optimizedText: $optimizedText, ')
          ..write('translatedText: $translatedText, ')
          ..write('detectedLanguage: $detectedLanguage, ')
          ..write('detectionConfidence: $detectionConfidence, ')
          ..write('audioFilePath: $audioFilePath, ')
          ..write('audioFileSizeBytes: $audioFileSizeBytes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      originalText,
      optimizedText,
      translatedText,
      detectedLanguage,
      detectionConfidence,
      audioFilePath,
      audioFileSizeBytes,
      createdAt,
      updatedAt,
      isFavorite);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteData &&
          other.id == this.id &&
          other.originalText == this.originalText &&
          other.optimizedText == this.optimizedText &&
          other.translatedText == this.translatedText &&
          other.detectedLanguage == this.detectedLanguage &&
          other.detectionConfidence == this.detectionConfidence &&
          other.audioFilePath == this.audioFilePath &&
          other.audioFileSizeBytes == this.audioFileSizeBytes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isFavorite == this.isFavorite);
}

class NotesCompanion extends UpdateCompanion<NoteData> {
  final Value<int> id;
  final Value<String> originalText;
  final Value<String?> optimizedText;
  final Value<String?> translatedText;
  final Value<String> detectedLanguage;
  final Value<double> detectionConfidence;
  final Value<String?> audioFilePath;
  final Value<int?> audioFileSizeBytes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isFavorite;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.originalText = const Value.absent(),
    this.optimizedText = const Value.absent(),
    this.translatedText = const Value.absent(),
    this.detectedLanguage = const Value.absent(),
    this.detectionConfidence = const Value.absent(),
    this.audioFilePath = const Value.absent(),
    this.audioFileSizeBytes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isFavorite = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    required String originalText,
    this.optimizedText = const Value.absent(),
    this.translatedText = const Value.absent(),
    this.detectedLanguage = const Value.absent(),
    this.detectionConfidence = const Value.absent(),
    this.audioFilePath = const Value.absent(),
    this.audioFileSizeBytes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isFavorite = const Value.absent(),
  }) : originalText = Value(originalText);
  static Insertable<NoteData> custom({
    Expression<int>? id,
    Expression<String>? originalText,
    Expression<String>? optimizedText,
    Expression<String>? translatedText,
    Expression<String>? detectedLanguage,
    Expression<double>? detectionConfidence,
    Expression<String>? audioFilePath,
    Expression<int>? audioFileSizeBytes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isFavorite,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (originalText != null) 'original_text': originalText,
      if (optimizedText != null) 'optimized_text': optimizedText,
      if (translatedText != null) 'translated_text': translatedText,
      if (detectedLanguage != null) 'detected_language': detectedLanguage,
      if (detectionConfidence != null)
        'detection_confidence': detectionConfidence,
      if (audioFilePath != null) 'audio_file_path': audioFilePath,
      if (audioFileSizeBytes != null)
        'audio_file_size_bytes': audioFileSizeBytes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isFavorite != null) 'is_favorite': isFavorite,
    });
  }

  NotesCompanion copyWith(
      {Value<int>? id,
      Value<String>? originalText,
      Value<String?>? optimizedText,
      Value<String?>? translatedText,
      Value<String>? detectedLanguage,
      Value<double>? detectionConfidence,
      Value<String?>? audioFilePath,
      Value<int?>? audioFileSizeBytes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? isFavorite}) {
    return NotesCompanion(
      id: id ?? this.id,
      originalText: originalText ?? this.originalText,
      optimizedText: optimizedText ?? this.optimizedText,
      translatedText: translatedText ?? this.translatedText,
      detectedLanguage: detectedLanguage ?? this.detectedLanguage,
      detectionConfidence: detectionConfidence ?? this.detectionConfidence,
      audioFilePath: audioFilePath ?? this.audioFilePath,
      audioFileSizeBytes: audioFileSizeBytes ?? this.audioFileSizeBytes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (originalText.present) {
      map['original_text'] = Variable<String>(originalText.value);
    }
    if (optimizedText.present) {
      map['optimized_text'] = Variable<String>(optimizedText.value);
    }
    if (translatedText.present) {
      map['translated_text'] = Variable<String>(translatedText.value);
    }
    if (detectedLanguage.present) {
      map['detected_language'] = Variable<String>(detectedLanguage.value);
    }
    if (detectionConfidence.present) {
      map['detection_confidence'] = Variable<double>(detectionConfidence.value);
    }
    if (audioFilePath.present) {
      map['audio_file_path'] = Variable<String>(audioFilePath.value);
    }
    if (audioFileSizeBytes.present) {
      map['audio_file_size_bytes'] = Variable<int>(audioFileSizeBytes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('originalText: $originalText, ')
          ..write('optimizedText: $optimizedText, ')
          ..write('translatedText: $translatedText, ')
          ..write('detectedLanguage: $detectedLanguage, ')
          ..write('detectionConfidence: $detectionConfidence, ')
          ..write('audioFilePath: $audioFilePath, ')
          ..write('audioFileSizeBytes: $audioFileSizeBytes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(Insertable<Tag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;
  final String name;
  final DateTime createdAt;
  const Tag({required this.id, required this.name, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Tag copyWith({int? id, String? name, DateTime? createdAt}) => Tag(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TagsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<DateTime>? createdAt}) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $NoteTagsTable extends NoteTags with TableInfo<$NoteTagsTable, NoteTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<int> noteId = GeneratedColumn<int>(
      'note_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
      'tag_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [noteId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_tags';
  @override
  VerificationContext validateIntegrity(Insertable<NoteTag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('note_id')) {
      context.handle(_noteIdMeta,
          noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta));
    } else if (isInserting) {
      context.missing(_noteIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
          _tagIdMeta, tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta));
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {noteId, tagId};
  @override
  NoteTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteTag(
      noteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}note_id'])!,
      tagId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tag_id'])!,
    );
  }

  @override
  $NoteTagsTable createAlias(String alias) {
    return $NoteTagsTable(attachedDatabase, alias);
  }
}

class NoteTag extends DataClass implements Insertable<NoteTag> {
  final int noteId;
  final int tagId;
  const NoteTag({required this.noteId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['note_id'] = Variable<int>(noteId);
    map['tag_id'] = Variable<int>(tagId);
    return map;
  }

  NoteTagsCompanion toCompanion(bool nullToAbsent) {
    return NoteTagsCompanion(
      noteId: Value(noteId),
      tagId: Value(tagId),
    );
  }

  factory NoteTag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteTag(
      noteId: serializer.fromJson<int>(json['noteId']),
      tagId: serializer.fromJson<int>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'noteId': serializer.toJson<int>(noteId),
      'tagId': serializer.toJson<int>(tagId),
    };
  }

  NoteTag copyWith({int? noteId, int? tagId}) => NoteTag(
        noteId: noteId ?? this.noteId,
        tagId: tagId ?? this.tagId,
      );
  NoteTag copyWithCompanion(NoteTagsCompanion data) {
    return NoteTag(
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteTag(')
          ..write('noteId: $noteId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(noteId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteTag &&
          other.noteId == this.noteId &&
          other.tagId == this.tagId);
}

class NoteTagsCompanion extends UpdateCompanion<NoteTag> {
  final Value<int> noteId;
  final Value<int> tagId;
  final Value<int> rowid;
  const NoteTagsCompanion({
    this.noteId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NoteTagsCompanion.insert({
    required int noteId,
    required int tagId,
    this.rowid = const Value.absent(),
  })  : noteId = Value(noteId),
        tagId = Value(tagId);
  static Insertable<NoteTag> custom({
    Expression<int>? noteId,
    Expression<int>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (noteId != null) 'note_id': noteId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NoteTagsCompanion copyWith(
      {Value<int>? noteId, Value<int>? tagId, Value<int>? rowid}) {
    return NoteTagsCompanion(
      noteId: noteId ?? this.noteId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (noteId.present) {
      map['note_id'] = Variable<int>(noteId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteTagsCompanion(')
          ..write('noteId: $noteId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiServiceConfigsTable extends AiServiceConfigs
    with TableInfo<$AiServiceConfigsTable, AiServiceConfigData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiServiceConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _serviceTypeMeta =
      const VerificationMeta('serviceType');
  @override
  late final GeneratedColumn<String> serviceType = GeneratedColumn<String>(
      'service_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _providerKeyMeta =
      const VerificationMeta('providerKey');
  @override
  late final GeneratedColumn<String> providerKey = GeneratedColumn<String>(
      'provider_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
      'model', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customBaseUrlMeta =
      const VerificationMeta('customBaseUrl');
  @override
  late final GeneratedColumn<String> customBaseUrl = GeneratedColumn<String>(
      'custom_base_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        serviceType,
        providerKey,
        displayName,
        model,
        customBaseUrl,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_service_configs';
  @override
  VerificationContext validateIntegrity(
      Insertable<AiServiceConfigData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('service_type')) {
      context.handle(
          _serviceTypeMeta,
          serviceType.isAcceptableOrUnknown(
              data['service_type']!, _serviceTypeMeta));
    } else if (isInserting) {
      context.missing(_serviceTypeMeta);
    }
    if (data.containsKey('provider_key')) {
      context.handle(
          _providerKeyMeta,
          providerKey.isAcceptableOrUnknown(
              data['provider_key']!, _providerKeyMeta));
    } else if (isInserting) {
      context.missing(_providerKeyMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
          _modelMeta, model.isAcceptableOrUnknown(data['model']!, _modelMeta));
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('custom_base_url')) {
      context.handle(
          _customBaseUrlMeta,
          customBaseUrl.isAcceptableOrUnknown(
              data['custom_base_url']!, _customBaseUrlMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiServiceConfigData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiServiceConfigData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      serviceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}service_type'])!,
      providerKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}provider_key'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      model: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model'])!,
      customBaseUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_base_url']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AiServiceConfigsTable createAlias(String alias) {
    return $AiServiceConfigsTable(attachedDatabase, alias);
  }
}

class AiServiceConfigData extends DataClass
    implements Insertable<AiServiceConfigData> {
  final String id;
  final String serviceType;
  final String providerKey;
  final String displayName;
  final String model;
  final String? customBaseUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AiServiceConfigData(
      {required this.id,
      required this.serviceType,
      required this.providerKey,
      required this.displayName,
      required this.model,
      this.customBaseUrl,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['service_type'] = Variable<String>(serviceType);
    map['provider_key'] = Variable<String>(providerKey);
    map['display_name'] = Variable<String>(displayName);
    map['model'] = Variable<String>(model);
    if (!nullToAbsent || customBaseUrl != null) {
      map['custom_base_url'] = Variable<String>(customBaseUrl);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AiServiceConfigsCompanion toCompanion(bool nullToAbsent) {
    return AiServiceConfigsCompanion(
      id: Value(id),
      serviceType: Value(serviceType),
      providerKey: Value(providerKey),
      displayName: Value(displayName),
      model: Value(model),
      customBaseUrl: customBaseUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(customBaseUrl),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AiServiceConfigData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiServiceConfigData(
      id: serializer.fromJson<String>(json['id']),
      serviceType: serializer.fromJson<String>(json['serviceType']),
      providerKey: serializer.fromJson<String>(json['providerKey']),
      displayName: serializer.fromJson<String>(json['displayName']),
      model: serializer.fromJson<String>(json['model']),
      customBaseUrl: serializer.fromJson<String?>(json['customBaseUrl']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serviceType': serializer.toJson<String>(serviceType),
      'providerKey': serializer.toJson<String>(providerKey),
      'displayName': serializer.toJson<String>(displayName),
      'model': serializer.toJson<String>(model),
      'customBaseUrl': serializer.toJson<String?>(customBaseUrl),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AiServiceConfigData copyWith(
          {String? id,
          String? serviceType,
          String? providerKey,
          String? displayName,
          String? model,
          Value<String?> customBaseUrl = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      AiServiceConfigData(
        id: id ?? this.id,
        serviceType: serviceType ?? this.serviceType,
        providerKey: providerKey ?? this.providerKey,
        displayName: displayName ?? this.displayName,
        model: model ?? this.model,
        customBaseUrl:
            customBaseUrl.present ? customBaseUrl.value : this.customBaseUrl,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AiServiceConfigData copyWithCompanion(AiServiceConfigsCompanion data) {
    return AiServiceConfigData(
      id: data.id.present ? data.id.value : this.id,
      serviceType:
          data.serviceType.present ? data.serviceType.value : this.serviceType,
      providerKey:
          data.providerKey.present ? data.providerKey.value : this.providerKey,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      model: data.model.present ? data.model.value : this.model,
      customBaseUrl: data.customBaseUrl.present
          ? data.customBaseUrl.value
          : this.customBaseUrl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiServiceConfigData(')
          ..write('id: $id, ')
          ..write('serviceType: $serviceType, ')
          ..write('providerKey: $providerKey, ')
          ..write('displayName: $displayName, ')
          ..write('model: $model, ')
          ..write('customBaseUrl: $customBaseUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, serviceType, providerKey, displayName,
      model, customBaseUrl, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiServiceConfigData &&
          other.id == this.id &&
          other.serviceType == this.serviceType &&
          other.providerKey == this.providerKey &&
          other.displayName == this.displayName &&
          other.model == this.model &&
          other.customBaseUrl == this.customBaseUrl &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AiServiceConfigsCompanion extends UpdateCompanion<AiServiceConfigData> {
  final Value<String> id;
  final Value<String> serviceType;
  final Value<String> providerKey;
  final Value<String> displayName;
  final Value<String> model;
  final Value<String?> customBaseUrl;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AiServiceConfigsCompanion({
    this.id = const Value.absent(),
    this.serviceType = const Value.absent(),
    this.providerKey = const Value.absent(),
    this.displayName = const Value.absent(),
    this.model = const Value.absent(),
    this.customBaseUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiServiceConfigsCompanion.insert({
    required String id,
    required String serviceType,
    required String providerKey,
    required String displayName,
    required String model,
    this.customBaseUrl = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        serviceType = Value(serviceType),
        providerKey = Value(providerKey),
        displayName = Value(displayName),
        model = Value(model),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<AiServiceConfigData> custom({
    Expression<String>? id,
    Expression<String>? serviceType,
    Expression<String>? providerKey,
    Expression<String>? displayName,
    Expression<String>? model,
    Expression<String>? customBaseUrl,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serviceType != null) 'service_type': serviceType,
      if (providerKey != null) 'provider_key': providerKey,
      if (displayName != null) 'display_name': displayName,
      if (model != null) 'model': model,
      if (customBaseUrl != null) 'custom_base_url': customBaseUrl,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiServiceConfigsCompanion copyWith(
      {Value<String>? id,
      Value<String>? serviceType,
      Value<String>? providerKey,
      Value<String>? displayName,
      Value<String>? model,
      Value<String?>? customBaseUrl,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return AiServiceConfigsCompanion(
      id: id ?? this.id,
      serviceType: serviceType ?? this.serviceType,
      providerKey: providerKey ?? this.providerKey,
      displayName: displayName ?? this.displayName,
      model: model ?? this.model,
      customBaseUrl: customBaseUrl ?? this.customBaseUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serviceType.present) {
      map['service_type'] = Variable<String>(serviceType.value);
    }
    if (providerKey.present) {
      map['provider_key'] = Variable<String>(providerKey.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (customBaseUrl.present) {
      map['custom_base_url'] = Variable<String>(customBaseUrl.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiServiceConfigsCompanion(')
          ..write('id: $id, ')
          ..write('serviceType: $serviceType, ')
          ..write('providerKey: $providerKey, ')
          ..write('displayName: $displayName, ')
          ..write('model: $model, ')
          ..write('customBaseUrl: $customBaseUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConversationEntriesTable extends ConversationEntries
    with TableInfo<$ConversationEntriesTable, ConversationEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversationEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inputTextMeta =
      const VerificationMeta('inputText');
  @override
  late final GeneratedColumn<String> inputText = GeneratedColumn<String>(
      'input_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inputLangMeta =
      const VerificationMeta('inputLang');
  @override
  late final GeneratedColumn<String> inputLang = GeneratedColumn<String>(
      'input_lang', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _detectionSourceMeta =
      const VerificationMeta('detectionSource');
  @override
  late final GeneratedColumn<String> detectionSource = GeneratedColumn<String>(
      'detection_source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('rule'));
  static const VerificationMeta _optimizedTextMeta =
      const VerificationMeta('optimizedText');
  @override
  late final GeneratedColumn<String> optimizedText = GeneratedColumn<String>(
      'optimized_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _translatedTextMeta =
      const VerificationMeta('translatedText');
  @override
  late final GeneratedColumn<String> translatedText = GeneratedColumn<String>(
      'translated_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _audioFilePathMeta =
      const VerificationMeta('audioFilePath');
  @override
  late final GeneratedColumn<String> audioFilePath = GeneratedColumn<String>(
      'audio_file_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _savedNoteIdMeta =
      const VerificationMeta('savedNoteId');
  @override
  late final GeneratedColumn<int> savedNoteId = GeneratedColumn<int>(
      'saved_note_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        inputText,
        inputLang,
        detectionSource,
        optimizedText,
        translatedText,
        audioFilePath,
        savedNoteId,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversation_entries';
  @override
  VerificationContext validateIntegrity(Insertable<ConversationEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('input_text')) {
      context.handle(_inputTextMeta,
          inputText.isAcceptableOrUnknown(data['input_text']!, _inputTextMeta));
    } else if (isInserting) {
      context.missing(_inputTextMeta);
    }
    if (data.containsKey('input_lang')) {
      context.handle(_inputLangMeta,
          inputLang.isAcceptableOrUnknown(data['input_lang']!, _inputLangMeta));
    } else if (isInserting) {
      context.missing(_inputLangMeta);
    }
    if (data.containsKey('detection_source')) {
      context.handle(
          _detectionSourceMeta,
          detectionSource.isAcceptableOrUnknown(
              data['detection_source']!, _detectionSourceMeta));
    }
    if (data.containsKey('optimized_text')) {
      context.handle(
          _optimizedTextMeta,
          optimizedText.isAcceptableOrUnknown(
              data['optimized_text']!, _optimizedTextMeta));
    }
    if (data.containsKey('translated_text')) {
      context.handle(
          _translatedTextMeta,
          translatedText.isAcceptableOrUnknown(
              data['translated_text']!, _translatedTextMeta));
    }
    if (data.containsKey('audio_file_path')) {
      context.handle(
          _audioFilePathMeta,
          audioFilePath.isAcceptableOrUnknown(
              data['audio_file_path']!, _audioFilePathMeta));
    }
    if (data.containsKey('saved_note_id')) {
      context.handle(
          _savedNoteIdMeta,
          savedNoteId.isAcceptableOrUnknown(
              data['saved_note_id']!, _savedNoteIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConversationEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConversationEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      inputText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}input_text'])!,
      inputLang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}input_lang'])!,
      detectionSource: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}detection_source'])!,
      optimizedText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}optimized_text']),
      translatedText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}translated_text']),
      audioFilePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_file_path']),
      savedNoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}saved_note_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ConversationEntriesTable createAlias(String alias) {
    return $ConversationEntriesTable(attachedDatabase, alias);
  }
}

class ConversationEntry extends DataClass
    implements Insertable<ConversationEntry> {
  final String id;
  final String inputText;
  final String inputLang;
  final String detectionSource;
  final String? optimizedText;
  final String? translatedText;
  final String? audioFilePath;
  final int? savedNoteId;
  final int createdAt;
  const ConversationEntry(
      {required this.id,
      required this.inputText,
      required this.inputLang,
      required this.detectionSource,
      this.optimizedText,
      this.translatedText,
      this.audioFilePath,
      this.savedNoteId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['input_text'] = Variable<String>(inputText);
    map['input_lang'] = Variable<String>(inputLang);
    map['detection_source'] = Variable<String>(detectionSource);
    if (!nullToAbsent || optimizedText != null) {
      map['optimized_text'] = Variable<String>(optimizedText);
    }
    if (!nullToAbsent || translatedText != null) {
      map['translated_text'] = Variable<String>(translatedText);
    }
    if (!nullToAbsent || audioFilePath != null) {
      map['audio_file_path'] = Variable<String>(audioFilePath);
    }
    if (!nullToAbsent || savedNoteId != null) {
      map['saved_note_id'] = Variable<int>(savedNoteId);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  ConversationEntriesCompanion toCompanion(bool nullToAbsent) {
    return ConversationEntriesCompanion(
      id: Value(id),
      inputText: Value(inputText),
      inputLang: Value(inputLang),
      detectionSource: Value(detectionSource),
      optimizedText: optimizedText == null && nullToAbsent
          ? const Value.absent()
          : Value(optimizedText),
      translatedText: translatedText == null && nullToAbsent
          ? const Value.absent()
          : Value(translatedText),
      audioFilePath: audioFilePath == null && nullToAbsent
          ? const Value.absent()
          : Value(audioFilePath),
      savedNoteId: savedNoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(savedNoteId),
      createdAt: Value(createdAt),
    );
  }

  factory ConversationEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConversationEntry(
      id: serializer.fromJson<String>(json['id']),
      inputText: serializer.fromJson<String>(json['inputText']),
      inputLang: serializer.fromJson<String>(json['inputLang']),
      detectionSource: serializer.fromJson<String>(json['detectionSource']),
      optimizedText: serializer.fromJson<String?>(json['optimizedText']),
      translatedText: serializer.fromJson<String?>(json['translatedText']),
      audioFilePath: serializer.fromJson<String?>(json['audioFilePath']),
      savedNoteId: serializer.fromJson<int?>(json['savedNoteId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'inputText': serializer.toJson<String>(inputText),
      'inputLang': serializer.toJson<String>(inputLang),
      'detectionSource': serializer.toJson<String>(detectionSource),
      'optimizedText': serializer.toJson<String?>(optimizedText),
      'translatedText': serializer.toJson<String?>(translatedText),
      'audioFilePath': serializer.toJson<String?>(audioFilePath),
      'savedNoteId': serializer.toJson<int?>(savedNoteId),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  ConversationEntry copyWith(
          {String? id,
          String? inputText,
          String? inputLang,
          String? detectionSource,
          Value<String?> optimizedText = const Value.absent(),
          Value<String?> translatedText = const Value.absent(),
          Value<String?> audioFilePath = const Value.absent(),
          Value<int?> savedNoteId = const Value.absent(),
          int? createdAt}) =>
      ConversationEntry(
        id: id ?? this.id,
        inputText: inputText ?? this.inputText,
        inputLang: inputLang ?? this.inputLang,
        detectionSource: detectionSource ?? this.detectionSource,
        optimizedText:
            optimizedText.present ? optimizedText.value : this.optimizedText,
        translatedText:
            translatedText.present ? translatedText.value : this.translatedText,
        audioFilePath:
            audioFilePath.present ? audioFilePath.value : this.audioFilePath,
        savedNoteId: savedNoteId.present ? savedNoteId.value : this.savedNoteId,
        createdAt: createdAt ?? this.createdAt,
      );
  ConversationEntry copyWithCompanion(ConversationEntriesCompanion data) {
    return ConversationEntry(
      id: data.id.present ? data.id.value : this.id,
      inputText: data.inputText.present ? data.inputText.value : this.inputText,
      inputLang: data.inputLang.present ? data.inputLang.value : this.inputLang,
      detectionSource: data.detectionSource.present
          ? data.detectionSource.value
          : this.detectionSource,
      optimizedText: data.optimizedText.present
          ? data.optimizedText.value
          : this.optimizedText,
      translatedText: data.translatedText.present
          ? data.translatedText.value
          : this.translatedText,
      audioFilePath: data.audioFilePath.present
          ? data.audioFilePath.value
          : this.audioFilePath,
      savedNoteId:
          data.savedNoteId.present ? data.savedNoteId.value : this.savedNoteId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConversationEntry(')
          ..write('id: $id, ')
          ..write('inputText: $inputText, ')
          ..write('inputLang: $inputLang, ')
          ..write('detectionSource: $detectionSource, ')
          ..write('optimizedText: $optimizedText, ')
          ..write('translatedText: $translatedText, ')
          ..write('audioFilePath: $audioFilePath, ')
          ..write('savedNoteId: $savedNoteId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, inputText, inputLang, detectionSource,
      optimizedText, translatedText, audioFilePath, savedNoteId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConversationEntry &&
          other.id == this.id &&
          other.inputText == this.inputText &&
          other.inputLang == this.inputLang &&
          other.detectionSource == this.detectionSource &&
          other.optimizedText == this.optimizedText &&
          other.translatedText == this.translatedText &&
          other.audioFilePath == this.audioFilePath &&
          other.savedNoteId == this.savedNoteId &&
          other.createdAt == this.createdAt);
}

class ConversationEntriesCompanion extends UpdateCompanion<ConversationEntry> {
  final Value<String> id;
  final Value<String> inputText;
  final Value<String> inputLang;
  final Value<String> detectionSource;
  final Value<String?> optimizedText;
  final Value<String?> translatedText;
  final Value<String?> audioFilePath;
  final Value<int?> savedNoteId;
  final Value<int> createdAt;
  final Value<int> rowid;
  const ConversationEntriesCompanion({
    this.id = const Value.absent(),
    this.inputText = const Value.absent(),
    this.inputLang = const Value.absent(),
    this.detectionSource = const Value.absent(),
    this.optimizedText = const Value.absent(),
    this.translatedText = const Value.absent(),
    this.audioFilePath = const Value.absent(),
    this.savedNoteId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversationEntriesCompanion.insert({
    required String id,
    required String inputText,
    required String inputLang,
    this.detectionSource = const Value.absent(),
    this.optimizedText = const Value.absent(),
    this.translatedText = const Value.absent(),
    this.audioFilePath = const Value.absent(),
    this.savedNoteId = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        inputText = Value(inputText),
        inputLang = Value(inputLang),
        createdAt = Value(createdAt);
  static Insertable<ConversationEntry> custom({
    Expression<String>? id,
    Expression<String>? inputText,
    Expression<String>? inputLang,
    Expression<String>? detectionSource,
    Expression<String>? optimizedText,
    Expression<String>? translatedText,
    Expression<String>? audioFilePath,
    Expression<int>? savedNoteId,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inputText != null) 'input_text': inputText,
      if (inputLang != null) 'input_lang': inputLang,
      if (detectionSource != null) 'detection_source': detectionSource,
      if (optimizedText != null) 'optimized_text': optimizedText,
      if (translatedText != null) 'translated_text': translatedText,
      if (audioFilePath != null) 'audio_file_path': audioFilePath,
      if (savedNoteId != null) 'saved_note_id': savedNoteId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversationEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? inputText,
      Value<String>? inputLang,
      Value<String>? detectionSource,
      Value<String?>? optimizedText,
      Value<String?>? translatedText,
      Value<String?>? audioFilePath,
      Value<int?>? savedNoteId,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return ConversationEntriesCompanion(
      id: id ?? this.id,
      inputText: inputText ?? this.inputText,
      inputLang: inputLang ?? this.inputLang,
      detectionSource: detectionSource ?? this.detectionSource,
      optimizedText: optimizedText ?? this.optimizedText,
      translatedText: translatedText ?? this.translatedText,
      audioFilePath: audioFilePath ?? this.audioFilePath,
      savedNoteId: savedNoteId ?? this.savedNoteId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (inputText.present) {
      map['input_text'] = Variable<String>(inputText.value);
    }
    if (inputLang.present) {
      map['input_lang'] = Variable<String>(inputLang.value);
    }
    if (detectionSource.present) {
      map['detection_source'] = Variable<String>(detectionSource.value);
    }
    if (optimizedText.present) {
      map['optimized_text'] = Variable<String>(optimizedText.value);
    }
    if (translatedText.present) {
      map['translated_text'] = Variable<String>(translatedText.value);
    }
    if (audioFilePath.present) {
      map['audio_file_path'] = Variable<String>(audioFilePath.value);
    }
    if (savedNoteId.present) {
      map['saved_note_id'] = Variable<int>(savedNoteId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversationEntriesCompanion(')
          ..write('id: $id, ')
          ..write('inputText: $inputText, ')
          ..write('inputLang: $inputLang, ')
          ..write('detectionSource: $detectionSource, ')
          ..write('optimizedText: $optimizedText, ')
          ..write('translatedText: $translatedText, ')
          ..write('audioFilePath: $audioFilePath, ')
          ..write('savedNoteId: $savedNoteId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $NoteTagsTable noteTags = $NoteTagsTable(this);
  late final $AiServiceConfigsTable aiServiceConfigs =
      $AiServiceConfigsTable(this);
  late final $ConversationEntriesTable conversationEntries =
      $ConversationEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [notes, tags, noteTags, aiServiceConfigs, conversationEntries];
}

typedef $$NotesTableCreateCompanionBuilder = NotesCompanion Function({
  Value<int> id,
  required String originalText,
  Value<String?> optimizedText,
  Value<String?> translatedText,
  Value<String> detectedLanguage,
  Value<double> detectionConfidence,
  Value<String?> audioFilePath,
  Value<int?> audioFileSizeBytes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isFavorite,
});
typedef $$NotesTableUpdateCompanionBuilder = NotesCompanion Function({
  Value<int> id,
  Value<String> originalText,
  Value<String?> optimizedText,
  Value<String?> translatedText,
  Value<String> detectedLanguage,
  Value<double> detectionConfidence,
  Value<String?> audioFilePath,
  Value<int?> audioFileSizeBytes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isFavorite,
});

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originalText => $composableBuilder(
      column: $table.originalText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get optimizedText => $composableBuilder(
      column: $table.optimizedText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get translatedText => $composableBuilder(
      column: $table.translatedText,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get detectedLanguage => $composableBuilder(
      column: $table.detectedLanguage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get detectionConfidence => $composableBuilder(
      column: $table.detectionConfidence,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioFilePath => $composableBuilder(
      column: $table.audioFilePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get audioFileSizeBytes => $composableBuilder(
      column: $table.audioFileSizeBytes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnFilters(column));
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originalText => $composableBuilder(
      column: $table.originalText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get optimizedText => $composableBuilder(
      column: $table.optimizedText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get translatedText => $composableBuilder(
      column: $table.translatedText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get detectedLanguage => $composableBuilder(
      column: $table.detectedLanguage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get detectionConfidence => $composableBuilder(
      column: $table.detectionConfidence,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioFilePath => $composableBuilder(
      column: $table.audioFilePath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get audioFileSizeBytes => $composableBuilder(
      column: $table.audioFileSizeBytes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnOrderings(column));
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get originalText => $composableBuilder(
      column: $table.originalText, builder: (column) => column);

  GeneratedColumn<String> get optimizedText => $composableBuilder(
      column: $table.optimizedText, builder: (column) => column);

  GeneratedColumn<String> get translatedText => $composableBuilder(
      column: $table.translatedText, builder: (column) => column);

  GeneratedColumn<String> get detectedLanguage => $composableBuilder(
      column: $table.detectedLanguage, builder: (column) => column);

  GeneratedColumn<double> get detectionConfidence => $composableBuilder(
      column: $table.detectionConfidence, builder: (column) => column);

  GeneratedColumn<String> get audioFilePath => $composableBuilder(
      column: $table.audioFilePath, builder: (column) => column);

  GeneratedColumn<int> get audioFileSizeBytes => $composableBuilder(
      column: $table.audioFileSizeBytes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);
}

class $$NotesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotesTable,
    NoteData,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (NoteData, BaseReferences<_$AppDatabase, $NotesTable, NoteData>),
    NoteData,
    PrefetchHooks Function()> {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> originalText = const Value.absent(),
            Value<String?> optimizedText = const Value.absent(),
            Value<String?> translatedText = const Value.absent(),
            Value<String> detectedLanguage = const Value.absent(),
            Value<double> detectionConfidence = const Value.absent(),
            Value<String?> audioFilePath = const Value.absent(),
            Value<int?> audioFileSizeBytes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
          }) =>
              NotesCompanion(
            id: id,
            originalText: originalText,
            optimizedText: optimizedText,
            translatedText: translatedText,
            detectedLanguage: detectedLanguage,
            detectionConfidence: detectionConfidence,
            audioFilePath: audioFilePath,
            audioFileSizeBytes: audioFileSizeBytes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isFavorite: isFavorite,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String originalText,
            Value<String?> optimizedText = const Value.absent(),
            Value<String?> translatedText = const Value.absent(),
            Value<String> detectedLanguage = const Value.absent(),
            Value<double> detectionConfidence = const Value.absent(),
            Value<String?> audioFilePath = const Value.absent(),
            Value<int?> audioFileSizeBytes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
          }) =>
              NotesCompanion.insert(
            id: id,
            originalText: originalText,
            optimizedText: optimizedText,
            translatedText: translatedText,
            detectedLanguage: detectedLanguage,
            detectionConfidence: detectionConfidence,
            audioFilePath: audioFilePath,
            audioFileSizeBytes: audioFileSizeBytes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isFavorite: isFavorite,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotesTable,
    NoteData,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (NoteData, BaseReferences<_$AppDatabase, $NotesTable, NoteData>),
    NoteData,
    PrefetchHooks Function()>;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  required String name,
  Value<DateTime> createdAt,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<DateTime> createdAt,
});

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TagsTable,
    Tag,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (Tag, BaseReferences<_$AppDatabase, $TagsTable, Tag>),
    Tag,
    PrefetchHooks Function()> {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TagsCompanion(
            id: id,
            name: name,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TagsCompanion.insert(
            id: id,
            name: name,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TagsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TagsTable,
    Tag,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (Tag, BaseReferences<_$AppDatabase, $TagsTable, Tag>),
    Tag,
    PrefetchHooks Function()>;
typedef $$NoteTagsTableCreateCompanionBuilder = NoteTagsCompanion Function({
  required int noteId,
  required int tagId,
  Value<int> rowid,
});
typedef $$NoteTagsTableUpdateCompanionBuilder = NoteTagsCompanion Function({
  Value<int> noteId,
  Value<int> tagId,
  Value<int> rowid,
});

class $$NoteTagsTableFilterComposer
    extends Composer<_$AppDatabase, $NoteTagsTable> {
  $$NoteTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get noteId => $composableBuilder(
      column: $table.noteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tagId => $composableBuilder(
      column: $table.tagId, builder: (column) => ColumnFilters(column));
}

class $$NoteTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteTagsTable> {
  $$NoteTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get noteId => $composableBuilder(
      column: $table.noteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tagId => $composableBuilder(
      column: $table.tagId, builder: (column) => ColumnOrderings(column));
}

class $$NoteTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteTagsTable> {
  $$NoteTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get noteId =>
      $composableBuilder(column: $table.noteId, builder: (column) => column);

  GeneratedColumn<int> get tagId =>
      $composableBuilder(column: $table.tagId, builder: (column) => column);
}

class $$NoteTagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NoteTagsTable,
    NoteTag,
    $$NoteTagsTableFilterComposer,
    $$NoteTagsTableOrderingComposer,
    $$NoteTagsTableAnnotationComposer,
    $$NoteTagsTableCreateCompanionBuilder,
    $$NoteTagsTableUpdateCompanionBuilder,
    (NoteTag, BaseReferences<_$AppDatabase, $NoteTagsTable, NoteTag>),
    NoteTag,
    PrefetchHooks Function()> {
  $$NoteTagsTableTableManager(_$AppDatabase db, $NoteTagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> noteId = const Value.absent(),
            Value<int> tagId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NoteTagsCompanion(
            noteId: noteId,
            tagId: tagId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int noteId,
            required int tagId,
            Value<int> rowid = const Value.absent(),
          }) =>
              NoteTagsCompanion.insert(
            noteId: noteId,
            tagId: tagId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NoteTagsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NoteTagsTable,
    NoteTag,
    $$NoteTagsTableFilterComposer,
    $$NoteTagsTableOrderingComposer,
    $$NoteTagsTableAnnotationComposer,
    $$NoteTagsTableCreateCompanionBuilder,
    $$NoteTagsTableUpdateCompanionBuilder,
    (NoteTag, BaseReferences<_$AppDatabase, $NoteTagsTable, NoteTag>),
    NoteTag,
    PrefetchHooks Function()>;
typedef $$AiServiceConfigsTableCreateCompanionBuilder
    = AiServiceConfigsCompanion Function({
  required String id,
  required String serviceType,
  required String providerKey,
  required String displayName,
  required String model,
  Value<String?> customBaseUrl,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$AiServiceConfigsTableUpdateCompanionBuilder
    = AiServiceConfigsCompanion Function({
  Value<String> id,
  Value<String> serviceType,
  Value<String> providerKey,
  Value<String> displayName,
  Value<String> model,
  Value<String?> customBaseUrl,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$AiServiceConfigsTableFilterComposer
    extends Composer<_$AppDatabase, $AiServiceConfigsTable> {
  $$AiServiceConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serviceType => $composableBuilder(
      column: $table.serviceType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get providerKey => $composableBuilder(
      column: $table.providerKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customBaseUrl => $composableBuilder(
      column: $table.customBaseUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AiServiceConfigsTableOrderingComposer
    extends Composer<_$AppDatabase, $AiServiceConfigsTable> {
  $$AiServiceConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serviceType => $composableBuilder(
      column: $table.serviceType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get providerKey => $composableBuilder(
      column: $table.providerKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customBaseUrl => $composableBuilder(
      column: $table.customBaseUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AiServiceConfigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiServiceConfigsTable> {
  $$AiServiceConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serviceType => $composableBuilder(
      column: $table.serviceType, builder: (column) => column);

  GeneratedColumn<String> get providerKey => $composableBuilder(
      column: $table.providerKey, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get customBaseUrl => $composableBuilder(
      column: $table.customBaseUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AiServiceConfigsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AiServiceConfigsTable,
    AiServiceConfigData,
    $$AiServiceConfigsTableFilterComposer,
    $$AiServiceConfigsTableOrderingComposer,
    $$AiServiceConfigsTableAnnotationComposer,
    $$AiServiceConfigsTableCreateCompanionBuilder,
    $$AiServiceConfigsTableUpdateCompanionBuilder,
    (
      AiServiceConfigData,
      BaseReferences<_$AppDatabase, $AiServiceConfigsTable, AiServiceConfigData>
    ),
    AiServiceConfigData,
    PrefetchHooks Function()> {
  $$AiServiceConfigsTableTableManager(
      _$AppDatabase db, $AiServiceConfigsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiServiceConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiServiceConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiServiceConfigsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> serviceType = const Value.absent(),
            Value<String> providerKey = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<String> model = const Value.absent(),
            Value<String?> customBaseUrl = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AiServiceConfigsCompanion(
            id: id,
            serviceType: serviceType,
            providerKey: providerKey,
            displayName: displayName,
            model: model,
            customBaseUrl: customBaseUrl,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String serviceType,
            required String providerKey,
            required String displayName,
            required String model,
            Value<String?> customBaseUrl = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AiServiceConfigsCompanion.insert(
            id: id,
            serviceType: serviceType,
            providerKey: providerKey,
            displayName: displayName,
            model: model,
            customBaseUrl: customBaseUrl,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AiServiceConfigsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AiServiceConfigsTable,
    AiServiceConfigData,
    $$AiServiceConfigsTableFilterComposer,
    $$AiServiceConfigsTableOrderingComposer,
    $$AiServiceConfigsTableAnnotationComposer,
    $$AiServiceConfigsTableCreateCompanionBuilder,
    $$AiServiceConfigsTableUpdateCompanionBuilder,
    (
      AiServiceConfigData,
      BaseReferences<_$AppDatabase, $AiServiceConfigsTable, AiServiceConfigData>
    ),
    AiServiceConfigData,
    PrefetchHooks Function()>;
typedef $$ConversationEntriesTableCreateCompanionBuilder
    = ConversationEntriesCompanion Function({
  required String id,
  required String inputText,
  required String inputLang,
  Value<String> detectionSource,
  Value<String?> optimizedText,
  Value<String?> translatedText,
  Value<String?> audioFilePath,
  Value<int?> savedNoteId,
  required int createdAt,
  Value<int> rowid,
});
typedef $$ConversationEntriesTableUpdateCompanionBuilder
    = ConversationEntriesCompanion Function({
  Value<String> id,
  Value<String> inputText,
  Value<String> inputLang,
  Value<String> detectionSource,
  Value<String?> optimizedText,
  Value<String?> translatedText,
  Value<String?> audioFilePath,
  Value<int?> savedNoteId,
  Value<int> createdAt,
  Value<int> rowid,
});

class $$ConversationEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ConversationEntriesTable> {
  $$ConversationEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inputText => $composableBuilder(
      column: $table.inputText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inputLang => $composableBuilder(
      column: $table.inputLang, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get detectionSource => $composableBuilder(
      column: $table.detectionSource,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get optimizedText => $composableBuilder(
      column: $table.optimizedText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get translatedText => $composableBuilder(
      column: $table.translatedText,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioFilePath => $composableBuilder(
      column: $table.audioFilePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get savedNoteId => $composableBuilder(
      column: $table.savedNoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ConversationEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ConversationEntriesTable> {
  $$ConversationEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inputText => $composableBuilder(
      column: $table.inputText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inputLang => $composableBuilder(
      column: $table.inputLang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get detectionSource => $composableBuilder(
      column: $table.detectionSource,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get optimizedText => $composableBuilder(
      column: $table.optimizedText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get translatedText => $composableBuilder(
      column: $table.translatedText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioFilePath => $composableBuilder(
      column: $table.audioFilePath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get savedNoteId => $composableBuilder(
      column: $table.savedNoteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ConversationEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConversationEntriesTable> {
  $$ConversationEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get inputText =>
      $composableBuilder(column: $table.inputText, builder: (column) => column);

  GeneratedColumn<String> get inputLang =>
      $composableBuilder(column: $table.inputLang, builder: (column) => column);

  GeneratedColumn<String> get detectionSource => $composableBuilder(
      column: $table.detectionSource, builder: (column) => column);

  GeneratedColumn<String> get optimizedText => $composableBuilder(
      column: $table.optimizedText, builder: (column) => column);

  GeneratedColumn<String> get translatedText => $composableBuilder(
      column: $table.translatedText, builder: (column) => column);

  GeneratedColumn<String> get audioFilePath => $composableBuilder(
      column: $table.audioFilePath, builder: (column) => column);

  GeneratedColumn<int> get savedNoteId => $composableBuilder(
      column: $table.savedNoteId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ConversationEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ConversationEntriesTable,
    ConversationEntry,
    $$ConversationEntriesTableFilterComposer,
    $$ConversationEntriesTableOrderingComposer,
    $$ConversationEntriesTableAnnotationComposer,
    $$ConversationEntriesTableCreateCompanionBuilder,
    $$ConversationEntriesTableUpdateCompanionBuilder,
    (
      ConversationEntry,
      BaseReferences<_$AppDatabase, $ConversationEntriesTable,
          ConversationEntry>
    ),
    ConversationEntry,
    PrefetchHooks Function()> {
  $$ConversationEntriesTableTableManager(
      _$AppDatabase db, $ConversationEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConversationEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConversationEntriesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConversationEntriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> inputText = const Value.absent(),
            Value<String> inputLang = const Value.absent(),
            Value<String> detectionSource = const Value.absent(),
            Value<String?> optimizedText = const Value.absent(),
            Value<String?> translatedText = const Value.absent(),
            Value<String?> audioFilePath = const Value.absent(),
            Value<int?> savedNoteId = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ConversationEntriesCompanion(
            id: id,
            inputText: inputText,
            inputLang: inputLang,
            detectionSource: detectionSource,
            optimizedText: optimizedText,
            translatedText: translatedText,
            audioFilePath: audioFilePath,
            savedNoteId: savedNoteId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String inputText,
            required String inputLang,
            Value<String> detectionSource = const Value.absent(),
            Value<String?> optimizedText = const Value.absent(),
            Value<String?> translatedText = const Value.absent(),
            Value<String?> audioFilePath = const Value.absent(),
            Value<int?> savedNoteId = const Value.absent(),
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ConversationEntriesCompanion.insert(
            id: id,
            inputText: inputText,
            inputLang: inputLang,
            detectionSource: detectionSource,
            optimizedText: optimizedText,
            translatedText: translatedText,
            audioFilePath: audioFilePath,
            savedNoteId: savedNoteId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ConversationEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ConversationEntriesTable,
    ConversationEntry,
    $$ConversationEntriesTableFilterComposer,
    $$ConversationEntriesTableOrderingComposer,
    $$ConversationEntriesTableAnnotationComposer,
    $$ConversationEntriesTableCreateCompanionBuilder,
    $$ConversationEntriesTableUpdateCompanionBuilder,
    (
      ConversationEntry,
      BaseReferences<_$AppDatabase, $ConversationEntriesTable,
          ConversationEntry>
    ),
    ConversationEntry,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$NoteTagsTableTableManager get noteTags =>
      $$NoteTagsTableTableManager(_db, _db.noteTags);
  $$AiServiceConfigsTableTableManager get aiServiceConfigs =>
      $$AiServiceConfigsTableTableManager(_db, _db.aiServiceConfigs);
  $$ConversationEntriesTableTableManager get conversationEntries =>
      $$ConversationEntriesTableTableManager(_db, _db.conversationEntries);
}
