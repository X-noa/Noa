import 'package:flutter/material.dart';
import 'package:noa/theme/noa_theme.dart';
import 'package:noa/widgets/breathing_animation.dart';
import 'package:noa/widgets/primary_button.dart';

class ActivityPlayerScreen extends StatelessWidget {
  const ActivityPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              NoaTheme.background,
              Color(0xFFFFF4EC), // Faint orange
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const BreathingAnimation(),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(NoaTheme.spacing32),
              child: PrimaryButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Activity complete! (mocked)')),
                  );
                  Navigator.of(context).pop();
                },
                text: 'Complete',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
