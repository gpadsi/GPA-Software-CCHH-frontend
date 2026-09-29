import 'package:capital_humano_front/features/positions/data/positions_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'phase_four_fixtures.dart';
import 'session_service_test.dart' show client, response;

void main() {
  group('PositionsRepository', () {
    test('list pagina del lado del servidor', () async {
      final repository = PositionsRepository(
        client((request) {
          expect(request.path, 'positions/posiciones/');
          expect(request.queryParameters, {'page': 2, 'page_size': 25});
          return response({
            'count': 1,
            'results': [posicionA.toJson()],
          });
        }),
      );
      final page = await repository.list(2);
      expect(page.count, 1);
    });

    test('save al crear envía todos los campos, sin id', () async {
      final repository = PositionsRepository(
        client((request) {
          expect(request.method, 'POST');
          expect(request.path, 'positions/posiciones/');
          final payload = request.data as Map<String, dynamic>;
          expect(payload.containsKey('id'), isFalse);
          expect(payload['organization_node'], 'org1');
          expect(payload['estatus'], 20);
          return response(posicionA.toJson());
        }),
      );
      await repository.save(posicionA, creating: true);
    });

    test('save al editar hace PATCH a la posición específica', () async {
      final repository = PositionsRepository(
        client((request) {
          expect(request.method, 'PATCH');
          expect(request.path, 'positions/posiciones/pos1/');
          return response(posicionA.toJson());
        }),
      );
      await repository.save(posicionA, creating: false);
    });

    test('allForPicker trae todas las páginas sin paginar del lado del cliente', () async {
      var calls = 0;
      final repository = PositionsRepository(
        client((request) {
          calls++;
          expect(request.path, 'positions/posiciones/');
          final isFirstPage = request.queryParameters['page'] == 1;
          return response({
            'count': 2,
            'next': isFirstPage ? 'siguiente' : null,
            'results': [posicionA.toJson()],
          });
        }),
      );
      final all = await repository.allForPicker();
      expect(all.length, 2);
      expect(calls, 2);
    });

    test('catalogs pide los 8 catálogos correctos', () async {
      final calledPaths = <String>[];
      final repository = PositionsRepository(
        client((request) {
          calledPaths.add(request.path);
          return response({'count': 0, 'results': []});
        }),
      );
      await repository.catalogs();
      // Future.wait las lanza en paralelo — se compara como conjunto, el
      // orden de llegada al adaptador falso no está garantizado.
      expect(calledPaths.toSet(), {
        'positions/alcances/',
        'positions/tipos-posicion/',
        'positions/tipos-requisicion/',
        'positions/estatus/',
        'positions/puestos/',
        'persons/generos/',
        'organizations/nodes/',
        'locations/areas/',
      });
      expect(calledPaths.length, 8);
    });

    test('delete llama al endpoint correcto', () async {
      final repository = PositionsRepository(
        client((request) {
          expect(request.method, 'DELETE');
          expect(request.path, 'positions/posiciones/pos1/');
          return response(null);
        }),
      );
      await repository.delete('pos1');
    });
  });
}
