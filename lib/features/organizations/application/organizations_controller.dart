import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/network/api_page.dart';
import '../../../core/network/table_query.dart';
import '../data/organization_models.dart';
import '../data/organizations_repository.dart';
part 'organizations_controller.g.dart';

@riverpod
OrganizationsRepository organizationsRepository(Ref ref) {
  ref.watch(sessionControllerProvider.select((session) => session.user?.id));
  return OrganizationsRepository(ref.watch(sessionServiceProvider).api);
}

@Riverpod(retry: manualRetryOnly)
Future<OrganizationTree> organizationTree(Ref ref) =>
    ref.watch(organizationsRepositoryProvider).tree();

@Riverpod(retry: manualRetryOnly)
Future<ApiPage<Company>> companiesPage(
  Ref ref,
  int pageIndex, {
  TableQuery query = const TableQuery(),
}) => ref
    .watch(organizationsRepositoryProvider)
    .companies(pageIndex + 1, query: query);

@Riverpod(retry: manualRetryOnly)
Future<OrganizationNode> companyNode(Ref ref, String id) =>
    ref.watch(organizationsRepositoryProvider).node(id);
