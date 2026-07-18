import 'dart:ui';
import 'package:flutter/material.dart';

class HomeHeroBanner extends StatelessWidget {
  final String title;

  const HomeHeroBanner({
    super.key,
    this.title = 'Play harder.\nClimb smarter.',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;

    return SizedBox(
      width: double.infinity, // ✅ FULL WIDTH FIX
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            height: 260,
            width: double.infinity, // ✅ ensure full width inside
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                colors: [
                  primary.withOpacity(0.24),
                  primary.withOpacity(0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.white.withOpacity(0.22)),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.12),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Stack(
              children: [
                // ── Decorative glows ─────────────────────────────
                Positioned(
                  right: -40,
                  top: -48,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.04),
                    ),
                  ),
                ),
                Positioned(
                  left: -20,
                  bottom: -60,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.03),
                    ),
                  ),
                ),

                // ── Trophy card ────────────────────────────────
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: Transform.rotate(
                    angle: -0.12,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          width: 88,
                          height: 110,
                          decoration: BoxDecoration(
                            color: const Color(0x2B17B7FF),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: const Color(0x5517B7FF),
                            ),
                          ),
                          child: const Icon(
                            Icons.emoji_events_rounded,
                            color: Colors.white,
                            size: 46,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── TEXT ────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0x3D17B7FF),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: const Color(0x6617B7FF),
                              ),
                            ),
                            child: const Text(
                              'LIVE SEASON',
                              style: TextStyle(
                                color: Color(0xFFECF7FF),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      Text(
                        title,
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 34,
                          height: 1.05,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: 300, // 🔥 slightly wider for full width layout
                        child: Text(
                          'Track live brackets, jump into weekend cups, and keep your squad tournament-ready.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.88),
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}