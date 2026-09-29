import 'package:dio/dio.dart';

import '../../../core/network/api_page.dart';
import 'employment_models.dart';

class EmploymentRepository {
  EmploymentRepository(this.api);
  final Dio api;

  Future<ApiPage<Empleado>> list(int page) =>
      fetchPage(api, 'employment/empleados/', Empleado.fromJson, page: page);

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
