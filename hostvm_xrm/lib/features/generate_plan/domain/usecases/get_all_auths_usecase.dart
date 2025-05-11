import 'package:hostvm_xrm/features/generate_plan/domain/repositories/generate_plan_repository.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/entities/authenticator_entity.dart';

class GetAllAuthsUseCase {
  final GeneratePlanRepository repository;

  GetAllAuthsUseCase(this.repository);

  Future<List<AuthenticatorEntity>> call() async {
    return repository.getAllAuths();
  }
}
