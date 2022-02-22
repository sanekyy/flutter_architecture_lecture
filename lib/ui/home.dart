import 'package:flutter/material.dart' hide Title;
import 'package:flutter_architecture_lecture/data/models/todo_event.dart';
import 'package:flutter_architecture_lecture/domain/todo_bloc.dart';
import 'package:flutter_architecture_lecture/ui/title.dart';
import 'package:flutter_architecture_lecture/ui/todo_item.dart';
import 'package:flutter_architecture_lecture/ui/toolbar.dart';
import 'package:provider/provider.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final todoBloc = context.watch<TodoBloc>();
    final state = todoBloc.state;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
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
                  todoBloc.add(OnRemoveTodoEvent(state.filteredTodos[i]));
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
  }

  void _addTodo(String description) {
    context.read<TodoBloc>().add(OnAddTodoEvent(description));
    _newTodoController.clear();
  }
}
