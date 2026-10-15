import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app_themes.dart';

/// Dónde se recuerda el tema: el de cada usuario en este navegador y el último
/// que se aplicó, que es con el que abre la app antes de saber quién entra.
abstract interface class ThemePreferenceStore {
  Future<AppThemeId?> readLast();
  Future<AppThemeId?> readFor(String userId);
  Future<void> writeLast(AppThemeId theme);
  Future<void> writeFor(String userId, AppThemeId theme);
}

class SecureThemePreferenceStore implements ThemePreferenceStore {
  SecureThemePreferenceStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _lastKey = 'gpa_capital_humano_tema';
  static String _userKey(String userId) => '${_lastKey}_$userId';

  @override
  Future<AppThemeId?> readLast() => _read(_lastKey);

  @override
  Future<AppThemeId?> readFor(String userId) => _read(_userKey(userId));

  @override
  Future<void> writeLast(AppThemeId theme) => _write(_lastKey, theme);

  @override
  Future<void> writeFor(String userId, AppThemeId theme) =>
      _write(_userKey(userId), theme);

  // Sin almacenamiento disponible la app sigue con el tema predeterminado: la
  // preferencia es una comodidad, no debe impedir trabajar.
  Future<AppThemeId?> _read(String key) async {
    try {
      return AppThemeId.byName(await _storage.read(key: key));
    } on Object {
      return null;
    }
  }

  Future<void> _write(String key, AppThemeId theme) async {
    try {
      await _storage.write(key: key, value: theme.name);
    } on Object {
      // Ver _read.
    }
  }
}

/// Para pruebas: lo guardado vive solo en memoria.
class MemoryThemePreferenceStore implements ThemePreferenceStore {
  MemoryThemePreferenceStore({this.last, Map<String, AppThemeId>? users})
    : users = {...?users};

  AppThemeId? last;
  final Map<String, AppThemeId> users;

  @override
  Future<AppThemeId?> readLast() async => last;

  @override
  Future<AppThemeId?> readFor(String userId) async => users[userId];

  @override
  Future<void> writeLast(AppThemeId theme) async => last = theme;

  @override
  Future<void> writeFor(String userId, AppThemeId theme) async =>
      users[userId] = theme;
}
