// lib/blocs/todo_bloc/todo_state.dart
import 'package:equatable/equatable.dart';
import '../../models/todo.dart';

// Estado base
abstract class TodoState extends Equatable {
  const TodoState();
  @override
  List<Object?> get props => [];
}

// 1. Estado inicial (antes de carregar)
class TodoInitial extends TodoState {}

// 2. Estado de carregamento (mostrar rodinha)
class TodoLoading extends TodoState {}

// 3. Estado carregado com sucesso (lista de tarefas)
class TodoLoaded extends TodoState {
  final List<Todo> todos;
  const TodoLoaded(this.todos);
  @override
  List<Object?> get props => [todos];
}

// 4. Estado de erro
class TodoError extends TodoState {
  final String message;
  const TodoError(this.message);
  @override
  List<Object?> get props => [message];
}