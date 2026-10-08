import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../application/recruitment_controller.dart';
import '../data/recruitment_models.dart';

/// Datos vinculados a la posición, de consulta y sin campos editables.
class PosicionContextoCard extends ConsumerWidget {
  const PosicionContextoCard({
    super.key,
    required this.posicionId,
    required this.para,
  });

  final String posicionId;
  final String para;

  String _dato(String? value, {String missing = 'Sin dato'}) =>
      value == null || value.trim().isEmpty ? missing : value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = posicionContextoProvider((posicionId, para));
    final posicion = ref.watch(provider);
    return AppCard(
      // Reservamos los mismos espacios para título, cinco relaciones y trámite
      // durante la carga, incluso si no hay área o trámite abierto.
      child: SizedBox(
        height: 324,
        child: posicion.when(
          data: (data) => _datos(context, data),
          loading: () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 48,
                child: Center(child: LoadingSkeleton()),
              ),
              const SizedBox(height: AppSpacing.md),
              for (var i = 0; i < 5; i++)
                const SizedBox(
                  height: 44,
                  child: Center(child: LoadingSkeleton()),
                ),
              const SizedBox(height: AppSpacing.sm),
              const SizedBox(
                height: 32,
                child: Center(child: LoadingSkeleton(width: 160)),
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
      ),
    );
  }

  Widget _datos(BuildContext context, PosicionContexto posicion) {
    final type = Theme.of(context).textTheme;
    Widget relacion(String label, String value, {bool badge = false}) =>
        SizedBox(
          height: 44,
          child: Row(
            children: [
              SizedBox(width: 104, child: Text(label, style: type.labelMedium)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: badge
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: AppBadge(label: value),
                      )
                    : Text(value, maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 48,
          child: Text(
            _dato(posicion.puesto),
            style: type.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        relacion('Empresa', _dato(posicion.empresa)),
        relacion('Unidad', _dato(posicion.unidad)),
        if (posicion.area?.trim().isNotEmpty ?? false)
          relacion('Área', posicion.area!)
        else
          const SizedBox(height: 44),
        relacion('Estatus', _dato(posicion.estatus), badge: true),
        relacion(
          'Reporta a',
          _dato(posicion.reportaA, missing: 'Sin relación registrada'),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 32,
          child: posicion.tramiteAbierto == null
              ? null
              : Text(
                  posicion.tramiteAbierto!.tipo == 'requisicion'
                      ? 'Requisición abierta'
                      : 'Borrador abierto',
                ),
        ),
      ],
    );
  }
}
