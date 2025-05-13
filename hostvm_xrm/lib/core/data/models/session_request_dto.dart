class SessionRequestDto {
  final String host;
  final String auth;
  final String username;
  final String password;

  SessionRequestDto({
    required this.host,
    required this.auth,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'host': host,
    'auth': auth,
    'username': username,
    'password': password,
  };
}
