import 'package:flutter/material.dart';

OverlayEntry? _activeToast;

/// Shows a toast anchored just below the AppBar.
/// Uses Overlay (not SnackBar) so the position is fixed relative to the screen top
/// and never shifts when the keyboard opens or closes.
/// Replaces any currently visible toast to avoid stacking.
void showTopSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  _activeToast?.remove();
  _activeToast = null;

  final overlay = Overlay.of(context);
  final topOffset = MediaQuery.of(context).padding.top + kToolbarHeight + 12;

  OverlayEntry? entry;
  entry = OverlayEntry(
    builder: (_) => Positioned(
      top: topOffset,
      left: 16,
      right: 16,
      child: _TopToast(message: message, isError: isError),
    ),
  );

  _activeToast = entry;
  overlay.insert(entry);
  Future.delayed(
    Duration(milliseconds: isError ? 3000 : 2000),
    () {
      entry?.remove();
      if (_activeToast == entry) _activeToast = null;
    },
  );
}

class _TopToast extends StatefulWidget {
  final String message;
  final bool isError;

  const _TopToast({required this.message, required this.isError});

  @override
  State<_TopToast> createState() => _TopToastState();
}

class _TopToastState extends State<_TopToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(10),
          color: widget.isError ? const Color(0xFFDC2626) : const Color(0xFF1E293B),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              widget.message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
