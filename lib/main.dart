import 'package:flutter/material.dart' hide Title;
import 'package:flutter_architecture_lecture/data/repositories/todo_repository.dart';
import 'package:flutter_architecture_lecture/domain/id_generator.dart';
import 'package:flutter_architecture_lecture/domain/todo_logic.dart';
import 'package:flutter_architecture_lecture/ui/home.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void _setup() {
  getIt.registerSingleton<IDGenerator>(IDGenerator());
  getIt.registerSingleton<TodoRepository>(TodoRepository());
  getIt.registerLazySingleton(
    () => TodoLogic(
      idGenerator: getIt.get<IDGenerator>(),
      todoRepository: getIt.get<TodoRepository>(),
    ),
  );
}

void main() {
  _setup();
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
