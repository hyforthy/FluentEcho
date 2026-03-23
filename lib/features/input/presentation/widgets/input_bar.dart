import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/errors/error_handler.dart';
import '../../../../../core/utils/error_log.dart';
import '../../../../../core/utils/top_snack_bar.dart';

import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/theme/app_spacing.dart';
import '../../../../../shared/theme/app_typography.dart';
import '../providers/speech_provider.dart';
import 'waveform_indicator.dart';

enum _InputMode { voice, text }

enum _RecordState { idle, recording, processing }

class InputBar extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitText;
  final ValueChanged<String> onVoiceRecorded;

  const InputBar({
    required this.controller,
    required this.onSubmitText,
    required this.onVoiceRecorded,
    super.key,
  });

  @override
  ConsumerState<InputBar> createState() => _InputBarState();
}

class _InputBarState extends ConsumerState<InputBar>
    with SingleTickerProviderStateMixin {
  _InputMode _mode = _InputMode.voice;
  _RecordState _recordState = _RecordState.idle;
  Timer? _recordingTimer;
  Duration _recordingDuration = Duration.zero;
  double _pointerStartY = 0;
  StreamSubscription<double>? _amplitudeSub;
  OverlayEntry? _overlayEntry;

  final _barKey = GlobalKey();
  bool _barHidden = false;
  final _cancelNotifier = ValueNotifier<bool>(false);
  final _amplitudeNotifier = ValueNotifier<double>(0);
  final _durationNotifier = ValueNotifier<Duration>(Duration.zero);

  static const _cancelThreshold = 80.0;

  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _amplitudeSub?.cancel();
    _pulseCtrl.dispose();
    _overlayEntry?.remove();
    _cancelNotifier.dispose();
    _amplitudeNotifier.dispose();
    _durationNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _barHidden ? 0.0 : 1.0,
      child: AnimatedContainer(
      key: _barKey,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.sm,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        child: _mode == _InputMode.voice ? _buildVoiceMode() : _buildTextMode(),
      ),
    ),
    );
  }

  Widget _buildVoiceMode() {
    final showKeyboard = _recordState == _RecordState.idle;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: _buildVoiceModeLeft()),
        if (showKeyboard) ...[
          const SizedBox(width: AppSpacing.sm),
          _buildIconButton(
            key: const ValueKey('keyboard'),
            icon: Icons.keyboard_outlined,
            onTap: () => setState(() => _mode = _InputMode.text),
          ),
        ],
      ],
    );
  }

  Widget _buildVoiceModeLeft() {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (e) => _onPointerDown(e.position.dy),
      onPointerMove: (e) => _onPointerMove(e.position.dy),
      onPointerUp: (_) => _onPointerUp(),
      onPointerCancel: (_) => _cancelRecording(),
      child: switch (_recordState) {
        _RecordState.idle ||
        _RecordState.recording =>
          _buildPressToSpeakContent(),
        _RecordState.processing => _buildProcessingContent(),
      },
    );
  }

  Widget _buildPressToSpeakContent() {
    return const SizedBox(
      height: 44,
      child: Center(
        child: Text(
          '按住说话',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
    );
  }

  Widget _buildProcessingContent() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Text(
            '识别中...',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildTextMode() {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.controller,
      builder: (context, value, _) {
        final hasText = value.text.trim().isNotEmpty;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44, maxHeight: 120),
                child: TextField(
                  controller: widget.controller,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  style: AppTextStyles.inputBody,
                  decoration: InputDecoration(
                    hintText: '输入文字...',
                    hintStyle: AppTextStyles.inputHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide:
                          const BorderSide(color: AppColors.originalBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide:
                          const BorderSide(color: AppColors.originalBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide:
                          const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                    // vertical:8 keeps natural height (8+24.8+8=40.8) below
                    // minHeight:44, so ConstrainedBox clamps text mode to
                    // exactly 44 — matching voice mode SizedBox(44).
                    // If AppTextStyles.inputBody fontSize/height changes,
                    // verify 8+fontSize*height+8 < 44 still holds.
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: hasText
                  ? _buildIconButton(
                      key: const ValueKey('send'),
                      icon: Icons.arrow_upward_rounded,
                      onTap: _submitText,
                    )
                  : _buildIconButton(
                      key: const ValueKey('mic'),
                      icon: Icons.mic_outlined,
                      onTap: () => setState(() => _mode = _InputMode.voice),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIconButton({
    required Key key,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.28),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  void _submitText() {
    final text = widget.controller.text.trim();
    if (text.isNotEmpty) widget.onSubmitText(text);
  }

  // ── Pointer-based voice gesture ───────────────────────────────────────────

  Future<void> _onPointerDown(double y) async {
    if (_recordState != _RecordState.idle) return;

    final status = await Permission.microphone.status;
    if (status.isGranted) {
      _beginPreparing(y);
      return;
    }

    if (status.isPermanentlyDenied) {
      _showMicPermissionSnackBar(permanent: true);
      return;
    }

    // isDenied or isRestricted — request at runtime.
    // Do NOT call _beginPreparing after the dialog: the pointer is already up
    // by the time the system dialog is dismissed, so recording must not auto-start.
    final result = await Permission.microphone.request();
    if (result.isGranted) {
      // Permission just granted — pointer is already up, do nothing.
      // User will press again naturally.
    } else if (result.isPermanentlyDenied) {
      _showMicPermissionSnackBar(permanent: true);
    } else {
      _showMicPermissionSnackBar(permanent: false);
    }
  }

  void _beginPreparing(double y) {
    _pointerStartY = y;
    HapticFeedback.mediumImpact();
    _startRecording();
    _showOverlay();
  }

  void _showMicPermissionSnackBar({required bool permanent}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          permanent ? '麦克风权限已被禁止，请在系统设置中开启' : '需要麦克风权限才能录音',
        ),
        duration: const Duration(milliseconds: 3000),
        action: permanent
            ? SnackBarAction(
                label: '去设置',
                onPressed: openAppSettings,
              )
            : null,
      ),
    );
  }

  void _onPointerMove(double y) {
    if (_recordState != _RecordState.recording) return;
    final dragUp = _pointerStartY - y;
    final cancelling = dragUp >= _cancelThreshold;
    if (_cancelNotifier.value != cancelling) {
      _cancelNotifier.value = cancelling;
    }
  }

  void _onPointerUp() {
    if (_recordState == _RecordState.recording) {
      final shouldCancel = _cancelNotifier.value;
      _removeOverlay();
      if (shouldCancel) {
        _cancelRecording();
      } else {
        // ignore: discarded_futures
        _stopAndSubmit();
      }
    }
  }

  // ── Overlay ───────────────────────────────────────────────────────────────

  void _showOverlay() {
    if (_barKey.currentContext == null) return;

    final screen = MediaQuery.of(context).size;
    // Ellipse: wide enough to cover full screen, short enough that
    // the 80dp cancel swipe feels natural (dome is ~22% of screen height).
    // hRadius = full screen width so the ellipse always exceeds screen edges
    // at every visible height (content sits at 24%–68% of vRadius from bottom).
    // vRadius (22% screen height ≈ 185dp on a 852dp screen) keeps the dome
    // short so the 80dp cancel-swipe threshold sits at ~43% dome height —
    // visually intuitive: swipe roughly halfway up the dome to cancel.
    final hRadius = screen.width;
    final vRadius = screen.height * 0.22;

    _overlayEntry = OverlayEntry(
      builder: (_) => IgnorePointer(
        child: _RecordingHalfCircle(
          hRadius: hRadius,
          vRadius: vRadius,
          cancelNotifier: _cancelNotifier,
          amplitudeNotifier: _amplitudeNotifier,
          durationNotifier: _durationNotifier,
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _barHidden = true);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _cancelNotifier.value = false;
    setState(() => _barHidden = false);
  }

  // ── Recording lifecycle ───────────────────────────────────────────────────

  void _startRecording() {
    setState(() {
      _recordState = _RecordState.recording;
      _recordingDuration = Duration.zero;
    });
    _durationNotifier.value = Duration.zero;
    _amplitudeNotifier.value = 0;
    _pulseCtrl.repeat(reverse: true);
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _recordingDuration += const Duration(seconds: 1);
      _durationNotifier.value = _recordingDuration;
    });
    final recorder = ref.read(audioRecorderProvider);
    recorder.start();
    _amplitudeSub = recorder.amplitudeStream().listen((amp) {
      _amplitudeNotifier.value = amp;
    });
  }

  Future<void> _stopAndSubmit() async {
    _recordingTimer?.cancel();
    _amplitudeSub?.cancel();
    _amplitudeSub = null;
    _pulseCtrl.stop();
    HapticFeedback.lightImpact();
    setState(() => _recordState = _RecordState.processing);
    final audioPath = await ref.read(audioRecorderProvider).stop();
    try {
      final recognizedText =
          await ref.read(sttUseCaseProvider).execute(audioPath);
      if (mounted) {
        setState(() => _recordState = _RecordState.idle);
        widget.onSubmitText(recognizedText);
      }
    } catch (e) {
      ref.read(errorLogProvider.notifier).add(
        service: ErrorLogService.stt,
        message: '语音识别失败',
        error: e,
      );
      if (mounted) {
        showTopSnackBar(context, ErrorHandler.toUserMessage(e), isError: true);
        setState(() => _recordState = _RecordState.idle);
      }
    }
  }

  void _cancelRecording() {
    final wasRecording = _recordState == _RecordState.recording;
    _recordingTimer?.cancel();
    _amplitudeSub?.cancel();
    _amplitudeSub = null;
    _pulseCtrl.stop();
    _removeOverlay();
    HapticFeedback.lightImpact();
    setState(() => _recordState = _RecordState.idle);
    if (wasRecording) {
      ref.read(audioRecorderProvider).cancelAndDelete();
    }
  }
}

// ── Half-circle recording overlay ────────────────────────────────────────────

class _RecordingHalfCircle extends StatelessWidget {
  final ValueNotifier<bool> cancelNotifier;
  final ValueNotifier<double> amplitudeNotifier;
  final ValueNotifier<Duration> durationNotifier;
  final double hRadius;
  final double vRadius;

  const _RecordingHalfCircle({
    required this.cancelNotifier,
    required this.amplitudeNotifier,
    required this.durationNotifier,
    required this.hRadius,
    required this.vRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: cancelNotifier,
      builder: (context, isCancelling, _) {
        final circleColor = isCancelling
            ? const Color(0xFFEF4444)
            : const Color(0xFF10B981);

        return Stack(
          children: [
            // True semicircle: full circle centered at screen-bottom-center,
            // bottom half is off-screen — only the dome is visible.
            Positioned.fill(
              child: TweenAnimationBuilder<Color?>(
                tween: ColorTween(end: circleColor),
                duration: const Duration(milliseconds: 250),
                builder: (_, color, __) => CustomPaint(
                  painter: _SemiCirclePainter(
                    color: color ?? circleColor,
                    hRadius: hRadius,
                    vRadius: vRadius,
                  ),
                ),
              ),
            ),

            // Duration + Waveform on the same row
            Positioned(
              left: 36,
              right: 36,
              bottom: vRadius * 0.36,
              height: 30,
              child: ValueListenableBuilder<Duration>(
                valueListenable: durationNotifier,
                builder: (_, duration, __) => ValueListenableBuilder<double>(
                  valueListenable: amplitudeNotifier,
                  builder: (_, amp, __) => Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${duration.inMinutes.toString().padLeft(2, '0')}:'
                        '${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.88),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFeatures: const [FontFeature.tabularFigures()],
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: WaveformIndicator(
                          isActive: !isCancelling,
                          amplitude: amp,
                          barColor: Colors.white.withOpacity(isCancelling ? 0.35 : 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Hint text
            Positioned(
              left: 0,
              right: 0,
              bottom: vRadius * 0.62,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  isCancelling ? '松手取消' : '松手发送，上滑取消',
                  key: ValueKey(isCancelling),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SemiCirclePainter extends CustomPainter {
  final Color color;
  final double hRadius;
  final double vRadius;

  const _SemiCirclePainter({
    required this.color,
    required this.hRadius,
    required this.vRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    // Use a vertical LinearGradient so the dome fades top→bottom uniformly
    // across its full width — a RadialGradient would create a circular fade
    // that leaves screen edges transparent when hRadius > gradient radius.
    final rect = Rect.fromCenter(
      center: center,
      width: hRadius * 2,
      height: vRadius * 2,
    );
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.0),
          color.withOpacity(0.93),
          color.withOpacity(0.96),
        ],
        // stops[1] at 0.5 = ellipse center = screen bottom, so the visible
        // dome (top half of ellipse) fades from transparent tip to solid base.
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect);
    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(_SemiCirclePainter old) =>
      old.color != color || old.hRadius != hRadius || old.vRadius != vRadius;
}
