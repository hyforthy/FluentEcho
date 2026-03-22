import 'package:flutter_test/flutter_test.dart';
import 'package:english_learning/features/input/domain/entities/optimization_result.dart';
import 'package:english_learning/features/input/domain/entities/detected_language.dart';

void main() {
  const zhDetectedLanguage = DetectedLanguage(
    language: 'zh',
    confidence: 0.9,
    source: DetectionSource.rule,
  );

  const enDetectedLanguage = DetectedLanguage(
    language: 'en',
    confidence: 0.9,
    source: DetectionSource.rule,
  );

  group('OptimizationResult', () {
    group('构造与基本属性', () {
      test('中文输入 OptimizationResult 含 translatedText', () {
        const result = OptimizationResult(
          optimizedText: 'The weather is great today.',
          translatedText: '今天天气真好。',
          detectedLanguage: zhDetectedLanguage,
        );

        expect(result.optimizedText, equals('The weather is great today.'));
        expect(result.translatedText, equals('今天天气真好。'));
        expect(result.detectedLanguage.language, equals('zh'));
        expect(result.parseWarning, isFalse);
      });

      test('英文输入 OptimizationResult translatedText 为 null', () {
        const result = OptimizationResult(
          optimizedText: 'The weather is great today.',
          detectedLanguage: enDetectedLanguage,
        );

        expect(result.optimizedText, equals('The weather is great today.'));
        expect(result.translatedText, isNull);
        expect(result.detectedLanguage.language, equals('en'));
        expect(result.parseWarning, isFalse);
      });

      test('parseWarning 默认为 false', () {
        const result = OptimizationResult(
          optimizedText: 'test',
          detectedLanguage: enDetectedLanguage,
        );
        expect(result.parseWarning, isFalse);
      });

      test('parseWarning 可设置为 true', () {
        const result = OptimizationResult(
          optimizedText: 'test',
          detectedLanguage: enDetectedLanguage,
          parseWarning: true,
        );
        expect(result.parseWarning, isTrue);
      });
    });

    group('copyWith', () {
      test('copyWith 更新 optimizedText', () {
        const original = OptimizationResult(
          optimizedText: 'Hello',
          detectedLanguage: enDetectedLanguage,
        );

        final updated = original.copyWith(optimizedText: 'Hello world');
        expect(updated.optimizedText, equals('Hello world'));
        expect(updated.detectedLanguage, equals(enDetectedLanguage));
        expect(updated.translatedText, isNull);
      });

      test('copyWith 更新 translatedText', () {
        const original = OptimizationResult(
          optimizedText: 'Good morning',
          detectedLanguage: zhDetectedLanguage,
        );

        final updated = original.copyWith(translatedText: '早上好');
        expect(updated.translatedText, equals('早上好'));
        expect(updated.optimizedText, equals('Good morning'));
      });

      test('copyWith 更新 parseWarning', () {
        const original = OptimizationResult(
          optimizedText: 'test',
          detectedLanguage: enDetectedLanguage,
        );

        final updated = original.copyWith(parseWarning: true);
        expect(updated.parseWarning, isTrue);
      });

      test('copyWith 不改变未指定字段', () {
        const original = OptimizationResult(
          optimizedText: 'test',
          translatedText: '测试',
          detectedLanguage: zhDetectedLanguage,
          parseWarning: true,
        );

        final updated = original.copyWith(optimizedText: 'updated');
        expect(updated.translatedText, equals('测试'));
        expect(updated.detectedLanguage, equals(zhDetectedLanguage));
        expect(updated.parseWarning, isTrue);
      });
    });

    group('相等性（freezed 生成）', () {
      test('相同内容的 OptimizationResult 应相等', () {
        const r1 = OptimizationResult(
          optimizedText: 'Hello',
          detectedLanguage: enDetectedLanguage,
        );
        const r2 = OptimizationResult(
          optimizedText: 'Hello',
          detectedLanguage: enDetectedLanguage,
        );
        expect(r1, equals(r2));
      });

      test('不同 optimizedText 的 OptimizationResult 不相等', () {
        const r1 = OptimizationResult(
          optimizedText: 'Hello',
          detectedLanguage: enDetectedLanguage,
        );
        const r2 = OptimizationResult(
          optimizedText: 'World',
          detectedLanguage: enDetectedLanguage,
        );
        expect(r1, isNot(equals(r2)));
      });
    });
  });
}
