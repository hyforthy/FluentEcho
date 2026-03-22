import 'package:drift/drift.dart';

class ConversationEntries extends Table {
  TextColumn get id => text()();
  TextColumn get inputText => text()();
  TextColumn get inputLang => text()();
  TextColumn get detectionSource => text().withDefault(const Constant('rule'))();
  TextColumn get optimizedText => text().nullable()();
  TextColumn get translatedText => text().nullable()();
  TextColumn get audioFilePath => text().nullable()();
  IntColumn get savedNoteId => integer().nullable()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
