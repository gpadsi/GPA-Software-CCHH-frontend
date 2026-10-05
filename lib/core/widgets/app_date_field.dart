import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../design_system/spacing.dart';

final _display = DateFormat.yMMMd('es_MX');

/// Campo de fecha de los formularios: se ve como los demás campos y abre el
/// selector de fecha al tocarlo. [onChanged] avisa cada cambio (la pantalla
/// guarda su propio valor, igual que con los campos de texto); si no es
/// [isRequired] trae un botón para quitar la fecha.
class AppDateField extends FormField<DateTime> {
  AppDateField({
    super.key,
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime?> onChanged,
    bool isRequired = false,
    super.enabled,
    DateTime? firstDate,
    DateTime? lastDate,
  }) : super(
         initialValue: value,
         validator: (date) =>
             isRequired && date == null ? 'Elige una fecha.' : null,
         builder: (field) {
           final context = field.context;
           void change(DateTime? date) {
             field.didChange(date);
             onChanged(date);
           }

           Future<void> pick() async {
             final picked = await showDatePicker(
               context: context,
               initialDate: field.value ?? DateTime.now(),
               firstDate: firstDate ?? DateTime(2000),
               lastDate: lastDate ?? DateTime(2100),
             );
             if (picked != null) change(picked);
           }

           final date = field.value;
           return Semantics(
             button: true,
             label: label,
             child: InkWell(
               borderRadius: BorderRadius.circular(AppSpacing.controlRadius),
               onTap: enabled ? pick : null,
               child: InputDecorator(
                 isEmpty: date == null,
                 decoration: InputDecoration(
                   labelText: label,
                   errorText: field.errorText,
                   suffixIcon: Row(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       if (date != null && !isRequired && enabled)
                         IconButton(
                           tooltip: 'Quitar $label',
                           onPressed: () => change(null),
                           icon: const Icon(Icons.close, size: 18),
                         ),
                       const Padding(
                         padding: EdgeInsets.only(right: AppSpacing.md),
                         child: Icon(Icons.calendar_today_outlined, size: 18),
                       ),
                     ],
                   ),
                 ),
                 child: Text(
                   date == null ? '' : _display.format(date),
                   style: Theme.of(context).textTheme.bodyMedium,
                 ),
               ),
             ),
           );
         },
       );
}
