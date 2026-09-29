import 'package:flutter/material.dart';

import '../design_system/colors.dart';
import '../design_system/motion.dart';
import '../design_system/spacing.dart';

enum AppButtonVariant { primary, secondary, text, danger }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final filled =
        variant == AppButtonVariant.primary ||
        variant == AppButtonVariant.danger;
    final foreground = filled ? AppColors.surface : AppColors.primary;
    final background = switch (variant) {
      AppButtonVariant.primary => AppColors.primary,
      AppButtonVariant.danger => AppColors.error,
      AppButtonVariant.secondary => AppColors.surface,
      AppButtonVariant.text => AppColors.transparent,
    };

    return Semantics(
      liveRegion: isLoading,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: foreground,
          backgroundColor: background,
          disabledForegroundColor: isLoading
              ? foreground
              : AppColors.textSecondary,
          disabledBackgroundColor: isLoading
              ? background
              : AppColors.background,
          minimumSize: const Size(44, 44),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          animationDuration: AppMotion.duration(context, AppMotion.interaction),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: variant == AppButtonVariant.secondary
                ? const BorderSide(color: AppColors.border)
                : BorderSide.none,
          ),
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading || icon != null) ...[
              AnimatedSwitcher(
                duration: AppMotion.duration(context, AppMotion.interaction),
                switchInCurve: AppMotion.curve,
                switchOutCurve: AppMotion.curve,
                child: isLoading
                    ? SizedBox.square(
                        key: const ValueKey('loading'),
                        dimension: 18,
                        child: MediaQuery.disableAnimationsOf(context)
                            ? Icon(
                                Icons.hourglass_empty_rounded,
                                size: 18,
                                color: foreground,
                              )
                            : CircularProgressIndicator(
                                strokeWidth: 2,
                                color: foreground,
                                semanticsLabel: 'Procesando',
                              ),
                      )
                    : Icon(icon, key: const ValueKey('icon'), size: 18),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Flexible(child: Text(label, textAlign: TextAlign.center)),
          ],
        ),
      ),
    );
  }
}
