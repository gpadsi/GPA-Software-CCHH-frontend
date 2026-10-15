import 'package:flutter/material.dart';

import 'app_themes.dart';
import 'motion.dart';
import 'spacing.dart';
import 'typography.dart';

abstract final class AppTheme {
  // Cada tema se construye una sola vez durante la ejecución de la app.
  static final _built = <(AppThemeId, AppFontChoice), ThemeData>{};

  static ThemeData of(
    AppThemeId id, {
    AppFontChoice font = AppFontChoice.themeDefault,
  }) => _built[(id, font)] ??= _build(id, font);

  static ThemeData _build(AppThemeId id, AppFontChoice font) {
    final colors = id.colors;
    final shape = id.shape;
    final textTheme = AppTypography.textTheme(id, font: font);
    final scheme = ColorScheme.fromSeed(
      seedColor: colors.primary,
      brightness: Brightness.light,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      secondary: colors.accent,
      surface: colors.surface,
      onSurface: colors.text,
      onSurfaceVariant: colors.textSecondary,
      error: colors.error,
      outline: colors.border,
      outlineVariant: colors.border,
      // Mantiene chips, diálogos y selectores dentro de la misma paleta.
      primaryContainer: colors.primarySurface,
      onPrimaryContainer: colors.onPrimarySurface,
      secondaryContainer: colors.primarySurface,
      onSecondaryContainer: colors.onPrimarySurface,
      surfaceContainerLowest: colors.surface,
      surfaceContainerLow: colors.surface,
      surfaceContainer: colors.surface,
      surfaceContainerHigh: colors.surface,
      surfaceContainerHighest: colors.primarySurface,
      inverseSurface: colors.text,
      onInverseSurface: colors.surface,
      // Sin el tinte de elevación de Material 3, que mancharía de color las
      // superficies elevadas (menús, listas desplegables).
      surfaceTint: Colors.transparent,
    );
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(shape.control),
      borderSide: BorderSide(color: colors.border),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      extensions: [colors, shape],
      fontFamily: font.family ?? id.bodyFont,
      fontFamilyFallback: const [AppFonts.manrope],
      textTheme: textTheme,
      scaffoldBackgroundColor: colors.background,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      dividerColor: colors.border,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.text,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
        errorBorder: border.copyWith(
          borderSide: BorderSide(color: colors.error),
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.md),
      ),
      // Filtros y opciones en chip: fondo de superficie con borde, y el
      // elegido con el tono suave del color principal.
      chipTheme: ChipThemeData(
        backgroundColor: colors.surface,
        selectedColor: colors.primarySurface,
        side: BorderSide(color: colors.border),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(shape.card),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colors.text,
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        textStyle: textTheme.bodySmall!.copyWith(color: colors.surface),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size.square(AppSpacing.touchTarget),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(shape.control),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: AppPageTransitionsBuilder(),
          TargetPlatform.iOS: AppPageTransitionsBuilder(),
          TargetPlatform.windows: AppPageTransitionsBuilder(),
          TargetPlatform.linux: AppPageTransitionsBuilder(),
          TargetPlatform.macOS: AppPageTransitionsBuilder(),
        },
      ),
    );
  }
}
