import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

@immutable
class Todo {
  const Todo({
    required this.description,
    required this.id,
    this.completed = false,
  });

  final String id;
  final String description;
  final bool completed;

  @override
  String toString() {
    return 'Todo(description: $description, completed: $completed)';
  }
}

/// The different ways to filter the list of todos
enum TodoListFilter {
  all,
  active,
  completed,
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController _newTodoController;
  late TodoListFilter _filter;
  late List<Todo> _todos;

  @override
  void initState() {
    super.initState();

    _newTodoController = TextEditingController();
    _filter = TodoListFilter.all;
    _todos = const [
      Todo(id: 'todo-0', description: 'hi'),
      Todo(id: 'todo-1', description: 'hello'),
      Todo(id: 'todo-2', description: 'bonjour'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final filteredTodos = _getFilteredTodos();

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
                _add(value);
                _newTodoController.clear();
              },
            ),
            const SizedBox(height: 42),
            Toolbar(
              todos: _todos,
              filter: _filter,
              setFilter: (filter) => setState(() => _filter = filter),
            ),
            if (_todos.isNotEmpty) const Divider(height: 0),
            for (var i = 0; i < filteredTodos.length; i++) ...[
              if (i > 0) const Divider(height: 0),
              Dismissible(
                key: ValueKey(filteredTodos[i].id),
                onDismissed: (_) {
                  _remove(filteredTodos[i]);
                },
                child: TodoItem(
                  todo: filteredTodos[i],
                  editDescription: (value) => _edit(
                    id: filteredTodos[i].id,
                    description: value,
                  ),
                  toggle: () => _toggle(filteredTodos[i].id),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }

  List<Todo> _getFilteredTodos() {
    switch (_filter) {
      case TodoListFilter.completed:
        return _todos.where((todo) => todo.completed).toList();
      case TodoListFilter.active:
        return _todos.where((todo) => !todo.completed).toList();
      case TodoListFilter.all:
        return _todos;
    }
  }

  void _add(String description) {
    setState(() {
      _todos = [
        ..._todos,
        Todo(
          id: _uuid.v4(),
          description: description,
        ),
      ];
    });
  }

  void _edit({required String id, required String description}) {
    setState(() {
      _todos = [
        for (final todo in _todos)
          if (todo.id == id)
            Todo(
              id: todo.id,
              completed: todo.completed,
              description: description,
            )
          else
            todo,
      ];
    });
  }

  void _toggle(String id) {
    setState(() {
      _todos = [
        for (final todo in _todos)
          if (todo.id == id)
            Todo(
              id: todo.id,
              completed: !todo.completed,
              description: todo.description,
            )
          else
            todo,
      ];
    });
  }

  void _remove(Todo target) {
    setState(() {
      _todos = _todos.where((todo) => todo.id != target.id).toList();
    });
  }
}

class Toolbar extends StatelessWidget {
  const Toolbar({
    Key? key,
    required this.todos,
    required this.filter,
    required this.setFilter,
  }) : super(key: key);

  final List<Todo> todos;
  final TodoListFilter filter;
  final ValueSetter<TodoListFilter> setFilter;

  @override
  Widget build(BuildContext context) {
    Color? textColorFor(TodoListFilter value) {
      return filter == value ? Colors.blue : Colors.black;
    }

    final uncompletedTodosCount = todos.where((todo) => !todo.completed).length;

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
              onPressed: () => setFilter(TodoListFilter.all),
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor:
                    MaterialStateProperty.all(textColorFor(TodoListFilter.all)),
              ),
              child: const Text('All'),
            ),
          ),
          Tooltip(
            message: 'Only uncompleted todos',
            child: TextButton(
              onPressed: () => setFilter(TodoListFilter.active),
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
              onPressed: () => setFilter(TodoListFilter.completed),
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
  }
}

class Title extends StatelessWidget {
  const Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'todos',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color.fromARGB(38, 47, 47, 247),
        fontSize: 100,
        fontWeight: FontWeight.w100,
        fontFamily: 'Helvetica Neue',
      ),
    );
  }
}

class TodoItem extends StatefulWidget {
  const TodoItem({
    Key? key,
    required this.todo,
    required this.editDescription,
    required this.toggle,
  }) : super(key: key);

  final Todo todo;
  final ValueSetter<String> editDescription;
  final VoidCallback toggle;

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  late final FocusNode _itemFocusNode;
  var _isFocused = false;
  late final FocusNode _textFieldFocusNode;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();

    _itemFocusNode = FocusNode();
    _itemFocusNode.addListener(() {
      setState(() => _isFocused = _itemFocusNode.hasFocus);
    });

    _textFieldFocusNode = FocusNode();

    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 6,
      child: Focus(
        focusNode: _itemFocusNode,
        onFocusChange: (focused) {
          if (focused) {
            _textEditingController.text = widget.todo.description;
          } else {
            // Commit changes only when the textfield is unfocused, for performance
            widget.editDescription(_textEditingController.text);
          }
        },
        child: ListTile(
          onTap: () {
            _itemFocusNode.requestFocus();
            _textFieldFocusNode.requestFocus();
          },
          leading: Checkbox(
            value: widget.todo.completed,
            onChanged: (value) => widget.toggle(),
          ),
          title: _isFocused
              ? TextField(
                  autofocus: true,
                  focusNode: _textFieldFocusNode,
                  controller: _textEditingController,
                )
              : Text(widget.todo.description),
        ),
      ),
    );
  }
}
