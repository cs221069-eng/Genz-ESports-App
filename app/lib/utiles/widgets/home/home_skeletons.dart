import 'package:flutter/material.dart';
import '../neumorphic/neumorphic_container.dart';

class SkeletonPulse extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonPulse({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<SkeletonPulse> createState() => _SkeletonPulseState();
}

class _SkeletonPulseState extends State<SkeletonPulse> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.05, end: 0.2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(_animation.value),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}

class FeaturedEventCardSkeleton extends StatelessWidget {
  const FeaturedEventCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      borderRadius: 24,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Area Skeleton
          Container(
            height: 96,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: const Center(
              child: SkeletonPulse(
                width: 40,
                height: 40,
                borderRadius: 20,
              ),
            ),
          ),
          // Content Area Skeleton
          const Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonPulse(width: 180, height: 20, borderRadius: 4),
                          SizedBox(height: 8),
                          SkeletonPulse(width: 120, height: 16, borderRadius: 4),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    SkeletonPulse(width: 70, height: 28, borderRadius: 12),
                  ],
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonPulse(width: 60, height: 12, borderRadius: 4),
                        SizedBox(height: 6),
                        SkeletonPulse(width: 80, height: 18, borderRadius: 4),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SkeletonPulse(width: 60, height: 12, borderRadius: 4),
                        SizedBox(height: 6),
                        SkeletonPulse(width: 80, height: 18, borderRadius: 4),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 18),
                SkeletonPulse(
                  width: double.infinity,
                  height: 48,
                  borderRadius: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LiveStreamEmbedCardSkeleton extends StatelessWidget {
  const LiveStreamEmbedCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      borderRadius: 20,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Thumbnail Area
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: const Center(
              child: SkeletonPulse(width: 50, height: 50, borderRadius: 25),
            ),
          ),
          // Details Area
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                SkeletonPulse(width: 40, height: 40, borderRadius: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonPulse(width: 160, height: 16, borderRadius: 4),
                      SizedBox(height: 6),
                      SkeletonPulse(width: 100, height: 12, borderRadius: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
