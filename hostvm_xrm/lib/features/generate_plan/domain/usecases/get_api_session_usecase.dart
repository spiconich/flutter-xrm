import 'package:hostvm_xrm/core/domain/entity/session_response_entity.dart';
import 'package:hostvm_xrm/core/domain/entity/session_request_entity.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/repositories/generate_plan_repository_interface.dart';

class GetApiSessionUseCase {
  final GeneratePlanRepository repository;

  GetApiSessionUseCase(this.repository);

  Future<SessionResponseEntity> call({
    required String username,
    required String password,
    required String auth,
    required String host,
  }) async {
    final params = SessionRequestEntity(
      username: username,
      password: password,
      host: host,
      auth: auth,
    );
    return repository.initializeSession(params);
  }
}
