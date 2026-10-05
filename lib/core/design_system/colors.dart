import 'package:flutter/material.dart';

/// Paleta de marca de Grupo GPA.
///
/// Rediseño de paleta con tonos vino más profundos. El tema se mantiene
/// claro y centraliza aquí los colores de fondo, superficies, texto y estado.
abstract final class AppColors {
  static const primary = Color(0xFF5A1E24);
  // Color secundario para acentos y detalles de navegación.
  static const accent = Color(0xFF6E2B30);

  static const background = Color(0xFFE9DFE0);
  static const surface = Color(0xFFF6F0F1);
  static const text = Color(0xFF1F1214);
  static const textSecondary = Color(0xFF5A4549);
  static const border = Color(0xFFCDB9BC);
  static const primarySurface = Color(0xFFDFC8CB);

  static const success = Color(0xFF1F5A42);
  // El tono de error se distingue del vino principal.
  static const error = Color(0xFF9C3A17);
  static const warning = Color(0xFF6F520F);
  static const successSurface = Color(0xFFD5E6DC);
  static const errorSurface = Color(0xFFEFD3C6);
  static const warningSurface = Color(0xFFEBDFB8);
  static const transparent = Color(0x00000000);
}
