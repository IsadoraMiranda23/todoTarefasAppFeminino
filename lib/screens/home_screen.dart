import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_event.dart';
import '../blocs/auth_bloc/auth_state.dart';
import '../blocs/todo_bloc/todo_bloc.dart';
import '../blocs/todo_bloc/todo_event.dart';
import '../blocs/todo_bloc/todo_state.dart';
import '../theme/app_theme.dart';
import '../theme/app_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(LoadTodosEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pastel,
      appBar: AppBar(
        title: const Text('Minhas Tarefas 🌸'),
        backgroundColor: AppTheme.rosaFundo,
        foregroundColor: AppTheme.roxo,
        actions: [
          IconButton(
            icon: Icon(
              AppIcon.logOut,
              color: AppTheme.lilac,
              size: 20,
            ),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthAuthenticated) {
            final userName = authState.user.username;
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Saudação
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        'Olá,',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                         
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Lista de tarefas
                Expanded(
                  child: BlocBuilder<TodoBloc, TodoState>(
                    builder: (context, todoState) {
                      if (todoState is TodoLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.blush,
                          ),
                        );
                      }
                      
                      if (todoState is TodoError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, size: 48),
                              const SizedBox(height: 16),
                              Text(
                                'Erro ao carregar tarefas',
                             
                              ),
                              const SizedBox(height: 8),
                              Text(
                                todoState.message,
                                
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<TodoBloc>().add(LoadTodosEvent());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.blush,
                                ),
                                child: const Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      if (todoState is TodoLoaded) {
                        final todos = todoState.todos;
                        
                        if (todos.isEmpty) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 64,
                                  color: AppTheme.blush,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Nenhuma tarefa ainda! 🌸',
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Clique no + para adicionar',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: todos.length,
                          itemBuilder: (context, index) {
                            final todo = todos[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                leading: Checkbox(
                                  value: todo.completed,
                                  onChanged: (value) {
                                    context.read<TodoBloc>().add(
                                      UpdateTodoEvent(
                                        id: todo.id,
                                        completed: value,
                                      ),
                                    );
                                  },
                                  activeColor: AppTheme.blush,
                                ),
                                title: Text(
                                  todo.title,
                                  style: TextStyle(
                                    decoration: todo.completed 
                                        ? TextDecoration.lineThrough 
                                        : null,
                                    color: todo.completed 
                                        ? AppTheme.roxo 
                                        : Colors.black,
                                  ),
                                ),
                                subtitle: todo.description != null 
                                    ? Text(
                                        todo.description!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      )
                                    : null,
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    context.read<TodoBloc>().add(
                                      DeleteTodoEvent(id: todo.id),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      }
                      
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            );
          }
          
          return const Center(
            child: Text('Usuário não encontrado'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoDialog(context);
        },
        backgroundColor: AppTheme.blush,
        child: const Icon(Icons.add),
      ),
    );
  }

  // ==========================================
  // 📝 DIÁLOGO PARA ADICIONAR TAREFA
  // ==========================================
  void _showAddTodoDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Nova Tarefa',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  hintText: 'O que você precisa fazer?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição (opcional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.black,),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  context.read<TodoBloc>().add(
                    AddTodoEvent(
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim().isEmpty
                          ? null
                          : descriptionController.text.trim(),
                    ),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Digite um título para a tarefa'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.blush,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}