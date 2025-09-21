import 'package:flutter/material.dart';
import 'package:noa/theme/noa_theme.dart';
import 'package:noa/widgets/noa_app_bar.dart';

class MoodHistoryScreen extends StatelessWidget {
  const MoodHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NoaAppBar(
        title: 'Your Mood History',
      ),
      body: Padding(
        padding: const EdgeInsets.all(NoaTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Last 30 Days', style: NoaTheme.h2),
            const SizedBox(height: NoaTheme.spacing16),
            // TODO: Add Sparkline widget
            Container(
              height: 200,
              color: NoaTheme.neutralSurface,
              child: const Center(
                child: Text('Sparkline Placeholder'),
              ),
            ),
            const SizedBox(height: NoaTheme.spacing32),
            const Text('Average Mood: 😊', style: NoaTheme.h3),
            const SizedBox(height: NoaTheme.spacing8),
            const Text(
              'Gentle Tip: A short walk can do wonders for your mood.',
              style: NoaTheme.body,
            ),
          ],
        ),
      ),
    );
  }
}
