import 'package:dio/dio.dart';

import '../../../core/network/api_page.dart';
import '../../../core/network/table_query.dart';
import 'location_models.dart';

class LocationsRepository {
  LocationsRepository(this.api);
  final Dio api;
  Future<ApiPage<LocationRecord>> list(
    LocationKind kind,
    int page, {
    TableQuery query = const TableQuery(),
  }) => fetchPage(
    api,
    kind.path,
    LocationRecord.fromJson,
    page: page,
    query: query,
  );

  Future<LocationCatalog> catalog() async {
    final results = await Future.wait([
      fetchCatalog(api, LocationKind.ubicaciones.path, LocationRecord.fromJson),
      fetchCatalog(api, LocationKind.naves.path, LocationRecord.fromJson),
    ]);
    return LocationCatalog(ubicaciones: results[0], naves: results[1]);
  }

  Future<void> save(
    LocationKind kind,
    LocationRecord record, {
    required bool creating,
  }) async {
    final fields = {
      'code',
      'name',
      'is_active',
      switch (kind) {
        LocationKind.ubicaciones => 'employer_registration',
        LocationKind.naves => 'ubicacion',
        LocationKind.areas => 'nave',
      },
    };
    final payload = record.toJson()
      ..removeWhere((key, _) => !fields.contains(key));
    if (creating) {
      await api.post<Map<String, dynamic>>(kind.path, data: payload);
    } else {
      await api.patch<Map<String, dynamic>>(
        '${kind.path}${record.id}/',
        data: payload,
      );
    }
  }

  Future<void> delete(LocationKind kind, String id) =>
      api.delete<void>('${kind.path}$id/');
}

String locationMutationError(Object error, {bool deleting = false}) {
  if (error is DioException && error.response?.statusCode == 400) {
    return 'Revisa los datos: el código no debe repetirse dentro de su ubicación o nave y las relaciones deben seguir vigentes.';
  }
  if (error is DioException && error.response?.statusCode == 403) {
    return 'Tu cuenta no tiene permiso para modificar estos registros.';
  }
  if (error is DioException && error.response?.statusCode == 404) {
    return 'El registro ya no está disponible. Actualiza la lista.';
  }
  if (deleting) {
    return 'No se pudo eliminar. Si tiene registros vinculados, deben resolverse antes. También puedes marcarlo como inactivo.';
  }
  return 'No se pudo guardar. Revisa tu conexión y vuelve a intentar.';
}
