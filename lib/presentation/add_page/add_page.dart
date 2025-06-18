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
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final String title = titleController.text.trim();
              if (title.isNotEmpty) {
                final Todo newTodo = Todo(
                  id: 0, // Dummy ID, backend assigns real ID
                  title: title,
                  isCompleted: false,
                  userId: 1,
                );
                print('Added Todo : ${newTodo.title}');
                context.read<TodoBloc>().add(AddToDoEvents(toDo: newTodo));
                Navigator.of(dialogContext).pop();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
