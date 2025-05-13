class GetAllAuthsResponseDto {
  final String status;
  final List<AuthenticatorDto> result;

  GetAllAuthsResponseDto({required this.result, required this.status});

  factory GetAllAuthsResponseDto.fromJson(Map<String, dynamic> json) {
    return GetAllAuthsResponseDto(
      result:
          (json['result'] as List)
              .map((e) => AuthenticatorDto.fromJson(e))
              .toList(),
      status: json['status'],
    );
  }
}

class AuthenticatorDto {
  final String id;
  final String name;
  final Map<String, dynamic> data;

  AuthenticatorDto({required this.id, required this.name, required this.data});

  factory AuthenticatorDto.fromJson(Map<String, dynamic> json) {
    return AuthenticatorDto(id: json['id'], name: json['name'], data: json);
  }
}
