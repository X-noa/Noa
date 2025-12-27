import 'package:flutter/material.dart';
import 'package:noa/theme/noa_theme.dart';

class NoaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;

  const NoaAppBar({
    super.key,
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: NoaTheme.h3,
            )
          : null,
      backgroundColor: NoaTheme.background,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: NoaTheme.neutralSurface,
      actions: actions,
      iconTheme: const IconThemeData(color: NoaTheme.textPrimary),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
