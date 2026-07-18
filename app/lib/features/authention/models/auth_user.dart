class AuthUser {
  AuthUser({
    required this.fullname,
    required this.email,
    required this.number,
    required this.favGame,
    required this.role,
    required this.createdAt,
    this.token,
  });

  final String fullname;
  final String email;
  final String number;
  final String? favGame;
  final String role;
  final DateTime createdAt;
  final String? token;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      fullname: json['fullname'] as String? ?? '',
      email: json['email'] as String? ?? '',
      number: json['number'] as String? ?? '',
      favGame: json['favGame'] as String?,
      role: json['role'] as String? ?? 'user',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'email': email,
      'number': number,
      'favGame': favGame,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'token': token,
    };
  }
}
