import 'package:flutter/material.dart';

import 'colors.dart';
import 'shape.dart';
import 'typography.dart';

/// Los temas que cada usuario puede elegir en Apariencia. Todos son claros;
/// [fallback] es el de quien todavía no ha elegido. Los contrastes de texto
/// sobre su fondo son de al menos 4.5:1.
enum AppThemeId {
  grafito(
    label: 'Grafito GPA',
    description: 'Barra lateral oscura y el rojo de GPA en las acciones.',
    colors: _grafito,
    shape: AppShape(
      control: 8,
      button: 8,
      card: 12,
      cardShadow: [
        BoxShadow(
          color: Color(0x0F101828),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    ),
    bodyFont: AppFonts.manrope,
    headingFont: AppFonts.manrope,
    headingWeight: FontWeight.w700,
  ),
  vino(
    label: 'Vino elegante',
    description: 'Neutros cálidos, acentos vino y títulos con serifa.',
    colors: _vino,
    shape: AppShape(
      control: 8,
      button: 8,
      card: 14,
      cardShadow: [
        BoxShadow(
          color: Color(0x0D1C1917),
          blurRadius: 3,
          offset: Offset(0, 1),
        ),
      ],
    ),
    bodyFont: AppFonts.manrope,
    headingFont: AppFonts.fraunces,
    headingWeight: FontWeight.w600,
  ),
  petroleo(
    label: 'Petróleo sereno',
    description: 'Azul petróleo tranquilo y esquinas más redondas.',
    colors: _petroleo,
    shape: AppShape(
      control: 10,
      button: 10,
      card: 16,
      cardShadow: [
        BoxShadow(
          color: Color(0x0D0F1E21),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    bodyFont: AppFonts.plusJakartaSans,
    headingFont: AppFonts.plusJakartaSans,
    headingWeight: FontWeight.w700,
  ),
  rojo(
    label: 'Rojo GPA audaz',
    description: 'Barra lateral roja, botones negros en forma de píldora.',
    colors: _rojo,
    shape: AppShape(
      control: 12,
      button: 999,
      card: 18,
      cardShadow: [
        BoxShadow(
          color: Color(0x0F1A1415),
          blurRadius: 14,
          offset: Offset(0, 4),
        ),
      ],
    ),
    bodyFont: AppFonts.outfit,
    headingFont: AppFonts.outfit,
    headingWeight: FontWeight.w700,
  );

  const AppThemeId({
    required this.label,
    required this.description,
    required this.colors,
    required this.shape,
    required this.bodyFont,
    required this.headingFont,
    required this.headingWeight,
  });

  final String label;
  final String description;
  final AppColors colors;
  final AppShape shape;
  final String bodyFont;

  /// Títulos de página, de tarjeta grande y de diálogo.
  final String headingFont;
  final FontWeight headingWeight;

  Set<String> get fonts => {bodyFont, headingFont};

  static const fallback = grafito;

  /// Null si el nombre guardado ya no corresponde a ningún tema.
  static AppThemeId? byName(String? name) =>
      name == null ? null : values.asNameMap()[name];
}

const _grafito = AppColors(
  primary: Color(0xFFA3262A),
  onPrimary: Color(0xFFFFFFFF),
  accent: Color(0xFFD63C42),
  background: Color(0xFFF3F4F6),
  surface: Color(0xFFFFFFFF),
  text: Color(0xFF15171A),
  textSecondary: Color(0xFF5B6270),
  border: Color(0xFFE4E6EA),
  primarySurface: Color(0xFFF7E8E9),
  onPrimarySurface: Color(0xFF8A1F23),
  success: Color(0xFF166534),
  error: Color(0xFFB42318),
  warning: Color(0xFF8A5300),
  successSurface: Color(0xFFDCFCE7),
  errorSurface: Color(0xFFFEE4E2),
  warningSurface: Color(0xFFFEF3C7),
  header: Color(0xFFFFFFFF),
  headerBorder: Color(0xFFE4E6EA),
  tableHeader: Color(0xFFF8F9FA),
  sidebar: Color(0xFF1B1E22),
  sidebarBorder: Color(0xFF1B1E22),
  sidebarText: Color(0xFFC3C8CF),
  sidebarMuted: Color(0xFF858C96),
  sidebarSelected: Color(0xFF2C3138),
  sidebarSelectedText: Color(0xFFFFFFFF),
  sidebarDivider: Color(0xFF2E3339),
  sidebarIndicator: Color(0xFFE5484D),
  brandPlate: Color(0xFFFFFFFF),
);

const _vino = AppColors(
  primary: Color(0xFF7B1E2B),
  onPrimary: Color(0xFFFFFFFF),
  accent: Color(0xFF7B1E2B),
  background: Color(0xFFFAF9F7),
  surface: Color(0xFFFFFFFF),
  text: Color(0xFF1C1917),
  textSecondary: Color(0xFF6B6460),
  border: Color(0xFFE9E4DF),
  primarySurface: Color(0xFFF6EBED),
  onPrimarySurface: Color(0xFF7B1E2B),
  success: Color(0xFF2F6B4F),
  error: Color(0xFFB3261E),
  warning: Color(0xFF8A5A00),
  successSurface: Color(0xFFE3F1E9),
  errorSurface: Color(0xFFFCE8E6),
  warningSurface: Color(0xFFFBF0D9),
  header: Color(0xFFFAF9F7),
  headerBorder: Color(0xFFFAF9F7),
  tableHeader: Color(0xFFFCFBFA),
  sidebar: Color(0xFFFFFFFF),
  sidebarBorder: Color(0xFFE9E4DF),
  sidebarText: Color(0xFF44403C),
  sidebarMuted: Color(0xFF77706A),
  sidebarSelected: Color(0xFFF6EBED),
  sidebarSelectedText: Color(0xFF7B1E2B),
  sidebarDivider: Color(0xFFE9E4DF),
  sidebarIndicator: Color(0xFF7B1E2B),
);

const _petroleo = AppColors(
  primary: Color(0xFF0B5563),
  onPrimary: Color(0xFFFFFFFF),
  accent: Color(0xFF0B5563),
  background: Color(0xFFF2F6F6),
  surface: Color(0xFFFFFFFF),
  text: Color(0xFF0F1E21),
  textSecondary: Color(0xFF4F6366),
  border: Color(0xFFDCE6E6),
  primarySurface: Color(0xFFE0EFF0),
  onPrimarySurface: Color(0xFF0B5563),
  success: Color(0xFF136B43),
  error: Color(0xFFB42318),
  warning: Color(0xFF8A5300),
  successSurface: Color(0xFFDDF4E7),
  errorSurface: Color(0xFFFDE6E3),
  warningSurface: Color(0xFFFDF0D5),
  header: Color(0xFFFFFFFF),
  headerBorder: Color(0xFFDCE6E6),
  tableHeader: Color(0xFFF7FAFA),
  sidebar: Color(0xFFE6EFEF),
  sidebarBorder: Color(0xFFD6E3E3),
  sidebarText: Color(0xFF2D4447),
  sidebarMuted: Color(0xFF5A6F72),
  sidebarSelected: Color(0xFFFFFFFF),
  sidebarSelectedText: Color(0xFF0B5563),
  sidebarDivider: Color(0xFFD0DEDE),
);

const _rojo = AppColors(
  primary: Color(0xFF1F1A1B),
  onPrimary: Color(0xFFFFFFFF),
  accent: Color(0xFF9B1F27),
  background: Color(0xFFF6F3F2),
  surface: Color(0xFFFFFFFF),
  text: Color(0xFF1A1415),
  textSecondary: Color(0xFF6E6264),
  border: Color(0xFFECE5E3),
  primarySurface: Color(0xFFFBE7E8),
  onPrimarySurface: Color(0xFF9B1F27),
  success: Color(0xFF166534),
  error: Color(0xFFB42318),
  warning: Color(0xFF8A5300),
  successSurface: Color(0xFFDCFCE7),
  errorSurface: Color(0xFFFEE4E2),
  warningSurface: Color(0xFFFEF3C7),
  header: Color(0xFFF6F3F2),
  headerBorder: Color(0xFFF6F3F2),
  tableHeader: Color(0xFFFFFFFF),
  sidebar: Color(0xFF7F1D24),
  sidebarBorder: Color(0xFF7F1D24),
  sidebarText: Color(0xFFF6DDDF),
  sidebarMuted: Color(0xFFE3AFB3),
  sidebarSelected: Color(0xFFFFFFFF),
  sidebarSelectedText: Color(0xFF7F1D24),
  sidebarDivider: Color(0xFF96333A),
  brandPlate: Color(0xFFFFFFFF),
);
