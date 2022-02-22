import 'package:flutter/material.dart' hide Title;
import 'package:flutter_architecture_lecture/domain/todo_logic.dart';
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
    final todoLogic = context.watch<TodoLogic>();

    final filteredTodos = todoLogic.getFilteredTodos();

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
            if (todoLogic.todos.isNotEmpty) const Divider(height: 0),
            for (var i = 0; i < filteredTodos.length; i++) ...[
              if (i > 0) const Divider(height: 0),
              Dismissible(
                key: ValueKey(filteredTodos[i].id),
                onDismissed: (_) {
                  todoLogic.remove(filteredTodos[i]);
                },
                child: TodoItem(
                  todo: filteredTodos[i],
                ),
              )
            ],
          ],
        ),
      ),
    );
  }

  void _addTodo(String description) {
    context.read<TodoLogic>().add(description);
    _newTodoController.clear();
  }
}
