import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/network/api_page.dart';
import '../data/position_models.dart';
import '../data/positions_repository.dart';

part 'positions_controller.g.dart';

@riverpod
PositionsRepository positionsRepository(Ref ref) {
  ref.watch(sessionControllerProvider.select((session) => session.user?.id));
  return PositionsRepository(ref.watch(sessionServiceProvider).api);
}

@Riverpod(retry: manualRetryOnly)
Future<PositionCatalogs> positionCatalogs(Ref ref) =>
    ref.watch(positionsRepositoryProvider).catalogs();

@Riverpod(retry: manualRetryOnly)
Future<ApiPage<Posicion>> posicionesPage(Ref ref, int pageIndex) =>
    ref.watch(positionsRepositoryProvider).list(pageIndex + 1);

@Riverpod(retry: manualRetryOnly)
Future<List<Posicion>> allPosicionesForPicker(Ref ref) =>
    ref.watch(positionsRepositoryProvider).allForPicker();

@Riverpod(retry: manualRetryOnly)
Future<Posicion> posicionDetail(Ref ref, String id) =>
    ref.watch(positionsRepositoryProvider).get(id);
