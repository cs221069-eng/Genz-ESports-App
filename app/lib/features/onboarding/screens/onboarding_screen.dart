import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../theme/neumorphic_theme.dart';
import '../../../utiles/widgets/glass/glass_kit.dart';
import '../../authention/screens/sign_in_screen.dart';
import '../controller/onboarding_controller.dart';
import '../models/onboarding_page_model.dart';

/// Screen representing the initial onboarding walk-through slides for new users.
/// Integrates global premium glassmorphic backgrounds and badges.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const String seenKey = 'onboarding.seen';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final OnboardingController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller and register listener to update UI on page changes
    _controller = OnboardingController()..addListener(_handleControllerUpdate);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleControllerUpdate)
      ..dispose();
    super.dispose();
  }

  void _handleControllerUpdate() {
    if (mounted) setState(() {});
  }

  /// Saves onboarding state seen flag in SharedPreferences and routes to SignInScreen
  Future<void> _goToSignIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(OnboardingScreen.seenKey, true);
    } catch (error) {
      debugPrint('Unable to save onboarding state: $error');
    }
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // Root widget implements premium radial glow background
      body: GlassBackground(
        child: SafeArea(
          child: Column(
            children: [
              // ── Header Row ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  children: [
                    GlassBadge(
                      child: Icon(
                        Icons.sports_esports_rounded,
                        color: theme.primaryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'GenZ eSports',
                      style: theme.textTheme.titleMedium,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _controller.skipToEnd,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: kTextMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Slider Page View ──────────────────────────────────────────
              Expanded(
                child: PageView.builder(
                  controller: _controller.pageController,
                  onPageChanged: _controller.onPageChanged,
                  itemCount: _controller.pages.length,
                  itemBuilder: (context, index) {
                    return _OnboardingPage(
                      page: _controller.pages[index],
                      isFinalPage: index == _controller.pages.length - 1,
                      screenWidth: size.width,
                    );
                  },
                ),
              ),

              // ── Footer Control Actions ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Uses global animated glass indicator dots
                    GlassPageIndicator(
                      count: _controller.pages.length,
                      currentIndex: _controller.currentPage,
                    ),
                    const SizedBox(height: 24),
                    
                    // CTA Button - Get Started / Continue
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton.icon(
                        onPressed: _controller.isLastPage ? _goToSignIn : _controller.nextPage,
                        icon: Icon(
                          _controller.isLastPage
                              ? Icons.check_circle_outline_rounded
                              : Icons.arrow_forward_rounded,
                          size: 20,
                        ),
                        label: Text(_controller.isLastPage ? 'Get Started' : 'Continue'),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    if (_controller.isLastPage) ...[
                      const SizedBox(height: 14),
                      TextButton(
                        onPressed: _goToSignIn,
                        child: const Text(
                          'Skip for now',
                          style: TextStyle(
                            color: kTextMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper sub-widget displaying a single slide information
class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.page,
    required this.isFinalPage,
    required this.screenWidth,
  });

  final OnboardingPageModel page;
  final bool isFinalPage;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    final iconSize = isFinalPage ? 72.0 : 88.0;
    final cardSize = screenWidth * 0.78;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Glass Illustration Panel card
          ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                width: cardSize,
                height: cardSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: page.gradientColors,
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: page.gradientColors.last.withValues(alpha: 0.30),
                      blurRadius: 48,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: -30,
                      right: -30,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: Container(
                          width: iconSize + 40,
                          height: iconSize + 40,
                          decoration: BoxDecoration(
                            color: page.iconBackgroundColor
                                .withValues(alpha: 0.30),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Icon(
                            page.icon,
                            size: iconSize,
                            color: page.iconColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 44),

          // Slide Title & Description Text
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: Column(
              children: [
                Text(
                  page.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 14),
                Text(
                  page.subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
