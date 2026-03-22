import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/ai/providers/ai_service_providers.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/storage/audio_file_store.dart';
import '../../../../core/utils/error_log.dart';

enum TtsPlaybackStatus { idle, generating, loading, playing, paused, error }

class TtsState {
  final TtsPlaybackStatus status;
  final String? currentPlaybackKey;
  final Duration? position;
  final Duration? duration;
  final double playbackSpeed;
  final String? errorMessage;

  const TtsState({
    this.status = TtsPlaybackStatus.idle,
    this.currentPlaybackKey,
    this.position,
    this.duration,
    this.playbackSpeed = 1.0,
    this.errorMessage,
  });

  TtsState copyWith({
    TtsPlaybackStatus? status,
    String? currentPlaybackKey,
    Duration? position,
    Duration? duration,
    double? playbackSpeed,
    String? errorMessage,
  }) {
    return TtsState(
      status: status ?? this.status,
      currentPlaybackKey: currentPlaybackKey ?? this.currentPlaybackKey,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class TtsNotifier extends Notifier<TtsState> {
  AudioPlayer? _player;
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  /// True while seek() is in flight. Blocks all position stream events.
  /// Must be set before updating _minPosition/state — otherwise the 20ms
  /// timer can fire between the two writes and push a stale value back.
  bool _blockPosition = false;

  /// The progress bar only moves forward, never backward.
  ///
  /// Every stream event is compared against this value: positions below it
  /// are dropped; positions at or above it are accepted and advance it.
  /// Reset to the actual frame-aligned position on each seek, and to zero
  /// on each new playback session.
  ///
  /// Prevents two sources of leftward jumps:
  ///   1. Frame alignment after seek — the player lands a few ms before target.
  ///   2. Native interpolation jitter — the platform position callback can
  ///      momentarily report a value slightly below the stream's interpolation.
  Duration _minPosition = Duration.zero;

  @override
  TtsState build() {
    ref.onDispose(() {
      _cancelSubscriptions();
      _player?.dispose();
    });
    return const TtsState();
  }

  Future<void> generateAndPlay(
    String text,
    String playbackKey, {
    Future<void> Function(String path)? onAudioGenerated,
    void Function(String message)? onError,
  }) async {
    state = TtsState(
      status: TtsPlaybackStatus.generating,
      currentPlaybackKey: playbackKey,
      playbackSpeed: state.playbackSpeed,
    );

    try {
      final ttsService = ref.read(ttsServiceProvider);
      final audioPath = await ttsService.generate(text);
      await onAudioGenerated?.call(audioPath);
      await _playFromPath(audioPath, playbackKey);
    } catch (e) {
      ref.read(errorLogProvider.notifier).add(
        service: ErrorLogService.tts,
        message: '朗读生成失败',
        error: e,
      );
      final userMessage = ErrorHandler.toUserMessage(e);
      if (e is MissingKeyException || e is MissingBaseUrlException) {
        state = TtsState(playbackSpeed: state.playbackSpeed);
      } else {
        state = state.copyWith(
          status: TtsPlaybackStatus.error,
          errorMessage: userMessage,
        );
      }
      onError?.call(userMessage);
    }
  }

  Future<void> playExisting(
    String audioPath,
    String playbackKey, {
    void Function(String message)? onError,
  }) async {
    state = TtsState(
      status: TtsPlaybackStatus.loading,
      currentPlaybackKey: playbackKey,
      playbackSpeed: state.playbackSpeed,
    );
    try {
      await _playFromPath(audioPath, playbackKey);
    } catch (e) {
      final userMessage = ErrorHandler.toUserMessage(e);
      state = state.copyWith(
        status: TtsPlaybackStatus.error,
        errorMessage: userMessage,
      );
      onError?.call(userMessage);
    }
  }

  Future<void> _playFromPath(String audioPath, String playbackKey) async {
    _blockPosition = false;
    _minPosition = Duration.zero;
    _cancelSubscriptions();
    await _player?.stop();
    _player?.dispose();
    _player = AudioPlayer();

    await _player!.setSpeed(state.playbackSpeed);
    await _player!.setFilePath(audioPath);

    // Fixed 20ms interval — no filtering beyond the forward-only guard below.
    _subscriptions.add(
      _player!.createPositionStream(
        minPeriod: const Duration(milliseconds: 20),
        maxPeriod: const Duration(milliseconds: 20),
      ).listen((pos) {
        if (_blockPosition) return;
        // Drop any position below the high-water mark — progress bar never goes left.
        if (pos < _minPosition) return;
        _minPosition = pos;
        if (state.currentPlaybackKey == playbackKey) {
          state = state.copyWith(position: pos);
        }
      }),
    );

    _subscriptions.add(_player!.durationStream.listen((dur) {
      if (dur != null && state.currentPlaybackKey == playbackKey) {
        state = state.copyWith(duration: dur);
      }
    }));

    // Only handle playing and completed here.
    // paused is written explicitly by pauseOrResume() to avoid spurious
    // paused emissions during player initialisation.
    _subscriptions.add(_player!.playerStateStream.listen((ps) {
      if (state.currentPlaybackKey != playbackKey) return;
      if (ps.processingState == ProcessingState.completed) {
        _cancelSubscriptions();
        state = TtsState(playbackSpeed: state.playbackSpeed);
      } else if (ps.playing) {
        state = state.copyWith(status: TtsPlaybackStatus.playing);
      }
    }));

    // Do not await play() — it resolves only after audio output actually starts,
    // which would block the position stream and freeze the progress bar at zero.
    // The playing status is picked up by playerStateStream above.
    _player!.play().catchError((Object e) {
      if (state.currentPlaybackKey == playbackKey) {
        state = state.copyWith(
          status: TtsPlaybackStatus.error,
          errorMessage: ErrorHandler.toUserMessage(e),
        );
      }
    });
  }

  Future<void> pauseOrResume() async {
    if (_player == null) return;
    if (state.status == TtsPlaybackStatus.playing) {
      await _player!.pause();
      state = state.copyWith(status: TtsPlaybackStatus.paused);
    } else if (state.status == TtsPlaybackStatus.paused) {
      await _player!.play();
      state = state.copyWith(status: TtsPlaybackStatus.playing);
    }
  }

  Future<void> setSpeed(double speed) async {
    state = state.copyWith(playbackSpeed: speed);
    if (_player == null) return;
    final wasPlaying = state.status == TtsPlaybackStatus.playing;
    if (wasPlaying) await _player!.pause();
    await _player!.setSpeed(speed);
    if (wasPlaying) await _player!.play();
  }

  Future<void> seek(Duration position) async {
    if (_player == null) return;
    final dur = state.duration ?? Duration.zero;
    final target = Duration(
      milliseconds: position.inMilliseconds.clamp(0, dur.inMilliseconds),
    );

    // Set _blockPosition before touching state — the 20ms timer could otherwise
    // fire between the two writes and push a stale position back into state.
    _blockPosition = true;
    try {
      state = state.copyWith(position: target); // immediate UI feedback
      await _player!.seek(target);
      // After seek completes, read the exact frame-aligned position from the
      // player. Audio frames (e.g. ~26 ms for MP3) mean the actual landing
      // point may differ slightly from target. Aligning the progress bar to
      // this value ensures the UI and audio are in sync, and the stream can
      // only move forward from here.
      final actual = _player?.position ?? target;
      _minPosition = actual;
      state = state.copyWith(position: actual);
    } finally {
      _blockPosition = false;
    }
  }

  Future<void> stop() async {
    _blockPosition = false;
    _minPosition = Duration.zero;
    _cancelSubscriptions();
    await _player?.stop();
    _player?.dispose();
    _player = null;
    state = const TtsState();
  }

  void _cancelSubscriptions() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
  }
}

final ttsNotifierProvider = NotifierProvider<TtsNotifier, TtsState>(TtsNotifier.new);

/// Provider for total audio storage size (used by SettingsScreen)
final audioSizeProvider = FutureProvider<int>((ref) async {
  return ref.watch(audioFileStoreProvider).getTotalSizeBytes();
});
