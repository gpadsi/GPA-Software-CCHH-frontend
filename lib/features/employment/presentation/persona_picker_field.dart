import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/search_picker_field.dart';
import '../application/employment_controller.dart';
import '../data/employment_models.dart';

/// Selector de Persona que busca en el servidor mientras se escribe (hay más
/// de 500 personas). La búsqueda y el debounce los hace [SearchPickerField].
class PersonaPickerField extends ConsumerWidget {
  const PersonaPickerField({
    super.key,
    required this.onChanged,
    this.errorText,
    this.enabled = true,
    this.debounce = const Duration(milliseconds: 300),
  });

  /// La persona elegida, o null cuando el texto ya no corresponde a ninguna.
  final ValueChanged<PersonSummary?> onChanged;
  final String? errorText;
  final bool enabled;
  final Duration debounce;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      SearchPickerField<PersonSummary>(
        label: 'Persona',
        hint: 'Escribe nombre, CURP, correo o teléfono',
        search: (text) =>
            ref.read(employmentRepositoryProvider).searchPersonas(text),
        labelOf: (persona) => persona.fullName,
        detailOf: (persona) => [
          persona.personalEmail,
          persona.phone,
        ].where((text) => text.isNotEmpty).join(' · '),
        onChanged: onChanged,
        errorText: errorText,
        enabled: enabled,
        debounce: debounce,
      );
}
