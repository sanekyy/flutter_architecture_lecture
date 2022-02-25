import 'package:flutter/material.dart' hide Title;
import 'package:flutter_architecture_lecture/data/repositories/todo_repository.dart';
import 'package:flutter_architecture_lecture/domain/id_generator.dart';
import 'package:flutter_architecture_lecture/domain/store.dart';
import 'package:flutter_architecture_lecture/domain/todo.dart';
import 'package:flutter_architecture_lecture/main.config.dart';
import 'package:flutter_architecture_lecture/ui/home.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:provider/provider.dart';
import 'package:flutter_redux/flutter_redux.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => $initGetIt(getIt);

@module
abstract class DependenciesModule {
  @singleton
  IDGenerator idGenerator() => IDGenerator();

  @singleton
  TodoRepository todoRepository() => TodoRepository();
}

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<GlobalState>(
      store: globalStore,
      child: const MaterialApp(
        home: Home(),
      ),
    );
  }
}
