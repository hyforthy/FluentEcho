sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class TimeoutException extends AppException {
  const TimeoutException(super.message);
}

class MissingKeyException extends AppException {
  const MissingKeyException(super.message);
}

class MissingBaseUrlException extends AppException {
  const MissingBaseUrlException(super.message);
}

class ParseWarningException extends AppException {
  const ParseWarningException(super.message, {this.rawContent});
  final String? rawContent;
}
