class SessionInitParams {
  final String username;
  final String password;
  final String host;
  final String auth;

  const SessionInitParams({
    required this.username,
    required this.password,
    required this.host,
    required this.auth,
  });
}
