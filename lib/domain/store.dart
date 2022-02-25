import 'package:flutter_architecture_lecture/data/models/todo_state.dart';
import 'package:flutter_architecture_lecture/domain/assemble.dart';
import 'package:flutter_architecture_lecture/domain/todo.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

final globalStore = Store<GlobalState>(
  _globalReducer,
  initialState: GlobalState.initState,
  middleware: [ExtraArgumentThunkMiddleware(Assemble())],
);

GlobalState _globalReducer(GlobalState state, action) => GlobalState(
      todoReducers(state.todoState, action),
    );

class GlobalState {
  static const initState = GlobalState(TodoState.empty);

  final TodoState todoState;

  const GlobalState(this.todoState);
}
