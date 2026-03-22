import 'package:drift/drift.dart';
// Hide Drift's generated ConversationEntry row class to avoid naming conflict with
// the domain entity ConversationEntry from conversation_entry.dart.
import '../../../../core/database/app_database.dart' hide ConversationEntry;
import '../../../../core/database/tables/conversation_entries_table.dart';
import '../../domain/entities/conversation_entry.dart';
import '../../domain/entities/detected_language.dart';

part 'conversation_entry_dao.g.dart';

@DriftAccessor(tables: [ConversationEntries])
class ConversationEntryDao extends DatabaseAccessor<AppDatabase>
    with _$ConversationEntryDaoMixin {
  ConversationEntryDao(super.db);

  Future<void> insertEntry(ConversationEntry entry) =>
      into(conversationEntries).insertOnConflictUpdate(
        ConversationEntriesCompanion.insert(
          id: entry.id,
          inputText: entry.originalText,
          inputLang: entry.detectedLanguage.language,
          detectionSource: Value(_sourceToString(entry.detectedLanguage.source)),
          optimizedText: Value(entry.optimizedText),
          translatedText: Value(entry.translatedText),
          audioFilePath: Value(entry.audioFilePath),
          savedNoteId: Value(entry.savedNoteId),
          createdAt: entry.createdAt.millisecondsSinceEpoch,
        ),
      );

  Future<void> updateEntry(ConversationEntry entry) =>
      (update(conversationEntries)..where((t) => t.id.equals(entry.id)))
          .write(ConversationEntriesCompanion(
        optimizedText: Value(entry.optimizedText),
        translatedText: Value(entry.translatedText),
        audioFilePath: Value(entry.audioFilePath),
        savedNoteId: Value(entry.savedNoteId),
      ));

  /// Loads entries older than the cursor. For first page, pass
  /// createdAtMs = max int, id = '' (sorts before all UUIDs).
  Future<List<ConversationEntry>> getOlderThan({
    required int createdAtMs,
    required String id,
    int limit = 30,
  }) async {
    final rows = await (select(conversationEntries)
          ..where((t) =>
              t.createdAt.isSmallerThanValue(createdAtMs) |
              (t.createdAt.equals(createdAtMs) & t.id.isBiggerThanValue(id)))
          ..orderBy([
            (t) => OrderingTerm.desc(t.createdAt),
            (t) => OrderingTerm.asc(t.id),
          ])
          ..limit(limit))
        .get();
    // Row type is Drift's ConversationEntry (hidden above); dynamic avoids
    // the name conflict while preserving runtime type safety.
    return rows.map((dynamic row) => _rowToEntity(row)).toList();
  }

  ConversationEntry _rowToEntity(dynamic row) {
    return ConversationEntry(
      id: row.id as String,
      originalText: row.inputText as String,
      optimizedText: (row.optimizedText as String?) ?? '',
      detectedLanguage: DetectedLanguage(
        language: row.inputLang as String,
        confidence: 1.0, // Not persisted — restored as neutral default.
        source: row.detectionSource == 'llm'
            ? DetectionSource.llm
            : DetectionSource.rule,
      ),
      translatedText: row.translatedText as String?,
      audioFilePath: row.audioFilePath as String?,
      savedNoteId: row.savedNoteId as int?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt as int),
    );
  }

  String _sourceToString(DetectionSource source) => switch (source) {
        DetectionSource.rule => 'rule',
        DetectionSource.llm => 'llm',
      };
}
