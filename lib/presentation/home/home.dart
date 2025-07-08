// home_page.dart

import 'package:bloc_app/bloc/todo_bloc.dart';
import 'package:bloc_app/core/model/model.dart';
import 'package:bloc_app/presentation/add_page/add_page.dart';
import 'package:bloc_app/core/repos/repos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(ApiServices())..add(GetTodoEvents()),
      child: const HomePageContent(), // Extract content to separate widget
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<TodoBloc>().add(GetTodoEvents());
                print('page refreshed');
              },
            ),
          ],
          title: const Text(
            'TODO APP',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [Tab(text: 'Incomplete'), Tab(text: 'Completed')],
          ),
        ),
        body: BlocBuilder<TodoBloc, ToDoState>(
          builder: (context, state) {
            if (state is LoadingToDoState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LoadedToDo) {
              final todos = state.todoList;
              final completedTodos =
                  todos.where((todo) => todo.isCompleted).toList();
              final incompleteTodos =
                  todos.where((todo) => !todo.isCompleted).toList();
              return TabBarView(
                children: [
                  _buildTodoList(context, incompleteTodos),
                  _buildTodoList(context, completedTodos),
                ],
              );
            } else if (state is ErrorToDoState) {
              return Center(child: Text(state.errorMessage));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed:
              () => showNameDialog(context), // Now context has access to BLoC
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.add, size: 30, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTodoList(BuildContext context, List<Todo> todos) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification &&
            scrollNotification.metrics.extentAfter == 0) {
          context.read<TodoBloc>().add(LoadMoreTodos());
        }
        return false;
      },
      child: AnimationLimiter(
        child: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return _buildTodoItem(context, todo, index);
          },
        ),
      ),
    );
  }

  Widget _buildTodoItem(BuildContext context, Todo todo, int index) {
    return AnimationConfiguration.staggeredList(
      position: index,
      delay: const Duration(milliseconds: 100),
      child: FadeInAnimation(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE6E0FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      todo.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: todo.isCompleted,
                        onChanged: (bool? value) {
                          context.read<TodoBloc>().add(
                            UpdateToDoEvent(
                              todo.copyWith(isCompleted: value ?? false),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<TodoBloc>().add(DeleteToDoEvent(todo));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
