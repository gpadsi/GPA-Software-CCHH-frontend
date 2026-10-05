import 'dart:typed_data';

import 'package:capital_humano_front/core/files/file_saver.dart';
import 'package:capital_humano_front/core/network/api_page.dart';
import 'package:capital_humano_front/core/network/table_query.dart';
import 'package:capital_humano_front/features/recruitment/data/recruitment_models.dart';
import 'package:capital_humano_front/features/recruitment/data/recruitment_repository.dart';
import 'package:dio/dio.dart';

import 'test_session.dart';

RecruitmentCatalogEntry entry(
  int id,
  String code,
  String name, {
  bool esTerminal = false,
  bool requiereJustificacion = false,
  bool requierePersona = false,
}) => RecruitmentCatalogEntry(
  id: id,
  code: code,
  name: name,
  esTerminal: esTerminal,
  requiereJustificacion: requiereJustificacion,
  requierePersona: requierePersona,
);

final estadoBorrador = entry(1, 'borrador', 'Borrador');
final estadoPendiente = entry(
  2,
  'pendiente-de-autorizacion',
  'Pendiente de Autorización',
);
final estadoAutorizada = entry(3, 'autorizada', 'Autorizada');
final estadoCubierta = entry(4, 'cubierta', 'Cubierta', esTerminal: true);
final tipoReemplazo = entry(40, 'reemplazo', 'Reemplazo');
final tipoNueva = entry(
  41,
  'nueva-posicion',
  'Nueva Posición',
  requiereJustificacion: true,
);
final etapaJefe = entry(10, 'jefe-inmediato', 'Jefe Inmediato');
final etapaGerencia = entry(11, 'gerencia-del-area', 'Gerencia del Área');
final etapaDireccion = entry(
  12,
  'direccion-general-vp',
  'Dirección General/VP',
);
final etapaCh = entry(13, 'capital-humano', 'Capital Humano');
final contratoPlanta = entry(20, 'planta', 'Planta');
final horario8 = entry(30, '8-00-17-45', '8:00 - 17:45');
final horarioOtro = entry(31, 'otro', 'Otro');
final edad1825 = entry(50, '18-25', '18 - 25');
final edadOtro = entry(51, 'otro', 'Otro');
final diasLv = entry(60, 'lunes-a-viernes', 'Lunes a Viernes');
final diasOtro = entry(61, 'otro', 'Otro');
final compLiderazgo = entry(70, 'liderazgo', 'Liderazgo');
final compEquipo = entry(71, 'trabajo-en-equipo', 'Trabajo en equipo');
final recursoLaptop = entry(80, 'laptop', 'Laptop');
final recursoEpp = entry(81, 'epp', 'Equipo de protección');
final rolColaborador = entry(
  90,
  'colaborador',
  'Colaborador',
  requierePersona: true,
);
final rolJefe = entry(91, 'jefe-inmediato', 'Jefe inmediato');
final rolCh = entry(92, 'capital-humano', 'Capital Humano');

const posicionUno = PosicionRef(
  id: 'pos1',
  etiqueta: 'Operador de Soldadura — PAILERIA',
);
const posicionDos = PosicionRef(
  id: 'pos2',
  etiqueta: 'Ingeniero de Servicio — SERVICIO TECNICO',
);

/// Una requisición levantada por la cuenta de prueba (Capital Humano).
final requisicionPropia = Requisicion(
  id: 'r1',
  posicion: 'pos1',
  posicionEtiqueta: posicionUno.etiqueta,
  tipo: tipoReemplazo.id,
  estado: estadoPendiente.id,
  creadoPor: testUser.id,
  solicitante: 'Cuenta de prueba',
  fechaSolicitud: '2026-09-10',
  fechaACubrirVacante: '2026-10-01',
  areaSolicitante: 'Soldadura',
  horarioACubrir: horario8.id,
  idiomasRequeridos: 'Inglés básico',
  disposicionViajar: true,
  nivelTabulador: 'N3',
  sueldoMensualBruto: '12500.00',
  tipoContratoOfrecido: contratoPlanta.id,
  aprobaciones: [
    Aprobacion(
      id: 'a1',
      requisicion: 'r1',
      etapa: etapaJefe.id,
      fecha: '2026-09-12',
      nombreManual: 'Luis Pérez',
    ),
  ],
);

/// Una importada de la sábana de GPA: nadie la levantó.
const requisicionImportada = Requisicion(
  id: 'r2',
  posicion: 'pos2',
  posicionEtiqueta: 'Ingeniero de Servicio — SERVICIO TECNICO',
  tipo: 40,
  estado: 3,
  fechaSolicitud: '2026-09-08',
);

/// Una levantada por otra cuenta (un Colaborador de prueba NO la puede editar).
final requisicionAjena = Requisicion(
  id: 'r3',
  posicion: 'pos2',
  posicionEtiqueta: 'Ingeniero de Servicio — SERVICIO TECNICO',
  tipo: 40,
  estado: 1,
  creadoPor: 'otra-cuenta',
  solicitante: 'Otra Persona',
  fechaSolicitud: '2026-09-09',
);

const descriptivoBorrador = Descriptivo(
  id: 'd1',
  posicion: 'pos1',
  posicionEtiqueta: 'Operador de Soldadura — PAILERIA',
  version: 1,
  nombrePuesto: 'Operador de Soldadura',
  empresa: 'GPA Azimatronics',
  areaDepartamento: 'PAILERIA',
  reportaA: 'Supervisor de Soldadura',
  fechaElaboracion: '2026-09-20',
  proposito: 'Soldar piezas según el plano.',
  competencias: [70],
  funciones: [TextoNumerado(orden: 1, texto: 'Soldar piezas')],
  indicadores: [TextoNumerado(orden: 1, texto: 'Piezas sin retrabajo')],
);

const descriptivoCongelado = Descriptivo(
  id: 'd2',
  posicion: 'pos2',
  posicionEtiqueta: 'Ingeniero de Servicio — SERVICIO TECNICO',
  version: 2,
  congeladoEn: '2026-09-25T10:00:00Z',
  estaCongelado: true,
  nombrePuesto: 'Ingeniero de Servicio',
  empresa: 'GPA Azimatronics',
  areaDepartamento: 'SERVICIO TECNICO',
  fechaElaboracion: '2026-09-24',
  proposito: 'Dar servicio técnico.',
  funciones: [TextoNumerado(orden: 1, texto: 'Atender equipos')],
  conformidades: [
    Conformidad(
      id: 'c1',
      descriptivo: 'd2',
      rol: 91,
      fecha: '2026-09-26',
      nombreManual: 'Ana Ruiz',
    ),
  ],
);

/// Un [FileSaver] que no baja nada: solo recuerda lo que se le entregó.
class FakeFileSaver implements FileSaver {
  final saved = <DownloadedFile>[];
  Object? failure;

  @override
  Future<void> save(DownloadedFile file) async {
    if (failure != null) throw failure!;
    saved.add(file);
  }
}

class FakeRecruitmentRepository extends RecruitmentRepository {
  FakeRecruitmentRepository() : super(Dio());

  /// Si no es nulo, toda llamada falla con esto (se pone DESPUÉS de cargar la
  /// pantalla para probar el fallo de una acción).
  Object? failure;

  // Lo que devuelven las listas.
  List<Requisicion> requisicionesData = [
    requisicionPropia,
    requisicionImportada,
  ];
  List<Descriptivo> descriptivosData = [
    descriptivoBorrador,
    descriptivoCongelado,
  ];

  // Lo que se pidió y se guardó.
  TableQuery lastRequisicionesQuery = const TableQuery();
  TableQuery lastDescriptivosQuery = const TableQuery();
  final searches = <String>[];
  Requisicion? savedRequisicion;
  bool? requisicionCreated;
  String? deletedRequisicion;
  Aprobacion? savedAprobacion;
  bool? aprobacionCreated;
  String? deletedAprobacion;
  Descriptivo? savedDescriptivo;
  final calls = <String>[];
  String? createdDraftFor;
  Conformidad? savedConformidad;
  bool? conformidadCreated;
  String? deletedConformidad;

  void _check() {
    if (failure != null) throw failure!;
  }

  @override
  Future<List<RecruitmentCatalogEntry>> estados() async {
    _check();
    return [estadoBorrador, estadoPendiente, estadoAutorizada, estadoCubierta];
  }

  @override
  Future<List<RecruitmentCatalogEntry>> etapasAprobacion() async {
    _check();
    return [etapaJefe, etapaGerencia, etapaDireccion, etapaCh];
  }

  @override
  Future<List<RecruitmentCatalogEntry>> tiposContrato() async {
    _check();
    return [contratoPlanta, entry(21, 'temporal', 'Temporal')];
  }

  @override
  Future<List<RecruitmentCatalogEntry>> horariosACubrir() async {
    _check();
    return [horario8, horarioOtro];
  }

  @override
  Future<List<RecruitmentCatalogEntry>> tiposRequisicion() async {
    _check();
    return [tipoReemplazo, tipoNueva];
  }

  @override
  Future<List<RecruitmentCatalogEntry>> rangosEdad() async {
    _check();
    return [edad1825, edadOtro];
  }

  @override
  Future<List<RecruitmentCatalogEntry>> diasPorLaborar() async {
    _check();
    return [diasLv, diasOtro];
  }

  @override
  Future<List<RecruitmentCatalogEntry>> competencias() async {
    _check();
    return [compLiderazgo, compEquipo];
  }

  @override
  Future<List<RecruitmentCatalogEntry>> recursos() async {
    _check();
    return [recursoLaptop, recursoEpp];
  }

  @override
  Future<List<RecruitmentCatalogEntry>> rolesConformidad() async {
    _check();
    return [rolColaborador, rolJefe, rolCh];
  }

  @override
  Future<List<PosicionRef>> searchPosiciones(String text) async {
    searches.add(text);
    _check();
    return [posicionDos];
  }

  @override
  Future<ApiPage<Requisicion>> requisiciones(
    int page, {
    TableQuery query = const TableQuery(),
  }) async {
    lastRequisicionesQuery = query;
    _check();
    return ApiPage(
      count: requisicionesData.length,
      results: [...requisicionesData],
    );
  }

  @override
  Future<Requisicion> requisicion(String id) async {
    _check();
    return requisicionesData.firstWhere((item) => item.id == id);
  }

  @override
  Future<Requisicion> saveRequisicion(
    Requisicion r, {
    required bool creating,
  }) async {
    _check();
    savedRequisicion = r;
    requisicionCreated = creating;
    final result = creating ? r.copyWith(id: 'nueva') : r;
    if (creating) {
      requisicionesData = [...requisicionesData, result];
    } else {
      requisicionesData = [
        for (final item in requisicionesData)
          if (item.id == r.id) result else item,
      ];
    }
    return result;
  }

  @override
  Future<void> deleteRequisicion(String id) async {
    _check();
    deletedRequisicion = id;
    requisicionesData = [
      for (final item in requisicionesData)
        if (item.id != id) item,
    ];
  }

  @override
  Future<DownloadedFile> exportarExcel(String id) async {
    _check();
    calls.add('excel:$id');
    return DownloadedFile(
      name: 'FO-C0-CH-08 Reemplazo.xlsx',
      bytes: Uint8List.fromList([1, 2, 3]),
      mimeType: 'application/x-test',
    );
  }

  @override
  Future<void> saveAprobacion(Aprobacion a, {required bool creating}) async {
    _check();
    savedAprobacion = a;
    aprobacionCreated = creating;
  }

  @override
  Future<void> deleteAprobacion(String id) async {
    _check();
    deletedAprobacion = id;
  }

  @override
  Future<ApiPage<Descriptivo>> descriptivos(
    int page, {
    TableQuery query = const TableQuery(),
  }) async {
    lastDescriptivosQuery = query;
    _check();
    return ApiPage(
      count: descriptivosData.length,
      results: [...descriptivosData],
    );
  }

  @override
  Future<Descriptivo> descriptivo(String id) async {
    _check();
    return descriptivosData.firstWhere((item) => item.id == id);
  }

  @override
  Future<Descriptivo> crearBorrador(String posicionId) async {
    _check();
    createdDraftFor = posicionId;
    final nuevo = descriptivoBorrador.copyWith(
      id: 'nuevo',
      posicion: posicionId,
    );
    descriptivosData = [...descriptivosData, nuevo];
    return nuevo;
  }

  @override
  Future<Descriptivo> saveDescriptivo(Descriptivo d) async {
    _check();
    calls.add('guardar:${d.id}');
    savedDescriptivo = d;
    descriptivosData = [
      for (final item in descriptivosData)
        if (item.id == d.id) d else item,
    ];
    return d;
  }

  @override
  Future<Descriptivo> congelar(String id) async {
    _check();
    calls.add('congelar:$id');
    final frozen = descriptivosData
        .firstWhere((item) => item.id == id)
        .copyWith(estaCongelado: true, congeladoEn: '2026-10-05T12:00:00Z');
    descriptivosData = [
      for (final item in descriptivosData)
        if (item.id == id) frozen else item,
    ];
    return frozen;
  }

  @override
  Future<Descriptivo> copiar(String id) async {
    _check();
    calls.add('copiar:$id');
    final nuevo = descriptivoBorrador.copyWith(id: 'copia', version: 3);
    descriptivosData = [...descriptivosData, nuevo];
    return nuevo;
  }

  @override
  Future<void> deleteDescriptivo(String id) async {
    _check();
    calls.add('eliminar:$id');
    descriptivosData = [
      for (final item in descriptivosData)
        if (item.id != id) item,
    ];
  }

  @override
  Future<DownloadedFile> exportarWord(String id) async {
    _check();
    calls.add('word:$id');
    return DownloadedFile(
      name: 'FO-C0-CH-04 Descriptivo.docx',
      bytes: Uint8List.fromList([4, 5, 6]),
      mimeType: 'application/x-test',
    );
  }

  @override
  Future<void> saveConformidad(Conformidad c, {required bool creating}) async {
    _check();
    savedConformidad = c;
    conformidadCreated = creating;
  }

  @override
  Future<void> deleteConformidad(String id) async {
    _check();
    deletedConformidad = id;
  }
}
