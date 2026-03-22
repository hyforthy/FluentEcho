import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../domain/entities/conversation_entry.dart';
import '../providers/input_notifier.dart';
import 'ai_result_bubble.dart';

/// Streaming bubble: displayed while the AI is currently streaming its response
class StreamingBubble extends ConsumerWidget {
  const StreamingBubble({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inputState = ref.watch(inputNotifierProvider);

    return inputState.maybeWhen(
      detecting: (originalText) => _ThinkingBubble(label: '正在识别语言...'),
      preparing: (originalText, _) => _ThinkingBubble(label: 'AI 分析中...'),
      streaming: (originalText, detected, section, optimized, translation) =>
          AIResultBubble(
            entry: ConversationEntry(
              id: 'streaming',
              originalText: originalText,
              optimizedText: optimized,
              translatedText: translation.isNotEmpty ? translation : null,
              detectedLanguage: detected,
              createdAt: DateTime.now(),
            ),
            isStreaming: true,
            section: section,
          ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _ThinkingBubble extends StatelessWidget {
  final String label;

  const _ThinkingBubble({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const SizedBox(width: 12),
      _AiAvatarSmall(),
      const SizedBox(width: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 1.8,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ]),
      ),
    ]);
  }
}

class _AiAvatarSmall extends StatelessWidget {
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

