import 'package:hostvm_xrm/core/data/models/session_response_dto.dart';
import 'package:hostvm_xrm/features/generate_plan/data/models/broker_login_response_dto.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/entities/authenticator_response_entity.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/entities/broker_login_response_entity.dart';
import 'package:hostvm_xrm/core/domain/entity/session_response_entity.dart';
import 'package:hostvm_xrm/core/domain/entity/session_request_entity.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/repositories/generate_plan_repository_interface.dart';
import 'package:hostvm_xrm/features/generate_plan/data/datasources/generate_plan_remote_data_source_impl.dart';
import 'package:hostvm_xrm/core/data/models/session_request_dto.dart';
import 'package:hostvm_xrm/features/generate_plan/data/models/get_all_auths_response_dto.dart';

class GeneratePlanRepositoryImpl implements GeneratePlanRepository {
  final GeneratePlanRemoteDataSourceImpl remoteDataSource;

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
    final json = await remoteDataSource.initializeSession(dto.toJson());
    final response = SessionResponseDto(
      sessionId: json['session_id'] as String,
      status: json['status'] as String,
    );
    return SessionResponseEntity(
      sessionId: response.sessionId,
      status: response.status,
    );
  }

  @override
  Future<BrokerLoginResponseEntity> brokerLogin() async {
    final json = await remoteDataSource.brokerLogin();
    final response = BrokerLoginResponseDto(
      result: json['result'] as String?,
      status: json['status'] as String,
    );
    return BrokerLoginResponseEntity(
      status: response.status,
      result: response.result,
    );
  }

  @override
  Future<List<AuthenticatorResponseEntity>> getAllAuths() async {
    final json = await remoteDataSource.getAllAuths();
    final dtos = GetAllAuthsResponseDto.fromJson(json);
    return dtos.result
        .map(
          (authData) => AuthenticatorResponseEntity(
            comments: authData.comments,
            id: authData.id,
            mfaId: authData.mfaId,
            mfaName: authData.mfaName,
            name: authData.name,
            numericId: authData.numericId,
            permission: authData.permission,
            priority: authData.priority,
            smallName: authData.smallName,
            tags: authData.tags,
            type: authData.type,
            typeInfo: authData.typeInfo,
            typeName: authData.typeName,
            usersCount: authData.usersCount,
            visible: authData.visible,
          ),
        )
        .toList();
  }
}
