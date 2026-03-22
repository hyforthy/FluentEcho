/// TranslateTextUseCase 单元测试
///
/// 测试策略：
/// 本测试通过直接实例化 TranslateTextUseCase 并注入 FakeLLMService，
/// 隔离 provider 层副作用，使测试专注 UseCase 核心翻译逻辑与错误传播行为。
/// （注：ai_config_list_notifier.dart 的编译问题已在 Bug Fix v1.1 中修复）

import 'package:flutter_test/flutter_test.dart';
import 'package:english_learning/core/ai/interfaces/i_llm_service.dart';
import 'package:english_learning/core/errors/app_exception.dart' as app_errors;
import 'package:english_learning/features/input/domain/entities/detected_language.dart';
import 'package:english_learning/features/input/domain/usecases/translate_text_usecase.dart';

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
  late TranslateTextUseCase useCase;

  setUp(() {
    fakeLlm = FakeLLMService();
    useCase = TranslateTextUseCase(fakeLlm);
  });

  group('TranslateTextUseCase', () {
    group('正常翻译', () {
      test('输入英文文本，返回中文翻译字符串', () async {
        const inputText = 'I want to go to school.';
        const expectedTranslation = '我想去学校。';
        fakeLlm.translateStub = ({required text, required detectedLanguage}) =>
            Future.value(expectedTranslation);

        final result = await useCase.execute(inputText);

        expect(result, equals(expectedTranslation));
      });

      test('LLM 返回空字符串时，execute 返回空字符串', () async {
        const inputText = 'Hello world.';
        fakeLlm.translateStub = ({required text, required detectedLanguage}) =>
            Future.value('');

        final result = await useCase.execute(inputText);

        expect(result, equals(''));
      });

      test('调用 translate 时传入正确的语言参数（language=en, confidence=1.0）', () async {
        const inputText = 'Good morning.';
        DetectedLanguage? capturedLanguage;
        fakeLlm.translateStub = ({required text, required detectedLanguage}) {
          capturedLanguage = detectedLanguage;
          return Future.value('早上好。');
        };

        await useCase.execute(inputText);

        expect(capturedLanguage, isNotNull);
        expect(capturedLanguage!.language, equals('en'));
        expect(capturedLanguage!.confidence, equals(1.0));
        expect(capturedLanguage!.source, equals(DetectionSource.rule));
      });
    });

    group('错误传播', () {
      test('LLM 抛出 TimeoutException 时，execute 向调用者传播', () async {
        const inputText = 'test timeout';
        fakeLlm.translateStub = ({required text, required detectedLanguage}) =>
            Future.error(const app_errors.TimeoutException('request timed out'));

        await expectLater(
          useCase.execute(inputText),
          throwsA(isA<app_errors.TimeoutException>()),
        );
      });

      test('LLM 抛出 NetworkException 时，execute 向调用者传播', () async {
        const inputText = 'test network error';
        fakeLlm.translateStub = ({required text, required detectedLanguage}) =>
            Future.error(const app_errors.NetworkException('network error'));

        await expectLater(
          useCase.execute(inputText),
          throwsA(isA<app_errors.NetworkException>()),
        );
      });
    });
  });
}
