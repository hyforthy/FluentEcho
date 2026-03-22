import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import 'api_interceptor.dart';

class DioFactory {
  static Dio create({
    required String baseUrl,
    required String apiKey,
    Duration timeout = AppConstants.llmTimeout,
    Map<String, String>? extraHeaders,
  }) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: timeout,
      receiveTimeout: timeout,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        ...?extraHeaders,
      },
    ));
    dio.interceptors.add(ApiInterceptor());
    return dio;
  }

  static Dio createWithCustomAuth({
    required String baseUrl,
    required Map<String, String> headers,
    Duration timeout = AppConstants.llmTimeout,
  }) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: timeout,
      receiveTimeout: timeout,
      headers: {
        'Content-Type': 'application/json',
        ...headers,
      },
    ));
    dio.interceptors.add(ApiInterceptor());
    return dio;
  }
}
