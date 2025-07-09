import 'package:bloc_app/bloc/todo_bloc.dart';
import 'package:bloc_app/core/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

Widget buildTodoItem(BuildContext context, Todo todo, int index) {
  return AnimationConfiguration.staggeredList(
    position: index,
    delay: const Duration(milliseconds: 100),
    child: FadeInAnimation(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              // Optional: Add tap functionality if needed
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 48,
                    decoration: BoxDecoration(
                      color:
                          todo.isCompleted
                              ? const Color(0xFF48BB78)
                              : const Color(0xFF667EEA),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color:
                                todo.isCompleted
                                    ? const Color(0xFF718096)
                                    : const Color(0xFF2D3748),
                            decoration:
                                todo.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              todo.isCompleted
                                  ? Icons.check_circle_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              size: 16,
                              color:
                                  todo.isCompleted
                                      ? const Color(0xFF48BB78)
                                      : const Color(0xFF667EEA),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              todo.isCompleted ? 'Completed' : 'In Progress',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color:
                                    todo.isCompleted
                                        ? const Color(0xFF48BB78)
                                        : const Color(0xFF667EEA),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color:
                              todo.isCompleted
                                  ? const Color(0xFF48BB78).withOpacity(0.1)
                                  : const Color(0xFF667EEA).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: todo.isCompleted,
                            onChanged: (bool? value) {
                              context.read<TodoBloc>().add(
                                UpdateToDoEvent(
                                  todo.copyWith(isCompleted: value ?? false),
                                ),
                              );
                            },
                            activeColor: const Color(0xFF48BB78),
                            checkColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red.shade400,
                            size: 20,
                          ),
                          onPressed: () {
                            context.read<TodoBloc>().add(DeleteToDoEvent(todo));
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
