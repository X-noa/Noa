import 'package:flutter/material.dart';
import 'package:noa/screens/activity_player_screen.dart';
import 'package:noa/screens/mood_history_screen.dart';
import 'package:noa/screens/uplift_screen.dart';
import 'package:noa/services/microcopy_service.dart';
import 'package:noa/theme/noa_theme.dart';
import 'package:noa/widgets/activity_card.dart';
import 'package:noa/screens/chat_screen.dart';
import 'package:noa/widgets/mood_logger.dart';
import 'package:noa/widgets/noa_app_bar.dart';
import 'package:noa/widgets/noa_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final MicrocopyService _microcopyService = MicrocopyService();
  bool _microcopyLoaded = false;

  late AnimationController _entranceController;
  late AnimationController _fabController;
  late AnimationController _moodController;
  late Animation<double> _fabAnimation;
  late Animation<Color?> _moodColorAnimation;
  late Animation<double> _moodLiftAnimation;
  List<Animation<double>> _activityCardAnimations = [];

  // Mock data for activities
  final List<Map<String, String>> _activities = [
    {'title': 'Mindful Breathing', 'duration': '2 min', 'benefit': 'Calm your mind'},
    {'title': 'Quick Stretch', 'duration': '3 min', 'benefit': 'Energize your body'},
    {'title': 'Jot Down a Thought', 'duration': '5 min', 'benefit': 'Clear your head'},
  ];

  @override
  void initState() {
    super.initState();
    _loadMicrocopy();

    _entranceController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500 + (60 * _activities.length)),
    );

    for (int i = 0; i < _activities.length; i++) {
      _activityCardAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Interval(
              (i * 60) / _entranceController.duration!.inMilliseconds,
              (500 + i * 60) / _entranceController.duration!.inMilliseconds,
              curve: Curves.easeOut,
            ),
          ),
        ),
      );
    }

    _fabController = AnimationController(
      vsync: this,
      duration: NoaMotion.microPress,
    );

    _fabAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(_fabController);

    _moodController = AnimationController(
        duration: const Duration(milliseconds: 320), vsync: this);

    _moodColorAnimation = ColorTween(
      begin: NoaTheme.neutralSurface, // Default card color
      end: NoaTheme.secondary.withOpacity(0.3), // New mood color
    ).animate(_moodController);

    _moodLiftAnimation = Tween<double>(begin: 0.0, end: -6.0).animate(
      CurvedAnimation(parent: _moodController, curve: Curves.easeInOut),
    );

    _entranceController.forward();
  }

  Future<void> _loadMicrocopy() async {
    await _microcopyService.load();
    if (mounted) {
      setState(() {
        _microcopyLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _fabController.dispose();
    _moodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_microcopyLoaded) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: NoaAppBar(
        title: _microcopyService.get('home_micro_slogan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(NoaTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Good morning,', style: NoaTheme.h2),
            const Text('How are you feeling today?', style: NoaTheme.body),
            const SizedBox(height: NoaTheme.spacing32),
            AnimatedBuilder(
              animation: _moodController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _moodLiftAnimation.value),
                  child: NoaCard(
                    color: _moodColorAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Row(
                children: [
                  const Text('😊', style: TextStyle(fontSize: 48)),
                  const SizedBox(width: NoaTheme.spacing16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('How are you?', style: NoaTheme.h3),
                        Text('Your mood seems stable.', style: NoaTheme.small),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Trigger animation and open logger
                      _moodController.forward().then((_) => _moodController.reverse());
                      _showMoodLogger(context);
                    },
                    icon: const Icon(Icons.arrow_forward_ios),
                  )
                ],
              ),
            ),
            const SizedBox(height: NoaTheme.spacing32),
            const Text('Recommended Activities', style: NoaTheme.h3),
            const SizedBox(height: NoaTheme.spacing16),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _activities.length,
                itemBuilder: (context, index) {
                  final activity = _activities[index];
                  return AnimatedBuilder(
                    animation: _activityCardAnimations[index],
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _activityCardAnimations[index],
                        child: Transform.translate(
                          offset: Offset(0, 30 * (1 - _activityCardAnimations[index].value)),
                          child: child,
                        ),
                      );
                    },
                    child: ActivityCard(
                      title: activity['title']!,
                      duration: activity['duration']!,
                      benefit: activity['benefit']!,
                      onStart: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ActivityPlayerScreen(),
                        ));
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: NoaTheme.spacing32),
            const Text('Quick Actions', style: NoaTheme.h3),
            const SizedBox(height: NoaTheme.spacing16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickAction(context, Icons.sentiment_very_satisfied, 'Joke', () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const UpliftScreen(),
                  ));
                }),
                _buildQuickAction(context, Icons.edit, 'Log mood', () {
                  _showMoodLogger(context);
                }),
                _buildQuickAction(context, Icons.history, 'History', () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MoodHistoryScreen(),
                  ));
                }),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: () {
             _fabController.forward().then((_) {
              _fabController.reverse();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ChatScreen(),
              ));
            });
          },
          backgroundColor: NoaTheme.primary,
          child: const Icon(Icons.chat_bubble_outline),
        ),
      ),
    );
  }

  void _showMoodLogger(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const MoodLogger(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(NoaTheme.modalRadius)),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(NoaTheme.cardRadius),
      child: Padding(
        padding: const EdgeInsets.all(NoaTheme.spacing8),
        child: Column(
          children: [
            Icon(icon, color: NoaTheme.primary, size: 32),
            const SizedBox(height: NoaTheme.spacing8),
            Text(label, style: NoaTheme.small),
          ],
        ),
      ),
    );
  }
}
