import 'package:flutter/material.dart';
import 'package:flutter_architecture_lecture/data/models/todo.dart';
import 'package:flutter_architecture_lecture/domain/todo_logic.dart';
import 'package:flutter_architecture_lecture/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoItem extends ConsumerStatefulWidget {
  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final Todo todo;

  @override
  _TodoItemState createState() => _TodoItemState();
}

class _TodoItemState extends ConsumerState<TodoItem> {
  late final TodoLogic _todoLogic;
  late final FocusNode _itemFocusNode;
  var _isFocused = false;
  late final FocusNode _textFieldFocusNode;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();

    _todoLogic = ref.read(todoLogicProvider);

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
            _todoLogic.edit(
              id: widget.todo.id,
              description: _textEditingController.text,
            );
          }
        },
        child: ListTile(
          onTap: () {
            _itemFocusNode.requestFocus();
            _textFieldFocusNode.requestFocus();
          },
          leading: Checkbox(
            value: widget.todo.completed,
            onChanged: (value) => _todoLogic.toggle(widget.todo.id),
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
