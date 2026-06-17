// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth_bloc/auth_bloc.dart';
import 'blocs/auth_bloc/auth_event.dart';
import 'blocs/todo_bloc/todo_bloc.dart';  
import 'repositories/api_repository.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ApiRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              repository: context.read<ApiRepository>(),
            )..add(CheckAuthEvent()),
          ),
          // 👇 ADICIONE O TODOBLOC AQUI!
          BlocProvider(
            create: (context) => TodoBloc(
              repository: context.read<ApiRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Todo App',
          theme: AppTheme.lightTheme(),
          debugShowCheckedModeBanner: false,
          initialRoute: '/login',
          routes: {
            '/login': (_) => const LoginScreen(),
            '/register': (_) => const RegisterScreen(),
            '/home': (_) => const HomeScreen(),
          },
        ),
      ),
    );
  }
}