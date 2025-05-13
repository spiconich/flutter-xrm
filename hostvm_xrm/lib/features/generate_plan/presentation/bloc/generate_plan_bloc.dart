import 'package:hostvm_xrm/features/generate_plan/domain/entities/authenticator_response_entity.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/entities/broker_login_response_entity.dart';
import 'package:hostvm_xrm/core/domain/entity/session_response_entity.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/usecases/broker_login_usecase.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/usecases/get_all_auths_usecase.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/usecases/get_api_session_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '../events/generate_plan_event.dart';
part '../states/generate_plan_state.dart';

class GeneratePlanBloc extends Bloc<GeneratePlanEvent, GeneratePlanState> {
  final GetApiSessionUseCase getApiSessionUseCase;
  final BrokerLoginUsecase brokerLoginUseCase;
  final GetAllAuthsUseCase getAllAuthsUseCase;
  String? sessionId;

  GeneratePlanBloc({
    required this.getApiSessionUseCase,
    required this.brokerLoginUseCase,
    required this.getAllAuthsUseCase,
  }) : super(GeneratePlanInitial()) {
    on<InitializeSessionEvent>(_onInitializeSession);
    on<BrokerLoginEvent>(_onBrokerLogged);
    on<GetAllAuthsEvent>(_onGotAllAuths);
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
    } catch (e, stackTrace) {
      emit(GeneratePlanError('Error: $e\nStack trace:\n$stackTrace'));
    }
  }

  Future<void> _onBrokerLogged(
    BrokerLoginEvent event,
    Emitter<GeneratePlanState> emit,
  ) async {
    emit(BrokerLoginLoading());
    try {
      final brokerLoginResponse = await brokerLoginUseCase();
      emit(BrokerLogged(brokerLoginResponse));
    } catch (e, stackTrace) {
      emit(GeneratePlanError('Error: $e\nStack trace:\n$stackTrace'));
    }
  }

  Future<void> _onGotAllAuths(
    GetAllAuthsEvent event,
    Emitter<GeneratePlanState> emit,
  ) async {
    emit(AllAuthsLoading());
    try {
      final getAllAuthsResponse = await getAllAuthsUseCase();
      emit(GotAllAuths(getAllAuthsResponse));
    } catch (e, stackTrace) {
      emit(GeneratePlanError('Error: $e\nStack trace:\n$stackTrace'));
    }
  }
}
