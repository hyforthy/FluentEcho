import '../entities/detected_language.dart';

class LanguageDetector {
  static const double _cjkThreshold = 0.15;
  static const double _highConfidence = 0.9;
  static const double _lowConfidence = 0.55;

  DetectedLanguage detect(String text) {
    if (text.trim().isEmpty) {
      return const DetectedLanguage(
        language: 'zh',
        confidence: 1.0,
        source: DetectionSource.rule,
      );
    }

    final chars = text.runes.toList();
    final total = chars.length;
    final cjkCount = chars.where(_isCjk).length;
    final cjkRatio = cjkCount / total;

    if (cjkRatio > _cjkThreshold) {
      final confidence = cjkRatio > 0.5 ? _highConfidence : _lowConfidence;
      return DetectedLanguage(
        language: cjkRatio > 0.8 ? 'zh' : 'mixed',
        confidence: confidence,
        source: DetectionSource.rule,
      );
    }

    return const DetectedLanguage(
      language: 'en',
      confidence: _highConfidence,
      source: DetectionSource.rule,
    );
  }

  static bool _isCjk(int rune) {
    return (rune >= 0x4E00 && rune <= 0x9FFF) ||
        (rune >= 0x3400 && rune <= 0x4DBF) ||
        (rune >= 0xF900 && rune <= 0xFAFF) ||
        (rune >= 0x3040 && rune <= 0x30FF); // 日文假名
  }
}
