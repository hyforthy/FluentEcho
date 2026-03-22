import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';

/// Transforms a raw SSE byte stream into a stream of text delta strings.
/// Supports two formats:
/// 1. OpenAI `data: {"choices":[{"delta":{"content":"..."}}]}`
/// 2. Anthropic `data: {"type":"content_block_delta","delta":{"text":"..."}}`
class SseTransformer extends StreamTransformerBase<Uint8List, String> {
  const SseTransformer();

  @override
  Stream<String> bind(Stream<Uint8List> stream) async* {
    final buffer = StringBuffer();
    await for (final chunk in stream.cast<List<int>>().transform(utf8.decoder)) {
      buffer.write(chunk);
      final text = buffer.toString();
      final lines = text.split('\n');
      // Retain the last line (may be incomplete)
      buffer.clear();
      buffer.write(lines.last);

      for (final line in lines.sublist(0, lines.length - 1)) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6).trim();
          if (data == '[DONE]') continue;
          final delta = _extractDelta(data);
          if (delta != null && delta.isNotEmpty) yield delta;
        }
      }
    }
  }

  String? _extractDelta(String data) {
    try {
      final json = jsonDecode(data) as Map<String, dynamic>;
      // OpenAI format
      final choices = json['choices'] as List<dynamic>?;
      if (choices != null && choices.isNotEmpty) {
        final delta =
            (choices[0] as Map<String, dynamic>)['delta'] as Map<String, dynamic>?;
        return delta?['content'] as String?;
      }
      // Anthropic format
      if (json['type'] == 'content_block_delta') {
        final delta = json['delta'] as Map<String, dynamic>?;
        return delta?['text'] as String?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
