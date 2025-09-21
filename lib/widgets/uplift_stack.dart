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
  bool _isLoading = true;
  Offset _dragPosition = Offset.zero;
  double _angle = 0;
  int _currentIndex = 0;

  late AnimationController _cardAnimationController;
  late Animation<Offset> _cardAnimation;

  // For heart animation
  final Map<int, bool> _favoritedJokes = {};
  late AnimationController _heartAnimationController;
  late Animation<double> _heartAnimation;

  @override
  void initState() {
    super.initState();
    _loadJokes();
    _cardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    )..addListener(() {
        setState(() {
          _dragPosition = _cardAnimation.value;
          _angle = _dragPosition.dx / 300;
        });
      });

    _heartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _heartAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _heartAnimationController, curve: Curves.elasticOut)
    );
  }

  Future<void> _loadJokes() async {
    final jsonString = await rootBundle.loadString('mock/jokes.json');
    final jsonResponse = json.decode(jsonString) as List;
    if (mounted) {
      setState(() {
        _jokes = jsonResponse.map((e) => e['text'] as String).toList();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    _heartAnimationController.dispose();
    super.dispose();
  }

  void _runSwipeAnimation() {
    final screenWidth = MediaQuery.of(context).size.width;
    final endPosition = Offset(screenWidth * _dragPosition.dx.sign, _dragPosition.dy);
    _cardAnimation = Tween<Offset>(begin: _dragPosition, end: endPosition)
        .animate(CurvedAnimation(parent: _cardAnimationController, curve: Curves.easeOut));

    _cardAnimationController.forward().then((_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _jokes.length;
        _dragPosition = Offset.zero;
        _angle = 0;
        _cardAnimationController.reset();
      });
    });
  }

  void _runBounceBackAnimation() {
     _cardAnimation = Tween<Offset>(begin: _dragPosition, end: Offset.zero)
        .animate(CurvedAnimation(parent: _cardAnimationController, curve: Curves.elasticOut));
    _cardAnimationController.forward().then((_) {
      setState(() {
        _dragPosition = Offset.zero;
        _angle = 0;
        _cardAnimationController.reset();
      });
    });
  }

  Widget _buildCard(int index) {
    final isTopCard = index == _currentIndex;
    final dragPercent = _dragPosition.dx.abs() / (MediaQuery.of(context).size.width / 2);

    final scale = isTopCard ? 1.0 : max(0.9, 1.0 - (index - _currentIndex) * 0.05 + (isTopCard ? 0 : dragPercent * 0.05));
    final offset = isTopCard ? _dragPosition : Offset(0, -10.0 * (index - _currentIndex) + (isTopCard ? 0 : dragPercent * 10));

    final isFavorited = _favoritedJokes[index] ?? false;

    return Transform.translate(
      offset: offset,
      child: Transform.scale(
        scale: scale,
        child: Transform.rotate(
          angle: isTopCard ? _angle : 0,
          child: NoaCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _jokes[index],
                  style: NoaTheme.h3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: NoaTheme.spacing32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: isTopCard ? _heartAnimation : const AlwaysStoppedAnimation(1.0),
                      child: IconButton(
                        iconSize: 32,
                        onPressed: () {
                           if (!isTopCard) return;
                           setState(() {
                             _favoritedJokes[index] = !isFavorited;
                           });
                           _heartAnimationController.forward(from: 0.0);
                        },
                        icon: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: isFavorited ? Colors.redAccent : NoaTheme.mutedText,
                        ),
                      ),
                    ),
                    IconButton(
                      iconSize: 32,
                      onPressed: () {
                        // TODO: Implement share
                      },
                      icon: const Icon(Icons.share, color: NoaTheme.mutedText),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: GestureDetector(
        onPanStart: (details) {
          _cardAnimationController.stop();
        },
        onPanUpdate: (details) {
          setState(() {
            _dragPosition += details.delta;
            _angle = _dragPosition.dx / 300;
          });
        },
        onPanEnd: (details) {
          if (_dragPosition.dx.abs() > 100) {
            _runSwipeAnimation();
          } else {
            _runBounceBackAnimation();
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: List.generate(min(3, _jokes.length - _currentIndex), (index) {
            final jokeIndex = (_currentIndex + index) % _jokes.length;
            return _buildCard(jokeIndex);
          }).reversed.toList(),
        ),
      ),
    );
  }
}
