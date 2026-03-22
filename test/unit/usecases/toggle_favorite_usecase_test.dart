import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:english_learning/core/database/app_database.dart';
import 'package:english_learning/features/notes/domain/usecases/toggle_favorite_usecase.dart';

/// 使用 Drift 内存数据库测试 ToggleFavoriteUseCase
void main() {
  late AppDatabase db;
  late ToggleFavoriteUseCase useCase;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    useCase = ToggleFavoriteUseCase(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('ToggleFavoriteUseCase（内存数据库）', () {
    test('收藏一条普通笔记后 isFavorite 变为 true', () async {
      final now = DateTime.now();
      final id = await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: '普通笔记',
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      // 初始状态确认
      final before = await db.notesDao.getById(id);
      expect(before!.isFavorite, isFalse);

      await useCase.call(id);

      final after = await db.notesDao.getById(id);
      expect(after!.isFavorite, isTrue);
    });

    test('取消收藏后 isFavorite 变为 false', () async {
      final now = DateTime.now();
      final id = await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: '已收藏笔记',
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      // 先收藏
      await useCase.call(id);
      final favorited = await db.notesDao.getById(id);
      expect(favorited!.isFavorite, isTrue);

      // 再取消收藏
      await useCase.call(id);
      final unfavorited = await db.notesDao.getById(id);
      expect(unfavorited!.isFavorite, isFalse);
    });

    test('切换两次后恢复为原始状态（false）', () async {
      final now = DateTime.now();
      final id = await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: '幂等切换测试',
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await useCase.call(id); // false → true
      await useCase.call(id); // true → false

      final note = await db.notesDao.getById(id);
      expect(note!.isFavorite, isFalse);
    });

    test('切换收藏不影响其他笔记的 isFavorite', () async {
      final now = DateTime.now();
      final id1 = await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: '笔记 1',
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );
      final id2 = await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: '笔记 2',
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await useCase.call(id1);

      final note1 = await db.notesDao.getById(id1);
      final note2 = await db.notesDao.getById(id2);
      expect(note1!.isFavorite, isTrue);
      expect(note2!.isFavorite, isFalse);
    });

    test('对不存在 ID 调用不崩溃', () async {
      await expectLater(useCase.call(99999), completes);
    });
  });
}
