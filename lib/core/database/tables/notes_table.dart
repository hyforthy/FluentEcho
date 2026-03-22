import 'package:drift/drift.dart';

@DataClassName('NoteData')
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get originalText => text()();
  TextColumn get optimizedText => text().nullable()();
  TextColumn get translatedText => text().nullable()();
  TextColumn get detectedLanguage => text().withDefault(const Constant('zh'))();
  RealColumn get detectionConfidence => real().withDefault(const Constant(1.0))();
  TextColumn get audioFilePath => text().nullable()();
  IntColumn get audioFileSizeBytes => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}
