import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/colors.dart';
import '../application/schedules_controller.dart';

// Selector filtrable de Empleado, compartido entre los formularios de
// Asignación de horario y de ubicación — hay 580+ Empleados, un dropdown
// plano sería visiblemente lento al abrir (misma razón que el selector de
// "Reporta a" en Posiciones, Fase 4). Se identifica por número de nómina
// porque es el único dato de Empleado disponible sin encadenar una segunda
// consulta a Persona por cada uno de los 580+ registros.
class EmpleadoPickerField extends ConsumerWidget {
  const EmpleadoPickerField({
    super.key,
    required this.selected,
    required this.enabled,
    required this.onChanged,
  });
  final String? selected;
  final bool enabled;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(allEmpleadosForPickerProvider)
      .when(
        data: (empleados) => FormField<String>(
          initialValue: selected,
          validator: (value) => value == null ? 'Elige un empleado.' : null,
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownMenu<String>(
                enabled: enabled,
                enableFilter: true,
                requestFocusOnTap: true,
                expandedInsets: EdgeInsets.zero,
                initialSelection: selected,
                label: const Text('Empleado'),
                hintText: 'Buscar por número de nómina',
                dropdownMenuEntries: [
                  for (final item in empleados)
                    DropdownMenuEntry(
                      value: item.id,
                      label: item.workNumber ?? 'Sin número de nómina',
                    ),
                ],
                onSelected: (value) {
                  field.didChange(value);
                  onChanged(value);
                },
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 12),
                  child: Text(
                    field.errorText!,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: AppColors.error),
                  ),
                ),
            ],
          ),
        ),
        loading: () => const DropdownMenu<String>(
          enabled: false,
          expandedInsets: EdgeInsets.zero,
          label: Text('Empleado'),
          hintText: 'Cargando empleados…',
          dropdownMenuEntries: [],
        ),
        error: (error, _) => Row(
          children: [
            const Expanded(
              child: Text(
                'No se pudo cargar la lista de empleados.',
                style: TextStyle(color: AppColors.error),
              ),
            ),
            TextButton(
              onPressed: () => ref.invalidate(allEmpleadosForPickerProvider),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
}
