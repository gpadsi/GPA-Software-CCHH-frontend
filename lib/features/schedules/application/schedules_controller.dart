import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/network/api_page.dart';
import '../../../core/network/table_query.dart';
import '../data/schedule_models.dart';
import '../data/schedules_repository.dart';

part 'schedules_controller.g.dart';

@riverpod
SchedulesRepository schedulesRepository(Ref ref) {
  ref.watch(sessionControllerProvider.select((session) => session.user?.id));
  return SchedulesRepository(ref.watch(sessionServiceProvider).api);
}

@Riverpod(retry: manualRetryOnly)
Future<ApiPage<Catorcena>> catorcenasPage(
  Ref ref,
  int pageIndex, {
  TableQuery query = const TableQuery(),
}) => ref
    .watch(schedulesRepositoryProvider)
    .catorcenasPage(pageIndex + 1, query: query);

@Riverpod(retry: manualRetryOnly)
Future<List<Catorcena>> allCatorcenas(Ref ref) =>
    ref.watch(schedulesRepositoryProvider).allCatorcenas();

@Riverpod(retry: manualRetryOnly)
Future<List<TipoHorarioRef>> tiposHorarioCatalog(Ref ref) =>
    ref.watch(schedulesRepositoryProvider).tiposHorario();

@Riverpod(retry: manualRetryOnly)
Future<List<AreaRef>> areasCatalog(Ref ref) =>
    ref.watch(schedulesRepositoryProvider).areas();

@Riverpod(retry: manualRetryOnly)
Future<List<EmpleadoRef>> allEmpleadosForPicker(Ref ref) =>
    ref.watch(schedulesRepositoryProvider).allEmpleados();

@Riverpod(retry: manualRetryOnly)
Future<EmpleadoRef> empleadoRef(Ref ref, String id) =>
    ref.watch(schedulesRepositoryProvider).empleado(id);

@Riverpod(retry: manualRetryOnly)
Future<ApiPage<AsignacionHorario>> asignacionesHorarioPage(
  Ref ref,
  int pageIndex, {
  TableQuery query = const TableQuery(),
}) => ref
    .watch(schedulesRepositoryProvider)
    .asignacionesHorarioPage(pageIndex + 1, query: query);

@Riverpod(retry: manualRetryOnly)
Future<ApiPage<AsignacionUbicacion>> asignacionesUbicacionPage(
  Ref ref,
  int pageIndex, {
  TableQuery query = const TableQuery(),
}) => ref
    .watch(schedulesRepositoryProvider)
    .asignacionesUbicacionPage(pageIndex + 1, query: query);
