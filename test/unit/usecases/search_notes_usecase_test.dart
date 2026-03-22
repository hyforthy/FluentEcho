import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:english_learning/core/database/app_database.dart';
import 'package:english_learning/features/notes/domain/usecases/search_notes_usecase.dart';

/// 使用 Drift 内存数据库测试 SearchNotesUseCase
void main() {
  late AppDatabase db;
  late SearchNotesUseCase useCase;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    useCase = SearchNotesUseCase(db);

    final now = DateTime.now();
    // 预插入测试数据
    await db.notesDao.insert(
      NotesCompanion.insert(
        originalText: '今天天气很好，适合出去走走',
        optimizedText: const Value('The weather is great today, perfect for a walk'),
        detectedLanguage: const Value('zh'),
        detectionConfidence: const Value(0.9),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    await db.notesDao.insert(
      NotesCompanion.insert(
        originalText: 'I want to improve my English vocabulary',
        optimizedText: const Value('I want to enhance my English vocabulary'),
        detectedLanguage: const Value('en'),
        detectionConfidence: const Value(0.9),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('SearchNotesUseCase（内存数据库）', () {
    test('空字符串搜索词返回空列表', () async {
      final results = await useCase.call('');
      expect(results, isEmpty);
    });

    test('仅含空格的搜索词返回空列表', () async {
      final results = await useCase.call('   ');
      expect(results, isEmpty);
    });

    test('搜索英文词返回包含该词的笔记', () async {
      final results = await useCase.call('English');
      expect(results, isNotEmpty);
      expect(
        results.any((n) =>
            (n.originalText.contains('English') ||
                (n.optimizedText?.contains('English') == true))),
        isTrue,
      );
    });

    test('搜索不存在的词返回空列表', () async {
      final results = await useCase.call('xyz_nonexistent_token');
      expect(results, isEmpty);
    });

    test('搜索词两端有空格时 trim 后正常搜索', () async {
      // '  weather  ' → trim → 'weather'
      final results = await useCase.call('  weather  ');
      expect(results, isNotEmpty);
    });
  });
}
