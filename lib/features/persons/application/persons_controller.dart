import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/network/api_page.dart';
import '../data/person_models.dart';
import '../data/persons_repository.dart';

part 'persons_controller.g.dart';

@riverpod
PersonsRepository personsRepository(Ref ref) {
  ref.watch(sessionControllerProvider.select((session) => session.user?.id));
  return PersonsRepository(ref.watch(sessionServiceProvider).api);
}

@Riverpod(retry: manualRetryOnly)
Future<PersonCatalogs> personCatalogs(Ref ref) =>
    ref.watch(personsRepositoryProvider).catalogs();

@Riverpod(retry: manualRetryOnly)
Future<ApiPage<Persona>> personsPage(Ref ref, int pageIndex) =>
    ref.watch(personsRepositoryProvider).list(pageIndex + 1);

@Riverpod(retry: manualRetryOnly)
Future<Persona> personDetail(Ref ref, String id) =>
    ref.watch(personsRepositoryProvider).get(id);

@Riverpod(retry: manualRetryOnly)
Future<List<ContactoUrgencia>> contactosDePersona(Ref ref, String personaId) =>
    ref.watch(personsRepositoryProvider).contactosDe(personaId);

@Riverpod(retry: manualRetryOnly)
Future<PerfilMedico?> perfilMedicoDePersona(Ref ref, String personaId) =>
    ref.watch(personsRepositoryProvider).perfilDe(personaId);
