import 'package:flutter/material.dart';

import '../../core/errors/app_exception.dart';

class ErrorDisplay extends StatelessWidget {
  final Object exception;
  final VoidCallback? onRetry;

  const ErrorDisplay({required this.exception, this.onRetry, super.key});

  String _friendlyMessage() {
    if (exception is MissingKeyException) {
      return '请先在设置中配置 API Key';
    }
    if (exception is TimeoutException) {
      return '请求超时，请检查网络后重试';
    }
    if (exception is NetworkException) {
      return '网络错误，请检查网络连接后重试';
    }
    if (exception is MissingBaseUrlException) {
      return '服务地址未配置，请检查设置';
    }
    return '出现错误，请稍后重试';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: colorScheme.error),
            const SizedBox(height: 12),
            Text(
              _friendlyMessage(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: onRetry,
                child: const Text('重试'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
