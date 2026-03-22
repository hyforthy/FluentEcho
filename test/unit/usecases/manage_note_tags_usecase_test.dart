import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:english_learning/core/database/app_database.dart';
import 'package:english_learning/features/notes/domain/usecases/manage_note_tags_usecase.dart';

/// 使用 Drift 内存数据库测试 AddTagToNoteUseCase / RemoveTagFromNoteUseCase
void main() {
  late AppDatabase db;
  late AddTagToNoteUseCase addTagUseCase;
  late RemoveTagFromNoteUseCase removeTagUseCase;

  /// 在 notes 表中插入一条最简笔记，返回其 id
  Future<int> _insertNote() async {
    final now = DateTime.now();
    return db.notesDao.insert(
      NotesCompanion.insert(
        originalText: 'test note',
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    addTagUseCase = AddTagToNoteUseCase(db);
    removeTagUseCase = RemoveTagFromNoteUseCase(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('AddTagToNoteUseCase（内存数据库）', () {
    test('新标签名 → 创建标签并关联笔记', () async {
      final noteId = await _insertNote();

      await addTagUseCase.call(noteId, 'Flutter');

      final tags = await db.tagsDao.getTagsForNote(noteId);
      expect(tags.length, equals(1));
      expect(tags.first.name, equals('Flutter'));
    });

    test('已有标签名 → 重复关联同一笔记幂等（不抛异常，仍只有一个关联）', () async {
      final noteId = await _insertNote();

      // 第一次添加
      await addTagUseCase.call(noteId, 'Dart');
      // 第二次以相同名称调用同一笔记：insertOrGetByName 幂等，addTagToNote 使用
      // insertOnConflictUpdate，整体操作不抛异常
      await addTagUseCase.call(noteId, 'Dart');

      final tags = await db.tagsDao.getTagsForNote(noteId);
      expect(tags.length, equals(1));
      expect(tags.first.name, equals('Dart'));
    });

    test('同一标签名关联不同笔记 → 两次调用均成功', () async {
      final noteId1 = await _insertNote();
      final noteId2 = await _insertNote();

      await addTagUseCase.call(noteId1, 'Dart');
      await addTagUseCase.call(noteId2, 'Dart');

      final tags1 = await db.tagsDao.getTagsForNote(noteId1);
      final tags2 = await db.tagsDao.getTagsForNote(noteId2);
      expect(tags1.first.name, equals('Dart'));
      expect(tags2.first.name, equals('Dart'));
      // 只有一个 Dart 标签记录（insertOrGetByName 幂等）
      expect(tags1.first.id, equals(tags2.first.id));
    });

    test('标签名为空字符串 → UseCase 不抛异常，空名标签正常插入', () async {
      final noteId = await _insertNote();

      // UseCase 不校验空字符串，直接透传给 DAO；首次插入空名标签可成功
      await addTagUseCase.call(noteId, '');

      final tags = await db.tagsDao.getTagsForNote(noteId);
      expect(tags.length, equals(1));
      expect(tags.first.name, equals(''));
    });

    test('同一笔记可关联多个不同标签', () async {
      final noteId = await _insertNote();

      await addTagUseCase.call(noteId, 'grammar');
      await addTagUseCase.call(noteId, 'vocabulary');

      final tags = await db.tagsDao.getTagsForNote(noteId);
      expect(tags.length, equals(2));
      final names = tags.map((t) => t.name).toSet();
      expect(names, containsAll(['grammar', 'vocabulary']));
    });
  });

  group('RemoveTagFromNoteUseCase（内存数据库）', () {
    test('正常移除笔记标签关联', () async {
      final noteId = await _insertNote();
      await addTagUseCase.call(noteId, 'remove-me');
      final tag = await db.tagsDao.getByName('remove-me');
      expect(tag, isNotNull);

      await removeTagUseCase.call(noteId, tag!.id);

      final tags = await db.tagsDao.getTagsForNote(noteId);
      expect(tags, isEmpty);
    });

    test('移除操作使用正确的 noteId 和 tagId', () async {
      final noteId = await _insertNote();
      await addTagUseCase.call(noteId, 'keep');
      await addTagUseCase.call(noteId, 'remove');

      final removeTag = await db.tagsDao.getByName('remove');
      await removeTagUseCase.call(noteId, removeTag!.id);

      final remaining = await db.tagsDao.getTagsForNote(noteId);
      expect(remaining.length, equals(1));
      expect(remaining.first.name, equals('keep'));
    });

    test('移除不存在的关联 → 不报错（DAO 返回 0 行受影响）', () async {
      final noteId = await _insertNote();
      const nonExistentTagId = 99999;

      // removeTagFromNote 删除 0 行时不抛异常
      await removeTagUseCase.call(noteId, nonExistentTagId);

      // 笔记无标签，验证状态未被破坏
      final tags = await db.tagsDao.getTagsForNote(noteId);
      expect(tags, isEmpty);
    });
  });
}
