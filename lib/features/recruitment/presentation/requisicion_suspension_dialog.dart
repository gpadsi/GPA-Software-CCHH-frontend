import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_date_field.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../data/recruitment_repository.dart';
import 'recruitment_ui.dart';

class RequisicionSuspensionDialog extends StatefulWidget {
  const RequisicionSuspensionDialog({super.key, required this.onSuspend});

  final Future<void> Function(String motivo, String fecha, String autorizadoPor)
  onSuspend;

  @override
  State<RequisicionSuspensionDialog> createState() =>
      _RequisicionSuspensionDialogState();
}

class _RequisicionSuspensionDialogState
    extends State<RequisicionSuspensionDialog> {
  final _form = GlobalKey<FormState>();
  final _motivo = TextEditingController();
  final _autorizado = TextEditingController();
  late final _hoy = DateUtils.dateOnly(DateTime.now());
  late DateTime? _fecha = _hoy;
  bool _busy = false;
  bool _confirming = false;
  String? _error;

  bool get _changed =>
      _motivo.text.isNotEmpty || _autorizado.text.isNotEmpty || _fecha != _hoy;

  @override
  void dispose() {
    _motivo.dispose();
    _autorizado.dispose();
    super.dispose();
  }

  Future<void> _close() async {
    if (_busy || _confirming) return;
    if (_changed) {
      _confirming = true;
      final discard = await showConfirmDialog(
        context,
        title: 'Descartar cambios',
        message: '¿Descartar los datos de suspensión que modificaste?',
        confirmLabel: 'Descartar',
        destructive: false,
        onConfirm: () async {},
      );
      _confirming = false;
      if (!mounted || !discard) return;
    }
    if (mounted) Navigator.of(context).pop(false);
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.onSuspend(
        _motivo.text.trim(),
        toIsoDate(_fecha!),
        _autorizado.text.trim(),
      );
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = recruitmentMutationError(error);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope<bool>(
    canPop: !_busy && !_changed,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) _close();
    },
    child: Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
      },
      child: Actions(
        actions: {
          DismissIntent: CallbackAction<DismissIntent>(
            onInvoke: (_) {
              _close();
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _close,
                ),
              ),
              Center(
                child: Dialog(
                  insetPadding: const EdgeInsets.all(AppSpacing.md),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Form(
                          key: _form,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Suspender requisición',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              AppTextField(
                                label: 'Motivo',
                                controller: _motivo,
                                enabled: !_busy,
                                maxLines: null,
                                minLines: 2,
                                onChanged: (_) => setState(() {}),
                                validator: (value) =>
                                    value == null || value.trim().isEmpty
                                    ? 'Escribe el motivo.'
                                    : null,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              AppDateField(
                                label: 'Fecha de suspensión',
                                value: _fecha,
                                enabled: !_busy,
                                isRequired: true,
                                onChanged: (value) =>
                                    setState(() => _fecha = value),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              AppTextField(
                                label: 'Autorizado por',
                                controller: _autorizado,
                                enabled: !_busy,
                                onChanged: (_) => setState(() {}),
                                validator: (value) =>
                                    (value?.trim().length ?? 0) > 150
                                    ? 'Usa como máximo 150 caracteres.'
                                    : null,
                              ),
                              if (_error != null) ...[
                                const SizedBox(height: AppSpacing.md),
                                Semantics(
                                  liveRegion: true,
                                  child: Text(_error!),
                                ),
                              ],
                              const SizedBox(height: AppSpacing.lg),
                              Wrap(
                                alignment: WrapAlignment.end,
                                spacing: AppSpacing.sm,
                                runSpacing: AppSpacing.sm,
                                children: [
                                  AppButton(
                                    label: 'Cancelar',
                                    variant: AppButtonVariant.secondary,
                                    onPressed: _busy ? null : _close,
                                  ),
                                  AppButton(
                                    label: 'Suspender',
                                    isLoading: _busy,
                                    onPressed: _save,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
