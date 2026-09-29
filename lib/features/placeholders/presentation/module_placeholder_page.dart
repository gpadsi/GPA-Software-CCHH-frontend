import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system/breakpoints.dart';
import '../../../core/design_system/colors.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/navigation.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';

class ModulePlaceholderPage extends StatelessWidget {
  const ModulePlaceholderPage({super.key, required this.destination});
  final AppDestination destination;

  List<AppDestination> get _siblings {
    final path = destination.path;
    final prefix = path.startsWith('/organizacion/')
        ? '/organizacion/'
        : path.startsWith('/ubicaciones')
        ? '/ubicaciones'
        : path.startsWith('/posiciones')
        ? '/posiciones'
        : path.startsWith('/horarios/')
        ? '/horarios/'
        : null;
    return prefix == null
        ? []
        : appDestinations
              .where((item) => item.path.startsWith(prefix))
              .toList();
  }

  @override
  Widget build(BuildContext context) {
    final type = Theme.of(context).textTheme;
    final strings = AppLocalizations.of(context);
    final mobile = MediaQuery.sizeOf(context).width < AppBreakpoints.mobile;
    final siblings = _siblings;
    return SingleChildScrollView(
      key: PageStorageKey(destination.path),
      padding: EdgeInsets.all(mobile ? AppSpacing.md : AppSpacing.xl),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.contentMaxWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(destination.label, style: type.headlineMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                destination.description,
                style: type.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
              if (siblings.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final item in siblings)
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: AppButton(
                            label: item.label,
                            variant: item.path == destination.path
                                ? AppButtonVariant.primary
                                : AppButtonVariant.text,
                            onPressed: () => context.go(item.path),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                padding: EdgeInsets.symmetric(
                  horizontal: mobile ? AppSpacing.md : AppSpacing.xl,
                  vertical: AppSpacing.xxl,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: EmptyState(
                    icon: destination.icon,
                    title: strings.comingSoonTitle,
                    message: strings.comingSoonMessage,
                    action: AppButton(
                      label: 'Volver al inicio',
                      variant: AppButtonVariant.secondary,
                      icon: Icons.arrow_back_rounded,
                      onPressed: () => context.go('/dashboard'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
