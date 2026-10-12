import 'dart:async';

import 'package:capital_humano_front/core/auth/auth_models.dart';
import 'package:capital_humano_front/core/widgets/app_button.dart';
import 'package:capital_humano_front/core/widgets/app_date_field.dart';
import 'package:capital_humano_front/features/recruitment/data/recruitment_models.dart';
import 'package:capital_humano_front/features/recruitment/presentation/recruitment_ui.dart';
import 'package:capital_humano_front/features/recruitment/presentation/requisicion_suspension_dialog.dart';
import 'package:capital_humano_front/features/recruitment/presentation/requisicion_edit_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'recruitment_fixtures.dart';
import 'recruitment_harness.dart';
import 'requisicion_transiciones_test.dart' show estadosTramite;
import 'test_session.dart';

class _TramiteRepository extends FakeRecruitmentRepository {
  Object? mutationError;
  Completer<void>? pending;
  final cambios = <Map<String, dynamic>>[];
  int lecturas = 0;

  @override
  Future<List<RecruitmentCatalogEntry>> estados() async => estadosTramite;

  @override
  Future<Requisicion> requisicion(String id) async {
    lecturas++;
    return super.requisicion(id);
  }

  @override
  Future<Requisicion> cambiarEstadoRequisicion(
    String id,
    int estadoId, {
    String? motivo,
    String? fecha,
    String? autorizadoPor,
  }) async {
    cambios.add({
      'id': id,
      'estado': estadoId,
      'motivo': motivo,
      'fecha': fecha,
      'autorizadoPor': autorizadoPor,
    });
    if (pending != null) await pending!.future;
    if (mutationError != null) throw mutationError!;
    final original = requisicionesData.firstWhere((r) => r.id == id);
    final updated = original.copyWith(
      estado: estadoId,
      motivoSuspension: motivo ?? original.motivoSuspension,
      fechaSuspension: fecha ?? original.fechaSuspension,
      autorizadoPorSuspension:
          autorizadoPor ?? original.autorizadoPorSuspension,
    );
    requisicionesData = [
      for (final r in requisicionesData)
        if (r.id == id) updated else r,
    ];
    return updated;
  }
}

Future<void> _abrir(
  WidgetTester tester,
  _TramiteRepository repository, {
  int estado = 1,
  SessionUser user = testUser,
  String? dueno,
}) async {
  repository.requisicionesData = [
    requisicionPropia.copyWith(estado: estado, creadoPor: dueno ?? user.id),
  ];
  await pumpRecruitment(
    tester,
    path: '/reclutamiento/requisiciones/r1',
    repository: repository,
    user: user,
  );
}

Finder _button(String text) => find.widgetWithText(AppButton, text);

Future<void> _tap(WidgetTester tester, String label) async {
  await tester.ensureVisible(_button(label).last);
  await tester.tap(_button(label).last);
  await tester.pumpAndSettle();
}

DioException _error(int code, Object data) => DioException(
  requestOptions: RequestOptions(path: '/requisicion'),
  response: Response(
    requestOptions: RequestOptions(path: '/requisicion'),
    statusCode: code,
    data: data,
  ),
  type: DioExceptionType.badResponse,
);

void main() {
  testWidgets('dueño envía; otro colaborador no tiene acciones', (
    tester,
  ) async {
    final repository = _TramiteRepository();
    await _abrir(tester, repository, user: testColaborador);
    expect(_button('Enviar a autorización'), findsOneWidget);
    expect(_button('Cancelar'), findsNothing);
    await _tap(tester, 'Enviar a autorización');
    expect(repository.cambios.single['estado'], estadoPendiente.id);
    expect(repository.lecturas, 2);
    expect(
      find.text('Estado actualizado: Pendiente de Autorización.'),
      findsOneWidget,
    );
    expect(_button('Enviar a autorización'), findsNothing);
    await _abrir(tester, repository, user: testColaborador, dueno: testUser.id);
    expect(_button('Enviar a autorización'), findsNothing);
    expect(_button('Cancelar'), findsNothing);
  });

  testWidgets(
    'enviar con errores de campo ofrece Completar y conserva estado',
    (tester) async {
      final repository = _TramiteRepository()
        ..mutationError = _error(400, {
          'justificacion': ['Este tipo de Requisición exige justificación.'],
        });
      await _abrir(tester, repository);
      await _tap(tester, 'Enviar a autorización');
      expect(
        find.text(
          'Justificación: Este tipo de Requisición exige justificación.',
        ),
        findsOneWidget,
      );
      expect(_button('Completar'), findsOneWidget);
      expect(repository.requisicionesData.single.estado, estadoBorrador.id);
      expect(repository.lecturas, 1);
      expect(find.textContaining('Estado actualizado:'), findsNothing);
      await _tap(tester, 'Cerrar');
      expect(_button('Enviar a autorización'), findsOneWidget);
      await _tap(tester, 'Enviar a autorización');
      await _tap(tester, 'Completar');
      expect(find.byType(RequisicionEditPage), findsOneWidget);
      expect(find.text('Editar requisición'), findsOneWidget);
    },
  );

  testWidgets('error de servidor mantiene detalle y permite reintentar', (
    tester,
  ) async {
    final repository = _TramiteRepository()
      ..mutationError = _error(400, {'detail': 'No se pudo autorizar.'});
    await _abrir(tester, repository, estado: estadoPendiente.id);
    await _tap(tester, 'Autorizar');
    expect(find.text('No se pudo autorizar.'), findsOneWidget);
    expect(_button('Autorizar'), findsOneWidget);
    expect(repository.requisicionesData.single.estado, estadoPendiente.id);
    repository.mutationError = null;
    await _tap(tester, 'Autorizar');
    expect(_button('Iniciar reclutamiento'), findsOneWidget);
  });

  testWidgets(
    'carga deshabilita acciones y no anuncia éxito antes de respuesta',
    (tester) async {
      final repository = _TramiteRepository()..pending = Completer<void>();
      await _abrir(tester, repository);
      await tester.tap(_button('Enviar a autorización'));
      await tester.pump();
      expect(
        tester.widget<AppButton>(_button('Enviar a autorización')).isLoading,
        isTrue,
      );
      expect(tester.widget<AppButton>(_button('Cancelar')).onPressed, isNull);
      expect(tester.widget<AppButton>(_button('Editar')).onPressed, isNull);
      expect(find.textContaining('Estado actualizado:'), findsNothing);
      expect(repository.requisicionesData.single.estado, estadoBorrador.id);
      repository.pending!.complete();
      await tester.pumpAndSettle();
      expect(
        find.text('Estado actualizado: Pendiente de Autorización.'),
        findsOneWidget,
      );
    },
  );

  for (final (origen, label, destino) in [
    (1, 'Cancelar', 8),
    (2, 'Rechazar', 5),
    (6, 'Marcar cubierta', 4),
  ]) {
    testWidgets('$label pide confirmación y solo cambia al confirmar', (
      tester,
    ) async {
      final repository = _TramiteRepository();
      await _abrir(tester, repository, estado: origen);
      await _tap(tester, label);
      expect(find.text('$label requisición'), findsOneWidget);
      expect(repository.cambios, isEmpty);
      await tester.tap(
        find
            .descendant(of: find.byType(Dialog), matching: _button('Cancelar'))
            .first,
      );
      await tester.pumpAndSettle();
      expect(repository.cambios, isEmpty);
      await _tap(tester, label);
      await _tap(tester, label);
      expect(repository.cambios.single['estado'], destino);
      expect(_button('Autorizar'), findsNothing);
      expect(_button('Enviar a autorización'), findsNothing);
      expect(_button('Cancelar'), findsNothing);
    });
  }

  testWidgets('confirmación fallida conserva el diálogo y los datos', (
    tester,
  ) async {
    final repository = _TramiteRepository()
      ..mutationError = _error(400, {'detail': 'No se puede cancelar.'});
    await _abrir(tester, repository);
    await _tap(tester, 'Cancelar');
    await _tap(tester, 'Cancelar');
    expect(find.text('No se puede cancelar.'), findsOneWidget);
    expect(find.text('Cancelar requisición'), findsOneWidget);
    expect(repository.requisicionesData.single.estado, estadoBorrador.id);
  });

  testWidgets(
    'suspender valida motivo y autorizado; guarda y refresca detalle y lista',
    (tester) async {
      final repository = _TramiteRepository();
      final router = await pumpRecruitment(
        tester,
        path: '/reclutamiento',
        repository: repository,
      );
      repository.requisicionesData = [
        requisicionPropia.copyWith(estado: estadoAutorizada.id),
      ];
      router.go('/reclutamiento/requisiciones/r1');
      await tester.pumpAndSettle();
      await _tap(tester, 'Suspender');
      await _tap(tester, 'Suspender');
      expect(find.text('Escribe el motivo.'), findsOneWidget);
      expect(repository.cambios, isEmpty);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Motivo'),
        ' Falta material ',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Autorizado por'),
        'x' * 151,
      );
      await _tap(tester, 'Suspender');
      expect(find.text('Usa como máximo 150 caracteres.'), findsOneWidget);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Autorizado por'),
        ' Ana Ruiz ',
      );
      await _tap(tester, 'Suspender');
      expect(repository.cambios.single, {
        'id': 'r1',
        'estado': 7,
        'motivo': 'Falta material',
        'fecha': toIsoDate(DateTime.now()),
        'autorizadoPor': 'Ana Ruiz',
      });
      expect(find.byType(RequisicionSuspensionDialog), findsNothing);
      expect(_button('Reactivar'), findsOneWidget);
      expect(find.text('Falta material'), findsOneWidget);
      expect(find.text('Ana Ruiz'), findsOneWidget);
      router.go('/reclutamiento');
      await tester.pumpAndSettle();
      expect(find.text('Suspendida'), findsWidgets);
    },
  );

  for (final escape in [false, true]) {
    testWidgets(
      'suspender sin cambios cierra con ${escape ? 'Escape' : 'clic exterior'} y devuelve foco',
      (tester) async {
        final repository = _TramiteRepository();
        await _abrir(tester, repository, estado: estadoAutorizada.id);
        await _tap(tester, 'Suspender');
        if (escape) {
          await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        } else {
          await tester.tapAt(const Offset(10, 10));
        }
        await tester.pumpAndSettle();
        expect(find.byType(RequisicionSuspensionDialog), findsNothing);
        expect(find.text('Descartar cambios'), findsNothing);
        expect(Focus.of(tester.element(_button('Suspender'))).hasFocus, isTrue);
        expect(repository.cambios, isEmpty);
      },
    );

    testWidgets(
      'suspender con cambios pide descartar con ${escape ? 'Escape' : 'clic exterior'}',
      (tester) async {
        final repository = _TramiteRepository();
        await _abrir(tester, repository, estado: estadoAutorizada.id);
        await _tap(tester, 'Suspender');
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Motivo'),
          'Falta material',
        );
        if (escape) {
          await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        } else {
          await tester.tapAt(const Offset(10, 10));
        }
        await tester.pumpAndSettle();
        expect(find.text('Descartar cambios'), findsOneWidget);
        await _tap(tester, 'Cancelar');
        expect(find.text('Falta material'), findsOneWidget);
        await _tap(tester, 'Cancelar');
        await _tap(tester, 'Descartar');
        expect(find.byType(RequisicionSuspensionDialog), findsNothing);
        expect(repository.cambios, isEmpty);
      },
    );
  }

  testWidgets('cambiar solo fecha pide descartar; restaurarla cierra directo', (
    tester,
  ) async {
    final repository = _TramiteRepository();
    await _abrir(tester, repository, estado: estadoAutorizada.id);
    await _tap(tester, 'Suspender');
    final hoy = DateUtils.dateOnly(DateTime.now());
    await tester.tap(find.byType(AppDateField));
    await tester.pumpAndSettle();
    await tester.tap(find.text('${hoy.day == 1 ? 2 : hoy.day - 1}').last);
    final ok = MaterialLocalizations.of(
      tester.element(find.byType(DatePickerDialog)),
    ).okButtonLabel;
    await tester.tap(find.text(ok).last);
    await tester.pumpAndSettle();
    await _tap(tester, 'Cancelar');
    expect(find.text('Descartar cambios'), findsOneWidget);
    await _tap(tester, 'Cancelar');
    await tester.tap(find.byType(AppDateField));
    await tester.pumpAndSettle();
    await tester.tap(find.text('${hoy.day}').last);
    await tester.tap(find.text(ok).last);
    await tester.pumpAndSettle();
    expect(
      tester.widget<AppDateField>(find.byType(AppDateField)).initialValue,
      hoy,
    );
    await _tap(tester, 'Cancelar');
    await tester.pumpAndSettle();
    expect(find.text('Descartar cambios'), findsNothing);
    expect(find.byType(RequisicionSuspensionDialog), findsNothing);
  });

  testWidgets(
    'suspensión fallida conserva campos; pendiente impide cierre y doble envío',
    (tester) async {
      final repository = _TramiteRepository()
        ..pending = Completer<void>()
        ..mutationError = _error(400, {
          'motivo_suspension': ['No se admite ese motivo.'],
        });
      await _abrir(tester, repository, estado: estadoAutorizada.id);
      await _tap(tester, 'Suspender');
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Motivo'),
        'Falta material',
      );
      await tester.tap(_button('Suspender').last);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();
      expect(find.byType(RequisicionSuspensionDialog), findsOneWidget);
      expect(repository.cambios, hasLength(1));
      repository.pending!.complete();
      await tester.pumpAndSettle();
      expect(find.text('Motivo: No se admite ese motivo.'), findsOneWidget);
      expect(find.text('Falta material'), findsOneWidget);
      expect(repository.requisicionesData.single.estado, estadoAutorizada.id);
      repository.pending = null;
      repository.mutationError = null;
      await _tap(tester, 'Suspender');
      expect(_button('Reactivar'), findsOneWidget);
    },
  );
}
