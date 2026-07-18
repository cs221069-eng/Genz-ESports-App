import 'package:flutter/material.dart';
import '../../Tournament/services/tournament_service.dart' as tournament_service;

import '../model/home_content_models.dart';

class TournamentService {
  TournamentService._privateConstructor();
  static final TournamentService instance = TournamentService._privateConstructor();

  static List<FeaturedEvent> _cache = [];

  Future<List<FeaturedEvent>> fetchFeaturedEvents({bool forceRefresh = false}) async {
    if (_cache.isNotEmpty && !forceRefresh) {
      _fetchAndCache(); // Revalidate in background
      return _cache;
    }
    return _fetchAndCache();
  }

  Future<List<FeaturedEvent>> _fetchAndCache() async {
    try {
      final entries = await tournament_service.TournamentService.instance.fetchTournaments();
      _cache = entries
          .map((entry) => FeaturedEvent(
                title: entry.title,
                schedule: entry.schedule,
                prize: entry.footerText,
                attendance: entry.trailingMeta,
                actionText: entry.actionText,
                bannerColors: entry.bannerColors,
                actionEnabled: entry.enabled,
                imageUrl: entry.imageUrl,
              ))
          .toList();
      return _cache;
    } catch (e) {
      return _cache;
    }
  }
}
