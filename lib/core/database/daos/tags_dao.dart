import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tags_table.dart';
import '../tables/note_tags_table.dart';

part 'tags_dao.g.dart';

@DriftAccessor(tables: [Tags, NoteTags])
class TagsDao extends DatabaseAccessor<AppDatabase> with _$TagsDaoMixin {
  TagsDao(super.db);

  Future<List<Tag>> getAll() => select(tags).get();

  Stream<List<Tag>> watchAll() => select(tags).watch();

  Future<Tag?> getByName(String name) =>
      (select(tags)..where((t) => t.name.equals(name))).getSingleOrNull();

  Future<int> insertTag(TagsCompanion companion) =>
      into(tags).insert(companion);

  Future<int> deleteTag(int id) =>
      (delete(tags)..where((t) => t.id.equals(id))).go();

  Future<List<Tag>> getTagsForNote(int noteId) async {
    final query = select(tags).join([
      innerJoin(noteTags, noteTags.tagId.equalsExp(tags.id)),
    ])
      ..where(noteTags.noteId.equals(noteId));
    final rows = await query.get();
    return rows.map((row) => row.readTable(tags)).toList();
  }

  Stream<List<Tag>> watchTagsForNote(int noteId) {
    final query = select(tags).join([
      innerJoin(noteTags, noteTags.tagId.equalsExp(tags.id)),
    ])
      ..where(noteTags.noteId.equals(noteId));
    return query.watch().map(
      (rows) => rows.map((row) => row.readTable(tags)).toList(),
    );
  }

  Future<void> addTagToNote(int noteId, int tagId) =>
      into(noteTags).insertOnConflictUpdate(
        NoteTagsCompanion.insert(noteId: noteId, tagId: tagId),
      );

  Future<int> removeTagFromNote(int noteId, int tagId) =>
      (delete(noteTags)
            ..where((t) => t.noteId.equals(noteId) & t.tagId.equals(tagId)))
          .go();

  /// Inserts the tag if it does not exist; returns the existing id if it already does.
  Future<int> insertOrGetByName(String name) async {
    final existing = await (select(tags)..where((t) => t.name.equals(name))).getSingleOrNull();
    if (existing != null) return existing.id;
    return into(tags).insert(TagsCompanion.insert(name: name));
  }
}
