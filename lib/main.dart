import 'package:flutter/material.dart' hide Title;
import 'package:flutter_architecture_lecture/data/repositories/todo_repository.dart';
import 'package:flutter_architecture_lecture/domain/id_generator.dart';
import 'package:flutter_architecture_lecture/domain/todo_logic.dart';
import 'package:flutter_architecture_lecture/main.config.dart';
import 'package:flutter_architecture_lecture/ui/home.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => $initGetIt(getIt);

@module
abstract class DependenciesModule {
  @singleton
  IDGenerator idGenerator() => IDGenerator();

  @singleton
  TodoRepository todoRepository() => TodoRepository();

  @lazySingleton
  TodoLogic todoLogic(IDGenerator idGenerator, TodoRepository todoRepository) =>
      TodoLogic(
        idGenerator: idGenerator,
        todoRepository: todoRepository,
      );
}

void main() {
  configureDependencies();
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
