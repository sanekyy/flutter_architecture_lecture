import 'package:flutter_architecture_lecture/data/models/todo.dart';
import 'package:flutter_architecture_lecture/data/models/todo_action.dart';
import 'package:flutter_architecture_lecture/data/models/todo_state.dart';
import 'package:flutter_architecture_lecture/domain/assemble.dart';
import 'package:flutter_architecture_lecture/domain/store.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

final todoReducers = combineReducers<TodoState>([
  TypedReducer<TodoState, OnSetFilterTodoAction>(_setFilter),
  TypedReducer<TodoState, OnUpdateTodosAction>(_updateTodos),
]);

TodoState _setFilter(TodoState state, OnSetFilterTodoAction action) {
  return state.copyWith(
    filter: action.filter,
  );
}

TodoState _updateTodos(TodoState state, OnUpdateTodosAction action) {
  return state.copyWith(
    todos: action.todos,
  );
}

class OnInitThunk
    extends CallableThunkActionWithExtraArgument<GlobalState, Assemble> {
  @override
  call(Store<GlobalState> store, Assemble assemble) {
    store.dispatch(OnUpdateTodosAction(assemble.todoRepository.todos));
  }
}

class OnAddTodoThunk
    extends CallableThunkActionWithExtraArgument<GlobalState, Assemble> {
  final String description;

  OnAddTodoThunk(this.description);

  @override
  call(Store<GlobalState> store, Assemble assemble) {
    final todo = Todo(
      id: assemble.idGenerator.generate(),
      description: description,
    );

    assemble.todoRepository.add(todo);

    store.dispatch(OnUpdateTodosAction(assemble.todoRepository.todos));
  }
}

class OnEditTodoThunk
    extends CallableThunkActionWithExtraArgument<GlobalState, Assemble> {
  final String id;
  final String description;

  OnEditTodoThunk({required this.id, required this.description});

  @override
  call(Store<GlobalState> store, Assemble assemble) {
    final todo = assemble.todoRepository.todos.firstWhere((it) => it.id == id);

    final updatedTodo = Todo(
      id: todo.id,
      completed: todo.completed,
      description: description,
    );

    assemble.todoRepository.update(updatedTodo);

    store.dispatch(OnUpdateTodosAction(assemble.todoRepository.todos));
  }
}

class OnToggleTodoThunk
    extends CallableThunkActionWithExtraArgument<GlobalState, Assemble> {
  final String id;

  OnToggleTodoThunk(this.id);

  @override
  call(Store<GlobalState> store, Assemble assemble) {
    final todo = assemble.todoRepository.todos.firstWhere((it) => it.id == id);

    final updatedTodo = Todo(
      id: todo.id,
      completed: !todo.completed,
      description: todo.description,
    );

    assemble.todoRepository.update(updatedTodo);

    store.dispatch(OnUpdateTodosAction(assemble.todoRepository.todos));
  }
}

class OnRemoveTodoThunk
    extends CallableThunkActionWithExtraArgument<GlobalState, Assemble> {
  final Todo todo;

  OnRemoveTodoThunk(this.todo);

  @override
  call(Store<GlobalState> store, Assemble assemble) {
    assemble.todoRepository.remove(todo);

    store.dispatch(OnUpdateTodosAction(assemble.todoRepository.todos));
  }
}
