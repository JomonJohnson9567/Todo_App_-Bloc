part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

class GetTodoEvents extends TodoEvent {}

class AddToDoEvents extends TodoEvent {
  final Todo toDo;
  AddToDoEvents({required this.toDo});
}

class LoadMoreTodos extends TodoEvent {}

class UpdateToDoEvent extends TodoEvent {
  final Todo todo;

  UpdateToDoEvent(this.todo);
}

class DeleteToDoEvent extends TodoEvent {
  final Todo todo;

  DeleteToDoEvent(this.todo);
}

