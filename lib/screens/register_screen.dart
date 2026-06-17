import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_event.dart';
import '../blocs/auth_bloc/auth_state.dart';
import '../theme/app_theme.dart';
import '../theme/app_icons.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  

  @override
  Widget build(BuildContext context) {

    void validateAndRegister() {
    
      final username = _usernameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      
      if (username.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          confirmPassword.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preencha todos os campos'),
          ),
        );
        return;
      }

     
      if (!email.contains('@') || !email.contains('.')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Digite um e-mail válido (ex: nome@email.com)'),
          ),
        );
        return;
      }

      
      if (username.length < 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('O nome deve ter pelo menos 3 caracteres'),
          ),
        );
        return;
      }

      
      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('As senhas não coincidem'),
          ),
        );
        return;
      }

    
      if (password.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('A senha deve ter pelo menos 6 caracteres'),
          ),
        );
        return;
      }

    
      context.read<AuthBloc>().add(
            RegisterEvent(
              email: email,
              username: username,
              password: password,
            ),
          );
    }

    return Scaffold(
        backgroundColor: AppTheme.rosaFundo,
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Conta criada com sucesso! '),
                ),
              );
              Navigator.pop(context);
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(24.0),
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
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Icon(AppIcon.sparkles),
                    ),
                    const SizedBox(height: 20),
                    const Text('Comece sua jornada',
                        style: TextStyle(fontSize: 32)),
                    Center(
                      child: Text(
                          "Crie um refúgio de organização para sua produtividade"),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                          labelText: 'Seu nome Completo',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)))),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                          labelText: 'Seu melhor E-mail',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)))),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                          labelText: 'Senha',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)))),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                          labelText: 'Senha',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)))),
                    ),
                    const SizedBox(height: 24),

// Botão CADASTRAR
                    ElevatedButton(
                      onPressed: () {
                        validateAndRegister();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.blush,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Cadastrar',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),

                    const SizedBox(height: 16),


                   
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Já tenho conta',
                            style: TextStyle(
                              color: AppTheme.blush,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                  
                ),
              ),
            ),
          )),
        ));
  }
}
