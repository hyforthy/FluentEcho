import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../shared/theme/app_colors.dart';

class WaveformIndicator extends StatefulWidget {
  final bool isActive;
  final Color barColor;
  final double amplitude;

  const WaveformIndicator({
    required this.isActive,
    this.barColor = AppColors.textOnPrimary,
    this.amplitude = 0.5,
    super.key,
  });

  @override
  State<WaveformIndicator> createState() => _WaveformIndicatorState();
}

class _WaveformIndicatorState extends State<WaveformIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final _random = math.Random();
  List<double> _heights = List.filled(20, 0.15);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && widget.isActive && mounted) {
          _updateHeights();
          _ctrl.forward(from: 0);
        }
      });
    if (widget.isActive) _ctrl.forward();
  }

  void _updateHeights() {
    final amp = widget.amplitude.clamp(0.05, 1.0);
    setState(() {
      _heights = List.generate(
        20,
        (_) => amp * (0.25 + _random.nextDouble() * 0.75),
      );
    });
  }

  @override
  void didUpdateWidget(WaveformIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _ctrl.forward();
    } else if (!widget.isActive && oldWidget.isActive) {
      _ctrl.stop();
      setState(() => _heights = List.filled(20, 0.15));
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = (constraints.maxWidth - 19 * 2) / 20;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(_heights.length, (i) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: barWidth.clamp(2.0, 8.0),
                height: constraints.maxHeight * _heights[i],
                decoration: BoxDecoration(
                  color: widget.barColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
