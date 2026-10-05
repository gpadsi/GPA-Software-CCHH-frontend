import 'package:dio/dio.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/network/api_page.dart';
import '../../../core/network/table_query.dart';
import 'schedule_models.dart';

class SchedulesRepository {
  SchedulesRepository(this.api);
  final Dio api;

  // Catorcenas — CRUD completo, sin catálogos (no tiene relaciones a otras
  // tablas). Hoy la tabla está vacía en datos reales: no hay calendario
  // confirmado todavía.
  Future<ApiPage<Catorcena>> catorcenasPage(
    int page, {
    TableQuery query = const TableQuery(),
  }) => fetchPage(
    api,
    'schedules/catorcenas/',
    Catorcena.fromJson,
    page: page,
    query: query,
  );

  Future<List<Catorcena>> allCatorcenas() =>
      fetchCatalog(api, 'schedules/catorcenas/', Catorcena.fromJson);

  Future<Catorcena> saveCatorcena(
    Catorcena catorcena, {
    required bool creating,
  }) async {
    final payload = catorcena.toJson()..remove('id');
    final response = creating
        ? await api.post<Map<String, dynamic>>(
            'schedules/catorcenas/',
            data: payload,
          )
        : await api.patch<Map<String, dynamic>>(
            'schedules/catorcenas/${catorcena.id}/',
            data: payload,
          );
    return Catorcena.fromJson(response.data!);
  }

  Future<void> deleteCatorcena(String id) =>
      api.delete<void>('schedules/catorcenas/$id/');

  // Tipos de horario — se crean y editan, no se borran (cada asignación
  // apunta a uno): el que ya no se usa se desactiva.
  Future<List<TipoHorarioRef>> tiposHorario() =>
      fetchCatalog(api, 'schedules/tipos-horario/', TipoHorarioRef.fromJson);

  Future<TipoHorarioRef> saveTipoHorario(
    TipoHorarioRef tipo, {
    required bool creating,
  }) async {
    final payload = {
      'name': tipo.name,
      'descripcion': tipo.descripcion,
      'is_active': tipo.isActive,
    };
    final response = creating
        ? await api.post<Map<String, dynamic>>(
            'schedules/tipos-horario/',
            data: payload,
          )
        : await api.patch<Map<String, dynamic>>(
            'schedules/tipos-horario/${tipo.id}/',
            data: payload,
          );
    return TipoHorarioRef.fromJson(response.data!);
  }

  // Áreas — referencia de solo lectura desde otro módulo (locations).
  Future<List<AreaRef>> areas() =>
      fetchCatalog(api, 'locations/areas/', AreaRef.fromJson);

  // Empleados — referencia de solo lectura desde otro módulo (employment).
  // allEmpleados() trae TODOS de una vez, solo para el selector filtrable de
  // los formularios (misma razón que allForPicker() en Fase 4: elegir entre
  // 580+ empleados no cabe en un dropdown plano). empleado() es la consulta
  // puntual que usan las tablas para resolver un solo registro por fila.
  Future<List<EmpleadoRef>> allEmpleados() =>
      fetchCatalog(api, 'employment/empleados/', EmpleadoRef.fromJson);

  Future<EmpleadoRef> empleado(String id) async {
    final response = await api.get<Map<String, dynamic>>(
      'employment/empleados/$id/',
    );
    return EmpleadoRef.fromJson(response.data!);
  }

  // Asignaciones de horario — CRUD completo, con datos reales (392 filas).
  Future<ApiPage<AsignacionHorario>> asignacionesHorarioPage(
    int page, {
    TableQuery query = const TableQuery(),
  }) => fetchPage(
    api,
    'schedules/asignaciones-horario/',
    AsignacionHorario.fromJson,
    page: page,
    query: query,
  );

  Future<AsignacionHorario> saveAsignacionHorario(
    AsignacionHorario asignacion, {
    required bool creating,
  }) async {
    final payload = asignacion.toJson()..remove('id');
    final response = creating
        ? await api.post<Map<String, dynamic>>(
            'schedules/asignaciones-horario/',
            data: payload,
          )
        : await api.patch<Map<String, dynamic>>(
            'schedules/asignaciones-horario/${asignacion.id}/',
            data: payload,
          );
    return AsignacionHorario.fromJson(response.data!);
  }

  Future<void> deleteAsignacionHorario(String id) =>
      api.delete<void>('schedules/asignaciones-horario/$id/');

  // Asignaciones de ubicación — CRUD completo. Hoy vacía en datos reales
  // (0 filas): la pantalla debe verse como "sin registros", no como error.
  Future<ApiPage<AsignacionUbicacion>> asignacionesUbicacionPage(
    int page, {
    TableQuery query = const TableQuery(),
  }) => fetchPage(
    api,
    'schedules/asignaciones-ubicacion/',
    AsignacionUbicacion.fromJson,
    page: page,
    query: query,
  );

  Future<AsignacionUbicacion> saveAsignacionUbicacion(
    AsignacionUbicacion asignacion, {
    required bool creating,
  }) async {
    final payload = asignacion.toJson()..remove('id');
    final response = creating
        ? await api.post<Map<String, dynamic>>(
            'schedules/asignaciones-ubicacion/',
            data: payload,
          )
        : await api.patch<Map<String, dynamic>>(
            'schedules/asignaciones-ubicacion/${asignacion.id}/',
            data: payload,
          );
    return AsignacionUbicacion.fromJson(response.data!);
  }

  Future<void> deleteAsignacionUbicacion(String id) =>
      api.delete<void>('schedules/asignaciones-ubicacion/$id/');
}

/// Mensaje para una falla al guardar un tipo de horario: el motivo del
/// servidor si lo da (ej. "Ya existe un tipo de horario con ese nombre.").
String tipoHorarioMutationError(Object error) =>
    validationDetail(
      error,
      labels: const {'name': 'Nombre', 'descripcion': 'Horario'},
    ) ??
    (error is DioException && error.response?.statusCode == 403
        ? 'Tu cuenta no tiene permiso para modificar tipos de horario.'
        : apiErrorMessage(error));
