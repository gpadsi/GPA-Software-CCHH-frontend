// Piezas compartidas que estrena el paso 3: campo de fecha, filtro desplegable
// y campo de texto multilínea / de solo lectura.
import 'package:capital_humano_front/core/widgets/app_date_field.dart';
import 'package:capital_humano_front/core/widgets/app_filter_field.dart';
import 'package:capital_humano_front/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

Widget _host(Widget child) => MaterialApp(
  home: Scaffold(
    body: Padding(padding: const EdgeInsets.all(16), child: child),
  ),
);

void main() {
  setUpAll(() => initializeDateFormatting('es_MX'));

  group('AppDateField', () {
    testWidgets('sin fecha se ve vacío y al tocarlo abre el selector', (
      tester,
    ) async {
      DateTime? picked;
      await tester.pumpWidget(
        _host(
          AppDateField(
            label: 'Fecha de solicitud',
            value: null,
            onChanged: (value) => picked = value,
          ),
        ),
      );
      expect(find.text('Fecha de solicitud'), findsOneWidget);
      await tester.tap(find.text('Fecha de solicitud'));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      // Sin fecha previa el selector arranca en hoy.
      final today = DateTime.now();
      expect(picked, DateTime(today.year, today.month, today.day));
    });

    testWidgets('muestra la fecha con formato legible y se puede quitar', (
      tester,
    ) async {
      DateTime? current = DateTime(2026, 9, 12);
      await tester.pumpWidget(
        _host(
          StatefulBuilder(
            builder: (context, setState) => AppDateField(
              key: ValueKey(current),
              label: 'Fecha',
              value: current,
              onChanged: (value) => setState(() => current = value),
            ),
          ),
        ),
      );
      expect(find.textContaining('2026'), findsOneWidget);
      expect(find.textContaining('12'), findsOneWidget);
      await tester.tap(find.byTooltip('Quitar Fecha'));
      await tester.pumpAndSettle();
      expect(current, isNull);
      expect(find.byTooltip('Quitar Fecha'), findsNothing);
    });

    testWidgets('si es obligatoria no ofrece quitarla y valida', (
      tester,
    ) async {
      final form = GlobalKey<FormState>();
      await tester.pumpWidget(
        _host(
          Form(
            key: form,
            child: AppDateField(
              label: 'Fecha',
              value: DateTime(2026, 9, 12),
              isRequired: true,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      expect(find.byTooltip('Quitar Fecha'), findsNothing);
      expect(form.currentState!.validate(), isTrue);

      final empty = GlobalKey<FormState>();
      await tester.pumpWidget(
        _host(
          Form(
            key: empty,
            child: AppDateField(
              label: 'Fecha',
              value: null,
              isRequired: true,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      expect(empty.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('Elige una fecha.'), findsOneWidget);
    });

    testWidgets('deshabilitado no abre el selector', (tester) async {
      await tester.pumpWidget(
        _host(
          AppDateField(
            label: 'Fecha',
            value: DateTime(2026, 9, 12),
            enabled: false,
            onChanged: (_) {},
          ),
        ),
      );
      await tester.tap(find.text('Fecha'));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsNothing);
      expect(find.byTooltip('Quitar Fecha'), findsNothing);
    });
  });

  group('AppFilterField', () {
    testWidgets('ofrece «Todos» y cada opción, y avisa la elegida', (
      tester,
    ) async {
      int? chosen = -1;
      await tester.pumpWidget(
        _host(
          AppFilterField<int>(
            label: 'Estado',
            value: null,
            options: const [
              (value: 1, label: 'Borrador'),
              (value: 2, label: 'Autorizada'),
            ],
            onChanged: (value) => chosen = value,
          ),
        ),
      );
      expect(find.text('Todos'), findsOneWidget);
      await tester.tap(find.byType(DropdownButtonFormField<int?>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Autorizada').last);
      await tester.pumpAndSettle();
      expect(chosen, 2);
    });

    testWidgets('elegir «Todos» quita el filtro (null)', (tester) async {
      int? chosen = -1;
      await tester.pumpWidget(
        _host(
          AppFilterField<int>(
            label: 'Estado',
            value: 2,
            options: const [
              (value: 1, label: 'Borrador'),
              (value: 2, label: 'Autorizada'),
            ],
            onChanged: (value) => chosen = value,
          ),
        ),
      );
      expect(find.text('Autorizada'), findsOneWidget);
      await tester.tap(find.byType(DropdownButtonFormField<int?>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Todos').last);
      await tester.pumpAndSettle();
      expect(chosen, isNull);
    });
  });

  group('AppTextField', () {
    testWidgets('de solo lectura se ve pero no se edita', (tester) async {
      final controller = TextEditingController(text: 'Texto fijo');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          AppTextField(
            label: 'Propósito',
            controller: controller,
            readOnly: true,
          ),
        ),
      );
      expect(find.text('Texto fijo'), findsOneWidget);
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.readOnly, isTrue);
      // No está «deshabilitado»: conserva el color normal del texto.
      expect(field.enabled, isTrue);
    });

    testWidgets('multilínea crece con el contenido y admite saltos de línea', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          AppTextField(
            label: 'Justificación',
            controller: controller,
            maxLines: null,
            minLines: 3,
          ),
        ),
      );
      final shortHeight = tester.getSize(find.byType(TextField)).height;
      await tester.enterText(
        find.byType(TextField),
        List.generate(8, (i) => 'Línea $i').join('\n'),
      );
      await tester.pump();
      expect(
        tester.getSize(find.byType(TextField)).height,
        greaterThan(shortHeight),
      );
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.keyboardType, TextInputType.multiline);
    });

    testWidgets('de una línea sigue igual que antes', (tester) async {
      await tester.pumpWidget(_host(const AppTextField(label: 'Nombre')));
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.maxLines, 1);
      expect(field.readOnly, isFalse);
      expect(field.keyboardType, TextInputType.text);
    });
  });
}
