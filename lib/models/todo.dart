class Todo {
  final int id;
  final String title;
  final String? description;
  final bool completed;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    this.description,
    required this.completed,
    required this.createdAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}