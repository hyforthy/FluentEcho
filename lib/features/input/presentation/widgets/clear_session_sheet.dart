import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../../../../../shared/theme/app_typography.dart';
import '../providers/conversation_history_notifier.dart';

class ClearSessionSheet extends ConsumerWidget {
  const ClearSessionSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.originalBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('清空本次会话', style: AppTextStyles.appBarTitle),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            '本次会话中未保存的内容将被删除，\n已保存到笔记本的内容不受影响。',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, height: 1.6, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: AppColors.originalBorder),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.error,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  await ref.read(conversationHistoryNotifierProvider.notifier).clearSession();
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('清空会话'),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}
