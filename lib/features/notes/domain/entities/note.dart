class Note {
  const Note({
    required this.id,
    required this.originalText,
    this.optimizedText,
    this.translatedText,
    required this.detectedLanguage,
    required this.detectionConfidence,
    this.audioFilePath,
    this.audioFileSizeBytes,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite,
    this.skipOptimization = false,
  });

  final int id;
  final String originalText;
  final String? optimizedText;
  final String? translatedText;
  final String detectedLanguage;
  final double detectionConfidence;
  final String? audioFilePath;
  final int? audioFileSizeBytes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;
  final bool skipOptimization;
}

enum NoteFilter { all, zhToEn, enToZh }
