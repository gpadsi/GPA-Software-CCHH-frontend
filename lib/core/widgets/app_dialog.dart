import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../design_system/breakpoints.dart';
import '../design_system/colors.dart';
import '../design_system/spacing.dart';

/// Anchos de las ventanas de la app. Uno por clase de contenido, en lugar de
/// que cada ventana elija su número.
enum AppDialogSize {
  /// Confirmaciones y altas de un par de campos.
  small(480),

  /// La mayoría de los formularios: una columna.
  medium(600),

  /// Formularios con muchos campos: dos columnas (ver `AppFieldGrid`).
  wide(880);

  const AppDialogSize(this.width);
  final double width;
}

/// La superficie de toda ventana de la app: centrada, con el borde, la
/// esquina y la sombra del tema activo. Mide lo que su contenido, hasta el
/// alto de la pantalla. Con [fullScreen] ocupa toda la pantalla (los
/// formularios en un teléfono, donde una ventana con márgenes no deja sitio).
class AppDialogSurface extends StatelessWidget {
  const AppDialogSurface({
    super.key,
    required this.width,
    required this.child,
    this.fullScreen = false,
  });

  final double width;
  final Widget child;
  final bool fullScreen;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final insets = MediaQuery.viewInsetsOf(context).bottom;
    if (fullScreen) {
      return Padding(
        padding: EdgeInsets.only(bottom: insets),
        child: Material(
          color: context.colors.surface,
          child: SafeArea(child: child),
        ),
      );
    }
    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg + insets,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: math.max(0, size.height - insets - AppSpacing.xxl),
          ),
          child: SizedBox(
            width: math.max(0, math.min(width, size.width - AppSpacing.xl)),
            child: Material(
              color: context.colors.surface,
              elevation: 12,
              shadowColor: context.colors.text.withValues(alpha: 0.3),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.shape.card + 4),
                side: BorderSide(color: context.colors.border),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Ventana con encabezado (título, subtítulo y cerrar), cuerpo desplazable y
/// pie fijo con el error y las acciones. Es el marco de los formularios
/// (`AppFormDialog`) y de cualquier otra ventana con contenido propio
/// (Apariencia); las confirmaciones usan la misma superficie en versión
/// compacta (`showConfirmDialog`).
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.child,
    required this.actions,
    this.subtitle,
    this.error,
    this.size = AppDialogSize.medium,
    this.minBodyHeight,
    this.onClose,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  /// Botones del pie, alineados a la derecha (el principal al final).
  final List<Widget> actions;

  /// Mensaje del servidor o de validación, arriba de los botones.
  final String? error;
  final AppDialogSize size;

  /// Alto mínimo del cuerpo. Lo usan las ventanas cuyo campo principal abre
  /// una lista de sugerencias (280 px), para que la lista quepa dentro y no
  /// tape los botones del pie.
  final double? minBodyHeight;

  /// Lo que hace la X; null la deshabilita (ej. mientras se guarda).
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final type = Theme.of(context).textTheme;
    final border = BorderSide(color: context.colors.border);
    final phone = MediaQuery.sizeOf(context).width < AppBreakpoints.mobile;
    return AppDialogSurface(
      width: size.width,
      fullScreen: phone,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
            ),
            decoration: BoxDecoration(border: Border(bottom: border)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Semantics(
                          header: true,
                          child: Text(title, style: type.titleLarge),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(subtitle!, style: type.bodySmall),
                        ],
                      ],
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Cerrar',
                  onPressed: onClose,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Flexible(
            // A pantalla completa el cuerpo llena el alto y el pie queda abajo.
            fit: phone ? FlexFit.tight : FlexFit.loose,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: minBodyHeight ?? 0),
              child: Scrollbar(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: child,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(border: Border(top: border)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (error != null) ...[
                  AppDialogError(error!),
                  const SizedBox(height: AppSpacing.md),
                ],
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: actions,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// El aviso de error de una ventana: se anuncia al lector de pantalla en
/// cuanto aparece.
class AppDialogError extends StatelessWidget {
  const AppDialogError(this.message, {super.key});
  final String message;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm + 4),
      decoration: BoxDecoration(
        color: context.colors.errorSurface,
        borderRadius: BorderRadius.circular(AppSpacing.controlRadius),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: context.colors.error),
      ),
    ),
  );
}
