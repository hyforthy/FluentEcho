import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/dio_factory.dart';
import '../../interfaces/i_tts_service.dart';

class OpenAITtsService implements ITTSService {
  OpenAITtsService({
    required String apiKey,
    required String voice,
    String? baseUrl,
    String? model,
  })  : _apiKey = apiKey,
        _voice = voice,
        _baseUrl = baseUrl ?? 'https://api.openai.com/v1',
        _model = model ?? 'tts-1';

  final String _apiKey;
  final String _voice;
  final String _baseUrl;
  final String _model;

  late final Dio _dio = DioFactory.create(
    baseUrl: _baseUrl,
    apiKey: _apiKey,
    timeout: AppConstants.ttsTimeout,
  );

  @override
  TTSProvider get provider => TTSProvider.openai;

  @override
  Future<bool> isAvailable() async {
    try {
      final response = await _dio.get<dynamic>(
        '/models',
        options: Options(receiveTimeout: const Duration(seconds: 5)),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<String> generate(String text, {String? voice}) async {
    if (_apiKey.isEmpty) {
      throw const MissingKeyException('OpenAI TTS API key is not configured');
    }

    try {
      final response = await _dio.post<List<int>>(
        '/audio/speech',
        data: {
          'model': _model,
          'voice': voice ?? _voice,
          'input': text,
        },
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: AppConstants.ttsTimeout,
        ),
      );

      if (response.data == null || response.data!.isEmpty) {
        throw const NetworkException('TTS returned empty audio data');
      }

      return _saveToFile(response.data!, 'mp3');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const TimeoutException('TTS request timed out');
      }
      throw NetworkException('TTS request failed: ${e.message}');
    }
  }

  @override
  Stream<List<int>> generateStream(String text, {String? voice}) {
    throw UnsupportedError('OpenAITtsService does not support streaming');
  }

  Future<String> _saveToFile(List<int> bytes, String ext) async {
    final dir = await getApplicationDocumentsDirectory();
    final audioDir = Directory('${dir.path}/${AppConstants.audioSubDirectory}');
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }
    final filePath = '${audioDir.path}/${const Uuid().v4()}.$ext';
    await File(filePath).writeAsBytes(bytes);
    return filePath;
  }
}
