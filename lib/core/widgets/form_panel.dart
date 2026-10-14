import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../design_system/breakpoints.dart';
import '../design_system/colors.dart';
import '../design_system/motion.dart';
import '../design_system/spacing.dart';
import 'app_button.dart';

/// Contenedor de formularios con título, cuerpo desplazable y acciones fijas.
/// Por defecto se ancla a la derecha (escritorio) o abajo (móvil); [centered]
/// permite una ventana centrada para acciones breves. Se abre con `showAppPanel`.
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
    this.centered = false,
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

  /// Opt-in para acciones breves que se presentan como ventana centrada.
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final wide = size.width >= AppBreakpoints.mobile;
    final type = Theme.of(context).textTheme;
    final radius = Radius.circular(AppSpacing.radius + 4);
    final insets = MediaQuery.viewInsetsOf(context).bottom;

    // Las ventanas centradas aparecen con fundido y una escala breve.
    // Se desliza el panel lateral y no la pantalla completa: el desplazamiento es
    // relativo a su propio ancho (o alto en móvil), así asoma desde el primer
    // fotograma de la animación de `showAppPanel`. El `RepaintBoundary` hace
    // que en cada fotograma solo se mueva la capa ya pintada del panel, sin
    // volver a pintar su contenido.
    final animation = ModalRoute.of(context)?.animation;
    Widget slide(Widget child) =>
        animation == null || MediaQuery.disableAnimationsOf(context)
        ? child
        : centered
        ? FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation
                  .drive(CurveTween(curve: AppMotion.curve))
                  .drive(Tween<double>(begin: 0.985, end: 1)),
              child: child,
            ),
          )
        : SlideTransition(
            position: animation
                .drive(CurveTween(curve: AppMotion.curve))
                .drive(
                  Tween<Offset>(
                    begin: wide ? const Offset(1, 0) : const Offset(0, 1),
                    end: Offset.zero,
                  ),
                ),
            child: RepaintBoundary(child: child),
          );

    return PopScope(
      canPop: !busy,
      child: Align(
        alignment: centered
            ? Alignment.center
            : wide
            ? Alignment.centerRight
            : Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            centered ? 16 : 0,
            centered ? 24 : 0,
            centered ? 16 : 0,
            insets + (centered ? 24 : 0),
          ),
          child: slide(
            Material(
              color: AppColors.surface,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: centered
                    ? BorderRadius.all(radius)
                    : wide
                    ? BorderRadius.horizontal(left: radius)
                    : BorderRadius.vertical(top: radius),
                side: const BorderSide(color: AppColors.border),
              ),
              child: SizedBox(
                width: centered
                    ? math.min(width, size.width - 32)
                    : wide
                    ? math.min(width, size.width)
                    : double.infinity,
                height: centered
                    ? math.min(640, math.max(0, size.height - insets - 48))
                    : wide
                    ? double.infinity
                    : size.height * 0.92,
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
                              padding: const EdgeInsets.only(
                                top: AppSpacing.sm,
                              ),
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
                        border: Border(
                          top: BorderSide(color: AppColors.border),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (error != null) ...[
                            Semantics(
                              liveRegion: true,
                              child: Container(
                                padding: const EdgeInsets.all(
                                  AppSpacing.sm + 4,
                                ),
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
      ),
    );
  }
}
