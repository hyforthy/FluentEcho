import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/top_snack_bar.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../domain/entities/conversation_entry.dart';
import '../../domain/entities/detected_language.dart';
import '../../../notes/domain/usecases/delete_note_usecase.dart';
import '../../../notes/presentation/providers/note_tags_notifier.dart';
import '../../../../shared/tts/presentation/providers/tts_notifier.dart';
import '../providers/conversation_history_notifier.dart';
import '../providers/input_notifier.dart';
import '../../../notes/presentation/providers/note_list_notifier.dart';
import '../../../notes/presentation/providers/note_detail_notifier.dart';

class AIResultBubble extends ConsumerWidget {
  final ConversationEntry entry;
  final bool isStreaming;
  final StreamingSection? section;

  const AIResultBubble({
    required this.entry,
    required this.isStreaming,
    this.section,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (entry.errorMessage != null) {
      return _LlmErrorBubble(entry: entry);
    }

    final isSkipped = entry.skipOptimization;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 12),
        _AiAvatar(),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.88,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: const BorderRadius.only(
                topLeft:     Radius.circular(4),
                topRight:    Radius.circular(18),
                bottomLeft:  Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 3),
              )],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft:     Radius.circular(4),
                topRight:    Radius.circular(18),
                bottomLeft:  Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              child: IntrinsicHeight(
                child: Row(children: [
                  Container(
                    width: 4,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _OptimizedSection(
                            text: entry.optimizedText,
                            isStreaming: isStreaming && section == StreamingSection.optimizing,
                            isSkipped: isSkipped,
                          ),
                          if (entry.translatedText?.isNotEmpty == true ||
                              (isStreaming && section == StreamingSection.translating)) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                              child: Divider(height: 1, color: AppColors.divider),
                            ),
                            _TranslationSection(
                              text: entry.translatedText ?? '',
                              isStreaming: isStreaming && section == StreamingSection.translating,
                              detectedLanguage: entry.detectedLanguage,
                            ),
                          ],
                          if (!isStreaming) ...[
                            const SizedBox(height: AppSpacing.sm),
                            _ActionRow(entry: entry),
                          ],
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}

// ── LLM error bubble (with retry button) ─────────────────────
class _LlmErrorBubble extends ConsumerStatefulWidget {
  final ConversationEntry entry;

  const _LlmErrorBubble({required this.entry});

  @override
  ConsumerState<_LlmErrorBubble> createState() => _LlmErrorBubbleState();
}

class _LlmErrorBubbleState extends ConsumerState<_LlmErrorBubble> {
  bool _isRetrying = false;

  Future<void> _retry() async {
    setState(() => _isRetrying = true);
    await ref.read(inputNotifierProvider.notifier).retryLlm(widget.entry);
    if (mounted) setState(() => _isRetrying = false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 12),
        _AiAvatar(),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              border: Border.all(color: const Color(0xFFFECACA)),
            ),
            child: Row(children: [
              const Icon(Icons.error_outline, size: 14, color: Color(0xFFEF4444)),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  widget.entry.errorMessage!,
                  style: const TextStyle(fontSize: 13, color: Color(0xFFEF4444)),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _isRetrying ? null : _retry,
                child: _isRetrying
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: Color(0xFFEF4444),
                        ),
                      )
                    : const Tooltip(
                        message: '重新处理',
                        child: Icon(Icons.refresh, size: 16, color: Color(0xFFEF4444)),
                      ),
              ),
            ]),
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}

class _AiAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32, height: 32,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text('✦', style: TextStyle(color: Colors.white, fontSize: 14)),
      ),
    );
  }
}


class _OptimizedSection extends StatelessWidget {
  final String text;
  final bool isStreaming;
  final bool isSkipped;

  const _OptimizedSection({
    required this.text,
    required this.isStreaming,
    this.isSkipped = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSkipped ? AppColors.textSecondary : AppColors.primary;
    final icon = isSkipped ? Icons.text_snippet_outlined : Icons.auto_awesome;
    final label = isSkipped ? '原文' : '优化结果';

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.cardLabel.copyWith(color: color)),
        if (isStreaming) ...[
          const SizedBox(width: 6),
          _StreamingBadge(),
        ],
      ]),
      const SizedBox(height: 4),
      _StreamingText(
        text: text,
        isStreaming: isStreaming,
        style: AppTextStyles.resultBody.copyWith(
          color: isSkipped ? AppColors.textSecondary : null,
        ),
      ),
    ]);
  }
}

class _TranslationSection extends StatelessWidget {
  final String text;
  final bool isStreaming;
  final DetectedLanguage detectedLanguage;

  const _TranslationSection({
    required this.text,
    required this.isStreaming,
    required this.detectedLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final isChineseInput = detectedLanguage.language == 'zh' || detectedLanguage.language == 'mixed';
    final label = isChineseInput ? '地道英文' : '中文译文';

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Icon(Icons.translate, size: 12, color: AppColors.translation),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.cardLabel.copyWith(color: AppColors.translation)),
        if (isStreaming) ...[
          const SizedBox(width: 6),
          _StreamingBadge(color: AppColors.translation),
        ],
      ]),
      const SizedBox(height: 4),
      _StreamingText(
        text: text,
        isStreaming: isStreaming,
        style: AppTextStyles.resultBody.copyWith(color: AppColors.textPrimary),
      ),
    ]);
  }
}

class _ActionRow extends ConsumerWidget {
  final ConversationEntry entry;

  const _ActionRow({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaved = entry.isSaved;
    final ttsState = ref.watch(ttsNotifierProvider);
    final isTtsGeneratingForThis = ttsState.status == TtsPlaybackStatus.generating &&
        ttsState.currentPlaybackKey == entry.id;
    final isTtsLoadingForThis = ttsState.status == TtsPlaybackStatus.loading &&
        ttsState.currentPlaybackKey == entry.id;
    final isTtsPlayingForThis = ttsState.status == TtsPlaybackStatus.playing &&
        ttsState.currentPlaybackKey == entry.id;
    final isTtsPausedForThis = ttsState.status == TtsPlaybackStatus.paused &&
        ttsState.currentPlaybackKey == entry.id;
    final isTtsErrorForThis = ttsState.status == TtsPlaybackStatus.error &&
        ttsState.currentPlaybackKey == entry.id;

    final isChineseInput = entry.detectedLanguage.language == 'zh' ||
        entry.detectedLanguage.language == 'mixed';
    final englishText = isChineseInput
        ? (entry.translatedText ?? '')
        : entry.optimizedText;

    return Row(children: [
      (isTtsGeneratingForThis || isTtsLoadingForThis)
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.8,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  isTtsGeneratingForThis ? '生成中' : '读取中',
                  style: TextStyle(fontSize: 12, color: AppColors.primary),
                ),
              ]),
            )
          : isTtsPlayingForThis
              ? _SmallActionButton(
                  icon: Icons.pause_rounded,
                  label: '暂停',
                  color: AppColors.primary,
                  onTap: () => ref.read(ttsNotifierProvider.notifier).pauseOrResume(),
                )
              : isTtsPausedForThis
                  ? _SmallActionButton(
                      icon: Icons.play_arrow_rounded,
                      label: '继续',
                      color: AppColors.primary,
                      onTap: () => ref.read(ttsNotifierProvider.notifier).pauseOrResume(),
                    )
                  : _SmallActionButton(
              icon: isTtsErrorForThis ? Icons.refresh : Icons.volume_up_outlined,
              label: isTtsErrorForThis ? '重新生成' : '朗读',
              color: isTtsErrorForThis ? AppColors.error : AppColors.primary,
              onTap: () async {
                if (englishText.trim().isEmpty) return;

                if (!isTtsErrorForThis) {
                  // 1. Session entry already has audio (generated earlier this session)
                  if (entry.audioFilePath != null) {
                    ref.read(ttsNotifierProvider.notifier).playExisting(
                      entry.audioFilePath!, entry.id,
                      onError: (msg) {
                        showTopSnackBar(context, msg, isError: true);
                        ref.read(ttsNotifierProvider.notifier).generateAndPlay(
                          englishText, entry.id,
                          onAudioGenerated: (path) async {
                            ref.read(conversationHistoryNotifierProvider.notifier)
                                .updateAudioPath(entry.id, path);
                            final latestEntry = ref.read(conversationHistoryNotifierProvider)
                                .entries.firstWhere((e) => e.id == entry.id, orElse: () => entry);
                            if (latestEntry.savedNoteId != null) {
                              await ref.read(noteRepositoryProvider)
                                  .updateAudioPath(latestEntry.savedNoteId!, path);
                            }
                          },
                          onError: (msg2) => showTopSnackBar(context, msg2, isError: true),
                        );
                      },
                    );
                    return;
                  }
                  // 2. Linked note has audio in DB (saved note, audio from note screen)
                  if (entry.savedNoteId != null) {
                    final existingPath = await ref
                        .read(noteRepositoryProvider)
                        .getAudioPath(entry.savedNoteId!);
                    if (existingPath != null) {
                      ref.read(conversationHistoryNotifierProvider.notifier)
                          .updateAudioPath(entry.id, existingPath);
                      ref.read(ttsNotifierProvider.notifier).playExisting(
                        existingPath, entry.id,
                        onError: (msg) {
                          showTopSnackBar(context, msg, isError: true);
                          ref.read(ttsNotifierProvider.notifier).generateAndPlay(
                            englishText, entry.id,
                            onAudioGenerated: (path) async {
                              ref.read(conversationHistoryNotifierProvider.notifier)
                                  .updateAudioPath(entry.id, path);
                              final latestEntry = ref.read(conversationHistoryNotifierProvider)
                                  .entries.firstWhere((e) => e.id == entry.id, orElse: () => entry);
                              if (latestEntry.savedNoteId != null) {
                                await ref.read(noteRepositoryProvider)
                                    .updateAudioPath(latestEntry.savedNoteId!, path);
                              }
                            },
                            onError: (msg2) => showTopSnackBar(context, msg2, isError: true),
                          );
                        },
                      );
                      return;
                    }
                  }
                }

                ref.read(ttsNotifierProvider.notifier).generateAndPlay(
                  englishText,
                  entry.id,
                  onAudioGenerated: (path) async {
                    ref.read(conversationHistoryNotifierProvider.notifier)
                        .updateAudioPath(entry.id, path);
                    // Read latest entry from state to get current savedNoteId —
                    // avoids race condition where save completes during TTS generation.
                    final latestEntry = ref.read(conversationHistoryNotifierProvider)
                        .entries.firstWhere((e) => e.id == entry.id, orElse: () => entry);
                    if (latestEntry.savedNoteId != null) {
                      await ref.read(noteRepositoryProvider)
                          .updateAudioPath(latestEntry.savedNoteId!, path);
                    }
                  },
                  onError: (msg) => showTopSnackBar(context, msg, isError: true),
                );
              },
            ),
      const SizedBox(width: AppSpacing.sm),
      _SmallActionButton(
        icon: Icons.copy_outlined,
        label: '复制英文',
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: englishText));
          if (context.mounted) showTopSnackBar(context, '已复制');
        },
      ),
      const Spacer(),
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isSaved
            ? GestureDetector(
                key: const ValueKey('saved'),
                onTap: () async {
                  final noteId = entry.savedNoteId;
                  if (noteId == null) return;
                  await ref.read(deleteNoteUseCaseProvider).call(noteId);
                  ref.read(conversationHistoryNotifierProvider.notifier).markUnsaved(entry.id);
                  ref.invalidate(noteListNotifierProvider);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.check, size: 14, color: AppColors.success),
                    const SizedBox(width: 4),
                    const Text('已保存', style: TextStyle(fontSize: 13, color: AppColors.success, fontWeight: FontWeight.w600)),
                  ]),
                ),
              )
            : FilledButton.icon(
                key: const ValueKey('save'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.bookmark_outlined, size: 14),
                label: const Text('保存', style: TextStyle(fontSize: 13)),
                onPressed: () async {
                  final noteId = await ref.read(saveAndTagNoteUseCaseProvider).call(
                    originalText: entry.originalText,
                    optimizedText: entry.optimizedText,
                    translatedText: entry.translatedText,
                    detectedLanguage: entry.detectedLanguage.language,
                    confidence: entry.detectedLanguage.confidence,
                    skipOptimization: entry.skipOptimization,
                  );
                  ref.read(conversationHistoryNotifierProvider.notifier).markSaved(entry.id, noteId);
                  if (entry.audioFilePath != null) {
                    await ref.read(noteRepositoryProvider).updateAudioPath(noteId, entry.audioFilePath!);
                  }
                  ref.invalidate(noteListNotifierProvider);
                },
              ),
      ),
    ]);
  }
}

class _SmallActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _SmallActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 14, color: c),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: c)),
        ]),
      ),
    );
  }
}

/// Typewriter text for streaming output.
class _StreamingText extends StatelessWidget {
  final String text;
  final bool isStreaming;
  final TextStyle style;

  const _StreamingText({
    required this.text,
    required this.isStreaming,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    if (!isStreaming || text.isEmpty) {
      return SelectableText(text, style: style);
    }
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: text, style: style),
          // Blinking cursor
          WidgetSpan(
            child: _BlinkingCursor(color: style.color ?? AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  final Color color;

  const _BlinkingCursor({required this.color});

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Opacity(
        opacity: _ctrl.value,
        child: Container(
          width: 2,
          height: 16,
          color: widget.color,
        ),
      ),
    );
  }
}

class _StreamingBadge extends StatelessWidget {
  final Color? color;

  const _StreamingBadge({this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: c.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          width: 8, height: 8,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: c,
          ),
        ),
        const SizedBox(width: 3),
        Text('生成中', style: TextStyle(fontSize: 9, color: c, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
