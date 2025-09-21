import 'package:flutter/material.dart';
import 'package:noa/theme/noa_theme.dart';
import 'package:noa/widgets/noa_card.dart';
import 'package:noa/widgets/primary_button.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String duration;
  final String benefit;
  final VoidCallback onStart;

  const ActivityCard({
    super.key,
    required this.title,
    required this.duration,
    required this.benefit,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return NoaCard(
      width: 250, // Fixed width for the carousel
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: NoaTheme.h3),
          const SizedBox(height: NoaTheme.spacing8),
          Text(duration, style: NoaTheme.small),
          const SizedBox(height: NoaTheme.spacing8),
          Text(benefit, style: NoaTheme.body),
          const Spacer(),
          PrimaryButton(
            onPressed: onStart,
            text: 'Start',
            size: ButtonSize.small,
          ),
        ],
      ),
    );
  }
}
