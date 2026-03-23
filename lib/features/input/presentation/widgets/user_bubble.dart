import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/input_notifier.dart';

class UserBubble extends ConsumerStatefulWidget {
  final String text;
  final DateTime time;
  final bool isFromVoice;

  /// When provided, shows the pencil edit button on the bubble.
  final void Function(String text)? onSkipOptimize;
  final void Function(String text)? onReoptimize;

  const UserBubble({
    required this.text,
    required this.time,
    required this.isFromVoice,
    this.onSkipOptimize,
    this.onReoptimize,
    super.key,
  });

  @override
  ConsumerState<UserBubble> createState() => _UserBubbleState();
}

class _UserBubbleState extends ConsumerState<UserBubble> {
  bool _editing = false;
  late TextEditingController _ctrl;

  String get _myId => widget.time.millisecondsSinceEpoch.toString();

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.text);
    ref.listenManual(bubbleEditingProvider, (_, next) {
      if (_editing && next != _myId) {
        _cancelSilently();
      }
    });
  }

  @override
  void didUpdateWidget(UserBubble old) {
    super.didUpdateWidget(old);
    if (widget.text != old.text && !_editing) {
      _ctrl.text = widget.text;
    }
  }

  @override
  void dispose() {
    if (ref.read(bubbleEditingProvider) == _myId) {
      ref.read(bubbleEditingProvider.notifier).state = null;
    }
    _ctrl.dispose();
    super.dispose();
  }

  void _startEditing() {
    ref.read(bubbleEditingProvider.notifier).state = _myId;
    setState(() {
      _ctrl.text = widget.text;
      _editing = true;
    });
  }

  void _cancelSilently() {
    _ctrl.text = widget.text;
    setState(() => _editing = false);
  }

  void _cancel() {
    _ctrl.text = widget.text;
    ref.read(bubbleEditingProvider.notifier).state = null;
    setState(() => _editing = false);
  }

  void _submitOptimize() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    ref.read(bubbleEditingProvider.notifier).state = null;
    setState(() => _editing = false);
    widget.onReoptimize!(text);
  }

  void _submitSkip() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    ref.read(bubbleEditingProvider.notifier).state = null;
    setState(() => _editing = false);
    widget.onSkipOptimize!(text);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final hasActions = widget.onSkipOptimize != null && widget.onReoptimize != null;

    return Semantics(
      label: '用户输入: ${widget.text}',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(width: 48),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: screenWidth * 0.75),
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft:     Radius.circular(18),
                      topRight:    Radius.circular(18),
                      bottomLeft:  Radius.circular(18),
                      bottomRight: Radius.circular(4),
                    ),
                    boxShadow: [BoxShadow(
                      color: const Color(0xFF0EA5E9).withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.isFromVoice)
                        Row(children: [
                          Icon(Icons.mic, size: 10, color: Colors.white.withOpacity(0.6)),
                          const SizedBox(width: 3),
                          Text('语音输入', style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.6))),
                        ]),
                      if (widget.isFromVoice) const SizedBox(height: 2),
                      if (_editing)
                        TextField(
                          controller: _ctrl,
                          maxLines: null,
                          autofocus: true,
                          style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.black.withOpacity(0.12),
                            contentPadding: const EdgeInsets.symmetric(vertical: 2),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.6)),
                            ),
                          ),
                        )
                      else
                        SelectableText(
                          widget.text,
                          style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.white),
                        ),
                      const SizedBox(height: 4),
                      if (_editing)
                        _EditActionRow(
                          onCancel: _cancel,
                          onOptimize: _submitOptimize,
                          onSkip: _submitSkip,
                        )
                      else
                        Row(children: [
                          Text(
                            DateFormat('HH:mm').format(widget.time),
                            style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.55)),
                          ),
                          const Spacer(),
                          if (hasActions)
                            GestureDetector(
                              onTap: _startEditing,
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
                                child: _PencilButton(),
                              ),
                            ),
                        ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _EditActionRow extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onOptimize;
  final VoidCallback onSkip;

  const _EditActionRow({
    required this.onCancel,
    required this.onOptimize,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onCancel,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              '取消',
              style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.55)),
            ),
          ),
        ),
        const Spacer(),
        _PillButton(label: '重新优化', onTap: onOptimize),
        const SizedBox(width: 8),
        _PillButton(label: '直接翻译', onTap: onSkip),
      ],
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PillButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0284C7),
          ),
        ),
      ),
    );
  }
}

class _PencilButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: CustomPaint(
          size: const Size(11, 11),
          painter: _PencilPainter(),
        ),
      ),
    );
  }
}

class _PencilPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.75)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    // Pencil body (upright, tip at bottom)
    path.moveTo(size.width * 0.68, size.height * 0.08);
    path.lineTo(size.width * 0.92, size.height * 0.32);
    path.lineTo(size.width * 0.32, size.height * 0.92);
    path.lineTo(size.width * 0.08, size.height * 0.92);
    path.lineTo(size.width * 0.08, size.height * 0.68);
    path.close();
    // Diagonal line across body
    path.moveTo(size.width * 0.54, size.height * 0.22);
    path.lineTo(size.width * 0.78, size.height * 0.46);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_PencilPainter old) => false;
}
