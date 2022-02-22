import 'package:flutter/material.dart';
import 'package:flutter_architecture_lecture/data/models/todo.dart';
import 'package:flutter_architecture_lecture/data/models/todo_list_filter.dart';
import 'package:flutter_architecture_lecture/data/repositories/todo_repository.dart';
import 'package:flutter_architecture_lecture/domain/id_generator.dart';

class TodoLogic extends ChangeNotifier {
  final IDGenerator _idGenerator;
  final TodoRepository _todoRepository;

  late TodoListFilter _filter;

  TodoListFilter get filter => _filter;

  List<Todo> get todos => _todoRepository.todos;

  TodoLogic({
    required IDGenerator idGenerator,
    required TodoRepository todoRepository,
  })  : _idGenerator = idGenerator,
        _todoRepository = todoRepository,
        _filter = TodoListFilter.all;

  List<Todo> getFilteredTodos() {
    switch (_filter) {
      case TodoListFilter.completed:
        return todos.where((todo) => todo.completed).toList();
      case TodoListFilter.active:
        return todos.where((todo) => !todo.completed).toList();
      case TodoListFilter.all:
        return todos;
    }
  }

  void add(String description) {
    final todo = Todo(
      id: _idGenerator.generate(),
      description: description,
    );

    _todoRepository.add(todo);

    notifyListeners();
  }

  void edit({required String id, required String description}) {
    final todo = todos.firstWhere((it) => it.id == id);

    final updatedTodo = Todo(
      id: todo.id,
      completed: todo.completed,
      description: description,
    );

    _todoRepository.update(updatedTodo);

    notifyListeners();
  }

  void toggle(String id) {
    final todo = todos.firstWhere((it) => it.id == id);

    final updatedTodo = Todo(
      id: todo.id,
      completed: !todo.completed,
      description: todo.description,
    );

    _todoRepository.update(updatedTodo);

    notifyListeners();
  }

  void remove(Todo todo) {
    _todoRepository.remove(todo);

    notifyListeners();
  }

  void setFilter(TodoListFilter filter) {
    _filter = filter;
    notifyListeners();
  }
}
