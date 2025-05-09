import 'package:hostvm_xrm/features/generate_plan/data/models/session_response_dto.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/usecases/authenticate_api_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '../events/generate_plan_event.dart';
part '../states/generate_plan_state.dart';

class GeneratePlanBloc extends Bloc<GeneratePlanEvent, GeneratePlanState> {
  final GetApiSessionUseCase authenticateApiUseCase;
  String? sessionId;

  GeneratePlanBloc(this.authenticateApiUseCase) : super(GeneratePlanInitial()) {
    on<InitializeSessionEvent>(_onInitializeSession);
  }

  Future<void> _onInitializeSession(
    InitializeSessionEvent event,
    Emitter<GeneratePlanState> emit,
  ) async {
    emit(GeneratePlanLoading());
    try {
      final authResponse = await authenticateApiUseCase(
        event.username,
        event.password,
        event.auth,
        event.host,
      );
      sessionId = authResponse.sessionId;
      emit(GeneratePlanSuccess(authResponse));
    } catch (e) {
      emit(GeneratePlanError(e.toString()));
    }
  }
}
