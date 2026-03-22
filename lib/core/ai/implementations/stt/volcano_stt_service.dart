import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/dio_factory.dart';
import '../../interfaces/i_stt_service.dart';

/// Volcano Engine BigModel Flash STT (大模型录音文件极速版).
/// Docs: https://www.volcengine.com/docs/6561/1631584
///
/// Auth headers (all required):
///   X-Api-App-Key      → App ID (控制台获取)
///   X-Api-Access-Key   → Access Token
///   X-Api-Resource-Id  → 固定值 volc.bigasr.auc_turbo（需在控制台开通权限）
///   X-Api-Request-Id   → 每次请求随机 UUID
///   X-Api-Sequence     → 固定值 -1
///
/// Config apiKey format: "appId|accessKey"
class VolcanoSttService implements ISTTService {
  VolcanoSttService({
    required String appId,
    required String accessKey,
    String resourceId = 'volc.bigasr.auc_turbo',
  })  : _appId = appId,
        _accessKey = accessKey,
        _resourceId = resourceId;

  final String _appId;
  final String _accessKey;
  final String _resourceId;
  final _uuid = const Uuid();

  static const _baseUrl = 'https://openspeech.bytedance.com';
  static const _path = '/api/v3/auc/bigmodel/recognize/flash';

  // Fixed headers shared across all requests; X-Api-Request-Id is per-request.
  late final Dio _dio = DioFactory.createWithCustomAuth(
    baseUrl: _baseUrl,
    headers: {
      'X-Api-App-Key': _appId,
      'X-Api-Access-Key': _accessKey,
      'X-Api-Resource-Id': _resourceId,
      'X-Api-Sequence': '-1',
    },
    timeout: AppConstants.sttTimeout,
  );

  @override
  STTProvider get provider => STTProvider.volcano;

  @override
  Future<bool> isAvailable() async =>
      _appId.isNotEmpty && _accessKey.isNotEmpty;

  @override
  Future<SttResult> transcribe(String audioPath) async {
    if (_appId.isEmpty || _accessKey.isEmpty) {
      throw const MissingKeyException(
          'Volcano STT: appId or accessKey not configured');
    }

    final file = File(audioPath);
    if (!await file.exists()) {
      throw NetworkException('Audio file not found: $audioPath');
    }

    final base64Audio = base64Encode(await file.readAsBytes());

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _path,
        data: {
          'user': {'uid': _appId},
          'audio': {'data': base64Audio},
          'request': {'model_name': 'bigmodel'},
        },
        // X-Api-Request-Id must be a fresh UUID per request.
        options: Options(headers: {'X-Api-Request-Id': _uuid.v4()}),
      );

      // Status code is in the response header, not the body.
      // 20000000 = success, 20000003 = silent audio (treat as empty result).
      final statusCode = response.headers.value('X-Api-Status-Code');
      if (statusCode == '20000003') {
        return const SttResult(text: '', confidence: 0.0);
      }
      if (statusCode != null && statusCode != '20000000') {
        final msg =
            response.headers.value('X-Api-Message') ?? 'unknown error';
        throw NetworkException('Volcano STT error ($statusCode): $msg');
      }

      final result = response.data?['result'] as Map<String, dynamic>?;
      final text = result?['text'] as String? ?? '';
      return SttResult(text: text.trim(), confidence: 0.9);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const TimeoutException('Volcano STT request timed out');
      }
      throw NetworkException('Volcano STT request failed: ${e.message}');
    }
  }
}
