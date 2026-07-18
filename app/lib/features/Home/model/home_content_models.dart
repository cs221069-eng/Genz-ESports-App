import 'package:flutter/material.dart';
import 'dart:convert';

enum VideoCategory { live, highlight }

class HomeQuickAction {
  const HomeQuickAction({
    required this.label,
    required this.caption,
    required this.icon,
    required this.tint,
  });

  final String label;
  final String caption;
  final IconData icon;
  final Color tint;
}

class HomeGameSpotlight {
  const HomeGameSpotlight({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
}

class LiveStreamEmbed {
  const LiveStreamEmbed({
    required this.title,
    required this.streamer,
    required this.viewers,
    required this.youtubeEmbedUrl,
    required this.thumbnailUrl,
    required this.accent,
    required this.badge,
    required this.category,
  });

  factory LiveStreamEmbed.fromJson(Map<String, dynamic> json) {
    final type = (json['type'] as String?)?.toLowerCase();
    final status = (json['status'] as String?)?.toUpperCase();
    final category = type == 'highlight'
        ? VideoCategory.highlight
        : VideoCategory.live;
    final badge = category == VideoCategory.highlight
        ? ((json['category'] as String?)?.toUpperCase() ?? 'HIGHLIGHT')
        : (status?.isNotEmpty == true ? status! : 'LIVE');

    return LiveStreamEmbed(
      title: json['title'] as String? ?? 'Untitled video',
      streamer: (json['streamer'] as String?)?.isNotEmpty == true
          ? json['streamer'] as String
          : (json['category'] as String? ?? 'GenZ Highlights'),
      viewers: (json['viewers'] as String?)?.isNotEmpty == true
          ? json['viewers'] as String
          : (json['duration'] as String? ?? ''),
      youtubeEmbedUrl:
          (json['embedUrl'] as String?) ?? (json['videoUrl'] as String? ?? ''),
      thumbnailUrl: json['thumbnail'] as String? ?? '',
      accent: category == VideoCategory.highlight
          ? const Color(0xFFFFD9D2)
          : const Color(0xFFD9D2FF),
      badge: badge,
      category: category,
    );
  }

  final String title;
  final String streamer;
  final String viewers;
  final String youtubeEmbedUrl;
  final String thumbnailUrl;
  final Color accent;
  final String badge;
  final VideoCategory category;
}

class FeaturedEvent {
  const FeaturedEvent({
    required this.title,
    required this.schedule,
    required this.prize,
    required this.attendance,
    required this.actionText,
    required this.bannerColors,
    required this.actionEnabled,
    this.imageUrl,
  });

  final String title;
  final String schedule;
  final String prize;
  final String attendance;
  final String actionText;
  final List<Color> bannerColors;
  final bool actionEnabled;
  final String? imageUrl;

  ImageProvider? get imageProvider {
    if (imageUrl == null || imageUrl!.isEmpty) return null;
    if (imageUrl!.startsWith('data:')) {
      final comma = imageUrl!.indexOf(',');
      if (comma == -1) return null;
      final base64Part = imageUrl!.substring(comma + 1);
      try {
        final bytes = base64Decode(base64Part);
        return MemoryImage(bytes);
      } catch (_) {
        return null;
      }
    }
    return NetworkImage(imageUrl!);
  }
}
