import 'package:flutter_architecture_lecture/data/models/todo.dart';
import 'package:flutter_architecture_lecture/data/models/todo_list_filter.dart';

abstract class TodoEvent {
  const TodoEvent();
}

class OnAddTodoEvent implements TodoEvent {
  final String description;

  OnAddTodoEvent(this.description);
}

class OnEditTodoEvent implements TodoEvent {
  final String id;
  final String description;

  OnEditTodoEvent(this.id, this.description);
}

class OnToggleTodoEvent implements TodoEvent {
  final String id;

  OnToggleTodoEvent(this.id);
}

class OnRemoveTodoEvent implements TodoEvent {
  final Todo todo;

  OnRemoveTodoEvent(this.todo);
}

class OnSetFilterTodoEvent implements TodoEvent {
  final TodoListFilter filter;

  OnSetFilterTodoEvent(this.filter);
}
