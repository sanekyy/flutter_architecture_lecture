import 'package:flutter/material.dart' hide Title;
import 'package:flutter_architecture_lecture/data/repositories/todo_repository.dart';
import 'package:flutter_architecture_lecture/domain/id_generator.dart';
import 'package:flutter_architecture_lecture/domain/todo_logic.dart';
import 'package:flutter_architecture_lecture/ui/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

final idGeneratorProvider = Provider<IDGenerator>((ref) {
  return IDGenerator();
});

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepository();
});

final todoLogicProvider = ChangeNotifierProvider<TodoLogic>((ref) {
  return TodoLogic(
    idGenerator: ref.watch(idGeneratorProvider),
    todoRepository: ref.watch(todoRepositoryProvider),
  );
});

void main() {
  runApp(const ProviderScope(child: MyApp()));
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
