/// GenerateSpeechUseCase 单元测试
///
/// 测试策略：
/// GenerateSpeechUseCase 内部直接使用 dart:io File 检查文件存在性和大小，
/// 因此对"文件存在"的测试用例使用 dart:io Directory.systemTemp 创建真实
/// 临时文件（测试结束后清理），其余用例（空路径/文件不存在）使用内存路径即可。
/// FakeTTSService 为手写 Fake，不依赖 mockito。
/// 直接实例化 GenerateSpeechUseCase 注入 Fake，绕过 Riverpod provider 链。

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:english_learning/core/ai/interfaces/i_tts_service.dart';
import 'package:english_learning/shared/tts/domain/usecases/generate_speech_usecase.dart';
import 'package:english_learning/core/errors/app_exception.dart' as app_errors;

/// 手写 Fake：ITTSService
class FakeTTSService implements ITTSService {
  Future<String> Function(String text, {String? voice})? generateStub;
  Stream<List<int>> Function(String text, {String? voice})? generateStreamStub;

  @override
  TTSProvider get provider => TTSProvider.system;

  @override
  Future<String> generate(String text, {String? voice}) {
    if (generateStub != null) {
      return generateStub!(text, voice: voice);
    }
    return Future.value('');
  }

  @override
  Stream<List<int>> generateStream(String text, {String? voice}) {
    if (generateStreamStub != null) {
      return generateStreamStub!(text, voice: voice);
    }
    throw UnsupportedError('generateStream not stubbed');
  }

  @override
  Future<bool> isAvailable() => Future.value(true);
}

void main() {
  late FakeTTSService fakeTts;
  late GenerateSpeechUseCase useCase;

  setUp(() {
    fakeTts = FakeTTSService();
    useCase = GenerateSpeechUseCase(fakeTts);
  });

  group('GenerateSpeechUseCase', () {
    group('TTS 返回空路径（system TTS 直接朗读）', () {
      test('返回 TtsAudio(filePath: \'\', sizeBytes: 0)', () async {
        fakeTts.generateStub = (text, {voice}) => Future.value('');

        final result = await useCase.execute('Hello world.');

        expect(result.filePath, equals(''));
        expect(result.sizeBytes, equals(0));
      });
    });

    group('TTS 返回非空路径', () {
      test('路径文件不存在时，sizeBytes 应为 0', () async {
        final nonExistentPath = '${Directory.systemTemp.path}/__nonexistent_tts_file_12345.wav';
        fakeTts.generateStub = (text, {voice}) => Future.value(nonExistentPath);

        final result = await useCase.execute('Hello world.');

        expect(result.filePath, equals(nonExistentPath));
        expect(result.sizeBytes, equals(0));
      });

      test('路径文件存在时，sizeBytes 等于实际文件字节数', () async {
        final tempDir = Directory.systemTemp;
        final tempFile = File('${tempDir.path}/tts_test_${DateTime.now().millisecondsSinceEpoch}.wav');
        const fakeContent = 'RIFF_fake_audio_data_for_testing';
        await tempFile.writeAsString(fakeContent);

        try {
          fakeTts.generateStub = (text, {voice}) => Future.value(tempFile.path);

          final result = await useCase.execute('Hello world.');
          final expectedSize = await tempFile.length();

          expect(result.filePath, equals(tempFile.path));
          expect(result.sizeBytes, equals(expectedSize));
          expect(result.sizeBytes, greaterThan(0));
        } finally {
          if (await tempFile.exists()) {
            await tempFile.delete();
          }
        }
      });
    });

    group('降级处理', () {
      test('TTS 抛出 TimeoutException 时，execute 返回空 TtsAudio 不抛出', () async {
        fakeTts.generateStub = (text, {voice}) =>
            Future.error(const app_errors.TimeoutException('TTS request timed out'));

        final result = await useCase.execute('Hello world.');

        expect(result.filePath, equals(''));
        expect(result.sizeBytes, equals(0));
      });

      test('TTS 抛出通用 Exception 时，execute 返回空 TtsAudio 不抛出', () async {
        fakeTts.generateStub = (text, {voice}) =>
            Future.error(Exception('unexpected TTS failure'));

        final result = await useCase.execute('Hello world.');

        expect(result.filePath, equals(''));
        expect(result.sizeBytes, equals(0));
      });
    });
  });
}
