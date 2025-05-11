import 'package:hostvm_xrm/features/generate_plan/domain/entities/authenticator_entity.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/entities/broker_login_entity.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/entities/session_entity.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/entities/session_init_params.dart';

abstract class GeneratePlanRepository {
  Future<SessionEntity> initializeSession(SessionInitParams params);

  Future<BrokerLoginEntity> brokerLogin();

  Future<List<AuthenticatorEntity>> getAllAuths();
}
