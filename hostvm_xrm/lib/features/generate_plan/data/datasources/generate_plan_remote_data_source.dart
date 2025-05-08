import 'package:dio/dio.dart';
import 'package:hostvm_xrm/core/constants/flask_server_config.dart';
import 'package:hostvm_xrm/features/generate_plan/data/models/session_request_dto.dart';
import 'package:hostvm_xrm/features/generate_plan/data/models/session_response_dto.dart';

class GeneratePlanRemoteDataSource {
  final Dio dio;
  String? _sessionId; // Храним session_id для последующих запросов

  GeneratePlanRemoteDataSource(this.dio);

  Future<SessionResponseDto> initializeSession(
    SessionRequestDto authData,
  ) async {
    try {
      final response = await dio.post(
        '$flaskServerAddress:$flaskServerPort/api/init_session',
        data: authData.toJson(),
      );

      if (response.statusCode == 200) {
        final authResponse = SessionResponseDto.fromJson(response.data);
        _sessionId = authResponse.sessionId; // Сохраняем session_id
        return authResponse;
      }
      throw Exception('Failed to initialize session');
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    }
  }
}
