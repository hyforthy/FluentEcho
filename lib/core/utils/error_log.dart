import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ErrorLogService { llm, tts, stt }

class ErrorLogEntry {
  final DateTime timestamp;
  final ErrorLogService service;
  final String message;   // user-facing summary
  final String details;   // raw error string for diagnosis

  const ErrorLogEntry({
    required this.timestamp,
    required this.service,
    required this.message,
    required this.details,
  });

  String get serviceLabel => switch (service) {
    ErrorLogService.llm => 'LLM',
    ErrorLogService.tts => 'TTS',
    ErrorLogService.stt => 'STT',
  };
}

class ErrorLogNotifier extends StateNotifier<List<ErrorLogEntry>> {
  static const _maxEntries = 300;

  ErrorLogNotifier() : super(const []);

  void add({
    required ErrorLogService service,
    required String message,
    required Object error,
  }) {
    final entry = ErrorLogEntry(
      timestamp: DateTime.now(),
      service: service,
      message: message,
      details: error.toString(),
    );
    final next = [entry, ...state];
    state = next.length > _maxEntries ? next.sublist(0, _maxEntries) : next;
  }

  void clear() => state = const [];
}

final errorLogProvider =
    StateNotifierProvider<ErrorLogNotifier, List<ErrorLogEntry>>(
  (_) => ErrorLogNotifier(),
);
