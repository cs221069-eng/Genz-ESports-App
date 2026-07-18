import 'package:flutter/material.dart';

import '../models/onboarding_page_model.dart';

class OnboardingController extends ChangeNotifier {
  OnboardingController()
      : pageController = PageController(),
        pages = const [
          OnboardingPageModel(
            title: 'Welcome to GenZ eSports',
            subtitle: 'Your tournament management app',
            icon: Icons.emoji_events_rounded,
            gradientColors: [Color(0xFFEAF6FF), Color(0xFFD6E9FF)],
            cardColor: Color(0xFFFFFFFF),
            iconBackgroundColor: Color(0x142D8CFF),
            iconColor: Color(0xFF17B7FF),
          ),
          OnboardingPageModel(
            title: 'Create & Join Tournaments',
            subtitle: 'Easily manage and participate in matches',
            icon: Icons.workspace_premium_rounded,
            gradientColors: [Color(0xFFE9F7FF), Color(0xFFCCE5FF)],
            cardColor: Color(0xFFF7FBFF),
            iconBackgroundColor: Color(0xFFECF5FF),
            iconColor: Color(0xFF17B7FF),
          ),
          OnboardingPageModel(
            title: 'Get Started',
            subtitle:
                'Let\'s begin your journey into the world of professional eSports competition by signing in to your account.',
            icon: Icons.rocket_launch_rounded,
            gradientColors: [Color(0xFFF0F7FF), Color(0xFFD8EBFF)],
            cardColor: Color(0xFFFFFFFF),
            iconBackgroundColor: Color(0x1A17B7FF),
            iconColor: Color(0xFF17B7FF),
          ),
        ];

  final PageController pageController;
  final List<OnboardingPageModel> pages;

  int currentPage = 0;

  bool get isLastPage => currentPage == pages.length - 1;

  void onPageChanged(int index) {
    if (currentPage == index) return;
    currentPage = index;
    notifyListeners();
  }

  Future<void> nextPage() async {
    if (isLastPage) return;
    await pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> skipToEnd() async {
    if (isLastPage) return;
    await pageController.animateToPage(
      pages.length - 1,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
