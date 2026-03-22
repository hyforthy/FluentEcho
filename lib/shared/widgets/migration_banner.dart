import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/settings/domain/entities/ai_service_config.dart';
import '../../features/settings/presentation/providers/active_config_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class MigrationBanner extends ConsumerWidget {
  final AIServiceType serviceType;

  const MigrationBanner({required this.serviceType, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(activeConfigWithKeyProvider(serviceType));
    return result.when(
      data: (r) => r.maybeWhen(
        missingKey: (config) => Container(
          margin: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.warningBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.warning.withOpacity(0.3)),
          ),
          child: Row(children: [
            const Icon(Icons.warning_amber_rounded, size: 18, color: AppColors.warning),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${_label(serviceType)} 配置「${config.displayName}」已迁移，但 API Key 缺失，请重新输入',
                style: const TextStyle(fontSize: 13, color: AppColors.warning, height: 1.4),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => context.push('/settings/${serviceType.name}/configs/${config.id}/edit'),
              child: const Text('前往补填 ›', style: TextStyle(
                fontSize: 13, color: AppColors.warning,
                fontWeight: FontWeight.w600, decoration: TextDecoration.underline,
              )),
            ),
          ]),
        ),
        orElse: () => const SizedBox.shrink(),
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  String _label(AIServiceType type) => switch (type) {
    AIServiceType.llm => 'LLM', AIServiceType.tts => 'TTS', AIServiceType.stt => 'STT',
  };
}
