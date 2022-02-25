import 'package:flutter_architecture_lecture/data/models/todo.dart';
import 'package:flutter_architecture_lecture/data/models/todo_list_filter.dart';

class OnUpdateTodosAction {
  final List<Todo> todos;

  OnUpdateTodosAction(this.todos);
}

class OnSetFilterTodoAction {
  final TodoListFilter filter;

  OnSetFilterTodoAction(this.filter);
}
