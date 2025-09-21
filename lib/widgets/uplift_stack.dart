import 'package:flutter/material.dart';
import 'package:noa/theme/noa_theme.dart';
import 'package:noa/widgets/noa_card.dart';

class UpliftStack extends StatefulWidget {
  const UpliftStack({super.key});

  @override
  State<UpliftStack> createState() => _UpliftStackState();
}

class _UpliftStackState extends State<UpliftStack> {
  // TODO: Load jokes from mock/jokes.json
  final List<String> _jokes = [
    "Why don't scientists trust atoms? Because they make up everything!",
    "I'm reading a book on anti-gravity. It's impossible to put down!",
    "What do you call a fake noodle? An Impasta.",
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: NoaCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _jokes[_currentIndex],
              style: NoaTheme.h3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: NoaTheme.spacing32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    // TODO: Implement favorite
                  },
                  icon: const Icon(Icons.favorite_border),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Implement share
                  },
                  icon: const Icon(Icons.share),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
