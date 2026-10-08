import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design_system/spacing.dart';
import '../network/api_failure.dart';
import 'app_button.dart';
import 'confirm_dialog.dart';

/// Alta breve desde un selector; solo pregunta por descartar si cambia el nombre.
class SearchPickerCreateDialog<T extends Object> extends StatefulWidget {
  const SearchPickerCreateDialog({
    super.key,
    required this.label,
    required this.name,
    required this.onCreate,
  });

  final String label;
  final String name;
  final Future<T> Function(String) onCreate;

  @override
  State<SearchPickerCreateDialog<T>> createState() =>
      _SearchPickerCreateDialogState<T>();
}

class _SearchPickerCreateDialogState<T extends Object>
    extends State<SearchPickerCreateDialog<T>> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.name);
  bool _busy = false;
  bool _confirming = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _close() async {
    if (_busy || _confirming) return;
    if (_name.text != widget.name) {
      _confirming = true;
      final discard = await showConfirmDialog(
        context,
        title: 'Descartar cambios',
        message: '¿Descartar el nombre que modificaste?',
        confirmLabel: 'Descartar',
        destructive: false,
        onConfirm: () async {},
      );
      _confirming = false;
      if (!mounted || !discard) return;
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final created = await widget.onCreate(_name.text.trim());
      if (mounted) Navigator.of(context).pop(created);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error =
              validationDetail(error, labels: const {'name': 'Nombre'}) ??
              apiErrorMessage(error);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope<T>(
    canPop: !_busy && _name.text == widget.name,
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
        child: Stack(
          children: [
            // El cierre por clic exterior pertenece solo a esta alta; la
            // barrera compartida de otros diálogos conserva su comportamiento.
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
                              'Agregar ${widget.label.toLowerCase()}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Nombre',
                              ),
                              controller: _name,
                              autofocus: true,
                              enabled: !_busy,
                              onChanged: (_) => setState(() {}),
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Escribe el nombre.'
                                  : value.trim().length > 150
                                  ? 'Usa como máximo 150 caracteres.'
                                  : null,
                            ),
                            if (_error != null) ...[
                              const SizedBox(height: AppSpacing.md),
                              Text(_error!),
                            ],
                            const SizedBox(height: AppSpacing.lg),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: _busy ? null : _close,
                                  child: const Text('Cancelar'),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                AppButton(
                                  label: 'Guardar',
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
  );
}
