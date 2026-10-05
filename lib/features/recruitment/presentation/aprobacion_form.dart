import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_date_field.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/form_panel.dart';
import '../application/recruitment_controller.dart';
import '../data/recruitment_models.dart';
import '../data/recruitment_repository.dart';
import 'recruitment_ui.dart';

/// Registra (o corrige) una de las firmas de aprobación de una requisición.
/// Capital Humano captura cada firma, digital o física: se dice QUIÉN firmó,
/// o con la casilla «la firmo yo» (firmó dentro del sistema) o con el nombre
/// de quien firmó en papel.
class AprobacionForm extends ConsumerStatefulWidget {
  const AprobacionForm({
    super.key,
    required this.requisicionId,
    required this.etapa,
    this.aprobacion,
  });

  final String requisicionId;
  final RecruitmentCatalogEntry etapa;
  final Aprobacion? aprobacion;

  @override
  ConsumerState<AprobacionForm> createState() => _AprobacionFormState();
}

class _AprobacionFormState extends ConsumerState<AprobacionForm> {
  final _form = GlobalKey<FormState>();
  late DateTime? _fecha =
      parseIsoDate(widget.aprobacion?.fecha) ?? DateTime.now();
  late bool _firmoYo =
      widget.aprobacion?.usuario != null &&
      widget.aprobacion!.usuario ==
          ref.read(sessionControllerProvider).user?.id;
  late final _nombre = TextEditingController(
    text: widget.aprobacion?.nombreManual,
  );
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _nombre.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final current = widget.aprobacion;
    try {
      await ref
          .read(recruitmentRepositoryProvider)
          .saveAprobacion(
            Aprobacion(
              id: current?.id ?? '',
              requisicion: widget.requisicionId,
              etapa: widget.etapa.id,
              fecha: toIsoDate(_fecha!),
              usuario: _firmoYo
                  ? ref.read(sessionControllerProvider).user?.id
                  : null,
              nombreManual: _firmoYo ? '' : _nombre.text,
            ),
            creating: current == null,
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
  Widget build(BuildContext context) => AppFormPanel(
    title: 'Aprobación: ${widget.etapa.name}',
    busy: _busy,
    error: _error,
    onSave: _save,
    child: Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppDateField(
            label: 'Fecha de aprobación',
            value: _fecha,
            isRequired: true,
            enabled: !_busy,
            onChanged: (value) => _fecha = value,
          ),
          const SizedBox(height: AppSpacing.md),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('La aprobé yo, dentro del sistema'),
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
              label: 'Nombre de quien aprobó',
              controller: _nombre,
              enabled: !_busy,
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return 'Escribe quién aprobó.';
                if (text.length > 150) return 'Usa como máximo 150 caracteres.';
                return null;
              },
            ),
          ],
        ],
      ),
    ),
  );
}
