import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/tournament_entry.dart';

class TournamentService {
  TournamentService._();

  static final TournamentService instance = TournamentService._();

  static const String _baseUrl = 'https://final-year-backend-pi.vercel.app';

  Future<List<TournamentEntry>> fetchTournaments() async {
    final uri = Uri.parse('$_baseUrl/api/tournaments');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Unable to fetch tournaments');
    }

    final body = jsonDecode(response.body) as List<dynamic>;
    return body
        .map((item) => TournamentEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<TournamentEntry> createTournament({
    required String title,
    required String game,
    required String status,
    required String schedule,
    required String prize,
    required String attendance,
    required String streamUrl,
    required String actionText,
    File? imageFile,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/tournaments');
    final request = http.MultipartRequest('POST', uri)
      ..fields['title'] = title
      ..fields['game'] = game
      ..fields['status'] = status
      ..fields['schedule'] = schedule
      ..fields['prize'] = prize
      ..fields['attendance'] = attendance
      ..fields['streamUrl'] = streamUrl
      ..fields['actionText'] = actionText;

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 201) {
      final message = responseBody.isNotEmpty ? responseBody : 'Unable to create tournament';
      throw Exception(message);
    }

    final body = jsonDecode(responseBody) as Map<String, dynamic>;
    return TournamentEntry.fromJson(body);
  }
}
