import 'package:flutter/material.dart';
import 'package:noa/screens/activity_player_screen.dart';
import 'package:noa/screens/mood_history_screen.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  final MicrocopyService _microcopyService = MicrocopyService();
  bool _microcopyLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadMicrocopy();
  }

  Future<void> _loadMicrocopy() async {
    await _microcopyService.load();
    setState(() {
      _microcopyLoaded = true;
    });
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
            NoaCard(
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
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ActivityCard(
                    title: 'Mindful Breathing',
                    duration: '2 min',
                    benefit: 'Calm your mind',
                    onStart: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ActivityPlayerScreen(),
                      ));
                    },
                  ),
                  ActivityCard(
                    title: 'Quick Stretch',
                    duration: '3 min',
                    benefit: 'Energize your body',
                    onStart: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: NoaTheme.spacing32),
            const Text('Quick Actions', style: NoaTheme.h3),
            const SizedBox(height: NoaTheme.spacing16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickAction(context, Icons.sentiment_very_satisfied, 'Joke', () {}),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ChatScreen(),
          ));
        },
        backgroundColor: NoaTheme.primary,
        child: const Icon(Icons.chat_bubble_outline),
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
