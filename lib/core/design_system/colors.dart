import 'package:flutter/material.dart';

import 'app_themes.dart';
import 'shape.dart';

/// Colores de un tema de la app. Cada usuario elige su tema (ver
/// `app_themes.dart`); las pantallas leen siempre los del tema activo con
/// `context.colors`, nunca un color fijo.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.text,
    required this.textSecondary,
    required this.border,
    required this.primarySurface,
    required this.onPrimarySurface,
    required this.success,
    required this.error,
    required this.warning,
    required this.successSurface,
    required this.errorSurface,
    required this.warningSurface,
    required this.header,
    required this.headerBorder,
    required this.tableHeader,
    required this.sidebar,
    required this.sidebarBorder,
    required this.sidebarText,
    required this.sidebarMuted,
    required this.sidebarSelected,
    required this.sidebarSelectedText,
    required this.sidebarDivider,
    this.sidebarIndicator,
    this.brandPlate,
  });

  /// Botones principales, foco de los campos y texto activo.
  final Color primary;
  final Color onPrimary;

  /// Indicador del menú seleccionado y trazos del organigrama.
  final Color accent;

  final Color background;
  final Color surface;
  final Color text;
  final Color textSecondary;
  final Color border;

  /// Fondo de lo seleccionado o resaltado (filas, chips, avatares) y el color
  /// del texto o icono que va encima.
  final Color primarySurface;
  final Color onPrimarySurface;

  final Color success;
  // El tono de error se distingue del color principal de cada tema.
  final Color error;
  final Color warning;
  final Color successSurface;
  final Color errorSurface;
  final Color warningSurface;

  /// Encabezado de cada página (título de la sección y menú de usuario).
  final Color header;
  final Color headerBorder;

  /// Fila de títulos de las tablas.
  final Color tableHeader;

  final Color sidebar;
  final Color sidebarBorder;
  final Color sidebarText;
  final Color sidebarMuted;
  final Color sidebarSelected;
  final Color sidebarSelectedText;
  final Color sidebarDivider;

  /// Barra delgada junto al destino seleccionado. Null si el tema distingue
  /// la selección solo con el fondo.
  final Color? sidebarIndicator;

  /// Placa clara detrás del logo cuando la barra lateral es oscura: el logo y
  /// el nombre de la app se ven igual en todos los temas. Null si la barra ya
  /// es clara.
  final Color? brandPlate;

  /// Fuera del tema de la app (un widget probado por separado) se usan los
  /// colores del tema predeterminado.
  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>() ?? AppThemeId.fallback.colors;

  @override
  AppColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? accent,
    Color? background,
    Color? surface,
    Color? text,
    Color? textSecondary,
    Color? border,
    Color? primarySurface,
    Color? onPrimarySurface,
    Color? success,
    Color? error,
    Color? warning,
    Color? successSurface,
    Color? errorSurface,
    Color? warningSurface,
    Color? header,
    Color? headerBorder,
    Color? tableHeader,
    Color? sidebar,
    Color? sidebarBorder,
    Color? sidebarText,
    Color? sidebarMuted,
    Color? sidebarSelected,
    Color? sidebarSelectedText,
    Color? sidebarDivider,
    Color? sidebarIndicator,
    Color? brandPlate,
  }) => AppColors(
    primary: primary ?? this.primary,
    onPrimary: onPrimary ?? this.onPrimary,
    accent: accent ?? this.accent,
    background: background ?? this.background,
    surface: surface ?? this.surface,
    text: text ?? this.text,
    textSecondary: textSecondary ?? this.textSecondary,
    border: border ?? this.border,
    primarySurface: primarySurface ?? this.primarySurface,
    onPrimarySurface: onPrimarySurface ?? this.onPrimarySurface,
    success: success ?? this.success,
    error: error ?? this.error,
    warning: warning ?? this.warning,
    successSurface: successSurface ?? this.successSurface,
    errorSurface: errorSurface ?? this.errorSurface,
    warningSurface: warningSurface ?? this.warningSurface,
    header: header ?? this.header,
    headerBorder: headerBorder ?? this.headerBorder,
    tableHeader: tableHeader ?? this.tableHeader,
    sidebar: sidebar ?? this.sidebar,
    sidebarBorder: sidebarBorder ?? this.sidebarBorder,
    sidebarText: sidebarText ?? this.sidebarText,
    sidebarMuted: sidebarMuted ?? this.sidebarMuted,
    sidebarSelected: sidebarSelected ?? this.sidebarSelected,
    sidebarSelectedText: sidebarSelectedText ?? this.sidebarSelectedText,
    sidebarDivider: sidebarDivider ?? this.sidebarDivider,
    sidebarIndicator: sidebarIndicator ?? this.sidebarIndicator,
    brandPlate: brandPlate ?? this.brandPlate,
  );

  /// Al cambiar de tema, MaterialApp interpola el anterior con el nuevo.
  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      primary: mix(primary, other.primary),
      onPrimary: mix(onPrimary, other.onPrimary),
      accent: mix(accent, other.accent),
      background: mix(background, other.background),
      surface: mix(surface, other.surface),
      text: mix(text, other.text),
      textSecondary: mix(textSecondary, other.textSecondary),
      border: mix(border, other.border),
      primarySurface: mix(primarySurface, other.primarySurface),
      onPrimarySurface: mix(onPrimarySurface, other.onPrimarySurface),
      success: mix(success, other.success),
      error: mix(error, other.error),
      warning: mix(warning, other.warning),
      successSurface: mix(successSurface, other.successSurface),
      errorSurface: mix(errorSurface, other.errorSurface),
      warningSurface: mix(warningSurface, other.warningSurface),
      header: mix(header, other.header),
      headerBorder: mix(headerBorder, other.headerBorder),
      tableHeader: mix(tableHeader, other.tableHeader),
      sidebar: mix(sidebar, other.sidebar),
      sidebarBorder: mix(sidebarBorder, other.sidebarBorder),
      sidebarText: mix(sidebarText, other.sidebarText),
      sidebarMuted: mix(sidebarMuted, other.sidebarMuted),
      sidebarSelected: mix(sidebarSelected, other.sidebarSelected),
      sidebarSelectedText: mix(sidebarSelectedText, other.sidebarSelectedText),
      sidebarDivider: mix(sidebarDivider, other.sidebarDivider),
      sidebarIndicator: t < 0.5 ? sidebarIndicator : other.sidebarIndicator,
      brandPlate: t < 0.5 ? brandPlate : other.brandPlate,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppColors get colors => AppColors.of(this);
  AppShape get shape => AppShape.of(this);
}
