import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/network/api_page.dart';
import '../../../core/network/table_query.dart';
import '../data/employment_models.dart';
import '../data/employment_repository.dart';

part 'employment_controller.g.dart';

@riverpod
EmploymentRepository employmentRepository(Ref ref) {
  ref.watch(sessionControllerProvider.select((session) => session.user?.id));
  return EmploymentRepository(ref.watch(sessionServiceProvider).api);
}

@Riverpod(retry: manualRetryOnly)
Future<ApiPage<Empleado>> empleadosPage(
  Ref ref,
  int pageIndex, {
  TableQuery query = const TableQuery(),
}) => ref.watch(employmentRepositoryProvider).list(pageIndex + 1, query: query);

@Riverpod(retry: manualRetryOnly)
Future<Empleado> empleadoDetail(Ref ref, String id) =>
    ref.watch(employmentRepositoryProvider).get(id);

@Riverpod(retry: manualRetryOnly)
Future<Contrato?> contratoVigenteDe(Ref ref, String empleadoId) =>
    ref.watch(employmentRepositoryProvider).contratoVigente(empleadoId);

@Riverpod(retry: manualRetryOnly)
Future<PersonSummary> personSummary(Ref ref, String personaId) =>
    ref.watch(employmentRepositoryProvider).persona(personaId);

@Riverpod(retry: manualRetryOnly)
Future<PosicionSummary> posicionSummary(Ref ref, String posicionId) =>
    ref.watch(employmentRepositoryProvider).posicion(posicionId);

@Riverpod(retry: manualRetryOnly)
Future<NamedRef> puestoRef(Ref ref, int puestoId) =>
    ref.watch(employmentRepositoryProvider).puesto(puestoId);

@Riverpod(retry: manualRetryOnly)
Future<NamedRef> estatusRef(Ref ref, int estatusId) =>
    ref.watch(employmentRepositoryProvider).estatus(estatusId);
