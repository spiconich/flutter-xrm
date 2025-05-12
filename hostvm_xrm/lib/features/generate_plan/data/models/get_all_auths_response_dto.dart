import 'package:hostvm_xrm/features/generate_plan/domain/entities/authenticator_response_entity.dart';

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
  final String comments;
  final String id;
  final String mfaId;
  final String mfaName;
  final String name;
  final int numericId;
  final int permission;
  final int priority;
  final String smallName;
  final List<dynamic> tags;
  final String type;
  final Map<String, dynamic> typeInfo;
  final String typeName;
  final int usersCount;
  final bool visible;

  AuthenticatorDto({
    required this.comments,
    required this.id,
    required this.mfaId,
    required this.mfaName,
    required this.name,
    required this.numericId,
    required this.permission,
    required this.priority,
    required this.smallName,
    required this.tags,
    required this.type,
    required this.typeInfo,
    required this.typeName,
    required this.usersCount,
    required this.visible,
  });

  factory AuthenticatorDto.fromJson(Map<String, dynamic> json) {
    return AuthenticatorDto(
      comments: json['comments'],
      id: json['id'],
      mfaId: json['mfa_id'],
      mfaName: json['mfa_name'],
      name: json['name'],
      numericId: json['numeric_id'],
      permission: json['permission'],
      priority: json['priority'],
      smallName: json['small_name'],
      tags: json['tags'],
      type: json['type'],
      typeInfo: json['type_info'],
      typeName: json['type_name'],
      usersCount: json['users_count'],
      visible: json['visible'],
    );
  }

  AuthenticatorResponseEntity toEntity() {
    return AuthenticatorResponseEntity(
      comments: comments,
      id: id,
      mfaId: mfaId,
      mfaName: mfaName,
      name: name,
      numericId: numericId,
      permission: permission,
      priority: priority,
      smallName: smallName,
      tags: tags,
      type: type,
      typeInfo: typeInfo,
      typeName: typeName,
      usersCount: usersCount,
      visible: visible,
    );
  }
}
