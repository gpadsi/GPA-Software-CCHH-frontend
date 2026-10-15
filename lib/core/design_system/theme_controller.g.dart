// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(themePreferenceStore)
final themePreferenceStoreProvider = ThemePreferenceStoreProvider._();

final class ThemePreferenceStoreProvider
    extends
        $FunctionalProvider<
          ThemePreferenceStore,
          ThemePreferenceStore,
          ThemePreferenceStore
        >
    with $Provider<ThemePreferenceStore> {
  ThemePreferenceStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themePreferenceStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themePreferenceStoreHash();

  @$internal
  @override
  $ProviderElement<ThemePreferenceStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ThemePreferenceStore create(Ref ref) {
    return themePreferenceStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemePreferenceStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemePreferenceStore>(value),
    );
  }
}

String _$themePreferenceStoreHash() =>
    r'4587d1590df4f858231cc334c0b294deebb150e0';

/// El tema con el que abre la app, antes de saber quién entra. `main` lo
/// reemplaza por el último usado en este navegador.

@ProviderFor(initialTheme)
final initialThemeProvider = InitialThemeProvider._();

/// El tema con el que abre la app, antes de saber quién entra. `main` lo
/// reemplaza por el último usado en este navegador.

final class InitialThemeProvider
    extends $FunctionalProvider<AppThemeId, AppThemeId, AppThemeId>
    with $Provider<AppThemeId> {
  /// El tema con el que abre la app, antes de saber quién entra. `main` lo
  /// reemplaza por el último usado en este navegador.
  InitialThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initialThemeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initialThemeHash();

  @$internal
  @override
  $ProviderElement<AppThemeId> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppThemeId create(Ref ref) {
    return initialTheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppThemeId value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppThemeId>(value),
    );
  }
}

String _$initialThemeHash() => r'bfc8a2c2a901100a14c7e51af43043cdf4f96e27';

/// El tema activo. Al entrar un usuario se aplica el que él eligió; quien
/// nunca ha elegido ve el predeterminado, aunque otra persona haya usado otro
/// tema en este navegador.

@ProviderFor(ThemeController)
final themeControllerProvider = ThemeControllerProvider._();

/// El tema activo. Al entrar un usuario se aplica el que él eligió; quien
/// nunca ha elegido ve el predeterminado, aunque otra persona haya usado otro
/// tema en este navegador.
final class ThemeControllerProvider
    extends $NotifierProvider<ThemeController, AppThemeId> {
  /// El tema activo. Al entrar un usuario se aplica el que él eligió; quien
  /// nunca ha elegido ve el predeterminado, aunque otra persona haya usado otro
  /// tema en este navegador.
  ThemeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeControllerHash();

  @$internal
  @override
  ThemeController create() => ThemeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppThemeId value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppThemeId>(value),
    );
  }
}

String _$themeControllerHash() => r'25adc090c3e573213f31defd5edad48bd48d8d7a';

/// El tema activo. Al entrar un usuario se aplica el que él eligió; quien
/// nunca ha elegido ve el predeterminado, aunque otra persona haya usado otro
/// tema en este navegador.

abstract class _$ThemeController extends $Notifier<AppThemeId> {
  AppThemeId build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppThemeId, AppThemeId>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppThemeId, AppThemeId>,
              AppThemeId,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
