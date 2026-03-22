import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:english_learning/core/network/sse_transformer.dart';

/// 将字符串列表转换为 SSE 字节流（Uint8List，与 SseTransformer 输入类型一致）
Stream<Uint8List> _sseStream(List<String> lines) async* {
  for (final line in lines) {
    yield Uint8List.fromList(utf8.encode(line));
  }
}

Future<List<String>> _collectStream(List<String> sseLines) async {
  final transformer = const SseTransformer();
  final results = <String>[];
  await for (final delta in transformer.bind(_sseStream(sseLines))) {
    results.add(delta);
  }
  return results;
}

void main() {
  group('SseTransformer', () {
    group('OpenAI 格式', () {
      test('解析标准 OpenAI content delta', () async {
        final lines = [
          'data: {"choices":[{"delta":{"content":"hello"}}]}\n',
          '\n',
        ];
        final results = await _collectStream(lines);
        expect(results, equals(['hello']));
      });

      test('多个 delta 事件按序返回', () async {
        final lines = [
          'data: {"choices":[{"delta":{"content":"Hello"}}]}\n',
          'data: {"choices":[{"delta":{"content":" world"}}]}\n',
          '\n',
        ];
        final results = await _collectStream(lines);
        expect(results, equals(['Hello', ' world']));
      });

      test('delta 无 content 字段时忽略', () async {
        final lines = [
          'data: {"choices":[{"delta":{}}]}\n',
          '\n',
        ];
        final results = await _collectStream(lines);
        expect(results, isEmpty);
      });

      test('[DONE] 信号被忽略，不产生 delta', () async {
        final lines = [
          'data: {"choices":[{"delta":{"content":"hi"}}]}\n',
          'data: [DONE]\n',
          '\n',
        ];
        final results = await _collectStream(lines);
        expect(results, equals(['hi']));
        expect(results.length, equals(1));
      });
    });

    group('Anthropic 格式', () {
      test('解析标准 Anthropic content_block_delta', () async {
        final lines = [
          'data: {"type":"content_block_delta","delta":{"text":"hello"}}\n',
          '\n',
        ];
        final results = await _collectStream(lines);
        expect(results, equals(['hello']));
      });

      test('Anthropic 多个 delta 事件', () async {
        final lines = [
          'data: {"type":"content_block_delta","delta":{"text":"Good "}}\n',
          'data: {"type":"content_block_delta","delta":{"text":"morning"}}\n',
          '\n',
        ];
        final results = await _collectStream(lines);
        expect(results, equals(['Good ', 'morning']));
      });

      test('Anthropic 非 content_block_delta 类型被忽略', () async {
        final lines = [
          'data: {"type":"message_start","message":{}}\n',
          'data: {"type":"content_block_delta","delta":{"text":"hi"}}\n',
          '\n',
        ];
        final results = await _collectStream(lines);
        expect(results, equals(['hi']));
      });
    });

    group('边界条件', () {
      test('空行被忽略', () async {
        final lines = [
          '\n',
          '\n',
          'data: {"choices":[{"delta":{"content":"test"}}]}\n',
          '\n',
        ];
        final results = await _collectStream(lines);
        expect(results, equals(['test']));
      });

      test('不以 data: 开头的行被忽略', () async {
        final lines = [
          ': this is a comment\n',
          'event: message\n',
          'data: {"choices":[{"delta":{"content":"ok"}}]}\n',
          '\n',
        ];
        final results = await _collectStream(lines);
        expect(results, equals(['ok']));
      });

      test('格式错误的 JSON 不崩溃，返回空', () async {
        final lines = [
          'data: {broken json\n',
          '\n',
        ];
        // 不应该抛出异常
        final results = await _collectStream(lines);
        expect(results, isEmpty);
      });

      test('空 data 行不崩溃', () async {
        final lines = [
          'data: \n',
          '\n',
        ];
        // 直接 await 并断言结果：既验证不抛异常，又验证返回值正确
        final results = await _collectStream(lines);
        expect(results, isEmpty);
      });

      test('空流返回空结果', () async {
        final results = await _collectStream([]);
        expect(results, isEmpty);
      });

      test('content 为空字符串时不 yield', () async {
        final lines = [
          'data: {"choices":[{"delta":{"content":""}}]}\n',
          '\n',
        ];
        final results = await _collectStream(lines);
        expect(results, isEmpty);
      });
    });

    group('混合格式', () {
      test('OpenAI 和 Anthropic 行在同一流中各自正确解析', () async {
        final lines = [
          'data: {"choices":[{"delta":{"content":"from openai"}}]}\n',
          'data: {"type":"content_block_delta","delta":{"text":" and anthropic"}}\n',
          '\n',
        ];
        final results = await _collectStream(lines);
        expect(results, equals(['from openai', ' and anthropic']));
      });
    });
  });
}
