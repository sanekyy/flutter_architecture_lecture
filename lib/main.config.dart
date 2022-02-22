// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'data/repositories/todo_repository.dart' as _i4;
import 'domain/id_generator.dart' as _i3;
import 'domain/todo_bloc.dart' as _i5;
import 'main.dart' as _i6; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final dependenciesModule = _$DependenciesModule();
  gh.singleton<_i3.IDGenerator>(dependenciesModule.idGenerator());
  gh.singleton<_i4.TodoRepository>(dependenciesModule.todoRepository());
  gh.lazySingleton<_i5.TodoBloc>(() => dependenciesModule.todoBloc(
      get<_i3.IDGenerator>(), get<_i4.TodoRepository>()));
  return get;
}

class _$DependenciesModule extends _i6.DependenciesModule {}
