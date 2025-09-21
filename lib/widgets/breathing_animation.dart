import 'package:flutter/material.dart';
import 'dart:math';
import 'package:noa/theme/noa_theme.dart';

class BreathingAnimation extends StatefulWidget {
  const BreathingAnimation({super.key});

  @override
  State<BreathingAnimation> createState() => _BreathingAnimationState();
}

class _BreathingAnimationState extends State<BreathingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _radiusAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _radiusAnimation = Tween<double>(begin: 40, end: 100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: NoaTheme.primary,
      end: NoaTheme.secondary,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: _radiusAnimation.value * 2,
          height: _radiusAnimation.value * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _colorAnimation.value,
          ),
          child: Center(
            child: Text(
              _controller.status == AnimationStatus.forward ? 'Inhale' : 'Exhale',
              style: NoaTheme.body.copyWith(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
