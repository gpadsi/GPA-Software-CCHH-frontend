import 'package:capital_humano_front/features/schedules/data/schedules_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'phase_five_fixtures.dart';
import 'session_service_test.dart' show client, response;

void main() {
  group('SchedulesRepository — Catorcenas', () {
    test('list pagina del lado del servidor', () async {
      final repository = SchedulesRepository(
        client((request) {
          expect(request.path, 'schedules/catorcenas/');
          expect(request.queryParameters, {'page': 2, 'page_size': 25});
          return response({
            'count': 1,
            'results': [catorcenaA.toJson()],
          });
        }),
      );
      final page = await repository.catorcenasPage(2);
      expect(page.count, 1);
    });

    test('save al crear envía todos los campos, sin id', () async {
      final repository = SchedulesRepository(
        client((request) {
          expect(request.method, 'POST');
          expect(request.path, 'schedules/catorcenas/');
          final payload = request.data as Map<String, dynamic>;
          expect(payload.containsKey('id'), isFalse);
          expect(payload['numero'], 5);
          expect(payload['anio'], 2026);
          return response(catorcenaA.toJson());
        }),
      );
      await repository.saveCatorcena(catorcenaA, creating: true);
    });

    test('save al editar hace PATCH a la catorcena específica', () async {
      final repository = SchedulesRepository(
        client((request) {
          expect(request.method, 'PATCH');
          expect(request.path, 'schedules/catorcenas/k1/');
          return response(catorcenaA.toJson());
        }),
      );
      await repository.saveCatorcena(catorcenaA, creating: false);
    });

    test('delete llama al endpoint correcto', () async {
      final repository = SchedulesRepository(
        client((request) {
          expect(request.method, 'DELETE');
          expect(request.path, 'schedules/catorcenas/k1/');
          return response(null);
        }),
      );
      await repository.deleteCatorcena('k1');
    });
  });

  test('tiposHorario pide el catálogo correcto', () async {
    final repository = SchedulesRepository(
      client((request) {
        expect(request.path, 'schedules/tipos-horario/');
        return response({
          'count': 1,
          'results': [tipoHorarioA.toJson()],
        });
      }),
    );
    final tipos = await repository.tiposHorario();
    expect(tipos.single.name, 'Horario 1');
  });

  test('allEmpleados trae todas las páginas', () async {
    var calls = 0;
    final repository = SchedulesRepository(
      client((request) {
        calls++;
        expect(request.path, 'employment/empleados/');
        final isFirstPage = request.queryParameters['page'] == 1;
        return response({
          'count': 2,
          'next': isFirstPage ? 'siguiente' : null,
          'results': [empleadoRefA.toJson()],
        });
      }),
    );
    final empleados = await repository.allEmpleados();
    expect(empleados.length, 2);
    expect(calls, 2);
  });

  group('SchedulesRepository — Asignaciones de horario', () {
    test('save al crear envía empleado y tipo_horario', () async {
      final repository = SchedulesRepository(
        client((request) {
          expect(request.method, 'POST');
          expect(request.path, 'schedules/asignaciones-horario/');
          final payload = request.data as Map<String, dynamic>;
          expect(payload['empleado'], 'e1');
          expect(payload['tipo_horario'], 1);
          return response(asignacionHorarioA.toJson());
        }),
      );
      await repository.saveAsignacionHorario(
        asignacionHorarioA,
        creating: true,
      );
    });

    test('delete llama al endpoint correcto', () async {
      final repository = SchedulesRepository(
        client((request) {
          expect(request.method, 'DELETE');
          expect(request.path, 'schedules/asignaciones-horario/ah1/');
          return response(null);
        }),
      );
      await repository.deleteAsignacionHorario('ah1');
    });
  });

  group('SchedulesRepository — Asignaciones de ubicación', () {
    test('save al crear envía empleado y area', () async {
      final repository = SchedulesRepository(
        client((request) {
          expect(request.method, 'POST');
          expect(request.path, 'schedules/asignaciones-ubicacion/');
          final payload = request.data as Map<String, dynamic>;
          expect(payload['empleado'], 'e1');
          expect(payload['area'], 'area1');
          return response(asignacionUbicacionA.toJson());
        }),
      );
      await repository.saveAsignacionUbicacion(
        asignacionUbicacionA,
        creating: true,
      );
    });
  });
}
