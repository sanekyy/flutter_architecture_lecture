import 'package:flutter/material.dart';
import 'package:flutter_architecture_lecture/data/models/todo_action.dart';
import 'package:flutter_architecture_lecture/data/models/todo_list_filter.dart';
import 'package:flutter_architecture_lecture/data/models/todo_state.dart';
import 'package:flutter_architecture_lecture/domain/store.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<GlobalState, TodoState>(
        distinct: true,
        converter: (store) => store.state.todoState,
        builder: (context, state) {
          Color? textColorFor(TodoListFilter value) {
            return state.filter == value ? Colors.blue : Colors.black;
          }

          final uncompletedTodosCount =
              state.todos.where((todo) => !todo.completed).length;

          return Material(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '$uncompletedTodosCount items left',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Tooltip(
                  message: 'All todos',
                  child: TextButton(
                    onPressed: () =>
                        StoreProvider.of<GlobalState>(context).dispatch(
                      OnSetFilterTodoAction(TodoListFilter.all),
                    ),
                    style: ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      foregroundColor: MaterialStateProperty.all(
                          textColorFor(TodoListFilter.all)),
                    ),
                    child: const Text('All'),
                  ),
                ),
                Tooltip(
                  message: 'Only uncompleted todos',
                  child: TextButton(
                    onPressed: () =>
                        StoreProvider.of<GlobalState>(context).dispatch(
                      OnSetFilterTodoAction(TodoListFilter.active),
                    ),
                    style: ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      foregroundColor: MaterialStateProperty.all(
                        textColorFor(TodoListFilter.active),
                      ),
                    ),
                    child: const Text('Active'),
                  ),
                ),
                Tooltip(
                  message: 'Only completed todos',
                  child: TextButton(
                    onPressed: () =>
                        StoreProvider.of<GlobalState>(context).dispatch(
                      OnSetFilterTodoAction(TodoListFilter.completed),
                    ),
                    style: ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      foregroundColor: MaterialStateProperty.all(
                        textColorFor(TodoListFilter.completed),
                      ),
                    ),
                    child: const Text('Completed'),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
