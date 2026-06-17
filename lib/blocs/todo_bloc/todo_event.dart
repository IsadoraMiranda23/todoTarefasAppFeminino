// lib/blocs/todo_bloc/todo_event.dart
import 'package:equatable/equatable.dart';

// Evento base
abstract class TodoEvent extends Equatable {
  const TodoEvent();
  @override
  List<Object?> get props => [];
}

// 1. Carregar tarefas
class LoadTodosEvent extends TodoEvent {}

// 2. Adicionar tarefa
class AddTodoEvent extends TodoEvent {
  final String title;
  final String? description;
  const AddTodoEvent({required this.title, this.description});
  @override
  List<Object?> get props => [title, description];
}

// 3. Atualizar tarefa
class UpdateTodoEvent extends TodoEvent {
  final int id;
  final bool? completed;
  final String? title;
  final String? description;
  const UpdateTodoEvent({
    required this.id,
    this.completed,
    this.title,
    this.description,
  });
  @override
  List<Object?> get props => [id, completed, title, description];
}

// 4. Deletar tarefa
class DeleteTodoEvent extends TodoEvent {
  final int id;
  const DeleteTodoEvent({required this.id});
  @override
  List<Object?> get props => [id];
}