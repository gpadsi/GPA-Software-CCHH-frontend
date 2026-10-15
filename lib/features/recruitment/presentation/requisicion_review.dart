import 'package:flutter/material.dart';

import '../../../core/design_system/colors.dart';
import '../../../core/widgets/app_card.dart';

/// Ficha de lectura de los valores actuales del formulario, sin duplicar estado.
class RequisicionReview extends StatelessWidget {
  const RequisicionReview({
    super.key,
    required this.posicion,
    required this.solicitud,
    required this.condiciones,
    required this.compensacion,
    required this.onEdit,
    this.contexto,
    this.justificacion,
    this.faltaJustificacion = false,
  });

  final String? posicion;
  final String? contexto;
  final List<(String, String?)> solicitud;
  final List<(String, String?)> condiciones;
  final List<(String, String?)> compensacion;
  final String? justificacion;
  final bool faltaJustificacion;
  final ValueChanged<int>? onEdit;

  @override
  Widget build(BuildContext context) {
    final type = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Revisión de la requisición', style: type.labelMedium),
            const SizedBox(height: 8),
            Text(
              posicion?.trim().isNotEmpty == true
                  ? posicion!
                  : 'Posición sin seleccionar',
              style: type.headlineSmall,
            ),
            if (contexto?.isNotEmpty == true) ...[
              const SizedBox(height: 6),
              Text(contexto!, style: type.bodySmall),
            ],
            const SizedBox(height: 24),
            Divider(height: 1, color: context.colors.border),
            _section(
              context,
              'Solicitud',
              0,
              solicitud,
              extra: [
                const SizedBox(height: 20),
                _value(context, 'Justificación', justificacion),
                if (faltaJustificacion) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.colors.warningSurface,
                      borderRadius: BorderRadius.circular(
                        context.shape.control,
                      ),
                    ),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Falta la justificación para enviar a autorización.',
                          style: type.bodySmall?.copyWith(
                            color: context.colors.warning,
                          ),
                        ),
                        TextButton(
                          onPressed: onEdit == null ? null : () => onEdit!(0),
                          child: const Text('Ir a Solicitud'),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            Divider(height: 1, color: context.colors.border),
            _section(context, 'Condiciones', 1, condiciones),
            Divider(height: 1, color: context.colors.border),
            _section(context, 'Compensación mensual', 2, compensacion),
          ],
        ),
      ),
    );
  }

  Widget _section(
    BuildContext context,
    String title,
    int index,
    List<(String, String?)> values, {
    List<Widget> extra = const [],
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: onEdit == null ? null : () => onEdit!(index),
              child: Text('Editar', semanticsLabel: 'Editar $title'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final scaled = MediaQuery.textScalerOf(context).scale(14);
            final columns = scaled > 20 || constraints.maxWidth < 480
                ? 1
                : constraints.maxWidth < 780
                ? 2
                : 3;
            final width = (constraints.maxWidth - (columns - 1) * 24) / columns;
            return Wrap(
              spacing: 24,
              runSpacing: 20,
              children: [
                for (final (label, value) in values)
                  SizedBox(width: width, child: _value(context, label, value)),
              ],
            );
          },
        ),
        ...extra,
      ],
    ),
  );

  Widget _value(BuildContext context, String label, String? value) {
    final missing = value == null || value.trim().isEmpty;
    final shown = missing ? 'No especificado' : value;
    final type = Theme.of(context).textTheme;
    return Semantics(
      label: '$label: $shown',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: type.bodySmall),
          const SizedBox(height: 5),
          Text(
            shown,
            style: type.bodyMedium?.copyWith(
              color: missing
                  ? context.colors.textSecondary
                  : context.colors.text,
              fontWeight: missing ? FontWeight.w400 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
