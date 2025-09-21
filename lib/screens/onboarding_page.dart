import 'package:flutter/material.dart';
import 'package:noa/services/microcopy_service.dart';
import 'package:noa/theme/noa_theme.dart';
import 'package:noa/widgets/primary_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  double _currentPage = 0.0;
  final MicrocopyService _microcopyService = MicrocopyService();
  bool _microcopyLoaded = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });
    _loadMicrocopy();
  }

  Future<void> _loadMicrocopy() async {
    await _microcopyService.load();
    setState(() {
      _microcopyLoaded = true;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_microcopyLoaded) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          _buildSlide1(),
          _buildSlide2(),
          _buildSlide3(),
        ],
      ),
    );
  }

  Widget _buildSlide1() {
    // TODO: Add illustration with parallax effect
    return Container(
      padding: const EdgeInsets.all(NoaTheme.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text('Noa', style: NoaTheme.h1),
          const SizedBox(height: NoaTheme.spacing16),
          Text(
            _microcopyService.get('onboarding_headline'),
            style: NoaTheme.body,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          PrimaryButton(
            onPressed: () {
              _pageController.nextPage(
                duration: NoaMotion.standardTransition,
                curve: NoaMotion.standardTransitionCurve,
              );
            },
            text: 'Get started',
          ),
        ],
      ),
    );
  }

  Widget _buildSlide2() {
    // TODO: Add icons and stagger animation
    return Container(
      padding: const EdgeInsets.all(NoaTheme.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text('Key Features', style: NoaTheme.h2),
          const SizedBox(height: NoaTheme.spacing32),
          _buildFeature('Chat', 'Talk through your feelings anytime.'),
          const SizedBox(height: NoaTheme.spacing16),
          _buildFeature('Short activities', 'Quick exercises to find calm.'),
          const SizedBox(height: NoaTheme.spacing16),
          _buildFeature('Nudges', 'Gentle reminders to check in.'),
          const Spacer(),
          PrimaryButton(
            onPressed: () {
              _pageController.nextPage(
                duration: NoaMotion.standardTransition,
                curve: NoaMotion.standardTransitionCurve,
              );
            },
            text: 'Next',
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(String title, String description) {
    return Row(
      children: [
        const Icon(Icons.check_circle_outline, color: NoaTheme.primary),
        const SizedBox(width: NoaTheme.spacing16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: NoaTheme.body.copyWith(fontWeight: FontWeight.bold)),
              Text(description, style: NoaTheme.small),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSlide3() {
    // TODO: Implement state management for the toggle
    // TODO: Implement saving to local storage
    return Container(
      padding: const EdgeInsets.all(NoaTheme.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text('Privacy First', style: NoaTheme.h2),
          const SizedBox(height: NoaTheme.spacing16),
          const Text(
            'Noa is designed to be a private space. Your data stays on your device by default.',
            style: NoaTheme.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: NoaTheme.spacing32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Enable cloud backup', style: NoaTheme.body),
              Switch(value: false, onChanged: (value) {
                // TODO: Handle state change
              }),
            ],
          ),
          const Spacer(),
          PrimaryButton(
            onPressed: () {
              // TODO: Save preference and navigate to home screen
              // For now, just print to console
              print('Onboarding complete');
            },
            text: 'Continue - local only',
          ),
        ],
      ),
    );
  }
}
