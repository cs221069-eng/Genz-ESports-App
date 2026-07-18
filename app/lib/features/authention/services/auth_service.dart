import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import '../models/auth_user.dart';

class AuthException implements Exception {
  AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const String _baseUrl = 'https://final-year-backend-pi.vercel.app';
  static const String _sessionUserKey = 'auth.session.user';
  static const String _sessionExpiresAtKey = 'auth.session.expiresAt';
  static const Duration _sessionDuration = Duration(days: 1);

  AuthUser? currentUser;
  // Broadcast stream for user changes
  final _userController = StreamController<AuthUser?>.broadcast();
  Stream<AuthUser?> get userStream => _userController.stream;

  void _notifyUserChanged() => _userController.add(currentUser);

  bool get isLoggedIn => currentUser != null;

  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final expiresAtMs = prefs.getInt(_sessionExpiresAtKey);
    final userJson = prefs.getString(_sessionUserKey);

    if (expiresAtMs == null ||
        userJson == null ||
        DateTime.now().millisecondsSinceEpoch >= expiresAtMs) {
      await _clearStoredSession(prefs);
      currentUser = null;
      _notifyUserChanged();
      return;
    }

    try {
      currentUser = AuthUser.fromJson(
        jsonDecode(userJson) as Map<String, dynamic>,
      );
      _notifyUserChanged();
    } catch (_) {
      await _clearStoredSession(prefs);
      currentUser = null;
      _notifyUserChanged();
    }
  }

  Future<String?> register({
    required String fullname,
    required String email,
    required String password,
    required String number,
    String? favGame,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/users/createUser');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullname': fullname.trim(),
        'email': email.trim(),
        'password': password,
        'number': number.trim(),
        'favGame': favGame?.trim(),
      }),
    );

    final body = response.body.isNotEmpty
        ? jsonDecode(response.body) as Map<String, dynamic>
        : <String, dynamic>{};

    if (response.statusCode != 201 && response.statusCode != 200) {
      final message = body['message'] as String? ?? 'Registration failed';
      throw AuthException(message);
    }

    if (body['debugOtp'] is String) {
      return body['debugOtp'] as String;
    }
    return null;
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/users/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.trim(),
        'password': password,
      }),
    );

    final body = response.body.isNotEmpty
        ? jsonDecode(response.body) as Map<String, dynamic>
        : <String, dynamic>{};

    if (response.statusCode != 200) {
      final message = body['message'] as String? ?? 'Login failed';
      throw AuthException(message);
    }

    final userJson = <String, dynamic>{};
    if (body['user'] is Map<String, dynamic>) {
      userJson.addAll(body['user'] as Map<String, dynamic>);
    }
    if (body['token'] is String) {
      userJson['token'] = body['token'] as String;
    }

    if (userJson.isEmpty) {
      throw AuthException('Unable to load user profile.');
    }

    currentUser = AuthUser.fromJson(userJson);
    try {
      await _saveSession(currentUser!);
    } catch (error) {
      print('Unable to save login session: $error');
    }
    _notifyUserChanged();
  }

  Future<void> verifyEmail({
    required String email,
    required String otp,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/users/verify-email');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.trim(),
        'otp': otp.trim(),
      }),
    );

    final body = response.body.isNotEmpty
        ? jsonDecode(response.body) as Map<String, dynamic>
        : <String, dynamic>{};

    if (response.statusCode != 200) {
      final message = body['message'] as String? ?? 'Verification failed';
      throw AuthException(message);
    }

    final userJson = <String, dynamic>{};
    if (body['user'] is Map<String, dynamic>) {
      userJson.addAll(body['user'] as Map<String, dynamic>);
    }
    if (body['token'] is String) {
      userJson['token'] = body['token'] as String;
    }

    currentUser = AuthUser.fromJson(userJson);
    try {
      await _saveSession(currentUser!);
    } catch (error) {
      print('Unable to save login session: $error');
    }
    _notifyUserChanged();
  }

  Future<void> updateDisplayName(String newName) async {
    if (currentUser == null || currentUser!.token == null) {
      throw AuthException('Not logged in');
    }

    final uri = Uri.parse('$_baseUrl/api/users/update-displayname');
    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${currentUser!.token}',
      },
      body: jsonEncode({'displayName': newName.trim()}),
    );

    // Debug output
    print('🛠 updateDisplayName → status: ${response.statusCode}');
    print('🛠 updateDisplayName → body: ${response.body}');

    final body = response.body.isNotEmpty
        ? jsonDecode(response.body) as Map<String, dynamic>
        : <String, dynamic>{};

    if (response.statusCode != 200) {
      final message = body['message'] as String? ?? 'Update failed';
      throw AuthException(message);
    }

    // If backend returns updated user, use it; otherwise refresh manually
    if (body['user'] is Map<String, dynamic>) {
      currentUser = AuthUser.fromJson(body['user'] as Map<String, dynamic>);
      _notifyUserChanged();
    } else {
      // Fallback: fetch the latest profile
      await refreshCurrentUser(); // refresh will also notify
    }
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (currentUser == null || currentUser!.token == null) {
      throw AuthException('Not logged in');
    }

    final uri = Uri.parse('$_baseUrl/api/users/update-password');
    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${currentUser!.token}',
      },
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    final body = response.body.isNotEmpty
        ? jsonDecode(response.body) as Map<String, dynamic>
        : <String, dynamic>{};

    if (response.statusCode != 200) {
      final message = body['message'] as String? ?? 'Password update failed';
      throw AuthException(message);
    }
  }

  // New method for forgot password - returns debugOtp in dev mode
  Future<String?> requestPasswordReset({
    required String email,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/users/forgot-password');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email.trim()}),
    );

    final body = response.body.isNotEmpty
        ? jsonDecode(response.body) as Map<String, dynamic>
        : <String, dynamic>{};

    if (response.statusCode != 200) {
      final message = body['message'] as String? ?? 'Password reset request failed';
      throw AuthException(message);
    }

    // Return debugOtp for dev convenience (same pattern as register)
    if (body['debugOtp'] is String) {
      return body['debugOtp'] as String;
    }
    return null;
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/users/reset-password');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.trim(),
        'otp': otp.trim(),
        'newPassword': newPassword,
      }),
    );

    final body = response.body.isNotEmpty
        ? jsonDecode(response.body) as Map<String, dynamic>
        : <String, dynamic>{};

    if (response.statusCode != 200) {
      final message = body['message'] as String? ?? 'Password reset failed';
      throw AuthException(message);
    }
  }

  // Fetch the current user's profile to refresh local cache
  Future<void> refreshCurrentUser() async {
    if (currentUser == null || currentUser!.token == null) {
      throw AuthException('Not logged in');
    }
    final uri = Uri.parse('$_baseUrl/api/users/me');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer ${currentUser!.token}'},
    );
    if (response.statusCode != 200) {
      throw AuthException('Failed to refresh user profile');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    currentUser = AuthUser.fromJson(body);
    _notifyUserChanged();
  }

  Future<void> logout() async {
    currentUser = null;
    try {
      await _clearStoredSession(await SharedPreferences.getInstance());
    } catch (error) {
      print('Unable to clear login session: $error');
    }
    _notifyUserChanged();
  }

  Future<void> _saveSession(AuthUser user) async {
    final prefs = await SharedPreferences.getInstance();
    final expiresAt = DateTime.now().add(_sessionDuration);
    await prefs.setString(_sessionUserKey, jsonEncode(user.toJson()));
    await prefs.setInt(
      _sessionExpiresAtKey,
      expiresAt.millisecondsSinceEpoch,
    );
  }

  Future<void> _clearStoredSession(SharedPreferences prefs) async {
    await prefs.remove(_sessionUserKey);
    await prefs.remove(_sessionExpiresAtKey);
  }

  Future<String> fetchFrontendUrl() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/config'));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['frontendUrl'] as String? ?? 'http://10.0.2.2:5173';
      }
    } catch (e) {
      print('Error fetching frontend config: $e');
    }
    // Fallback if API fails
    return Platform.isAndroid ? 'http://10.0.2.2:5173' : 'http://localhost:5173';
  }
}
