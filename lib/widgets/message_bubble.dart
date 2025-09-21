import 'package:flutter/material.dart';
import 'package:noa/theme/noa_theme.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    final alignment = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = isUser ? NoaTheme.neutralSurface : NoaTheme.primary.withOpacity(0.1);
    final textColor = isUser ? NoaTheme.textPrimary : NoaTheme.textPrimary;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            text,
            style: NoaTheme.body.copyWith(color: textColor),
          ),
        ),
      ],
    );
  }
}
