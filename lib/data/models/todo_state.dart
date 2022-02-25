import 'package:flutter_architecture_lecture/data/models/todo.dart';
import 'package:flutter_architecture_lecture/data/models/todo_list_filter.dart';

class TodoState {
  static const empty = TodoState(filter: TodoListFilter.all, todos: []);

  final TodoListFilter filter;
  final List<Todo> todos;

  List<Todo> get filteredTodos {
    switch (filter) {
      case TodoListFilter.completed:
        return todos.where((todo) => todo.completed).toList();
      case TodoListFilter.active:
        return todos.where((todo) => !todo.completed).toList();
      case TodoListFilter.all:
        return todos;
    }
  }

  const TodoState({
    required this.filter,
    required this.todos,
  });

  TodoState copyWith({
    TodoListFilter? filter,
    List<Todo>? todos,
  }) {
    return TodoState(
      filter: filter ?? this.filter,
      todos: todos ?? this.todos,
    );
  }
}
