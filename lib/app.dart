import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/ai/providers/ai_service_providers.dart';
import 'features/settings/domain/entities/ai_service_config.dart';
import 'features/settings/presentation/providers/ai_config_list_notifier.dart';
import 'shared/theme/app_theme.dart';
import 'features/input/presentation/input_screen.dart';
import 'features/notes/presentation/note_list_screen.dart';
import 'features/notes/presentation/note_detail_screen.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'features/settings/presentation/ai_config_list_screen.dart';
import 'features/settings/presentation/ai_config_edit_screen.dart';
import 'features/settings/presentation/error_log_screen.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const NoteListScreen(),
    ),
    GoRoute(
      path: '/input',
      builder: (context, state) => const InputScreen(),
    ),
    GoRoute(
      path: '/notes/:id',
      builder: (context, state) {
        final rawId = state.pathParameters['id']!;
        final id = int.tryParse(rawId);
        if (id == null) {
          return const _ErrorScreen(message: '无效的笔记 ID');
        }
        return NoteDetailScreen(noteId: id);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/settings/logs',
      builder: (context, state) => const ErrorLogScreen(),
    ),
    GoRoute(
      path: '/settings/:type/configs',
      builder: (context, state) {
        final type = state.pathParameters['type']!;
        final serviceType = _parseServiceType(type);
        if (serviceType == null) {
          return _ErrorScreen(message: '无效的服务类型: $type');
        }
        return AIConfigListScreen(serviceType: serviceType);
      },
    ),
    GoRoute(
      path: '/settings/:type/configs/new',
      builder: (context, state) {
        final type = state.pathParameters['type']!;
        final serviceType = _parseServiceType(type);
        if (serviceType == null) {
          return _ErrorScreen(message: '无效的服务类型: $type');
        }
        return AIConfigEditScreen(serviceType: serviceType);
      },
    ),
    GoRoute(
      path: '/settings/:type/configs/:id/edit',
      builder: (context, state) {
        final type = state.pathParameters['type']!;
        final configId = state.pathParameters['id']!;
        final serviceType = _parseServiceType(type);
        if (serviceType == null) {
          return _ErrorScreen(message: '无效的服务类型: $type');
        }
        return _AIConfigEditLoader(serviceType: serviceType, configId: configId);
      },
    ),
  ],
);

AIServiceType? _parseServiceType(String name) {
  try {
    return AIServiceType.values.byName(name);
  } catch (_) {
    return null;
  }
}

/// Asynchronously loads config then renders AIConfigEditScreen (edit mode)
class _AIConfigEditLoader extends ConsumerWidget {
  final AIServiceType serviceType;
  final String configId;

  const _AIConfigEditLoader({
    required this.serviceType,
    required this.configId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configsAsync = ref.watch(aiConfigListProvider(serviceType));
    return configsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('加载配置失败：$e')),
      ),
      data: (configs) {
        final existing = configs.where((c) => c.id == configId).firstOrNull;
        return AIConfigEditScreen(
          serviceType: serviceType,
          existingConfig: existing,
        );
      },
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  final String message;
  const _ErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(message)),
    );
  }
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pre-warm AI service providers at app root so the async config begins
    // resolving as early as possible, narrowing the cold-start window in
    // which the Notifiers hold stub services (NullLLMService / SystemTtsService
    // / SystemSttService). This is best-effort: if a feature screen is reached
    // before the FutureProvider resolves, the Notifier's ref.listen will pick
    // up the resolved config and swap in the real service on the next frame.
    ref.watch(llmServiceProvider);
    ref.watch(ttsServiceProvider);
    ref.watch(sttServiceProvider);
    return MaterialApp.router(
      title: 'FluentEcho',
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
