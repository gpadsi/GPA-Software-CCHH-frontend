import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'app_themes.dart';

/// Esquinas y sombra de un tema: cada uno tiene su carácter (más recto, más
/// redondo, botones en forma de píldora).
@immutable
class AppShape extends ThemeExtension<AppShape> {
  const AppShape({
    required this.control,
    required this.button,
    required this.card,
    required this.cardShadow,
  });

  /// Campos de captura, chips y cajas pequeñas.
  final double control;
  final double button;

  /// Tarjetas, tablas, diálogos y paneles.
  final double card;
  final List<BoxShadow> cardShadow;

  static AppShape of(BuildContext context) =>
      Theme.of(context).extension<AppShape>() ?? AppThemeId.fallback.shape;

  @override
  AppShape copyWith({
    double? control,
    double? button,
    double? card,
    List<BoxShadow>? cardShadow,
  }) => AppShape(
    control: control ?? this.control,
    button: button ?? this.button,
    card: card ?? this.card,
    cardShadow: cardShadow ?? this.cardShadow,
  );

  @override
  AppShape lerp(AppShape? other, double t) {
    if (other == null) return this;
    return AppShape(
      control: lerpDouble(control, other.control, t)!,
      button: lerpDouble(button, other.button, t)!,
      card: lerpDouble(card, other.card, t)!,
      cardShadow: BoxShadow.lerpList(cardShadow, other.cardShadow, t)!,
    );
  }
}
