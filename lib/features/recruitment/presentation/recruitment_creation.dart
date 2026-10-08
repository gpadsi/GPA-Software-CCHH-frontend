import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_overlays.dart';
import '../application/recruitment_controller.dart';
import '../data/recruitment_models.dart';
import 'nuevo_descriptivo_form.dart';
import 'requisicion_form.dart';

Future<void> abrirNuevaRequisicion(
  BuildContext context,
  WidgetRef ref, {
  String? posicionId,
}) async {
  final saved = await showAppPanel<Requisicion>(
    context: context,
    builder: (_) => RequisicionForm(posicionId: posicionId),
  );
  if (saved != null && context.mounted) {
    ref.invalidate(requisicionesPageProvider);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Requisición creada.')));
    context.go('/reclutamiento/requisiciones/${saved.id}');
  }
}

Future<void> abrirNuevoDescriptivo(
  BuildContext context,
  WidgetRef ref, {
  String? posicionId,
}) async {
  final creado = await showAppPanel<Descriptivo>(
    context: context,
    builder: (_) => NuevoDescriptivoForm(posicionId: posicionId),
  );
  if (creado != null && context.mounted) {
    ref.invalidate(descriptivosPageProvider);
    context.go('/reclutamiento/descriptivos/${creado.id}');
  }
}
