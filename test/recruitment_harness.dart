import 'package:capital_humano_front/core/auth/auth_models.dart';
import 'package:capital_humano_front/core/auth/session_controller.dart';
import 'package:capital_humano_front/core/files/file_saver.dart';
import 'package:capital_humano_front/core/routing/app_router.dart';
import 'package:capital_humano_front/features/employment/application/employment_controller.dart';
import 'package:capital_humano_front/features/positions/application/positions_controller.dart';
import 'package:capital_humano_front/features/recruitment/application/recruitment_controller.dart';
import 'package:capital_humano_front/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'phase_three_fixtures.dart';
import 'phase_four_fixtures.dart';
import 'recruitment_fixtures.dart';
import 'test_session.dart';

/// La app completa con Reclutamiento falso, el guardado de archivos falso y la
/// cuenta indicada (Capital Humano por defecto).
Future<GoRouter> pumpRecruitment(
  WidgetTester tester, {
  required String path,
  required FakeRecruitmentRepository repository,
  FakeFileSaver? saver,
  FakeEmploymentRepository? employment,
  FakePositionsRepository? positions,
  SessionUser user = testUser,
  double width = 1440,
  double height = 1000,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
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
      // Clave nueva en cada montaje (ver edit_screens_test.dart).
      key: UniqueKey(),
      overrides: [
        sessionControllerProvider.overrideWith(
          () => TestSessionController(user: user),
        ),
        recruitmentRepositoryProvider.overrideWithValue(repository),
        if (positions != null)
          positionsRepositoryProvider.overrideWithValue(positions),
        fileSaverProvider.overrideWithValue(saver ?? FakeFileSaver()),
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

Future<void> pumpDebounce(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pumpAndSettle();
}

Future<void> saveForm(WidgetTester tester, {String label = 'Guardar'}) async {
  await tester.ensureVisible(find.text(label));
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

/// Abre un campo desplegable por su etiqueta y elige una opción.
Future<void> choose(
  WidgetTester tester, {
  required String field,
  required String option,
}) async {
  await tester.ensureVisible(find.text(field).first);
  await tester.tap(find.text(field).first);
  await tester.pumpAndSettle();
  await tester.tap(find.text(option).last);
  await tester.pumpAndSettle();
}

/// Toca un botón por su tooltip, desplazando antes la tabla o la página si hace
/// falta: en las pruebas el texto usa una fuente muy ancha y la fila se sale
/// de la pantalla (en la app real cabe).
Future<void> tapTooltip(WidgetTester tester, String tooltip) async {
  await tester.ensureVisible(find.byTooltip(tooltip));
  await tester.tap(find.byTooltip(tooltip));
  await tester.pumpAndSettle();
}
