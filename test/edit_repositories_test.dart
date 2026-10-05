// Lo que las pantallas de alta y edición mandan de verdad al servidor
// (paso 2 del plan del front, 2026-10-02): puestos, tipos de horario,
// nodos y empresas del organigrama, y empleados.
import 'package:capital_humano_front/core/auth/auth_models.dart';
import 'package:capital_humano_front/core/network/api_failure.dart';
import 'package:capital_humano_front/features/employment/data/employment_models.dart';
import 'package:capital_humano_front/features/employment/data/employment_repository.dart';
import 'package:capital_humano_front/features/organizations/data/organization_models.dart';
import 'package:capital_humano_front/features/organizations/data/organizations_repository.dart';
import 'package:capital_humano_front/features/positions/data/position_models.dart';
import 'package:capital_humano_front/features/positions/data/positions_repository.dart';
import 'package:capital_humano_front/features/schedules/data/schedule_models.dart';
import 'package:capital_humano_front/features/schedules/data/schedules_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'phase_three_fixtures.dart'
    show personSummaryA, personSummaryB, personaB;
import 'phase_two_fixtures.dart';
import 'session_service_test.dart' show client, response;

DioException _http(int code, Object? data) => DioException(
  requestOptions: RequestOptions(path: '/x'),
  response: Response(
    requestOptions: RequestOptions(path: '/x'),
    statusCode: code,
    data: data,
  ),
  type: DioExceptionType.badResponse,
);

void main() {
  group('sesión', () {
    test('lee el rol y si puede gestionar Capital Humano', () {
      final user = SessionUser.fromJson({
        'id': 'u1',
        'username': 'ana',
        'email': 'ana@example.test',
        'first_name': 'Ana',
        'last_name': 'Ruiz',
        'is_active': true,
        'role': {'code': 'capital-humano', 'name': 'Capital Humano'},
        'can_manage_hr': true,
      });
      expect(user.role?.code, 'capital-humano');
      expect(user.role?.name, 'Capital Humano');
      expect(user.canManageHr, isTrue);
    });

    test('sin rol ni la marca, NO puede gestionar (lo seguro por defecto)', () {
      // Un servidor sin el cambio, o una cuenta sin rol: no se ofrecen
      // botones de escritura que la API rechazaría.
      final user = SessionUser.fromJson({
        'id': 'u1',
        'username': 'ana',
        'email': 'ana@example.test',
        'first_name': 'Ana',
        'last_name': 'Ruiz',
        'is_active': true,
        'role': null,
      });
      expect(user.role, isNull);
      expect(user.canManageHr, isFalse);
    });
  });

  group('nombres', () {
    test('sin apellido materno no queda un espacio doble', () {
      expect(personSummaryB.fullName, 'Ruiz Ana');
      expect(personaB.fullName, 'Ruiz Ana');
      expect(personSummaryA.fullName, 'Pérez López Juan');
    });
  });

  group('mensajes del servidor', () {
    test('conflictDetail devuelve el motivo de un 409 y nada más', () {
      expect(
        conflictDetail(_http(409, {'detail': 'Lo usan 3 posiciones.'})),
        'Lo usan 3 posiciones.',
      );
      expect(conflictDetail(_http(400, {'detail': 'x'})), isNull);
      expect(conflictDetail(_http(409, 'texto suelto')), isNull);
      expect(conflictDetail(StateError('no es de red')), isNull);
    });

    test(
      'validationDetail junta los mensajes y pone la etiqueta del campo',
      () {
        final error = _http(400, {
          'name': ['Ya existe un puesto con ese nombre.'],
          'non_field_errors': ['Revisa los datos.'],
        });
        expect(
          validationDetail(error, labels: const {'name': 'Nombre'}),
          'Nombre: Ya existe un puesto con ese nombre. Revisa los datos.',
        );
        expect(
          validationDetail(
            _http(500, {
              'name': ['x'],
            }),
          ),
          isNull,
        );
        expect(validationDetail(_http(400, <String, Object>{})), isNull);
      },
    );
  });

  group('PositionsRepository.savePuesto', () {
    const puesto = PositionCatalogEntry(
      id: 7,
      code: 'jefe',
      name: 'Jefe de Almacén',
      isActive: false,
      esGerenciaDeUnidad: true,
    );

    test(
      'al crear hace POST con nombre y las dos marcas, sin código ni id',
      () async {
        final repository = PositionsRepository(
          client((request) {
            expect(request.method, 'POST');
            expect(request.path, 'positions/puestos/');
            expect(request.data, {
              'name': 'Jefe de Almacén',
              'is_active': false,
              'es_gerencia_de_unidad': true,
            });
            return response({...puesto.toJson(), 'id': 8}, status: 201);
          }),
        );
        final saved = await repository.savePuesto(puesto, creating: true);
        expect(saved.id, 8);
      },
    );

    test('al editar hace PATCH al puesto', () async {
      final repository = PositionsRepository(
        client((request) {
          expect(request.method, 'PATCH');
          expect(request.path, 'positions/puestos/7/');
          return response(puesto.toJson());
        }),
      );
      await repository.savePuesto(puesto, creating: false);
    });

    test('puestoMutationError explica el motivo del servidor', () {
      expect(
        puestoMutationError(
          _http(400, {
            'name': ['Ya existe un puesto con ese nombre.'],
          }),
        ),
        'Nombre: Ya existe un puesto con ese nombre.',
      );
      expect(
        puestoMutationError(_http(403, {'detail': 'x'})),
        'Tu cuenta no tiene permiso para modificar puestos.',
      );
    });
  });

  group('SchedulesRepository.saveTipoHorario', () {
    const tipo = TipoHorarioRef(
      id: 3,
      code: 'h03',
      name: 'H03',
      descripcion: '08:00 - 17:00',
      isActive: true,
    );

    test('al crear hace POST con nombre, horario y vigencia', () async {
      final repository = SchedulesRepository(
        client((request) {
          expect(request.method, 'POST');
          expect(request.path, 'schedules/tipos-horario/');
          expect(request.data, {
            'name': 'H03',
            'descripcion': '08:00 - 17:00',
            'is_active': true,
          });
          return response(tipo.toJson(), status: 201);
        }),
      );
      await repository.saveTipoHorario(tipo, creating: true);
    });

    test('al editar hace PATCH al tipo', () async {
      final repository = SchedulesRepository(
        client((request) {
          expect(request.method, 'PATCH');
          expect(request.path, 'schedules/tipos-horario/3/');
          return response(tipo.toJson());
        }),
      );
      await repository.saveTipoHorario(tipo, creating: false);
    });
  });

  group('OrganizationsRepository', () {
    test('saveNode manda nivel, padre, código, nombre y vigencia; nunca la organización', () async {
      final repository = OrganizationsRepository(
        client((request) {
          expect(request.method, 'POST');
          expect(request.path, 'organizations/nodes/');
          expect(request.data, {
            'level': 2,
            'parent': 'root',
            'code': 'UN-1',
            'name': 'Nueva unidad',
            'is_active': true,
          });
          return response(childNode.toJson(), status: 201);
        }),
      );
      await repository.saveNode(
        const OrganizationNode(
          id: '',
          tenant: 0,
          level: 2,
          parent: 'root',
          code: 'UN-1',
          name: 'Nueva unidad',
          isActive: true,
        ),
        creating: true,
      );
    });

    test('saveNode al editar hace PATCH al nodo', () async {
      final repository = OrganizationsRepository(
        client((request) {
          expect(request.method, 'PATCH');
          expect(request.path, 'organizations/nodes/child/');
          return response(childNode.toJson());
        }),
      );
      await repository.saveNode(childNode, creating: false);
    });

    test('deleteNode hace DELETE al nodo', () async {
      final repository = OrganizationsRepository(
        client((request) {
          expect(request.method, 'DELETE');
          expect(request.path, 'organizations/nodes/child/');
          return response(null, status: 204);
        }),
      );
      await repository.deleteNode('child');
    });

    test('updateCompany sin cambio de nombre solo hace PATCH a la empresa y los vacíos van como null', () async {
      final calls = <String>[];
      final repository = OrganizationsRepository(
        client((request) {
          calls.add('${request.method} ${request.path}');
          expect(request.data, {
            'legal_name': 'Azimatronics, S.A. de C.V.',
            'rfc': null,
            'employer_registration': null,
          });
          return response(companyA.toJson());
        }),
      );
      await repository.updateCompany(
        const Company(
          id: 'c1',
          organizationNode: 'root',
          legalName: '  Azimatronics, S.A. de C.V.  ',
          rfc: '   ',
          employerRegistration: '',
        ),
        node: rootNode,
        name: rootNode.name,
      );
      expect(calls, ['PATCH organizations/companies/c1/']);
    });

    test(
      'updateCompany renombra primero el nodo y luego guarda los datos legales',
      () async {
        final calls = <String>[];
        final repository = OrganizationsRepository(
          client((request) {
            calls.add('${request.method} ${request.path}');
            if (request.path.startsWith('organizations/nodes/')) {
              expect((request.data as Map)['name'], 'Nombre nuevo');
              return response(rootNode.toJson());
            }
            return response(companyA.toJson());
          }),
        );
        await repository.updateCompany(
          companyA,
          node: rootNode,
          name: 'Nombre nuevo',
        );
        expect(calls, [
          'PATCH organizations/nodes/root/',
          'PATCH organizations/companies/c1/',
        ]);
      },
    );

    test('createCompany crea el nodo de nivel Empresa y luego la empresa ligada a él', () async {
      final calls = <String>[];
      final repository = OrganizationsRepository(
        client((request) {
          calls.add('${request.method} ${request.path}');
          if (request.path == 'organizations/nodes/') {
            expect((request.data as Map)['level'], 1);
            expect((request.data as Map)['parent'], isNull);
            return response({...rootNode.toJson(), 'id': 'nuevo'}, status: 201);
          }
          expect((request.data as Map)['organization_node'], 'nuevo');
          expect((request.data as Map)['rfc'], isNull);
          return response(companyA.toJson(), status: 201);
        }),
      );
      await repository.createCompany(
        empresaLevel: 1,
        code: 'GPA-NUEVA',
        name: 'Empresa nueva',
        company: const Company(id: '', organizationNode: '', rfc: ''),
      );
      expect(calls, [
        'POST organizations/nodes/',
        'POST organizations/companies/',
      ]);
    });

    test('createCompany quita el nodo recién creado si los datos legales fallan y relanza el error', () async {
      final calls = <String>[];
      final repository = OrganizationsRepository(
        client((request) {
          calls.add('${request.method} ${request.path}');
          if (request.method == 'POST' &&
              request.path == 'organizations/nodes/') {
            return response({...rootNode.toJson(), 'id': 'nuevo'}, status: 201);
          }
          if (request.method == 'DELETE') return response(null, status: 204);
          return response({
            'rfc': ['Ya existe.'],
          }, status: 400);
        }),
      );
      await expectLater(
        repository.createCompany(
          empresaLevel: 1,
          code: 'GPA-NUEVA',
          name: 'Empresa nueva',
          company: const Company(id: '', organizationNode: '', rfc: 'AAA'),
        ),
        throwsA(isA<DioException>()),
      );
      expect(calls, [
        'POST organizations/nodes/',
        'POST organizations/companies/',
        'DELETE organizations/nodes/nuevo/',
      ]);
    });

    test('organizationMutationError distingue un código repetido bajo el mismo padre', () {
      expect(
        organizationMutationError(
          _http(400, {
            'non_field_errors': [
              'Los campos parent, code deben formar un conjunto único.',
            ],
          }),
        ),
        'Ya existe un nodo con ese código dentro del mismo padre. Usa otro código.',
      );
      expect(
        organizationMutationError(
          _http(400, {
            'parent': ['El nodo padre es obligatorio.'],
          }),
        ),
        'Nodo padre: El nodo padre es obligatorio.',
      );
    });
  });

  group('EmploymentRepository', () {
    test('save al crear manda la persona y el número de nómina', () async {
      final repository = EmploymentRepository(
        client((request) {
          expect(request.method, 'POST');
          expect(request.path, 'employment/empleados/');
          expect(request.data, {'work_number': 'ADV0200', 'persona': 'p2'});
          return response({
            'id': 'e2',
            'persona': 'p2',
            'work_number': 'ADV0200',
          }, status: 201);
        }),
      );
      final saved = await repository.save(
        const Empleado(id: '', persona: 'p2', workNumber: ' ADV0200 '),
        creating: true,
      );
      expect(saved.id, 'e2');
    });

    test(
      'save al editar NO manda la persona y un número vacío va como null',
      () async {
        final repository = EmploymentRepository(
          client((request) {
            expect(request.method, 'PATCH');
            expect(request.path, 'employment/empleados/e1/');
            expect(request.data, {'work_number': null});
            return response({'id': 'e1', 'persona': 'p1'});
          }),
        );
        await repository.save(
          const Empleado(id: 'e1', persona: 'p1', workNumber: '   '),
          creating: false,
        );
      },
    );

    test('searchPersonas pide el servidor con la búsqueda, 8 resultados y orden por apellido', () async {
      final repository = EmploymentRepository(
        client((request) {
          expect(request.path, 'persons/personas/');
          expect(request.queryParameters, {
            'search': 'perez',
            'page_size': 8,
            'ordering': 'last_name_paternal,last_name_maternal,first_name',
          });
          return response({
            'count': 1,
            'results': [
              {
                'id': 'p1',
                'first_name': 'Juan',
                'last_name_paternal': 'Pérez',
                'last_name_maternal': 'López',
              },
            ],
          });
        }),
      );
      final found = await repository.searchPersonas('perez');
      expect(found.single.fullName, 'Pérez López Juan');
    });

    test('empleadoMutationError dice en claro los dos choques posibles', () {
      expect(
        empleadoMutationError(
          _http(400, {
            'persona': ['x'],
          }),
        ),
        'Esa persona ya es empleada. Búscala en la lista de empleados.',
      );
      expect(
        empleadoMutationError(
          _http(400, {
            'work_number': ['x'],
          }),
        ),
        'Ese número de nómina ya pertenece a otro empleado.',
      );
      expect(
        empleadoMutationError(_http(403, {'detail': 'x'})),
        'Tu cuenta no tiene permiso para modificar empleados.',
      );
    });
  });
}
