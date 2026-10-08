import 'dart:async';

import 'package:capital_humano_front/core/widgets/app_badge.dart';
import 'package:capital_humano_front/core/widgets/app_button.dart';
import 'package:capital_humano_front/core/widgets/app_overlays.dart';
import 'package:capital_humano_front/core/widgets/loading_skeleton.dart';
import 'package:capital_humano_front/core/widgets/search_picker_field.dart';
import 'package:capital_humano_front/features/recruitment/application/recruitment_controller.dart';
import 'package:capital_humano_front/features/recruitment/data/recruitment_models.dart';
import 'package:capital_humano_front/features/recruitment/presentation/descriptivos_page.dart';
import 'package:capital_humano_front/features/recruitment/presentation/nuevo_descriptivo_form.dart';
import 'package:capital_humano_front/features/recruitment/presentation/posicion_contexto_card.dart';
import 'package:capital_humano_front/features/recruitment/presentation/requisicion_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'phase_four_fixtures.dart';
import 'recruitment_fixtures.dart';
import 'recruitment_harness.dart';
import 'test_session.dart';

final _picker = find.byType(SearchPickerField<PosicionElegible>);
final _card = find.byType(PosicionContextoCard);
Finder _inCard(String text) =>
    find.descendant(of: _card, matching: find.text(text));

Future<void> _mountCard(
  WidgetTester tester,
  FakeRecruitmentRepository repository, {
  String para = 'descriptivo',
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [recruitmentRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 470,
              child: PosicionContextoCard(posicionId: 'pos1', para: para),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

Future<void> _openForm(
  WidgetTester tester,
  FakeRecruitmentRepository repository,
  Widget form,
) async {
  await pumpRecruitment(
    tester,
    path: '/reclutamiento/descriptivos',
    repository: repository,
  );
  unawaited(
    showAppPanel<void>(
      context: tester.element(find.byType(DescriptivosPage)),
      builder: (_) => form,
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _choosePosicion(WidgetTester tester) async {
  final field = find.descendant(
    of: _picker,
    matching: find.byType(TextFormField),
  );
  await tester.ensureVisible(field);
  await tester.tap(field);
  await pumpDebounce(tester);
  await tester.tap(find.text(posicionDos.etiqueta).last);
  await tester.pumpAndSettle();
}

void main() {
  group('tarjeta de contexto', () {
    for (final para in ['requisicion', 'descriptivo']) {
      testWidgets('datos completos y trámite de $para', (tester) async {
        final repository = FakeRecruitmentRepository();
        repository.contextos[('pos1', para)] = contextoUno.copyWith(
          tramiteAbierto: TramiteAbierto(tipo: para, id: 'tramite'),
        );
        await _mountCard(tester, repository, para: para);
        await tester.pumpAndSettle();
        for (final text in [
          'Operador de Soldadura',
          'Empresa',
          'GPA Azimatronics',
          'Unidad',
          'PAILERIA',
          'Área',
          'Producción',
          'Estatus',
          'Colaborador Activo',
          'Reporta a',
          'Supervisor de Soldadura',
          para == 'requisicion' ? 'Requisición abierta' : 'Borrador abierto',
        ]) {
          expect(_inCard(text), findsOneWidget);
        }
        expect(find.byType(AppBadge), findsOneWidget);
        expect(find.byType(TextFormField), findsNothing);
        expect(repository.contextoRequests, [('pos1', para)]);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('faltantes sin inventar datos y sin área vacía', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      repository.contextos[('pos1', 'descriptivo')] = contextoUno.copyWith(
        puesto: null,
        empresa: null,
        unidad: '',
        area: null,
        estatus: '',
        reportaA: null,
      );
      await _mountCard(tester, repository);
      await tester.pumpAndSettle();
      expect(_inCard('Sin dato'), findsNWidgets(4));
      expect(_inCard('Sin relación registrada'), findsOneWidget);
      expect(_inCard('Área'), findsNothing);
      expect(_inCard('Borrador abierto'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('esqueleto reserva la misma altura que los datos', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      final pending = Completer<PosicionContexto>();
      repository.contextoLoader = (_, _) => pending.future;
      await _mountCard(tester, repository);
      expect(find.byType(LoadingSkeleton), findsWidgets);
      final loadingHeight = tester.getSize(_card).height;
      pending.complete(contextoUno);
      await tester.pumpAndSettle();
      expect(find.byType(LoadingSkeleton), findsNothing);
      expect(tester.getSize(_card).height, loadingHeight);
      expect(_inCard(contextoUno.puesto!), findsOneWidget);
    });

    testWidgets('error y Reintentar hacen una segunda llamada real', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      repository.contextoLoader = (_, _) async {
        if (repository.contextoRequests.length == 1) throw StateError('fallo');
        return contextoUno;
      };
      await _mountCard(tester, repository);
      await tester.pumpAndSettle();
      expect(find.text('No se pudo cargar la posición.'), findsOneWidget);
      expect(repository.contextoRequests.length, 1);
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();
      expect(repository.contextoRequests, [
        ('pos1', 'descriptivo'),
        ('pos1', 'descriptivo'),
      ]);
      expect(_inCard(contextoUno.puesto!), findsOneWidget);
    });

    test('la familia separa el contexto por posición y propósito', () async {
      final repository = FakeRecruitmentRepository();
      final container = ProviderContainer(
        overrides: [
          recruitmentRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      for (final key in [
        ('pos1', 'requisicion'),
        ('pos1', 'descriptivo'),
        ('pos2', 'descriptivo'),
      ]) {
        await container.read(posicionContextoProvider(key).future);
      }
      expect(repository.contextoRequests, [
        ('pos1', 'requisicion'),
        ('pos1', 'descriptivo'),
        ('pos2', 'descriptivo'),
      ]);
    });
  });

  group('formularios con contexto', () {
    for (final descriptivo in [true, false]) {
      final para = descriptivo ? 'descriptivo' : 'requisicion';
      testWidgets('$para preseleccionado y Cambiar posición', (tester) async {
        final repository = FakeRecruitmentRepository();
        await _openForm(
          tester,
          repository,
          descriptivo
              ? const NuevoDescriptivoForm(posicionId: 'pos1')
              : const RequisicionForm(posicionId: 'pos1'),
        );
        expect(_picker, findsNothing);
        expect(_inCard(contextoUno.puesto!), findsOneWidget);
        expect(repository.contextoRequests, [('pos1', para)]);
        await tester.ensureVisible(find.text('Cambiar posición'));
        await tester.tap(find.text('Cambiar posición'));
        await tester.pumpAndSettle();
        expect(_picker, findsOneWidget);
        expect(_card, findsNothing);
        await _choosePosicion(tester);
        expect(_inCard(contextoDos.puesto!), findsOneWidget);
        expect(_inCard(contextoUno.puesto!), findsNothing);
        expect(repository.contextoRequests, [('pos1', para), ('pos2', para)]);
        expect(tester.takeException(), isNull);
      });

      testWidgets('$para sin preselección muestra tarjeta tras elegir', (
        tester,
      ) async {
        final repository = FakeRecruitmentRepository();
        await _openForm(
          tester,
          repository,
          descriptivo ? const NuevoDescriptivoForm() : const RequisicionForm(),
        );
        expect(_picker, findsOneWidget);
        expect(_card, findsNothing);
        await _choosePosicion(tester);
        expect(_picker, findsOneWidget);
        expect(_inCard(contextoDos.puesto!), findsOneWidget);
        expect(repository.contextoRequests, [('pos2', para)]);
        expect(tester.takeException(), isNull);
      });

      testWidgets('$para preseleccionado no guarda antes de cargar', (
        tester,
      ) async {
        final repository = FakeRecruitmentRepository();
        final pending = Completer<PosicionContexto>();
        repository.contextoLoader = (_, _) => pending.future;
        await _openForm(
          tester,
          repository,
          descriptivo
              ? const NuevoDescriptivoForm(posicionId: 'pos1')
              : const RequisicionForm(posicionId: 'pos1'),
        );
        final label = descriptivo ? 'Crear borrador' : 'Guardar';
        expect(
          tester
              .widget<AppButton>(find.widgetWithText(AppButton, label))
              .onPressed,
          isNull,
        );
        pending.complete(contextoUno);
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<AppButton>(find.widgetWithText(AppButton, label))
              .onPressed,
          isNotNull,
        );
      });
    }

    testWidgets('borrador preseleccionado se continúa sin crear otro', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      repository.contextos[('pos1', 'descriptivo')] = contextoUno.copyWith(
        tramiteAbierto: const TramiteAbierto(
          tipo: 'descriptivo',
          id: 'd1',
          estado: 'Borrador',
        ),
      );
      final router = await pumpRecruitment(
        tester,
        path: '/posiciones',
        repository: repository,
        positions: FakePositionsRepository(),
      );
      await tapTooltip(tester, 'Crear descriptivo');
      expect(find.text('Continuar borrador'), findsOneWidget);
      await saveForm(tester, label: 'Continuar borrador');
      expect(repository.createdDraftFor, isNull);
      expect(
        router.routeInformationProvider.value.uri.path,
        '/reclutamiento/descriptivos/d1',
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('requisición ajena preseleccionada bloquea sin enlace Abrir', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      repository.contextos[('pos1', 'requisicion')] = contextoUno.copyWith(
        tramiteAbierto: const TramiteAbierto(tipo: 'requisicion'),
      );
      await _openForm(
        tester,
        repository,
        const RequisicionForm(posicionId: 'pos1'),
      );
      expect(
        find.text('Esta posición ya tiene una requisición abierta'),
        findsOneWidget,
      );
      expect(find.text('Pídela a Capital Humano'), findsOneWidget);
      expect(find.text('Abrir'), findsNothing);
      expect(
        tester
            .widget<AppButton>(find.widgetWithText(AppButton, 'Guardar'))
            .onPressed,
        isNull,
      );
      expect(repository.savedRequisicion, isNull);
    });

    testWidgets('requisición visible preseleccionada ofrece Abrir', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      repository.contextos[('pos1', 'requisicion')] = contextoUno.copyWith(
        tramiteAbierto: const TramiteAbierto(tipo: 'requisicion', id: 'r1'),
      );
      final router = await pumpRecruitment(
        tester,
        path: '/posiciones',
        repository: repository,
        positions: FakePositionsRepository(),
      );
      await tapTooltip(tester, 'Crear requisición');
      await tester.ensureVisible(find.text('Abrir'));
      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();
      expect(
        router.routeInformationProvider.value.uri.path,
        '/reclutamiento/requisiciones/r1',
      );
      expect(repository.savedRequisicion, isNull);
      expect(tester.takeException(), isNull);
    });
  });

  group('entrada desde Posiciones', () {
    testWidgets('gestión tiene dos acciones por fila y ambas preseleccionan', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      final positions = FakePositionsRepository();
      positions.posiciones.add(posicionA.copyWith(id: 'pos2'));
      await pumpRecruitment(
        tester,
        path: '/posiciones',
        repository: repository,
        positions: positions,
      );
      expect(find.byTooltip('Crear requisición'), findsNWidgets(2));
      expect(find.byTooltip('Crear descriptivo'), findsNWidgets(2));
      final requisicion = find.byTooltip('Crear requisición').last;
      await tester.ensureVisible(requisicion);
      await tester.tap(requisicion);
      await tester.pumpAndSettle();
      expect(find.byType(RequisicionForm), findsOneWidget);
      expect(
        tester.widget<RequisicionForm>(find.byType(RequisicionForm)).posicionId,
        'pos2',
      );
      expect(_picker, findsNothing);
      expect(_inCard(contextoDos.puesto!), findsOneWidget);
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      final descriptivo = find.byTooltip('Crear descriptivo').first;
      await tester.ensureVisible(descriptivo);
      await tester.tap(descriptivo);
      await tester.pumpAndSettle();
      expect(find.byType(NuevoDescriptivoForm), findsOneWidget);
      expect(
        tester
            .widget<NuevoDescriptivoForm>(find.byType(NuevoDescriptivoForm))
            .posicionId,
        'pos1',
      );
      expect(_picker, findsNothing);
      expect(_inCard(contextoUno.puesto!), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Colaborador no tiene acciones de creación', (tester) async {
      await pumpRecruitment(
        tester,
        path: '/posiciones',
        repository: FakeRecruitmentRepository(),
        positions: FakePositionsRepository(),
        user: testColaborador,
      );
      expect(find.byTooltip('Crear requisición'), findsNothing);
      expect(find.byTooltip('Crear descriptivo'), findsNothing);
    });

    for (final code in ['colaborador-activo', 'trainee-activo']) {
      testWidgets('crea Descriptivo de posición ocupada $code y navega', (
        tester,
      ) async {
        final repository = FakeRecruitmentRepository();
        repository.contextos[('pos1', 'descriptivo')] = contextoUno.copyWith(
          estatusCode: code,
        );
        final router = await pumpRecruitment(
          tester,
          path: '/posiciones',
          repository: repository,
          positions: FakePositionsRepository(),
        );
        await tapTooltip(tester, 'Crear descriptivo');
        await saveForm(tester, label: 'Crear borrador');
        expect(repository.createdDraftFor, 'pos1');
        expect(
          router.routeInformationProvider.value.uri.path,
          '/reclutamiento/descriptivos/nuevo',
        );
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('crea requisición de la fila y conserva navegación y aviso', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      final router = await pumpRecruitment(
        tester,
        path: '/posiciones',
        repository: repository,
        positions: FakePositionsRepository(),
      );
      await tapTooltip(tester, 'Crear requisición');
      await choose(tester, field: 'Tipo de requisición', option: 'Reemplazo');
      await saveForm(tester);
      expect(repository.savedRequisicion!.posicion, 'pos1');
      expect(repository.requisicionCreated, isTrue);
      expect(
        router.routeInformationProvider.value.uri.path,
        '/reclutamiento/requisiciones/nueva',
      );
      expect(find.text('Requisición creada.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
