import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_models.dart';

abstract interface class TokenStore {
  Future<TokenPair?> read();
  Future<void> write(TokenPair tokens);
  Future<void> clear();
}

class SecureTokenStore implements TokenStore {
  SecureTokenStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _key = 'gpa_capital_humano_session';

  @override
  Future<TokenPair?> read() async {
    final encoded = await _storage.read(key: _key);
    if (encoded == null) return null;
    try {
      final tokens = TokenPair.fromJson(
        jsonDecode(encoded) as Map<String, dynamic>,
      );
      if (tokens.access.isEmpty || tokens.refresh.isEmpty) {
        throw const FormatException();
      }
      return tokens;
    } on Object {
      await clear();
      return null;
    }
  }

  @override
  Future<void> write(TokenPair tokens) =>
      _storage.write(key: _key, value: jsonEncode(tokens.toJson()));

  @override
  Future<void> clear() => _storage.delete(key: _key);
}
