import 'package:flutter/material.dart';
import 'package:noa/theme/noa_theme.dart';

enum ButtonSize { small, normal, large }

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final ButtonSize size;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.size = ButtonSize.normal,
  });

  double _getVerticalPadding() {
    switch (size) {
      case ButtonSize.small:
        return NoaTheme.spacing8;
      case ButtonSize.normal:
        return NoaTheme.spacing12;
      case ButtonSize.large:
        return NoaTheme.spacing16;
    }
  }

  double _getHorizontalPadding() {
    switch (size) {
      case ButtonSize.small:
        return NoaTheme.spacing16;
      case ButtonSize.normal:
        return NoaTheme.spacing24;
      case ButtonSize.large:
        return NoaTheme.spacing32;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return NoaTheme.small.copyWith(color: Colors.white, fontWeight: FontWeight.bold);
      case ButtonSize.normal:
        return NoaTheme.body.copyWith(color: Colors.white, fontWeight: FontWeight.bold);
      case ButtonSize.large:
        return NoaTheme.h3.copyWith(color: Colors.white, fontWeight: FontWeight.bold);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: NoaTheme.primary,
        disabledBackgroundColor: NoaTheme.primary.withOpacity(0.5),
        padding: EdgeInsets.symmetric(
          vertical: _getVerticalPadding(),
          horizontal: _getHorizontalPadding(),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NoaTheme.buttonRadius),
        ),
        elevation: 0,
      ),
      child: Text(
        text,
        style: _getTextStyle(),
      ),
    );
  }
}
