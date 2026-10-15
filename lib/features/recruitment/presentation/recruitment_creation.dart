import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_overlays.dart';
import '../application/recruitment_controller.dart';
import '../data/recruitment_models.dart';
import 'nuevo_descriptivo_form.dart';

Future<void> abrirNuevaRequisicion(
  BuildContext context,
  WidgetRef ref, {
  String? posicionId,
}) async {
  await context.push<void>(
    Uri(
      path: '/reclutamiento/requisiciones/nueva',
      queryParameters: posicionId == null ? null : {'posicion': posicionId},
    ).toString(),
  );
}

Future<void> abrirNuevoDescriptivo(
  BuildContext context,
  WidgetRef ref, {
  String? posicionId,
}) async {
  final creado = await showAppDialog<Descriptivo>(
    context: context,
    builder: (_) => NuevoDescriptivoForm(posicionId: posicionId),
  );
  if (creado != null && context.mounted) {
    ref.invalidate(descriptivosPageProvider);
    context.go('/reclutamiento/descriptivos/${creado.id}');
  }
}
