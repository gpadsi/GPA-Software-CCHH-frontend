import 'package:flutter/material.dart';

import '../design_system/spacing.dart';
import '../network/api_failure.dart';
import 'app_button.dart';
import 'app_shimmer.dart';
import 'empty_state.dart';
import 'loading_skeleton.dart';

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
