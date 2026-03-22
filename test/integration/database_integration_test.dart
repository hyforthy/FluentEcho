import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:english_learning/core/database/app_database.dart';
import 'package:english_learning/features/notes/domain/entities/note.dart';

/// 创建内存数据库实例供测试使用
AppDatabase _buildTestDb() {
  return AppDatabase.forTesting(NativeDatabase.memory());
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = _buildTestDb();
  });

  tearDown(() async {
    await db.close();
  });

  group('数据库 schema', () {
    test('schemaVersion 为 4', () {
      expect(db.schemaVersion, equals(4));
    });
  });

  group('笔记 CRUD', () {
    test('插入笔记后可通过 ID 读取', () async {
      final now = DateTime.now();
      final id = await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: '今天天气很好',
          optimizedText: const Value('The weather is great today.'),
          detectedLanguage: const Value('zh'),
          detectionConfidence: const Value(0.9),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      final note = await db.notesDao.getById(id);
      expect(note, isNotNull);
      expect(note!.id, equals(id));
      expect(note.originalText, equals('今天天气很好'));
      expect(note.optimizedText, equals('The weather is great today.'));
      expect(note.detectedLanguage, equals('zh'));
    });

    test('getAll 返回所有笔记，最新优先', () async {
      final t1 = DateTime(2026, 3, 1);
      final t2 = DateTime(2026, 3, 15);

      await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: 'First note',
          createdAt: Value(t1),
          updatedAt: Value(t1),
        ),
      );
      await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: 'Second note',
          createdAt: Value(t2),
          updatedAt: Value(t2),
        ),
      );

      final notes = await db.notesDao.getAll();
      expect(notes.length, equals(2));
      // 最新优先
      expect(notes.first.originalText, equals('Second note'));
    });

    test('deleteById 删除后 getById 返回 null', () async {
      final now = DateTime.now();
      final id = await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: 'to be deleted',
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await db.notesDao.deleteById(id);

      final note = await db.notesDao.getById(id);
      expect(note, isNull);
    });

    test('updateNote 更新字段', () async {
      final now = DateTime.now();
      final id = await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: 'original',
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await db.notesDao.updateNote(
        NotesCompanion(
          id: Value(id),
          originalText: const Value('updated'),
          updatedAt: Value(DateTime.now()),
        ),
      );

      final note = await db.notesDao.getById(id);
      expect(note!.originalText, equals('updated'));
    });

    test('插入多条笔记并验证数量', () async {
      final now = DateTime.now();
      for (int i = 0; i < 5; i++) {
        await db.notesDao.insert(
          NotesCompanion.insert(
            originalText: 'Note $i',
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
      }

      final notes = await db.notesDao.getAll();
      expect(notes.length, equals(5));
    });
  });

  group('收藏切换', () {
    test('toggleFavorite 将 isFavorite false→true', () async {
      final now = DateTime.now();
      final id = await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: '测试收藏',
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await db.notesDao.toggleFavorite(id);

      final note = await db.notesDao.getById(id);
      expect(note!.isFavorite, isTrue);
    });

    test('toggleFavorite 连续调用两次恢复为 false', () async {
      final now = DateTime.now();
      final id = await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: '再次切换收藏',
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await db.notesDao.toggleFavorite(id);
      await db.notesDao.toggleFavorite(id);

      final note = await db.notesDao.getById(id);
      expect(note!.isFavorite, isFalse);
    });

    test('对不存在 ID 调用 toggleFavorite 不崩溃', () async {
      expect(
        () => db.notesDao.toggleFavorite(99999),
        returnsNormally,
      );
    });
  });

  group('NoteFilter 过滤', () {
    setUp(() async {
      final now = DateTime.now();
      // 插入 zh 笔记（含 optimizedText）
      await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: '中文笔记',
          optimizedText: const Value('Chinese note'),
          detectedLanguage: const Value('zh'),
          detectionConfidence: const Value(0.9),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );
      // 插入 en 笔记
      await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: 'English note',
          optimizedText: const Value('English note optimized'),
          detectedLanguage: const Value('en'),
          detectionConfidence: const Value(0.9),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );
    });

    test('NoteFilter.all 返回所有笔记', () async {
      final notes = await db.notesDao.getAll(filter: NoteFilter.all);
      expect(notes.length, equals(2));
    });

    test('NoteFilter.favorite 返回收藏笔记', () async {
      final allNotes = await db.notesDao.getAll();
      await db.notesDao.toggleFavorite(allNotes.first.id);

      final favorites = await db.notesDao.getAll(filter: NoteFilter.favorite);
      expect(favorites.length, equals(1));
      expect(favorites.first.isFavorite, isTrue);
    });
  });

  group('FTS5 全文搜索', () {
    test('插入笔记后可通过内容搜索到', () async {
      final now = DateTime.now();
      await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: '英语学习很有趣',
          optimizedText: const Value('Learning English is fun and rewarding'),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      // FTS5 trigram 搜索需要至少 3 字符的 token
      final results = await db.notesDao.getAll(searchQuery: 'English');
      expect(results, isNotEmpty);
      expect(
        results.any((n) => n.optimizedText?.contains('English') == true),
        isTrue,
      );
    });

    test('FTS 搜索不存在的词返回空', () async {
      final now = DateTime.now();
      await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: 'hello world',
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      final results = await db.notesDao.getAll(searchQuery: 'xyz_not_exist_123');
      expect(results, isEmpty);
    });
  });

  group('AI 服务配置 CRUD', () {
    test('插入配置后可通过 ID 读取', () async {
      final now = DateTime.now();
      await db.aiServiceConfigsDao.insert(
        AiServiceConfigsCompanion.insert(
          id: 'config-1',
          serviceType: 'llm',
          providerKey: 'openai',
          displayName: 'GPT-4o',
          model: 'gpt-4o',
          createdAt: now,
          updatedAt: now,
        ),
      );

      final config = await db.aiServiceConfigsDao.getById('config-1');
      expect(config, isNotNull);
      expect(config!.providerKey, equals('openai'));
      expect(config.model, equals('gpt-4o'));
    });

    test('按 serviceType 查询正确返回', () async {
      final now = DateTime.now();
      await db.aiServiceConfigsDao.insert(
        AiServiceConfigsCompanion.insert(
          id: 'llm-1',
          serviceType: 'llm',
          providerKey: 'claude',
          displayName: 'Claude',
          model: 'claude-3-5-sonnet',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.aiServiceConfigsDao.insert(
        AiServiceConfigsCompanion.insert(
          id: 'tts-1',
          serviceType: 'tts',
          providerKey: 'openai',
          displayName: 'OpenAI TTS',
          model: 'tts-1',
          createdAt: now,
          updatedAt: now,
        ),
      );

      final llmConfigs = await db.aiServiceConfigsDao.getByType('llm');
      expect(llmConfigs.length, equals(1));
      expect(llmConfigs.first.id, equals('llm-1'));

      final ttsConfigs = await db.aiServiceConfigsDao.getByType('tts');
      expect(ttsConfigs.length, equals(1));
      expect(ttsConfigs.first.id, equals('tts-1'));
    });

    test('deleteById 删除后 getById 返回 null', () async {
      final now = DateTime.now();
      await db.aiServiceConfigsDao.insert(
        AiServiceConfigsCompanion.insert(
          id: 'del-config',
          serviceType: 'llm',
          providerKey: 'openai',
          displayName: 'test',
          model: 'gpt-4o',
          createdAt: now,
          updatedAt: now,
        ),
      );

      await db.aiServiceConfigsDao.deleteById('del-config');
      final config = await db.aiServiceConfigsDao.getById('del-config');
      expect(config, isNull);
    });
  });

  group('音频路径管理', () {
    test('updateAudioPath 更新音频路径', () async {
      final now = DateTime.now();
      final id = await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: 'audio test',
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await db.notesDao.updateAudioPath(id, '/storage/test.mp3');

      final note = await db.notesDao.getById(id);
      expect(note!.audioFilePath, equals('/storage/test.mp3'));
    });

    test('clearAudioPath 清空音频路径', () async {
      final now = DateTime.now();
      final id = await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: 'audio clear test',
          audioFilePath: const Value('/storage/test.mp3'),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await db.notesDao.clearAudioPath(id);

      final note = await db.notesDao.getById(id);
      expect(note!.audioFilePath, isNull);
    });
  });
}
