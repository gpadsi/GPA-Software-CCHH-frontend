import 'package:capital_humano_front/core/auth/auth_models.dart';
import 'package:capital_humano_front/core/auth/session_controller.dart';
import 'package:capital_humano_front/core/design_system/app_themes.dart';
import 'package:capital_humano_front/core/design_system/colors.dart';
import 'package:capital_humano_front/core/design_system/theme_controller.dart';
import 'package:capital_humano_front/core/design_system/theme_preference_store.dart';
import 'package:capital_humano_front/core/design_system/typography.dart';
import 'package:capital_humano_front/features/dashboard/application/dashboard_controller.dart';
import 'package:capital_humano_front/features/dashboard/data/dashboard_repository.dart';
import 'package:capital_humano_front/features/dashboard/presentation/dashboard_page.dart';
import 'package:capital_humano_front/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_session.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Las letras de los temas se cargan una sola vez y fuera del reloj simulado
  // de las pruebas de widgets.
  setUpAll(
    () => AppFonts.ensureLoaded(AppThemeId.values.expand((t) => t.fonts)),
  );

  group('tema por usuario', () {
    ProviderContainer container(
      ThemePreferenceStore store, {
      AppThemeId initial = AppThemeId.fallback,
      SessionUser user = testUser,
    }) {
      final container = ProviderContainer(
        overrides: [
          themePreferenceStoreProvider.overrideWithValue(store),
          initialThemeProvider.overrideWithValue(initial),
          sessionControllerProvider.overrideWith(
            () => TestSessionController(user: user),
          ),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('al entrar se aplica el tema que eligió ese usuario', () async {
      final store = MemoryThemePreferenceStore(
        users: {testUser.id: AppThemeId.petroleo},
      );
      final themes = container(store);
      expect(themes.read(themeControllerProvider), AppThemeId.fallback);
      await pumpEventQueue();
      expect(themes.read(themeControllerProvider), AppThemeId.petroleo);
      expect(store.last, AppThemeId.petroleo);
    });

    test('quien nunca eligió ve el predeterminado aunque el navegador '
        'recuerde el tema de otra persona', () async {
      final store = MemoryThemePreferenceStore(
        last: AppThemeId.rojo,
        users: {testUser.id: AppThemeId.rojo},
      );
      final themes = container(
        store,
        initial: AppThemeId.rojo,
        user: testColaborador,
      );
      expect(themes.read(themeControllerProvider), AppThemeId.rojo);
      await pumpEventQueue();
      expect(themes.read(themeControllerProvider), AppThemeId.fallback);
      expect(store.last, AppThemeId.fallback);
      expect(store.users[testUser.id], AppThemeId.rojo);
    });

    test('elegir un tema lo recuerda para el usuario en sesión', () async {
      final store = MemoryThemePreferenceStore();
      final themes = container(store)..read(themeControllerProvider);
      await pumpEventQueue();
      await themes
          .read(themeControllerProvider.notifier)
          .select(AppThemeId.vino);
      expect(themes.read(themeControllerProvider), AppThemeId.vino);
      expect(store.users[testUser.id], AppThemeId.vino);
      expect(store.last, AppThemeId.vino);
    });

    test('la app abre con el último tema usado en este navegador', () async {
      expect(
        await loadLastTheme(MemoryThemePreferenceStore(last: AppThemeId.rojo)),
        AppThemeId.rojo,
      );
      expect(
        await loadLastTheme(MemoryThemePreferenceStore()),
        AppThemeId.fallback,
      );
    });

    test('un nombre guardado que ya no existe no rompe la app', () {
      expect(AppThemeId.byName('tema-retirado'), isNull);
      expect(AppThemeId.byName(null), isNull);
      expect(AppThemeId.byName('vino'), AppThemeId.vino);
    });
  });

  testWidgets('Apariencia cambia el tema de toda la app al momento', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1440, 1000);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = MemoryThemePreferenceStore();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          themePreferenceStoreProvider.overrideWithValue(store),
          sessionControllerProvider.overrideWith(TestSessionController.new),
          for (final metric in DashboardMetric.values)
            dashboardCountProvider(metric).overrideWith((ref) async => 1234),
        ],
        child: const CapitalHumanoApp(),
      ),
    );
    await tester.pumpAndSettle();
    AppColors colors() =>
        AppColors.of(tester.element(find.byType(DashboardPage)));
    expect(colors().sidebar, AppThemeId.fallback.colors.sidebar);

    await tester.tap(find.byTooltip('Menú de usuario'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apariencia'));
    await tester.pumpAndSettle();
    for (final theme in AppThemeId.values) {
      expect(find.text(theme.label), findsOneWidget);
    }
    expect(find.text('Predeterminado'), findsOneWidget);

    await tester.tap(find.text(AppThemeId.rojo.label));
    await tester.pumpAndSettle();
    // La letra del tema ya se cargó en setUpAll, fuera del reloj simulado: su
    // aviso de listo corre en la cola real.
    await tester.runAsync(pumpEventQueue);
    await tester.pumpAndSettle();
    expect(colors().sidebar, AppThemeId.rojo.colors.sidebar);
    expect(colors().primary, AppThemeId.rojo.colors.primary);
    expect(store.users[testUser.id], AppThemeId.rojo);

    await tester.tap(find.text('Listo'));
    await tester.pumpAndSettle();
    expect(find.text('Apariencia'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
