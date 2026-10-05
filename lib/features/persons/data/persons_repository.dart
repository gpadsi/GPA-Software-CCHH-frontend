import 'package:dio/dio.dart';

import '../../../core/network/api_page.dart';
import '../../../core/network/table_query.dart';
import 'person_models.dart';

class PersonsRepository {
  PersonsRepository(this.api);
  final Dio api;

  Future<PersonCatalogs> catalogs() async {
    final results = await Future.wait([
      fetchCatalog(api, 'persons/generos/', PersonCatalogEntry.fromJson),
      fetchCatalog(
        api,
        'persons/estados-civiles/',
        PersonCatalogEntry.fromJson,
      ),
      fetchCatalog(api, 'persons/escolaridades/', PersonCatalogEntry.fromJson),
      fetchCatalog(api, 'persons/tipos-sangre/', PersonCatalogEntry.fromJson),
    ]);
    return PersonCatalogs(
      generos: results[0],
      estadosCiviles: results[1],
      escolaridades: results[2],
      tiposSangre: results[3],
    );
  }

  Future<ApiPage<Persona>> list(
    int page, {
    TableQuery query = const TableQuery(),
  }) => fetchPage(
    api,
    'persons/personas/',
    Persona.fromJson,
    page: page,
    query: query,
  );

  Future<Persona> get(String id) async {
    final response = await api.get<Map<String, dynamic>>(
      'persons/personas/$id/',
    );
    return Persona.fromJson(response.data!);
  }

  Future<Persona> save(Persona persona, {required bool creating}) async {
    final payload = persona.toJson()..remove('id');
    final response = creating
        ? await api.post<Map<String, dynamic>>(
            'persons/personas/',
            data: payload,
          )
        : await api.patch<Map<String, dynamic>>(
            'persons/personas/${persona.id}/',
            data: payload,
          );
    return Persona.fromJson(response.data!);
  }

  Future<void> delete(String id) => api.delete<void>('persons/personas/$id/');

  Future<List<ContactoUrgencia>> contactosDe(String personaId) => fetchCatalog(
    api,
    'persons/contactos-urgencia/',
    ContactoUrgencia.fromJson,
    queryParameters: {'persona': personaId},
  );

  Future<void> saveContacto(
    ContactoUrgencia contacto, {
    required bool creating,
  }) async {
    final payload = contacto.toJson()..remove('id');
    if (creating) {
      await api.post<Map<String, dynamic>>(
        'persons/contactos-urgencia/',
        data: payload,
      );
    } else {
      await api.patch<Map<String, dynamic>>(
        'persons/contactos-urgencia/${contacto.id}/',
        data: payload,
      );
    }
  }

  Future<void> deleteContacto(String id) =>
      api.delete<void>('persons/contactos-urgencia/$id/');

  Future<PerfilMedico?> perfilDe(String personaId) async {
    final results = await fetchCatalog(
      api,
      'persons/perfiles-medicos/',
      PerfilMedico.fromJson,
      queryParameters: {'persona': personaId},
    );
    return results.isEmpty ? null : results.first;
  }

  Future<void> savePerfil(PerfilMedico perfil, {required bool creating}) async {
    final payload = perfil.toJson()..remove('id');
    if (creating) {
      await api.post<Map<String, dynamic>>(
        'persons/perfiles-medicos/',
        data: payload,
      );
    } else {
      await api.patch<Map<String, dynamic>>(
        'persons/perfiles-medicos/${perfil.id}/',
        data: payload,
      );
    }
  }
}
