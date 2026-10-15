import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'typography.dart';

abstract interface class FontPreferenceStore {
  Future<AppFontChoice?> readLast();
  Future<AppFontChoice?> readFor(String userId);
  Future<void> writeLast(AppFontChoice font);
  Future<void> writeFor(String userId, AppFontChoice font);
}

class SecureFontPreferenceStore implements FontPreferenceStore {
  SecureFontPreferenceStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _lastKey = 'gpa_capital_humano_fuente';
  static String _userKey(String userId) => '${_lastKey}_$userId';

  @override
  Future<AppFontChoice?> readLast() => _read(_lastKey);
  @override
  Future<AppFontChoice?> readFor(String userId) => _read(_userKey(userId));
  @override
  Future<void> writeLast(AppFontChoice font) => _write(_lastKey, font);
  @override
  Future<void> writeFor(String userId, AppFontChoice font) =>
      _write(_userKey(userId), font);

  Future<AppFontChoice?> _read(String key) async {
    try {
      return AppFontChoice.byName(await _storage.read(key: key));
    } on Object {
      return null;
    }
  }

  Future<void> _write(String key, AppFontChoice font) async {
    try {
      await _storage.write(key: key, value: font.name);
    } on Object {
      // Una preferencia no debe impedir trabajar sin almacenamiento.
    }
  }
}

class MemoryFontPreferenceStore implements FontPreferenceStore {
  MemoryFontPreferenceStore({this.last, Map<String, AppFontChoice>? users})
    : users = {...?users};

  AppFontChoice? last;
  final Map<String, AppFontChoice> users;

  @override
  Future<AppFontChoice?> readLast() async => last;
  @override
  Future<AppFontChoice?> readFor(String userId) async => users[userId];
  @override
  Future<void> writeLast(AppFontChoice font) async => last = font;
  @override
  Future<void> writeFor(String userId, AppFontChoice font) async =>
      users[userId] = font;
}
