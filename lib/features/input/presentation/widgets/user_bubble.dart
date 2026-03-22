import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserBubble extends StatelessWidget {
  final String text;
  final DateTime time;
  final bool isFromVoice;

  const UserBubble({
    required this.text,
    required this.time,
    required this.isFromVoice,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Semantics(
      label: '用户输入: $text',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(width: 48),
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: screenWidth * 0.75),
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 3),
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
                  if (isFromVoice)
                    Row(children: [
                      Icon(Icons.mic, size: 10, color: Colors.white.withOpacity(0.6)),
                      const SizedBox(width: 3),
                      Text('语音输入', style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.6))),
                    ]),
                  if (isFromVoice) const SizedBox(height: 2),
                  Text(text, style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.white)),
                  const SizedBox(height: 1),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text(
                      DateFormat('HH:mm').format(time),
                      style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.55)),
                    ),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
