import 'package:flutter/material.dart';
import 'package:noa/theme/noa_theme.dart';

class NoaCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? width;

  const NoaCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin ?? const EdgeInsets.all(NoaTheme.spacing16),
      padding: padding ?? const EdgeInsets.all(NoaTheme.spacing16),
      decoration: BoxDecoration(
        color: color ?? NoaTheme.background,
        borderRadius: BorderRadius.circular(NoaTheme.cardRadius),
        boxShadow: [NoaTheme.cardShadow],
      ),
      child: child,
    );
  }
}
