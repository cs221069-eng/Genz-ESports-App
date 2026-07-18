import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/home_content_models.dart';

class MediaService {
  MediaService._();

  static final MediaService instance = MediaService._();

  static const String _baseUrl = 'https://final-year-backend-pi.vercel.app';
  static List<LiveStreamEmbed> _cache = [];

  Future<List<LiveStreamEmbed>> fetchMediaItems({bool forceRefresh = false}) async {
    if (_cache.isNotEmpty && !forceRefresh) {
      _fetchAndCache(); // Revalidate in background
      return _cache;
    }
    return _fetchAndCache();
  }

  Future<List<LiveStreamEmbed>> _fetchAndCache() async {
    try {
      final uri = Uri.parse('$_baseUrl/api/media');
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('Unable to fetch media');
      }

      final body = jsonDecode(response.body) as List<dynamic>;
      _cache = body
          .map((item) => LiveStreamEmbed.fromJson(item as Map<String, dynamic>))
          .where((item) => item.youtubeEmbedUrl.trim().isNotEmpty)
          .toList();
      return _cache;
    } catch (e) {
      return _cache;
    }
  }
}
