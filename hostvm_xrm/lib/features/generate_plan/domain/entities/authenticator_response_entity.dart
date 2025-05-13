class AuthenticatorResponseEntity {
  final String id;
  final String name;
  final Map<String, dynamic> data;

  const AuthenticatorResponseEntity({
    required this.id,
    required this.name,
    required this.data,
  });
}
