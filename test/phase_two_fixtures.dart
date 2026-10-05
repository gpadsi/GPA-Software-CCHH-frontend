import 'package:capital_humano_front/core/network/table_query.dart';
import 'package:capital_humano_front/core/network/api_page.dart';
import 'package:capital_humano_front/features/locations/data/location_models.dart';
import 'package:capital_humano_front/features/locations/data/locations_repository.dart';
import 'package:capital_humano_front/features/organizations/data/organization_models.dart';
import 'package:capital_humano_front/features/organizations/data/organizations_repository.dart';
import 'package:dio/dio.dart';

const locationA = LocationRecord(id: 'u1', code: 'MATRIZ', name: 'Matriz');
const locationB = LocationRecord(id: 'u2', code: 'SUR', name: 'Sucursal sur');
const naveA = LocationRecord(id: 'n1', code: 'N1', ubicacion: 'u1');
const naveB = LocationRecord(
  id: 'n2',
  code: 'N2',
  name: 'Nave sur',
  ubicacion: 'u2',
);
const areaA = LocationRecord(
  id: 'a1',
  code: 'AREA',
  name: 'Área sin confirmar',
);
const rootNode = OrganizationNode(
  id: 'root',
  tenant: 1,
  level: 1,
  code: 'GPA',
  name: 'Empresa de prueba',
  isActive: true,
);
const childNode = OrganizationNode(
  id: 'child',
  tenant: 1,
  level: 2,
  parent: 'root',
  code: 'NEGOCIO',
  name: 'Unidad de negocio',
  isActive: true,
);
const grandchildNode = OrganizationNode(
  id: 'grandchild',
  tenant: 1,
  level: 2,
  parent: 'child',
  code: 'UNIDAD',
  name: 'Unidad anidada',
  isActive: false,
);
const companyA = Company(id: 'c1', organizationNode: 'root');

class FakeOrganizationsRepository extends OrganizationsRepository {
  TableQuery lastQuery = const TableQuery();
  FakeOrganizationsRepository() : super(Dio());
  final requestedPages = <int>[];
  Object? failure;
  @override
  Future<OrganizationTree> tree() async {
    if (failure != null) throw failure!;
    return const OrganizationTree(
      tenants: [OrganizationTenant(id: 1, code: 'GPA', name: 'Grupo GPA')],
      levels: [
        OrganizationLevel(
          id: 1,
          numero: 1,
          code: 'empresa',
          name: 'Empresa',
          allowsRecursiveNesting: false,
        ),
        OrganizationLevel(
          id: 2,
          numero: 2,
          code: 'unidad',
          name: 'Unidad',
          allowsRecursiveNesting: true,
        ),
      ],
      nodes: [rootNode, childNode, grandchildNode],
    );
  }

  @override
  Future<ApiPage<Company>> companies(
    int page, {
    TableQuery query = const TableQuery(),
  }) async {
    lastQuery = query;
    requestedPages.add(page);
    if (failure != null) throw failure!;
    return ApiPage(
      count: 26,
      results: [
        page == 1
            ? companyA
            : companyA.copyWith(legalName: 'Empresa segunda página'),
      ],
    );
  }

  @override
  Future<OrganizationNode> node(String id) async => rootNode;

  OrganizationNode? savedNode;
  bool? nodeCreated;
  String? deletedNode;
  Company? updatedCompany;
  String? updatedCompanyName;
  Company? createdCompany;
  String? createdCompanyName;
  String? createdCompanyCode;
  int? createdCompanyLevel;

  @override
  Future<OrganizationNode> saveNode(
    OrganizationNode node, {
    required bool creating,
  }) async {
    if (failure != null) throw failure!;
    savedNode = node;
    nodeCreated = creating;
    return node;
  }

  @override
  Future<void> deleteNode(String id) async {
    if (failure != null) throw failure!;
    deletedNode = id;
  }

  @override
  Future<void> updateCompany(
    Company company, {
    required OrganizationNode node,
    required String name,
  }) async {
    if (failure != null) throw failure!;
    updatedCompany = company;
    updatedCompanyName = name;
  }

  @override
  Future<void> createCompany({
    required int empresaLevel,
    required String code,
    required String name,
    required Company company,
  }) async {
    if (failure != null) throw failure!;
    createdCompanyLevel = empresaLevel;
    createdCompanyCode = code;
    createdCompanyName = name;
    createdCompany = company;
  }
}

class FakeLocationsRepository extends LocationsRepository {
  TableQuery lastQuery = const TableQuery();
  FakeLocationsRepository() : super(Dio());
  LocationKind? savedKind;
  LocationRecord? saved;
  bool? created;
  String? deleted;
  Object? failure;
  final items = <LocationKind, List<LocationRecord>>{
    LocationKind.ubicaciones: [locationA, locationB],
    LocationKind.naves: [naveA, naveB],
    LocationKind.areas: [areaA],
  };
  @override
  Future<ApiPage<LocationRecord>> list(
    LocationKind kind,
    int page, {
    TableQuery query = const TableQuery(),
  }) async {
    lastQuery = query;
    if (failure != null) throw failure!;
    return ApiPage(count: items[kind]!.length, results: [...items[kind]!]);
  }

  @override
  Future<LocationCatalog> catalog() async => LocationCatalog(
    ubicaciones: [...items[LocationKind.ubicaciones]!],
    naves: [...items[LocationKind.naves]!],
  );
  @override
  Future<void> save(
    LocationKind kind,
    LocationRecord record, {
    required bool creating,
  }) async {
    if (failure != null) throw failure!;
    savedKind = kind;
    saved = record;
    created = creating;
    if (creating) {
      items[kind]!.add(record.copyWith(id: 'new'));
    } else {
      items[kind]![items[kind]!.indexWhere((item) => item.id == record.id)] =
          record;
    }
  }

  @override
  Future<void> delete(LocationKind kind, String id) async {
    if (failure != null) throw failure!;
    deleted = id;
    items[kind]!.removeWhere((item) => item.id == id);
  }
}

DioException denied() => DioException(
  requestOptions: RequestOptions(),
  response: Response(requestOptions: RequestOptions(), statusCode: 403),
);
