import 'package:dio/dio.dart';

import '../../../core/network/api_page.dart';
import 'organization_models.dart';

class OrganizationsRepository {
  OrganizationsRepository(this.api);
  final Dio api;

  Future<OrganizationTree> tree() async {
    final tenants = fetchCatalog(
      api,
      'organizations/tenants/',
      OrganizationTenant.fromJson,
    );
    final levels = fetchCatalog(
      api,
      'organizations/levels/',
      OrganizationLevel.fromJson,
    );
    final nodes = fetchCatalog(
      api,
      'organizations/nodes/',
      OrganizationNode.fromJson,
    );
    // Future.wait instala manejadores de error en las tres cargas concurrentes.
    final result = await Future.wait<Object>([tenants, levels, nodes]);
    return OrganizationTree(
      tenants: result[0] as List<OrganizationTenant>,
      levels: result[1] as List<OrganizationLevel>,
      nodes: result[2] as List<OrganizationNode>,
    );
  }

  Future<ApiPage<Company>> companies(int page) =>
      fetchPage(api, 'organizations/companies/', Company.fromJson, page: page);

  Future<OrganizationNode> node(String id) async {
    final response = await api.get<Map<String, dynamic>>(
      'organizations/nodes/$id/',
    );
    return OrganizationNode.fromJson(response.data!);
  }
}
