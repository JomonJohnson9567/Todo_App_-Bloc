class Todo {
  final int? id;
  final String title;
  final bool isCompleted;
  final int userId;

  Todo({
    this.id,
    required this.title,
    required this.isCompleted,
    required this.userId,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['todo'] ?? '',
      isCompleted: json['completed'] ?? false,
      userId: json['userId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'todo': title,
        'completed': isCompleted,
        'userId': userId,
      };

  Todo copyWith({int? id, String? title, bool? isCompleted, int? userId}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
    );
  }
}
