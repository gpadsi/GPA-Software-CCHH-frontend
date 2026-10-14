// R5: recargar la página o recuperar la sesión vuelve a la ruta en la que se
// estaba, también en los detalles que no son destinos del menú.
import 'package:capital_humano_front/core/auth/auth_models.dart';
import 'package:capital_humano_front/core/auth/session_controller.dart';
import 'package:capital_humano_front/core/routing/app_router.dart';
import 'package:capital_humano_front/core/routing/navigation.dart';
import 'package:capital_humano_front/features/recruitment/application/recruitment_controller.dart';
import 'package:capital_humano_front/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'recruitment_fixtures.dart';
import 'test_session.dart';

Future<(GoRouter, ValueNotifier<SessionState>)> _pump(
  WidgetTester tester, {
  required String location,
  required SessionState initial,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1440, 1000);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final session = ValueNotifier(initial);
  final router = createAppRouter(
    initialLocation: location,
    session: () => session.value,
    refreshListenable: session,
  );
  addTearDown(router.dispose);
  addTearDown(session.dispose);
  await tester.pumpWidget(
    ProviderScope(
      key: UniqueKey(),
      overrides: [
        sessionControllerProvider.overrideWith(() => TestSessionController()),
        recruitmentRepositoryProvider.overrideWithValue(
          FakeRecruitmentRepository(),
        ),
      ],
      child: CapitalHumanoApp(router: router),
    ),
  );
  await tester.pumpAndSettle();
  return (router, session);
}

const _signedIn = SessionState(status: SessionStatus.signedIn, user: testUser);

void main() {
  group('canReturnTo', () {
    test('acepta destinos del menú y sus detalles, con su consulta', () {
      for (final location in [
        '/dashboard',
        '/reclutamiento',
        '/reclutamiento/descriptivos',
        '/reclutamiento/descriptivos/d1',
        '/reclutamiento/requisiciones/r1/editar',
        '/reclutamiento/requisiciones/nueva?posicion=pos1',
        '/personas/p1',
        '/empleados/e1',
        '/posiciones/puestos',
      ]) {
        expect(canReturnTo(location), isTrue, reason: location);
      }
    });

    test('rechaza otras direcciones, rutas de sesión y rutas desconocidas', () {
      for (final location in [
        '',
        '/',
        '/login',
        '/session?from=/dashboard',
        '/desconocida',
        '/reclutamientos',
        'reclutamiento',
        '//evil.test/reclutamiento',
        'https://evil.test/reclutamiento',
        'javascript:alert(1)',
      ]) {
        expect(canReturnTo(location), isFalse, reason: location);
      }
    });
  });

  group('volver a la ruta tras recuperar la sesión', () {
    testWidgets('una ruta de detalle que no es del menú se conserva', (
      tester,
    ) async {
      final (router, session) = await _pump(
        tester,
        location: '/reclutamiento/descriptivos',
        initial: const SessionState(status: SessionStatus.restoring),
      );
      expect(router.routeInformationProvider.value.uri.path, '/session');
      expect(
        router.routeInformationProvider.value.uri.queryParameters['from'],
        '/reclutamiento/descriptivos',
      );

      session.value = _signedIn;
      await tester.pumpAndSettle();
      expect(
        router.routeInformationProvider.value.uri.path,
        '/reclutamiento/descriptivos',
      );
      expect(find.text('Descriptivos de puesto'), findsWidgets);
    });

    testWidgets('también conserva la consulta de la ruta', (tester) async {
      final (router, session) = await _pump(
        tester,
        location: '/reclutamiento/requisiciones/nueva?posicion=pos1',
        initial: const SessionState(status: SessionStatus.signedOut),
      );
      expect(router.routeInformationProvider.value.uri.path, '/login');

      session.value = _signedIn;
      await tester.pumpAndSettle();
      final uri = router.routeInformationProvider.value.uri;
      expect(uri.path, '/reclutamiento/requisiciones/nueva');
      expect(uri.queryParameters['posicion'], 'pos1');
    });

    testWidgets('una dirección ajena en «from» cae en el Inicio', (
      tester,
    ) async {
      final (router, session) = await _pump(
        tester,
        location: '/login?from=https://evil.test/robo',
        initial: const SessionState(status: SessionStatus.signedOut),
      );
      session.value = _signedIn;
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, '/dashboard');
    });

    testWidgets('un destino del menú sigue funcionando', (tester) async {
      final (router, session) = await _pump(
        tester,
        location: '/reclutamiento',
        initial: const SessionState(status: SessionStatus.restoring),
      );
      session.value = _signedIn;
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, '/reclutamiento');
    });
  });
}
