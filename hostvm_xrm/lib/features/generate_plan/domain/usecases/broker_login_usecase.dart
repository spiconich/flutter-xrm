import 'package:hostvm_xrm/features/generate_plan/data/models/broker_login_response_dto.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/repositories/generate_plan_repository.dart';

class BrokerLoginUsecase {
  final GeneratePlanRepository repository;

  BrokerLoginUsecase(this.repository);

  Future<BrokerLoginResponseDto> call() async {
    return repository.brokerLogin();
  }
}
