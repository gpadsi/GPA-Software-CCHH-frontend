import 'package:flutter/material.dart';

/// Paleta de marca de Grupo GPA (confirmada 2026-09-25), familia de rojos:
/// #6E2B30 (principal oscuro), #7F353A (vino), #AA3D40 (medio),
/// #834B53 (grisáceo), #A85D64 (claro). `primary` y `accent` usan dos de
/// esos tonos directamente; los neutros (fondo/texto/bordes) se derivan de
/// la misma familia para que todo se sienta como una sola paleta, no rojos
/// sueltos sobre grises genéricos. El logo real lo reemplaza `brand.dart`.
abstract final class AppColors {
  static const primary = Color(0xFF6E2B30);
  // Vino oscuro (2026-09-25: antes #AA3D40 — se pidió explícitamente que
  // los rojos visibles (barra activa, líneas del organigrama) se vean más
  // oscuros/menos claros) — a propósito solo para detalles puntuales, nunca
  // fondos grandes, para no competir visualmente con `error`.
  static const accent = Color(0xFF7F353A);

  static const background = Color(0xFFF8F5F5);
  static const surface = Color(0xFFFFFFFF);
  static const text = Color(0xFF241A1C);
  static const textSecondary = Color(0xFF6B5458);
  static const border = Color(0xFFE8DEDF);
  static const primarySurface = Color(0xFFF4E8E9);

  static const success = Color(0xFF2C6E53);
  // Deliberadamente FUERA de la familia de rojos de marca (más hacia
  // naranja) — si error usara un rojo parecido a primary, un mensaje de
  // error se confundiría visualmente con un botón principal.
  static const error = Color(0xFFB3451F);
  static const warning = Color(0xFF846313);
  static const successSurface = Color(0xFFEDF6F0);
  static const errorSurface = Color(0xFFFBEEE8);
  static const warningSurface = Color(0xFFFBF5E5);
  static const transparent = Color(0x00000000);
}
