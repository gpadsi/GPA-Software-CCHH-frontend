import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/design_system/colors.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_badge.dart';

const recruitmentTabs = [
  (label: 'Requisiciones', path: '/reclutamiento'),
  (label: 'Descriptivos de puesto', path: '/reclutamiento/descriptivos'),
];

final _isoDate = DateFormat('yyyy-MM-dd');
final _shownDate = DateFormat.yMMMd('es_MX');
final _money = NumberFormat.currency(locale: 'es_MX', symbol: r'$');

/// La fecha como la espera el servidor (`2026-10-05`).
String toIsoDate(DateTime date) => _isoDate.format(date);

DateTime? parseIsoDate(String? value) =>
    value == null || value.isEmpty ? null : DateTime.tryParse(value);

/// Una fecha del servidor como la lee una persona ("5 oct 2026"); null si no
/// hay (la pantalla decide qué dice en su lugar).
String? shownDate(String? iso) {
  final date = parseIsoDate(iso);
  return date == null ? null : _shownDate.format(date);
}

/// Un importe del servidor ("12500.00") como moneda ("$12,500.00").
String? shownMoney(String? value) {
  final amount = value == null ? null : double.tryParse(value);
  return amount == null ? null : _money.format(amount);
}

/// El color del estado de una requisición, por su código (es solo
/// presentación: lo que el estado permite lo decide el servidor).
AppBadgeTone estadoTone(String? code) => switch (code) {
  'cubierta' || 'autorizada' => AppBadgeTone.success,
  'cancelada' || 'rechazada' => AppBadgeTone.error,
  'suspendida' || 'pendiente-de-autorizacion' => AppBadgeTone.warning,
  _ => AppBadgeTone.neutral,
};

const noCapturado = 'No capturado';

/// Una fila "etiqueta: valor" de las fichas de detalle. Un valor vacío dice
/// [noCapturado] en lugar de dejar un hueco.
class DetailField extends StatelessWidget {
  const DetailField(this.label, this.value, {super.key, this.child});

  final String label;
  final String? value;

  /// Un widget en lugar del texto (ej. una insignia de estado).
  final Widget? child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.md),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 420;
        final labelText = Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary),
        );
        final content =
            child ??
            Text(value == null || value!.trim().isEmpty ? noCapturado : value!);
        return stacked
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [labelText, const SizedBox(height: 2), content],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 220, child: labelText),
                  Expanded(child: content),
                ],
              );
      },
    ),
  );
}

/// Una sección con título dentro de una ficha o formulario.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.padTop = true});
  final String text;
  final bool padTop;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
      top: padTop ? AppSpacing.xl : 0,
      bottom: AppSpacing.md,
    ),
    child: Text(text, style: Theme.of(context).textTheme.titleSmall),
  );
}
