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
      log('Fetched ${toDoList.length} todos');
      emit(LoadedToDo(toDoList));
    } catch (e) {
      log('Error fetching todos: $e');
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
      log('Adding todo: ${event.toDo.title}');

      // For local testing, create a todo with a unique ID
      final currentState = state;
      int newId = DateTime.now().millisecondsSinceEpoch; // Generate unique ID

      if (currentState is LoadedToDo) {
        // Create a new todo with a unique ID
        final newTodo = Todo(
          id: newId,
          title: event.toDo.title,
          isCompleted: false,
          userId: event.toDo.userId,
        );

        log('Created new todo with ID: ${newTodo.id}');

        // Add to the beginning of the list
        final updatedList = [newTodo, ...currentState.todoList];
        emit(LoadedToDo(updatedList));

        log('Todo added successfully. Total todos: ${updatedList.length}');
      } else {
        // If no current state, create new list
        final newTodo = Todo(
          id: newId,
          title: event.toDo.title,
          isCompleted: false,
          userId: event.toDo.userId,
        );
        emit(LoadedToDo([newTodo]));
        log('Created first todo in empty list');
      }

      // Optionally, try to sync with API in background
      _syncWithAPI(event.toDo);
    } catch (e) {
      log('Failed to add todo: $e');
      emit(ErrorToDoState('Failed to add data'));
    }
  }

  // Background sync with API (optional)
  Future<void> _syncWithAPI(Todo todo) async {
    try {
      final createdTodo = await apiServices.createTodo(todo);
      if (createdTodo != null) {
        log('Todo synced with API: ${createdTodo.id}');
      }
    } catch (e) {
      log('Failed to sync with API: $e');
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
              if (todo.id == event.todo.id) {
                // Fixed: use ID instead of title
                return event.todo;
              }
              return todo;
            }).toList();

        // Sort: incomplete first, then completed
        updatedList.sort((a, b) {
          if (!a.isCompleted && b.isCompleted) return -1;
          if (a.isCompleted && !b.isCompleted) return 1;
          return 0;
        });

        emit(LoadedToDo(updatedList));
        log(
          'Todo updated: ${event.todo.title}, completed: ${event.todo.isCompleted}',
        );
      }
    } catch (e) {
      log('Failed to update todo: $e');
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
        log('Todo deleted: ${event.todo.title}');
      }
    } catch (e) {
      log('Failed to delete todo: $e');
      emit(ErrorToDoState('Failed to delete data'));
    }
  }
}
