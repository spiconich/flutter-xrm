class AuthenticatorEntity {
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

  const AuthenticatorEntity({
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
}
