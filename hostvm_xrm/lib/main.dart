import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/usecases/broker_login_usecase.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/usecases/get_all_auths_usecase.dart';
import 'package:hostvm_xrm/features/generate_plan/presentation/bloc/generate_plan_bloc.dart';
import 'package:hostvm_xrm/features/generate_plan/domain/usecases/get_api_session_usecase.dart';
import 'package:hostvm_xrm/features/generate_plan/data/repositories/generate_plan_repository_impl.dart';
import 'package:hostvm_xrm/features/generate_plan/data/datasources/generate_plan_remote_data_source_impl.dart';
import 'package:hostvm_xrm/features/generate_plan/presentation/pages/generate_plan_page.dart';

void main() {
  final dio = Dio();
  final generatePlanRemoteDataSource = GeneratePlanRemoteDataSourceImpl(dio);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create:
            (context) => GeneratePlanBloc(
              getApiSessionUseCase: GetApiSessionUseCase(
                GeneratePlanRepositoryImpl(generatePlanRemoteDataSource),
              ),
              brokerLoginUseCase: BrokerLoginUsecase(
                GeneratePlanRepositoryImpl(generatePlanRemoteDataSource),
              ),
              getAllAuthsUseCase: GetAllAuthsUseCase(
                GeneratePlanRepositoryImpl(generatePlanRemoteDataSource),
              ),
            ),
        child: GeneratePlanPage(),
      ),
    ),
  );
}
