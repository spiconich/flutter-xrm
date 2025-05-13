import 'package:hostvm_xrm/features/generate_plan/domain/entities/authenticator_response_entity.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/entities/broker_login_response_entity.dart';
import 'package:hostvm_xrm/core/domain/entity/session_response_entity.dart';
import 'package:hostvm_xrm/core/domain/entity/session_request_entity.dart';

abstract class GeneratePlanRepository {
  Future<SessionResponseEntity> initializeSession(SessionRequestEntity params);

  Future<BrokerLoginResponseEntity> brokerLogin();

  Future<List<AuthenticatorResponseEntity>> getAllAuths();
}
