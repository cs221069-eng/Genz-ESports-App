import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../theme/neumorphic_theme.dart';

enum TournamentStatus { live, upcoming, completed }

class TournamentEntry {
  const TournamentEntry({
    required this.title,
    required this.game,
    required this.badgeText,
    required this.badgeColor,
    required this.schedule,
    required this.footerText,
    required this.actionText,
    required this.trailingMeta,
    required this.bannerColors,
    required this.metaIcon,
    required this.status,
    required this.enabled,
    this.imageUrl,
  });

  final String title;
  final String game;
  final String badgeText;
  final Color badgeColor;
  final String schedule;
  final String footerText;
  final String actionText;
  final String trailingMeta;
  final List<Color> bannerColors;
  final IconData metaIcon;
  final TournamentStatus status;
  final bool enabled;
  final String? imageUrl;

  ImageProvider? get imageProvider {
    if (imageUrl == null || imageUrl!.isEmpty) return null;
    final s = imageUrl!;
    if (s.startsWith('data:')) {
      final comma = s.indexOf(',');
      if (comma == -1) return null;
      final base64Part = s.substring(comma + 1);
      try {
        final bytes = base64Decode(base64Part);
        return MemoryImage(bytes);
      } catch (_) {
        return null;
      }
    }
    return NetworkImage(s);
  }

factory TournamentEntry.fromJson(Map<String, dynamic> json) {
  final rawStatus = (json['status'] as String? ?? 'Upcoming').toLowerCase();
  final status = rawStatus == 'live'
      ? TournamentStatus.live
      : rawStatus == 'completed'
          ? TournamentStatus.completed
          : TournamentStatus.upcoming;

  final badgeText = rawStatus.toUpperCase();
  final badgeColor = status == TournamentStatus.live
      ? Colors.red
      : status == TournamentStatus.completed
          ? const Color(0xFFEAF3FF)
          : kPrimaryBlue;

  final bannerColors = status == TournamentStatus.live
      ? const [Color(0xFF7A233C), Color(0xFFDA2B58)]
      : status == TournamentStatus.completed
          ? const [Color(0xFF1C223A), Color(0xFF4B5E95)]
          : const [Color(0xFF0E5A3A), Color(0xFF39C58D)];

  // Handle imageUrl which may be a plain base64 string without data URI prefix
  String? rawImageUrl = json['imageUrl'] as String?;
  String? imageUrl;
  if (rawImageUrl != null && rawImageUrl.isNotEmpty) {
    if (rawImageUrl.startsWith('data:')) {
      imageUrl = rawImageUrl;
    } else {
      // Assume it's a base64 PNG; prepend proper data URI prefix
      imageUrl = 'data:image/png;base64,$rawImageUrl';
    }
  }

  return TournamentEntry(
    title: json['title'] as String? ?? 'Untitled Tournament',
    game: json['game'] as String? ?? 'FC26',
    badgeText: badgeText,
    badgeColor: badgeColor,
    schedule: json['schedule'] as String? ?? '',
    footerText: json['prize'] as String? ?? '',
    actionText: json['actionText'] as String? ?? 'Register',
    trailingMeta: json['attendance'] as String? ?? '',
    bannerColors: bannerColors,
    metaIcon: Icons.schedule_rounded,
    status: status,
    enabled: status != TournamentStatus.completed,
    imageUrl: imageUrl,
  );
}
}
