import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:noa/theme/noa_theme.dart';

Future<T?> showNoaModal<T>(BuildContext context, {required Widget child}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withOpacity(0.4),
    transitionDuration: NoaMotion.standardTransition,
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      );

      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 8 * curvedAnimation.value,
          sigmaY: 8 * curvedAnimation.value,
        ),
        child: FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        ),
      );
    },
  );
}
