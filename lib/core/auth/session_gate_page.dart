import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../design_system/brand.dart';
import '../design_system/spacing.dart';
import '../widgets/app_button.dart';
import '../widgets/loading_skeleton.dart';
import 'auth_models.dart';
import 'session_controller.dart';

class SessionGatePage extends ConsumerWidget {
  const SessionGatePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionControllerProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    gpaLogoAsset,
                    height: 100,
                    semanticLabel: 'Grupo GPA',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (session.status == SessionStatus.unavailable) ...[
                    Text(
                      session.message ?? 'No pudimos recuperar tu sesión.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: 'Volver a intentar',
                      onPressed: () => ref
                          .read(sessionControllerProvider.notifier)
                          .restore(),
                    ),
                    AppButton(
                      label: 'Cerrar sesión',
                      variant: AppButtonVariant.text,
                      onPressed: () =>
                          ref.read(sessionControllerProvider.notifier).logout(),
                    ),
                  ] else ...[
                    Text(
                      'Preparando tu espacio…',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const LoadingSkeleton(width: 200),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
