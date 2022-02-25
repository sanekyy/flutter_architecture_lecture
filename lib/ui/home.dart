import 'package:flutter/material.dart' hide Title;
import 'package:flutter_architecture_lecture/data/models/todo_state.dart';
import 'package:flutter_architecture_lecture/domain/store.dart';
import 'package:flutter_architecture_lecture/domain/todo.dart';
import 'package:flutter_architecture_lecture/ui/title.dart';
import 'package:flutter_architecture_lecture/ui/todo_item.dart';
import 'package:flutter_architecture_lecture/ui/toolbar.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController _newTodoController;

  @override
  void initState() {
    super.initState();

    _newTodoController = TextEditingController();

    StoreProvider.of<GlobalState>(context, listen: false)
        .dispatch(OnInitThunk());
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<GlobalState, TodoState>(
        distinct: true,
        converter: (store) => store.state.todoState,
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              body: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                children: [
                  const Title(),
                  TextField(
                      controller: _newTodoController,
                      decoration: const InputDecoration(
                        labelText: 'What needs to be done?',
                      ),
                      onSubmitted: _addTodo),
                  const SizedBox(height: 42),
                  const Toolbar(),
                  if (state.todos.isNotEmpty) const Divider(height: 0),
                  for (var i = 0; i < state.filteredTodos.length; i++) ...[
                    if (i > 0) const Divider(height: 0),
                    Dismissible(
                      key: ValueKey(state.filteredTodos[i].id),
                      onDismissed: (_) {
                        StoreProvider.of<GlobalState>(context).dispatch(
                          OnRemoveTodoThunk(state.filteredTodos[i]),
                        );
                      },
                      child: TodoItem(
                        todo: state.filteredTodos[i],
                      ),
                    )
                  ],
                ],
              ),
            ),
          );
        });
  }

  void _addTodo(String description) {
    StoreProvider.of<GlobalState>(context).dispatch(
      OnAddTodoThunk(description),
    );
    _newTodoController.clear();
  }
}
