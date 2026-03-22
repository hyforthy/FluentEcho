import 'package:dio/dio.dart';
import '../utils/logger.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['_startTime'] = DateTime.now().millisecondsSinceEpoch;
    appLogger.d('[API] ${options.method} ${options.uri.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final elapsed = _elapsed(response.requestOptions);
    appLogger.d(
      '[API] ${response.statusCode} ${response.requestOptions.uri.path} (${elapsed}ms)',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final elapsed = _elapsed(err.requestOptions);
    appLogger.e(
      '[API] ERROR ${err.requestOptions.uri.path} (${elapsed}ms): ${err.message}',
      error: err,
    );
    handler.next(err);
  }

  int _elapsed(RequestOptions options) {
    final start = options.extra['_startTime'] as int?;
    if (start == null) return -1;
    return DateTime.now().millisecondsSinceEpoch - start;
  }
}
