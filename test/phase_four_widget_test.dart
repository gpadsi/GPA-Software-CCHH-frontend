import 'package:capital_humano_front/core/auth/auth_models.dart';
import 'package:capital_humano_front/core/auth/session_controller.dart';
import 'package:capital_humano_front/core/network/jefe_inmediato.dart';
import 'package:capital_humano_front/core/routing/app_router.dart';
import 'package:capital_humano_front/features/employment/application/employment_controller.dart';
import 'package:capital_humano_front/features/positions/application/positions_controller.dart';
import 'package:capital_humano_front/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'phase_four_fixtures.dart';
import 'phase_three_fixtures.dart' show FakeEmploymentRepository;
import 'test_session.dart';

void main() {
  testWidgets('posiciones: la lista resuelve nombres desde los catálogos', (
    tester,
  ) async {
    final repository = FakePositionsRepository();
    await pumpPhaseFour(tester, path: '/posiciones', positions: repository);
    expect(find.text('Auxiliar de Producción'), findsOneWidget);
    expect(find.text('Producción'), findsOneWidget);
    expect(find.text('CEI Aerospace Group'), findsOneWidget);
    expect(find.text('Colaborador Activo'), findsOneWidget);
  });

  testWidgets('posiciones: agregar exige unidad organizacional y estatus', (
    tester,
  ) async {
    final repository = FakePositionsRepository();
    await pumpPhaseFour(tester, path: '/posiciones', positions: repository);
    await tester.tap(find.text('Agregar posición'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Elige a qué unidad pertenece.'), findsOneWidget);
    expect(find.text('Elige un estatus.'), findsOneWidget);
    expect(repository.saved, isNull);
  });

  testWidgets('posiciones: editar conserva la selección existente y guarda', (
    tester,
  ) async {
    final repository = FakePositionsRepository();
    await pumpPhaseFour(tester, path: '/posiciones', positions: repository);
    await tester.ensureVisible(find.byTooltip('Editar posición'));
    await tester.tap(find.byTooltip('Editar posición'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'ALAN ARTEAGA');
    await tester.ensureVisible(find.text('Guardar'));
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(repository.created, false);
    expect(repository.saved?.supervisionTexto, 'ALAN ARTEAGA');
    expect(repository.saved?.organizationNode, 'org1');
    expect(repository.saved?.estatus, 20);
  });

  testWidgets('posiciones: eliminar pide confirmación antes de borrar', (
    tester,
  ) async {
    final repository = FakePositionsRepository();
    await pumpPhaseFour(tester, path: '/posiciones', positions: repository);
    await tester.ensureVisible(find.byTooltip('Eliminar posición'));
    await tester.tap(find.byTooltip('Eliminar posición'));
    await tester.pumpAndSettle();
    expect(repository.deleted, isNull);
    await tester.ensureVisible(find.text('Eliminar'));
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    expect(repository.deleted, 'pos1');
  });

  testWidgets('puestos: catálogo de solo lectura', (tester) async {
    final repository = FakePositionsRepository();
    await pumpPhaseFour(
      tester,
      path: '/posiciones/puestos',
      positions: repository,
    );
    expect(find.text('Auxiliar de Producción'), findsOneWidget);
    expect(find.text('Activo'), findsOneWidget);
  });

  testWidgets('jefe inmediato: sin jefe se ve como estado intencional', (
    tester,
  ) async {
    await pumpPhaseFour(
      tester,
      path: '/empleados/e1',
      employment: FakeEmploymentRepository(),
      jefe: const JefeInmediato(),
    );
    expect(find.text('Sin jefe asignado todavía'), findsOneWidget);
  });

  testWidgets('jefe inmediato: con jefe resuelto navega a su expediente', (
    tester,
  ) async {
    final router = await pumpPhaseFour(
      tester,
      path: '/empleados/e1',
      employment: FakeEmploymentRepository(),
      jefe: const JefeInmediato(
        posicionId: 'pos1',
        puesto: 'Supervisor de Producción',
        empleadoId: 'e2',
        nombre: 'María López',
      ),
    );
    expect(find.text('María López'), findsOneWidget);
    expect(find.text('Supervisor de Producción'), findsOneWidget);
    await tester.ensureVisible(find.text('Ver expediente'));
    await tester.tap(find.text('Ver expediente'));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/empleados/e2');
  });
}

Future<GoRouter> pumpPhaseFour(
  WidgetTester tester, {
  required String path,
  FakePositionsRepository? positions,
  FakeEmploymentRepository? employment,
  JefeInmediato? jefe,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1440, 1000);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
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
        positionsRepositoryProvider.overrideWithValue(
          positions ?? FakePositionsRepository(),
        ),
        employmentRepositoryProvider.overrideWithValue(
          employment ?? FakeEmploymentRepository(),
        ),
        if (jefe != null)
          jefeInmediatoProvider('e1').overrideWith((ref) async => jefe),
      ],
      child: CapitalHumanoApp(router: router),
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  return router;
}
