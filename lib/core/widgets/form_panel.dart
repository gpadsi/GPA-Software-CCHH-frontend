import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../design_system/breakpoints.dart';
import '../design_system/colors.dart';
import '../design_system/spacing.dart';
import 'app_button.dart';

/// Contenedor único de los formularios de alta y edición: un panel que se
/// ancla a la derecha (pantallas anchas) o sube desde abajo (móvil), con el
/// título arriba, el cuerpo con su propio scroll y los botones SIEMPRE a la
/// vista abajo. Se abre con `showAppPanel`.
///
/// Reemplaza a los 8 formularios que cada uno armaba su propio `Dialog` con
/// el mismo título, `SingleChildScrollView`, texto de error y par de botones
/// copiados. Los formularios solo aportan su cuerpo y qué hacer al guardar;
/// este widget pone el marco, el estado de carga y el mensaje de error.
class AppFormPanel extends StatelessWidget {
  const AppFormPanel({
    super.key,
    required this.title,
    required this.child,
    required this.onSave,
    this.subtitle,
    this.busy = false,
    this.error,
    this.saveLabel = 'Guardar',
    this.canSave = true,
    this.width = 520,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final VoidCallback onSave;

  /// Guardando: bloquea cerrar y muestra el progreso en el botón.
  final bool busy;
  final String? error;
  final String saveLabel;

  /// false mientras el cuerpo todavía no puede guardarse (ej. catálogos sin
  /// cargar).
  final bool canSave;

  /// Ancho máximo en pantallas anchas.
  final double width;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final wide = size.width >= AppBreakpoints.mobile;
    final type = Theme.of(context).textTheme;
    final radius = Radius.circular(AppSpacing.radius + 4);
    final insets = MediaQuery.viewInsetsOf(context).bottom;

    return PopScope(
      canPop: !busy,
      child: Align(
        alignment: wide ? Alignment.centerRight : Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: insets),
          child: Material(
            color: AppColors.surface,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: wide
                  ? BorderRadius.horizontal(left: radius)
                  : BorderRadius.vertical(top: radius),
              side: const BorderSide(color: AppColors.border),
            ),
            child: SizedBox(
              width: wide ? math.min(width, size.width) : double.infinity,
              height: wide ? double.infinity : size.height * 0.92,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.sm),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title, style: type.titleLarge),
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
                          onPressed: busy
                              ? null
                              : () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: child,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      border: Border(top: BorderSide(color: AppColors.border)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (error != null) ...[
                          Semantics(
                            liveRegion: true,
                            child: Container(
                              padding: const EdgeInsets.all(AppSpacing.sm + 4),
                              decoration: BoxDecoration(
                                color: AppColors.errorSurface,
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.controlRadius,
                                ),
                              ),
                              child: Text(
                                error!,
                                style: type.bodySmall?.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                        Wrap(
                          alignment: WrapAlignment.end,
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: [
                            AppButton(
                              label: 'Cancelar',
                              variant: AppButtonVariant.secondary,
                              onPressed: busy
                                  ? null
                                  : () => Navigator.of(context).pop(),
                            ),
                            AppButton(
                              label: saveLabel,
                              isLoading: busy,
                              onPressed: canSave ? onSave : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
