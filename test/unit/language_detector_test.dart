import 'package:flutter_test/flutter_test.dart';
import 'package:english_learning/features/input/domain/services/language_detector.dart';
import 'package:english_learning/features/input/domain/entities/detected_language.dart';

void main() {
  late LanguageDetector detector;

  setUp(() {
    detector = LanguageDetector();
  });

  group('LanguageDetector', () {
    group('纯中文输入', () {
      test('典型中文句子应检测为 zh，置信度高', () {
        final result = detector.detect('今天天气真好，我们去公园散步吧');
        expect(result.language, equals('zh'));
        expect(result.confidence, greaterThanOrEqualTo(0.9));
        expect(result.source, equals(DetectionSource.rule));
      });

      test('单个中文字符应检测为 zh', () {
        final result = detector.detect('好');
        expect(result.language, equals('zh'));
        expect(result.confidence, greaterThanOrEqualTo(0.9));
      });

      test('纯中文（CJK 比例 > 80%）应返回 zh', () {
        final result = detector.detect('我爱学习英语，每天坚持练习，进步很快');
        expect(result.language, equals('zh'));
      });
    });

    group('纯英文输入', () {
      test('典型英文句子应检测为 en，置信度高', () {
        final result = detector.detect('The weather is great today.');
        expect(result.language, equals('en'));
        expect(result.confidence, equals(0.9));
        expect(result.source, equals(DetectionSource.rule));
      });

      test('单个英文单词应检测为 en', () {
        final result = detector.detect('hello');
        expect(result.language, equals('en'));
        expect(result.confidence, equals(0.9));
      });
    });

    group('中英混杂输入', () {
      test('CJK 字符占比 > 30% 应识别为中文相关（zh 或 mixed）', () {
        // 约50% CJK
        final result = detector.detect('我 love 学习 English 很多');
        expect(result.language, isIn(['zh', 'mixed']));
        expect(result.confidence, greaterThan(0.0));
      });

      test('CJK 字符占比在 15-50% 区间应返回 mixed', () {
        // 构造 cjkRatio 约 25%：6 CJK 字符，总共约 24 字符
        // '学习好' = 3 CJK, 'abc' = 3 non-CJK → 6 CJK / ~12 total = 50%，改用
        // '学习好的' = 4 CJK, 'abcdefghijklmno' = 15 non-CJK → ratio ~4/19 ≈ 21%
        final result = detector.detect('学习好的abcdefghijklmno');
        // cjkRatio = 4/19 ≈ 0.21 → 在 (0.15, 0.5) → language = 'mixed', confidence = 0.55
        expect(result.language, equals('mixed'));
        expect(result.confidence, equals(0.55));
      });

      test('CJK 字符占比 < 10% 应检测为 en', () {
        // 2 CJK out of ~30 chars → ratio < 0.1
        final result = detector.detect('This is a long English sentence with 的 one char');
        expect(result.language, equals('en'));
      });
    });

    group('空输入', () {
      test('空字符串应返回 zh，置信度为 1.0（默认）', () {
        final result = detector.detect('');
        // 实际代码：空字符串返回 language: 'zh', confidence: 1.0
        expect(result.language, equals('zh'));
        expect(result.confidence, equals(1.0));
        expect(result.source, equals(DetectionSource.rule));
      });

      test('仅含空格的字符串应返回 zh（trim 后为空）', () {
        final result = detector.detect('   ');
        expect(result.language, equals('zh'));
        expect(result.confidence, equals(1.0));
      });
    });

    group('仅含数字/标点', () {
      test('仅含数字不崩溃，应返回 en', () {
        final result = detector.detect('12345 67890');
        expect(result, isNotNull);
        expect(result.language, equals('en'));
      });

      test('仅含标点不崩溃，应返回 en', () {
        final result = detector.detect('!!! ??? ...');
        expect(result, isNotNull);
        expect(result.language, equals('en'));
      });

      test('混合标点和数字不崩溃', () {
        expect(() => detector.detect('123!@#\$%^&*()'), returnsNormally);
      });
    });

    group('DetectionSource 验证', () {
      test('规则检测结果来源为 rule', () {
        final result = detector.detect('Hello world');
        expect(result.source, equals(DetectionSource.rule));
      });
    });
  });
}
