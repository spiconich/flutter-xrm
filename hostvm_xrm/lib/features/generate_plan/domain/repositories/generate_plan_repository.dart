import 'package:hostvm_xrm/features/generate_plan/data/models/broker_login_response_dto.dart';
import 'package:hostvm_xrm/features/generate_plan/data/models/session_response_dto.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/entities/authenticator_entity.dart';

abstract class GeneratePlanRepository {
  Future<SessionResponseDto> initializeSession({
    required String host,
    required String auth,
    required String username,
    required String password,
  });

  Future<BrokerLoginResponseDto> brokerLogin();

  Future<List<AuthenticatorEntity>> getAllAuths();
}
