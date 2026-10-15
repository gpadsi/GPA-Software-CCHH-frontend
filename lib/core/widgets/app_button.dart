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
    final foreground = switch (variant) {
      AppButtonVariant.primary => context.colors.onPrimary,
      AppButtonVariant.danger => context.colors.surface,
      _ => context.colors.primary,
    };
    final background = switch (variant) {
      AppButtonVariant.primary => context.colors.primary,
      AppButtonVariant.danger => context.colors.error,
      AppButtonVariant.secondary => context.colors.surface,
      AppButtonVariant.text => Colors.transparent,
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
              : context.colors.textSecondary,
          disabledBackgroundColor: isLoading
              ? background
              : context.colors.background,
          minimumSize: const Size(44, 44),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          animationDuration: AppMotion.duration(context, AppMotion.interaction),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.shape.button),
            side: variant == AppButtonVariant.secondary
                ? BorderSide(color: context.colors.border)
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
