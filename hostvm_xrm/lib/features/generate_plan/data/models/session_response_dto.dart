// Ответ от API при успешной инициализации сессии
class SessionResponseDto {
  final String sessionId;
  final String status;

  SessionResponseDto({required this.sessionId, required this.status});

  factory SessionResponseDto.fromJson(Map<String, dynamic> json) {
    return SessionResponseDto(
      sessionId: json['session_id'],
      status: json['status'],
    );
  }
}
