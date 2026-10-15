import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../auth/session_controller.dart';
import 'app_themes.dart';
import 'theme_preference_store.dart';
import 'typography.dart';

part 'theme_controller.g.dart';

@Riverpod(keepAlive: true)
ThemePreferenceStore themePreferenceStore(Ref ref) =>
    SecureThemePreferenceStore();

/// El tema con el que abre la app, antes de saber quién entra. `main` lo
/// reemplaza por el último usado en este navegador.
@Riverpod(keepAlive: true)
AppThemeId initialTheme(Ref ref) => AppThemeId.fallback;

/// El último tema usado en este navegador, con su letra ya cargada: la app
/// no abre con un tema para cambiar a otro un instante después. Si tarda, se
/// abre igual y la letra llega después.
Future<AppThemeId> loadLastTheme(
  ThemePreferenceStore store, {
  Duration wait = const Duration(seconds: 3),
}) async {
  final theme =
      await store.readLast().timeout(wait, onTimeout: () => null) ??
      AppThemeId.fallback;
  await AppFonts.ensureLoaded(theme.fonts).timeout(wait, onTimeout: () {});
  return theme;
}

/// El tema activo. Al entrar un usuario se aplica el que él eligió; quien
/// nunca ha elegido ve el predeterminado, aunque otra persona haya usado otro
/// tema en este navegador.
@Riverpod(keepAlive: true)
class ThemeController extends _$ThemeController {
  // Cada petición nueva deja sin efecto a las anteriores que sigan esperando
  // su letra.
  int _request = 0;

  @override
  AppThemeId build() {
    ref.listen(
      sessionControllerProvider.select((session) => session.user?.id),
      (_, userId) {
        if (userId != null) _restoreFor(userId);
      },
      fireImmediately: true,
    );
    return ref.read(initialThemeProvider);
  }

  /// Aplica [theme] y lo recuerda para el usuario en sesión.
  Future<void> select(AppThemeId theme) async {
    final request = ++_request;
    final userId = ref.read(sessionControllerProvider).user?.id;
    if (userId != null) {
      await ref.read(themePreferenceStoreProvider).writeFor(userId, theme);
    }
    await _apply(theme, request);
  }

  Future<void> _restoreFor(String userId) async {
    final request = ++_request;
    final saved = await ref.read(themePreferenceStoreProvider).readFor(userId);
    await _apply(saved ?? AppThemeId.fallback, request);
  }

  // El tema cambia cuando su letra ya está cargada: así no se ve primero con
  // la letra de respaldo.
  Future<void> _apply(AppThemeId theme, int request) async {
    await AppFonts.ensureLoaded(theme.fonts);
    if (!ref.mounted || request != _request) return;
    state = theme;
    await ref.read(themePreferenceStoreProvider).writeLast(theme);
  }
}
