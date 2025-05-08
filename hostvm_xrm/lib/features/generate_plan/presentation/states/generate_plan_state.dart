part of '../bloc/generate_plan_bloc.dart';

sealed class GeneratePlanState {}

final class GeneratePlanInitial extends GeneratePlanState {}

final class GeneratePlanLoading extends GeneratePlanState {}

final class GeneratePlanSuccess extends GeneratePlanState {
  final SessionResponseDto sessionResponse;

  GeneratePlanSuccess(this.sessionResponse);
}

final class GeneratePlanError extends GeneratePlanState {
  final String message;

  GeneratePlanError(this.message);
}
