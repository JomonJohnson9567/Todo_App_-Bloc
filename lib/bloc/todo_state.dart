part of 'todo_bloc.dart';

@immutable
sealed class ToDoState {}

final class ToDoInitial extends ToDoState {}

class InitialToDoState extends ToDoState {}

class LoadingToDoState extends ToDoState {}

class LoadedToDo extends ToDoState {
  final List<Todo> todoList;
  LoadedToDo(this.todoList);
}

class ErrorToDoState extends ToDoState {
  final String errorMessage;
  ErrorToDoState(this.errorMessage);
}

class TodoAdded extends ToDoState {}


