import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/files/file_saver.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/app_row_actions.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/feature_page.dart';
import '../application/recruitment_controller.dart';
import '../application/requisicion_transiciones.dart';
import '../data/recruitment_catalogs.dart';
import '../data/recruitment_models.dart';
import '../data/recruitment_repository.dart';
import 'aprobacion_form.dart';
import 'recruitment_ui.dart';
import 'requisicion_suspension_dialog.dart';
import 'requisiciones_page.dart';

class RequisicionDetailPage extends ConsumerStatefulWidget {
  const RequisicionDetailPage({super.key, required this.requisicionId});
  final String requisicionId;

  @override
  ConsumerState<RequisicionDetailPage> createState() =>
      _RequisicionDetailPageState();
}

class _RequisicionDetailPageState extends ConsumerState<RequisicionDetailPage> {
  bool _exporting = false;
  String? _working;
  bool _submitting = false;
  final _suspenderFocus = FocusNode(debugLabel: 'Suspender');

  @override
  void dispose() {
    _suspenderFocus.dispose();
    super.dispose();
  }

  void _refresh() {
    ref.invalidate(requisicionDetailProvider(widget.requisicionId));
    ref.invalidate(requisicionCatalogsProvider);
    ref.invalidate(requisicionesPageProvider);
  }

  void _say(String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));

  void _edit(Requisicion requisicion) =>
      context.go('/reclutamiento/requisiciones/${requisicion.id}/editar');

  Future<void> _transition(
    TransicionRequisicion action,
    RecruitmentCatalogEntry destino,
  ) async {
    if (_working != null) return;
    setState(() => _working = action.destino);
    Future<void> patch({
      String? motivo,
      String? fecha,
      String? autorizadoPor,
    }) async {
      setState(() => _submitting = true);
      try {
        await ref
            .read(recruitmentRepositoryProvider)
            .cambiarEstadoRequisicion(
              widget.requisicionId,
              destino.id,
              motivo: motivo,
              fecha: fecha,
              autorizadoPor: autorizadoPor,
            );
      } finally {
        if (mounted) setState(() => _submitting = false);
      }
      if (mounted) {
        _refresh();
        _say('Estado actualizado: ${destino.name}.');
      }
    }

    try {
      if (action.captura) {
        await showAppDialog<bool>(
          context: context,
          builder: (_) => RequisicionSuspensionDialog(
            onSuspend: (motivo, fecha, autorizadoPor) => patch(
              motivo: motivo,
              fecha: fecha,
              autorizadoPor: autorizadoPor,
            ),
          ),
        );
      } else if (action.confirmacion) {
        await showConfirmDialog(
          context,
          title: '${action.etiqueta} requisición',
          message:
              '¿Cambiar el estado de esta requisición a «${destino.name}»?',
          confirmLabel: action.etiqueta,
          destructive:
              action.destino == 'cancelada' || action.destino == 'rechazada',
          errorMessage: recruitmentMutationError,
          onConfirm: () => patch(),
        );
      } else {
        await patch();
      }
    } on Object catch (error) {
      if (!mounted) return;
      final data = error is DioException ? error.response?.data : null;
      final fieldErrors =
          error is DioException &&
          error.response?.statusCode == 400 &&
          data is Map &&
          data.keys.any((key) => key != 'detail' && key != 'non_field_errors');
      if (action.destino == 'pendiente-de-autorizacion' && fieldErrors) {
        final complete = await showConfirmDialog(
          context,
          title: 'Completa la requisición',
          message: recruitmentMutationError(error),
          confirmLabel: 'Completar',
          cancelLabel: 'Cerrar',
          destructive: false,
          icon: Icons.assignment_late_outlined,
          onConfirm: () async {},
        );
        if (complete && mounted) {
          context.go(
            '/reclutamiento/requisiciones/${widget.requisicionId}/editar',
          );
        }
      } else {
        _say(recruitmentMutationError(error));
      }
    } finally {
      if (mounted) {
        setState(() => _working = null);
        if (action.captura) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _suspenderFocus.context != null) {
              final button = _suspenderFocus.descendants
                  .where((n) => n.canRequestFocus)
                  .firstOrNull;
              (button ?? _suspenderFocus).requestFocus();
            }
          });
        }
      }
    }
  }

  Future<void> _export() async {
    if (_exporting) return;
    setState(() => _exporting = true);
    try {
      final file = await ref
          .read(recruitmentRepositoryProvider)
          .exportarExcel(widget.requisicionId);
      await ref.read(fileSaverProvider).save(file);
      if (mounted) _say('Se descargó «${file.name}».');
    } on Object catch (error) {
      if (mounted) _say(apiErrorMessage(error));
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _registerApproval(
    RecruitmentCatalogEntry etapa,
    Aprobacion? current,
  ) async {
    final saved = await showAppDialog<bool>(
      context: context,
      builder: (_) => AprobacionForm(
        requisicionId: widget.requisicionId,
        etapa: etapa,
        aprobacion: current,
      ),
    );
    if (saved == true && mounted) {
      ref.invalidate(requisicionDetailProvider(widget.requisicionId));
      _say('Aprobación guardada.');
    }
  }

  Future<void> _removeApproval(
    RecruitmentCatalogEntry etapa,
    Aprobacion current,
  ) async {
    final removed = await showConfirmDialog(
      context,
      title: 'Quitar aprobación',
      message:
          '¿Quitar la aprobación de «${etapa.name}»? La etapa vuelve a quedar pendiente.',
      confirmLabel: 'Quitar',
      onConfirm: () =>
          ref.read(recruitmentRepositoryProvider).deleteAprobacion(current.id),
      errorMessage: recruitmentMutationError,
    );
    if (removed && mounted) {
      ref.invalidate(requisicionDetailProvider(widget.requisicionId));
      _say('Aprobación quitada.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final requisicion = ref.watch(
      requisicionDetailProvider(widget.requisicionId),
    );
    final catalogs = ref.watch(requisicionCatalogsProvider);
    final canManage = ref.watch(canManageHrProvider);
    final me = ref.watch(sessionControllerProvider).user?.id;
    final loaded = requisicion.value;
    return AppPage(
      section: 'Reclutamiento',
      title: loaded?.posicionEtiqueta.isNotEmpty ?? false
          ? loaded!.posicionEtiqueta
          : 'Requisición',
      description: switch ((loaded, catalogs.value)) {
        (final r?, final c?) =>
          'Requisición de ${nameIn(c.tipos, r.tipo)?.toLowerCase() ?? 'personal'}, solicitada el ${shownDate(r.fechaSolicitud) ?? 'sin fecha'}.',
        _ => 'Detalle de la requisición.',
      },
      tabs: const AppRouteTabs(
        current: '/reclutamiento',
        destinations: recruitmentTabs,
      ),
      actions: [
        if (loaded != null &&
            canEditRequisicion(loaded, canManage: canManage, me: me))
          AppButton(
            label: 'Editar',
            icon: Icons.edit_outlined,
            onPressed: _working == null ? () => _edit(loaded) : null,
          ),
        if (loaded != null)
          AppButton(
            label: 'Descargar Excel oficial',
            icon: Icons.download_outlined,
            variant: AppButtonVariant.secondary,
            isLoading: _exporting,
            onPressed: _export,
          ),
        AppButton(
          label: 'Actualizar',
          icon: Icons.refresh,
          variant: AppButtonVariant.secondary,
          onPressed: _working == null ? _refresh : null,
        ),
      ],
      child: switch ((requisicion, catalogs)) {
        (AsyncError(:final error), _) || (_, AsyncError(:final error)) =>
          FeatureError(error: error, onRetry: _refresh),
        (AsyncData(value: final r), AsyncData(value: final c)) => _body(
          r,
          c,
          canManage: canManage,
          me: me,
        ),
        _ => const FeatureLoading(),
      },
    );
  }

  Widget _body(
    Requisicion r,
    RequisicionCatalogs c, {
    required bool canManage,
    required String? me,
  }) {
    final estado = entryIn(c.estados, r.estado);
    final tipo = entryIn(c.tipos, r.tipo);
    final transiciones = transicionesDisponibles(
      r,
      c.estados,
      puedeGestionar: canManage,
      esDueno: me != null && r.creadoPor == me,
    );
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (transiciones.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final action in transiciones)
                      Focus(
                        focusNode: action.captura ? _suspenderFocus : null,
                        child: AppButton(
                          label: action.etiqueta,
                          variant:
                              action.destino == 'cancelada' ||
                                  action.destino == 'rechazada'
                              ? AppButtonVariant.danger
                              : action == transiciones.first
                              ? AppButtonVariant.primary
                              : AppButtonVariant.secondary,
                          isLoading: _working == action.destino && _submitting,
                          onPressed: _working == null
                              ? () => _transition(
                                  action,
                                  c.estados.firstWhere(
                                    (e) => e.code == action.destino,
                                  ),
                                )
                              : null,
                        ),
                      ),
                  ],
                ),
              ),
            _Card(
              title: 'Solicitud',
              children: [
                DetailField('Tipo', tipo?.name),
                DetailField(
                  'Estado',
                  estado?.name,
                  child: estado == null
                      ? null
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: AppBadge(
                            label: estado.name,
                            tone: estadoTone(estado.code),
                          ),
                        ),
                ),
                DetailField('Fecha de solicitud', shownDate(r.fechaSolicitud)),
                DetailField(
                  'Fecha a cubrir la vacante',
                  shownDate(r.fechaACubrirVacante),
                ),
                DetailField(
                  'Entrega a Capital Humano',
                  shownDate(r.fechaEntregaACapitalHumano),
                ),
                DetailField('Área solicitante', r.areaSolicitanteNombre ?? ''),
                DetailField(
                  'Solicitante',
                  r.solicitante ?? 'Importada de los datos de GPA',
                ),
              ],
            ),
            if ((tipo?.requiereJustificacion ?? false) ||
                r.justificacion.trim().isNotEmpty)
              _Card(
                title: 'Justificación',
                children: [
                  Text(
                    r.justificacion.trim().isEmpty
                        ? noCapturado
                        : r.justificacion,
                  ),
                ],
              ),
            _Card(
              title: 'Perfil de la vacante',
              children: [
                DetailField(
                  'Horario a cubrir',
                  nameIn(c.horarios, r.horarioACubrir),
                ),
                DetailField('Idiomas requeridos', r.idiomasRequeridos),
                DetailField(
                  'Disposición para viajar',
                  switch (r.disposicionViajar) {
                    true => 'Sí',
                    false => 'No',
                    null => null,
                  },
                ),
              ],
            ),
            _Card(
              title: 'Compensación',
              children: [
                DetailField('Nivel de tabulador', r.nivelTabulador),
                DetailField(
                  'Sueldo mensual compuesto',
                  shownMoney(r.sueldoMensualCompuesto),
                ),
                DetailField(
                  'Sueldo mensual bruto',
                  shownMoney(r.sueldoMensualBruto),
                ),
                DetailField(
                  'Sueldo mensual neto',
                  shownMoney(r.sueldoMensualNeto),
                ),
                DetailField(
                  'Tipo de contrato',
                  nameIn(c.tiposContrato, r.tipoContratoOfrecido),
                ),
              ],
            ),
            if (r.tieneDatosDeSuspension)
              _Card(
                title: 'Suspensión',
                children: [
                  DetailField('Motivo', r.motivoSuspension),
                  DetailField('Fecha', shownDate(r.fechaSuspension)),
                  DetailField('Autorizado por', r.autorizadoPorSuspension),
                ],
              ),
            _approvals(r, c, canManage: canManage, me: me),
          ],
        ),
      ),
    );
  }

  Widget _approvals(
    Requisicion r,
    RequisicionCatalogs c, {
    required bool canManage,
    required String? me,
  }) {
    final type = Theme.of(context).textTheme;
    return _Card(
      title: 'Aprobaciones',
      children: [
        Text(
          canManage
              ? 'Las firmas del formulario. Tú las registras, ya sean digitales o físicas.'
              : 'Las firmas del formulario. Capital Humano las registra.',
          style: type.bodySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        for (final etapa in c.etapas)
          Builder(
            builder: (context) {
              final current = r.aprobaciones
                  .where((a) => a.etapa == etapa.id)
                  .firstOrNull;
              final done = current?.fecha != null;
              final who = !done
                  ? ''
                  : current!.usuario != null && current.usuario == me
                  ? 'por ti'
                  : current.nombreManual.trim().isNotEmpty
                  ? 'por ${current.nombreManual}'
                  : 'por un usuario del sistema';
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.xs,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(etapa.name, style: type.titleSmall),
                    ),
                    AppBadge(
                      label: done
                          ? 'Aprobada el ${shownDate(current!.fecha)}'
                          : 'Pendiente',
                      tone: done ? AppBadgeTone.success : AppBadgeTone.neutral,
                    ),
                    if (done) Text(who, style: type.bodySmall),
                    if (canManage && !done)
                      AppButton(
                        label: 'Registrar aprobación',
                        icon: Icons.check,
                        variant: AppButtonVariant.secondary,
                        onPressed: () => _registerApproval(etapa, current),
                      ),
                    if (canManage && done)
                      AppRowActions(
                        subject: 'aprobación de ${etapa.name}',
                        onEdit: () => _registerApproval(etapa, current),
                        onDelete: () => _removeApproval(etapa, current!),
                      ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
    child: AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.lg),
          ...children,
        ],
      ),
    ),
  );
}
