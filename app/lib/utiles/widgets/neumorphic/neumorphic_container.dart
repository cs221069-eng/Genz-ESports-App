// NeumorphicContainer is now a glassmorphism card — all existing code that
// imports this widget gets the glass upgrade automatically.
export '../glass/glass_kit.dart' show GlassCard;

import 'dart:ui';
import 'package:flutter/material.dart';

class NeumorphicContainer extends StatelessWidget {
  const NeumorphicContainer({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.padding,
    this.margin,
    this.inset = false,
    this.color,
    this.blur = 14.0,
  });

  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool inset;
  final Color? color;
  final double blur;

  @override
  Widget build(BuildContext context) {
    // Derive tint: if a color is provided use it at 12% opacity, else 10% primary.
    final Color tint;
    if (color != null) {
      final c = color!;
      tint = Color.fromRGBO(
        (c.r * 255.0).round() & 0xff,
        (c.g * 255.0).round() & 0xff,
        (c.b * 255.0).round() & 0xff,
        0.12,
      );
    } else {
      tint = const Color(0x1A17B7FF);
    }

    const borderColor = Color(0x33FFFFFF);
    const shadow = Color(0x28000000);

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: borderColor, width: 1.0),
              boxShadow: inset
                  ? null
                  : const [
                      BoxShadow(
                        color: shadow,
                        blurRadius: 24,
                        offset: Offset(0, 8),
                      ),
                    ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
