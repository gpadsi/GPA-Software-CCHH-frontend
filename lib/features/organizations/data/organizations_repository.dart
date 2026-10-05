import 'package:dio/dio.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/network/api_page.dart';
import '../../../core/network/table_query.dart';
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

  Future<ApiPage<Company>> companies(
    int page, {
    TableQuery query = const TableQuery(),
  }) => fetchPage(
    api,
    'organizations/companies/',
    Company.fromJson,
    page: page,
    query: query,
  );

  Future<OrganizationNode> node(String id) async {
    final response = await api.get<Map<String, dynamic>>(
      'organizations/nodes/$id/',
    );
    return OrganizationNode.fromJson(response.data!);
  }

  // El servidor asigna la organización (tenant); el cliente nunca la manda.
  Future<OrganizationNode> saveNode(
    OrganizationNode node, {
    required bool creating,
  }) async {
    final payload = {
      'level': node.level,
      'parent': node.parent,
      'code': node.code,
      'name': node.name,
      'is_active': node.isActive,
    };
    final response = creating
        ? await api.post<Map<String, dynamic>>(
            'organizations/nodes/',
            data: payload,
          )
        : await api.patch<Map<String, dynamic>>(
            'organizations/nodes/${node.id}/',
            data: payload,
          );
    return OrganizationNode.fromJson(response.data!);
  }

  Future<void> deleteNode(String id) =>
      api.delete<void>('organizations/nodes/$id/');

  // Los datos legales: vacío viaja como null (= "pendiente"). Un RFC vacío no
  // puede viajar como texto: es único y dos empresas "pendientes" chocarían.
  static Map<String, dynamic> _legalPayload(Company company) => {
    'legal_name': _nullIfBlank(company.legalName),
    'rfc': _nullIfBlank(company.rfc),
    'employer_registration': _nullIfBlank(company.employerRegistration),
  };

  static String? _nullIfBlank(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? null : text;
  }

  /// Edita una empresa: sus datos legales y, si cambió, el nombre de su nodo
  /// (el nombre que se ve en las listas es el del nodo organizacional).
  Future<void> updateCompany(
    Company company, {
    required OrganizationNode node,
    required String name,
  }) async {
    if (name != node.name) {
      await saveNode(node.copyWith(name: name), creating: false);
    }
    await api.patch<Map<String, dynamic>>(
      'organizations/companies/${company.id}/',
      data: _legalPayload(company),
    );
  }

  /// Da de alta una empresa NUEVA: primero su nodo (nivel Empresa, sin padre)
  /// y luego sus datos legales. Si lo segundo falla se quita el nodo recién
  /// creado, para no dejar una empresa a medias en el organigrama.
  Future<void> createCompany({
    required int empresaLevel,
    required String code,
    required String name,
    required Company company,
  }) async {
    final node = await saveNode(
      OrganizationNode(
        id: '',
        tenant: 0,
        level: empresaLevel,
        code: code,
        name: name,
        isActive: true,
      ),
      creating: true,
    );
    try {
      await api.post<Map<String, dynamic>>(
        'organizations/companies/',
        data: {'organization_node': node.id, ..._legalPayload(company)},
      );
    } on Object {
      try {
        await deleteNode(node.id);
      } on Object {
        // Sin remedio desde aquí; se informa el error original.
      }
      rethrow;
    }
  }
}

/// Mensaje para una falla al guardar un nodo o una empresa: el motivo del
/// servidor si lo da.
String organizationMutationError(Object error) {
  if (error is DioException && error.response?.statusCode == 400) {
    final data = error.response?.data;
    if (data is Map && data.containsKey('non_field_errors')) {
      return 'Ya existe un nodo con ese código dentro del mismo padre. Usa otro código.';
    }
  }
  return validationDetail(
        error,
        labels: const {
          'name': 'Nombre',
          'code': 'Código',
          'level': 'Nivel',
          'parent': 'Nodo padre',
          'rfc': 'RFC',
          'legal_name': 'Razón social',
          'employer_registration': 'Registro patronal',
        },
      ) ??
      (error is DioException && error.response?.statusCode == 403
          ? 'Tu cuenta no tiene permiso para modificar la organización.'
          : apiErrorMessage(error));
}
