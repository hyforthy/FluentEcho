import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/dio_factory.dart';
import '../../interfaces/i_tts_service.dart';

/// Volcano Engine V3 TTS — HTTP Chunked streaming.
/// Auth headers: X-Api-App-Id + X-Api-Access-Key + X-Api-Resource-Id.
/// Config apiKey format:  "appId|accessKey"
/// Config model field:    "resourceId:speakerId"
///   e.g. "seed-tts-1.0:zh_female_shuangkuaisisi_moon_bigtts"
class VolcanoTtsService implements ITTSService {
  VolcanoTtsService({
    required String appId,
    required String accessKey,
    required String resourceId,
    required String defaultSpeaker,
  })  : _appId = appId,
        _accessKey = accessKey,
        _resourceId = resourceId,
        _defaultSpeaker = defaultSpeaker;

  final String _appId;
  final String _accessKey;
  final String _resourceId;
  final String _defaultSpeaker;

  static const _baseUrl = 'https://openspeech.bytedance.com';
  static const _path = '/api/v3/tts/unidirectional';

  final String _sessionUid = const Uuid().v4();

  late final Dio _dio = DioFactory.createWithCustomAuth(
    baseUrl: _baseUrl,
    headers: {
      'X-Api-App-Id': _appId,
      'X-Api-Access-Key': _accessKey,
      'X-Api-Resource-Id': _resourceId,
    },
    timeout: AppConstants.ttsTimeout,
  );

  @override
  TTSProvider get provider => TTSProvider.volcano;

  @override
  Future<bool> isAvailable() async =>
      _appId.isNotEmpty && _accessKey.isNotEmpty && _resourceId.isNotEmpty;

  @override
  Future<String> generate(String text, {String? voice}) async {
    final allBytes = <int>[];
    await for (final chunk in generateStream(text, voice: voice)) {
      allBytes.addAll(chunk);
    }
    if (allBytes.isEmpty) {
      throw const NetworkException('Volcano TTS returned empty audio data');
    }
    return _saveToFile(allBytes, 'mp3');
  }

  @override
  Stream<List<int>> generateStream(String text, {String? voice}) async* {
    if (_appId.isEmpty || _accessKey.isEmpty || _resourceId.isEmpty) {
      throw const MissingKeyException('Volcano TTS: credentials not configured');
    }
    if (text.trim().isEmpty) {
      throw const NetworkException('Volcano TTS: text must not be empty');
    }

    final speaker = voice ?? _defaultSpeaker;

    try {
      final response = await _dio.post<ResponseBody>(
        _path,
        data: {
          'user': {'uid': _sessionUid},
          'req_params': {
            'text': text,
            'speaker': speaker,
            'audio_params': {'format': 'mp3', 'sample_rate': 24000},
          },
        },
        options: Options(
          responseType: ResponseType.stream,
          headers: {'X-Api-Request-Id': const Uuid().v4()},
        ),
      );

      final buffer = StringBuffer();
      await for (final bytes in response.data!.stream) {
        buffer.write(utf8.decode(bytes, allowMalformed: true));

        final raw = buffer.toString();
        final lines = raw.split('\n');
        buffer.clear();

        for (int i = 0; i < lines.length - 1; i++) {
          final line = lines[i].trim();
          if (line.isEmpty) continue;
          final audioBytes = _decodeChunk(line);
          if (audioBytes != null) yield audioBytes;
        }
        if (lines.last.isNotEmpty) buffer.write(lines.last);
      }

      final remaining = buffer.toString().trim();
      if (remaining.isNotEmpty) {
        final audioBytes = _decodeChunk(remaining);
        if (audioBytes != null) yield audioBytes;
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const TimeoutException('Volcano TTS request timed out');
      }
      throw NetworkException('Volcano TTS request failed: ${e.message}');
    }
  }

  /// Decodes an audio chunk from a JSON line.
  /// Returns MP3 bytes when code == 0 and data is present.
  /// Returns null for the terminal packet (code == 20000000).
  /// Throws [NetworkException] for any other non-zero code (API error).
  List<int>? _decodeChunk(String line) {
    try {
      final json = jsonDecode(line) as Map<String, dynamic>;
      final code = json['code'] as int? ?? 0;
      if (code == 20000000) return null; // normal end
      if (code != 0) {
        final msg = json['message'] as String? ?? 'unknown error';
        throw NetworkException('Volcano TTS API error (code $code): $msg');
      }
      final data = json['data'] as String?;
      if (data == null || data.isEmpty) return null;
      return base64Decode(data);
    } on NetworkException {
      rethrow;
    } on FormatException {
      return null; // Partial or non-JSON line during streaming — expected.
    } catch (e) {
      throw NetworkException('Volcano TTS: unexpected chunk parse error: $e');
    }
  }

  Future<String> _saveToFile(List<int> bytes, String ext) async {
    final dir = await getApplicationDocumentsDirectory();
    final audioDir =
        Directory('${dir.path}/${AppConstants.audioSubDirectory}');
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }
    final filePath = '${audioDir.path}/${const Uuid().v4()}.$ext';
    await File(filePath).writeAsBytes(bytes);
    return filePath;
  }
}
