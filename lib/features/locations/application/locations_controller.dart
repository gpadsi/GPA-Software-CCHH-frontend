import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/network/api_page.dart';
import '../../../core/network/table_query.dart';
import '../data/location_models.dart';
import '../data/locations_repository.dart';
part 'locations_controller.g.dart';

@riverpod
LocationsRepository locationsRepository(Ref ref) {
  ref.watch(sessionControllerProvider.select((session) => session.user?.id));
  return LocationsRepository(ref.watch(sessionServiceProvider).api);
}

@Riverpod(retry: manualRetryOnly)
Future<ApiPage<LocationRecord>> locationPage(
  Ref ref,
  LocationKind kind,
  int pageIndex, {
  TableQuery query = const TableQuery(),
}) => ref
    .watch(locationsRepositoryProvider)
    .list(kind, pageIndex + 1, query: query);

@Riverpod(retry: manualRetryOnly)
Future<LocationCatalog> locationCatalog(Ref ref) =>
    ref.watch(locationsRepositoryProvider).catalog();
