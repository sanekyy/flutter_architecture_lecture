import 'package:flutter_architecture_lecture/data/models/todo.dart';
import 'package:flutter_architecture_lecture/data/models/todo_bloc_state.dart';
import 'package:flutter_architecture_lecture/data/models/todo_event.dart';
import 'package:flutter_architecture_lecture/data/models/todo_list_filter.dart';
import 'package:flutter_architecture_lecture/data/repositories/todo_repository.dart';
import 'package:flutter_architecture_lecture/domain/id_generator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final IDGenerator _idGenerator;
  final TodoRepository _todoRepository;

  TodoBloc({
    required IDGenerator idGenerator,
    required TodoRepository todoRepository,
  })  : _idGenerator = idGenerator,
        _todoRepository = todoRepository,
        super(
          TodoState(
            filter: TodoListFilter.all,
            todos: todoRepository.todos,
          ),
        ) {
    on(_add);
    on(_edit);
    on(_toggle);
    on(_remove);
    on(_setFilter);
  }

  void _add(OnAddTodoEvent event, Emitter<TodoState> emit) {
    final todo = Todo(
      id: _idGenerator.generate(),
      description: event.description,
    );

    _todoRepository.add(todo);

    emit(
      state.copyWith(
        todos: _todoRepository.todos,
      ),
    );
  }

  void _edit(OnEditTodoEvent event, Emitter<TodoState> emit) {
    final todo = _todoRepository.todos.firstWhere((it) => it.id == event.id);

    final updatedTodo = Todo(
      id: todo.id,
      completed: todo.completed,
      description: event.description,
    );

    _todoRepository.update(updatedTodo);

    emit(
      state.copyWith(
        todos: _todoRepository.todos,
      ),
    );
  }

  void _toggle(OnToggleTodoEvent event, Emitter<TodoState> emit) {
    final todo = _todoRepository.todos.firstWhere((it) => it.id == event.id);

    final updatedTodo = Todo(
      id: todo.id,
      completed: !todo.completed,
      description: todo.description,
    );

    _todoRepository.update(updatedTodo);

    emit(
      state.copyWith(
        todos: _todoRepository.todos,
      ),
    );
  }

  void _remove(OnRemoveTodoEvent event, Emitter<TodoState> emit) {
    _todoRepository.remove(event.todo);

    emit(
      state.copyWith(
        todos: _todoRepository.todos,
      ),
    );
  }

  void _setFilter(OnSetFilterTodoEvent event, Emitter<TodoState> emit) {
    emit(
      state.copyWith(
        filter: event.filter,
      ),
    );
  }
}
