// Comportamiento a nivel de pantalla del paso 2 del plan del front
// (2026-10-02): el rol decide quién ve botones de escritura, y Puestos,
// Tipos de horario, Empresas, Organigrama y Empleados ya se crean y editan.
import 'package:capital_humano_front/core/auth/auth_models.dart';
import 'package:capital_humano_front/core/auth/session_controller.dart';
import 'package:capital_humano_front/core/routing/app_router.dart';
import 'package:capital_humano_front/core/widgets/form_panel.dart';
import 'package:capital_humano_front/features/employment/application/employment_controller.dart';
import 'package:capital_humano_front/features/locations/application/locations_controller.dart';
import 'package:capital_humano_front/features/organizations/application/organizations_controller.dart';
import 'package:capital_humano_front/features/organizations/data/organization_models.dart';
import 'package:capital_humano_front/features/organizations/presentation/node_form.dart';
import 'package:capital_humano_front/features/persons/application/persons_controller.dart';
import 'package:capital_humano_front/features/positions/application/positions_controller.dart';
import 'package:capital_humano_front/features/schedules/application/schedules_controller.dart';
import 'package:capital_humano_front/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'phase_five_fixtures.dart';
import 'phase_four_fixtures.dart';
import 'phase_three_fixtures.dart';
import 'phase_two_fixtures.dart';
import 'test_session.dart';

DioException _http(int code, [Object? data]) => DioException(
  requestOptions: RequestOptions(path: '/x'),
  response: Response(
    requestOptions: RequestOptions(path: '/x'),
    statusCode: code,
    data: data,
  ),
  type: DioExceptionType.badResponse,
);

/// La app completa con los seis repositorios falsos y la cuenta indicada.
Future<GoRouter> pumpAll(
  WidgetTester tester, {
  required String path,
  SessionUser user = testUser,
  FakeOrganizationsRepository? organizations,
  FakeLocationsRepository? locations,
  FakePersonsRepository? persons,
  FakeEmploymentRepository? employment,
  FakePositionsRepository? positions,
  FakeSchedulesRepository? schedules,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1440, 1000);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final session = ValueNotifier(
    SessionState(status: SessionStatus.signedIn, user: user),
  );
  final router = createAppRouter(
    initialLocation: path,
    session: () => session.value,
    refreshListenable: session,
  );
  addTearDown(router.dispose);
  addTearDown(session.dispose);
  await tester.pumpWidget(
    ProviderScope(
      // Clave nueva en cada montaje: sin ella, un segundo pumpAll en la misma
      // prueba reutilizaría el contenedor (y la sesión) del primero.
      key: UniqueKey(),
      overrides: [
        sessionControllerProvider.overrideWith(
          () => TestSessionController(user: user),
        ),
        organizationsRepositoryProvider.overrideWithValue(
          organizations ?? FakeOrganizationsRepository(),
        ),
        locationsRepositoryProvider.overrideWithValue(
          locations ?? FakeLocationsRepository(),
        ),
        personsRepositoryProvider.overrideWithValue(
          persons ?? FakePersonsRepository(),
        ),
        employmentRepositoryProvider.overrideWithValue(
          employment ?? FakeEmploymentRepository(),
        ),
        positionsRepositoryProvider.overrideWithValue(
          positions ?? FakePositionsRepository(),
        ),
        schedulesRepositoryProvider.overrideWithValue(
          schedules ?? FakeSchedulesRepository(),
        ),
      ],
      child: CapitalHumanoApp(router: router),
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  return router;
}

Future<void> _save(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Guardar'));
  await tester.tap(find.text('Guardar'));
  await tester.pumpAndSettle();
}

void main() {
  group('el rol decide qué botones de escritura se ven', () {
    // (ruta, textos de botón, tooltips de acción por fila o menú)
    final screens = <(String, List<String>, List<String>)>[
      (
        '/personas',
        ['Agregar persona'],
        ['Editar a Pérez López Juan', 'Eliminar a Pérez López Juan'],
      ),
      (
        '/posiciones',
        ['Agregar posición'],
        ['Editar posición', 'Eliminar posición'],
      ),
      (
        '/posiciones/puestos',
        ['Agregar puesto'],
        ['Editar Auxiliar de Producción'],
      ),
      ('/horarios/tipos', ['Agregar tipo de horario'], ['Editar Horario 1']),
      (
        '/horarios/catorcenas',
        ['Agregar catorcena'],
        ['Editar catorcena', 'Eliminar catorcena'],
      ),
      (
        '/horarios/asignaciones-horario',
        ['Agregar asignación'],
        ['Editar asignación', 'Eliminar asignación'],
      ),
      ('/ubicaciones', ['Agregar ubicación'], ['Editar MATRIZ']),
      ('/empleados', ['Agregar empleado'], ['Editar empleado ADV0001']),
      (
        '/organizacion/empresas',
        ['Agregar empresa'],
        ['Editar Empresa de prueba'],
      ),
      (
        '/organizacion/organigrama',
        <String>[],
        ['Acciones de Empresa de prueba'],
      ),
    ];

    for (final (path, buttons, tooltips) in screens) {
      testWidgets('$path: Capital Humano los ve, un Colaborador no', (
        tester,
      ) async {
        await pumpAll(tester, path: path);
        for (final label in buttons) {
          expect(find.text(label), findsWidgets, reason: 'CH ve "$label"');
        }
        for (final tooltip in tooltips) {
          expect(
            find.byTooltip(tooltip),
            findsWidgets,
            reason: 'CH ve "$tooltip"',
          );
        }

        await pumpAll(tester, path: path, user: testColaborador);
        for (final label in buttons) {
          expect(
            find.text(label),
            findsNothing,
            reason: 'Colaborador "$label"',
          );
        }
        for (final tooltip in tooltips) {
          expect(
            find.byTooltip(tooltip),
            findsNothing,
            reason: 'Colaborador "$tooltip"',
          );
        }
      });
    }

    testWidgets(
      'un Colaborador sigue pudiendo abrir un expediente (solo lectura)',
      (tester) async {
        final router = await pumpAll(
          tester,
          path: '/personas',
          user: testColaborador,
        );
        await tester.tap(find.byTooltip('Ver a Pérez López Juan'));
        await tester.pumpAndSettle();
        expect(router.routeInformationProvider.value.uri.path, '/personas/p1');
        expect(find.text('Editar'), findsNothing);
        expect(find.text('Agregar contacto'), findsNothing);
      },
    );

    testWidgets('detalle de empleado: «Editar» solo para quien puede', (
      tester,
    ) async {
      await pumpAll(tester, path: '/empleados/e1');
      expect(find.text('Editar'), findsOneWidget);
      await pumpAll(tester, path: '/empleados/e1', user: testColaborador);
      expect(find.text('Editar'), findsNothing);
    });
  });

  group('un borrado bloqueado explica por qué', () {
    testWidgets('el diálogo muestra el motivo que da el servidor (409)', (
      tester,
    ) async {
      final repository = FakePersonsRepository();
      await pumpAll(tester, path: '/personas', persons: repository);
      repository.failure = _http(409, {
        'detail': 'No se puede eliminar porque todavía está en uso por: 1 Empleado. Resuelve esos registros primero.',
      });

      await tester.tap(find.byTooltip('Eliminar a Pérez López Juan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();

      expect(find.text('Eliminar persona'), findsOneWidget); // sigue abierto
      expect(
        find.text(
          'No se puede eliminar porque todavía está en uso por: 1 Empleado. Resuelve esos registros primero.',
        ),
        findsOneWidget,
      );
    });
  });

  group('puestos', () {
    testWidgets('agregar guarda el nombre y las marcas', (tester) async {
      final positions = FakePositionsRepository();
      await pumpAll(tester, path: '/posiciones/puestos', positions: positions);

      await tester.tap(find.text('Agregar puesto'));
      await tester.pumpAndSettle();
      expect(find.byType(AppFormPanel), findsOneWidget);

      await tester.enterText(
        find.byType(TextFormField).first,
        'Jefe de Almacén',
      );
      await tester.tap(find.text('Es gerencia de la unidad'));
      await tester.pump();
      await _save(tester);

      expect(positions.puestoCreated, isTrue);
      expect(positions.savedPuesto?.name, 'Jefe de Almacén');
      expect(positions.savedPuesto?.isActive, isTrue);
      expect(positions.savedPuesto?.esGerenciaDeUnidad, isTrue);
      expect(find.byType(AppFormPanel), findsNothing);
      expect(find.text('Puesto guardado.'), findsOneWidget);
    });

    testWidgets('el nombre es obligatorio', (tester) async {
      final positions = FakePositionsRepository();
      await pumpAll(tester, path: '/posiciones/puestos', positions: positions);
      await tester.tap(find.text('Agregar puesto'));
      await tester.pumpAndSettle();
      await _save(tester);
      expect(find.text('Este dato es obligatorio.'), findsOneWidget);
      expect(positions.savedPuesto, isNull);
    });

    testWidgets('editar parte de los datos actuales y conserva el código', (
      tester,
    ) async {
      final positions = FakePositionsRepository();
      await pumpAll(tester, path: '/posiciones/puestos', positions: positions);

      await tester.tap(find.byTooltip('Editar Auxiliar de Producción'));
      await tester.pumpAndSettle();
      expect(find.text('Editar puesto'), findsOneWidget);
      expect(
        find.widgetWithText(TextFormField, 'Auxiliar de Producción'),
        findsOneWidget,
      );

      await tester.enterText(
        find.byType(TextFormField).first,
        'Auxiliar General',
      );
      await _save(tester);

      expect(positions.puestoCreated, isFalse);
      expect(positions.savedPuesto?.id, 1);
      expect(positions.savedPuesto?.code, 'AUX');
      expect(positions.savedPuesto?.name, 'Auxiliar General');
    });

    testWidgets('clic en la fila también abre la edición', (tester) async {
      await pumpAll(tester, path: '/posiciones/puestos');
      await tester.tap(find.text('Auxiliar de Producción'));
      await tester.pumpAndSettle();
      expect(find.text('Editar puesto'), findsOneWidget);
    });

    testWidgets('un rechazo del servidor se explica y el panel sigue abierto', (
      tester,
    ) async {
      final positions = FakePositionsRepository();
      await pumpAll(tester, path: '/posiciones/puestos', positions: positions);
      await tester.tap(find.text('Agregar puesto'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, 'Repetido');
      positions.failure = _http(400, {
        'name': ['Ya existe un puesto con ese nombre.'],
      });
      await _save(tester);

      expect(
        find.text('Nombre: Ya existe un puesto con ese nombre.'),
        findsOneWidget,
      );
      expect(find.byType(AppFormPanel), findsOneWidget);
    });
  });

  group('tipos de horario', () {
    testWidgets('agregar guarda nombre y horario', (tester) async {
      final schedules = FakeSchedulesRepository();
      await pumpAll(tester, path: '/horarios/tipos', schedules: schedules);

      await tester.tap(find.text('Agregar tipo de horario'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), 'H09');
      await tester.enterText(find.byType(TextFormField).at(1), '06:00 - 14:00');
      await _save(tester);

      expect(schedules.tipoCreated, isTrue);
      expect(schedules.savedTipo?.name, 'H09');
      expect(schedules.savedTipo?.descripcion, '06:00 - 14:00');
      expect(schedules.savedTipo?.isActive, isTrue);
      expect(find.text('Tipo de horario guardado.'), findsOneWidget);
    });

    testWidgets('editar permite desactivarlo sin borrarlo', (tester) async {
      final schedules = FakeSchedulesRepository();
      await pumpAll(tester, path: '/horarios/tipos', schedules: schedules);

      await tester.tap(find.byTooltip('Editar Horario 1'));
      await tester.pumpAndSettle();
      expect(find.text('Editar tipo de horario'), findsOneWidget);
      await tester.tap(find.widgetWithText(SwitchListTile, 'Activo'));
      await tester.pump();
      await _save(tester);

      expect(schedules.tipoCreated, isFalse);
      expect(schedules.savedTipo?.id, 1);
      expect(schedules.savedTipo?.code, 'H01');
      expect(schedules.savedTipo?.isActive, isFalse);
    });
  });

  group('empresas', () {
    testWidgets('editar trae el nombre del nodo y guarda los datos legales', (
      tester,
    ) async {
      final organizations = FakeOrganizationsRepository();
      await pumpAll(
        tester,
        path: '/organizacion/empresas',
        organizations: organizations,
      );

      await tester.tap(find.byTooltip('Editar Empresa de prueba'));
      await tester.pumpAndSettle();
      expect(find.text('Editar empresa'), findsOneWidget);
      // Nombre (del nodo), razón social, RFC, registro patronal.
      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(
        find.widgetWithText(TextFormField, 'Empresa de prueba'),
        findsOneWidget,
      );

      await tester.enterText(
        find.byType(TextFormField).at(1),
        'Azimatronics, S.A. de C.V.',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'AZI010203AB1');
      await _save(tester);

      expect(organizations.updatedCompany?.id, 'c1');
      expect(
        organizations.updatedCompany?.legalName,
        'Azimatronics, S.A. de C.V.',
      );
      expect(organizations.updatedCompany?.rfc, 'AZI010203AB1');
      expect(organizations.updatedCompanyName, 'Empresa de prueba');
      expect(find.text('Empresa guardada.'), findsOneWidget);
    });

    testWidgets(
      'agregar pide nombre y código y crea el nodo de nivel Empresa',
      (tester) async {
        final organizations = FakeOrganizationsRepository();
        await pumpAll(
          tester,
          path: '/organizacion/empresas',
          organizations: organizations,
        );

        await tester.tap(find.text('Agregar empresa'));
        await tester.pumpAndSettle();
        // Nombre, código, razón social, RFC, registro patronal.
        expect(find.byType(TextFormField), findsNWidgets(5));

        await _save(tester);
        expect(find.text('Este dato es obligatorio.'), findsNWidgets(2));
        expect(organizations.createdCompany, isNull);

        await tester.enterText(
          find.byType(TextFormField).at(0),
          'Empresa nueva',
        );
        await tester.enterText(find.byType(TextFormField).at(1), 'GPA-NUEVA');
        await _save(tester);

        expect(organizations.createdCompanyLevel, 1); // el nivel «Empresa»
        expect(organizations.createdCompanyName, 'Empresa nueva');
        expect(organizations.createdCompanyCode, 'GPA-NUEVA');
        // Los datos legales pueden quedar vacíos (pendientes).
        expect(organizations.createdCompany?.legalName, isEmpty);
      },
    );
  });

  group('organigrama', () {
    Future<void> openMenu(WidgetTester tester, String nodeName) async {
      await tester.tap(find.byTooltip('Acciones de $nodeName'));
      await tester.pumpAndSettle();
    }

    testWidgets(
      'agregar una unidad dentro de un nodo la crea y abre el padre',
      (tester) async {
        final organizations = FakeOrganizationsRepository();
        await pumpAll(
          tester,
          path: '/organizacion/organigrama',
          organizations: organizations,
        );
        expect(find.text('Unidad de negocio'), findsNothing); // todo cerrado

        await openMenu(tester, 'Empresa de prueba');
        await tester.tap(find.text('Agregar unidad dentro'));
        await tester.pumpAndSettle();

        expect(find.text('Agregar unidad'), findsOneWidget);
        expect(find.text('Dentro de Empresa de prueba'), findsOneWidget);
        // El nivel ya viene elegido: el inmediato siguiente al del padre.
        expect(find.text('Unidad'), findsOneWidget);

        await tester.enterText(find.byType(TextFormField).at(0), 'Logística');
        await tester.enterText(find.byType(TextFormField).at(1), 'GPA-LOG');
        await _save(tester);

        expect(organizations.nodeCreated, isTrue);
        expect(organizations.savedNode?.parent, 'root');
        expect(organizations.savedNode?.level, 2);
        expect(organizations.savedNode?.name, 'Logística');
        expect(organizations.savedNode?.code, 'GPA-LOG');
        expect(organizations.savedNode?.isActive, isTrue);
        expect(find.text('Unidad guardada.'), findsOneWidget);
        // El padre queda abierto para ver lo recién creado.
        expect(find.text('Unidad de negocio'), findsOneWidget);
      },
    );

    testWidgets(
      'editar conserva nivel y padre, y el árbol no se cierra al guardar',
      (tester) async {
        final organizations = FakeOrganizationsRepository();
        await pumpAll(
          tester,
          path: '/organizacion/organigrama',
          organizations: organizations,
        );
        await tester.tap(find.byTooltip('Expandir Empresa de prueba'));
        await tester.pumpAndSettle();

        await openMenu(tester, 'Unidad de negocio');
        await tester.tap(find.text('Editar'));
        await tester.pumpAndSettle();
        expect(find.text('Editar unidad'), findsOneWidget);
        expect(
          find.widgetWithText(TextFormField, 'Unidad de negocio'),
          findsOneWidget,
        );

        await tester.enterText(
          find.byType(TextFormField).at(0),
          'Negocio renombrado',
        );
        await _save(tester);

        expect(organizations.nodeCreated, isFalse);
        expect(organizations.savedNode?.id, 'child');
        expect(organizations.savedNode?.level, 2);
        expect(organizations.savedNode?.parent, 'root');
        expect(organizations.savedNode?.name, 'Negocio renombrado');
        // Se recargó el árbol y sigue abierto: el hijo no desapareció.
        expect(find.text('Unidad de negocio'), findsOneWidget);
      },
    );

    testWidgets('eliminar pide confirmación y borra el nodo', (tester) async {
      final organizations = FakeOrganizationsRepository();
      await pumpAll(
        tester,
        path: '/organizacion/organigrama',
        organizations: organizations,
      );

      await openMenu(tester, 'Empresa de prueba');
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();
      expect(find.text('Eliminar unidad'), findsOneWidget);

      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();
      expect(organizations.deletedNode, 'root');
      expect(find.text('Unidad eliminada.'), findsOneWidget);
    });

    testWidgets('un nodo en uso no se borra y el diálogo dice qué lo usa', (
      tester,
    ) async {
      final organizations = FakeOrganizationsRepository();
      await pumpAll(
        tester,
        path: '/organizacion/organigrama',
        organizations: organizations,
      );
      organizations.failure = _http(409, {
        'detail': 'No se puede eliminar porque todavía está en uso por: 3 Nodos organizacionales. Resuelve esos registros primero.',
      });

      await openMenu(tester, 'Empresa de prueba');
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();

      expect(organizations.deletedNode, isNull);
      expect(find.text('Eliminar unidad'), findsOneWidget);
      expect(find.textContaining('3 Nodos organizacionales'), findsOneWidget);
    });

    test(
      'childLevelsFor ofrece solo los niveles que el servidor aceptaría',
      () {
        const empresa = OrganizationLevel(
          id: 1,
          numero: 1,
          code: 'empresa',
          name: 'Empresa',
          allowsRecursiveNesting: false,
        );
        const unidadOrg = OrganizationLevel(
          id: 2,
          numero: 2,
          code: 'uo',
          name: 'Unidad organizacional',
          allowsRecursiveNesting: false,
        );
        const negocio = OrganizationLevel(
          id: 3,
          numero: 3,
          code: 'un',
          name: 'Unidad de negocio',
          allowsRecursiveNesting: true,
        );
        const levels = [
          negocio,
          empresa,
          unidadOrg,
        ]; // desordenados a propósito
        OrganizationNode at(int level) => OrganizationNode(
          id: 'n$level',
          tenant: 1,
          level: level,
          code: 'C',
          name: 'N',
          isActive: true,
        );

        // Un nivel se puede saltar: bajo una Empresa caben los dos siguientes.
        expect(childLevelsFor(levels, at(1)).map((l) => l.id), [2, 3]);
        expect(childLevelsFor(levels, at(2)).map((l) => l.id), [3]);
        // Unidad de negocio se anida a sí misma: su único hijo posible es otro.
        expect(childLevelsFor(levels, at(3)).map((l) => l.id), [3]);
        // Un nivel que no se anida y es el último no admite nada dentro.
        expect(childLevelsFor(const [empresa, unidadOrg], at(2)), isEmpty);
        expect(childLevelsFor(levels, at(99)), isEmpty);
      },
    );
  });

  group('empleados', () {
    testWidgets('agregar: busca la persona en el servidor, la elige y guarda', (
      tester,
    ) async {
      final employment = FakeEmploymentRepository();
      await pumpAll(tester, path: '/empleados', employment: employment);

      await tester.tap(find.text('Agregar empleado'));
      await tester.pumpAndSettle();
      expect(find.byType(AppFormPanel), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).at(0), 'ana');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(employment.searches, ['ana']);
      expect(find.text('Ruiz Ana'), findsOneWidget);
      expect(
        find.text('ana@example.test'),
        findsOneWidget,
      ); // distingue homónimos

      await tester.tap(find.text('Ruiz Ana'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(1), 'ADV0200');
      await _save(tester);

      expect(employment.created, isTrue);
      expect(employment.saved?.persona, 'p2');
      expect(employment.saved?.workNumber, 'ADV0200');
      expect(find.byType(AppFormPanel), findsNothing);
      expect(find.text('Empleado guardado.'), findsOneWidget);
    });

    testWidgets('no consulta con una letra y espera a que dejes de teclear', (
      tester,
    ) async {
      final employment = FakeEmploymentRepository();
      await pumpAll(tester, path: '/empleados', employment: employment);
      await tester.tap(find.text('Agregar empleado'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'a');
      await tester.pump(const Duration(milliseconds: 400));
      expect(employment.searches, isEmpty);

      // Dos teclazos seguidos: solo se consulta lo último.
      await tester.enterText(find.byType(TextFormField).at(0), 'an');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(find.byType(TextFormField).at(0), 'ana');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(employment.searches, ['ana']);
    });

    testWidgets('sin elegir a la persona no guarda', (tester) async {
      final employment = FakeEmploymentRepository();
      await pumpAll(tester, path: '/empleados', employment: employment);
      await tester.tap(find.text('Agregar empleado'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(1), 'ADV0300');
      await _save(tester);

      expect(find.text('Elige a la persona de la lista.'), findsOneWidget);
      expect(employment.saved, isNull);
      expect(find.byType(AppFormPanel), findsOneWidget);
    });

    testWidgets('si ya era empleada lo dice con claridad', (tester) async {
      final employment = FakeEmploymentRepository();
      await pumpAll(tester, path: '/empleados', employment: employment);
      await tester.tap(find.text('Agregar empleado'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), 'ana');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ruiz Ana'));
      await tester.pumpAndSettle();
      employment.failure = _http(400, {
        'persona': ['Ya existe empleado con este persona.'],
      });
      await _save(tester);

      expect(
        find.text(
          'Esa persona ya es empleada. Búscala en la lista de empleados.',
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'editar muestra la persona sin dejar cambiarla y guarda el número',
      (tester) async {
        final employment = FakeEmploymentRepository();
        await pumpAll(tester, path: '/empleados', employment: employment);

        await tester.tap(find.byTooltip('Editar empleado ADV0001'));
        await tester.pumpAndSettle();
        expect(find.text('Editar empleado'), findsOneWidget);
        // Solo el número de nómina es editable: no hay buscador de persona.
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'ADV0001'), findsOneWidget);

        await tester.enterText(find.byType(TextFormField), 'ADV0009');
        await _save(tester);

        expect(employment.created, isFalse);
        expect(employment.saved?.id, 'e1');
        expect(employment.saved?.persona, 'p1');
        expect(employment.saved?.workNumber, 'ADV0009');
      },
    );

    testWidgets('el detalle del empleado también se edita', (tester) async {
      final employment = FakeEmploymentRepository();
      await pumpAll(tester, path: '/empleados/e1', employment: employment);
      await tester.tap(find.text('Editar'));
      await tester.pumpAndSettle();
      expect(find.text('Editar empleado'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), 'ADV0010');
      await _save(tester);
      expect(employment.saved?.workNumber, 'ADV0010');
      expect(find.byType(AppFormPanel), findsNothing);
    });
  });
}
