import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:bloc_app/core/model/model.dart';
import 'package:bloc_app/core/repos/repos.dart';
import 'package:meta/meta.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, ToDoState> {
  final ApiServices apiServices;
  int _currentPage = 1;
  final int _perPage = 10;
  bool _isFetching = false;

  TodoBloc(this.apiServices) : super(InitialToDoState()) {
    on<GetTodoEvents>(_fetchInitialToDoListEvent);
    on<LoadMoreTodos>(_loadMoreTodos);
    on<AddToDoEvents>(_addToDoEvents);
    on<UpdateToDoEvent>(_updateToDoEvent);
    on<DeleteToDoEvent>(_deleteToDoEvent);
  }

  Future<void> _fetchInitialToDoListEvent(
    TodoEvent event,
    Emitter<ToDoState> emit,
  ) async {
    emit(LoadingToDoState());
    _currentPage = 1;
    try {
      final toDoList = await apiServices.fetchTodos(
        page: _currentPage,
        limit: _perPage,
      );
      emit(LoadedToDo(toDoList));
    } catch (e) {
      emit(ErrorToDoState('Failed to fetch data'));
    }
  }

  Future<void> _loadMoreTodos(
    LoadMoreTodos event,
    Emitter<ToDoState> emit,
  ) async {
    if (_isFetching) return;
    _isFetching = true;
    _currentPage++;
    try {
      final toDoList = await apiServices.fetchTodos(
        page: _currentPage,
        limit: _perPage,
      );
      final currentState = state;
      if (currentState is LoadedToDo) {
        emit(LoadedToDo([...currentState.todoList, ...toDoList]));
      } else {
        emit(LoadedToDo(toDoList));
      }
    } catch (e) {
      emit(ErrorToDoState('Failed to fetch more data'));
    } finally {
      _isFetching = false;
    }
  }

  Future<void> _addToDoEvents(
    AddToDoEvents event,
    Emitter<ToDoState> emit,
  ) async {
    try {
      final createdTodo = await apiServices.createTodo(event.toDo);
      if (createdTodo != null) {
        final currentState = state;
        if (currentState is LoadedToDo) {
          final updatedList = [createdTodo, ...currentState.todoList];
          emit(LoadedToDo(updatedList));
        } else {
          emit(LoadedToDo([createdTodo]));
        }
      }
    } catch (e) {
      log('Failed to add todo: $e');
      emit(ErrorToDoState('Failed to add data'));
    }
  }

  Future<void> _updateToDoEvent(
    UpdateToDoEvent event,
    Emitter<ToDoState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is LoadedToDo) {
        final updatedList =
            currentState.todoList.map((todo) {
              if (todo.title == event.todo.title) {
                return event.todo;
              }
              return todo;
            }).toList();

        updatedList.sort((a, b) {
          if (a.isCompleted && !b.isCompleted) return -1;
          if (!a.isCompleted && b.isCompleted) return 1;
          return 0;
        });

        emit(LoadedToDo(updatedList));
      }
    } catch (e) {
      log('Failed to update todo');
      emit(ErrorToDoState('Failed to update data'));
    }
  }

  Future<void> _deleteToDoEvent(
    DeleteToDoEvent event,
    Emitter<ToDoState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is LoadedToDo) {
        final updatedList =
            currentState.todoList
                .where((todo) => todo.id != event.todo.id)
                .toList();
        emit(LoadedToDo(updatedList));
      }
    } catch (e) {
      log('Failed to delete todo: $e');
      emit(ErrorToDoState('Failed to delete data'));
    }
  }
}
