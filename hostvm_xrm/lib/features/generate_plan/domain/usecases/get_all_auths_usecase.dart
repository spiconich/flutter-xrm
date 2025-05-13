import 'package:hostvm_xrm/features/generate_plan/domain/repositories/generate_plan_repository_interface.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/entities/authenticator_response_entity.dart';

class GetAllAuthsUseCase {
  final GeneratePlanRepository repository;

  GetAllAuthsUseCase(this.repository);

  Future<List<AuthenticatorResponseEntity>> call() async {
    return repository.getAllAuths();
  }
}
