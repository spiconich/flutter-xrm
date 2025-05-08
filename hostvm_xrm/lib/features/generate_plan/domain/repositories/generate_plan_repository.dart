import 'package:hostvm_xrm/features/generate_plan/data/models/session_response_dto.dart';

abstract class GeneratePlanRepository {
  Future<SessionResponseDto> initializeSession(
    String host,
    String auth,
    String username,
    String password,
  );
}
