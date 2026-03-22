import 'package:flutter_test/flutter_test.dart';
import 'package:english_learning/core/ai/interfaces/i_llm_service.dart';
import 'package:english_learning/core/errors/app_exception.dart' as app_errors;
import 'package:english_learning/features/input/domain/entities/detected_language.dart';
import 'package:english_learning/features/input/domain/entities/optimization_result.dart';
import 'package:english_learning/features/input/domain/services/language_detector.dart';
import 'package:english_learning/features/input/domain/usecases/optimize_text_usecase.dart';

/// 手写 Fake：ILLMService（不依赖 mockito，不触发 @GenerateMocks 代码生成）
class FakeLLMService implements ILLMService {
  Stream<String> Function({required String text, required DetectedLanguage detectedLanguage})?
      optimizeTextStreamStub;
  Future<String> Function({required String text, required DetectedLanguage detectedLanguage})?
      translateStub;

  @override
  LLMProvider get provider => LLMProvider.openaiCompatible;

  @override
  bool get isConfigured => true;

  @override
  Stream<String> optimizeTextStream({
    required String text,
    required DetectedLanguage detectedLanguage,
  }) {
    if (optimizeTextStreamStub != null) {
      return optimizeTextStreamStub!(text: text, detectedLanguage: detectedLanguage);
    }
    return const Stream.empty();
  }

  @override
  Future<String> translate({
    required String text,
    required DetectedLanguage detectedLanguage,
  }) {
    if (translateStub != null) {
      return translateStub!(text: text, detectedLanguage: detectedLanguage);
    }
    return Future.value('');
  }

  @override
  Future<String> detectLanguage(String text) => Future.value('en');
}

void main() {
  late FakeLLMService fakeLlm;
  late LanguageDetector detector;
  late OptimizeTextUseCase useCase;

  setUp(() {
    fakeLlm = FakeLLMService();
    detector = LanguageDetector();
    useCase = OptimizeTextUseCase(fakeLlm, detector);
  });

  group('OptimizeTextUseCase（核心逻辑）', () {
    group('正常流式优化', () {
      test('英文输入：流式输出逐步累积 optimizedText', () async {
        const inputText = 'i want go to school';
        fakeLlm.optimizeTextStreamStub = ({required text, required detectedLanguage}) =>
            Stream.fromIterable(['I ', 'want ', 'to go ', 'to school.']);

        final results = <OptimizationResult>[];
        await for (final r in useCase.execute(inputText)) {
          results.add(r);
        }

        expect(results.length, equals(4));
        expect(results.last.optimizedText, equals('I want to go to school.'));
        expect(results.first.optimizedText, equals('I '));
      });

      test('中文输入：检测语言为 zh 并传给 LLM', () async {
        const inputText = '我想去学校';
        fakeLlm.optimizeTextStreamStub = ({required text, required detectedLanguage}) =>
            Stream.fromIterable(['I want ', 'to go to school.']);

        final results = <OptimizationResult>[];
        await for (final r in useCase.execute(inputText)) {
          results.add(r);
        }

        for (final r in results) {
          expect(r.detectedLanguage.language, equals('zh'));
        }
        expect(results.last.optimizedText, equals('I want to go to school.'));
      });

      test('LLM 返回单个 delta 时，只产生一个结果', () async {
        const inputText = 'test input';
        fakeLlm.optimizeTextStreamStub = ({required text, required detectedLanguage}) =>
            Stream.fromIterable(['Optimized output.']);

        final results = <OptimizationResult>[];
        await for (final r in useCase.execute(inputText)) {
          results.add(r);
        }

        expect(results.length, equals(1));
        expect(results.first.optimizedText, equals('Optimized output.'));
      });

      test('LLM 返回空流时，不产生任何结果', () async {
        const inputText = 'hello';
        fakeLlm.optimizeTextStreamStub = ({required text, required detectedLanguage}) =>
            const Stream.empty();

        final results = <OptimizationResult>[];
        await for (final r in useCase.execute(inputText)) {
          results.add(r);
        }

        expect(results, isEmpty);
      });
    });

    group('错误传播', () {
      test('LLM 抛出 TimeoutException 时 UseCase 向调用者传播', () async {
        const inputText = 'test timeout';
        fakeLlm.optimizeTextStreamStub = ({required text, required detectedLanguage}) =>
            Stream.error(const app_errors.TimeoutException('request timed out'));

        await expectLater(
          () async {
            await for (final _ in useCase.execute(inputText)) {}
          },
          throwsA(isA<app_errors.TimeoutException>()),
        );
      });

      test('LLM 抛出 NetworkException 时 UseCase 向调用者传播', () async {
        const inputText = 'test network error';
        fakeLlm.optimizeTextStreamStub = ({required text, required detectedLanguage}) =>
            Stream.error(const app_errors.NetworkException('network error'));

        await expectLater(
          () async {
            await for (final _ in useCase.execute(inputText)) {}
          },
          throwsA(isA<app_errors.NetworkException>()),
        );
      });
    });
  });
}
