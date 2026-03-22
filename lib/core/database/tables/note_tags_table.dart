import 'package:drift/drift.dart';

class NoteTags extends Table {
  IntColumn get noteId => integer()();
  IntColumn get tagId => integer()();

  @override
  Set<Column> get primaryKey => {noteId, tagId};
}
