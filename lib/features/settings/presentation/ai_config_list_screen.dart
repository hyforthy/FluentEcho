import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/error_display.dart';
import '../domain/entities/ai_service_config.dart';
import 'providers/active_config_providers.dart';
import 'providers/ai_config_list_notifier.dart';

class AIConfigListScreen extends ConsumerWidget {
  final AIServiceType serviceType;

  const AIConfigListScreen({required this.serviceType, super.key});

  String get _title => switch (serviceType) {
    AIServiceType.llm => 'LLM 配置',
    AIServiceType.tts => 'TTS 配置',
    AIServiceType.stt => 'STT 配置',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configsAsync = ref.watch(aiConfigListProvider(serviceType));
    final activeIdAsync = ref.watch(activeConfigIdProvider(serviceType));

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        leadingWidth: 40,
        title: Text(_title, style: AppTextStyles.appBarTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '新增配置',
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onPressed: () => context.push('/settings/${serviceType.name}/configs/new'),
          ),
        ],
      ),
      body: configsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorDisplay(exception: e),
        data: (configs) {
          if (configs.isEmpty) return _EmptyConfigState(serviceType: serviceType);
          // Use valueOrNull so the list renders immediately during brief activeId reload
          final activeId = activeIdAsync.valueOrNull;
          return _ConfigList(configs: configs, activeId: activeId, serviceType: serviceType);
        },
      ),
    );
  }
}

class _ConfigList extends StatelessWidget {
  final List<AIServiceConfig> configs;
  final String? activeId;
  final AIServiceType serviceType;

  const _ConfigList({required this.configs, required this.activeId, required this.serviceType});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: configs.length,
      itemBuilder: (context, index) => _ConfigTile(
        config: configs[index],
        isActive: configs[index].id == activeId,
        serviceType: serviceType,
        isFirst: index == 0,
        isLast: index == configs.length - 1,
      ),
    );
  }
}

class _ConfigTile extends ConsumerWidget {
  final AIServiceConfig config;
  final bool isActive;
  final AIServiceType serviceType;
  final bool isFirst;
  final bool isLast;

  const _ConfigTile({
    required this.config,
    required this.isActive,
    required this.serviceType,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(config.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        color: AppColors.error,
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 22),
      ),
      confirmDismiss: (_) => _confirmDelete(context, ref),
      onDismissed: (_) => ref.read(aiConfigListProvider(serviceType).notifier).delete(config.id),
      child: Container(
        margin: EdgeInsets.only(bottom: isLast ? 0 : 1),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.only(
            topLeft:     Radius.circular(isFirst ? 14 : 4),
            topRight:    Radius.circular(isFirst ? 14 : 4),
            bottomLeft:  Radius.circular(isLast  ? 14 : 4),
            bottomRight: Radius.circular(isLast  ? 14 : 4),
          ),
          border: isActive ? Border.all(color: AppColors.primaryBorder, width: 1.5) : null,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: InkWell(
          borderRadius: BorderRadius.only(
            topLeft:    Radius.circular(isFirst ? 14 : 4),
            topRight:   Radius.circular(isFirst ? 14 : 4),
            bottomLeft:  Radius.circular(isLast ? 14 : 4),
            bottomRight: Radius.circular(isLast ? 14 : 4),
          ),
          onTap: isActive ? null : () => _showSetActiveSheet(context, ref),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 12, AppSpacing.sm, 12),
            child: Row(children: [
              Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? AppColors.primary : Colors.transparent,
                  border: isActive ? null : Border.all(color: AppColors.originalBorder),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text(config.displayName, style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500,
                      color: isActive ? AppColors.primary : AppColors.textPrimary,
                    )),
                    if (isActive) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(4)),
                        child: Text('活跃', style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ]),
                  const SizedBox(height: 2),
                  Text(config.model, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
                  if (config.customBaseUrl != null) ...[
                    const SizedBox(height: 1),
                    Text(config.customBaseUrl!, style: const TextStyle(fontSize: 11, color: AppColors.textHint), overflow: TextOverflow.ellipsis),
                  ],
                ]),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                color: AppColors.textSecondary,
                tooltip: '编辑',
                onPressed: () => context.push('/settings/${serviceType.name}/configs/${config.id}/edit'),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final title = isActive ? '删除活跃配置' : '删除配置';
    final content = isActive
        ? '「${config.displayName}」是当前活跃配置，删除后该服务将不可用，直到重新选择活跃配置。'
        : '确认删除「${config.displayName}」？此操作不可撤销。';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
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

  void _showSetActiveSheet(BuildContext context, WidgetRef ref) {
    final typeLabel = switch (serviceType) {
      AIServiceType.llm => 'LLM',
      AIServiceType.tts => 'TTS',
      AIServiceType.stt => 'STT',
    };
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.originalBorder, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: AppSpacing.lg),
            Text('设为活跃配置', style: AppTextStyles.appBarTitle),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '将「${config.displayName}」设为当前活跃的 $typeLabel 配置？',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, height: 1.6, color: AppColors.textSecondary),
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
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ref.read(aiConfigListProvider(serviceType).notifier).setActive(config.id);
                  },
                  child: const Text('确认设为活跃'),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}

class _EmptyConfigState extends StatelessWidget {
  final AIServiceType serviceType;

  const _EmptyConfigState({required this.serviceType});

  @override
  Widget build(BuildContext context) {
    final (label, icon) = switch (serviceType) {
      AIServiceType.llm => ('LLM 配置', Icons.auto_awesome),
      AIServiceType.tts => ('TTS 配置', Icons.volume_up),
      AIServiceType.stt => ('STT 配置', Icons.mic),
    };
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 80, height: 80,
            decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
            child: Icon(icon, size: 36, color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('还没有$label', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          const Text('点击右上角 + 新增第一条配置', style: TextStyle(fontSize: 13, color: AppColors.textHint)),
        ]),
      ),
    );
  }
}
