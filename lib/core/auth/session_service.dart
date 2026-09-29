import 'package:dio/dio.dart';

import '../network/api_config.dart';
import 'auth_models.dart';
import 'token_store.dart';

class SessionService {
  SessionService({required this.store, Dio? apiClient, Dio? authClient})
    : api = apiClient ?? Dio(_options()),
      _auth = authClient ?? Dio(_options()) {
    api.interceptors.add(_SessionInterceptor(this));
  }

  static BaseOptions _options() => BaseOptions(
    baseUrl: '${ApiConfig.baseUrl.replaceFirst(RegExp(r'/+$'), '')}/',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 20),
    sendTimeout: const Duration(seconds: 15),
    headers: {'Accept': 'application/json'},
  );

  final TokenStore store;
  final Dio api;
  final Dio _auth;
  TokenPair? _tokens;
  int _epoch = 0;
  Future<TokenPair>? _refreshing;
  Future<void> _storageQueue = Future.value();
  void Function()? onExpired;

  Future<void> _persist(Future<void> Function() action) {
    final operation = _storageQueue.then((_) => action());
    _storageQueue = operation.catchError((Object _) {});
    return operation;
  }

  Future<SessionUser?> restore() async {
    final epoch = _epoch;
    final saved = await store.read();
    if (epoch != _epoch || saved == null) return null;
    _tokens = saved;
    final response = await api.get<Map<String, dynamic>>('users/me/');
    if (epoch != _epoch) return null;
    return SessionUser.fromJson(response.data!);
  }

  Future<SessionUser> login(String username, String password) async {
    final epoch = ++_epoch;
    final response = await _auth.post<Map<String, dynamic>>(
      'auth/login/',
      data: {'username': username, 'password': password},
    );
    final tokens = TokenPair.fromJson(response.data!);
    final me = await _auth.get<Map<String, dynamic>>(
      'users/me/',
      options: Options(headers: {'Authorization': 'Bearer ${tokens.access}'}),
    );
    final user = SessionUser.fromJson(me.data!);
    if (epoch != _epoch) throw StateError('Sesión cancelada');
    await _persist(
      () => epoch == _epoch ? store.write(tokens) : Future.value(),
    );
    if (epoch != _epoch) throw StateError('Sesión cancelada');
    _tokens = tokens;
    return user;
  }

  Future<void> logout() async {
    ++_epoch;
    _tokens = null;
    _refreshing = null;
    onExpired?.call();
    await _persist(store.clear);
  }

  Future<TokenPair> _refresh(int epoch) {
    return _refreshing ??= _renew(epoch).whenComplete(() {
      if (epoch == _epoch) _refreshing = null;
    });
  }

  Future<TokenPair> _renew(int epoch) async {
    final current = _tokens;
    if (current == null) throw StateError('Sin sesión');
    try {
      final response = await _auth.post<Map<String, dynamic>>(
        'auth/refresh/',
        data: {'refresh': current.refresh},
      );
      final refreshed = RefreshResponse.fromJson(response.data!);
      final next = TokenPair(
        access: refreshed.access,
        refresh: refreshed.refresh ?? current.refresh,
      );
      if (epoch != _epoch) throw StateError('Sesión cancelada');
      await _persist(
        () => epoch == _epoch ? store.write(next) : Future.value(),
      );
      if (epoch != _epoch) throw StateError('Sesión cancelada');
      _tokens = next;
      return next;
    } on Object {
      if (epoch == _epoch) await logout();
      rethrow;
    }
  }

  void dispose() {
    ++_epoch;
    onExpired = null;
    api.close(force: true);
    _auth.close(force: true);
  }
}

class _SessionInterceptor extends Interceptor {
  _SessionInterceptor(this.session);
  final SessionService session;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final tokens = session._tokens;
    if (tokens != null) {
      options.headers['Authorization'] = 'Bearer ${tokens.access}';
    }
    options.extra['sessionEpoch'] = session._epoch;
    handler.next(options);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) async {
    final request = error.requestOptions;
    final epoch = request.extra['sessionEpoch'];
    if (error.response?.statusCode != 401 ||
        session._tokens == null ||
        epoch != session._epoch) {
      handler.next(error);
      return;
    }
    if (request.extra['sessionRetried'] == true) {
      try {
        await session.logout();
      } on Object {
        /* La sesión en memoria ya está cerrada. */
      }
      handler.next(error);
      return;
    }
    try {
      // Las respuestas 401 concurrentes comparten una sola renovación.
      final current = session._tokens!;
      final tokens =
          request.headers['Authorization'] != 'Bearer ${current.access}'
          ? current
          : await session._refresh(epoch as int);
      if (epoch != session._epoch) {
        handler.next(error);
        return;
      }
      final response = await session.api.fetch<dynamic>(
        request.copyWith(
          headers: {
            ...request.headers,
            'Authorization': 'Bearer ${tokens.access}',
          },
          extra: {...request.extra, 'sessionRetried': true},
        ),
      );
      handler.resolve(response);
    } on Object catch (failure) {
      handler.next(failure is DioException ? failure : error);
    }
  }
}
