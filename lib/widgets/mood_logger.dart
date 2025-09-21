import 'package:flutter/material.dart';
import 'package:noa/theme/noa_theme.dart';

class MoodLogger extends StatefulWidget {
  const MoodLogger({super.key});

  @override
  State<MoodLogger> createState() => _MoodLoggerState();
}

class _MoodLoggerState extends State<MoodLogger> with TickerProviderStateMixin {
  double _moodScore = 3.0;
  late AnimationController _lowMoodController;
  late AnimationController _midMoodController;
  late AnimationController _highMoodController;

  late Animation<double> _lowMoodAnimation;
  late Animation<double> _midMoodAnimation;
  late Animation<double> _highMoodAnimation;

  @override
  void initState() {
    super.initState();
    _lowMoodController = AnimationController(vsync: this, duration: const Duration(milliseconds: 160));
    _midMoodController = AnimationController(vsync: this, duration: const Duration(milliseconds: 160));
    _highMoodController = AnimationController(vsync: this, duration: const Duration(milliseconds: 160));

    _lowMoodAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(CurvedAnimation(parent: _lowMoodController, curve: Curves.easeOut));
    _midMoodAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(CurvedAnimation(parent: _midMoodController, curve: Curves.easeOut));
    _highMoodAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(CurvedAnimation(parent: _highMoodController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _lowMoodController.dispose();
    _midMoodController.dispose();
    _highMoodController.dispose();
    super.dispose();
  }

  void _triggerAnimation(double score) {
    final controller = _getControllerForScore(score);
    controller?.forward().then((_) => controller.reverse());
  }

  Animation<double> _getAnimationForScore(double score) {
    if (score == 1) return _lowMoodAnimation;
    if (score == 3) return _midMoodAnimation;
    if (score == 5) return _highMoodAnimation;
    return const AlwaysStoppedAnimation(1.0);
  }

   AnimationController? _getControllerForScore(double score) {
    if (score == 1) return _lowMoodController;
    if (score == 3) return _midMoodController;
    if (score == 5) return _highMoodController;
    return null;
  }

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
              _triggerAnimation(value);
            },
            activeColor: NoaTheme.primary,
            inactiveColor: NoaTheme.neutralSurface,
          ),
        ],
      ),
    );
  }

  Widget _buildMoodEmoji(String emoji, double score) {
    return ScaleTransition(
      scale: _getAnimationForScore(score),
      child: IconButton(
        iconSize: 40,
        icon: Text(emoji, style: const TextStyle(fontSize: 40)),
        onPressed: () {
          setState(() {
            _moodScore = score;
          });
          _triggerAnimation(score);
        },
      ),
    );
  }
}
