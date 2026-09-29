import 'package:capital_humano_front/core/network/api_page.dart';
import 'package:capital_humano_front/features/employment/data/employment_models.dart';
import 'package:capital_humano_front/features/employment/data/employment_repository.dart';
import 'package:capital_humano_front/features/persons/data/person_models.dart';
import 'package:capital_humano_front/features/persons/data/persons_repository.dart';
import 'package:dio/dio.dart';

const generoM = PersonCatalogEntry(id: 1, code: 'm', name: 'Masculino', isActive: true);
const civilS = PersonCatalogEntry(id: 1, code: 's', name: 'Soltero', isActive: true);
const escolaridadA = PersonCatalogEntry(id: 1, code: 'p', name: 'Primaria', isActive: true);
const sangreA = PersonCatalogEntry(id: 1, code: 'op', name: 'O+', isActive: true);
const personCatalogsFixture = PersonCatalogs(
  generos: [generoM],
  estadosCiviles: [civilS],
  escolaridades: [escolaridadA],
  tiposSangre: [sangreA],
);

const personaA = Persona(
  id: 'p1',
  firstName: 'Juan',
  lastNamePaternal: 'Pérez',
  lastNameMaternal: 'López',
);
const personaB = Persona(id: 'p2', firstName: 'Ana', lastNamePaternal: 'Ruiz');
const contactoA = ContactoUrgencia(
  id: 'c1',
  persona: 'p1',
  name: 'Mamá',
  relationship: 'Madre',
  phone: '5512345678',
);
const perfilA = PerfilMedico(id: 'm1', persona: 'p1', allergies: 'Ninguna');

class FakePersonsRepository extends PersonsRepository {
  FakePersonsRepository() : super(Dio());
  Object? failure;
  Persona? saved;
  bool? created;
  String? deleted;
  ContactoUrgencia? savedContacto;
  bool? createdContacto;
  String? deletedContacto;
  PerfilMedico? savedPerfil;
  bool? createdPerfil;
  final personas = [personaA, personaB];
  final contactos = [contactoA];
  PerfilMedico? perfil = perfilA;

  @override
  Future<PersonCatalogs> catalogs() async {
    if (failure != null) throw failure!;
    return personCatalogsFixture;
  }

  @override
  Future<ApiPage<Persona>> list(int page) async {
    if (failure != null) throw failure!;
    return ApiPage(count: personas.length, results: [...personas]);
  }

  @override
  Future<Persona> get(String id) async {
    if (failure != null) throw failure!;
    return personas.firstWhere((item) => item.id == id);
  }

  @override
  Future<Persona> save(Persona persona, {required bool creating}) async {
    if (failure != null) throw failure!;
    saved = persona;
    created = creating;
    final result = creating ? persona.copyWith(id: 'new') : persona;
    if (creating) {
      personas.add(result);
    } else {
      personas[personas.indexWhere((item) => item.id == persona.id)] = result;
    }
    return result;
  }

  @override
  Future<void> delete(String id) async {
    if (failure != null) throw failure!;
    deleted = id;
    personas.removeWhere((item) => item.id == id);
  }

  @override
  Future<List<ContactoUrgencia>> contactosDe(String personaId) async {
    if (failure != null) throw failure!;
    return contactos.where((item) => item.persona == personaId).toList();
  }

  @override
  Future<void> saveContacto(ContactoUrgencia contacto, {required bool creating}) async {
    if (failure != null) throw failure!;
    savedContacto = contacto;
    createdContacto = creating;
    if (creating) {
      contactos.add(contacto.copyWith(id: 'new'));
    } else {
      contactos[contactos.indexWhere((item) => item.id == contacto.id)] = contacto;
    }
  }

  @override
  Future<void> deleteContacto(String id) async {
    if (failure != null) throw failure!;
    deletedContacto = id;
    contactos.removeWhere((item) => item.id == id);
  }

  @override
  Future<PerfilMedico?> perfilDe(String personaId) async {
    if (failure != null) throw failure!;
    return perfil?.persona == personaId ? perfil : null;
  }

  @override
  Future<void> savePerfil(PerfilMedico perfil, {required bool creating}) async {
    if (failure != null) throw failure!;
    savedPerfil = perfil;
    createdPerfil = creating;
    this.perfil = creating ? perfil.copyWith(id: 'new') : perfil;
  }
}

const empleadoA = Empleado(id: 'e1', persona: 'p1', workNumber: 'ADV0001');
const contratoA = Contrato(
  id: 'k1',
  empleado: 'e1',
  posicion: 'pos1',
  fechaIngreso: '2020-01-10',
);
const personSummaryA = PersonSummary(
  id: 'p1',
  firstName: 'Juan',
  lastNamePaternal: 'Pérez',
  lastNameMaternal: 'López',
  personalEmail: 'juan@example.test',
);
const posicionSummaryA = PosicionSummary(id: 'pos1', puesto: 10, estatus: 20);
const puestoRefA = NamedRef(id: 10, name: 'Auxiliar de Producción');
const estatusRefA = NamedRef(id: 20, name: 'Colaborador Activo');

class FakeEmploymentRepository extends EmploymentRepository {
  FakeEmploymentRepository() : super(Dio());
  Object? failure;
  Contrato? contratoVigenteValue = contratoA;
  final empleados = [empleadoA];

  @override
  Future<ApiPage<Empleado>> list(int page) async {
    if (failure != null) throw failure!;
    return ApiPage(count: empleados.length, results: [...empleados]);
  }

  @override
  Future<Empleado> get(String id) async {
    if (failure != null) throw failure!;
    return empleados.firstWhere((item) => item.id == id);
  }

  @override
  Future<Contrato?> contratoVigente(String empleadoId) async {
    if (failure != null) throw failure!;
    return contratoVigenteValue;
  }

  @override
  Future<PersonSummary> persona(String id) async {
    if (failure != null) throw failure!;
    return personSummaryA;
  }

  @override
  Future<PosicionSummary> posicion(String id) async {
    if (failure != null) throw failure!;
    return posicionSummaryA;
  }

  @override
  Future<NamedRef> puesto(int id) async {
    if (failure != null) throw failure!;
    return puestoRefA;
  }

  @override
  Future<NamedRef> estatus(int id) async {
    if (failure != null) throw failure!;
    return estatusRefA;
  }
}
