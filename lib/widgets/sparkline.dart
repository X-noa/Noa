import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:noa/theme/noa_theme.dart';

// Mock data structure, assuming mood is 1-5
class MoodEntry {
  final DateTime date;
  final double mood;
  MoodEntry({required this.date, required this.mood});
}

class Sparkline extends StatefulWidget {
  final List<MoodEntry> data;
  final Function(MoodEntry?) onEntrySelected;

  const Sparkline({super.key, required this.data, required this.onEntrySelected});

  @override
  State<Sparkline> createState() => _SparklineState();
}

class _SparklineState extends State<Sparkline> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        // This is a simplified hit test. A real implementation would be more robust.
        final RenderBox box = context.findRenderObject() as RenderBox;
        final dx = details.localPosition.dx;
        final pointWidth = box.size.width / (widget.data.length - 1);
        final index = (dx / pointWidth).round();

        if (index >= 0 && index < widget.data.length) {
          setState(() {
            _selectedIndex = index;
          });
          widget.onEntrySelected(widget.data[index]);
        }
      },
      child: CustomPaint(
        size: const Size(double.infinity, 200),
        painter: SparklinePainter(
          data: widget.data,
          selectedIndex: _selectedIndex,
        ),
      ),
    );
  }
}

class SparklinePainter extends CustomPainter {
  final List<MoodEntry> data;
  final int? selectedIndex;

  SparklinePainter({required this.data, this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = NoaTheme.primary.withOpacity(0.5)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final pointWidth = size.width / (data.length - 1);

    // Map mood (1-5) to y-coordinate
    double getY(double mood) {
      // Invert y-axis and add padding
      return size.height - ((mood / 5.0) * (size.height * 0.8) + (size.height * 0.1));
    }

    path.moveTo(0, getY(data.first.mood));
    for (int i = 1; i < data.length; i++) {
      path.lineTo(i * pointWidth, getY(data[i].mood));
    }
    canvas.drawPath(path, paint);

    // Draw points
    for (int i = 0; i < data.length; i++) {
      final x = i * pointWidth;
      final y = getY(data[i]);
      final isSelected = i == selectedIndex;

      final pointPaint = Paint()
        ..color = isSelected ? NoaTheme.primary : NoaTheme.secondary;

      final innerRadius = isSelected ? 6.0 : 4.0;
      final outerRadius = isSelected ? 10.0 : 0.0;

      if (isSelected) {
         canvas.drawCircle(Offset(x,y), outerRadius, Paint()..color = NoaTheme.primary.withOpacity(0.2));
      }
      canvas.drawCircle(Offset(x, y), innerRadius, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SparklinePainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex || oldDelegate.data != data;
  }
}
