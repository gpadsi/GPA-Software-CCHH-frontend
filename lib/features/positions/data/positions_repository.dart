import 'package:dio/dio.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/network/api_page.dart';
import '../../../core/network/table_query.dart';
import 'position_models.dart';

class PositionsRepository {
  PositionsRepository(this.api);
  final Dio api;

  Future<PositionCatalogs> catalogs() async {
    final results = await Future.wait([
      fetchCatalog(api, 'positions/alcances/', PositionCatalogEntry.fromJson),
      fetchCatalog(
        api,
        'positions/tipos-posicion/',
        PositionCatalogEntry.fromJson,
      ),
      fetchCatalog(
        api,
        'positions/tipos-requisicion/',
        PositionCatalogEntry.fromJson,
      ),
      fetchCatalog(api, 'positions/estatus/', PositionCatalogEntry.fromJson),
      fetchCatalog(api, 'positions/puestos/', PositionCatalogEntry.fromJson),
      fetchCatalog(api, 'persons/generos/', PositionCatalogEntry.fromJson),
      fetchCatalog(api, 'organizations/nodes/', RefEntry.fromJson),
      fetchCatalog(api, 'locations/areas/', RefEntry.fromJson),
    ]);
    return PositionCatalogs(
      alcances: results[0] as List<PositionCatalogEntry>,
      tiposPosicion: results[1] as List<PositionCatalogEntry>,
      tiposRequisicion: results[2] as List<PositionCatalogEntry>,
      estatus: results[3] as List<PositionCatalogEntry>,
      puestos: results[4] as List<PositionCatalogEntry>,
      generos: results[5] as List<PositionCatalogEntry>,
      organizationNodes: results[6] as List<RefEntry>,
      areas: results[7] as List<RefEntry>,
    );
  }

  Future<ApiPage<Posicion>> list(
    int page, {
    TableQuery query = const TableQuery(),
  }) => fetchPage(
    api,
    'positions/posiciones/',
    Posicion.fromJson,
    page: page,
    query: query,
  );

  // Todas las posiciones, sin paginar — solo para el selector de "reporta
  // a" (línea de reporte), que necesita elegir entre cualquier Posición
  // existente, no solo la página visible de la tabla.
  Future<List<Posicion>> allForPicker() =>
      fetchCatalog(api, 'positions/posiciones/', Posicion.fromJson);

  Future<Posicion> get(String id) async {
    final response = await api.get<Map<String, dynamic>>(
      'positions/posiciones/$id/',
    );
    return Posicion.fromJson(response.data!);
  }

  Future<Posicion> save(Posicion posicion, {required bool creating}) async {
    final payload = posicion.toJson()..remove('id');
    final response = creating
        ? await api.post<Map<String, dynamic>>(
            'positions/posiciones/',
            data: payload,
          )
        : await api.patch<Map<String, dynamic>>(
            'positions/posiciones/${posicion.id}/',
            data: payload,
          );
    return Posicion.fromJson(response.data!);
  }

  Future<void> delete(String id) =>
      api.delete<void>('positions/posiciones/$id/');

  // Los puestos se crean y editan pero no se borran: una Posición apunta a
  // cada uno. Lo que ya no se usa se desactiva.
  Future<PositionCatalogEntry> savePuesto(
    PositionCatalogEntry puesto, {
    required bool creating,
  }) async {
    final payload = {
      'name': puesto.name,
      'is_active': puesto.isActive,
      'es_gerencia_de_unidad': puesto.esGerenciaDeUnidad,
    };
    final response = creating
        ? await api.post<Map<String, dynamic>>(
            'positions/puestos/',
            data: payload,
          )
        : await api.patch<Map<String, dynamic>>(
            'positions/puestos/${puesto.id}/',
            data: payload,
          );
    return PositionCatalogEntry.fromJson(response.data!);
  }
}

/// Mensaje para una falla al guardar un puesto: el motivo del servidor si lo
/// da (ej. "Ya existe un puesto con ese nombre.").
String puestoMutationError(Object error) =>
    validationDetail(error, labels: const {'name': 'Nombre'}) ??
    (error is DioException && error.response?.statusCode == 403
        ? 'Tu cuenta no tiene permiso para modificar puestos.'
        : apiErrorMessage(error));
