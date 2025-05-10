import 'package:dio/dio.dart';
import 'package:hostvm_xrm/core/constants/flask_server_config.dart';
import 'package:hostvm_xrm/features/generate_plan/data/models/broker_login_response_dto.dart';
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
      print("Отправлен запрос на инициализацию сессии");
      final response = await dio.post(
        '$flaskServerAddress:$flaskServerPort/api/init_session',
        data: authData.toJson(),
        options: Options(
          validateStatus: (status) => status! < 600, // Принимаем все статусы
        ),
      );
      print('''
    Ответ:
    Status: ${response.statusCode}
    Headers: ${response.headers}
    Data: ${response.data}
    ''');
      if (response.statusCode == 200) {
        final authResponse = SessionResponseDto.fromJson(response.data);
        _sessionId = authResponse.sessionId; // Сохраняем session_id
        print('Session ID: $_sessionId');
        return authResponse;
      }
      throw Exception('Failed to initialize session');
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    }
  }

  Future<BrokerLoginResponseDto> brokerLogin() async {
    try {
      print(
        "Отправлен запрос выполнения метода login с session_id: $_sessionId",
      );

      final response = await dio.post(
        '$flaskServerAddress:$flaskServerPort/api/call',
        data: {'method': 'login', 'session_id': _sessionId},
        options: Options(
          validateStatus: (status) => status! < 600, // Принимаем все статусы
        ),
      );

      print('''
    Ответ:
    Status: ${response.statusCode}
    Headers: ${response.headers}
    Data: ${response.data}
    ''');

      if (response.statusCode == 200) {
        return BrokerLoginResponseDto.fromJson(response.data);
      }

      final errorMsg =
          response.data is Map
              ? response.data['error'] ?? response.data.toString()
              : response.data.toString();

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Server error ${response.statusCode}: $errorMsg',
      );
    } on DioException catch (e) {
      throw Exception('Login failed: ${e.response?.data ?? e.message}');
    }
  }
}
