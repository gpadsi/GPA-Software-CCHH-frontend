import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/design_system/breakpoints.dart';
import '../../../core/design_system/colors.dart';
import '../../../core/design_system/motion.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../application/dashboard_controller.dart';
import '../data/dashboard_repository.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionControllerProvider).user;
    final type = Theme.of(context).textTheme;
    final mobile = MediaQuery.sizeOf(context).width < AppBreakpoints.mobile;
    return SingleChildScrollView(
      padding: EdgeInsets.all(mobile ? AppSpacing.md : AppSpacing.xl),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.contentMaxWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                padding: EdgeInsets.all(mobile ? AppSpacing.lg : AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMMEEEEd('es_MX').format(DateTime.now()),
                      style: type.labelMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Hola, ${user?.displayName ?? ''}',
                      style: mobile ? type.headlineSmall : type.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Este es el resumen general de tu organización.',
                      style: type.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('Tu organización en cifras', style: type.titleLarge),
                  AppButton(
                    label: 'Actualizar',
                    icon: Icons.refresh_rounded,
                    variant: AppButtonVariant.text,
                    onPressed: () {
                      for (final metric in DashboardMetric.values) {
                        ref.invalidate(dashboardCountProvider(metric));
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth < 560
                      ? 1
                      : constraints.maxWidth < 1000
                      ? 2
                      : 4;
                  final width =
                      (constraints.maxWidth - AppSpacing.md * (columns - 1)) /
                      columns;
                  return Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: [
                      for (final (index, metric)
                          in DashboardMetric.values.indexed)
                        SizedBox(
                          width: width,
                          child: _CountCard(metric: metric),
                        ).appEnter(context, index: index),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Los totales corresponden a la información disponible para tu cuenta.',
                style: type.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Accesos directos', style: type.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Entra directamente a las secciones más usadas.',
                      style: type.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        AppButton(
                          label: 'Organigrama',
                          icon: Icons.account_tree_outlined,
                          variant: AppButtonVariant.secondary,
                          onPressed: () =>
                              context.go('/organizacion/organigrama'),
                        ),
                        AppButton(
                          label: 'Personas',
                          icon: Icons.people_outline,
                          variant: AppButtonVariant.secondary,
                          onPressed: () => context.go('/personas'),
                        ),
                        AppButton(
                          label: 'Horarios',
                          icon: Icons.schedule_outlined,
                          variant: AppButtonVariant.secondary,
                          onPressed: () => context.go('/horarios/catorcenas'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountCard extends ConsumerWidget {
  const _CountCard({required this.metric});
  final DashboardMetric metric;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(dashboardCountProvider(metric));
    final (label, icon) = switch (metric) {
      DashboardMetric.persons => ('Personas', Icons.people_outline),
      DashboardMetric.employees => ('Empleados', Icons.badge_outlined),
      DashboardMetric.positions => ('Posiciones', Icons.work_outline),
      DashboardMetric.companies => ('Empresas', Icons.business_outlined),
    };
    final type = Theme.of(context).textTheme;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(AppSpacing.controlRadius),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(label, style: type.titleSmall)),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          count.when(
            skipLoadingOnRefresh: false,
            data: (value) => Semantics(
              label: '$label: $value',
              child: Text(
                NumberFormat.decimalPattern('es_MX').format(value),
                style: type.displaySmall,
              ),
            ),
            loading: () => const LoadingSkeleton(width: 100, height: 40),
            error: (error, stack) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(apiErrorMessage(error), style: type.bodySmall),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Reintentar',
                  variant: AppButtonVariant.text,
                  onPressed: () =>
                      ref.invalidate(dashboardCountProvider(metric)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
