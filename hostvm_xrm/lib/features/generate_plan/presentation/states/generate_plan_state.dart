part of '../bloc/generate_plan_bloc.dart';

sealed class GeneratePlanState {}

final class GeneratePlanInitial extends GeneratePlanState {}

final class GeneratePlanLoading extends GeneratePlanState {}

final class BrokerLoginLoading extends GeneratePlanState {}

final class AllAuthsLoading extends GeneratePlanState {}

final class SessionInitialized extends GeneratePlanState {
  final SessionResponseDto sessionResponse;

  SessionInitialized(this.sessionResponse);
}

final class BrokerLogged extends GeneratePlanState {
  final BrokerLoginResponseDto brokerLoginResponse;

  BrokerLogged(this.brokerLoginResponse);
}

final class GotAllAuths extends GeneratePlanState {
  final List<AuthenticatorEntity> getAllAuthsResponse;

  GotAllAuths(this.getAllAuthsResponse);
}

final class GeneratePlanError extends GeneratePlanState {
  final String message;

  GeneratePlanError(this.message);
}
