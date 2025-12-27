import 'package:flutter/material.dart';
import 'package:noa/theme/noa_theme.dart';
import 'package:noa/widgets/noa_app_bar.dart';
import 'package:noa/widgets/noa_card.dart';
import 'package:noa/widgets/sparkline.dart';
import 'package:intl/intl.dart';

class MoodHistoryScreen extends StatefulWidget {
  const MoodHistoryScreen({super.key});

  @override
  State<MoodHistoryScreen> createState() => _MoodHistoryScreenState();
}

class _MoodHistoryScreenState extends State<MoodHistoryScreen> {
  MoodEntry? _selectedEntry;

  // Mock data for the last 7 days
  final List<MoodEntry> _mockData = List.generate(7, (index) {
    return MoodEntry(
      date: DateTime.now().subtract(Duration(days: index)),
      mood: (index % 5) + 1.0, // Cycle through moods 1-5
    );
  }).reversed.toList();

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
            const Text('Last 7 Days', style: NoaTheme.h2),
            const SizedBox(height: NoaTheme.spacing16),
            Sparkline(
              data: _mockData,
              onEntrySelected: (entry) {
                setState(() {
                  _selectedEntry = entry;
                });
              },
            ),
            const SizedBox(height: NoaTheme.spacing24),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _selectedEntry == null
                  ? const SizedBox(key: ValueKey('empty'), height: 60)
                  : DayMicrocard(
                      key: ValueKey(_selectedEntry!.date),
                      entry: _selectedEntry!,
                    ),
            ),
            const Spacer(),
            const Text('Average Mood: 😊', style: NoaTheme.h3),
            const SizedBox(height: NoaTheme.spacing8),
            const Text(
              'Gentle Tip: A short walk can do wonders for your mood.',
              style: NoaTheme.body,
            ),
            const SizedBox(height: NoaTheme.spacing16),
          ],
        ),
      ),
    );
  }
}

class DayMicrocard extends StatelessWidget {
  final MoodEntry entry;
  const DayMicrocard({super.key, required this.entry});

  String _getMoodEmoji(double mood) {
    if (mood <= 1.5) return '😞';
    if (mood <= 2.5) return '😟';
    if (mood <= 3.5) return '😐';
    if (mood <= 4.5) return '🙂';
    return '😊';
  }

  @override
  Widget build(BuildContext context) {
    return NoaCard(
      child: Row(
        children: [
          Text(_getMoodEmoji(entry.mood), style: const TextStyle(fontSize: 24)),
          const SizedBox(width: NoaTheme.spacing12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMd().format(entry.date),
                style: NoaTheme.body.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'Mood: ${entry.mood.toStringAsFixed(1)}',
                style: NoaTheme.small.copyWith(color: NoaTheme.mutedText),
              )
            ],
          )
        ],
      ),
    );
  }
}
