import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:capital_humano_front/core/auth/auth_models.dart';
import 'package:capital_humano_front/core/auth/session_service.dart';
import 'package:capital_humano_front/core/auth/token_store.dart';
import 'package:capital_humano_front/features/dashboard/data/dashboard_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_session.dart';

const original = TokenPair(access: 'access-prueba', refresh: 'refresh-prueba');
const renewed = TokenPair(access: 'access-nuevo', refresh: 'refresh-rotado');

void main() {
  test(
    'login guarda el par y restaura la identidad desde el almacenamiento',
    () async {
      final store = MemoryTokenStore();
      final api = client((request) {
        expect(request.headers['Authorization'], 'Bearer ${original.access}');
        return response(testUser.toJson());
      });
      final service = SessionService(
        store: store,
        apiClient: api,
        authClient: client((request) {
          if (request.path == 'auth/login/') {
            expect(request.data, {'username': 'prueba', 'password': 'clave'});
            return response(original.toJson());
          }
          expect(request.headers['Authorization'], 'Bearer ${original.access}');
          return response(testUser.toJson());
        }),
      );
      addTearDown(service.dispose);
      expect((await service.login('prueba', 'clave')).id, testUser.id);
      expect(store.tokens, original);
      final reloaded = SessionService(
        store: store,
        apiClient: client((request) {
          expect(request.headers['Authorization'], 'Bearer ${original.access}');
          return response(testUser.toJson());
        }),
      );
      addTearDown(reloaded.dispose);
      expect((await reloaded.restore())?.displayName, testUser.displayName);
      await reloaded.logout();
      expect(store.tokens, isNull);
    },
  );

  test(
    '401 concurrentes renuevan una vez y persisten refresh rotado',
    () async {
      var refreshCalls = 0;
      var retriedCalls = 0;
      final store = MemoryTokenStore(original);
      final service = SessionService(
        store: store,
        apiClient: client((request) {
          if (request.path == 'users/me/') return response(testUser.toJson());
          if (request.headers['Authorization'] == 'Bearer ${original.access}') {
            return response({}, status: 401);
          }
          expect(request.extra['sessionRetried'], isTrue);
          retriedCalls++;
          return response({'count': 12, 'results': []});
        }),
        authClient: client((request) async {
          refreshCalls++;
          expect(request.data, {'refresh': original.refresh});
          await Future<void>.delayed(const Duration(milliseconds: 30));
          return response(renewed.toJson());
        }),
      );
      addTearDown(service.dispose);
      await service.restore();
      await Future.wait(List.generate(4, (_) => service.api.get('protected/')));
      expect(refreshCalls, 1);
      expect(retriedCalls, 4);
      expect(store.tokens, renewed);
    },
  );

  test('refresh inválido borra tokens y notifica salida', () async {
    var expired = 0;
    final store = MemoryTokenStore(original);
    final service = SessionService(
      store: store,
      apiClient: client(
        (request) => request.path == 'users/me/'
            ? response(testUser.toJson())
            : response({}, status: 401),
      ),
      authClient: client((_) => response({}, status: 401)),
    );
    service.onExpired = () => expired++;
    addTearDown(service.dispose);
    await service.restore();
    await expectLater(
      service.api.get('protected/'),
      throwsA(isA<DioException>()),
    );
    expect(store.tokens, isNull);
    expect(expired, 1);
  });

  test('un segundo 401 no entra en un bucle de refresh', () async {
    var refreshCalls = 0;
    var attempts = 0;
    final store = MemoryTokenStore(original);
    final service = SessionService(
      store: store,
      apiClient: client((request) {
        if (request.path == 'users/me/') return response(testUser.toJson());
        attempts++;
        return response({}, status: 401);
      }),
      authClient: client((_) {
        refreshCalls++;
        return response(renewed.toJson());
      }),
    );
    addTearDown(service.dispose);
    await service.restore();
    await expectLater(
      service.api.get('protected/'),
      throwsA(isA<DioException>()),
    );
    expect(refreshCalls, 1);
    expect(attempts, 2);
    expect(store.tokens, isNull);
  });

  test('403 conserva la sesión y no solicita refresh', () async {
    var refreshCalls = 0;
    final store = MemoryTokenStore(original);
    final service = SessionService(
      store: store,
      apiClient: client(
        (request) => request.path == 'users/me/'
            ? response(testUser.toJson())
            : response({}, status: 403),
      ),
      authClient: client((_) {
        refreshCalls++;
        return response(renewed.toJson());
      }),
    );
    addTearDown(service.dispose);
    await service.restore();
    await expectLater(
      service.api.get('restricted/'),
      throwsA(isA<DioException>()),
    );
    expect(refreshCalls, 0);
    expect(store.tokens, original);
  });

  test(
    'cerrar sesión durante refresh impide restaurar tokens tardíos',
    () async {
      final started = Completer<void>();
      final refreshResponse = Completer<ResponseBody>();
      final store = MemoryTokenStore(original);
      final service = SessionService(
        store: store,
        apiClient: client(
          (request) => request.path == 'users/me/'
              ? response(testUser.toJson())
              : response({}, status: 401),
        ),
        authClient: client((_) {
          started.complete();
          return refreshResponse.future;
        }),
      );
      addTearDown(service.dispose);
      await service.restore();
      final pending = expectLater(
        service.api.get('protected/'),
        throwsA(isA<DioException>()),
      );
      await started.future;
      await service.logout();
      refreshResponse.complete(response(renewed.toJson()));
      await pending;
      expect(store.tokens, isNull);
    },
  );

  test(
    'dashboard solicita una fila y utiliza count, incluyendo cero',
    () async {
      final calls = <String>[];
      final repository = DashboardRepository(
        client((request) {
          calls.add(request.path);
          expect(request.queryParameters, {'page_size': 1});
          return response({
            'count': calls.length == 1 ? 0 : 123,
            'results': [],
            'next': null,
            'previous': null,
          });
        }),
      );
      expect(await repository.count(DashboardMetric.persons), 0);
      expect(await repository.count(DashboardMetric.employees), 123);
      expect(calls, ['persons/personas/', 'employment/empleados/']);
    },
  );
}

class MemoryTokenStore implements TokenStore {
  MemoryTokenStore([this.tokens]);
  TokenPair? tokens;
  @override
  Future<TokenPair?> read() async => tokens;
  @override
  Future<void> write(TokenPair value) async {
    tokens = value;
  }

  @override
  Future<void> clear() async {
    tokens = null;
  }
}

Dio client(FutureOr<ResponseBody> Function(RequestOptions) callback) =>
    Dio(BaseOptions(baseUrl: 'http://localhost:8000/api/v1/'))
      ..httpClientAdapter = _Adapter(callback);

ResponseBody response(Object? data, {int status = 200}) =>
    ResponseBody.fromString(
      jsonEncode(data),
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );

class _Adapter implements HttpClientAdapter {
  _Adapter(this.callback);
  final FutureOr<ResponseBody> Function(RequestOptions) callback;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => callback(options);
  @override
  void close({bool force = false}) {}
}
