import 'package:hostvm_xrm/features/generate_plan/domain/entities/authenticator_response_entity.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/entities/broker_login_response_entity.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/entities/session_response_entity.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/entities/session_request_entity.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/repositories/generate_plan_repository.dart';
import 'package:hostvm_xrm/features/generate_plan/data/datasources/generate_plan_remote_data_source.dart';
import 'package:hostvm_xrm/features/generate_plan/data/models/session_request_dto.dart';

class GeneratePlanRepositoryImpl implements GeneratePlanRepository {
  final GeneratePlanRemoteDataSource remoteDataSource;

  GeneratePlanRepositoryImpl(this.remoteDataSource);

  @override
  Future<SessionResponseEntity> initializeSession(
    SessionRequestEntity params,
  ) async {
    final dto = SessionRequestDto(
      host: params.host,
      auth: params.auth,
      username: params.username,
      password: params.password,
    );
    final response = await remoteDataSource.initializeSession(dto);
    return SessionResponseEntity(
      sessionId: response.sessionId,
      status: response.status,
    );
  }

  @override
  Future<BrokerLoginResponseEntity> brokerLogin() async {
    final response = await remoteDataSource.brokerLogin();
    return BrokerLoginResponseEntity(
      status: response.status,
      result: response.result,
    );
  }

  @override
  Future<List<AuthenticatorResponseEntity>> getAllAuths() async {
    final response = await remoteDataSource.getAllAuths();
    return response.result.map((authDto) => authDto.toEntity()).toList();
  }
}
