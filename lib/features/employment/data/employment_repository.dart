import 'package:dio/dio.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/network/api_page.dart';
import '../../../core/network/table_query.dart';
import 'employment_models.dart';

class EmploymentRepository {
  EmploymentRepository(this.api);
  final Dio api;

  Future<ApiPage<Empleado>> list(
    int page, {
    TableQuery query = const TableQuery(),
  }) => fetchPage(
    api,
    'employment/empleados/',
    Empleado.fromJson,
    page: page,
    query: query,
  );

  Future<Empleado> get(String id) async {
    final response = await api.get<Map<String, dynamic>>(
      'employment/empleados/$id/',
    );
    return Empleado.fromJson(response.data!);
  }

  Future<Contrato?> contratoVigente(String empleadoId) async {
    final response = await api.get<dynamic>(
      'employment/empleados/$empleadoId/contrato-vigente/',
    );
    return response.data == null
        ? null
        : Contrato.fromJson(response.data as Map<String, dynamic>);
  }

  /// Alta (con [Empleado.persona]) o cambio del número de nómina. Una persona
  /// no cambia de expediente al editar: solo se manda al crear. Un número de
  /// nómina vacío viaja como null (es único: dos vacíos "" chocarían).
  Future<Empleado> save(Empleado empleado, {required bool creating}) async {
    final number = empleado.workNumber?.trim() ?? '';
    final payload = {
      'work_number': number.isEmpty ? null : number,
      if (creating) 'persona': empleado.persona,
    };
    final response = creating
        ? await api.post<Map<String, dynamic>>(
            'employment/empleados/',
            data: payload,
          )
        : await api.patch<Map<String, dynamic>>(
            'employment/empleados/${empleado.id}/',
            data: payload,
          );
    return Empleado.fromJson(response.data!);
  }

  /// Personas que coinciden con lo escrito (nombre, CURP, correo, teléfono; sin
  /// distinguir acentos), para elegir a quién dar de alta como empleado.
  Future<List<PersonSummary>> searchPersonas(String text) async {
    final response = await api.get<Map<String, dynamic>>(
      'persons/personas/',
      queryParameters: {
        'search': text,
        'page_size': 8,
        'ordering': 'last_name_paternal,last_name_maternal,first_name',
      },
    );
    return [
      for (final item in response.data!['results'] as List<dynamic>)
        PersonSummary.fromJson(item as Map<String, dynamic>),
    ];
  }

  Future<PersonSummary> persona(String id) async {
    final response = await api.get<Map<String, dynamic>>(
      'persons/personas/$id/',
    );
    return PersonSummary.fromJson(response.data!);
  }

  Future<PosicionSummary> posicion(String id) async {
    final response = await api.get<Map<String, dynamic>>(
      'positions/posiciones/$id/',
    );
    return PosicionSummary.fromJson(response.data!);
  }

  Future<NamedRef> puesto(int id) async {
    final response = await api.get<Map<String, dynamic>>(
      'positions/puestos/$id/',
    );
    return NamedRef.fromJson(response.data!);
  }

  Future<NamedRef> estatus(int id) async {
    final response = await api.get<Map<String, dynamic>>(
      'positions/estatus/$id/',
    );
    return NamedRef.fromJson(response.data!);
  }
}

/// Mensaje para una falla al guardar un empleado, con los dos choques que sí
/// pueden pasar dichos en claro.
String empleadoMutationError(Object error) {
  if (error is DioException && error.response?.statusCode == 400) {
    final data = error.response?.data;
    if (data is Map && data.containsKey('persona')) {
      return 'Esa persona ya es empleada. Búscala en la lista de empleados.';
    }
    if (data is Map && data.containsKey('work_number')) {
      return 'Ese número de nómina ya pertenece a otro empleado.';
    }
  }
  return validationDetail(
        error,
        labels: const {'work_number': 'Número de nómina'},
      ) ??
      (error is DioException && error.response?.statusCode == 403
          ? 'Tu cuenta no tiene permiso para modificar empleados.'
          : apiErrorMessage(error));
}
