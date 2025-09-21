import 'dart:math';
import 'package:flutter/material.dart';
import 'package:noa/theme/noa_theme.dart';
import 'package:noa/widgets/breathing_animation.dart';
import 'package:noa/widgets/primary_button.dart';

class ActivityPlayerScreen extends StatefulWidget {
  const ActivityPlayerScreen({super.key});

  @override
  State<ActivityPlayerScreen> createState() => _ActivityPlayerScreenState();
}

class _ActivityPlayerScreenState extends State<ActivityPlayerScreen> with TickerProviderStateMixin {
  late AnimationController _timerController;
  late AnimationController _completionController;
  bool _isCompleting = false;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Mocked duration
    )..forward();

    _completionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _timerController.dispose();
    _completionController.dispose();
    super.dispose();
  }

  void _handleComplete() {
    setState(() {
      _isCompleting = true;
    });
    _completionController.forward().then((_) {
      // TODO: Save to mood history
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activity saved to your journal!')),
      );
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [NoaTheme.background, Color(0xFFFFF4EC)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            _buildAnimationContent(),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(NoaTheme.spacing32),
              child: PrimaryButton(
                onPressed: _handleComplete,
                text: 'Complete',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationContent() {
    if (_isCompleting) {
      return FadeTransition(
        opacity: _completionController,
        child: Column(
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: CustomPaint(
                painter: ConfettiPainter(animation: _completionController),
              ),
            ),
            const SizedBox(height: NoaTheme.spacing16),
            Text(
              'Nice - you did it.',
              style: NoaTheme.h2.copyWith(color: NoaTheme.textPrimary),
            ),
          ],
        ),
      );
    } else {
      return AnimatedBuilder(
        animation: _timerController,
        builder: (context, child) {
          return CustomPaint(
            painter: CircularTimerPainter(
              progress: _timerController.value,
              progressColor: NoaTheme.primary,
              backgroundColor: NoaTheme.neutralSurface,
            ),
            child: const BreathingAnimation(),
          );
        },
      );
    }
  }
}

class ConfettiPainter extends CustomPainter {
  final Animation<double> animation;
  final List<ConfettiParticle> particles;
  final Random _random = Random();

  ConfettiPainter({required this.animation})
      : particles = List.generate(30, (index) => ConfettiParticle(random: _random)),
        super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (var particle in particles) {
      particle.update(animation.value);
      final paint = Paint()..color = particle.color.withOpacity(1.0 - animation.value);
      canvas.drawCircle(center + particle.position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) => true;
}

class ConfettiParticle {
  final Random random;
  late double x, y, vx, vy;
  late Color color;
  late double size;
  final double initialVelocity;

  ConfettiParticle({required this.random}) {
    final angle = random.nextDouble() * 2 * pi;
    initialVelocity = 50 + random.nextDouble() * 50;
    x = 0;
    y = 0;
    vx = cos(angle) * initialVelocity;
    vy = sin(angle) * initialVelocity;
    color = [NoaTheme.primary, NoaTheme.secondary, NoaTheme.success].elementAt(random.nextInt(3));
    size = 2 + random.nextDouble() * 4;
  }

  void update(double t) {
    // Simple physics: initial burst, then fall
    final double gravity = 150.0;
    x = vx * t;
    y = vy * t + 0.5 * gravity * t * t;
  }
}


class CircularTimerPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;

  CircularTimerPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) + 20;
    const strokeWidth = 8.0;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CircularTimerPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
