import 'package:flutter_architecture_lecture/data/repositories/todo_repository.dart';
import 'package:flutter_architecture_lecture/domain/id_generator.dart';
import 'package:flutter_architecture_lecture/main.dart';

class Assemble {
  final todoRepository = getIt.get<TodoRepository>();
  final idGenerator = getIt.get<IDGenerator>();

  Assemble();
}
