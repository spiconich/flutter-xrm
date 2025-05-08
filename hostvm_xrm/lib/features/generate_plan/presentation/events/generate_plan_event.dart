part of '../bloc/generate_plan_bloc.dart';

abstract class GeneratePlanEvent {}

class InitializeSessionEvent extends GeneratePlanEvent {
  final String username;
  final String password;
  final String host;
  final String auth;

  InitializeSessionEvent({
    required this.username,
    required this.password,
    required this.host,
    required this.auth,
  });
}
