import 'package:flutter/material.dart' hide Title;
import 'package:flutter_architecture_lecture/domain/todo_logic.dart';
import 'package:flutter_architecture_lecture/main.dart';
import 'package:flutter_architecture_lecture/ui/title.dart';
import 'package:flutter_architecture_lecture/ui/todo_item.dart';
import 'package:flutter_architecture_lecture/ui/toolbar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController _newTodoController;
  late TodoLogic _todoLogic;

  @override
  void initState() {
    super.initState();

    _todoLogic = getIt.get<TodoLogic>();

    _newTodoController = TextEditingController();

    _todoLogic.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final filteredTodos = _todoLogic.getFilteredTodos();

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
              onSubmitted: (value) {
                _todoLogic.add(value);
                _newTodoController.clear();
              },
            ),
            const SizedBox(height: 42),
            const Toolbar(),
            if (_todoLogic.todos.isNotEmpty) const Divider(height: 0),
            for (var i = 0; i < filteredTodos.length; i++) ...[
              if (i > 0) const Divider(height: 0),
              Dismissible(
                key: ValueKey(filteredTodos[i].id),
                onDismissed: (_) {
                  _todoLogic.remove(filteredTodos[i]);
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
}
