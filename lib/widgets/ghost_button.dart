import 'package:flutter/material.dart';
import 'package:noa/theme/noa_theme.dart';
import 'package:noa/widgets/primary_button.dart'; // To reuse ButtonSize

class GhostButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final ButtonSize size;

  const GhostButton({
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
        return NoaTheme.small.copyWith(color: NoaTheme.textPrimary, fontWeight: FontWeight.bold);
      case ButtonSize.normal:
        return NoaTheme.body.copyWith(color: NoaTheme.textPrimary, fontWeight: FontWeight.bold);
      case ButtonSize.large:
        return NoaTheme.h3.copyWith(color: NoaTheme.textPrimary, fontWeight: FontWeight.bold);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: NoaTheme.textPrimary,
        disabledForegroundColor: NoaTheme.mutedText,
        padding: EdgeInsets.symmetric(
          vertical: _getVerticalPadding(),
          horizontal: _getHorizontalPadding(),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NoaTheme.buttonRadius),
        ),
      ),
      child: Text(
        text,
        style: _getTextStyle(),
      ),
    );
  }
}
