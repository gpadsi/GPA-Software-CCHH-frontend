import 'package:capital_humano_front/core/auth/auth_models.dart';
import 'package:capital_humano_front/core/auth/session_controller.dart';
import 'package:capital_humano_front/core/routing/app_router.dart';
import 'package:capital_humano_front/features/locations/application/locations_controller.dart';
import 'package:capital_humano_front/features/locations/data/location_models.dart';
import 'package:capital_humano_front/features/locations/presentation/location_form.dart';
import 'package:capital_humano_front/features/organizations/application/organizations_controller.dart';
import 'package:capital_humano_front/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'phase_two_fixtures.dart';
import 'test_session.dart';

void main() {
  testWidgets('organigrama expande, anida y contrae sin perder relaciones', (
    tester,
  ) async {
    await pumpPhaseTwo(tester, path: '/organizacion/organigrama');
    expect(find.text('Empresa de prueba'), findsOneWidget);
    expect(find.text('Unidad de negocio'), findsNothing);
    await tester.tap(find.byTooltip('Expandir Empresa de prueba'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Expandir Unidad de negocio'));
    await tester.pumpAndSettle();
    expect(find.text('Unidad anidada'), findsOneWidget);
    expect(find.text('Inactivo'), findsOneWidget);
    await tester.tap(find.byTooltip('Contraer Empresa de prueba'));
    await tester.pumpAndSettle();
    expect(find.text('Unidad anidada'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('empresas muestra Pendiente y solicita la segunda página', (
    tester,
  ) async {
    final repository = FakeOrganizationsRepository();
    await pumpPhaseTwo(
      tester,
      path: '/organizacion/empresas',
      organizations: repository,
    );
    expect(find.text('Pendiente'), findsNWidgets(3));
    expect(find.text('null'), findsNothing);
    await tester.tap(find.byTooltip('Página siguiente'));
    await tester.pumpAndSettle();
    expect(repository.requestedPages, [1, 2]);
    expect(find.text('Empresa segunda página'), findsOneWidget);
  });

  testWidgets('área: cambio de ubicación limpia nave y filtra sus opciones', (
    tester,
  ) async {
    final repository = FakeLocationsRepository();
    repository.items[LocationKind.areas] = [areaA.copyWith(nave: 'n1')];
    await pumpPhaseTwo(
      tester,
      path: '/ubicaciones/areas',
      locations: repository,
    );
    await tester.tap(find.byTooltip('Editar AREA'));
    await tester.pumpAndSettle();
    expect(find.text('MATRIZ · Matriz'), findsWidgets);
    await tester.tap(find.byType(DropdownButtonFormField<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('SUR · Sucursal sur').last);
    await tester.pumpAndSettle();
    expect(find.text('Sin nave confirmada'), findsWidgets);
    await tester.tap(find.byType(DropdownButtonFormField<String>).last);
    await tester.pumpAndSettle();
    expect(
      tester.widget<DropdownButton<String>>(
        find.byType(DropdownButton<String>).last,
      ).items!.map((item) => item.value),
      ['', 'n2'],
    );
    await tester.tap(find.text('N2 · Nave sur').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(repository.saved?.nave, 'n2');
    expect(repository.created, false);
    expect(find.byType(LocationForm), findsNothing);
  });

  testWidgets(
    'área nueva admite nave pendiente y conserva validación obligatoria',
    (tester) async {
      final repository = FakeLocationsRepository();
      await pumpPhaseTwo(
        tester,
        path: '/ubicaciones/areas',
        locations: repository,
      );
      await tester.tap(find.text('Agregar área'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();
      expect(find.text('Este dato es obligatorio.'), findsNWidgets(2));
      await tester.enterText(find.byType(TextFormField).at(0), 'NUEVA');
      await tester.enterText(find.byType(TextFormField).at(1), 'Área nueva');
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();
      expect(repository.saved?.nave, isNull);
      expect(repository.savedKind, LocationKind.areas);
      expect(repository.created, true);
    },
  );

  testWidgets('nave requiere ubicación pero no nombre', (tester) async {
    final repository = FakeLocationsRepository();
    await pumpPhaseTwo(
      tester,
      path: '/ubicaciones/naves',
      locations: repository,
    );
    await tester.tap(find.text('Agregar nave'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'NUEVA');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Selecciona una ubicación.'), findsOneWidget);
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('MATRIZ · Matriz').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(repository.saved?.ubicacion, 'u1');
    expect(repository.saved?.name, '');
  });

  testWidgets(
    'cancelar eliminación no envía petición; confirmar actualiza lista',
    (tester) async {
      final repository = FakeLocationsRepository();
      await pumpPhaseTwo(
        tester,
        path: '/ubicaciones/areas',
        locations: repository,
      );
      await tester.tap(find.byTooltip('Eliminar AREA'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(repository.deleted, isNull);
      await tester.tap(find.byTooltip('Eliminar AREA'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();
      expect(repository.deleted, 'a1');
      expect(find.text('Sin resultados'), findsOneWidget);
    },
  );

  testWidgets('403 al guardar conserva formulario y datos sin error crudo', (
    tester,
  ) async {
    final repository = FakeLocationsRepository();
    await pumpPhaseTwo(tester, path: '/ubicaciones', locations: repository);
    await tester.tap(find.byTooltip('Editar MATRIZ'));
    await tester.pumpAndSettle();
    repository.failure = denied();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(
      find.text('Tu cuenta no tiene permiso para modificar estos registros.'),
      findsOneWidget,
    );
    expect(find.byType(LocationForm), findsOneWidget);
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).first)
          .controller!
          .text,
      'MATRIZ',
    );
  });

  testWidgets('fallo de lectura permite reintentar sin asumir acceso total', (
    tester,
  ) async {
    final repository = FakeOrganizationsRepository()..failure = denied();
    await pumpPhaseTwo(
      tester,
      path: '/organizacion/organigrama',
      organizations: repository,
    );
    expect(
      find.text('Tu cuenta no tiene acceso a esta información.'),
      findsOneWidget,
    );
    repository.failure = null;
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('Empresa de prueba'), findsOneWidget);
  });

  for (final width in [320.0, 640.0, 1024.0, 1440.0]) {
    testWidgets('fase 2 y formularios sin overflow a $width px y texto 1.5', (
      tester,
    ) async {
      final router = await pumpPhaseTwo(
        tester,
        path: '/organizacion/organigrama',
        width: width,
        scale: 1.5,
      );
      await tester.ensureVisible(find.byTooltip('Expandir Empresa de prueba'));
      await tester.tap(find.byTooltip('Expandir Empresa de prueba'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byTooltip('Expandir Unidad de negocio'));
      await tester.tap(find.byTooltip('Expandir Unidad de negocio'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      for (final path in [
        '/organizacion/empresas',
        '/ubicaciones',
        '/ubicaciones/naves',
        '/ubicaciones/areas',
      ]) {
        router.go(path);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: path);
        if (path.startsWith('/ubicaciones')) {
          final label = path.endsWith('/areas')
              ? 'Agregar área'
              : path.endsWith('/naves')
              ? 'Agregar nave'
              : 'Agregar ubicación';
          await tester.tap(find.text(label));
          await tester.pumpAndSettle();
          await tester.ensureVisible(find.text('Guardar'));
          await tester.tap(find.text('Guardar'));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: '$path formulario');
          await tester.ensureVisible(find.text('Cancelar'));
          await tester.tap(find.text('Cancelar'));
          await tester.pumpAndSettle();
        }
      }
    });
  }
}

Future<GoRouter> pumpPhaseTwo(
  WidgetTester tester, {
  required String path,
  double width = 1440,
  double scale = 1,
  FakeOrganizationsRepository? organizations,
  FakeLocationsRepository? locations,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 1000);
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final session = ValueNotifier(
    const SessionState(status: SessionStatus.signedIn, user: testUser),
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
      overrides: [
        sessionControllerProvider.overrideWith(TestSessionController.new),
        organizationsRepositoryProvider.overrideWithValue(
          organizations ?? FakeOrganizationsRepository(),
        ),
        locationsRepositoryProvider.overrideWithValue(
          locations ?? FakeLocationsRepository(),
        ),
      ],
      child: CapitalHumanoApp(router: router),
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  return router;
}
