import 'package:flutter_test/flutter_test.dart';
import 'package:english_learning/features/notes/domain/entities/note.dart';

void main() {
  final baseTime = DateTime(2026, 3, 18, 10, 0, 0);

  Note makeNote({
    int id = 1,
    String originalText = '今天天气很好',
    String? optimizedText = 'The weather is great today.',
    String? translatedText = '今天天气真好。',
    String detectedLanguage = 'zh',
    double detectionConfidence = 0.9,
    String? audioFilePath,
    int? audioFileSizeBytes,
    bool isFavorite = false,
  }) {
    return Note(
      id: id,
      originalText: originalText,
      optimizedText: optimizedText,
      translatedText: translatedText,
      detectedLanguage: detectedLanguage,
      detectionConfidence: detectionConfidence,
      audioFilePath: audioFilePath,
      audioFileSizeBytes: audioFileSizeBytes,
      createdAt: baseTime,
      updatedAt: baseTime,
      isFavorite: isFavorite,
    );
  }

  group('Note', () {
    group('构造与属性', () {
      test('正确设置所有必填字段', () {
        final note = makeNote();
        expect(note.id, equals(1));
        expect(note.originalText, equals('今天天气很好'));
        expect(note.optimizedText, equals('The weather is great today.'));
        expect(note.translatedText, equals('今天天气真好。'));
        expect(note.detectedLanguage, equals('zh'));
        expect(note.detectionConfidence, equals(0.9));
        expect(note.createdAt, equals(baseTime));
        expect(note.updatedAt, equals(baseTime));
        expect(note.isFavorite, isFalse);
      });

      test('可选字段可以为 null', () {
        final note = makeNote(
          optimizedText: null,
          translatedText: null,
          audioFilePath: null,
          audioFileSizeBytes: null,
        );
        expect(note.optimizedText, isNull);
        expect(note.translatedText, isNull);
        expect(note.audioFilePath, isNull);
        expect(note.audioFileSizeBytes, isNull);
      });

      test('可设置 isFavorite 为 true', () {
        final note = makeNote(isFavorite: true);
        expect(note.isFavorite, isTrue);
      });

      test('可设置音频文件路径和大小', () {
        final note = makeNote(
          audioFilePath: '/storage/emulated/0/audio/test.mp3',
          audioFileSizeBytes: 102400,
        );
        expect(note.audioFilePath, equals('/storage/emulated/0/audio/test.mp3'));
        expect(note.audioFileSizeBytes, equals(102400));
      });
    });

    group('英文笔记', () {
      test('英文笔记 detectedLanguage 为 en，translatedText 可为 null', () {
        final note = makeNote(
          originalText: 'I want to improve my English skills.',
          optimizedText: 'I want to improve my English skills.',
          translatedText: null,
          detectedLanguage: 'en',
          detectionConfidence: 0.9,
        );
        expect(note.detectedLanguage, equals('en'));
        expect(note.translatedText, isNull);
      });
    });
  });

  group('NoteFilter', () {
    test('NoteFilter 枚举包含 all', () {
      expect(NoteFilter.values, contains(NoteFilter.all));
    });

    test('NoteFilter 枚举包含 favorite', () {
      expect(NoteFilter.values, contains(NoteFilter.favorite));
    });

    test('NoteFilter 枚举包含 zhToEn', () {
      expect(NoteFilter.values, contains(NoteFilter.zhToEn));
    });

    test('NoteFilter 枚举包含 enToZh', () {
      expect(NoteFilter.values, contains(NoteFilter.enToZh));
    });

    test('NoteFilter 共有 4 个枚举值', () {
      expect(NoteFilter.values.length, equals(4));
    });

    test('枚举值名称正确', () {
      final names = NoteFilter.values.map((f) => f.name).toList();
      expect(names, containsAll(['all', 'favorite', 'zhToEn', 'enToZh']));
    });
  });
}
