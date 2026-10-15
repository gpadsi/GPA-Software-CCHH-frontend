import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_themes.dart';

/// Una elección explícita se mantiene aunque cambie la paleta.
enum AppFontChoice {
  themeDefault('Según el tema', null),
  manrope('Manrope', AppFonts.manrope),
  plusJakartaSans('Plus Jakarta Sans', AppFonts.plusJakartaSans),
  outfit('Outfit', AppFonts.outfit),
  fraunces('Fraunces', AppFonts.fraunces);

  const AppFontChoice(this.label, this.family);
  final String label;
  final String? family;

  Iterable<String> get fonts => family == null ? const [] : [family!];

  static AppFontChoice? byName(String? name) {
    for (final font in values) {
      if (font.name == name) return font;
    }
    return null;
  }
}

/// Familias locales; ninguna se pide a un servicio externo.
abstract final class AppFonts {
  static const manrope = 'Manrope';
  static const fraunces = 'Fraunces';
  static const plusJakartaSans = 'PlusJakartaSans';
  static const outfit = 'Outfit';

  /// Manrope viene declarada en pubspec y se carga con la app. Estas solo se
  /// descargan cuando alguien usa un tema que las pide; mientras llegan, el
  /// texto se dibuja con Manrope.
  static const _onDemand = {
    fraunces: 'lib/core/design_system/fonts/Fraunces.ttf',
    plusJakartaSans: 'lib/core/design_system/fonts/PlusJakartaSans.ttf',
    outfit: 'lib/core/design_system/fonts/Outfit.ttf',
  };
  static final _loads = <String, Future<void>>{};

  /// Si una familia no llega (red caída), el tema se aplica igual con Manrope
  /// y el siguiente intento la vuelve a pedir.
  static Future<void> ensureLoaded(Iterable<String> families) async {
    await Future.wait(families.toSet().map(_load));
  }

  static Future<void> _load(String family) {
    final asset = _onDemand[family];
    if (asset == null) return Future.value();
    return _loads[family] ??=
        (FontLoader(family)..addFont(rootBundle.load(asset))).load().catchError(
          (Object _) {
            _loads.remove(family);
          },
        );
  }
}

abstract final class AppTypography {
  static const regular = FontWeight.w400;
  static const medium = FontWeight.w500;
  static const semibold = FontWeight.w600;

  /// La misma escala en todos los temas; cambian la familia, el peso de los
  /// títulos y los colores.
  static TextTheme textTheme(
    AppThemeId theme, {
    AppFontChoice font = AppFontChoice.themeDefault,
  }) {
    final colors = theme.colors;
    TextStyle style(
      double size,
      double height,
      FontWeight weight, {
      bool heading = false,
      bool secondary = false,
      double letterSpacing = 0,
    }) => TextStyle(
      fontFamily: font.family ?? (heading ? theme.headingFont : theme.bodyFont),
      fontFamilyFallback: const [AppFonts.manrope],
      fontSize: size,
      height: height,
      fontWeight: weight,
      color: secondary ? colors.textSecondary : colors.text,
      letterSpacing: letterSpacing,
    );

    final title = theme.headingWeight;
    return TextTheme(
      displaySmall: style(36, 1.2, title, heading: true, letterSpacing: -1),
      headlineMedium: style(28, 1.3, title, heading: true, letterSpacing: -0.6),
      headlineSmall: style(24, 1.35, title, heading: true, letterSpacing: -0.4),
      titleLarge: style(20, 1.4, title, heading: true),
      titleMedium: style(16, 1.5, semibold),
      titleSmall: style(14, 1.5, semibold),
      bodyLarge: style(16, 1.6, regular),
      bodyMedium: style(14, 1.6, regular),
      bodySmall: style(12, 1.5, regular, secondary: true),
      labelLarge: style(14, 1.4, semibold),
      labelMedium: style(12, 1.4, medium, secondary: true),
      labelSmall: style(11, 1.4, medium, secondary: true),
    );
  }
}
