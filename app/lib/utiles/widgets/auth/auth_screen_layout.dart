import 'package:flutter/material.dart';

import '../glass/glass_kit.dart';

/// Shared shell for auth screens so login and signup keep the same layout behavior.
/// The page body is composed from reusable glass UI and a consistent scrollable flow.
class AuthScreenLayout extends StatelessWidget {
  const AuthScreenLayout({
    super.key,
    this.appBar,
    this.hero,
    required this.content,
    this.bottomContent,
    this.maxWidth = 440,
    this.contentPadding = const EdgeInsets.fromLTRB(24, 8, 24, 32),
    this.bottomPadding = const EdgeInsets.fromLTRB(24, 0, 24, 28),
  });

  final Widget? appBar;
  final Widget? hero;
  final Widget content;
  final Widget? bottomContent;
  final double maxWidth;
  final EdgeInsets contentPadding;
  final EdgeInsets bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground(
        child: SafeArea(
          child: Column(
            children: [
              if (appBar != null) appBar!,
              Expanded(
                child: SingleChildScrollView(
                  padding: contentPadding,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (hero != null) ...[
                            hero!,
                            const SizedBox(height: 24),
                          ],
                          content,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (bottomContent != null)
                Padding(
                  padding: bottomPadding,
                  child: bottomContent,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
