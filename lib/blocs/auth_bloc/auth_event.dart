import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;
  const LoginEvent({required this.username, required this.password});
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String username;
  final String password;
  const RegisterEvent({required this.email, required this.username, required this.password});
}

class LogoutEvent extends AuthEvent {}

class CheckAuthEvent extends AuthEvent {}