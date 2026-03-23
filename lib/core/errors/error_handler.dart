import 'dart:async' as dart_async;

import 'app_exception.dart';

class ErrorHandler {
  /// Delegates to [toUserMessage] for backwards compatibility.
  static String handle(Exception e) => toUserMessage(e);

  /// User-facing toast message for any thrown object (Exception or Error).
  static String toUserMessage(Object e) {
    if (e is MissingKeyException) {
      final msg = e.message.toLowerCase();
      if (msg.contains('tts') || msg.contains('volcano tts') || msg.contains('openai tts')) {
        return '请前往设置 → 语音朗读（TTS）完成配置';
      }
      if (msg.contains('stt') || msg.contains('whisper')) {
        return '请前往设置 → 语音识别（STT）完成配置';
      }
      return '请前往设置 → 文本优化（LLM）完成配置';
    }
    if (e is MissingBaseUrlException) return '服务地址未配置，请检查设置';
    // Check both app_exception.TimeoutException and dart:async.TimeoutException
    // (dart:async is imported by tts_notifier and input_bar, so both can propagate).
    if (e is TimeoutException || e is dart_async.TimeoutException) {
      return '请求超时，请检查网络后重试';
    }
    if (e is NetworkException) return _parseNetworkMessage(e.message);
    if (e is ParseWarningException) return 'AI 返回内容格式异常，请重试';
    if (e is AppException) return e.message;
    // UnsupportedError.toString() returns "Unsupported operation: ...", not the type name —
    // use type check instead of string matching.
    if (e is UnsupportedError) {
      final msg = e.message ?? '';
      if (msg.contains('transcription') || msg.contains('STT') || msg.contains('stt')) {
        return '请前往设置 → 语音识别（STT）完成配置';
      }
      if (msg.contains('streaming') || msg.contains('TTS') || msg.contains('tts')) {
        return '请前往设置 → 语音朗读（TTS）完成配置';
      }
      return '请前往设置完成对应服务的配置';
    }

    return '出现意外错误，请稍后重试';
  }

  static String _parseNetworkMessage(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('unauthenticated') || lower.contains('status: 401') ||
        lower.contains('status 401') || lower.contains(': 401 ')) {
      return '认证失败：API Key 错误或已过期，请检查配置';
    }
    if (lower.contains('permission_denied') || lower.contains('status: 403') ||
        lower.contains('status 403') || lower.contains(': 403 ')) {
      return '无权限：请检查 API Key 的权限配置';
    }
    if (lower.contains('status: 400') || lower.contains('status 400') ||
        lower.contains(': 400 ') || lower.contains('invalid_request') ||
        lower.contains('bad request')) {
      return '请求参数错误，请检查配置（如模型名称）是否正确';
    }
    if (lower.contains('status: 404') || lower.contains('status 404') ||
        lower.contains(': 404 ') || lower.contains('not found')) {
      return '请求的模型或接口不存在，请检查配置';
    }
    if (lower.contains('resource_exhausted') || lower.contains('quota') ||
        lower.contains('status: 429') || lower.contains('status 429') ||
        lower.contains(': 429 ')) {
      return 'API 配额已耗尽，请稍后重试';
    }
    if (lower.contains('unavailable') || lower.contains('status: 500') ||
        lower.contains('status: 502') || lower.contains('status: 503') ||
        lower.contains('status 500') || lower.contains('status 502') ||
        lower.contains('status 503')) {
      return '服务暂时不可用，请稍后重试';
    }
    return '请求失败，请检查配置或网络后重试';
  }
}
