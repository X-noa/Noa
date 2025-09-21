import 'package:flutter/material.dart';
import 'package:noa/theme/noa_theme.dart';

class BreathingAnimation extends StatefulWidget {
  const BreathingAnimation({super.key});

  @override
  State<BreathingAnimation> createState() => _BreathingAnimationState();
}

class _BreathingAnimationState extends State<BreathingAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<Color?> _colorAnimation;
  String _breathStateText = 'Inhale';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    final curvedAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _sizeAnimation = Tween<double>(begin: 150, end: 250).animate(curvedAnimation);

    _colorAnimation = ColorTween(
      begin: NoaTheme.primary,
      end: NoaTheme.secondary,
    ).animate(curvedAnimation);

    _controller.addStatusListener((status) {
      if (!mounted) return;
      if (status == AnimationStatus.forward) {
        setState(() => _breathStateText = 'Inhale');
      } else if (status == AnimationStatus.reverse) {
        setState(() => _breathStateText = 'Exhale');
      }
    });
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
          width: _sizeAnimation.value,
          height: _sizeAnimation.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _colorAnimation.value,
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Text(
                _breathStateText,
                key: ValueKey<String>(_breathStateText),
                style: NoaTheme.h3.copyWith(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
