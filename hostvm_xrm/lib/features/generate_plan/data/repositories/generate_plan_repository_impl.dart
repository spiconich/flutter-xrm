import 'package:hostvm_xrm/features/generate_plan/domain/entities/authenticator_entity.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/entities/broker_login_entity.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/entities/session_entity.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/entities/session_init_params.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/repositories/generate_plan_repository.dart';
import 'package:hostvm_xrm/features/generate_plan/data/datasources/generate_plan_remote_data_source.dart';
import 'package:hostvm_xrm/features/generate_plan/data/models/session_request_dto.dart';

class GeneratePlanRepositoryImpl implements GeneratePlanRepository {
  final GeneratePlanRemoteDataSource remoteDataSource;

  GeneratePlanRepositoryImpl(this.remoteDataSource);

  @override
  Future<SessionEntity> initializeSession(SessionInitParams params) async {
    final dto = SessionRequestDto(
      host: params.host,
      auth: params.auth,
      username: params.username,
      password: params.password,
    );
    final response = await remoteDataSource.initializeSession(dto);
    return SessionEntity(
      sessionId: response.sessionId,
      status: response.status,
    );
  }

  @override
  Future<BrokerLoginEntity> brokerLogin() async {
    final response = await remoteDataSource.brokerLogin();
    return BrokerLoginEntity(status: response.status, result: response.result);
  }

  @override
  Future<List<AuthenticatorEntity>> getAllAuths() async {
    final response = await remoteDataSource.getAllAuths();
    return response.result.map((authDto) => authDto.toEntity()).toList();
  }
}
