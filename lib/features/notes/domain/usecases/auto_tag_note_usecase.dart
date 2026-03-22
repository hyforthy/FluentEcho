import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/ai/interfaces/i_llm_service.dart';
import '../../../../core/database/app_database.dart';

class AutoTagNoteUseCase {
  final ILLMService _llm;
  final AppDatabase _db;

  AutoTagNoteUseCase({required ILLMService llm, required AppDatabase db})
      : _llm = llm,
        _db = db;

  Future<void> call({
    required int noteId,
    required String originalText,
    String? optimizedText,
    String? translatedText,
  }) async {
    if (!_llm.isConfigured) {
      await _applyFallbackTag(noteId);
      return;
    }
    try {
      var categories = await _llm.suggestTags(
        original: originalText,
        optimized: optimizedText,
        translated: translatedText,
      ).timeout(const Duration(seconds: 15));
      if (categories.isEmpty) categories = ['其他'];
      for (final name in categories) {
        final tagId = await _db.tagsDao.insertOrGetByName(name);
        await _db.tagsDao.addTagToNote(noteId, tagId);
      }
    } catch (e) {
      debugPrint('[AutoTagNoteUseCase] error: $e');
      await _applyFallbackTag(noteId);
    }
  }

  Future<void> _applyFallbackTag(int noteId) async {
    try {
      final tagId = await _db.tagsDao.insertOrGetByName('其他');
      await _db.tagsDao.addTagToNote(noteId, tagId);
    } catch (e) {
      debugPrint('[AutoTagNoteUseCase] fallback tag error: $e');
    }
  }
}
