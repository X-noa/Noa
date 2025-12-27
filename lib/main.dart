import 'package:flutter/material.dart';
import 'package:noa/screens/onboarding_page.dart';
import 'package:noa/theme/noa_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noa',
      theme: NoaTheme.themeData,
      home: const OnboardingPage(),
    );
  }
}
