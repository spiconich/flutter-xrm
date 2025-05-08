import 'package:hostvm_xrm/features/generate_plan/domain/repositories/generate_plan_repository.dart';
import 'package:hostvm_xrm/features/generate_plan/data/models/session_response_dto.dart';

class AuthenticateApiUseCase {
  final GeneratePlanRepository repository;

  AuthenticateApiUseCase(this.repository);

  Future<SessionResponseDto> call(
    String username,
    String password,
    String auth,
    String host,
  ) async {
    return repository.initializeSession(
      host = host,
      username = username,
      auth = auth,
      host = host,
    );
  }
}
