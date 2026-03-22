import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:english_learning/core/database/app_database.dart';
import 'package:english_learning/features/notes/domain/usecases/save_note_usecase.dart';

/// 使用 Drift 内存数据库测试 SaveNoteUseCase（不 mock，不 stub）
void main() {
  late AppDatabase db;
  late SaveNoteUseCase useCase;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    useCase = SaveNoteUseCase(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('SaveNoteUseCase（内存数据库）', () {
    test('正常保存返回正整数 ID', () async {
      final id = await useCase.call(
        originalText: '今天天气很好',
        optimizedText: 'The weather is great today.',
        translatedText: '今天天气真好。',
        detectedLanguage: 'zh',
        confidence: 0.9,
      );

      expect(id, greaterThan(0));
    });

    test('保存后可通过 DAO 读取笔记内容', () async {
      final id = await useCase.call(
        originalText: '我爱学习英语',
        optimizedText: 'I love learning English.',
        detectedLanguage: 'zh',
        confidence: 0.9,
      );

      final note = await db.notesDao.getById(id);
      expect(note, isNotNull);
      expect(note!.originalText, equals('我爱学习英语'));
      expect(note.optimizedText, equals('I love learning English.'));
      expect(note.detectedLanguage, equals('zh'));
    });

    test('不提供 optimizedText 时可正常保存', () async {
      final id = await useCase.call(
        originalText: 'Hello world',
        detectedLanguage: 'en',
        confidence: 0.9,
      );

      final note = await db.notesDao.getById(id);
      expect(note, isNotNull);
      expect(note!.optimizedText, isNull);
      expect(note.translatedText, isNull);
    });

    test('多次保存返回不同 ID', () async {
      final id1 = await useCase.call(
        originalText: 'first note',
        detectedLanguage: 'en',
        confidence: 0.9,
      );
      final id2 = await useCase.call(
        originalText: 'second note',
        detectedLanguage: 'en',
        confidence: 0.9,
      );

      expect(id1, isNot(equals(id2)));
    });

    test('保存的 isFavorite 默认为 false', () async {
      final id = await useCase.call(
        originalText: 'test default favorite',
        detectedLanguage: 'en',
        confidence: 0.9,
      );

      final note = await db.notesDao.getById(id);
      expect(note!.isFavorite, isFalse);
    });
  });
}
