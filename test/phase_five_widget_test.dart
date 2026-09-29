import 'package:capital_humano_front/core/auth/auth_models.dart';
import 'package:capital_humano_front/core/auth/session_controller.dart';
import 'package:capital_humano_front/core/routing/app_router.dart';
import 'package:capital_humano_front/features/schedules/application/schedules_controller.dart';
import 'package:capital_humano_front/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'phase_five_fixtures.dart';
import 'test_session.dart';

void main() {
  testWidgets('catorcenas: la lista muestra los periodos reales', (
    tester,
  ) async {
    final repository = FakeSchedulesRepository();
    await pumpPhaseFive(tester, path: '/horarios/catorcenas', schedules: repository);
    expect(find.text('5/2026'), findsOneWidget);
  });

  testWidgets('catorcenas: agregar exige número y año', (tester) async {
    final repository = FakeSchedulesRepository();
    await pumpPhaseFive(tester, path: '/horarios/catorcenas', schedules: repository);
    await tester.tap(find.text('Agregar catorcena'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Este dato es obligatorio.'), findsNWidgets(2));
    expect(repository.saved, isNull);
  });

  testWidgets('catorcenas: editar conserva los datos y guarda', (
    tester,
  ) async {
    final repository = FakeSchedulesRepository();
    await pumpPhaseFive(tester, path: '/horarios/catorcenas', schedules: repository);
    await tester.ensureVisible(find.byTooltip('Editar catorcena'));
    await tester.tap(find.byTooltip('Editar catorcena'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Guardar'));
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(repository.created, false);
    expect(repository.saved?.numero, 5);
  });

  testWidgets('catorcenas: eliminar pide confirmación', (tester) async {
    final repository = FakeSchedulesRepository();
    await pumpPhaseFive(tester, path: '/horarios/catorcenas', schedules: repository);
    await tester.ensureVisible(find.byTooltip('Eliminar catorcena'));
    await tester.tap(find.byTooltip('Eliminar catorcena'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    expect(repository.deleted, 'k1');
  });

  testWidgets('tipos de horario: catálogo de solo lectura', (tester) async {
    final repository = FakeSchedulesRepository();
    await pumpPhaseFive(tester, path: '/horarios/tipos', schedules: repository);
    expect(find.text('Horario 1'), findsOneWidget);
    expect(find.text('07:00 - 16:00'), findsOneWidget);
  });

  testWidgets(
    'asignaciones de horario: la lista resuelve el tipo de horario',
    (tester) async {
      final repository = FakeSchedulesRepository();
      await pumpPhaseFive(
        tester,
        path: '/horarios/asignaciones-horario',
        schedules: repository,
      );
      expect(find.text('Horario 1'), findsOneWidget);
      expect(find.text('ADV0001'), findsOneWidget);
    },
  );

  testWidgets('asignaciones de horario: agregar exige empleado y tipo', (
    tester,
  ) async {
    final repository = FakeSchedulesRepository();
    await pumpPhaseFive(
      tester,
      path: '/horarios/asignaciones-horario',
      schedules: repository,
    );
    await tester.tap(find.text('Agregar asignación'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Elige un empleado.'), findsOneWidget);
    expect(find.text('Elige un tipo de horario.'), findsOneWidget);
    expect(repository.savedHorario, isNull);
  });

  testWidgets('asignaciones de horario: editar conserva la selección y guarda', (
    tester,
  ) async {
    final repository = FakeSchedulesRepository();
    await pumpPhaseFive(
      tester,
      path: '/horarios/asignaciones-horario',
      schedules: repository,
    );
    await tester.ensureVisible(find.byTooltip('Editar asignación'));
    await tester.tap(find.byTooltip('Editar asignación'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Guardar'));
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(repository.createdHorario, false);
    expect(repository.savedHorario?.empleado, 'e1');
    expect(repository.savedHorario?.tipoHorario, 1);
  });

  testWidgets(
    'asignaciones de ubicación: sin datos reales se ve como vacío, no como error',
    (tester) async {
      final repository = FakeSchedulesRepository();
      await pumpPhaseFive(
        tester,
        path: '/horarios/asignaciones-ubicacion',
        schedules: repository,
      );
      expect(find.text('Sin resultados'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('asignaciones de ubicación: agregar exige empleado y área', (
    tester,
  ) async {
    final repository = FakeSchedulesRepository();
    await pumpPhaseFive(
      tester,
      path: '/horarios/asignaciones-ubicacion',
      schedules: repository,
    );
    await tester.tap(find.text('Agregar asignación'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Elige un empleado.'), findsOneWidget);
    expect(find.text('Elige un área.'), findsOneWidget);
    expect(repository.savedUbicacion, isNull);
  });

  for (final width in [320.0, 1440.0]) {
    testWidgets('fase 5 sin desbordamientos a $width px y texto 1.5', (
      tester,
    ) async {
      final router = await pumpPhaseFive(
        tester,
        path: '/horarios/catorcenas',
        width: width,
        scale: 1.5,
      );
      for (final path in [
        '/horarios/tipos',
        '/horarios/asignaciones-horario',
        '/horarios/asignaciones-ubicacion',
      ]) {
        router.go(path);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: path);
      }
    });
  }
}

Future<GoRouter> pumpPhaseFive(
  WidgetTester tester, {
  required String path,
  double width = 1440,
  double scale = 1,
  FakeSchedulesRepository? schedules,
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
