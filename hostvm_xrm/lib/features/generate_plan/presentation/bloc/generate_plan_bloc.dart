import 'package:hostvm_xrm/features/generate_plan/data/models/broker_login_response_dto.dart';
import 'package:hostvm_xrm/features/generate_plan/data/models/session_response_dto.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/usecases/broker_login_usecase.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/usecases/get_api_session_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '../events/generate_plan_event.dart';
part '../states/generate_plan_state.dart';

class GeneratePlanBloc extends Bloc<GeneratePlanEvent, GeneratePlanState> {
  final GetApiSessionUseCase getApiSessionUseCase;
  final BrokerLoginUsecase brokerLoginUseCase;
  String? sessionId;

  GeneratePlanBloc({
    required this.getApiSessionUseCase,
    required this.brokerLoginUseCase,
  }) : super(GeneratePlanInitial()) {
    on<InitializeSessionEvent>(_onInitializeSession);
    on<BrokerLoginEvent>(_onBrokerLogged);
  }

  Future<void> _onInitializeSession(
    InitializeSessionEvent event,
    Emitter<GeneratePlanState> emit,
  ) async {
    emit(GeneratePlanLoading());
    try {
      final sessionResponse = await getApiSessionUseCase(
        auth: event.auth,
        host: event.host,
        username: event.username,
        password: event.password,
      );
      sessionId = sessionResponse.sessionId;
      emit(SessionInitialized(sessionResponse));
    } catch (e) {
      emit(GeneratePlanError(e.toString()));
    }
  }

  Future<void> _onBrokerLogged(
    BrokerLoginEvent event,
    Emitter<GeneratePlanState> emit,
  ) async {
    emit(GeneratePlanLoading());
    try {
      final brokerLoginResponse = await brokerLoginUseCase();
      emit(BrokerLogged(brokerLoginResponse));
    } catch (e) {
      emit(GeneratePlanError(e.toString()));
    }
  }
}
