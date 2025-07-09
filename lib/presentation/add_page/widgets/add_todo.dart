import 'package:bloc_app/bloc/todo_bloc.dart';
import 'package:bloc_app/core/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void addTodo(
  BuildContext context,
  BuildContext dialogContext,
  TextEditingController titleController,
) {
  final String title = titleController.text.trim();
  if (title.isNotEmpty) {
    final Todo newTodo = Todo(
      id: 0, // Will be replaced with unique ID in BLoC
      title: title,
      isCompleted: false,
      userId: 1,
    );

    print('Adding Todo: ${newTodo.title}');

    // Add the todo using the parent context (which has access to TodoBloc)
    context.read<TodoBloc>().add(AddToDoEvents(toDo: newTodo));

    // Close the dialog
    Navigator.of(dialogContext).pop();

    // Show a modern snackbar confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text(
                'Task added successfully!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xFF48BB78),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        elevation: 6,
      ),
    );
  } else {
    // Show modern error snackbar if title is empty
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: const Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text(
                'Please enter a task title',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        elevation: 6,
      ),
    );
  }
}
