import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../../core/network/sse_transformer.dart';
import '../../../../features/input/domain/entities/detected_language.dart';
import '../../../../core/constants/note_categories.dart';
import '../../interfaces/i_llm_service.dart';

class ClaudeLLMService implements ILLMService {
  ClaudeLLMService({
    required String apiKey,
    required String model,
    String? customBaseUrl,
  })  : _apiKey = apiKey,
        _model = model {
    _dio = DioFactory.createWithCustomAuth(
      baseUrl: (customBaseUrl != null && customBaseUrl.isNotEmpty)
          ? customBaseUrl
          : _defaultBaseUrl,
      headers: {
        'x-api-key': apiKey,
        'anthropic-version': _anthropicVersion,
      },
      timeout: AppConstants.llmTimeout,
    );
  }

  static const String _defaultBaseUrl = 'https://api.anthropic.com';
  static const String _anthropicVersion = '2023-06-01';

  final String _apiKey;
  final String _model;

  late final Dio _dio;

  @override
  LLMProvider get provider => LLMProvider.claude;

  @override
  bool get isConfigured => _apiKey.isNotEmpty;

  @override
  Stream<String> optimizeTextStream({
    required String text,
    required DetectedLanguage detectedLanguage,
  }) async* {
    if (!isConfigured) {
      throw const MissingKeyException('Claude service is not configured');
    }

    final prompt = _buildOptimizePrompt(text, detectedLanguage);
    yield* _streamMessages(prompt);
  }

  @override
  Future<String> translate({
    required String text,
    required DetectedLanguage detectedLanguage,
  }) async {
    if (!isConfigured) {
      throw const MissingKeyException('Claude service is not configured');
    }

    final isChineseInput = detectedLanguage.language == 'zh' || detectedLanguage.language == 'mixed';
    final prompt = isChineseInput
        ? 'You are a native American English speaker and language coach. '
          'Translate the following Chinese text into natural, everyday American English — '
          'the kind of casual, idiomatic language a native speaker would actually say out loud. '
          'Use contractions and colloquialisms where appropriate. '
          'Return ONLY the English translation, no explanation.\n'
          'Input: $text'
        : 'Translate the following English text into natural, fluent Chinese. '
          'Return ONLY the Chinese translation, no explanation.\n'
          'Input: $text';

    final buffer = StringBuffer();
    await for (final delta in _streamMessages(prompt)) {
      buffer.write(delta);
    }
    return buffer.toString();
  }

  @override
  Future<String> detectLanguage(String text) async {
    if (!isConfigured) {
      throw const MissingKeyException('Claude service is not configured');
    }

    final prompt =
        'Detect the language of the following text. '
        'Reply with ONLY one word: "zh" for Chinese, "en" for English, "mixed" for mixed.\n'
        'Text: $text';

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/messages',
        data: {
          'model': _model,
          'max_tokens': 10,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
        },
        options: Options(receiveTimeout: AppConstants.llmTimeout),
      );
      final content = response.data?['content'] as List<dynamic>?;
      if (content == null || content.isEmpty) return 'zh';
      final block = content[0] as Map<String, dynamic>?;
      return (block?['text'] as String?)?.trim().toLowerCase() ?? 'zh';
    } on DioException catch (e) {
      throw NetworkException('Language detection failed: ${e.message}');
    }
  }

  @override
  Future<List<String>> suggestTags({
    required String original,
    String? optimized,
    String? translated,
    int maxTags = 3,
  }) async {
    if (!isConfigured) return [];
    try {
      final categoryList = kNoteCategories.join('、');
      final prompt =
          'You are a note classifier for an English learning app.\n'
          'Classify the following note into 1 to $maxTags categories.\n'
          'You MUST choose ONLY from this exact list: [$categoryList]\n'
          'Do NOT create new categories or modify the names.\n\n'
          'Note content:\n'
          '- Original: $original'
          '${optimized != null ? '\n- Optimized: $optimized' : ''}'
          '${translated != null ? '\n- Translation: $translated' : ''}\n\n'
          'Return ONLY a JSON array of Chinese strings from the list, e.g. ["日常生活"]. '
          'Use Chinese category names exactly as shown. No explanation, no other text.';
      final buffer = StringBuffer();
      await for (final delta
          in _streamMessages(prompt).timeout(const Duration(seconds: 10))) {
        buffer.write(delta);
      }
      final raw = buffer.toString().trim()
          .replaceAll(RegExp(r'^```(?:json)?\s*'), '')
          .replaceAll(RegExp(r'\s*```$'), '')
          .trim();
      final allowed = kNoteCategories.toSet();
      final List<dynamic> parsed = jsonDecode(raw);
      return parsed.cast<String>()
          .map((t) => t.trim())
          .where((t) => allowed.contains(t))
          .toSet()
          .take(maxTags)
          .toList();
    } catch (e) {
      debugPrint('[suggestTags] error: $e');
      return [];
    }
  }

  Stream<String> _streamMessages(String userPrompt) async* {
    try {
      final response = await _dio.post<ResponseBody>(
        '/v1/messages',
        data: {
          'model': _model,
          'max_tokens': 2048,
          'stream': true,
          'messages': [
            {'role': 'user', 'content': userPrompt},
          ],
        },
        options: Options(responseType: ResponseType.stream),
      );

      final stream = response.data?.stream;
      if (stream == null) return;

      await for (final delta in stream.transform(const SseTransformer())) {
        yield delta;
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const TimeoutException('Claude request timed out');
      }
      throw NetworkException('Claude request failed: ${e.message}');
    }
  }

  String _buildOptimizePrompt(String text, DetectedLanguage detectedLanguage) {
    if (detectedLanguage.language == 'zh' ||
        detectedLanguage.language == 'mixed') {
      return '你是一位中文写作专家。'
          '请对以下中文文本进行优化：修正错别字、语病，改善表达方式，使其更加流畅、自然、准确。'
          '保持原文语言为中文，保持原意不变，只优化表达。'
          '只返回优化后的中文文本，不要任何解释。\n'
          '输入：$text';
    }
    return 'You are a native American English speaker and language coach. '
        'Rewrite the following English text to sound like natural, spoken American English. '
        'Fix grammar and spelling, replace formal or awkward phrasing with everyday American expressions, '
        'and use contractions freely. Keep the original meaning but make it sound like something a native speaker would actually say. '
        'Return ONLY the rewritten English, no explanation, no alternatives.\n'
        'Input: $text';
  }
}

