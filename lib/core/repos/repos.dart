import 'dart:convert';
import 'dart:developer';
import 'package:bloc_app/core/model/model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static const String baseurl = 'https://dummyjson.com/todos';

  // Fetch Todos with pagination
  Future<List<Todo>> fetchTodos({required int page, required int limit}) async {
    const maxRetries = 3;
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        final response = await http.get(
          Uri.parse('$baseurl?limit=$limit&skip=${(page - 1) * limit}'),
        );
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body)['todos'];
          return data.map((json) => Todo.fromJson(json)).toList();
        }
      } catch (e) {
        log('Error fetching data: $e');
      }
      retryCount++;
    }

    return [];
  }

  // Create a new Todo

  Future<Todo?> createTodo(Todo todo) async {
    final response = await http.post(
      Uri.parse(baseurl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      log('Todo created successfully: ${response.body}');
      return Todo.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}
