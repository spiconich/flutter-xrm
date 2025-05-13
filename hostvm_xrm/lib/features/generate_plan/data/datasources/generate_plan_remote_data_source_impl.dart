import 'package:dio/dio.dart';
import 'package:hostvm_xrm/core/constants/flask_server_config.dart';
import 'package:hostvm_xrm/core/constants/api_routes.dart';
import 'package:hostvm_xrm/core/constants/api_methods.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/repositories/generate_plan_remote_data_source_interface.dart';

class GeneratePlanRemoteDataSourceImpl implements GeneratePlanRemoteDataSource {
  final Dio dio;
  String? _sessionId;

  GeneratePlanRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> initializeSession(
    Map<String, dynamic> authData,
  ) async {
    try {
      print("Отправлен запрос на инициализацию сессии");

      final response = await dio.post(
        '$flaskServerAddress:$flaskServerPort${ApiRoutes.apiInitSession}',
        data: authData,
        options: Options(validateStatus: (status) => status! < 600),
      );

      print('''
      Ответ:
      Status: ${response.statusCode}
      Headers: ${response.headers}
      Data: ${response.data}
      ''');

      if (response.statusCode == 200) {
        _sessionId = response.data['session_id'] as String?;
        return response.data;
      }
      throw Exception('Failed to initialize session: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> brokerLogin() async {
    try {
      print(
        "Отправлен запрос выполнения метода ${ApiMethods.login} с session_id: $_sessionId",
      );

      final response = await dio.post(
        '$flaskServerAddress:$flaskServerPort${ApiRoutes.apiCallMethod}',
        data: {'method': ApiMethods.login, 'session_id': _sessionId},
        options: Options(validateStatus: (status) => status! < 600),
      );

      print('''
    Ответ:
    Status: ${response.statusCode}
    Headers: ${response.headers}
    Data: ${response.data}
    ''');

      if (response.statusCode == 200) {
        return response.data;
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

  @override
  Future<Map<String, dynamic>> getAllAuths() async {
    try {
      print(
        "Отправлен запрос выполнения метода ${ApiMethods.listAuths} с session_id: $_sessionId",
      );

      final response = await dio.post(
        '$flaskServerAddress:$flaskServerPort${ApiRoutes.apiCallMethod}',
        data: {'method': ApiMethods.listAuths, 'session_id': _sessionId},
        options: Options(validateStatus: (status) => status! < 600),
      );

      print('''
    Ответ:
    Status: ${response.statusCode}
    Headers: ${response.headers}
    Data: ${response.data}
    ''');

      if (response.statusCode == 200) {
        return response.data;
      }

      final errorMsg =
          response.data is Map
              ? response.data['error'] ?? response.data.toString()
              : response.data.toString();

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: '${response.statusCode}: $errorMsg',
      );
    } on DioException catch (e) {
      throw Exception('${e.response?.data ?? e.message}');
    }
  }
}
