import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../domain/entities/ai_service_config.dart';
import 'providers/active_config_providers.dart';
import '../../../shared/widgets/migration_banner.dart';
import '../../input/presentation/providers/conversation_history_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        leadingWidth: 40,
        title: const Text('设置', style: AppTextStyles.appBarTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          MigrationBanner(serviceType: AIServiceType.llm),
          MigrationBanner(serviceType: AIServiceType.tts),
          MigrationBanner(serviceType: AIServiceType.stt),

          const _SectionHeader(title: 'AI 服务配置'),
          _SettingsCard(children: [
            _ProviderTile(
              icon: Icons.auto_awesome,
              iconColor: AppColors.primary,
              title: '文本优化（LLM）',
              subtitle: _activeConfigLabel(ref, AIServiceType.llm),
              onTap: () => context.push('/settings/llm/configs'),
            ),
            const _Divider(),
            _ProviderTile(
              icon: Icons.volume_up,
              iconColor: AppColors.translation,
              title: '语音朗读（TTS）',
              subtitle: _activeConfigLabel(ref, AIServiceType.tts),
              onTap: () => context.push('/settings/tts/configs'),
            ),
            const _Divider(),
            _ProviderTile(
              icon: Icons.mic,
              iconColor: AppColors.userBubble,
              title: '语音识别（STT）',
              subtitle: _activeConfigLabel(ref, AIServiceType.stt),
              onTap: () => context.push('/settings/stt/configs'),
            ),
          ]),

          const _SectionHeader(title: '存储管理'),
          _SettingsCard(children: [
            _SettingsTile(
              icon: Icons.forum_outlined,
              iconColor: AppColors.error,
              title: '清空会话记录',
              titleColor: AppColors.error,
              trailing: const SizedBox.shrink(),
              onTap: () => _showClearSessionConfirm(context, ref),
            ),
          ]),

          const _SectionHeader(title: '诊断'),
          _SettingsCard(children: [
            _SettingsTile(
              icon: Icons.bug_report_outlined,
              iconColor: AppColors.error,
              title: '错误日志',
              trailing: const Icon(Icons.chevron_right, color: AppColors.textHint),
              onTap: () => context.push('/settings/logs'),
            ),
          ]),

          const _SectionHeader(title: '关于'),
          _SettingsCard(children: [
            const _SettingsTile(
              icon: Icons.info_outline,
              iconColor: AppColors.textSecondary,
              title: '版本',
              trailing: Text('v1.0.0', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              onTap: null,
            ),
            const _Divider(),
            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              iconColor: AppColors.textSecondary,
              title: '隐私政策',
              trailing: const Icon(Icons.chevron_right, color: AppColors.textHint),
              onTap: () => _showPrivacyPolicy(context),
            ),
          ]),

          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('隐私政策'),
        content: const SingleChildScrollView(
          child: Text(
            '最后更新：2026年3月\n\n'
            'FluentEcho 由个人开发者提供，旨在帮助用户记录和优化英语学习内容。\n\n'
            '一、数据收集与存储\n'
            '本应用所有数据均存储在您的设备本地，包括：语音录音、AI 优化文本、翻译结果、TTS 音频文件及笔记标签。我们不运营任何服务器，不上传、不收集您的个人信息。\n\n'
            '二、第三方 AI 服务\n'
            '为提供文本优化、翻译及语音合成功能，您可自行配置第三方 AI 服务（如 OpenAI、Anthropic Claude、火山引擎等）。您的输入文本将发送至您选择的第三方服务进行处理。请参阅对应服务商的隐私政策，了解其数据处理方式。您的 API Key 仅保存在本地设备的安全存储中。\n\n'
            '三、语音与音频\n'
            '语音录音在识别完成后不会长期保存原始音频。TTS 生成的音频文件保存在本地，可通过设置删除。\n\n'
            '四、网络权限\n'
            '本应用仅在调用 AI 服务时访问网络，不存在后台数据上传行为。\n\n'
            '五、变更通知\n'
            '政策更新时，版本号将同步更新。建议定期查看本页面。\n\n'
            '如有疑问，请通过应用内反馈渠道联系我们。',
            style: TextStyle(fontSize: 13, height: 1.6, color: Color(0xFF333333)),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('我知道了'),
          ),
        ],
      ),
    );
  }

  Future<void> _showClearSessionConfirm(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('清空会话记录'),
        content: const Text('本次会话中未保存的内容将被删除，已保存到笔记本的内容不受影响。'),
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
      await ref.read(conversationHistoryNotifierProvider.notifier).clearSession();
    }
  }

}

String _activeConfigLabel(WidgetRef ref, AIServiceType type) {
  final result = ref.watch(activeConfigWithKeyProvider(type));
  return result.when(
    data: (r) => r.when(
      configured: (config, _) => config.displayName,
      noActiveConfig: () => '未配置',
      missingKey: (config) => '${config.displayName}（Key 缺失）',
    ),
    loading: () => '加载中...',
    error: (_, __) => '加载失败',
  );
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 8),
      child: Text(title, style: AppTextStyles.sectionHeader),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        )],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class _ProviderTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProviderTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textHint),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      minVerticalPadding: 12,
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color? titleColor;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.trailing,
    this.titleColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      title: Text(title, style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: titleColor ?? AppColors.textPrimary,
      )),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      minVerticalPadding: 14,
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 56, color: AppColors.divider);
  }
}
