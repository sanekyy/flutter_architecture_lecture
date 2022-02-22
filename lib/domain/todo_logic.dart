import 'dart:async';

import 'package:flutter_architecture_lecture/data/models/todo.dart';
import 'package:flutter_architecture_lecture/data/models/todo_list_filter.dart';
import 'package:flutter_architecture_lecture/data/models/todo_logic_state.dart';
import 'package:flutter_architecture_lecture/data/repositories/todo_repository.dart';
import 'package:flutter_architecture_lecture/domain/id_generator.dart';
import 'package:rxdart/rxdart.dart';

class TodoLogic {
  final IDGenerator _idGenerator;
  final TodoRepository _todoRepository;

  final _subject = BehaviorSubject<TodoLogicState>();

  TodoLogicState get state => _subject.value;

  Stream<TodoLogicState> get stateStream => _subject;

  TodoLogic({
    required IDGenerator idGenerator,
    required TodoRepository todoRepository,
  })  : _idGenerator = idGenerator,
        _todoRepository = todoRepository {
    _subject.add(
      TodoLogicState(
        filter: TodoListFilter.all,
        todos: todoRepository.todos,
      ),
    );
  }

  void add(String description) {
    final todo = Todo(
      id: _idGenerator.generate(),
      description: description,
    );

    _todoRepository.add(todo);

    _subject.add(
      _subject.value.copyWith(
        todos: _todoRepository.todos,
      ),
    );
  }

  void edit({required String id, required String description}) {
    final todo = _todoRepository.todos.firstWhere((it) => it.id == id);

    final updatedTodo = Todo(
      id: todo.id,
      completed: todo.completed,
      description: description,
    );

    _todoRepository.update(updatedTodo);

    _subject.add(
      _subject.value.copyWith(
        todos: _todoRepository.todos,
      ),
    );
  }

  void toggle(String id) {
    final todo = _todoRepository.todos.firstWhere((it) => it.id == id);

    final updatedTodo = Todo(
      id: todo.id,
      completed: !todo.completed,
      description: todo.description,
    );

    _todoRepository.update(updatedTodo);

    _subject.add(
      _subject.value.copyWith(
        todos: _todoRepository.todos,
      ),
    );
  }

  void remove(Todo todo) {
    _todoRepository.remove(todo);

    _subject.add(
      _subject.value.copyWith(
        todos: _todoRepository.todos,
      ),
    );
  }

  void setFilter(TodoListFilter filter) {
    _subject.add(
      _subject.value.copyWith(
        filter: filter,
      ),
    );
  }
}
