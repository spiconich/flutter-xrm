import 'package:hostvm_xrm/features/generate_plan/data/models/broker_login_response_dto.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/entities/authenticator_entity.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/repositories/generate_plan_repository.dart';
import 'package:hostvm_xrm/features/generate_plan/data/datasources/generate_plan_remote_data_source.dart';
import 'package:hostvm_xrm/features/generate_plan/data/models/session_request_dto.dart';
import 'package:hostvm_xrm/features/generate_plan/data/models/session_response_dto.dart';

class GeneratePlanRepositoryImpl implements GeneratePlanRepository {
  final GeneratePlanRemoteDataSource remoteDataSource;

  GeneratePlanRepositoryImpl(this.remoteDataSource);

  @override
  Future<SessionResponseDto> initializeSession({
    required String host,
    required String auth,
    required String username,
    required String password,
  }) async {
    return remoteDataSource.initializeSession(
      SessionRequestDto(
        host: host,
        username: username,
        auth: auth,
        password: password,
      ),
    );
  }

  @override
  Future<BrokerLoginResponseDto> brokerLogin() async {
    return remoteDataSource.brokerLogin();
  }

  @override
  Future<List<AuthenticatorEntity>> getAllAuths() async {
    final dto = await remoteDataSource.getAllAuths();
    return dto.result.map((authDto) => authDto.toEntity()).toList();
  }
}
