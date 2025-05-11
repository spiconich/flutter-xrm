import 'package:hostvm_xrm/features/generate_plan/domain/entities/session_entity.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/entities/session_init_params.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/repositories/generate_plan_repository.dart';

class GetApiSessionUseCase {
  final GeneratePlanRepository repository;

  GetApiSessionUseCase(this.repository);

  Future<SessionEntity> call({
    required String username,
    required String password,
    required String auth,
    required String host,
  }) async {
    final params = SessionInitParams(
      username: username,
      password: password,
      host: host,
      auth: auth,
    );
    return repository.initializeSession(params);
  }
}
