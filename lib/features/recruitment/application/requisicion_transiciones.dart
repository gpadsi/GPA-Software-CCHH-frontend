import '../data/recruitment_models.dart';

// Propuesta de reglas de flujo que el usuario debe confirmar. El servidor
// valida quién puede elegir cada estado, pero no valida este grafo.
class TransicionRequisicion {
  const TransicionRequisicion({
    required this.origen,
    required this.destino,
    required this.etiqueta,
    this.soloGestor = true,
    this.confirmacion = false,
    this.captura = false,
  });

  final String origen;
  final String destino;
  final String etiqueta;
  final bool soloGestor;
  final bool confirmacion;
  final bool captura;
}

const _transiciones = [
  TransicionRequisicion(
    origen: 'borrador',
    destino: 'pendiente-de-autorizacion',
    etiqueta: 'Enviar a autorización',
    soloGestor: false,
  ),
  TransicionRequisicion(
    origen: 'pendiente-de-autorizacion',
    destino: 'autorizada',
    etiqueta: 'Autorizar',
  ),
  TransicionRequisicion(
    origen: 'pendiente-de-autorizacion',
    destino: 'rechazada',
    etiqueta: 'Rechazar',
    confirmacion: true,
  ),
  TransicionRequisicion(
    origen: 'autorizada',
    destino: 'en-reclutamiento',
    etiqueta: 'Iniciar reclutamiento',
  ),
  TransicionRequisicion(
    origen: 'en-reclutamiento',
    destino: 'cubierta',
    etiqueta: 'Marcar cubierta',
    confirmacion: true,
  ),
  TransicionRequisicion(
    origen: 'autorizada',
    destino: 'suspendida',
    etiqueta: 'Suspender',
    captura: true,
  ),
  TransicionRequisicion(
    origen: 'en-reclutamiento',
    destino: 'suspendida',
    etiqueta: 'Suspender',
    captura: true,
  ),
  TransicionRequisicion(
    origen: 'suspendida',
    destino: 'en-reclutamiento',
    etiqueta: 'Reactivar',
  ),
  // El asterisco representa cualquier estado no terminal del catálogo.
  TransicionRequisicion(
    origen: '*',
    destino: 'cancelada',
    etiqueta: 'Cancelar',
    confirmacion: true,
  ),
];

List<TransicionRequisicion> transicionesDisponibles(
  Requisicion requisicion,
  List<RecruitmentCatalogEntry> estados, {
  required bool puedeGestionar,
  required bool esDueno,
}) {
  final actual = estados.where((e) => e.id == requisicion.estado).firstOrNull;
  if (actual == null || actual.esTerminal) return [];
  final codigos = estados.map((e) => e.code).toSet();
  return [
    for (final t in _transiciones)
      if ((t.origen == actual.code || t.origen == '*') &&
          (puedeGestionar || (!t.soloGestor && esDueno)) &&
          codigos.contains(t.destino))
        t,
  ];
}
