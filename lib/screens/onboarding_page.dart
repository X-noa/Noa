import 'package:flutter/material.dart';
import 'package:noa/services/microcopy_service.dart';
import 'package:noa/theme/noa_theme.dart';
import 'package:noa/widgets/primary_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  double _currentPage = 0.0;
  final MicrocopyService _microcopyService = MicrocopyService();
  bool _microcopyLoaded = false;
  bool _cloudBackupEnabled = false;
  late AnimationController _bounceController;
  late AnimationController _slide2AnimationController;
  late Animation<double> _feature1Animation;
  late Animation<double> _feature2Animation;
  late Animation<double> _feature3Animation;
  late Animation<double> _slide2TitleAnimation;
  late Animation<double> _slide2ButtonAnimation;


  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page ?? 0;
      setState(() {
        _currentPage = page;
      });
      if (page.round() == 1) {
        _slide2AnimationController.forward();
      } else {
        _slide2AnimationController.reset();
      }
    });
    _loadMicrocopy();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    const slide2Duration = Duration(milliseconds: 700);
    _slide2AnimationController = AnimationController(vsync: this, duration: slide2Duration);

    _slide2TitleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _slide2AnimationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _feature1Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _slide2AnimationController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );
     _feature2Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _slide2AnimationController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut), // 60ms stagger
      ),
    );
     _feature3Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _slide2AnimationController,
        curve: const Interval(0.4, 0.9, curve: Curves.easeOut), // 60ms stagger
      ),
    );

    _slide2ButtonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _slide2AnimationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
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
    _bounceController.dispose();
    _slide2AnimationController.dispose();
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
    final parallaxOffset = _currentPage * 12.0;
    return Container(
      padding: const EdgeInsets.all(NoaTheme.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Transform.translate(
            offset: Offset(-parallaxOffset, 0),
            child: const Icon(Icons.wb_sunny, size: 100, color: NoaTheme.secondary),
          ),
          const SizedBox(height: NoaTheme.spacing48),
          AnimatedOpacity(
            opacity: _currentPage == 0 ? 1.0 : 0.0,
            duration: NoaMotion.standardTransition,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - (_currentPage == 0 ? 1.0 : 0.0))),
              child: const Text('Noa', style: NoaTheme.h1),
            ),
          ),
          const SizedBox(height: NoaTheme.spacing16),
          AnimatedOpacity(
            opacity: _currentPage == 0 ? 1.0 : 0.0,
            duration: NoaMotion.standardTransition,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - (_currentPage == 0 ? 1.0 : 0.0))),
              child: Text(
                _microcopyService.get('onboarding_headline'),
                style: NoaTheme.body,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Spacer(),
          Transform.scale(
            scale: 1 - _bounceController.value,
            child: PrimaryButton(
              onPressed: () {
                _bounceController.forward().then((_) {
                  _bounceController.reverse();
                  _pageController.nextPage(
                    duration: NoaMotion.standardTransition,
                    curve: NoaMotion.standardTransitionCurve,
                  );
                });
              },
              text: 'Get started',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedFeature({required Animation<double> animation, required String title, required String description}) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - animation.value)),
            child: child,
          ),
        );
      },
      child: _buildFeature(title, description),
    );
  }

  Widget _buildSlide2() {
    return Container(
      padding: const EdgeInsets.all(NoaTheme.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          _buildAnimatedOpacity(
            animation: _slide2TitleAnimation,
            child: const Text('Key Features', style: NoaTheme.h2),
          ),
          const SizedBox(height: NoaTheme.spacing32),
          _buildAnimatedFeature(animation: _feature1Animation, title: 'Chat', description: 'Talk through your feelings anytime.'),
          const SizedBox(height: NoaTheme.spacing16),
          _buildAnimatedFeature(animation: _feature2Animation, title: 'Short activities', description: 'Quick exercises to find calm.'),
          const SizedBox(height: NoaTheme.spacing16),
          _buildAnimatedFeature(animation: _feature3Animation, title: 'Nudges', 'Gentle reminders to check in.'),
          const Spacer(),
          _buildAnimatedOpacity(
            animation: _slide2ButtonAnimation,
            child: PrimaryButton(
              onPressed: () {
                _pageController.nextPage(
                  duration: NoaMotion.standardTransition,
                  curve: NoaMotion.standardTransitionCurve,
                );
              },
              text: 'Next',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedOpacity({required Animation<double> animation, required Widget child}) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Opacity(
          opacity: animation.value,
          child: child,
        );
      },
    );
  }

  Widget _buildFeature(String title, String description) {
    // TODO: Use pill icons
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
    // A simple fade in for the content of slide 3 for consistency.
    final opacity = (_currentPage - 1.0).clamp(0.0, 1.0);

    return Opacity(
      opacity: opacity,
      child: Container(
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
                Switch(
                  value: _cloudBackupEnabled,
                  onChanged: (value) {
                    setState(() {
                      _cloudBackupEnabled = value;
                    });
                  },
                  activeColor: NoaTheme.primary,
                ),
              ],
            ),
            const Spacer(),
            PrimaryButton(
              onPressed: () {
                // TODO: Save preference to local storage
                print('Cloud backup enabled: $_cloudBackupEnabled');
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ));
              },
              text: 'Continue - local only',
            ),
          ],
        ),
      ),
    );
  }
}
