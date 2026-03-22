import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../../../../shared/tts/presentation/providers/tts_notifier.dart';

/// TTS mini player (embedded in the bottom action bar of AIResultBubble)
/// Shows only the playback state (playing / paused) for the current entry
class TtsMiniPlayer extends ConsumerWidget {
  final String playbackKey;

  const TtsMiniPlayer({required this.playbackKey, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ttsState = ref.watch(ttsNotifierProvider);
    final isThisEntry = ttsState.currentPlaybackKey == playbackKey;

    if (!isThisEntry || ttsState.status == TtsPlaybackStatus.idle) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (ttsState.status == TtsPlaybackStatus.loading)
          const SizedBox(
            width: 14, height: 14,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
          )
        else
          GestureDetector(
            onTap: () => ref.read(ttsNotifierProvider.notifier).pauseOrResume(),
            child: Icon(
              ttsState.status == TtsPlaybackStatus.playing
                  ? Icons.pause_circle_rounded
                  : Icons.play_circle_rounded,
              size: 18,
              color: AppColors.primary,
            ),
          ),
        if (ttsState.status == TtsPlaybackStatus.playing &&
            ttsState.position != null &&
            ttsState.duration != null) ...[
          const SizedBox(width: 6),
          SizedBox(
            width: 60,
            child: LinearProgressIndicator(
              value: ttsState.duration!.inMilliseconds > 0
                  ? ttsState.position!.inMilliseconds / ttsState.duration!.inMilliseconds
                  : 0,
              backgroundColor: AppColors.primaryBorder,
              color: AppColors.primary,
              minHeight: 2,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ]),
    );
  }
}
