import 'package:flutter/material.dart';
import 'package:flutter_architecture_lecture/data/models/todo_list_filter.dart';
import 'package:flutter_architecture_lecture/data/models/todo_logic_state.dart';
import 'package:flutter_architecture_lecture/domain/todo_logic.dart';
import 'package:provider/provider.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todoLogic = context.watch<TodoLogic>();

    return StreamBuilder<TodoLogicState>(
      initialData: todoLogic.state,
      stream: todoLogic.stateStream,
      builder: (_, snapshot) {
        final state = snapshot.requireData;

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
                  onPressed: () => todoLogic.setFilter(TodoListFilter.all),
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
                  onPressed: () => todoLogic.setFilter(TodoListFilter.active),
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
                      todoLogic.setFilter(TodoListFilter.completed),
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
      },
    );
  }
}
