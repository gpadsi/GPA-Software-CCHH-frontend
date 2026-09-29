import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../design_system/colors.dart';
import '../design_system/spacing.dart';
import '../network/jefe_inmediato.dart';
import 'app_button.dart';
import 'app_card.dart';
import 'empty_state.dart';
import 'feature_page.dart';

// Reutilizable: se usa en el detalle de Empleado y en cualquier otro lugar
// que necesite mostrar el jefe inmediato de un Empleado — vive en core/
// junto con el provider (core/network/jefe_inmediato.dart) para que ningún
// feature tenga que importar el de otro solo para esto.
class JefeInmediatoCard extends ConsumerWidget {
  const JefeInmediatoCard({super.key, required this.empleadoId});
  final String empleadoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) => AppCard(
    child: ref
        .watch(jefeInmediatoProvider(empleadoId))
        .when(
          skipLoadingOnRefresh: false,
          loading: () => const FeatureLoading(),
          error: (error, _) => FeatureError(
            error: error,
            onRetry: () => ref.invalidate(jefeInmediatoProvider(empleadoId)),
          ),
          data: (jefe) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Jefe inmediato',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              if (jefe.empleadoId == null)
                const EmptyState(
                  icon: Icons.supervisor_account_outlined,
                  title: 'Sin jefe asignado todavía',
                  message:
                      'No hay una posición superior o está vacante en este momento.',
                )
              else
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.sm,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          jefe.nombre ?? 'Nombre no disponible',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          jefe.puesto ?? 'Puesto no capturado',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    AppButton(
                      label: 'Ver expediente',
                      icon: Icons.arrow_forward_rounded,
                      variant: AppButtonVariant.secondary,
                      onPressed: () =>
                          context.go('/empleados/${jefe.empleadoId}'),
                    ),
                  ],
                ),
            ],
          ),
        ),
  );
}
