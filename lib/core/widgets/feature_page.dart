import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design_system/spacing.dart';
import '../network/api_failure.dart';
import 'app_button.dart';
import 'app_fade_switcher.dart';
import 'app_shimmer.dart';
import 'empty_state.dart';
import 'loading_skeleton.dart';

class FeaturePage extends StatelessWidget {
  const FeaturePage({
    super.key,
    required this.title,
    required this.description,
    required this.child,
    this.actions = const [],
    this.tabs,
  });
  final String title;
  final String description;
  final Widget child;
  final List<Widget> actions;
  final Widget? tabs;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(
      MediaQuery.sizeOf(context).width < 640 ? AppSpacing.md : AppSpacing.xl,
    ),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.contentMaxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (tabs != null) ...[tabs!, const SizedBox(height: AppSpacing.lg)],
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
            if (actions.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: actions,
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            // Fundido entre cargando / error / datos (ver AppFadeSwitcher).
            AppFadeSwitcher(child: child),
          ],
        ),
      ),
    ),
  );
}

class FeatureLoading extends StatelessWidget {
  const FeatureLoading({super.key});
  @override
  Widget build(BuildContext context) => const AppShimmer(
    child: Column(
      children: [
        LoadingSkeleton(height: 64),
        SizedBox(height: AppSpacing.md),
        LoadingSkeleton(height: 64),
        SizedBox(height: AppSpacing.md),
        LoadingSkeleton(height: 64),
      ],
    ),
  );
}

class FeatureError extends StatelessWidget {
  const FeatureError({super.key, required this.error, required this.onRetry});
  final Object error;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => EmptyState(
    icon: Icons.cloud_off_outlined,
    title: 'No pudimos cargar la información',
    message: apiErrorMessage(error),
    action: AppButton(label: 'Reintentar', onPressed: onRetry),
  );
}

Widget tableText(String? value, {String fallback = 'Pendiente'}) => SizedBox(
  width: 200,
  child: Text(
    value == null || value.trim().isEmpty ? fallback : value,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
  ),
);

class FeatureTabs extends StatelessWidget {
  const FeatureTabs({
    super.key,
    required this.current,
    required this.destinations,
  });
  final String current;
  final List<({String label, String path})> destinations;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppSpacing.sm,
    runSpacing: AppSpacing.sm,
    children: [
      for (final item in destinations)
        ChoiceChip(
          label: Text(item.label),
          selected: current == item.path,
          onSelected: (_) => context.go(item.path),
        ),
    ],
  );
}
