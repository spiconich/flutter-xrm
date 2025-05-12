class SessionRequestEntity {
  final String username;
  final String password;
  final String host;
  final String auth;

  const SessionRequestEntity({
    required this.username,
    required this.password,
    required this.host,
    required this.auth,
  });
}
