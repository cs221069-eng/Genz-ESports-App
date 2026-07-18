import 'dart:ui';
import 'package:flutter/material.dart';

/// A glassmorphism-styled button with a press-scale animation.
class NeumorphicButton extends StatefulWidget {
  const NeumorphicButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.filled = true,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  /// If true, shows solid primary blue (CTA style). If false, shows glass outline.
  final bool filled;

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      lowerBound: 0.95,
      upperBound: 1.0,
    )..value = 1.0;
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
    final bg = widget.filled
        ? const Color(0xFF17B7FF)
        : const Color(0x2217B7FF);
    final border = widget.filled
        ? const Color(0x0017B7FF)
        : const Color(0x4417B7FF);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _ctrl,
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
                boxShadow: widget.filled
                    ? const [
                        BoxShadow(
                          color: Color(0x4417B7FF),
                          blurRadius: 14,
                          offset: Offset(0, 5),
                        ),
                      ]
                    : null,
              ),
              child: DefaultTextStyle(
                style: const TextStyle(
                  color: Colors.white,
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
