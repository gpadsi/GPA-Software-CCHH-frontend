import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/design_system/colors.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/feature_page.dart';
import '../../../core/widgets/jefe_inmediato_card.dart';
import '../../../core/network/jefe_inmediato.dart';
import '../application/employment_controller.dart';
import '../data/employment_models.dart';
import 'empleado_form.dart';

const _noCapturado = 'No capturado';
final _displayDate = DateFormat.yMMMd('es_MX');

class EmpleadoDetailPage extends ConsumerWidget {
  const EmpleadoDetailPage({super.key, required this.empleadoId});
  final String empleadoId;

  void _refresh(WidgetRef ref) {
    ref.invalidate(empleadoDetailProvider(empleadoId));
    ref.invalidate(contratoVigenteDeProvider(empleadoId));
    ref.invalidate(jefeInmediatoProvider(empleadoId));
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    Empleado empleado,
  ) async {
    final saved = await showAppPanel<bool>(
      context: context,
      builder: (_) => EmpleadoForm(empleado: empleado),
    );
    if (saved == true) {
      ref.invalidate(empleadoDetailProvider(empleadoId));
      ref.invalidate(empleadosPageProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final empleado = ref.watch(empleadoDetailProvider(empleadoId));
    final canManage = ref.watch(canManageHrProvider);
    final title = switch (empleado) {
      AsyncData(:final value) => value.workNumber ?? 'Empleado',
      _ => 'Empleado',
    };
    return FeaturePage(
      title: title,
      description: 'Contrato vigente y posición actual de este empleado.',
      actions: [
        if (canManage && empleado.hasValue)
          AppButton(
            label: 'Editar',
            icon: Icons.edit_outlined,
            onPressed: () => _edit(context, ref, empleado.requireValue),
          ),
        AppButton(
          label: 'Actualizar',
          icon: Icons.refresh,
          variant: AppButtonVariant.secondary,
          onPressed: () => _refresh(ref),
        ),
      ],
      child: empleado.when(
        skipLoadingOnRefresh: false,
        loading: () => const FeatureLoading(),
        error: (error, _) =>
            FeatureError(error: error, onRetry: () => _refresh(ref)),
        data: (data) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PersonaCard(personaId: data.persona),
            const SizedBox(height: AppSpacing.lg),
            _ContratoCard(empleadoId: data.id),
            const SizedBox(height: AppSpacing.lg),
            JefeInmediatoCard(empleadoId: data.id),
          ],
        ),
      ),
    );
  }
}

Widget _field(String label, String? value) => Padding(
  padding: const EdgeInsets.only(bottom: AppSpacing.md),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 160,
        child: Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
      Expanded(
        child: Text(
          value == null || value.trim().isEmpty ? _noCapturado : value,
        ),
      ),
    ],
  ),
);

class _PersonaCard extends ConsumerWidget {
  const _PersonaCard({required this.personaId});
  final String personaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) => AppCard(
    child: ref
        .watch(personSummaryProvider(personaId))
        .when(
          skipLoadingOnRefresh: false,
          loading: () => const FeatureLoading(),
          error: (error, _) => FeatureError(
            error: error,
            onRetry: () => ref.invalidate(personSummaryProvider(personaId)),
          ),
          data: (persona) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.sm,
                children: [
                  Text(
                    persona.fullName.isEmpty ? 'Persona' : persona.fullName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  AppButton(
                    label: 'Ver expediente completo',
                    icon: Icons.arrow_forward_rounded,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => context.go('/personas/$personaId'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _field('Correo personal', persona.personalEmail),
              _field('Teléfono', persona.phone),
            ],
          ),
        ),
  );
}

class _ContratoCard extends ConsumerWidget {
  const _ContratoCard({required this.empleadoId});
  final String empleadoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) => AppCard(
    child: ref
        .watch(contratoVigenteDeProvider(empleadoId))
        .when(
          skipLoadingOnRefresh: false,
          loading: () => const FeatureLoading(),
          error: (error, _) => FeatureError(
            error: error,
            onRetry: () =>
                ref.invalidate(contratoVigenteDeProvider(empleadoId)),
          ),
          data: (contrato) => contrato == null
              ? const EmptyState(
                  icon: Icons.work_off_outlined,
                  title: 'Sin contrato vigente',
                  message: 'Este empleado no tiene un contrato activo hoy.',
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Contrato vigente',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _field(
                      'Fecha de ingreso',
                      contrato.fechaIngreso == null
                          ? null
                          : _displayDate.format(
                              DateTime.parse(contrato.fechaIngreso!),
                            ),
                    ),
                    _field(
                      'Fecha de alta',
                      contrato.fechaAlta == null
                          ? null
                          : _displayDate.format(
                              DateTime.parse(contrato.fechaAlta!),
                            ),
                    ),
                    _field(
                      'Fecha de reingreso',
                      contrato.fechaReingreso == null
                          ? null
                          : _displayDate.format(
                              DateTime.parse(contrato.fechaReingreso!),
                            ),
                    ),
                    const Divider(height: AppSpacing.xl),
                    Text(
                      'Posición actual',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _PosicionSummaryView(posicionId: contrato.posicion),
                  ],
                ),
        ),
  );
}

class _PosicionSummaryView extends ConsumerWidget {
  const _PosicionSummaryView({required this.posicionId});
  final String posicionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(posicionSummaryProvider(posicionId))
      .when(
        skipLoadingOnRefresh: false,
        loading: () => const FeatureLoading(),
        error: (error, _) => FeatureError(
          error: error,
          onRetry: () => ref.invalidate(posicionSummaryProvider(posicionId)),
        ),
        data: (posicion) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (posicion.puesto == null)
              _field('Puesto', null)
            else
              _PuestoField(puestoId: posicion.puesto!),
            _EstatusField(estatusId: posicion.estatus),
          ],
        ),
      );
}

class _PuestoField extends ConsumerWidget {
  const _PuestoField({required this.puestoId});
  final int puestoId;
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(puestoRefProvider(puestoId))
      .when(
        data: (value) => _field('Puesto', value.name),
        loading: () => _field('Puesto', 'Cargando…'),
        error: (_, _) => _field('Puesto', null),
      );
}

class _EstatusField extends ConsumerWidget {
  const _EstatusField({required this.estatusId});
  final int estatusId;
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(estatusRefProvider(estatusId))
      .when(
        data: (value) => _field('Estatus', value.name),
        loading: () => _field('Estatus', 'Cargando…'),
        error: (_, _) => _field('Estatus', null),
      );
}
