import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/error_log.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';

class ErrorLogScreen extends ConsumerWidget {
  const ErrorLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(errorLogProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        leadingWidth: 40,
        title: const Text('错误日志', style: AppTextStyles.appBarTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          onPressed: () => context.pop(),
        ),
        actions: [
          if (entries.isNotEmpty)
            TextButton(
              onPressed: () => _confirmClear(context, ref),
              child: const Text('清空', style: TextStyle(color: AppColors.error)),
            ),
        ],
      ),
      body: entries.isEmpty
          ? const _EmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: entries.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (_, i) => _LogCard(entry: entries[i]),
            ),
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('清空错误日志'),
        content: const Text('确认清空所有错误记录？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('清空'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(errorLogProvider.notifier).clear();
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, size: 56, color: AppColors.success),
          SizedBox(height: AppSpacing.md),
          Text('暂无错误日志', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _LogCard extends StatefulWidget {
  final ErrorLogEntry entry;
  const _LogCard({required this.entry});

  @override
  State<_LogCard> createState() => _LogCardState();
}

class _LogCardState extends State<_LogCard> {
  bool _expanded = false;

  static final _timeFmt = DateFormat('MM-dd HH:mm:ss');

  static Color _serviceColor(ErrorLogService s) => switch (s) {
    ErrorLogService.llm => AppColors.primary,
    ErrorLogService.tts => AppColors.translation,
    ErrorLogService.stt => AppColors.userBubble,
  };

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    final color = _serviceColor(e.service);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: 12),
              child: Row(
                children: [
                  // Service badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      e.serviceLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  // Message
                  Expanded(
                    child: Text(
                      e.message,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  // Timestamp + chevron
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _timeFmt.format(e.timestamp),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 16,
                        color: AppColors.textHint,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Expandable details
          if (_expanded) ...[
            const Divider(height: 1, color: AppColors.divider),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        '详细信息',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: e.details));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('已复制到剪贴板'),
                              duration: Duration(milliseconds: 1500),
                            ),
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.copy, size: 13, color: AppColors.textHint),
                            SizedBox(width: 4),
                            Text(
                              '复制',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      e.details,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontFamily: 'monospace',
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
