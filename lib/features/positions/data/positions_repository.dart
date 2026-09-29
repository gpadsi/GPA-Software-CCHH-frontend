import 'package:dio/dio.dart';

import '../../../core/network/api_page.dart';
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

  Future<ApiPage<Posicion>> list(int page) =>
      fetchPage(api, 'positions/posiciones/', Posicion.fromJson, page: page);

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
}
