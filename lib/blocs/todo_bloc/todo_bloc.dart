// lib/blocs/todo_bloc/todo_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/api_repository.dart';
//import '../../models/todo.dart';

import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final ApiRepository repository;

  TodoBloc({required this.repository}) : super(TodoInitial()) {
    // Registra quais métodos cuidam de quais eventos
    on<LoadTodosEvent>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
  }

  //  CARREGAR TAREFAS
 
  Future<void> _onLoadTodos(LoadTodosEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());  
    try {
      final todos = await repository.getTodos();  
      emit(TodoLoaded(todos));  
    } catch (e) {
      emit(TodoError(e.toString()));  
    }
  }


  //  ADICIONAR TAREFA
 
  Future<void> _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    try {
      final newTodo = await repository.createTodo(event.title, event.description);
      
      // Se já tem uma lista, adiciona a nova no final
      if (state is TodoLoaded) {
        final currentTodos = (state as TodoLoaded).todos;
        emit(TodoLoaded([...currentTodos, newTodo]));
      } else {
        emit(TodoLoaded([newTodo]));
      }
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  
  //  ATUALIZAR TAREFA
  Future<void> _onUpdateTodo(UpdateTodoEvent event, Emitter<TodoState> emit) async {
    try {
      final updatedTodo = await repository.updateTodo(
        event.id,
        completed: event.completed,
        title: event.title,
        description: event.description,
      );

      // Atualiza a lista substituindo a tarefa antiga pela nova
      if (state is TodoLoaded) {
        final currentTodos = (state as TodoLoaded).todos;
        final updatedList = currentTodos.map((todo) {
          return todo.id == updatedTodo.id ? updatedTodo : todo;
        }).toList();
        emit(TodoLoaded(updatedList));
      }
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }


  //  DELETAR TAREFA

  Future<void> _onDeleteTodo(DeleteTodoEvent event, Emitter<TodoState> emit) async {
    try {
      await repository.deleteTodo(event.id);

      // Remove a tarefa da lista
      if (state is TodoLoaded) {
        final currentTodos = (state as TodoLoaded).todos;
        final updatedList = currentTodos.where((todo) => todo.id != event.id).toList();
        emit(TodoLoaded(updatedList));
      }
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }
}