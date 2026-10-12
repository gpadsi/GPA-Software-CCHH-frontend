import 'package:capital_humano_front/features/recruitment/application/requisicion_transiciones.dart';
import 'package:flutter_test/flutter_test.dart';

import 'recruitment_fixtures.dart';

final estadosTramite = [
  estadoBorrador,
  estadoPendiente,
  estadoAutorizada,
  entry(5, 'rechazada', 'Rechazada', esTerminal: true),
  entry(6, 'en-reclutamiento', 'En Reclutamiento'),
  estadoCubierta,
  entry(7, 'suspendida', 'Suspendida'),
  entry(8, 'cancelada', 'Cancelada', esTerminal: true),
];

void main() {
  final gestor = <String, List<String>>{
    'borrador': ['pendiente-de-autorizacion', 'cancelada'],
    'pendiente-de-autorizacion': ['autorizada', 'rechazada', 'cancelada'],
    'autorizada': ['en-reclutamiento', 'suspendida', 'cancelada'],
    'en-reclutamiento': ['cubierta', 'suspendida', 'cancelada'],
    'suspendida': ['en-reclutamiento', 'cancelada'],
    'rechazada': [],
    'cubierta': [],
    'cancelada': [],
  };
  for (final estado in estadosTramite) {
    for (final rol in ['dueño', 'otro colaborador', 'gestor']) {
      test('${estado.code}: acciones exactas de $rol', () {
        final acciones = transicionesDisponibles(
          requisicionPropia.copyWith(estado: estado.id),
          estadosTramite,
          puedeGestionar: rol == 'gestor',
          esDueno: rol == 'dueño',
        );
        expect(
          acciones.map((a) => a.destino).toList(),
          rol == 'gestor'
              ? gestor[estado.code]
              : rol == 'dueño' && estado.code == 'borrador'
              ? ['pendiente-de-autorizacion']
              : <String>[],
        );
      });
    }
  }

  test('un destino ausente del catálogo no se ofrece', () {
    final estados = estadosTramite
        .where((e) => e.code != 'autorizada')
        .toList();
    expect(
      transicionesDisponibles(
        requisicionPropia,
        estados,
        puedeGestionar: true,
        esDueno: false,
      ).map((a) => a.destino),
      ['rechazada', 'cancelada'],
    );
  });

  test('estado desconocido y terminales por marca no ofrecen acciones', () {
    expect(
      transicionesDisponibles(
        requisicionPropia.copyWith(estado: 999),
        estadosTramite,
        puedeGestionar: true,
        esDueno: true,
      ),
      isEmpty,
    );
    expect(
      transicionesDisponibles(
        requisicionPropia,
        [
          estadoPendiente.copyWith(esTerminal: true),
          ...estadosTramite.where((e) => e.id != estadoPendiente.id),
        ],
        puedeGestionar: true,
        esDueno: true,
      ),
      isEmpty,
    );
  });

  test('confirmaciones y captura corresponden al trámite', () {
    final acciones = [
      for (final estado in estadosTramite)
        ...transicionesDisponibles(
          requisicionPropia.copyWith(estado: estado.id),
          estadosTramite,
          puedeGestionar: true,
          esDueno: false,
        ),
    ];
    for (final accion in acciones) {
      expect(
        accion.confirmacion,
        ['rechazada', 'cubierta', 'cancelada'].contains(accion.destino),
      );
      expect(accion.captura, accion.destino == 'suspendida');
    }
  });

  test('gestor puede cancelar cualquier estado no terminal del catálogo', () {
    final extra = entry(99, 'otro-estado', 'Otro estado');
    expect(
      transicionesDisponibles(
        requisicionPropia.copyWith(estado: extra.id),
        [...estadosTramite, extra],
        puedeGestionar: true,
        esDueno: false,
      ).map((a) => a.destino),
      ['cancelada'],
    );
  });
}
