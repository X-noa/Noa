import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noa/theme/noa_theme.dart';
import 'package:noa/widgets/noa_card.dart';

class UpliftStack extends StatefulWidget {
  const UpliftStack({super.key});

  @override
  State<UpliftStack> createState() => _UpliftStackState();
}

class _UpliftStackState extends State<UpliftStack> {
  List<String> _jokes = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJokes();
  }

  Future<void> _loadJokes() async {
    final jsonString = await rootBundle.loadString('mock/jokes.json');
    final jsonResponse = json.decode(jsonString) as List;
    setState(() {
      _jokes = jsonResponse.map((e) => e['text'] as String).toList();
      _isLoading = false;
    });
  }

  void _nextJoke() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _jokes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: GestureDetector(
        onTap: _nextJoke,
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
      ),
    );
  }
}
