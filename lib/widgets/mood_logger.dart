import 'package:flutter/material.dart';
import 'package:noa/theme/noa_theme.dart';

class MoodLogger extends StatefulWidget {
  const MoodLogger({super.key});

  @override
  State<MoodLogger> createState() => _MoodLoggerState();
}

class _MoodLoggerState extends State<MoodLogger> {
  double _moodScore = 3.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(NoaTheme.spacing24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('How are you feeling?', style: NoaTheme.h2),
          const SizedBox(height: NoaTheme.spacing32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMoodEmoji('😞', 1),
              _buildMoodEmoji('😐', 3),
              _buildMoodEmoji('😊', 5),
            ],
          ),
          const SizedBox(height: NoaTheme.spacing16),
          Slider(
            value: _moodScore,
            min: 1,
            max: 5,
            divisions: 4,
            onChanged: (value) {
              setState(() {
                _moodScore = value;
              });
            },
            activeColor: NoaTheme.primary,
            inactiveColor: NoaTheme.neutralSurface,
          ),
        ],
      ),
    );
  }

  Widget _buildMoodEmoji(String emoji, double score) {
    return IconButton(
      icon: Text(emoji, style: const TextStyle(fontSize: 40)),
      onPressed: () {
        setState(() {
          _moodScore = score;
        });
      },
    );
  }
}
