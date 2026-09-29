import 'package:capital_humano_front/core/auth/session_controller.dart';
import 'package:capital_humano_front/features/auth/presentation/login_page.dart';
import 'package:capital_humano_front/features/dashboard/application/dashboard_controller.dart';
import 'package:capital_humano_front/features/dashboard/data/dashboard_repository.dart';
import 'package:capital_humano_front/features/dashboard/presentation/dashboard_page.dart';
import 'package:capital_humano_front/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'test_session.dart';

void main() {
  testWidgets('rutas protegidas, credenciales inválidas y retorno al destino', (
    tester,
  ) async {
    await pumpSession(tester, signedIn: false);
    expect(find.byType(LoginPage), findsOneWidget);
    final router = GoRouter.of(tester.element(find.byType(LoginPage)));
    router.go('/personas');
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/login');
    expect(
      router.routeInformationProvider.value.uri.queryParameters['from'],
      '/personas',
    );
    await tester.enterText(find.byType(TextFormField).at(0), 'incorrecto');
    await tester.enterText(find.byType(TextFormField).at(1), 'clave-prueba');
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pump();
    expect(
      tester.widget<TextFormField>(find.byType(TextFormField).first).enabled,
      isFalse,
    );
    await tester.pumpAndSettle();
    expect(
      find.text('El usuario o la contraseña no son correctos.'),
      findsOneWidget,
    );
    expect(router.routeInformationProvider.value.uri.path, '/login');
    await tester.enterText(find.byType(TextFormField).at(0), 'correcto');
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/personas');
    expect(find.byType(LoginPage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sesión abierta evita login, muestra conteos y permite salir', (
    tester,
  ) async {
    await pumpSession(tester, signedIn: true);
    final router = GoRouter.of(tester.element(find.byType(DashboardPage)));
    expect(find.text('1,234'), findsNWidgets(4));
    router.go('/login');
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/dashboard');
    await tester.tap(find.byTooltip('Menú de usuario'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/login');
    router.go('/dashboard');
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final width in [320.0, 640.0, 1024.0, 1440.0]) {
    testWidgets('login accesible a $width px y texto 1.5', (tester) async {
      await pumpSession(tester, signedIn: false, width: width, textScale: 1.5);
      expect(find.byType(LoginPage), findsOneWidget);
      await tester.ensureVisible(find.text('Iniciar sesión'));
      await tester.tap(find.text('Iniciar sesión'));
      await tester.pumpAndSettle();
      expect(find.text('Escribe tu usuario.'), findsOneWidget);
      expect(find.text('Escribe tu contraseña.'), findsOneWidget);
      await tester.ensureVisible(find.byTooltip('Mostrar contraseña'));
      await tester.tap(find.byTooltip('Mostrar contraseña'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Ocultar contraseña'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}

Future<void> pumpSession(
  WidgetTester tester, {
  required bool signedIn,
  double width = 1440,
  double textScale = 1,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 1000);
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sessionControllerProvider.overrideWith(
          () => TestSessionController(signedIn: signedIn),
        ),
        for (final metric in DashboardMetric.values)
          dashboardCountProvider(metric).overrideWith((ref) async => 1234),
      ],
      child: const CapitalHumanoApp(),
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}
