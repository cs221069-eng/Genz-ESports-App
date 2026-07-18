import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:genz_app/theme/neumorphic_theme.dart';

/// A premium glassmorphism container.
/// Wraps child in a blurred, semi-transparent glass card with a subtle border.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.padding,
    this.margin,
    this.color,
    this.borderColor,
    this.blur = 14.0,
    this.opacity = 0.10,
    this.elevation = true,
  });

  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  /// Override the glass tint (default: 10% primary blue).
  final Color? color;
  /// Override the border color (default: 20% white).
  final Color? borderColor;
  final double blur;
  final double opacity;
  /// Whether to show a soft drop shadow beneath the card.
  final bool elevation;

  @override
  Widget build(BuildContext context) {
    final tint = color ?? kPrimaryBlue.withValues(alpha: opacity);
    final border = borderColor ?? const Color(0x33FFFFFF);

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
              border: Border.all(color: border, width: 1.0),
              boxShadow: elevation
                  ? const [
                      BoxShadow(
                        color: Color(0x28000000),
                        blurRadius: 24,
                        offset: Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Color(0x0AFFFFFF),
                        blurRadius: 1,
                        offset: Offset(0, 1),
                        spreadRadius: -1,
                      ),
                    ]
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// A premium full-width glass button.
class GlassButton extends StatefulWidget {
  const GlassButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.isFilled = false,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color foregroundColor;
  /// If true, uses a solid primary-colored background instead of glass.
  final bool isFilled;

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
    )..value = 1.0;
    _scale = _ctrl;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _ctrl.reverse();
  void _onTapUp(_) => _ctrl.forward();
  void _onTapCancel() => _ctrl.forward();

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ??
        (widget.isFilled
            ? kPrimaryBlue
            : kPrimaryBlue.withValues(alpha: 0.13));
    final border = widget.isFilled
        ? Colors.transparent
        : kPrimaryBlue.withValues(alpha: 0.27);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _scale,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(color: border),
                boxShadow: widget.isFilled
                    ? const [
                        BoxShadow(
                          color: Color(0x4417B7FF),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: widget.foregroundColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
                child: Center(child: widget.child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Glass text field — a clean, readable input with a glass appearance.
class GlassTextField extends StatelessWidget {
  const GlassTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.validator,
    this.readOnly = false,
    this.maxLines = 1,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final bool readOnly;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: kTextMuted,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              onChanged: onChanged,
              validator: validator,
              readOnly: readOnly,
              maxLines: obscureText ? 1 : maxLines,
              style: const TextStyle(
                color: kTextHeading,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: kTextSubtle,
                  fontSize: 14,
                ),
                filled: true,
                fillColor: kPrimaryBlue.withValues(alpha: 0.10),
                prefixIcon: prefix,
                suffixIcon: suffix,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: kPrimaryBlue.withValues(alpha: 0.27)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: kPrimaryBlue.withValues(alpha: 0.20)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                      color: kPrimaryBlue, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFBA1A1A)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                      color: Color(0xFFBA1A1A), width: 1.5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Animated page indicator dots.
class GlassPageIndicator extends StatelessWidget {
  const GlassPageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.activeColor = kPrimaryBlue,
  });

  final int count;
  final int currentIndex;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? activeColor : kPrimaryBlue.withValues(alpha: 0.20),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isActive ? activeColor : kPrimaryBlue.withValues(alpha: 0.27),
            ),
          ),
        );
      }),
    );
  }
}

/// A background with radial glow circles that sets the stage for glassmorphism.
class GlassBackground extends StatelessWidget {
  const GlassBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background base color
        const ColoredBox(color: kBackground),
        // Top-left radial glow
        Positioned(
          top: -120,
          left: -80,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kPrimaryBlue.withValues(alpha: 0.10),
            ),
          ),
        ),
        // Bottom-right radial glow
        Positioned(
          bottom: -100,
          right: -60,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kPrimaryBlue.withValues(alpha: 0.06),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

/// A premium glassmorphism logo mark container.
class GlassLogoMark extends StatelessWidget {
  const GlassLogoMark({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: kPrimaryBlue.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: kPrimaryBlue.withValues(alpha: 0.27)),
            boxShadow: [
              BoxShadow(
                color: kPrimaryBlue.withValues(alpha: 0.20),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.sports_esports_rounded,
            color: kPrimaryBlue,
            size: 36,
          ),
        ),
      ),
    );
  }
}

/// A premium glassmorphism error dialog box.
class GlassErrorBox extends StatelessWidget {
  const GlassErrorBox({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0x20BA1A1A),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0x50BA1A1A)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFFF6B6B),
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFFFF6B6B),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A premium glassmorphism app bar with a back button and logo.
class GlassAppBar extends StatelessWidget {
  const GlassAppBar({super.key, required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: kPrimaryBlue.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kPrimaryBlue.withValues(alpha: 0.20)),
                ),
                child: IconButton(
                  onPressed: onBack,
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: kTextHeading,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: kPrimaryBlue.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kPrimaryBlue.withValues(alpha: 0.20)),
                ),
                child: const Icon(
                  Icons.sports_esports_rounded,
                  color: kPrimaryBlue,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'GenZ eSports',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

/// A premium glassmorphism badge/icon holder.
class GlassBadge extends StatelessWidget {
  const GlassBadge({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kPrimaryBlue.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kPrimaryBlue.withValues(alpha: 0.20)),
          ),
          child: child,
        ),
      ),
    );
  }
}

