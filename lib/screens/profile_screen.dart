import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_event.dart';
import '../blocs/auth_bloc/auth_state.dart';
import '../blocs/todo_bloc/todo_bloc.dart';
import '../blocs/todo_bloc/todo_state.dart';
import '../theme/app_theme.dart';
import '../theme/app_icons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.rosaFundo,
      appBar: AppBar(
        title: const Text(
          'Perfil',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      
        elevation: 0,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthAuthenticated) {
            final user = authState.user;
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
              // foto de perfil futura
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: AppTheme.blush,
                      shape: BoxShape.circle,
                    
                    ),
                    child: Center(
                      child: Text(
                        user.username.isNotEmpty
                            ? user.username[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                 
                  Text(
                    user.username,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                 
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 14,
                    
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
               
                  BlocBuilder<TodoBloc, TodoState>(
                    builder: (context, todoState) {
                      int total = 0;
                      int completed = 0;
                      
                      if (todoState is TodoLoaded) {
                        total = todoState.todos.length;
                        completed = todoState.todos.where((t) => t.completed).length;
                      }
                      
                      return Row(
                        children: [
                          // Card: Total 
                          Expanded(
                            child: _buildStatCard(
                              icon: AppIcon.diary,
                              value: total.toString(),
                              label: 'Tarefas',
                              color: AppTheme.blush,
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Card: Tarefas concluídas
                          Expanded(
                            child: _buildStatCard(
                              icon: AppIcon.sparkles,
                              value: completed.toString(),
                              label: 'Concluídas',
                              color: Colors.green
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  
                  const SizedBox(height: 52),
                  
                 
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Sair',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
              
                  Text(
                    'Versão 1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                    
                    ),
                  ),
                ],
              ),
            );
          }
          
          // Se não estiver autenticado
          return const Center(
            child: Text(
              'Usuário não encontrado',
          
            ),
          );
        },
      ),
    );
  }

  // ==========================================
  // 🛠️ WIDGET AUXILIAR: Card de estatística
  // ==========================================
  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
          
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 28,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
             
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 📝 DIÁLOGO DE CONFIRMAÇÃO DE SAÍDA
  // ==========================================
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Sair do app?',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'Tem certeza que deseja sair? Você precisará fazer login novamente.',
            
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
               
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<AuthBloc>().add(LogoutEvent());
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
              
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }
}