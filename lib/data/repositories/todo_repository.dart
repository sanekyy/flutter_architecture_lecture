import 'package:flutter_architecture_lecture/data/models/todo.dart';

class TodoRepository {
  final List<Todo> _todos;

  List<Todo> get todos => List.from(_todos);

  TodoRepository()
      : _todos = [
          const Todo(id: 'todo-0', description: 'hi'),
          const Todo(id: 'todo-1', description: 'hello'),
          const Todo(id: 'todo-2', description: 'bonjour'),
        ];

  void add(Todo todo) {
    _todos.add(todo);
  }

  void update(Todo todo) {
    final index = _todos.indexWhere((it) => it.id == todo.id);

    _todos.removeAt(index);
    _todos.insert(index, todo);
  }

  void remove(Todo todo) {
    _todos.removeWhere((it) => it.id == todo.id);
  }
}
