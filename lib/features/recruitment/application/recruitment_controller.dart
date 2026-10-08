import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/network/api_page.dart';
import '../../../core/network/table_query.dart';
import '../data/recruitment_catalogs.dart';
import '../data/recruitment_models.dart';
import '../data/recruitment_repository.dart';

part 'recruitment_controller.g.dart';

final posicionContextoProvider = FutureProvider.autoDispose
    .family<PosicionContexto, (String, String)>(
      (ref, key) => ref
          .watch(recruitmentRepositoryProvider)
          .posicionContexto(key.$1, para: key.$2),
      retry: manualRetryOnly,
    );

@riverpod
RecruitmentRepository recruitmentRepository(Ref ref) {
  ref.watch(sessionControllerProvider.select((session) => session.user?.id));
  return RecruitmentRepository(ref.watch(sessionServiceProvider).api);
}

@Riverpod(retry: manualRetryOnly)
Future<RequisicionCatalogs> requisicionCatalogs(Ref ref) async {
  final repository = ref.watch(recruitmentRepositoryProvider);
  final results = await Future.wait([
    repository.estados(),
    repository.etapasAprobacion(),
    repository.tiposContrato(),
    repository.horariosACubrir(),
    repository.tiposRequisicion(),
  ]);
  return RequisicionCatalogs(
    estados: results[0],
    etapas: results[1],
    tiposContrato: results[2],
    horarios: results[3],
    tipos: results[4],
  );
}

@Riverpod(retry: manualRetryOnly)
Future<DescriptivoCatalogs> descriptivoCatalogs(Ref ref) async {
  final repository = ref.watch(recruitmentRepositoryProvider);
  final results = await Future.wait([
    repository.rangosEdad(),
    repository.diasPorLaborar(),
    repository.horariosACubrir(),
    repository.competencias(),
    repository.recursos(),
    repository.rolesConformidad(),
  ]);
  return DescriptivoCatalogs(
    rangosEdad: results[0],
    dias: results[1],
    horarios: results[2],
    competencias: results[3],
    recursos: results[4],
    roles: results[5],
  );
}

@Riverpod(retry: manualRetryOnly)
Future<ApiPage<Requisicion>> requisicionesPage(
  Ref ref,
  int pageIndex, {
  TableQuery query = const TableQuery(),
}) => ref
    .watch(recruitmentRepositoryProvider)
    .requisiciones(pageIndex + 1, query: query);

@Riverpod(retry: manualRetryOnly)
Future<Requisicion> requisicionDetail(Ref ref, String id) =>
    ref.watch(recruitmentRepositoryProvider).requisicion(id);

@Riverpod(retry: manualRetryOnly)
Future<ApiPage<Descriptivo>> descriptivosPage(
  Ref ref,
  int pageIndex, {
  TableQuery query = const TableQuery(),
}) => ref
    .watch(recruitmentRepositoryProvider)
    .descriptivos(pageIndex + 1, query: query);

@Riverpod(retry: manualRetryOnly)
Future<Descriptivo> descriptivoDetail(Ref ref, String id) =>
    ref.watch(recruitmentRepositoryProvider).descriptivo(id);
