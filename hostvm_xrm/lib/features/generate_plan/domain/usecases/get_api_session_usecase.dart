import 'package:hostvm_xrm/features/generate_plan/domain/repositories/generate_plan_repository.dart';
import 'package:hostvm_xrm/features/generate_plan/data/models/session_response_dto.dart';

class GetApiSessionUseCase {
  final GeneratePlanRepository repository;

  GetApiSessionUseCase(this.repository);

  Future<SessionResponseDto> call({
    required String username,
    required String password,
    required String auth,
    required String host,
  }) async {
    return repository.initializeSession(
      host = host,
      username = username,
      auth = auth,
      host = host,
    );
  }
}
