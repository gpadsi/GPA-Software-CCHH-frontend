import 'package:capital_humano_front/core/network/api_page.dart';
import 'package:capital_humano_front/features/locations/data/location_models.dart';
import 'package:capital_humano_front/features/locations/data/locations_repository.dart';
import 'package:capital_humano_front/features/organizations/data/organization_models.dart';
import 'package:capital_humano_front/features/organizations/data/organizations_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'phase_two_fixtures.dart';
import 'session_service_test.dart' show client, response;

void main() {
  test(
    'empresas usa paginación del servidor sin filtros inexistentes',
    () async {
      final repository = OrganizationsRepository(
        client((request) {
          expect(request.path, 'organizations/companies/');
          expect(request.queryParameters, {'page': 2, 'page_size': 25});
          return response({
            'count': 26,
            'next': null,
            'previous': 'page=1',
            'results': [companyA.toJson()],
          });
        }),
      );
      final page = await repository.companies(2);
      expect(page.count, 26);
      expect(page.results.single.legalName, isNull);
      expect(page.results.single.rfc, isNull);
      expect(page.results.single.employerRegistration, isNull);
    },
  );

  test('catálogos recorren todas las páginas sin usar URLs externas', () async {
    final pages = <int>[];
    final api = client((request) {
      expect(request.path, 'locations/ubicaciones/');
      expect(request.queryParameters['page_size'], 200);
      final page = request.queryParameters['page'] as int;
      pages.add(page);
      return response({
        'count': 2,
        'next': page == 1 ? 'http://example.invalid/page=2' : null,
        'results': [page == 1 ? locationA.toJson() : locationB.toJson()],
      });
    });
    final all = await fetchCatalog(
      api,
      'locations/ubicaciones/',
      LocationRecord.fromJson,
    );
    expect(pages, [1, 2]);
    expect(all.map((item) => item.id), ['u1', 'u2']);
  });

  for (final kind in LocationKind.values) {
    test('CRUD ${kind.name}: rutas, métodos y solo campos admitidos', () async {
      final calls = <String>[];
      final repository = LocationsRepository(
        client((request) {
          calls.add(request.method);
          if (request.method == 'GET') {
            expect(request.path, kind.path);
            expect(request.queryParameters, {'page': 3, 'page_size': 25});
            return response({
              'count': 51,
              'results': [locationA.toJson()],
            });
          }
          expect(
            request.path,
            request.method == 'POST' ? kind.path : '${kind.path}test-id/',
          );
          if (request.method != 'DELETE') {
            final payload = request.data as Map<String, dynamic>;
            expect(payload.keys.toSet(), {
              'code',
              'name',
              'is_active',
              switch (kind) {
                LocationKind.ubicaciones => 'employer_registration',
                LocationKind.naves => 'ubicacion',
                LocationKind.areas => 'nave',
              },
            });
            if (kind == LocationKind.areas) expect(payload['nave'], isNull);
            expect(payload['is_active'], false);
          }
          return response({}, status: request.method == 'DELETE' ? 204 : 200);
        }),
      );
      final record = locationA.copyWith(
        id: 'test-id',
        ubicacion: 'u1',
        isActive: false,
      );
      expect((await repository.list(kind, 3)).count, 51);
      await repository.save(kind, record, creating: true);
      await repository.save(kind, record, creating: false);
      await repository.delete(kind, record.id);
      expect(calls, ['GET', 'POST', 'PATCH', 'DELETE']);
    });
  }

  test('IDs de catálogos enteros, nodos UUID y área sin nave', () {
    expect(
      OrganizationTenant.fromJson({'id': 1, 'code': 'GPA', 'name': 'GPA'}).id,
      1,
    );
    expect(OrganizationNode.fromJson(rootNode.toJson()).parent, isNull);
    expect(
      LocationRecord.fromJson({
        'id': 'area',
        'code': 'A',
        'name': 'Área',
        'nave': null,
      }).nave,
      isNull,
    );
    final catalog = LocationCatalog(
      ubicaciones: [locationA, locationB],
      naves: [naveA, naveB],
    );
    expect(catalog.navesAt('u1'), [naveA]);
    expect(catalog.navesAt('u2'), [naveB]);
    expect(catalog.navesAt(null), isEmpty);
  });
}
