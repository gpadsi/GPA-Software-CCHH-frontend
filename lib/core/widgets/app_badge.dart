import 'package:flutter/material.dart';

import '../design_system/colors.dart';
import '../design_system/spacing.dart';

enum AppBadgeTone { neutral, success, warning, error }

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.tone = AppBadgeTone.neutral,
  });

  final String label;
  final AppBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final (foreground, background) = switch (tone) {
      AppBadgeTone.neutral => (AppColors.primary, AppColors.primarySurface),
      AppBadgeTone.success => (AppColors.success, AppColors.successSurface),
      AppBadgeTone.warning => (AppColors.warning, AppColors.warningSurface),
      AppBadgeTone.error => (AppColors.error, AppColors.errorSurface),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall
              ?.copyWith(color: foreground),
        ),
      ),
    );
  }
}
