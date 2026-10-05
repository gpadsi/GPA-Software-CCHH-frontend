import 'package:capital_humano_front/core/network/table_query.dart';
import 'package:capital_humano_front/core/network/api_page.dart';
import 'package:capital_humano_front/features/positions/data/position_models.dart';
import 'package:capital_humano_front/features/positions/data/positions_repository.dart';
import 'package:dio/dio.dart';

const orgNodeA = RefEntry(
  id: 'org1',
  code: 'GPA-CEI-01',
  name: 'CEI Aerospace Group',
);
const areaRefA = RefEntry(id: 'area1', code: 'A1', name: 'Producción');
const puestoCatalogA = PositionCatalogEntry(
  id: 1,
  code: 'AUX',
  name: 'Auxiliar de Producción',
  isActive: true,
);
const estatusCatalogA = PositionCatalogEntry(
  id: 20,
  code: 'CA',
  name: 'Colaborador Activo',
  isActive: true,
);
const alcanceCatalogA = PositionCatalogEntry(
  id: 2,
  code: 'OP',
  name: 'Operativo',
  isActive: true,
);
const tipoPosicionCatalogA = PositionCatalogEntry(
  id: 3,
  code: 'FIJA',
  name: 'Fija',
  isActive: true,
);
const tipoRequisicionCatalogA = PositionCatalogEntry(
  id: 4,
  code: 'NP',
  name: 'Nueva Posición',
  isActive: true,
);
const generoCatalogA = PositionCatalogEntry(
  id: 5,
  code: 'M',
  name: 'Masculino',
  isActive: true,
);

const positionCatalogsFixture = PositionCatalogs(
  alcances: [alcanceCatalogA],
  tiposPosicion: [tipoPosicionCatalogA],
  tiposRequisicion: [tipoRequisicionCatalogA],
  estatus: [estatusCatalogA],
  puestos: [puestoCatalogA],
  generos: [generoCatalogA],
  organizationNodes: [orgNodeA],
  areas: [areaRefA],
);

const posicionA = Posicion(
  id: 'pos1',
  organizationNode: 'org1',
  area: 'area1',
  puesto: 1,
  estatus: 20,
);

class FakePositionsRepository extends PositionsRepository {
  TableQuery lastQuery = const TableQuery();
  FakePositionsRepository() : super(Dio());
  Object? failure;
  Posicion? saved;
  bool? created;
  String? deleted;
  final posiciones = [posicionA];

  @override
  Future<PositionCatalogs> catalogs() async {
    if (failure != null) throw failure!;
    return positionCatalogsFixture;
  }

  @override
  Future<ApiPage<Posicion>> list(
    int page, {
    TableQuery query = const TableQuery(),
  }) async {
    lastQuery = query;
    if (failure != null) throw failure!;
    return ApiPage(count: posiciones.length, results: [...posiciones]);
  }

  @override
  Future<List<Posicion>> allForPicker() async {
    if (failure != null) throw failure!;
    return [...posiciones];
  }

  @override
  Future<Posicion> get(String id) async {
    if (failure != null) throw failure!;
    return posiciones.firstWhere((item) => item.id == id);
  }

  @override
  Future<Posicion> save(Posicion posicion, {required bool creating}) async {
    if (failure != null) throw failure!;
    saved = posicion;
    created = creating;
    final result = creating ? posicion.copyWith(id: 'new') : posicion;
    if (creating) {
      posiciones.add(result);
    } else {
      posiciones[posiciones.indexWhere((item) => item.id == posicion.id)] =
          result;
    }
    return result;
  }

  PositionCatalogEntry? savedPuesto;
  bool? puestoCreated;

  @override
  Future<PositionCatalogEntry> savePuesto(
    PositionCatalogEntry puesto, {
    required bool creating,
  }) async {
    if (failure != null) throw failure!;
    savedPuesto = puesto;
    puestoCreated = creating;
    return puesto;
  }

  @override
  Future<void> delete(String id) async {
    if (failure != null) throw failure!;
    deleted = id;
    posiciones.removeWhere((item) => item.id == id);
  }
}
