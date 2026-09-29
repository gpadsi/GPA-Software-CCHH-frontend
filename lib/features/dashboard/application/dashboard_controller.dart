import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/auth/session_controller.dart';
import '../data/dashboard_repository.dart';

part 'dashboard_controller.g.dart';

@riverpod
Future<int> dashboardCount(Ref ref, DashboardMetric metric) {
  final userId = ref.watch(
    sessionControllerProvider.select((session) => session.user?.id),
  );
  if (userId == null) throw StateError('Sin sesión');
  return DashboardRepository(ref.watch(sessionServiceProvider).api)
      .count(metric);
}
