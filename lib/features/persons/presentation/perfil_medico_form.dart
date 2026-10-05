import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/spacing.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/form_panel.dart';
import '../application/persons_controller.dart';
import '../data/person_models.dart';

class PerfilMedicoForm extends ConsumerStatefulWidget {
  const PerfilMedicoForm({
    super.key,
    required this.personaId,
    required this.tiposSangre,
    this.perfil,
  });
  final String personaId;
  final List<PersonCatalogEntry> tiposSangre;
  final PerfilMedico? perfil;
  @override
  ConsumerState<PerfilMedicoForm> createState() => _PerfilMedicoFormState();
}

class _PerfilMedicoFormState extends ConsumerState<PerfilMedicoForm> {
  late final _allergies = TextEditingController(text: widget.perfil?.allergies);
  late int? _bloodType = widget.perfil?.bloodType;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _allergies.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(personsRepositoryProvider)
          .savePerfil(
            PerfilMedico(
              id: widget.perfil?.id ?? '',
              persona: widget.personaId,
              bloodType: _bloodType,
              allergies: _allergies.text.trim(),
            ),
            creating: widget.perfil == null,
          );
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _error = apiErrorMessage(error);
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => AppFormPanel(
    title: widget.perfil == null
        ? 'Agregar perfil médico'
        : 'Editar perfil médico',
    busy: _busy,
    error: _error,
    onSave: _save,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<int>(
          key: ValueKey('tipo-sangre:$_bloodType'),
          initialValue: _bloodType,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Tipo de sangre (opcional)',
          ),
          items: [
            const DropdownMenuItem(value: null, child: Text('Sin capturar')),
            for (final tipo in widget.tiposSangre)
              DropdownMenuItem(value: tipo.id, child: Text(tipo.name)),
          ],
          onChanged: _busy
              ? null
              : (value) => setState(() => _bloodType = value),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'Alergias (opcional)',
          controller: _allergies,
          enabled: !_busy,
        ),
      ],
    ),
  );
}
