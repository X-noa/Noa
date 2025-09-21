import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noa/theme/noa_theme.dart';
import 'package:noa/widgets/noa_card.dart';

class UpliftStack extends StatefulWidget {
  const UpliftStack({super.key});

  @override
  State<UpliftStack> createState() => _UpliftStackState();
}

class _UpliftStackState extends State<UpliftStack> with TickerProviderStateMixin {
  List<String> _jokes = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _animation;
  Offset _dragPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _loadJokes();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
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
      _animationController.reset();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: GestureDetector(
        onPanStart: (details) {
          _animationController.stop();
        },
        onPanUpdate: (details) {
          setState(() {
            _dragPosition += details.delta;
          });
        },
        onPanEnd: (details) {
          if (_dragPosition.dx.abs() > 100) {
            _animationController.forward().then((_) => _nextJoke());
          } else {
            setState(() {
              _dragPosition = Offset.zero;
            });
          }
        },
        child: Transform.translate(
          offset: _dragPosition,
          child: Transform.rotate(
            angle: _dragPosition.dx / 300,
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
        ),
      ),
    );
  }
}
