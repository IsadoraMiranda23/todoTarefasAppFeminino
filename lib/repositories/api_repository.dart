import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/todo.dart';

class ApiRepository {
  static const String baseUrl = 'http://localhost:8000';

  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<User> register(String email, String username, String password) async {
    final response = await _dio.post(
      '/auth/register',
      data: {'email': email, 'username': username, 'password': password},
    );
    return User.fromJson(response.data);
  }

  Future<User> login(String username, String password) async {
    final response = await _dio.post(
      '/auth/login',
      data: {'username': username, 'password': password},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    final token = response.data['access_token'];
    await _saveToken(token);
    return User(id: 0, email: '', username: username);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<bool> hasToken() async {
    final token = await _getToken();
    return token != null;
  }

  Future<List<Todo>> getTodos() async {
    await _loadToken();
    try {
      final response = await _dio.get('/todos/');
      final List<dynamic> data = response.data;
      return data.map((json) => Todo.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Todo> createTodo(String title, String? description) async {
    await _loadToken();
    try {
      final response = await _dio.post(
        '/todos/',
        data: {
          'title': title,
          'description': description,
        },
      );
      return Todo.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Todo> updateTodo(int id,
      {bool? completed, String? title, String? description}) async {
    await _loadToken();
    try {
      final Map<String, dynamic> data = {};
      if (completed != null) data['completed'] = completed;
      if (title != null) data['title'] = title;
      if (description != null) data['description'] = description;

      final response = await _dio.put('/todos/$id', data: data);
      return Todo.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteTodo(int id) async {
    await _loadToken();
    try {
      await _dio.delete('/todos/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> _loadToken() async {
    final token = await _getToken();
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map && data.containsKey('detail')) {
        return data['detail'].toString();
      }
      return 'Erro: ${error.response?.statusCode}';
    }
    return 'Erro de conexão. Verifique se a API está rodando em $baseUrl';
  }
}
