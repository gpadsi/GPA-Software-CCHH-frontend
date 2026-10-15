import 'package:capital_humano_front/core/auth/session_controller.dart';
import 'package:capital_humano_front/core/design_system/app_themes.dart';
import 'package:capital_humano_front/core/design_system/brand.dart';
import 'package:capital_humano_front/core/design_system/font_controller.dart';
import 'package:capital_humano_front/core/design_system/font_preference_store.dart';
import 'package:capital_humano_front/core/design_system/theme.dart';
import 'package:capital_humano_front/core/design_system/theme_controller.dart';
import 'package:capital_humano_front/core/design_system/theme_preference_store.dart';
import 'package:capital_humano_front/core/design_system/typography.dart';
import 'package:capital_humano_front/core/widgets/appearance_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_session.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(
    () => AppFonts.ensureLoaded(AppFontChoice.values.expand((f) => f.fonts)),
  );

  test(
    'la fuente se restaura por usuario y permanece al cambiar de tema',
    () async {
      final store = MemoryFontPreferenceStore(
        users: {testUser.id: AppFontChoice.outfit},
      );
      final container = ProviderContainer(
        overrides: [
          fontPreferenceStoreProvider.overrideWithValue(store),
          themePreferenceStoreProvider.overrideWithValue(
            MemoryThemePreferenceStore(),
          ),
          sessionControllerProvider.overrideWith(TestSessionController.new),
        ],
      );
      addTearDown(container.dispose);
      container.read(fontControllerProvider);
      container.read(themeControllerProvider);
      await pumpEventQueue();
      expect(container.read(fontControllerProvider), AppFontChoice.outfit);
      await container
          .read(themeControllerProvider.notifier)
          .select(AppThemeId.vino);
      expect(container.read(fontControllerProvider), AppFontChoice.outfit);
      await container
          .read(fontControllerProvider.notifier)
          .select(AppFontChoice.plusJakartaSans);
      expect(store.users[testUser.id], AppFontChoice.plusJakartaSans);
      expect(await loadLastFont(store), AppFontChoice.plusJakartaSans);
      expect(container.read(themeControllerProvider), AppThemeId.vino);
    },
  );

  test('una cuenta nueva no hereda la fuente de otra cuenta', () async {
    final store = MemoryFontPreferenceStore(
      last: AppFontChoice.fraunces,
      users: {testUser.id: AppFontChoice.fraunces},
    );
    final container = ProviderContainer(
      overrides: [
        fontPreferenceStoreProvider.overrideWithValue(store),
        initialFontProvider.overrideWithValue(AppFontChoice.fraunces),
        sessionControllerProvider.overrideWith(
          () => TestSessionController(user: testColaborador),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.read(fontControllerProvider);
    await pumpEventQueue();
    expect(container.read(fontControllerProvider), AppFontChoice.themeDefault);
    expect(store.users[testUser.id], AppFontChoice.fraunces);
    expect(AppFontChoice.byName('retirada'), isNull);
  });

  testWidgets('selector aplica la fuente y permite restaurar la del tema', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1440, 1000);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = MemoryFontPreferenceStore();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          fontPreferenceStoreProvider.overrideWithValue(store),
          themePreferenceStoreProvider.overrideWithValue(
            MemoryThemePreferenceStore(users: {testUser.id: AppThemeId.vino}),
          ),
          sessionControllerProvider.overrideWith(TestSessionController.new),
        ],
        child: const _AppearanceHarness(),
      ),
    );
    await tester.runAsync(pumpEventQueue);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<AppFontChoice>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Outfit').last);
    await tester.runAsync(pumpEventQueue);
    await tester.pumpAndSettle();
    TextTheme currentType() =>
        Theme.of(tester.element(find.byType(AppearanceDialog))).textTheme;
    expect(currentType().bodyMedium!.fontFamily, AppFonts.outfit);
    expect(currentType().titleLarge!.fontFamily, AppFonts.outfit);
    expect(store.users[testUser.id], AppFontChoice.outfit);
    await tester.tap(find.byType(DropdownButtonFormField<AppFontChoice>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Según el tema').last);
    await tester.runAsync(pumpEventQueue);
    await tester.pumpAndSettle();
    expect(currentType().bodyMedium!.fontFamily, AppThemeId.vino.bodyFont);
    expect(currentType().titleLarge!.fontFamily, AppThemeId.vino.headingFont);
    // El mismo diálogo a ancho mínimo y texto aumentado sigue desplazable.
    tester.view.physicalSize = const Size(320, 700);
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Rojo GPA audaz'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Listo').hitTestable(), findsOneWidget);
  });

  for (final reducedMotion in [false, true]) {
    testWidgets('engrane: giro finito y movimiento reducido=$reducedMotion', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: reducedMotion),
            child: const Center(child: GpaEmblem(animateOnHover: true)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.byType(GpaEmblem)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      final rotation = tester.widget<RotationTransition>(
        find.byType(RotationTransition),
      );
      expect(rotation.turns.value, reducedMotion ? 0 : greaterThan(0));
      expect(
        find.ancestor(
          of: find.byWidgetPredicate(
            (w) =>
                w is Image &&
                w.image is AssetImage &&
                (w.image as AssetImage).assetName == gpaMarkAsset,
          ),
          matching: find.byType(RotationTransition),
        ),
        findsNothing,
      );
      await tester.pumpAndSettle();
      expect(tester.binding.hasScheduledFrame, isFalse);
      await mouse.removePointer();
    });
  }
}

class _AppearanceHarness extends ConsumerWidget {
  const _AppearanceHarness();
  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp(
    theme: AppTheme.of(
      ref.watch(themeControllerProvider),
      font: ref.watch(fontControllerProvider),
    ),
    home: const Scaffold(body: AppearanceDialog()),
  );
}
