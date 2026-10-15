import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/session_controller.dart';
import 'font_preference_store.dart';
import 'typography.dart';

final fontPreferenceStoreProvider = Provider<FontPreferenceStore>(
  (ref) => SecureFontPreferenceStore(),
);
final initialFontProvider = Provider<AppFontChoice>(
  (ref) => AppFontChoice.themeDefault,
);
final fontControllerProvider = NotifierProvider<FontController, AppFontChoice>(
  FontController.new,
);

Future<AppFontChoice> loadLastFont(
  FontPreferenceStore store, {
  Duration wait = const Duration(seconds: 3),
}) async {
  final font =
      await store.readLast().timeout(wait, onTimeout: () => null) ??
      AppFontChoice.themeDefault;
  await AppFonts.ensureLoaded(font.fonts).timeout(wait, onTimeout: () {});
  return font;
}

/// Se recuerda por usuario, con independencia de su elección de colores.
class FontController extends Notifier<AppFontChoice> {
  int _request = 0;

  @override
  AppFontChoice build() {
    ref.listen(
      sessionControllerProvider.select((session) => session.user?.id),
      (_, userId) {
        if (userId == null) {
          _request++;
        } else {
          _restoreFor(userId);
        }
      },
      fireImmediately: true,
    );
    return ref.read(initialFontProvider);
  }

  Future<void> select(AppFontChoice font) async {
    final request = ++_request;
    final userId = ref.read(sessionControllerProvider).user?.id;
    await AppFonts.ensureLoaded(font.fonts);
    if (!ref.mounted || request != _request) return;
    state = font;
    final store = ref.read(fontPreferenceStoreProvider);
    if (userId != null) await store.writeFor(userId, font);
    if (!ref.mounted || request != _request) return;
    await store.writeLast(font);
  }

  Future<void> _restoreFor(String userId) async {
    final request = ++_request;
    final store = ref.read(fontPreferenceStoreProvider);
    final font = await store.readFor(userId) ?? AppFontChoice.themeDefault;
    await AppFonts.ensureLoaded(font.fonts);
    if (!ref.mounted || request != _request) return;
    state = font;
    await store.writeLast(font);
  }
}
