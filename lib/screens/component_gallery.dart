import 'package:flutter/material.dart';
import 'package:noa/theme/noa_theme.dart';
import 'package:noa/widgets/ghost_button.dart';
import 'package:noa/widgets/noa_app_bar.dart';
import 'package:noa/widgets/noa_card.dart';
import 'package:noa/widgets/primary_button.dart';

class ComponentGallery extends StatelessWidget {
  const ComponentGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NoaAppBar(
        title: 'Component Gallery',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(NoaTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Typography', style: NoaTheme.h1),
            const Divider(),
            const Text('Headline 1', style: NoaTheme.h1),
            const Text('Headline 2', style: NoaTheme.h2),
            const Text('Headline 3', style: NoaTheme.h3),
            const Text('Body Text', style: NoaTheme.body),
            const Text('Small Text', style: NoaTheme.small),
            const SizedBox(height: NoaTheme.spacing32),

            const Text('Buttons', style: NoaTheme.h1),
            const Divider(),
            const SizedBox(height: NoaTheme.spacing16),
            const Text('Primary Buttons', style: NoaTheme.h3),
            const SizedBox(height: NoaTheme.spacing8),
            const PrimaryButton(onPressed: null, text: 'Disabled'),
            const SizedBox(height: NoaTheme.spacing8),
            PrimaryButton(onPressed: () {}, text: 'Small', size: ButtonSize.small),
            const SizedBox(height: NoaTheme.spacing8),
            PrimaryButton(onPressed: () {}, text: 'Normal', size: ButtonSize.normal),
            const SizedBox(height: NoaTheme.spacing8),
            PrimaryButton(onPressed: () {}, text: 'Large', size: ButtonSize.large),
            const SizedBox(height: NoaTheme.spacing16),

            const Text('Ghost Buttons', style: NoaTheme.h3),
            const SizedBox(height: NoaTheme.spacing8),
            const GhostButton(onPressed: null, text: 'Disabled'),
            const SizedBox(height: NoaTheme.spacing8),
            GhostButton(onPressed: () {}, text: 'Small', size: ButtonSize.small),
            const SizedBox(height: NoaTheme.spacing8),
            GhostButton(onPressed: () {}, text: 'Normal', size: ButtonSize.normal),
            const SizedBox(height: NoaTheme.spacing8),
            GhostButton(onPressed: () {}, text: 'Large', size: ButtonSize.large),
            const SizedBox(height: NoaTheme.spacing32),

            const Text('Cards', style: NoaTheme.h1),
            const Divider(),
            NoaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('This is a NoaCard', style: NoaTheme.h3),
                  const SizedBox(height: NoaTheme.spacing8),
                  const Text(
                    'It has the default background, padding, margin, and shadow.',
                    style: NoaTheme.body,
                  ),
                  const SizedBox(height: NoaTheme.spacing16),
                  PrimaryButton(onPressed: () {}, text: 'Action')
                ],
              ),
            ),
            NoaCard(
              color: NoaTheme.neutralSurface,
              child: const Text('This is a card with a different color.', style: NoaTheme.body),
            ),
          ],
        ),
      ),
    );
  }
}
