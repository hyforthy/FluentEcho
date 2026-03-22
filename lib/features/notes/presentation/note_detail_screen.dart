import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/utils/top_snack_bar.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/error_display.dart';
import '../domain/entities/note.dart';
import '../domain/usecases/delete_note_usecase.dart';
import '../../../shared/tts/presentation/providers/tts_notifier.dart';
import '../../../core/database/app_database.dart';
import 'providers/note_detail_notifier.dart';
import 'providers/note_tags_notifier.dart';

class NoteDetailScreen extends ConsumerWidget {
  final int noteId;

  const NoteDetailScreen({required this.noteId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final note = ref.watch(noteDetailProvider(noteId));

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: _buildAppBar(context, ref, note.valueOrNull),
      body: note.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorDisplay(exception: e),
        data: (n) => _DetailBody(note: n),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref, Note? note) {
    return AppBar(
      backgroundColor: AppColors.surfaceWhite,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 40,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        onPressed: () => context.pop(),
      ),
      title: const Text('详情', style: AppTextStyles.appBarTitle),
      actions: [
        if (note != null)
          PopupMenuButton<_NoteAction>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(value: _NoteAction.copyEnglish, child: Text('复制英文')),
              const PopupMenuItem(value: _NoteAction.regenTts, child: Text('重新生成朗读')),
              const PopupMenuItem(value: _NoteAction.share, child: Text('分享')),
              const PopupMenuItem(
                value: _NoteAction.delete,
                child: Text('删除', style: TextStyle(color: AppColors.error)),
              ),
            ],
            onSelected: (action) => _handleAction(context, ref, note, action),
          ),
      ],
    );
  }
}

enum _NoteAction { copyEnglish, regenTts, share, delete }

String _englishTextForNote(Note note) {
  final isChineseNote = note.detectedLanguage == 'zh' || note.detectedLanguage == 'mixed';
  return isChineseNote
      ? (note.translatedText ?? note.optimizedText ?? '')
      : (note.optimizedText ?? '');
}

void _handleAction(BuildContext context, WidgetRef ref, Note note, _NoteAction action) {
  switch (action) {
    case _NoteAction.copyEnglish:
      Clipboard.setData(ClipboardData(text: _englishTextForNote(note)));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已复制英文'), duration: Duration(seconds: 2)),
      );

    case _NoteAction.regenTts:
      final text = _englishTextForNote(note);
      if (text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('暂无英文内容，无法生成朗读'), duration: Duration(seconds: 2)),
        );
        return;
      }
      ref.read(noteRepositoryProvider).clearAudioPath(note.id);
      ref.read(ttsNotifierProvider.notifier).generateAndPlay(
        text,
        note.id.toString(),
        onAudioGenerated: (path) async {
          await ref.read(noteRepositoryProvider).updateAudioPath(note.id, path);
          ref.invalidate(noteDetailProvider(note.id));
        },
        onError: (msg) => showTopSnackBar(context, msg, isError: true),
      );

    case _NoteAction.share:
      final shareText = [
        if (note.optimizedText != null) note.optimizedText!,
        if (note.translatedText != null) '\n${note.translatedText!}',
      ].join();
      Share.share(shareText);

    case _NoteAction.delete:
      showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('删除笔记'),
          content: const Text('确定删除这条笔记？此操作不可恢复。'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('删除', style: TextStyle(color: AppColors.error)),
            ),
          ],
        ),
      ).then((confirmed) {
        if (confirmed == true) {
          ref.read(deleteNoteUseCaseProvider).call(note.id);
          context.pop();
        }
      });
  }
}

class _DetailBody extends StatelessWidget {
  final Note note;

  const _DetailBody({required this.note});

  @override
  Widget build(BuildContext context) {
    final isChineseNote = note.detectedLanguage == 'zh' || note.detectedLanguage == 'mixed';
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _OriginalCard(text: note.originalText),
        const SizedBox(height: AppSpacing.md),
        // For Chinese input the optimized text is Chinese, so TTS goes in the translation card; for English input TTS goes in the optimized card.
        _OptimizedCard(note: note, showTts: !isChineseNote),
        const SizedBox(height: AppSpacing.md),
        if (note.translatedText != null && note.translatedText!.isNotEmpty)
          _TranslationCard(
            note: note,
            showTts: isChineseNote,
          ),
        const SizedBox(height: AppSpacing.md),
        _TagsSection(noteId: note.id),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: Text(
            DateFormat('yyyy-MM-dd HH:mm').format(note.createdAt),
            style: const TextStyle(fontSize: 12, color: AppColors.textHint),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
      ]),
    );
  }
}

class _OriginalCard extends StatelessWidget {
  final String text;

  const _OriginalCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.originalBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.originalBorder),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('原文', style: AppTextStyles.cardLabel),
        const SizedBox(height: 8),
        SelectableText(
          text,
          style: AppTextStyles.resultBody.copyWith(color: AppColors.textSecondary),
        ),
      ]),
    );
  }
}

class _OptimizedCard extends StatelessWidget {
  final Note note;
  final bool showTts;

  const _OptimizedCard({required this.note, required this.showTts});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryBorder, width: 1.5),
        boxShadow: [BoxShadow(
          color: AppColors.primary.withOpacity(0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        )],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
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
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Icon(Icons.auto_awesome, size: 13, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text('优化结果', style: AppTextStyles.cardLabel.copyWith(color: AppColors.primary)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.copy_outlined, size: 18),
                      color: AppColors.textSecondary,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: EdgeInsets.zero,
                      tooltip: '复制',
                      onPressed: () => Clipboard.setData(
                        ClipboardData(text: note.optimizedText ?? ''),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  SelectableText(
                    note.optimizedText ?? '',
                    style: AppTextStyles.resultBody,
                  ),
                  if (showTts) ...[
                    const SizedBox(height: AppSpacing.md),
                    const Divider(height: 1, color: AppColors.primaryBorder),
                    const SizedBox(height: AppSpacing.md),
                    _TtsControlSection(
                      note: note,
                      textToRead: note.optimizedText ?? '',
                    ),
                  ],
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _TtsControlSection extends ConsumerStatefulWidget {
  final Note note;
  final String textToRead;

  const _TtsControlSection({
    required this.note,
    required this.textToRead,
  });

  @override
  ConsumerState<_TtsControlSection> createState() => _TtsControlSectionState();
}

class _TtsControlSectionState extends ConsumerState<_TtsControlSection> {
  int _stepSeconds = 5;
  bool _isDragging = false;
  double _dragValue = 0;

  void _skip(int seconds) {
    final live = ref.read(ttsNotifierProvider);
    final pos = live.position ?? Duration.zero;
    final dur = live.duration ?? Duration.zero;
    final clamped = Duration(
      seconds: (pos.inSeconds + seconds).clamp(0, dur.inSeconds),
    );
    ref.read(ttsNotifierProvider.notifier).seek(clamped);
  }

  @override
  Widget build(BuildContext context) {
    final ttsState = ref.watch(ttsNotifierProvider);
    final note = widget.note;
    final isThisNote = ttsState.currentPlaybackKey == note.id.toString();
    final hasAudio = note.audioFilePath != null;
    final textToRead = widget.textToRead;

    final isGenerating = isThisNote && ttsState.status == TtsPlaybackStatus.generating;
    final isLoading = isThisNote && ttsState.status == TtsPlaybackStatus.loading;
    final isPlaying = isThisNote && ttsState.status == TtsPlaybackStatus.playing;
    final isPaused = isThisNote && ttsState.status == TtsPlaybackStatus.paused;
    final showProgress = isThisNote &&
        (ttsState.status == TtsPlaybackStatus.playing ||
            ttsState.status == TtsPlaybackStatus.paused);

    final isBusy = isGenerating || isLoading;
    String buttonLabel;
    IconData buttonIcon;
    if (isGenerating) {
      buttonLabel = '生成中';
      buttonIcon = Icons.hourglass_empty_rounded;
    } else if (isLoading) {
      buttonLabel = '读取中';
      buttonIcon = Icons.hourglass_empty_rounded;
    } else if (isPlaying) {
      buttonLabel = '暂停';
      buttonIcon = Icons.pause_rounded;
    } else if (isPaused) {
      buttonLabel = '继续';
      buttonIcon = Icons.play_arrow_rounded;
    } else {
      buttonLabel = '朗读';
      buttonIcon = Icons.volume_up_rounded;
    }

    final totalMs = ttsState.duration?.inMilliseconds ?? 0;
    final posMs = ttsState.position?.inMilliseconds ?? 0;
    final sliderValue = !_isDragging
        ? (totalMs > 0 ? (posMs / totalMs).clamp(0.0, 1.0) : 0.0)
        : _dragValue;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (showProgress) ...[
        Row(children: [
          Text(
            _formatDuration(
              _isDragging
                  ? Duration(milliseconds: (_dragValue * totalMs).round())
                  : ttsState.position ?? Duration.zero,
            ),
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const Spacer(),
          Text(
            _formatDuration(ttsState.duration ?? Duration.zero),
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ]),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.primaryBorder,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withOpacity(0.15),
          ),
          child: Semantics(
            label: '播放进度',
            child: Slider(
            value: sliderValue,
            onChanged: (v) => setState(() {
              _isDragging = true;
              _dragValue = v;
            }),
            onChangeEnd: (v) {
              setState(() => _isDragging = false);
              if (totalMs > 0) {
                ref.read(ttsNotifierProvider.notifier).seek(
                  Duration(milliseconds: (v * totalMs).round()),
                );
              }
            },
          ),
          ),
        ),
        Row(children: [
          Tooltip(
            message: '后退 ${_stepSeconds} 秒',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _skip(-_stepSeconds),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.replay_rounded, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 2),
                  Text(
                    '${_stepSeconds}s',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ]),
              ),
            ),
          ),
          const Spacer(),
          ...[2, 5, 10, 20].map((s) {
            final selected = _stepSeconds == s;
            return Tooltip(
              message: '跳转步长 ${s} 秒',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _stepSeconds = s),
                child: Container(
                  margin: const EdgeInsets.only(left: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.primaryBorder,
                    ),
                  ),
                  child: Text(
                    '${s}s',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      color: selected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
          Tooltip(
            message: '前进 ${_stepSeconds} 秒',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _skip(_stepSeconds),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    '${_stepSeconds}s',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 2),
                  Transform.scale(
                    scaleX: -1,
                    child: const Icon(Icons.replay_rounded, size: 16, color: AppColors.textSecondary),
                  ),
                ]),
              ),
            ),
          ),
        ]),
        const SizedBox(height: AppSpacing.sm),
      ],
      Row(children: [
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: isBusy ? AppColors.primaryBorder : AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            minimumSize: Size.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: isBusy
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Icon(buttonIcon, size: 18),
          label: Text(buttonLabel, style: const TextStyle(fontSize: 13)),
          onPressed: isBusy
              ? null
              : () {
                  if (isPlaying || isPaused) {
                    ref.read(ttsNotifierProvider.notifier).pauseOrResume();
                  } else if (hasAudio) {
                    ref.read(ttsNotifierProvider.notifier).playExisting(
                      note.audioFilePath!,
                      note.id.toString(),
                      onError: (msg) {
                        showTopSnackBar(context, msg, isError: true);
                        if (textToRead.trim().isEmpty) return;
                        ref.read(ttsNotifierProvider.notifier).generateAndPlay(
                          textToRead,
                          note.id.toString(),
                          onAudioGenerated: (path) async {
                            await ref.read(noteRepositoryProvider).updateAudioPath(note.id, path);
                            ref.invalidate(noteDetailProvider(note.id));
                          },
                          onError: (msg2) => showTopSnackBar(context, msg2, isError: true),
                        );
                      },
                    );
                  } else {
                    if (textToRead.trim().isEmpty) return;
                    ref.read(ttsNotifierProvider.notifier).generateAndPlay(
                      textToRead,
                      note.id.toString(),
                      onAudioGenerated: (path) async {
                        await ref.read(noteRepositoryProvider).updateAudioPath(note.id, path);
                        ref.invalidate(noteDetailProvider(note.id));
                      },
                      onError: (msg) => showTopSnackBar(context, msg, isError: true),
                    );
                  }
                },
        ),
        const SizedBox(width: AppSpacing.sm),
        const Spacer(),
        ...[0.25, 0.5, 1.0, 1.5].map((speed) {
          final isSelected = (ttsState.playbackSpeed - speed).abs() < 0.01;
          final speedLabel = speed == speed.truncateToDouble() ? '${speed.toInt()}' : '$speed';
          return Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Tooltip(
              message: '播放速度 ${speedLabel}×',
              child: GestureDetector(
                onTap: () => ref.read(ttsNotifierProvider.notifier).setSpeed(speed),
                child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.primaryBorder,
                  ),
                ),
                child: Text(
                  '${speedLabel}×',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
          );
        }),
      ]),
    ]);
  }

  String _formatDuration(Duration d) =>
      '${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
}

class _TranslationCard extends StatelessWidget {
  final Note note;
  final bool showTts;

  const _TranslationCard({required this.note, required this.showTts});

  @override
  Widget build(BuildContext context) {
    final text = note.translatedText!;
    final label = note.detectedLanguage == 'zh' ? '地道英文' : '中文译文';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.translationLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.translationBorder, width: 1.5),
        boxShadow: [BoxShadow(
          color: AppColors.translation.withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 3),
        )],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: IntrinsicHeight(
          child: Row(children: [
            Container(width: 4, color: AppColors.translation),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Icon(Icons.translate, size: 13, color: AppColors.translation),
                    const SizedBox(width: 4),
                    Text(label, style: AppTextStyles.cardLabel.copyWith(color: AppColors.translation)),
                  ]),
                  const SizedBox(height: 8),
                  SelectableText(text, style: AppTextStyles.resultBody),
                  if (showTts) ...[
                    const SizedBox(height: AppSpacing.md),
                    const Divider(height: 1, color: AppColors.translationBorder),
                    const SizedBox(height: AppSpacing.md),
                    _TtsControlSection(
                      note: note,
                      textToRead: text,
                    ),
                  ],
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

/// Read-only tag display. Tags are assigned automatically by AI at save time.
class _TagsSection extends ConsumerWidget {
  final int noteId;

  const _TagsSection({required this.noteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(noteTagsProvider(noteId));

    return tagsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (tags) {
        if (tags.isEmpty) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.originalBorder),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.sell_outlined, size: 13, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              const Text(
                '标签',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ]),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: tags.map((tag) => Chip(
                label: Text(tag.name, style: const TextStyle(fontSize: 13, color: AppColors.primary)),
                backgroundColor: AppColors.primaryLight,
                side: const BorderSide(color: AppColors.primaryBorder),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(horizontal: 4),
              )).toList(),
            ),
          ]),
        );
      },
    );
  }
}
