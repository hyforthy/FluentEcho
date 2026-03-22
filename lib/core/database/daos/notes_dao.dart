import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/notes_table.dart';
import '../tables/note_tags_table.dart';
import '../../../features/notes/domain/entities/note.dart';

part 'notes_dao.g.dart';

@DriftAccessor(tables: [Notes, NoteTags])
class NotesDao extends DatabaseAccessor<AppDatabase> with _$NotesDaoMixin {
  NotesDao(super.db);

  /// Reactive query combining tag filter, language filter, and search.
  /// Re-emits whenever notes OR note_tags table changes.
  Stream<List<Note>> watchNotes({
    NoteFilter filter = NoteFilter.all,
    String? searchQuery,
    int? tagId,
  }) {
    if (tagId != null) {
      return _watchWithTagFilter(
        tagId: tagId,
        filter: filter,
        searchQuery: searchQuery,
      );
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final base = _containsChinese(searchQuery)
          ? _watchWithLike(searchQuery)
          : _watchWithFts(searchQuery);
      if (filter == NoteFilter.all) return base;
      final lang = filter == NoteFilter.zhToEn ? 'zh' : 'en';
      return base.map(
        (notes) => notes.where((n) => n.detectedLanguage == lang).toList(),
      );
    }
    if (filter == NoteFilter.all) {
      return _buildBaseQuery().watch().map(
        (rows) => rows.map(_dataToNote).toList(),
      );
    }
    final lang = filter == NoteFilter.zhToEn ? 'zh' : 'en';
    return _buildBaseQuery().watch().map(
      (rows) => rows
          .where((r) => r.detectedLanguage == lang)
          .map(_dataToNote)
          .toList(),
    );
  }

  Stream<List<Note>> _watchWithTagFilter({
    required int tagId,
    required NoteFilter filter,
    String? searchQuery,
  }) {
    final langClause = filter == NoteFilter.zhToEn
        ? "AND n.detected_language = 'zh'"
        : filter == NoteFilter.enToZh
            ? "AND n.detected_language = 'en'"
            : '';

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final pattern = '%$searchQuery%';
      final sql = '''
        SELECT n.*
        FROM notes n
        INNER JOIN note_tags nt ON nt.note_id = n.id
        WHERE nt.tag_id = ?
          $langClause
          AND (n.original_text LIKE ? OR n.optimized_text LIKE ? OR n.translated_text LIKE ?)
        ORDER BY n.created_at DESC
      ''';
      return customSelect(
        sql,
        variables: [
          Variable.withInt(tagId),
          Variable.withString(pattern),
          Variable.withString(pattern),
          Variable.withString(pattern),
        ],
        readsFrom: {notes, noteTags},
      ).watch().map((rows) => rows.map(_queryRowToNote).toList());
    }

    final sql = '''
      SELECT n.*
      FROM notes n
      INNER JOIN note_tags nt ON nt.note_id = n.id
      WHERE nt.tag_id = ?
        $langClause
      ORDER BY n.created_at DESC
    ''';
    return customSelect(
      sql,
      variables: [Variable.withInt(tagId)],
      readsFrom: {notes, noteTags},
    ).watch().map((rows) => rows.map(_queryRowToNote).toList());
  }

  Stream<List<Note>> watchAll({
    String? searchQuery,
  }) {
    if (searchQuery != null && searchQuery.isNotEmpty) {
      if (_containsChinese(searchQuery)) {
        return _watchWithLike(searchQuery);
      }
      return _watchWithFts(searchQuery);
    }
    return _buildBaseQuery().watch().map(
      (rows) => rows.map(_dataToNote).toList(),
    );
  }

  Future<List<Note>> getAll({
    String? searchQuery,
  }) async {
    if (searchQuery != null && searchQuery.isNotEmpty) {
      if (_containsChinese(searchQuery)) {
        return _getWithLike(searchQuery);
      }
      return _getWithFts(searchQuery);
    }
    final rows = await _buildBaseQuery().get();
    return rows.map(_dataToNote).toList();
  }

  Future<Note?> getById(int id) async {
    final row = await (select(notes)..where((n) => n.id.equals(id))).getSingleOrNull();
    return row == null ? null : _dataToNote(row);
  }

  Future<int> insert(NotesCompanion companion) =>
      into(notes).insert(companion);

  Future<bool> updateNote(NotesCompanion companion) =>
      update(notes).replace(companion);

  Future<int> deleteById(int id) =>
      (delete(notes)..where((n) => n.id.equals(id))).go();

  Future<void> updateAudioPath(int noteId, String audioPath) =>
      (update(notes)..where((n) => n.id.equals(noteId))).write(
        NotesCompanion(audioFilePath: Value(audioPath)),
      );

  Future<void> clearAudioPath(int noteId) =>
      (update(notes)..where((n) => n.id.equals(noteId))).write(
        const NotesCompanion(audioFilePath: Value(null)),
      );

  Future<void> clearAllAudioPaths() =>
      update(notes).write(const NotesCompanion(audioFilePath: Value(null)));

  Future<Set<String>> getAllAudioPaths() async {
    final rows = await (select(notes)
          ..where((n) => n.audioFilePath.isNotNull()))
        .get();
    return rows.map((r) => r.audioFilePath!).toSet();
  }

  SimpleSelectStatement<$NotesTable, NoteData> _buildBaseQuery() {
    final query = select(notes);
    query.orderBy([(n) => OrderingTerm.desc(n.createdAt)]);
    return query;
  }

  bool _containsChinese(String text) =>
      RegExp(r'[\u4e00-\u9fff\u3400-\u4dbf]').hasMatch(text);

  Stream<List<Note>> _watchWithFts(String searchQuery) {
    return customSelect(
      _ftsSql,
      variables: [Variable.withString(searchQuery)],
      readsFrom: {notes},
    ).watch().map((rows) => rows.map(_queryRowToNote).toList());
  }

  Future<List<Note>> _getWithFts(String searchQuery) async {
    final rows = await customSelect(
      _ftsSql,
      variables: [Variable.withString(searchQuery)],
      readsFrom: {notes},
    ).get();
    return rows.map(_queryRowToNote).toList();
  }

  static const _ftsSql = '''
    SELECT n.*
    FROM notes n
    INNER JOIN notes_fts fts ON fts.rowid = n.id
    WHERE notes_fts MATCH ?
    ORDER BY n.created_at DESC
  ''';

  Stream<List<Note>> _watchWithLike(String searchQuery) {
    final pattern = '%$searchQuery%';
    return customSelect(
      _likeSql,
      variables: [
        Variable.withString(pattern),
        Variable.withString(pattern),
        Variable.withString(pattern),
      ],
      readsFrom: {notes},
    ).watch().map((rows) => rows.map(_queryRowToNote).toList());
  }

  Future<List<Note>> _getWithLike(String searchQuery) async {
    final pattern = '%$searchQuery%';
    final rows = await customSelect(
      _likeSql,
      variables: [
        Variable.withString(pattern),
        Variable.withString(pattern),
        Variable.withString(pattern),
      ],
      readsFrom: {notes},
    ).get();
    return rows.map(_queryRowToNote).toList();
  }

  static const _likeSql = '''
    SELECT * FROM notes
    WHERE original_text LIKE ?
       OR optimized_text LIKE ?
       OR translated_text LIKE ?
    ORDER BY created_at DESC
  ''';

  Note _dataToNote(NoteData row) => Note(
        id: row.id,
        originalText: row.originalText,
        optimizedText: row.optimizedText,
        translatedText: row.translatedText,
        detectedLanguage: row.detectedLanguage,
        detectionConfidence: row.detectionConfidence,
        audioFilePath: row.audioFilePath,
        audioFileSizeBytes: row.audioFileSizeBytes,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        isFavorite: row.isFavorite,
      );

  Note _queryRowToNote(QueryRow row) => Note(
        id: row.read<int>('id'),
        originalText: row.read<String>('original_text'),
        optimizedText: row.readNullable<String>('optimized_text'),
        translatedText: row.readNullable<String>('translated_text'),
        detectedLanguage: row.read<String>('detected_language'),
        detectionConfidence: row.read<double>('detection_confidence'),
        audioFilePath: row.readNullable<String>('audio_file_path'),
        audioFileSizeBytes: row.readNullable<int>('audio_file_size_bytes'),
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          row.read<int>('created_at') * 1000,
        ),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          row.read<int>('updated_at') * 1000,
        ),
        isFavorite: row.read<int>('is_favorite') == 1,
      );
}
