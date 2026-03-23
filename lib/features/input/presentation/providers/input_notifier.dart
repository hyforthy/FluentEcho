import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/ai/providers/ai_service_providers.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/utils/error_log.dart';
import '../../domain/entities/conversation_entry.dart';
import '../../domain/entities/detected_language.dart';
import '../../domain/services/language_detector.dart';
import 'conversation_history_notifier.dart';
import '../../../notes/presentation/providers/note_detail_notifier.dart';
import '../../../notes/presentation/providers/note_list_notifier.dart';

part 'input_notifier.g.dart';
part 'input_notifier.freezed.dart';

/// Streaming phase enum
enum StreamingSection { optimizing, translating }

@freezed
class InputState with _$InputState {
  const factory InputState.idle() = _Idle;

  const factory InputState.detecting({
    required String originalText,
  }) = _Detecting;

  const factory InputState.preparing({
    required String originalText,
    required DetectedLanguage detectedLanguage,
  }) = _Preparing;

  const factory InputState.streaming({
    required String originalText,
    required DetectedLanguage detectedLanguage,
    required StreamingSection section,
    required String optimizedText,
    required String translatedText,
  }) = _Streaming;

  const factory InputState.done({
    required ConversationEntry entry,
  }) = _Done;

  const factory InputState.error({
    required String message,
    required String originalText,
  }) = _Error;
}

/// ID of the user bubble currently in inline-edit mode, or null if none.
/// Changing to a different ID causes the previous bubble to auto-cancel.
final bubbleEditingProvider = StateProvider<String?>((ref) => null);

/// Entry IDs currently being translated via skipOptimize (shows "生成中" on translation section).
final translatingEntryIdsProvider = StateProvider<Set<String>>((ref) => {});

/// Entry IDs currently in the optimization streaming phase of reoptimize().
final optimizingEntryIdsProvider = StateProvider<Set<String>>((ref) => {});

/// Text field Controller provider, shared between InputBar and InputScreen
final inputTextControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

@riverpod
class InputNotifier extends _$InputNotifier {
  @override
  InputState build() => const InputState.idle();

  /// Sets the input text (used by example chips in ConversationEmptyState)
  void setInputText(String text) {
    ref.read(inputTextControllerProvider).text = text;
  }

  Future<void> submitText(String text) async {
    if (text.trim().isEmpty) return;

    // Pre-flight: config check before any LLM call.
    // User's message enters the conversation; error is shown as a toast only (no error bubble).
    if (!ref.read(llmServiceProvider).isConfigured) {
      final msg = ErrorHandler.toUserMessage(
        const MissingKeyException('LLM service is not configured'),
      );
      final entry = ConversationEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        originalText: text,
        optimizedText: '',
        detectedLanguage: const DetectedLanguage(
          language: 'unknown',
          confidence: 0,
          source: DetectionSource.rule,
        ),
        createdAt: DateTime.now(),
      );
      await ref.read(conversationHistoryNotifierProvider.notifier).addEntry(entry);
      state = InputState.error(message: msg, originalText: text);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      state = const InputState.idle();
      return;
    }

    state = InputState.detecting(originalText: text);

    try {
      // Detect language using client-side rules
      final detector = LanguageDetector();
      var detected = detector.detect(text);

      // Fall back to LLM detection when confidence is low
      if (detected.confidence < 0.7) {
        try {
          final llm = ref.read(llmServiceProvider);
          final lang = await llm.detectLanguage(text);
          detected = DetectedLanguage(
            language: lang,
            confidence: 0.9,
            source: DetectionSource.llm,
          );
        } catch (_) {
          // Fallback failed; continue with rule-based result
        }
      }

      state = InputState.preparing(originalText: text, detectedLanguage: detected);

      // Streaming optimization
      String optimizedText = '';
      const translatedText = '';

      state = InputState.streaming(
        originalText: text,
        detectedLanguage: detected,
        section: StreamingSection.optimizing,
        optimizedText: optimizedText,
        translatedText: translatedText,
      );

      final llmService = ref.read(llmServiceProvider);
      await for (final chunk in llmService.optimizeTextStream(
        text: text,
        detectedLanguage: detected,
      )) {
        optimizedText += chunk;
        state = InputState.streaming(
          originalText: text,
          detectedLanguage: detected,
          section: StreamingSection.optimizing,
          optimizedText: optimizedText,
          translatedText: translatedText,
        );
      }

      // Translation
      state = InputState.streaming(
        originalText: text,
        detectedLanguage: detected,
        section: StreamingSection.translating,
        optimizedText: optimizedText,
        translatedText: translatedText,
      );

      final translation = await llmService.translate(
        text: optimizedText,
        detectedLanguage: detected,
      );

      state = InputState.streaming(
        originalText: text,
        detectedLanguage: detected,
        section: StreamingSection.translating,
        optimizedText: optimizedText,
        translatedText: translation,
      );

      // Done — add to session history (not auto-saved; saving is triggered by the user clicking the save button)
      final entry = ConversationEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        originalText: text,
        optimizedText: optimizedText,
        translatedText: translation.isNotEmpty ? translation : null,
        detectedLanguage: detected,
        createdAt: DateTime.now(),
      );

      await ref.read(conversationHistoryNotifierProvider.notifier).addEntry(entry);

      state = InputState.done(entry: entry);

      await Future<void>.delayed(const Duration(milliseconds: 100));
      state = const InputState.idle();
    } catch (e) {
      final msg = ErrorHandler.toUserMessage(e);
      ref.read(errorLogProvider.notifier).add(
        service: ErrorLogService.llm,
        message: msg,
        error: e,
      );
      final isConfigError = e is MissingKeyException || e is MissingBaseUrlException;
      if (isConfigError) {
        // Config errors: restore input text so the user can configure and resend.
        ref.read(inputTextControllerProvider).text = text;
      } else {
        // Retryable errors (network, timeout): add a bubble with a retry button.
        final entry = ConversationEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          originalText: text,
          optimizedText: '',
          detectedLanguage: const DetectedLanguage(
            language: 'unknown',
            confidence: 0,
            source: DetectionSource.rule,
          ),
          createdAt: DateTime.now(),
          errorMessage: msg,
        );
        await ref.read(conversationHistoryNotifierProvider.notifier).addEntry(entry);
      }
      state = InputState.error(message: msg, originalText: text);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      state = const InputState.idle();
    }
  }

  /// Skip LLM optimization: use [text] as-is, re-request translation only.
  /// [text] defaults to entry.originalText; pass an edited value to update it.
  Future<void> skipOptimize(ConversationEntry entry, {String? text}) async {
    final useText = (text != null && text.trim().isNotEmpty)
        ? text.trim()
        : entry.originalText;
    final historyNotifier = ref.read(conversationHistoryNotifierProvider.notifier);
    final pending = entry.withSkippedOptimization(useText);
    historyNotifier.updateEntry(pending);
    ref.read(translatingEntryIdsProvider.notifier).update((s) => {...s, pending.id});
    try {
      final translation = await ref.read(llmServiceProvider).translate(
        text: useText,
        detectedLanguage: entry.detectedLanguage,
      );
      final translatedText = translation.isNotEmpty ? translation : null;
      historyNotifier.updateEntry(pending.copyWith(translatedText: translatedText));
      if (pending.savedNoteId != null) {
        await ref.read(noteRepositoryProvider).updateSkippedContent(
          pending.savedNoteId!,
          text: useText,
          translatedText: translatedText,
        );
        ref.invalidate(noteListNotifierProvider);
        ref.invalidate(noteDetailProvider(pending.savedNoteId!));
      }
    } catch (e) {
      // Roll back to original entry so conversation is not left in a half-done state.
      historyNotifier.updateEntry(entry);
      final msg = ErrorHandler.toUserMessage(e);
      state = InputState.error(message: msg, originalText: useText);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      state = const InputState.idle();
    }
    ref.read(translatingEntryIdsProvider.notifier).update((s) => s.difference({pending.id}));
  }

  /// Re-optimize with new [text]: full language detect → optimize stream → translate.
  Future<void> reoptimize(ConversationEntry entry, {required String text}) async {
    final useText = text.trim();
    if (useText.isEmpty) return;
    final historyNotifier = ref.read(conversationHistoryNotifierProvider.notifier);
    final pending = entry.withReoptimize(useText);
    historyNotifier.updateEntry(pending);
    // Phase 1: optimizing
    ref.read(optimizingEntryIdsProvider.notifier).update((s) => {...s, pending.id});
    try {
      final detector = LanguageDetector();
      var detected = detector.detect(useText);
      if (detected.confidence < 0.7) {
        try {
          final lang = await ref.read(llmServiceProvider).detectLanguage(useText);
          detected = DetectedLanguage(language: lang, confidence: 0.9, source: DetectionSource.llm);
        } catch (_) {}
      }
      final llmService = ref.read(llmServiceProvider);
      String optimizedText = '';
      await for (final chunk in llmService.optimizeTextStream(
        text: useText,
        detectedLanguage: detected,
      )) {
        optimizedText += chunk;
        historyNotifier.updateEntry(pending.copyWith(
          detectedLanguage: detected,
          optimizedText: optimizedText,
        ));
      }
      // Phase 2: translating
      ref.read(optimizingEntryIdsProvider.notifier).update((s) => s.difference({pending.id}));
      ref.read(translatingEntryIdsProvider.notifier).update((s) => {...s, pending.id});
      final translation = await llmService.translate(
        text: optimizedText,
        detectedLanguage: detected,
      );
      final finished = pending.copyWith(
        detectedLanguage: detected,
        optimizedText: optimizedText,
        translatedText: translation.isNotEmpty ? translation : null,
      );
      historyNotifier.updateEntry(finished);
      if (finished.savedNoteId != null) {
        await ref.read(noteRepositoryProvider).updateReoptimizedContent(
          finished.savedNoteId!,
          originalText: useText,
          optimizedText: optimizedText,
          translatedText: finished.translatedText,
        );
        ref.invalidate(noteListNotifierProvider);
        ref.invalidate(noteDetailProvider(finished.savedNoteId!));
      }
    } catch (e) {
      historyNotifier.updateEntry(entry);
      final msg = ErrorHandler.toUserMessage(e);
      ref.read(errorLogProvider.notifier).add(
        service: ErrorLogService.llm,
        message: msg,
        error: e,
      );
      state = InputState.error(message: msg, originalText: useText);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      state = const InputState.idle();
    }
    ref.read(optimizingEntryIdsProvider.notifier).update((s) => s.difference({pending.id}));
    ref.read(translatingEntryIdsProvider.notifier).update((s) => s.difference({pending.id}));
  }

  Future<void> retryLlm(ConversationEntry failedEntry) async {
    if (!ref.read(llmServiceProvider).isConfigured) {
      final msg = ErrorHandler.toUserMessage(
        const MissingKeyException('LLM service is not configured'),
      );
      state = InputState.error(message: msg, originalText: failedEntry.originalText);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      state = const InputState.idle();
      return;
    }
    final historyNotifier = ref.read(conversationHistoryNotifierProvider.notifier);
    try {
      final detector = LanguageDetector();
      var detected = detector.detect(failedEntry.originalText);
      if (detected.confidence < 0.7) {
        try {
          final lang = await ref.read(llmServiceProvider).detectLanguage(failedEntry.originalText);
          detected = DetectedLanguage(language: lang, confidence: 0.9, source: DetectionSource.llm);
        } catch (_) {}
      }

      final llmService = ref.read(llmServiceProvider);
      String optimizedText = '';
      await for (final chunk in llmService.optimizeTextStream(
        text: failedEntry.originalText,
        detectedLanguage: detected,
      )) {
        optimizedText += chunk;
      }

      final translation = await llmService.translate(
        text: optimizedText,
        detectedLanguage: detected,
      );

      historyNotifier.updateEntry(
        failedEntry.copyWith(
          optimizedText: optimizedText,
          translatedText: translation.isNotEmpty ? translation : null,
          detectedLanguage: detected,
          errorMessage: null,
        ),
      );
    } catch (e) {
      final msg = ErrorHandler.toUserMessage(e);
      ref.read(errorLogProvider.notifier).add(
        service: ErrorLogService.llm,
        message: msg,
        error: e,
      );
      final isConfigError = e is MissingKeyException || e is MissingBaseUrlException;
      historyNotifier.updateEntry(
        failedEntry.copyWith(errorMessage: isConfigError ? null : msg),
      );
      state = InputState.error(message: msg, originalText: failedEntry.originalText);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      state = const InputState.idle();
    }
  }
}

