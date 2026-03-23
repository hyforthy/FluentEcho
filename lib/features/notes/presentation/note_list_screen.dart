import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/top_snack_bar.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/error_display.dart';
import '../domain/entities/note.dart';
import '../../../core/database/app_database.dart';
import '../../../shared/tts/presentation/providers/tts_notifier.dart';
import '../domain/usecases/delete_note_usecase.dart';
import '../domain/usecases/export_import_notes_usecase.dart';
import 'providers/note_detail_notifier.dart';
import 'providers/note_list_notifier.dart';
import 'providers/note_tags_notifier.dart';
import '../../input/presentation/providers/conversation_history_notifier.dart';

class NoteListScreen extends ConsumerWidget {
  const NoteListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(noteListNotifierProvider);
    final filter = ref.watch(noteFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: _buildAppBar(context, ref),
      body: Column(children: [
        _SearchBar(),
        _CombinedFilterRow(selected: filter),
        Expanded(
          child: notes.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => ErrorDisplay(exception: e),
            data: (noteGroups) => noteGroups.isEmpty
                ? const _EmptyNotebookState()
                : _NoteGroupedList(groups: noteGroups),
          ),
        ),
      ]),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text('FluentEcho', style: AppTextStyles.appBarTitle),
      backgroundColor: AppColors.surfaceWhite,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_note_outlined, size: 28),
          tooltip: '输入',
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          onPressed: () => context.push('/input'),
        ),
        PopupMenuButton<_AppBarAction>(
          icon: const Icon(Icons.more_vert),
          tooltip: '更多操作',
          padding: EdgeInsets.zero,
          style: const ButtonStyle(
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: WidgetStatePropertyAll(EdgeInsets.zero),
          ),
          onSelected: (action) => _handleAction(context, ref, action),
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: _AppBarAction.export,
              child: ListTile(
                leading: Icon(Icons.upload_outlined),
                title: Text('导出笔记'),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
            PopupMenuItem(
              value: _AppBarAction.import,
              child: ListTile(
                leading: Icon(Icons.download_outlined),
                title: Text('导入笔记'),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _handleAction(
      BuildContext context, WidgetRef ref, _AppBarAction action) async {
    final useCase = ref.read(exportImportNotesUseCaseProvider);
    switch (action) {
      case _AppBarAction.export:
        try {
          final count = await useCase.export();
          if (context.mounted) {
            _showSnack(context, '已导出 $count 条笔记');
          }
        } catch (e) {
          if (context.mounted) _showSnack(context, '导出失败：$e', isError: true);
        }
      case _AppBarAction.import:
        try {
          final (imported, skipped) = await useCase.import();
          if (imported == 0 && skipped == 0) return; // 用户取消
          ref.invalidate(noteListNotifierProvider);
          if (context.mounted) {
            _showSnack(
              context,
              skipped > 0
                  ? '已导入 $imported 条，跳过 $skipped 条无效记录'
                  : '已导入 $imported 条笔记',
            );
          }
        } on FormatException catch (e) {
          if (context.mounted) _showSnack(context, e.message, isError: true);
        } catch (e) {
          if (context.mounted) _showSnack(context, '导入失败：$e', isError: true);
        }
    }
  }

  void _showSnack(BuildContext context, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? AppColors.error : null,
      duration: const Duration(seconds: 3),
    ));
  }
}

enum _AppBarAction { export, import }

class _SearchBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: AppColors.surfaceWhite,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: TextField(
        onChanged: (q) => ref.read(searchQueryProvider.notifier).state = q,
        style: AppTextStyles.inputBody.copyWith(fontSize: 15),
        decoration: InputDecoration(
          hintText: '搜索笔记...',
          hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 15),
          prefixIcon: const Icon(Icons.search, color: AppColors.textHint, size: 20),
          filled: true,
          fillColor: AppColors.scaffoldBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }
}

/// Single scrollable chip row combining language filter and category tags.
class _CombinedFilterRow extends ConsumerWidget {
  final NoteFilter selected;

  const _CombinedFilterRow({required this.selected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(allTagsProvider);
    final selectedTagId = ref.watch(selectedTagIdProvider);
    final tagList = [...tagsAsync.maybeWhen(data: (t) => t, orElse: () => <Tag>[])]
      ..sort((a, b) {
        if (a.name == '其他') return 1;
        if (b.name == '其他') return -1;
        return a.name.compareTo(b.name);
      });

    return Container(
      color: AppColors.surfaceWhite,
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          // Language filter chips
          ...NoteFilter.values.map((f) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(_filterLabel(f)),
              selected: selected == f,
              onSelected: (_) => ref.read(noteFilterProvider.notifier).state = f,
              selectedColor: AppColors.primaryLight,
              checkmarkColor: AppColors.primary,
              side: BorderSide(
                color: selected == f ? AppColors.primaryBorder : AppColors.originalBorder,
              ),
              labelStyle: TextStyle(
                fontSize: 13,
                color: selected == f ? AppColors.primary : AppColors.textSecondary,
                fontWeight: selected == f ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          )),
          // Divider between language filters and category tags
          if (tagList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: VerticalDivider(
                width: 1,
                indent: 12,
                endIndent: 12,
                color: AppColors.divider,
              ),
            ),
          // Category tag chips
          ...tagList.map((tag) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(tag.name),
              selected: selectedTagId == tag.id,
              onSelected: (_) {
                final notifier = ref.read(selectedTagIdProvider.notifier);
                notifier.state = notifier.state == tag.id ? null : tag.id;
              },
              selectedColor: AppColors.primaryLight,
              checkmarkColor: AppColors.primary,
              side: BorderSide(
                color: selectedTagId == tag.id
                    ? AppColors.primaryBorder
                    : AppColors.originalBorder,
              ),
              labelStyle: TextStyle(
                fontSize: 13,
                color: selectedTagId == tag.id
                    ? AppColors.primary
                    : AppColors.textSecondary,
                fontWeight: selectedTagId == tag.id
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          )),
        ],
      ),
    );
  }

  String _filterLabel(NoteFilter f) => switch (f) {
    NoteFilter.all    => '全部',
    NoteFilter.zhToEn => '中→英',
    NoteFilter.enToZh => '英→中',
  };
}

class _NoteGroupedList extends StatelessWidget {
  final List<NoteGroup> groups;

  const _NoteGroupedList({required this.groups});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: groups.map((group) => _buildGroup(group)).expand((w) => w).toList(),
    );
  }

  List<Widget> _buildGroup(NoteGroup group) => [
    SliverPersistentHeader(
      pinned: true,
      delegate: _DateSectionHeaderDelegate(group.date),
    ),
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => NoteCard(note: group.notes[index]),
        childCount: group.notes.length,
      ),
    ),
  ];
}

class _DateSectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final DateTime date;

  _DateSectionHeaderDelegate(this.date);

  @override
  double get minExtent => 32;

  @override
  double get maxExtent => 32;

  @override
  bool shouldRebuild(_DateSectionHeaderDelegate old) => old.date != date;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.scaffoldBg,
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 6, AppSpacing.md, 6),
      child: Text(
        DateFormat('yyyy-MM-dd').format(date),
        style: AppTextStyles.sectionHeader,
      ),
    );
  }
}

class NoteCard extends ConsumerWidget {
  final Note note;

  const NoteCard({required this.note, super.key});

  String _englishText() {
    final isChineseNote = note.detectedLanguage == 'zh' || note.detectedLanguage == 'mixed';
    return isChineseNote
        ? (note.translatedText ?? note.optimizedText ?? '')
        : (note.optimizedText ?? '');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ttsState = ref.watch(ttsNotifierProvider);
    final key = note.id.toString();
    final isThisNote = ttsState.currentPlaybackKey == key;
    final isPlaying = isThisNote && ttsState.status == TtsPlaybackStatus.playing;
    final isPaused = isThisNote && ttsState.status == TtsPlaybackStatus.paused;
    final isGenerating = isThisNote && ttsState.status == TtsPlaybackStatus.generating;
    final isLoading = isThisNote && ttsState.status == TtsPlaybackStatus.loading;

    return Dismissible(
      key: ValueKey(note.id),
      background: const _SwipeBackground(
        alignment: Alignment.centerRight,
        color: AppColors.error,
        icon: Icons.delete,
        label: '删除',
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _showDeleteConfirm(context),
      onDismissed: (_) {
        unawaited(ref.read(deleteNoteUseCaseProvider).call(note.id));
        ref.read(conversationHistoryNotifierProvider.notifier).markUnsavedByNoteId(note.id);
      },
      child: GestureDetector(
        onLongPress: () => _showContextMenu(context, ref, note),
        onTap: () => context.push('/notes/${note.id}'),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border(
              left: BorderSide(
                color: note.detectedLanguage == 'zh'
                    ? AppColors.primary
                    : AppColors.translation,
                width: 3.5,
              ),
            ),
            boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _HighlightableText(
                text: note.optimizedText ?? note.originalText,
                style: AppTextStyles.noteTitle,
                maxLines: 2,
              ),
              if (note.translatedText != null && note.translatedText!.isNotEmpty) ...[
                const SizedBox(height: 3),
                _HighlightableText(
                  text: note.translatedText!,
                  style: AppTextStyles.noteSubtitle,
                  maxLines: 1,
                ),
              ],
              const SizedBox(height: 8),
              Row(children: [
                Text(
                  DateFormat('MM-dd HH:mm').format(note.createdAt),
                  style: const TextStyle(fontSize: 11, color: AppColors.textHint),
                ),
                const Spacer(),
                _TtsChip(
                  isGenerating: isGenerating,
                  isLoading: isLoading,
                  isPlaying: isPlaying,
                  isPaused: isPaused,
                  hasAudio: note.audioFilePath != null,
                  onTap: () {
                    if (isGenerating || isLoading) return;
                    final text = _englishText();
                    if (text.trim().isEmpty) return;
                    if (isPlaying || isPaused) {
                      ref.read(ttsNotifierProvider.notifier).pauseOrResume();
                    } else if (note.audioFilePath != null) {
                      ref.read(ttsNotifierProvider.notifier).playExisting(
                        note.audioFilePath!,
                        key,
                        onError: (msg) {
                          showTopSnackBar(context, msg, isError: true);
                          ref.read(ttsNotifierProvider.notifier).generateAndPlay(
                            text, key,
                            onAudioGenerated: (path) async {
                              await ref.read(noteRepositoryProvider).updateAudioPath(note.id, path);
                              ref.invalidate(noteListNotifierProvider);
                            },
                            onError: (msg2) => showTopSnackBar(context, msg2, isError: true),
                          );
                        },
                      );
                    } else {
                      ref.read(ttsNotifierProvider.notifier).generateAndPlay(
                        text,
                        key,
                        onAudioGenerated: (path) async {
                          await ref.read(noteRepositoryProvider).updateAudioPath(note.id, path);
                          ref.invalidate(noteListNotifierProvider);
                        },
                        onError: (msg) => showTopSnackBar(context, msg, isError: true),
                      );
                    }
                  },
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}

class _TtsChip extends StatelessWidget {
  final bool isGenerating;
  final bool isLoading;
  final bool isPlaying;
  final bool isPaused;
  final bool hasAudio;
  final VoidCallback onTap;

  const _TtsChip({
    required this.isGenerating,
    required this.isLoading,
    required this.isPlaying,
    required this.isPaused,
    required this.hasAudio,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isBusy = isGenerating || isLoading;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isPlaying ? AppColors.primaryLight : AppColors.scaffoldBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isPlaying ? AppColors.primaryBorder : AppColors.originalBorder,
          ),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (isBusy)
            const SizedBox(
              width: 11, height: 11,
              child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.primary),
            )
          else
            Icon(
              isPlaying
                  ? Icons.pause_rounded
                  : isPaused
                      ? Icons.play_arrow_rounded
                      : Icons.volume_up_rounded,
              size: 12,
              color: (isPlaying || isPaused) ? AppColors.primary : AppColors.textSecondary,
            ),
          const SizedBox(width: 3),
          Text(
            isGenerating
                ? '生成中'
                : isLoading
                    ? '读取中'
                    : isPlaying
                        ? '暂停'
                        : isPaused
                            ? '继续'
                            : '朗读',
            style: TextStyle(
              fontSize: 11,
              color: (isPlaying || isPaused) ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ]),
      ),
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  final AlignmentGeometry alignment;
  final Color color;
  final IconData icon;
  final String label;

  const _SwipeBackground({
    required this.alignment,
    required this.color,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 11)),
      ]),
    );
  }
}

Future<bool> _showDeleteConfirm(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('删除笔记'),
      content: const Text('此操作不可撤销，确认删除这条笔记吗？'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('取消'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('删除'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

void _showContextMenu(BuildContext context, WidgetRef ref, Note note) {
  showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: AppColors.originalBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: AppColors.error),
            title: const Text('删除笔记', style: TextStyle(color: AppColors.error)),
            onTap: () async {
              Navigator.pop(context);
              final ok = await _showDeleteConfirm(context);
              if (ok) {
                unawaited(ref.read(deleteNoteUseCaseProvider).call(note.id));
                ref.read(conversationHistoryNotifierProvider.notifier).markUnsavedByNoteId(note.id);
                ref.invalidate(noteListNotifierProvider);
              }
            },
          ),
        ],
      ),
    ),
  );
}

class _HighlightableText extends ConsumerWidget {
  final String text;
  final TextStyle style;
  final int maxLines;

  const _HighlightableText({
    required this.text,
    required this.style,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);

    if (query.isEmpty) {
      return Text(text, style: style, maxLines: maxLines, overflow: TextOverflow.ellipsis);
    }

    final spans = _buildHighlightSpans(text, query, style);
    return RichText(
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(children: spans),
    );
  }

  List<TextSpan> _buildHighlightSpans(String text, String query, TextStyle base) {
    final List<TextSpan> spans = [];
    final lower = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    var start = 0;

    while (true) {
      final index = lower.indexOf(lowerQuery, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start), style: base));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index), style: base));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: base.copyWith(
          backgroundColor: const Color(0xFFFEF08A),
          color: AppColors.textPrimary,
        ),
      ));
      start = index + query.length;
    }
    return spans;
  }
}

class _EmptyNotebookState extends StatelessWidget {
  const _EmptyNotebookState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 80, height: 80,
            decoration: const BoxDecoration(
              color: AppColors.originalBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.menu_book_outlined, size: 36, color: AppColors.textHint),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text('笔记本还是空的', style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textSecondary,
          )),
          const SizedBox(height: 6),
          const Text('在AI助手页保存记录后会显示在这里', style: TextStyle(
            fontSize: 13, color: AppColors.textHint,
          )),
        ]),
      ),
    );
  }
}
