import 'package:flutter/material.dart';

class OnboardingPageModel {
  const OnboardingPageModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.cardColor,
    required this.iconBackgroundColor,
    required this.iconColor,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final Color cardColor;
  final Color iconBackgroundColor;
  final Color iconColor;
}
