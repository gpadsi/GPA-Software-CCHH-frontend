import 'package:flutter/material.dart';

import '../network/api_failure.dart';
import 'app_text_field.dart';
import 'form_dialog.dart';

/// Alta breve desde un selector: solo el nombre. Pregunta por descartar solo
/// si se cambió el nombre que venía escrito en el selector.
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
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
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
  Widget build(BuildContext context) => AppFormDialog(
    title: 'Agregar ${widget.label.toLowerCase()}',
    size: AppDialogSize.small,
    busy: _busy,
    error: _error,
    dirty: _name.text != widget.name,
    discardMessage: '¿Descartar el nombre que modificaste?',
    onSave: _save,
    child: Form(
      key: _form,
      child: AppTextField(
        label: 'Nombre',
        controller: _name,
        autofocus: true,
        enabled: !_busy,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => _save(),
        onChanged: (_) => setState(() {}),
        validator: (value) => value == null || value.trim().isEmpty
            ? 'Escribe el nombre.'
            : value.trim().length > 150
            ? 'Usa como máximo 150 caracteres.'
            : null,
      ),
    ),
  );
}
