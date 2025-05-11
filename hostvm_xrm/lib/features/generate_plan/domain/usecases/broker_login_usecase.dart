import 'package:hostvm_xrm/features/generate_plan/domain/entities/broker_login_entity.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/repositories/generate_plan_repository.dart';

class BrokerLoginUsecase {
  final GeneratePlanRepository repository;

  BrokerLoginUsecase(this.repository);

  Future<BrokerLoginEntity> call() async {
    return repository.brokerLogin();
  }
}
