import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/notes_table.dart';
import 'tables/tags_table.dart';
import 'tables/note_tags_table.dart';
import 'tables/ai_service_configs_table.dart';
import 'tables/conversation_entries_table.dart';
import 'daos/notes_dao.dart';
import 'daos/tags_dao.dart';
import 'daos/ai_service_configs_dao.dart';
import '../../features/input/data/daos/conversation_entry_dao.dart';

part 'app_database.g.dart';

/// Called when the conversation_entries table had to be recreated during migration
/// (e.g. because a backup rename succeeded but history was cleared).
typedef OnHistoryReset = Future<void> Function();

@DriftDatabase(tables: [Notes, Tags, NoteTags, AiServiceConfigs, ConversationEntries])
class AppDatabase extends _$AppDatabase {
  final OnHistoryReset? onHistoryReset;

  AppDatabase({this.onHistoryReset}) : super(_openConnection());
  AppDatabase.forTesting(super.e) : onHistoryReset = null;

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAllTables();
          await customStatement('''
            CREATE VIRTUAL TABLE IF NOT EXISTS notes_fts
            USING fts5(
              original_text,
              optimized_text,
              translated_text,
              content=notes,
              content_rowid=id,
              tokenize='trigram'
            );
          ''');
          await customStatement('''
            CREATE TRIGGER IF NOT EXISTS notes_ai
            AFTER INSERT ON notes BEGIN
              INSERT INTO notes_fts(rowid, original_text, optimized_text, translated_text)
              VALUES (new.id, new.original_text, new.optimized_text, new.translated_text);
            END;
          ''');
          await customStatement('''
            CREATE TRIGGER IF NOT EXISTS notes_ad
            AFTER DELETE ON notes BEGIN
              INSERT INTO notes_fts(notes_fts, rowid, original_text, optimized_text, translated_text)
              VALUES ('delete', old.id, old.original_text, old.optimized_text, old.translated_text);
            END;
          ''');
          await customStatement('''
            CREATE TRIGGER IF NOT EXISTS notes_au
            AFTER UPDATE ON notes BEGIN
              INSERT INTO notes_fts(notes_fts, rowid, original_text, optimized_text, translated_text)
              VALUES ('delete', old.id, old.original_text, old.optimized_text, old.translated_text);
              INSERT INTO notes_fts(rowid, original_text, optimized_text, translated_text)
              VALUES (new.id, new.original_text, new.optimized_text, new.translated_text);
            END;
          ''');
          await customStatement('''
            CREATE INDEX IF NOT EXISTS idx_ce_cursor
            ON conversation_entries (created_at DESC, id ASC);
          ''');
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(notes, notes.audioFileSizeBytes);
          }
          if (from < 3) {
            await customStatement(
              'ALTER TABLE notes RENAME COLUMN input_language TO detected_language;',
            );
            await m.addColumn(notes, notes.detectionConfidence);
          }
          if (from < 4) {
            await m.createTable(aiServiceConfigs);
          }
          if (from < 5) {
            try {
              await m.createTable(conversationEntries);
            } catch (e) {
              final ts = DateTime.now().millisecondsSinceEpoch;
              await customStatement(
                'ALTER TABLE conversation_entries RENAME TO conversation_entries_backup_$ts',
              );
              await m.createTable(conversationEntries);
              await onHistoryReset?.call();
            }
            await customStatement('''
              CREATE INDEX IF NOT EXISTS idx_ce_cursor
              ON conversation_entries (created_at DESC, id ASC);
            ''');
          }
          if (from < 6) {
            await m.addColumn(notes, notes.skipOptimization);
            await m.addColumn(conversationEntries, conversationEntries.skipOptimization);
          }
        },
      );

  NotesDao get notesDao => NotesDao(this);
  TagsDao get tagsDao => TagsDao(this);
  AiServiceConfigsDao get aiServiceConfigsDao => AiServiceConfigsDao(this);
  ConversationEntryDao get conversationEntryDao => ConversationEntryDao(this);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'english_learning.db'));
    return NativeDatabase.createInBackground(file);
  });
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Override in main.dart ProviderScope');
});
