import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:english_learning/core/storage/audio_file_store.dart';
import 'package:english_learning/core/database/app_database.dart';
import 'package:english_learning/features/notes/domain/usecases/delete_note_usecase.dart';

/// 手写 Fake AudioFileStore，记录 delete() 被调用的路径列表，不依赖文件系统
class _FakeAudioFileStore extends AudioFileStore {
  final List<String> deletedPaths = [];

  @override
  Future<void> delete(String filePath) async {
    deletedPaths.add(filePath);
  }
}

/// 使用 Drift 内存数据库 + FakeAudioFileStore 测试 DeleteNoteUseCase
void main() {
  late AppDatabase db;
  late _FakeAudioFileStore fakeAudioStore;
  late DeleteNoteUseCase useCase;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    fakeAudioStore = _FakeAudioFileStore();
    useCase = DeleteNoteUseCase(db, fakeAudioStore);
  });

  tearDown(() async {
    await db.close();
  });

  group('DeleteNoteUseCase（内存数据库）', () {
    test('删除存在的笔记后 getById 返回 null', () async {
      final now = DateTime.now();
      final id = await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: '待删除笔记',
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await useCase.call(id);

      final note = await db.notesDao.getById(id);
      expect(note, isNull);
    });

    test('删除后 getAll 不再包含该笔记', () async {
      final now = DateTime.now();
      final id = await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: '将被删除的笔记',
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await useCase.call(id);

      final notes = await db.notesDao.getAll();
      expect(notes.any((n) => n.id == id), isFalse);
    });

    test('笔记含音频路径时 delete 会调用 AudioFileStore.delete', () async {
      final now = DateTime.now();
      const audioPath = '/storage/emulated/0/audio/test.mp3';
      final id = await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: '含音频的笔记',
          audioFilePath: const Value(audioPath),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await useCase.call(id);

      expect(fakeAudioStore.deletedPaths, contains(audioPath));
    });

    test('笔记不含音频路径时不调用 AudioFileStore.delete', () async {
      final now = DateTime.now();
      final id = await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: '无音频的笔记',
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await useCase.call(id);

      expect(fakeAudioStore.deletedPaths, isEmpty);
    });

    test('删除不存在的 ID 不崩溃', () async {
      await expectLater(useCase.call(99999), completes);
    });

    test('删除一条笔记不影响其他笔记', () async {
      final now = DateTime.now();
      final id1 = await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: '笔记 A',
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );
      final id2 = await db.notesDao.insert(
        NotesCompanion.insert(
          originalText: '笔记 B',
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await useCase.call(id1);

      final remaining = await db.notesDao.getAll();
      expect(remaining.length, equals(1));
      expect(remaining.first.id, equals(id2));
    });
  });
}
