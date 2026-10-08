import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../core/files/file_saver.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/network/api_page.dart';
import '../../../core/network/table_query.dart';
import 'recruitment_models.dart';

const _xlsx =
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
const _docx =
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document';

/// Un importe escrito por una persona ("$12,500.5") como el texto decimal que
/// espera el servidor ("12500.5"); vacío = null (sin dato, no cero).
String? decimalOrNull(String? text) {
  final cleaned = (text ?? '').replaceAll(RegExp(r'[\s$,]'), '');
  return cleaned.isEmpty ? null : cleaned;
}

String? _nullIfBlank(String? value) {
  final text = value?.trim() ?? '';
  return text.isEmpty ? null : text;
}

class RecruitmentRepository {
  RecruitmentRepository(this.api);
  final Dio api;

  // --- Catálogos -------------------------------------------------------

  Future<List<RecruitmentCatalogEntry>> _catalog(String path) =>
      fetchCatalog(api, path, RecruitmentCatalogEntry.fromJson);

  Future<List<RecruitmentCatalogEntry>> estados() =>
      _catalog('recruitment/estados/');
  Future<List<RecruitmentCatalogEntry>> etapasAprobacion() =>
      _catalog('recruitment/etapas-aprobacion/');
  Future<List<RecruitmentCatalogEntry>> tiposContrato() =>
      _catalog('recruitment/tipos-contrato-ofrecido/');
  Future<List<RecruitmentCatalogEntry>> horariosACubrir() =>
      _catalog('recruitment/horarios-a-cubrir/');
  // El tipo de requisición vive en Posiciones (lo comparte la Posición).
  Future<List<RecruitmentCatalogEntry>> tiposRequisicion() =>
      _catalog('positions/tipos-requisicion/');
  Future<List<RecruitmentCatalogEntry>> rangosEdad() =>
      _catalog('recruitment/rangos-edad/');
  Future<List<RecruitmentCatalogEntry>> diasPorLaborar() =>
      _catalog('recruitment/dias-por-laborar/');
  Future<List<RecruitmentCatalogEntry>> competencias() =>
      _catalog('recruitment/competencias-conductuales/');
  Future<List<RecruitmentCatalogEntry>> recursos() =>
      _catalog('recruitment/recursos-asignados/');
  Future<List<RecruitmentCatalogEntry>> rolesConformidad() =>
      _catalog('recruitment/roles-conformidad/');

  /// Posiciones que coinciden con lo escrito (puesto, unidad, área...), con
  /// su nombre ya armado, para elegir a cuál se refiere una requisición o un
  /// descriptivo.
  Future<List<PosicionRef>> searchPosiciones(String text) async {
    final response = await api.get<Map<String, dynamic>>(
      'positions/posiciones/',
      queryParameters: {'search': text, 'page_size': 8},
    );
    return [
      for (final item in response.data!['results'] as List<dynamic>)
        PosicionRef.fromJson(item as Map<String, dynamic>),
    ];
  }

  // --- Requisiciones ---------------------------------------------------

  Future<List<PosicionElegible>> posicionesElegibles({
    required String para,
    String search = '',
    int pageSize = 8,
  }) async {
    final response = await api.get<Map<String, dynamic>>(
      'recruitment/posiciones-elegibles/',
      queryParameters: {'para': para, 'search': search, 'page_size': pageSize},
    );
    return [
      for (final item in response.data!['results'] as List<dynamic>)
        PosicionElegible.fromJson(item as Map<String, dynamic>),
    ];
  }

  Future<PosicionContexto> posicionContexto(
    String id, {
    required String para,
  }) async {
    final response = await api.get<Map<String, dynamic>>(
      'recruitment/posiciones-elegibles/$id/',
      queryParameters: {'para': para},
    );
    return PosicionContexto.fromJson(response.data!);
  }

  Future<ApiPage<Requisicion>> requisiciones(
    int page, {
    TableQuery query = const TableQuery(),
  }) => fetchPage(
    api,
    'recruitment/requisiciones/',
    Requisicion.fromJson,
    page: page,
    query: query,
  );

  Future<Requisicion> requisicion(String id) async {
    final response = await api.get<Map<String, dynamic>>(
      'recruitment/requisiciones/$id/',
    );
    return Requisicion.fromJson(response.data!);
  }

  /// La Posición solo se manda al crear: una requisición no cambia de plaza.
  /// Texto vacío viaja como null en lo opcional, y los importes limpios.
  Future<Requisicion> saveRequisicion(
    Requisicion r, {
    required bool creating,
  }) async {
    final payload = <String, dynamic>{
      if (creating) 'posicion': r.posicion,
      'tipo': r.tipo,
      'estado': r.estado,
      'fecha_solicitud': r.fechaSolicitud,
      'fecha_a_cubrir_vacante': r.fechaACubrirVacante,
      'fecha_entrega_a_capital_humano': r.fechaEntregaACapitalHumano,
      'area_solicitante': r.areaSolicitante.trim(),
      'justificacion': r.justificacion.trim(),
      'horario_a_cubrir': r.horarioACubrir,
      'idiomas_requeridos': r.idiomasRequeridos.trim(),
      'disposicion_viajar': r.disposicionViajar,
      'nivel_tabulador': r.nivelTabulador.trim(),
      'sueldo_mensual_compuesto': decimalOrNull(r.sueldoMensualCompuesto),
      'sueldo_mensual_bruto': decimalOrNull(r.sueldoMensualBruto),
      'sueldo_mensual_neto': decimalOrNull(r.sueldoMensualNeto),
      'tipo_contrato_ofrecido': r.tipoContratoOfrecido,
      'motivo_suspension': r.motivoSuspension.trim(),
      'fecha_suspension': r.fechaSuspension,
      'autorizado_por_suspension': r.autorizadoPorSuspension.trim(),
    };
    final response = creating
        ? await api.post<Map<String, dynamic>>(
            'recruitment/requisiciones/',
            data: payload,
          )
        : await api.patch<Map<String, dynamic>>(
            'recruitment/requisiciones/${r.id}/',
            data: payload,
          );
    return Requisicion.fromJson(response.data!);
  }

  Future<void> deleteRequisicion(String id) =>
      api.delete<void>('recruitment/requisiciones/$id/');

  Future<DownloadedFile> exportarExcel(String id) => _download(
    'recruitment/requisiciones/$id/exportar-excel/',
    fallbackName: 'Requisicion.xlsx',
    mimeType: _xlsx,
  );

  // --- Aprobaciones de una requisición ---------------------------------

  /// Una firma de la requisición. Con fecha, hay que decir quién firmó: el
  /// propio usuario (firmó dentro del sistema) o un nombre a mano (firma
  /// física); el servidor lo exige.
  Future<void> saveAprobacion(Aprobacion a, {required bool creating}) async {
    final payload = {
      if (creating) 'requisicion': a.requisicion,
      if (creating) 'etapa': a.etapa,
      'fecha': a.fecha,
      'usuario': a.usuario,
      'nombre_manual': a.nombreManual.trim(),
    };
    if (creating) {
      await api.post<Map<String, dynamic>>(
        'recruitment/aprobaciones/',
        data: payload,
      );
    } else {
      await api.patch<Map<String, dynamic>>(
        'recruitment/aprobaciones/${a.id}/',
        data: payload,
      );
    }
  }

  Future<void> deleteAprobacion(String id) =>
      api.delete<void>('recruitment/aprobaciones/$id/');

  // --- Descriptivos de puesto ------------------------------------------

  Future<ApiPage<Descriptivo>> descriptivos(
    int page, {
    TableQuery query = const TableQuery(),
  }) => fetchPage(
    api,
    'recruitment/descriptivos/',
    Descriptivo.fromJson,
    page: page,
    query: query,
  );

  Future<Descriptivo> descriptivo(String id) async {
    final response = await api.get<Map<String, dynamic>>(
      'recruitment/descriptivos/$id/',
    );
    return Descriptivo.fromJson(response.data!);
  }

  /// Abre un borrador nuevo de la Posición con lo que el sistema ya sabe.
  Future<Descriptivo> crearBorrador(String posicionId) async {
    final response = await api.post<Map<String, dynamic>>(
      'recruitment/descriptivos/crear-borrador/',
      data: {'posicion': posicionId},
    );
    return Descriptivo.fromJson(response.data!);
  }

  /// Guarda el borrador. Funciones e indicadores viajan como lista completa
  /// que REEMPLAZA a la anterior (sin renglones vacíos), igual que las
  /// casillas de competencias y recursos.
  Future<Descriptivo> saveDescriptivo(Descriptivo d) async {
    List<Map<String, String>> lines(List<TextoNumerado> items) => [
      for (final item in items)
        if (item.texto.trim().isNotEmpty) {'texto': item.texto.trim()},
    ];
    final response = await api.patch<Map<String, dynamic>>(
      'recruitment/descriptivos/${d.id}/',
      data: {
        'nombre_puesto': d.nombrePuesto.trim(),
        'empresa': d.empresa.trim(),
        'area_departamento': d.areaDepartamento.trim(),
        'reporta_a': d.reportaA.trim(),
        'supervisa_a': d.supervisaA.trim(),
        'fecha_elaboracion': d.fechaElaboracion,
        'edad': d.edad,
        'edad_otro': d.edadOtro.trim(),
        'disponibilidad_viajar': d.disponibilidadViajar,
        'dias_por_laborar': d.diasPorLaborar,
        'dias_por_laborar_otro': d.diasPorLaborarOtro.trim(),
        'horario': d.horario,
        'horario_otro': d.horarioOtro.trim(),
        'proposito': d.proposito.trim(),
        'decisiones_operativas': d.decisionesOperativas.trim(),
        'decisiones_funcionales': d.decisionesFuncionales.trim(),
        'decisiones_estrategicas': d.decisionesEstrategicas.trim(),
        'relaciones_internas': d.relacionesInternas.trim(),
        'relaciones_externas': d.relacionesExternas.trim(),
        'escolaridad_minima': d.escolaridadMinima.trim(),
        'experiencia_requerida': d.experienciaRequerida.trim(),
        'idiomas': d.idiomas.trim(),
        'competencias_tecnicas': d.competenciasTecnicas.trim(),
        'competencias': d.competencias,
        'competencias_otras': d.competenciasOtras.trim(),
        'recursos': d.recursos,
        'recursos_otro': d.recursosOtro.trim(),
        'funciones': lines(d.funciones),
        'indicadores': lines(d.indicadores),
      },
    );
    return Descriptivo.fromJson(response.data!);
  }

  /// Aprueba el borrador: desde aquí es inmutable.
  Future<Descriptivo> congelar(String id) async {
    final response = await api.post<Map<String, dynamic>>(
      'recruitment/descriptivos/$id/congelar/',
    );
    return Descriptivo.fromJson(response.data!);
  }

  /// Abre un borrador nuevo con el contenido de esta versión.
  Future<Descriptivo> copiar(String id) async {
    final response = await api.post<Map<String, dynamic>>(
      'recruitment/descriptivos/$id/copiar/',
    );
    return Descriptivo.fromJson(response.data!);
  }

  Future<void> deleteDescriptivo(String id) =>
      api.delete<void>('recruitment/descriptivos/$id/');

  Future<DownloadedFile> exportarWord(String id) => _download(
    'recruitment/descriptivos/$id/exportar-word/',
    fallbackName: 'Descriptivo de puesto.docx',
    mimeType: _docx,
  );

  // --- Conformidades de un descriptivo congelado -----------------------

  Future<void> saveConformidad(Conformidad c, {required bool creating}) async {
    final payload = {
      if (creating) 'descriptivo': c.descriptivo,
      if (creating) 'rol': c.rol,
      'persona': c.persona,
      'fecha': c.fecha,
      'usuario': c.usuario,
      'nombre_manual': c.nombreManual.trim(),
    };
    if (creating) {
      await api.post<Map<String, dynamic>>(
        'recruitment/conformidades-descriptivo/',
        data: payload,
      );
    } else {
      await api.patch<Map<String, dynamic>>(
        'recruitment/conformidades-descriptivo/${c.id}/',
        data: payload,
      );
    }
  }

  Future<void> deleteConformidad(String id) =>
      api.delete<void>('recruitment/conformidades-descriptivo/$id/');

  // --- Descarga --------------------------------------------------------

  Future<DownloadedFile> _download(
    String path, {
    required String fallbackName,
    required String mimeType,
  }) async {
    final response = await api.get<List<int>>(
      path,
      options: Options(responseType: ResponseType.bytes),
    );
    return DownloadedFile(
      name: filenameFromContentDisposition(
        response.headers.value('content-disposition'),
        fallback: fallbackName,
      ),
      bytes: Uint8List.fromList(response.data ?? const []),
      mimeType: mimeType,
    );
  }
}

/// Mensaje para una falla al guardar o borrar algo de Reclutamiento: el
/// motivo del servidor si lo da ("Esta Posición ya tiene una Requisición
/// abierta…"), con el nombre del campo delante.
String recruitmentMutationError(Object error) {
  final detail = validationDetail(
    error,
    labels: const {
      'posicion': 'Posición',
      'tipo': 'Tipo',
      'estado': 'Estado',
      'justificacion': 'Justificación',
      'fecha_solicitud': 'Fecha de solicitud',
      'nombre_manual': 'Nombre',
      'fecha': 'Fecha',
      'persona': 'Persona',
      'rol': 'Rol',
      'etapa': 'Etapa',
      'funciones': 'Funciones',
      'indicadores': 'Indicadores',
    },
  );
  if (detail != null) return detail;
  if (error is DioException) {
    final code = error.response?.statusCode;
    if (code == 403) return 'Tu cuenta no tiene permiso para hacer esto.';
    if (code == 404) return 'Ya no está disponible. Actualiza la lista.';
  }
  return apiErrorMessage(error);
}

/// Texto → null si está vacío; ayuda de los formularios.
String? nullIfBlank(String? value) => _nullIfBlank(value);
