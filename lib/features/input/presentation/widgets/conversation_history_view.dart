import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/theme/app_spacing.dart';
import '../providers/conversation_history_notifier.dart';
import '../providers/input_notifier.dart';
import 'ai_result_bubble.dart';
import 'streaming_bubble.dart';
import 'user_bubble.dart';

/// Core display widget: combines conversation history and current streaming state into a scrollable chat list
class ConversationHistoryView extends ConsumerWidget {
  final ScrollController scrollController;

  const ConversationHistoryView({
    required this.scrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(conversationHistoryNotifierProvider);
    final history = historyState.entries;
    final inputState = ref.watch(inputNotifierProvider);
    final translatingIds = ref.watch(translatingEntryIdsProvider);
    final optimizingIds = ref.watch(optimizingEntryIdsProvider);

    final hasActiveStream = inputState.maybeWhen(
      idle: () => false,
      error: (_, __) => false,
      orElse: () => true,
    );

    if (history.isEmpty && !hasActiveStream) {
      return const ConversationEmptyState();
    }

    final itemCount = history.length + (hasActiveStream ? 1 : 0);

    final bottomInset = MediaQuery.of(context).padding.bottom + 88;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // Load more when user scrolls within 600px of the top of the list
        if (notification is ScrollUpdateNotification) {
          final metrics = notification.metrics;
          if (metrics.pixels >= metrics.maxScrollExtent - 600) {
            ref
                .read(conversationHistoryNotifierProvider.notifier)
                .loadMore();
          }
        }
        return false;
      },
      child: ListView.builder(
        controller: scrollController,
        reverse: true,
        padding: EdgeInsets.only(
          top: AppSpacing.sm,
          bottom: bottomInset,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          // With reverse:true the first rendered item (index 0) is the most recent.
          // Streaming bubble is always at index 0 when active.
          if (hasActiveStream && index == 0) {
            final originalText = inputState.maybeWhen(
              detecting: (t) => t,
              preparing: (t, _) => t,
              streaming: (t, _, __, ___, ____) => t,
              orElse: () => '',
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (originalText.isNotEmpty)
                    UserBubble(
                      text: originalText,
                      time: DateTime.now(),
                      isFromVoice: false,
                    ),
                  const SizedBox(height: AppSpacing.xs),
                  const StreamingBubble(),
                ],
              ),
            );
          }

          // Offset history index by 1 when streaming bubble occupies index 0
          final historyIndex =
              history.length - 1 - (hasActiveStream ? index - 1 : index);
          final entry = history[historyIndex];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                UserBubble(
                  text: entry.originalText,
                  time: entry.createdAt,
                  isFromVoice: entry.isFromVoice,
                  onSkipOptimize: (text) => ref
                      .read(inputNotifierProvider.notifier)
                      .skipOptimize(entry, text: text),
                  onReoptimize: (text) => ref
                      .read(inputNotifierProvider.notifier)
                      .reoptimize(entry, text: text),
                ),
                if (entry.optimizedText.isNotEmpty ||
                    entry.errorMessage != null ||
                    translatingIds.contains(entry.id) ||
                    optimizingIds.contains(entry.id)) ...[
                  const SizedBox(height: AppSpacing.xs),
                  AIResultBubble(
                    entry: entry,
                    isStreaming: optimizingIds.contains(entry.id) || translatingIds.contains(entry.id),
                    section: optimizingIds.contains(entry.id)
                        ? StreamingSection.optimizing
                        : translatingIds.contains(entry.id)
                            ? StreamingSection.translating
                            : null,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Empty state shown on first launch or after clearing the conversation
class ConversationEmptyState extends ConsumerWidget {
  const ConversationEmptyState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 100, height: 100,
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF), // AppColors.primaryLight
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.translate, size: 44, color: Color(0xFF2563EB)),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Hi，我是 FluentEcho',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 18, fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            '输入中文或英文，我会帮你优化表达\n支持语音输入，无需切换语言',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: AppSpacing.xl),
          _ExampleChips(
            onExampleTap: (example) =>
                ref.read(inputNotifierProvider.notifier).setInputText(example),
          ),
        ]),
      ),
    );
  }
}

class _ExampleChips extends StatelessWidget {
  final ValueChanged<String> onExampleTap;

  const _ExampleChips({required this.onExampleTap});

  static const examples = [
    '今天天气不错，挺风和日丽的',
    'I feel really confident today',
    '每天进步一点点，挺开心的',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: examples.map((example) =>
        InkWell(
          onTap: () => onExampleTap(example),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Text(example, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
          ),
        ),
      ).toList(),
    );
  }
}
