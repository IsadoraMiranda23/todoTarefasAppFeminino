import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_event.dart';
import '../blocs/auth_bloc/auth_state.dart';
import '../theme/app_theme.dart';
import '../theme/app_icons.dart';
import './register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD9DF),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Container(
                  height: 720,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.blueGrey,
                            blurRadius: 2,
                            offset: Offset(0, 2)),
                      ],
                      color: const Color.fromARGB(255, 249, 246, 246)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 90),
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                                color: AppTheme.lavandaClaro,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Icon(AppIcon.sparkles),
                          ),
                          const Text('Hello, sunshine  ',
                              style: TextStyle(fontSize: 32)),
                          Text("Sinta a calma de um dia organizado"),
                          const SizedBox(height: 90),
                          TextField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                                labelText: 'Usuário',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)))),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                                labelText: 'Senha',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)))),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: AlignmentGeometry.centerRight,
                            child: InkWell(
                              child: Text(
                                "Esqueceu a senha?",
                                style:
                                    TextStyle(color: AppTheme.rosaBlushIntenso),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                    LoginEvent(
                                      username: _usernameController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.blush,
                              foregroundColor: Colors.black54,
                              minimumSize: const Size(220, 65),
                            ),
                            child: const Text('Entrar'),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Não tem conta? "),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const RegisterScreen()),
                                  );
                                },
                                child: Text(
                                  "Criar conta",
                                  style:
                                      TextStyle(color: AppTheme.rosaBlushIntenso),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
