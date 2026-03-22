import 'package:freezed_annotation/freezed_annotation.dart';

part 'detected_language.freezed.dart';

enum DetectionSource { rule, llm }

@freezed
class DetectedLanguage with _$DetectedLanguage {
  const factory DetectedLanguage({
    required String language,     // 'zh' | 'en' | 'mixed'
    required double confidence,   // 0.0 - 1.0
    required DetectionSource source,
  }) = _DetectedLanguage;
}
