import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/colors.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../application/recruitment_controller.dart';
import '../data/recruitment_models.dart';

/// Contexto de consulta con espacio reservado durante la carga y dos columnas
/// cuando hay espacio. Crece con el texto; cada relación conserva su tooltip.
class PosicionContextoCard extends ConsumerWidget {
  const PosicionContextoCard({
    super.key,
    required this.posicionId,
    required this.para,
    this.action,
  });
  final String posicionId;
  final String para;
  final Widget? action;

  String _dato(String? value, {String missing = 'Sin dato'}) =>
      value == null || value.trim().isEmpty ? missing : value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = posicionContextoProvider((posicionId, para));
    final posicion = ref.watch(provider);
    final scaler = MediaQuery.textScalerOf(context);
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 600;
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  scaler.scale(wide ? 162 : 218) +
                  (!wide && action != null ? 48 : 0),
            ),
            child: posicion.when(
              data: (data) => _datos(context, data, wide, scaler),
              loading: () => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LoadingSkeleton(width: 180, height: 14),
                  const SizedBox(height: 12),
                  const LoadingSkeleton(width: 260, height: 24),
                  const SizedBox(height: 20),
                  for (var i = 0; i < (wide ? 2 : 4); i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: LoadingSkeleton(
                        width: 320,
                        height: scaler.scale(12),
                      ),
                    ),
                ],
              ),
              error: (_, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('No se pudo cargar la posición.'),
                    TextButton(
                      onPressed: () => ref.invalidate(provider),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _datos(
    BuildContext context,
    PosicionContexto data,
    bool wide,
    TextScaler scaler,
  ) {
    final type = Theme.of(context).textTheme;
    Widget text(String value, {TextStyle? style}) => Tooltip(
      message: value,
      excludeFromSemantics: true,
      child: Text(
        value,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
    Widget relation(String label, String value) => SizedBox(
      height: scaler.scale(28),
      child: Row(
        children: [
          SizedBox(
            width: 84,
            child: Text(
              label,
              style: type.labelMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: text(value, style: type.bodyMedium)),
        ],
      ),
    );
    final fields = [
      relation('Empresa', _dato(data.empresa)),
      relation('Unidad', _dato(data.unidad)),
      if (data.area != null && data.area!.trim().isNotEmpty)
        relation('Área', data.area!),
      relation(
        'Reporta a',
        _dato(data.reportaA, missing: 'Sin relación registrada'),
      ),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'POSICIÓN VINCULADA',
                style: type.labelSmall?.copyWith(
                  color: context.colors.textSecondary,
                  letterSpacing: 1,
                ),
              ),
            ),
            if (wide && action != null) action!,
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: text(
                _dato(data.puesto),
                style: type.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 12),
            if (wide) ...[
              Text('Estatus', style: type.labelMedium),
              const SizedBox(width: 8),
              AppBadge(label: _dato(data.estatus)),
            ],
          ],
        ),
        const SizedBox(height: 14),
        if (wide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Column(children: fields.take(2).toList())),
              const SizedBox(width: 24),
              Expanded(child: Column(children: fields.skip(2).toList())),
            ],
          )
        else
          ...fields,
        const SizedBox(height: 8),
        Row(
          children: [
            if (!wide) ...[
              Text('Estatus', style: type.labelMedium),
              const SizedBox(width: 8),
            ],
            if (!wide) Flexible(child: AppBadge(label: _dato(data.estatus))),
            if (!wide) const SizedBox(width: 8),
            if (data.tramiteAbierto != null)
              Expanded(
                child: text(
                  data.tramiteAbierto!.tipo == 'requisicion'
                      ? 'Requisición abierta'
                      : 'Borrador abierto',
                  style: type.bodySmall,
                ),
              ),
          ],
        ),
        if (!wide && action != null)
          Align(alignment: Alignment.centerRight, child: action!),
      ],
    );
  }
}
