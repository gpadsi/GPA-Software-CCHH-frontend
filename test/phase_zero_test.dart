import 'package:capital_humano_front/core/design_system/theme.dart';
import 'package:capital_humano_front/core/routing/app_router.dart';
import 'package:capital_humano_front/core/routing/navigation.dart';
import 'package:capital_humano_front/core/widgets/app_data_table.dart';
import 'package:capital_humano_front/core/widgets/app_scaffold.dart';
import 'package:capital_humano_front/main.dart';
import 'package:capital_humano_front/core/auth/auth_models.dart';
import 'package:capital_humano_front/core/auth/session_controller.dart';
import 'package:capital_humano_front/features/dashboard/application/dashboard_controller.dart';
import 'package:capital_humano_front/features/dashboard/data/dashboard_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'test_session.dart';
import 'phase_two_fixtures.dart';

import 'package:capital_humano_front/features/organizations/application/organizations_controller.dart';
import 'package:capital_humano_front/features/locations/application/locations_controller.dart';

void main() {
  for (final viewport in <Size>[const Size(1440, 1000), const Size(390, 844)]) {
    testWidgets(
      'Las 19 secciones admiten navegación en ${viewport.width.toInt()} px',
      (tester) async {
        final router = await _pumpApp(tester, size: viewport);

        expect(appDestinations, hasLength(19));
        expect(
          appDestinations.map((destination) => destination.path).toSet(),
          hasLength(19),
        );

        for (final destination in appDestinations) {
          router.go(destination.path);
          await tester.pumpAndSettle();

          expect(
            router.routeInformationProvider.value.uri.path,
            destination.path,
          );
          expect(
            tester.widget<AppScaffold>(find.byType(AppScaffold)).location,
            destination.path,
          );
          expect(find.text(destination.label), findsWidgets);
          expect(tester.takeException(), isNull, reason: destination.path);
        }
      },
    );
  }

  testWidgets('La barra lateral se contrae y expande con transición', (
    tester,
  ) async {
    await _pumpApp(tester, size: const Size(1440, 1000));
    expect(find.byTooltip('Abrir menú de navegación'), findsNothing);

    final expandedWidth = tester
        .getSize(_sidebarFor('Contraer barra lateral'))
        .width;
    await tester.tap(find.byTooltip('Contraer barra lateral'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 110));
    final widthDuringCollapse = tester
        .getSize(_sidebarFor('Expandir barra lateral'))
        .width;
    await tester.pumpAndSettle();
    final collapsedWidth = tester
        .getSize(_sidebarFor('Expandir barra lateral'))
        .width;

    expect(collapsedWidth, lessThan(expandedWidth));
    expect(widthDuringCollapse, greaterThan(collapsedWidth));
    expect(widthDuringCollapse, lessThan(expandedWidth));
    expect(find.byTooltip('Contraer barra lateral'), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Expandir barra lateral'));
    await tester.pumpAndSettle();
    expect(
      tester.getSize(_sidebarFor('Contraer barra lateral')).width,
      expandedWidth,
    );
    expect(find.byTooltip('Expandir barra lateral'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('El menú móvil permite elegir una sección y se cierra', (
    tester,
  ) async {
    final router = await _pumpApp(tester, size: const Size(390, 844));
    expect(find.byTooltip('Contraer barra lateral'), findsNothing);

    await tester.tap(find.byTooltip('Abrir menú de navegación'));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsOneWidget);
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
      isTrue,
    );

    final personas = find.descendant(
      of: find.byType(Drawer),
      matching: find.text('Personas'),
    );
    await tester.scrollUntilVisible(
      personas,
      180,
      scrollable: find.descendant(
        of: find.byType(Drawer),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(personas);
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, '/personas');
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
      isFalse,
    );
    expect(tester.takeException(), isNull);
  });

  for (final width in <double>[320, 640, 1024, 1440]) {
    testWidgets(
      'Sin desbordamientos a ${width.toInt()} px con texto 1.5 y movimiento reducido',
      (tester) async {
        final router = await _pumpApp(
          tester,
          size: Size(width, 1000),
          textScaler: TextScaler.linear(1.5),
          disableAnimations: true,
        );
        final context = tester.element(find.byType(AppScaffold));
        expect(MediaQuery.textScalerOf(context).scale(10), 15);
        expect(MediaQuery.disableAnimationsOf(context), isTrue);

        for (final destination in appDestinations) {
          router.go(destination.path);
          await tester.pumpAndSettle();
          expect(find.text(destination.label), findsWidgets);
          expect(tester.takeException(), isNull, reason: destination.path);
        }

        if (width <= 1024) {
          await tester.tap(find.byTooltip('Abrir menú de navegación'));
          await tester.pumpAndSettle();
          expect(find.byType(Drawer), findsOneWidget);
          await tester.scrollUntilVisible(
            find.descendant(
              of: find.byType(Drawer),
              matching: find.text('Buzz'),
            ),
            240,
            scrollable: find.descendant(
              of: find.byType(Drawer),
              matching: find.byType(Scrollable),
            ),
          );
          expect(tester.takeException(), isNull);
          await tester.tap(find.byTooltip('Cerrar menú'));
        } else {
          await tester.tap(find.byTooltip('Contraer barra lateral'));
        }
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('La tabla solicita otra página sin paginar las filas recibidas', (
    tester,
  ) async {
    final requestedPages = <int>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: AppDataTable(
            columns: const [DataColumn(label: Text('Nombre'))],
            rows: const [
              DataRow(cells: [DataCell(Text('Registro recibido A'))]),
              DataRow(cells: [DataCell(Text('Registro recibido B'))]),
            ],
            totalCount: 100,
            pageIndex: 0,
            pageSize: 10,
            onPageChanged: requestedPages.add,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1–2 de 100 resultados'), findsOneWidget);
    expect(find.text('Página 1 de 10'), findsOneWidget);
    expect(tester.widget<DataTable>(find.byType(DataTable)).rows, hasLength(2));
    expect(
      tester
          .widget<IconButton>(
            find.byWidgetPredicate(
              (widget) =>
                  widget is IconButton && widget.tooltip == 'Página anterior',
            ),
          )
          .onPressed,
      isNull,
    );

    await tester.tap(find.byTooltip('Página siguiente'));
    await tester.pumpAndSettle();

    expect(requestedPages, [1]);
    expect(find.text('Registro recibido A'), findsOneWidget);
    expect(find.text('Registro recibido B'), findsOneWidget);
    expect(find.text('1–2 de 100 resultados'), findsOneWidget);
    expect(find.text('Página 1 de 10'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Finder _sidebarFor(String tooltip) => find.ancestor(
  of: find.byTooltip(tooltip),
  matching: find.byType(AnimatedContainer),
);

Future<GoRouter> _pumpApp(
  WidgetTester tester, {
  required Size size,
  TextScaler textScaler = TextScaler.noScaling,
  bool disableAnimations = false,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  tester.platformDispatcher.textScaleFactorTestValue = textScaler.scale(1);
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      FakeAccessibilityFeatures(
        disableAnimations: disableAnimations,
        reduceMotion: disableAnimations,
      );
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

  final session = ValueNotifier(
    const SessionState(status: SessionStatus.signedIn, user: testUser),
  );
  addTearDown(session.dispose);
  final router = createAppRouter(
    initialLocation: '/dashboard',
    session: () => session.value,
    refreshListenable: session,
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sessionControllerProvider.overrideWith(TestSessionController.new),
        organizationsRepositoryProvider.overrideWithValue(
          FakeOrganizationsRepository(),
        ),
        locationsRepositoryProvider.overrideWithValue(
          FakeLocationsRepository(),
        ),
        for (final metric in DashboardMetric.values)
          dashboardCountProvider(metric).overrideWith((ref) async => 25),
      ],
      child: CapitalHumanoApp(router: router),
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  return router;
}
