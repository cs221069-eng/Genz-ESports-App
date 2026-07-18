import 'dart:ui';
import 'package:flutter/material.dart';

class NeumorphicBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const NeumorphicBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _icons = [
    Icons.home_rounded,
    Icons.sports_esports_rounded,
    Icons.live_tv_rounded,
    Icons.store_rounded,
    Icons.person_rounded,
  ];

  static const _labels = [
    'Home',
    'Tournaments',
    'Live',
    'Shop',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0x1A17B7FF),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0x33FFFFFF)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x30000000),
                    blurRadius: 32,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_icons.length, (i) {
                  final selected = currentIndex == i;

                  return GestureDetector(
                    onTap: () => onTap(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0x3D17B7FF) // Translucent primary blue
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFF17B7FF) // Glowing border
                              : Colors.transparent,
                          width: 1.2,
                        ),
                        boxShadow: selected
                            ? const [
                                BoxShadow(
                                  color: Color(0x2B17B7FF),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _icons[i],
                            color: selected
                                ? const Color(0xFFECF7FF)
                                : const Color(0xFF6B91B5),
                            size: 22,
                          ),
                          if (selected) ...[
                            const SizedBox(width: 6),
                            Text(
                              _labels[i],
                              style: const TextStyle(
                                color: Color(0xFFECF7FF),
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}