import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostvm_xrm/features/generate_plan/presentation/bloc/generate_plan_bloc.dart';

class GeneratePlanPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = TextEditingController();
  final _hostController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Initialize Session')),
      body: BlocConsumer<GeneratePlanBloc, GeneratePlanState>(
        listener: (context, state) {
          if (state is GeneratePlanError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _hostController,
                  decoration: const InputDecoration(labelText: 'Broker URL'),
                ),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                TextField(
                  controller: _authController,
                  decoration: const InputDecoration(labelText: 'Authenticator'),
                ),
                const SizedBox(height: 20),
                if (state is GeneratePlanLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: () {
                      context.read<GeneratePlanBloc>().add(
                        InitializeSessionEvent(
                          username: _usernameController.text,
                          password: _passwordController.text,
                          host: _hostController.text,
                          auth: _authController.text,
                        ),
                      );
                    },
                    child: const Text('Initialize Session'),
                  ),
                if (state is GeneratePlanSuccess)
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Session initialized successfully!',
                        style: TextStyle(color: Colors.green),
                      ),
                      Text('Session ID: ${state.sessionResponse.sessionId}'),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
