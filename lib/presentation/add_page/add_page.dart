import 'package:flutter/material.dart';
import 'package:bloc_app/bloc/todo_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_app/core/model/model.dart';

void showNameDialog(BuildContext context) {
  final TextEditingController titleController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Center(child: Text('Add Task')),
        content: TextFormField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Enter Task',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
          autofocus: true,
          onFieldSubmitted: (value) {
            // Allow pressing Enter to add the task
            _addTodo(context, dialogContext, titleController);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _addTodo(context, dialogContext, titleController);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

void _addTodo(
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

    // Show a snackbar confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Task  added successfully!',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  } else {
    // Show error if title is empty
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter a task title'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }
}
