import 'package:capital_humano_front/core/auth/auth_models.dart';
import 'package:capital_humano_front/core/auth/session_controller.dart';
import 'package:capital_humano_front/core/routing/app_router.dart';
import 'package:capital_humano_front/features/employment/application/employment_controller.dart';
import 'package:capital_humano_front/features/persons/application/persons_controller.dart';
import 'package:capital_humano_front/features/persons/presentation/person_form.dart';
import 'package:capital_humano_front/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'phase_three_fixtures.dart';
import 'test_session.dart';

void main() {
  testWidgets('personas: crea con validación y navega al detalle', (
    tester,
  ) async {
    final repository = FakePersonsRepository();
    final router = await pumpPhaseThree(tester, path: '/personas', persons: repository);

    await tester.tap(find.text('Agregar persona'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Este dato es obligatorio.'), findsNWidgets(2));

    await tester.enterText(find.byType(TextFormField).at(0), 'Nueva');
    await tester.enterText(find.byType(TextFormField).at(1), 'Persona');
    await tester.ensureVisible(find.text('Guardar'));
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(repository.created, true);
    expect(find.byType(PersonForm), findsNothing);

    await tester.tap(find.byTooltip('Ver a Pérez López Juan').first);
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/personas/p1');
    expect(find.text('Pérez López Juan'), findsWidgets);
  });

  testWidgets('detalle de persona: datos generales, contacto y perfil médico', (
    tester,
  ) async {
    final repository = FakePersonsRepository();
    await pumpPhaseThree(tester, path: '/personas/p1', persons: repository);

    expect(find.text('No capturado'), findsWidgets);

    await tester.tap(find.text('Contacto de urgencia'));
    await tester.pumpAndSettle();
    expect(find.text('Mamá'), findsOneWidget);
    await tester.tap(find.text('Agregar contacto'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Papá');
    await tester.enterText(find.byType(TextFormField).at(1), 'Padre');
    await tester.enterText(find.byType(TextFormField).at(2), '5500000000');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(repository.createdContacto, true);

    await tester.tap(find.text('Perfil médico'));
    await tester.pumpAndSettle();
    expect(find.text('Alergias: Ninguna'), findsOneWidget);
  });

  testWidgets('perfil médico sin capturar muestra el estado vacío', (
    tester,
  ) async {
    final repository = FakePersonsRepository()..perfil = null;
    await pumpPhaseThree(tester, path: '/personas/p1', persons: repository);
    await tester.tap(find.text('Perfil médico'));
    await tester.pumpAndSettle();
    expect(find.text('Sin perfil médico capturado'), findsOneWidget);
    await tester.tap(find.text('Agregar perfil médico'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(repository.createdPerfil, true);
  });

  testWidgets('empleados: lista con nombre resuelto y detalle con contrato vigente', (
    tester,
  ) async {
    final employment = FakeEmploymentRepository();
    final router = await pumpPhaseThree(
      tester,
      path: '/empleados',
      employment: employment,
    );
    expect(find.text('ADV0001'), findsOneWidget);
    expect(find.text('Pérez López Juan'), findsOneWidget);

    await tester.tap(find.byTooltip('Ver empleado ADV0001'));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/empleados/e1');
    expect(find.text('Contrato vigente'), findsOneWidget);
    expect(find.text('Auxiliar de Producción'), findsOneWidget);
    expect(find.text('Colaborador Activo'), findsOneWidget);

    await tester.tap(find.text('Ver expediente completo'));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/personas/p1');
  });

  testWidgets('empleado sin contrato vigente muestra el estado vacío', (
    tester,
  ) async {
    final employment = FakeEmploymentRepository()..contratoVigenteValue = null;
    await pumpPhaseThree(tester, path: '/empleados/e1', employment: employment);
    expect(find.text('Sin contrato vigente'), findsOneWidget);
  });

  for (final width in [320.0, 640.0, 1024.0, 1440.0]) {
    testWidgets('fase 3 sin desbordamientos a $width px y texto 1.5', (
      tester,
    ) async {
      final router = await pumpPhaseThree(
        tester,
        path: '/personas',
        width: width,
        scale: 1.5,
      );
      for (final path in ['/personas/p1', '/empleados', '/empleados/e1']) {
        router.go(path);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: path);
      }
      router.go('/personas/p1');
      await tester.pumpAndSettle();
      for (final tab in ['Contacto de urgencia', 'Perfil médico']) {
        await tester.tap(find.text(tab));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: tab);
      }
    });
  }
}

Future<GoRouter> pumpPhaseThree(
  WidgetTester tester, {
  required String path,
  double width = 1440,
  double scale = 1,
  FakePersonsRepository? persons,
  FakeEmploymentRepository? employment,
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
        personsRepositoryProvider.overrideWithValue(
          persons ?? FakePersonsRepository(),
        ),
        employmentRepositoryProvider.overrideWithValue(
          employment ?? FakeEmploymentRepository(),
        ),
      ],
      child: CapitalHumanoApp(router: router),
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  return router;
}
