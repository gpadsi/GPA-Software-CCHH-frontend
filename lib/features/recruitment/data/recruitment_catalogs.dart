import 'recruitment_models.dart';

/// Busca el nombre de una opción por su id; null si no hay id o ya no existe.
String? nameIn(List<RecruitmentCatalogEntry> catalog, int? id) {
  if (id == null) return null;
  for (final item in catalog) {
    if (item.id == id) return item.name;
  }
  return null;
}

RecruitmentCatalogEntry? entryIn(
  List<RecruitmentCatalogEntry> catalog,
  int? id,
) {
  if (id == null) return null;
  for (final item in catalog) {
    if (item.id == id) return item;
  }
  return null;
}

/// Todo lo que las pantallas de Requisiciones necesitan para mostrar nombres
/// y ofrecer opciones: se carga una vez y se reutiliza.
class RequisicionCatalogs {
  const RequisicionCatalogs({
    required this.estados,
    required this.etapas,
    required this.tiposContrato,
    required this.horarios,
    required this.tipos,
  });
  final List<RecruitmentCatalogEntry> estados;
  final List<RecruitmentCatalogEntry> etapas;
  final List<RecruitmentCatalogEntry> tiposContrato;
  final List<RecruitmentCatalogEntry> horarios;
  final List<RecruitmentCatalogEntry> tipos;
}

/// Opciones del Descriptivo de puesto (casillas y listas del formulario).
class DescriptivoCatalogs {
  const DescriptivoCatalogs({
    required this.rangosEdad,
    required this.dias,
    required this.horarios,
    required this.competencias,
    required this.recursos,
    required this.roles,
  });
  final List<RecruitmentCatalogEntry> rangosEdad;
  final List<RecruitmentCatalogEntry> dias;
  final List<RecruitmentCatalogEntry> horarios;
  final List<RecruitmentCatalogEntry> competencias;
  final List<RecruitmentCatalogEntry> recursos;
  final List<RecruitmentCatalogEntry> roles;
}

/// Las opciones «Otro» del formulario real llevan un texto aparte; el campo
/// solo se pide cuando se elige esa opción.
bool isOtro(RecruitmentCatalogEntry? entry) =>
    entry != null && entry.name.trim().toLowerCase() == 'otro';

/// Los únicos estados que quien solicita (cualquier cuenta que no sea Capital
/// Humano o Admin) puede poner por sí misma: dejar la requisición en Borrador
/// o mandarla a autorización. Es la misma lista que valida el servidor
/// (`ESTADOS_QUE_ELIGE_EL_SOLICITANTE`); aquí solo evita ofrecer opciones que
/// rechazaría.
const estadosDelSolicitante = ['borrador', 'pendiente-de-autorizacion'];
