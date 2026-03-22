import 'dart:async' as dart_async;

import 'package:flutter_test/flutter_test.dart';
import 'package:english_learning/core/errors/app_exception.dart';
import 'package:english_learning/core/errors/error_handler.dart';

void main() {
  group('AppException 子类构造', () {
    test('NetworkException 可正确构造并持有 message', () {
      const e = NetworkException('network error');
      expect(e.message, equals('network error'));
      expect(e, isA<AppException>());
      expect(e, isA<Exception>());
    });

    test('TimeoutException 可正确构造', () {
      const e = TimeoutException('request timed out');
      expect(e.message, equals('request timed out'));
      expect(e, isA<AppException>());
    });

    test('MissingKeyException 可正确构造', () {
      const e = MissingKeyException('api key missing');
      expect(e.message, equals('api key missing'));
      expect(e, isA<AppException>());
    });

    test('MissingBaseUrlException 可正确构造', () {
      const e = MissingBaseUrlException('base url missing');
      expect(e.message, equals('base url missing'));
      expect(e, isA<AppException>());
    });

    test('ParseWarningException 可正确构造，rawContent 可为 null', () {
      const e = ParseWarningException('parse failed');
      expect(e.message, equals('parse failed'));
      expect(e.rawContent, isNull);
      expect(e, isA<AppException>());
    });

    test('ParseWarningException 可带 rawContent', () {
      const e = ParseWarningException('parse failed', rawContent: '{"bad": json}');
      expect(e.rawContent, equals('{"bad": json}'));
    });
  });

  group('ErrorHandler.handle()', () {
    test('MissingKeyException 返回配置 API Key 提示', () {
      final msg = ErrorHandler.handle(const MissingKeyException('key missing'));
      expect(msg, equals('请先在设置中配置 API Key'));
      expect(msg, isNotEmpty);
    });

    test('TimeoutException 返回超时提示', () {
      final msg = ErrorHandler.handle(const TimeoutException('timeout'));
      expect(msg, equals('请求超时，请检查网络后重试'));
      expect(msg, isNotEmpty);
    });

    test('NetworkException 返回网络错误提示', () {
      final msg = ErrorHandler.handle(const NetworkException('network'));
      expect(msg, equals('网络请求失败，请检查网络连接'));
      expect(msg, isNotEmpty);
    });

    test('MissingBaseUrlException 返回地址未配置提示', () {
      final msg = ErrorHandler.handle(const MissingBaseUrlException('url missing'));
      expect(msg, equals('服务地址未配置，请检查设置'));
      expect(msg, isNotEmpty);
    });

    test('ParseWarningException 返回解析异常提示', () {
      final msg = ErrorHandler.handle(const ParseWarningException('bad parse'));
      expect(msg, equals('响应解析异常，请重试'));
      expect(msg, isNotEmpty);
    });

    test('未知 Exception 返回兜底消息', () {
      final msg = ErrorHandler.handle(Exception('some unknown error'));
      expect(msg, equals('出现未知错误，请稍后重试'));
      expect(msg, isNotEmpty);
    });

    test('dart:async.TimeoutException 返回超时提示', () {
      final msg = ErrorHandler.toUserMessage(dart_async.TimeoutException('future timed out'));
      expect(msg, equals('请求超时，请检查网络后重试'));
    });

    test('UnsupportedError 返回功能不支持提示', () {
      final msg = ErrorHandler.toUserMessage(UnsupportedError('not implemented'));
      expect(msg, equals('该功能暂不支持，请先配置对应服务'));
    });

    test('所有 handle 返回值均为非空中文字符串', () {
      final exceptions = <Exception>[
        const MissingKeyException(''),
        const TimeoutException(''),
        const NetworkException(''),
        const MissingBaseUrlException(''),
        const ParseWarningException(''),
        Exception('unknown'),
      ];

      for (final e in exceptions) {
        final msg = ErrorHandler.handle(e);
        expect(msg, isNotEmpty, reason: 'Exception $e 应返回非空消息');
      }
    });
  });
}
