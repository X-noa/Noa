import 'package:flutter/material.dart';
import 'package:noa/widgets/noa_app_bar.dart';
import 'package:noa/widgets/uplift_stack.dart';

class UpliftScreen extends StatelessWidget {
  const UpliftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: NoaAppBar(
        title: 'A little something for you',
      ),
      body: UpliftStack(),
    );
  }
}
