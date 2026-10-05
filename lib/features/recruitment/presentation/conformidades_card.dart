import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_date_field.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/app_row_actions.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/form_panel.dart';
import '../../employment/presentation/persona_picker_field.dart';
import '../application/recruitment_controller.dart';
import '../data/recruitment_models.dart';
import '../data/recruitment_repository.dart';
import 'recruitment_ui.dart';

/// Las firmas de conformidad de una versión CONGELADA (Colaborador, Jefe
/// inmediato, Capital Humano). Capital Humano captura cada una, digital o
/// física. El rol Colaborador se liga a una persona concreta y puede haber
/// varias (cada quien firma la versión que conoció); los demás, una sola.
class ConformidadesCard extends ConsumerWidget {
  const ConformidadesCard({
    super.key,
    required this.descriptivo,
    required this.roles,
    required this.onChanged,
  });

  final Descriptivo descriptivo;
  final List<RecruitmentCatalogEntry> roles;

  /// Se llama después de guardar o quitar algo, para recargar la versión.
  final VoidCallback onChanged;

  Future<void> _edit(
    BuildContext context,
    RecruitmentCatalogEntry rol,
    Conformidad? current,
  ) async {
    final saved = await showAppPanel<bool>(
      context: context,
      builder: (_) => ConformidadForm(
        descriptivoId: descriptivo.id,
        rol: rol,
        conformidad: current,
      ),
    );
    if (saved == true) onChanged();
  }

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    RecruitmentCatalogEntry rol,
    Conformidad current,
  ) async {
    final removed = await showConfirmDialog(
      context,
      title: 'Quitar conformidad',
      message: '¿Quitar la conformidad de «${rol.name}»?',
      confirmLabel: 'Quitar',
      onConfirm: () =>
          ref.read(recruitmentRepositoryProvider).deleteConformidad(current.id),
      errorMessage: recruitmentMutationError,
    );
    if (removed) onChanged();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = Theme.of(context).textTheme;
    final me = ref.watch(sessionControllerProvider).user?.id;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Conformidades', style: type.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Quién dio su conformidad a esta versión. Se registran después de congelarla.',
            style: type.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final rol in roles)
            Builder(
              builder: (context) {
                final entries = descriptivo.conformidades
                    .where((c) => c.rol == rol.id)
                    .toList();
                final canAdd = rol.requierePersona || entries.isEmpty;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rol.name, style: type.titleSmall),
                      const SizedBox(height: AppSpacing.sm),
                      if (entries.isEmpty) const AppBadge(label: 'Pendiente'),
                      for (final c in entries)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: AppSpacing.md,
                            children: [
                              AppBadge(
                                label: c.fecha == null
                                    ? 'Pendiente'
                                    : 'Conforme el ${shownDate(c.fecha)}',
                                tone: c.fecha == null
                                    ? AppBadgeTone.neutral
                                    : AppBadgeTone.success,
                              ),
                              Text(_who(c, me), style: type.bodySmall),
                              AppRowActions(
                                subject: 'conformidad de ${rol.name}',
                                onEdit: () => _edit(context, rol, c),
                                onDelete: () => _remove(context, ref, rol, c),
                              ),
                            ],
                          ),
                        ),
                      if (canAdd)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: AppButton(
                            label: 'Registrar conformidad',
                            icon: Icons.check,
                            variant: AppButtonVariant.secondary,
                            onPressed: () => _edit(context, rol, null),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  String _who(Conformidad c, String? me) {
    if (c.personaNombre != null && c.personaNombre!.isNotEmpty) {
      return c.personaNombre!;
    }
    if (c.usuario != null && c.usuario == me) return 'tú';
    if (c.nombreManual.trim().isNotEmpty) return c.nombreManual;
    return c.usuario != null ? 'un usuario del sistema' : '';
  }
}

/// Registra o corrige una conformidad. En el rol que exige persona (el
/// Colaborador) se elige a la persona, que ya no se cambia al corregir; en los
/// demás se dice quién la dio: la propia cuenta o un nombre a mano.
class ConformidadForm extends ConsumerStatefulWidget {
  const ConformidadForm({
    super.key,
    required this.descriptivoId,
    required this.rol,
    this.conformidad,
  });

  final String descriptivoId;
  final RecruitmentCatalogEntry rol;
  final Conformidad? conformidad;

  @override
  ConsumerState<ConformidadForm> createState() => _ConformidadFormState();
}

class _ConformidadFormState extends ConsumerState<ConformidadForm> {
  final _form = GlobalKey<FormState>();
  late DateTime? _fecha =
      parseIsoDate(widget.conformidad?.fecha) ?? DateTime.now();
  String? _personaId;
  String? _personaError;
  late bool _firmoYo =
      widget.conformidad?.usuario != null &&
      widget.conformidad!.usuario ==
          ref.read(sessionControllerProvider).user?.id;
  late final _nombre = TextEditingController(
    text: widget.conformidad?.nombreManual,
  );
  bool _busy = false;
  String? _error;

  bool get _editing => widget.conformidad != null;

  @override
  void dispose() {
    _nombre.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy) return;
    final valid = _form.currentState!.validate();
    final needsPerson = widget.rol.requierePersona && !_editing;
    if (needsPerson && _personaId == null) {
      setState(() => _personaError = 'Elige a la persona de la lista.');
      return;
    }
    if (!valid) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final current = widget.conformidad;
    final persona = widget.rol.requierePersona;
    try {
      await ref
          .read(recruitmentRepositoryProvider)
          .saveConformidad(
            Conformidad(
              id: current?.id ?? '',
              descriptivo: widget.descriptivoId,
              rol: widget.rol.id,
              persona: current?.persona ?? _personaId,
              fecha: toIsoDate(_fecha!),
              usuario: !persona && _firmoYo
                  ? ref.read(sessionControllerProvider).user?.id
                  : null,
              nombreManual: !persona && !_firmoYo ? _nombre.text : '',
            ),
            creating: !_editing,
          );
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _error = recruitmentMutationError(error);
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final persona = widget.rol.requierePersona;
    return AppFormPanel(
      title: 'Conformidad: ${widget.rol.name}',
      busy: _busy,
      error: _error,
      onSave: _save,
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppDateField(
              label: 'Fecha de conformidad',
              value: _fecha,
              isRequired: true,
              enabled: !_busy,
              onChanged: (value) => _fecha = value,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (persona && !_editing)
              PersonaPickerField(
                enabled: !_busy,
                errorText: _personaError,
                onChanged: (value) => setState(() {
                  _personaId = value?.id;
                  _personaError = null;
                }),
              )
            else if (persona)
              InputDecorator(
                decoration: const InputDecoration(labelText: 'Persona'),
                child: Text(widget.conformidad?.personaNombre ?? ''),
              )
            else ...[
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('La registro yo, dentro del sistema'),
                subtitle: Text(
                  'Apágalo si firmó otra persona (por ejemplo en papel) y escribe su nombre.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                value: _firmoYo,
                onChanged: _busy
                    ? null
                    : (value) => setState(() => _firmoYo = value),
              ),
              if (!_firmoYo) ...[
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Nombre de quien dio su conformidad',
                  controller: _nombre,
                  enabled: !_busy,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return 'Escribe quién la dio.';
                    if (text.length > 150) {
                      return 'Usa como máximo 150 caracteres.';
                    }
                    return null;
                  },
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
