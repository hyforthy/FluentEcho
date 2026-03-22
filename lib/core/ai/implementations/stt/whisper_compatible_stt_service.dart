import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/dio_factory.dart';
import '../../interfaces/i_stt_service.dart';

class WhisperCompatibleSttService implements ISTTService {
  WhisperCompatibleSttService({
    required String apiKey,
    required String model,
    required String baseUrl,
  })  : _apiKey = apiKey,
        _model = model,
        _baseUrl = baseUrl;

  final String _apiKey;
  final String _model;
  final String _baseUrl;

  late final Dio _dio = DioFactory.create(
    baseUrl: _baseUrl,
    apiKey: _apiKey,
    timeout: AppConstants.sttTimeout,
  );

  @override
  STTProvider get provider => STTProvider.whisperCompatible;

  @override
  Future<bool> isAvailable() async {
    return _apiKey.isNotEmpty && _baseUrl.isNotEmpty;
  }

  @override
  Future<SttResult> transcribe(String audioPath) async {
    if (_apiKey.isEmpty || _baseUrl.isEmpty) {
      throw const MissingKeyException('STT service is not configured');
    }

    final file = File(audioPath);
    if (!await file.exists()) {
      throw NetworkException('Audio file not found: $audioPath');
    }

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          audioPath,
          filename: file.uri.pathSegments.last,
        ),
        'model': _model,
        'response_format': 'json',
      });

      final response = await _dio.post<Map<String, dynamic>>(
        '/audio/transcriptions',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          receiveTimeout: AppConstants.sttTimeout,
        ),
      );

      final text = response.data?['text'] as String? ?? '';
      // Whisper API does not return per-request confidence scores
      return SttResult(text: text.trim(), confidence: 0.9);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const TimeoutException('STT request timed out');
      }
      throw NetworkException('STT request failed: ${e.message}');
    }
  }
}
