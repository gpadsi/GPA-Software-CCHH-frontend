import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/design_system/brand.dart';
import '../../../core/design_system/breakpoints.dart';
import '../../../core/design_system/colors.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _visible = false;
  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    await ref
        .read(sessionControllerProvider.notifier)
        .login(_username.text, _password.text);
    if (!mounted) return;
    TextInput.finishAutofillContext(shouldSave: false);
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionControllerProvider);
    final strings = AppLocalizations.of(context);
    final type = Theme.of(context).textTheme;
    final wide = MediaQuery.sizeOf(context).width > AppBreakpoints.desktop;
    final form = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: AutofillGroup(
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  gpaLogoAsset,
                  height: 96,
                  fit: BoxFit.contain,
                  semanticLabel: 'Grupo GPA',
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(strings.loginTitle, style: type.headlineSmall),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  strings.loginSubtitle,
                  style: type.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppTextField(
                  label: strings.usernameLabel,
                  controller: _username,
                  prefixIcon: Icons.person_outline,
                  enabled: !session.isSubmitting,
                  autofillHints: const [AutofillHints.username],
                  textInputAction: TextInputAction.next,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? strings.usernameRequired
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: strings.passwordLabel,
                  controller: _password,
                  prefixIcon: Icons.lock_outline,
                  enabled: !session.isSubmitting,
                  obscureText: !_visible,
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: (value) => value == null || value.isEmpty
                      ? strings.passwordRequired
                      : null,
                  suffixIcon: IconButton(
                    tooltip: _visible
                        ? strings.hidePassword
                        : strings.showPassword,
                    onPressed: () => setState(() => _visible = !_visible),
                    icon: Icon(
                      _visible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
                if (session.message != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Semantics(
                    liveRegion: true,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.errorSurface,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.controlRadius,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 20,
                            color: AppColors.error,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              session.message!,
                              style: type.bodyMedium?.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: strings.signIn,
                  onPressed: _submit,
                  isLoading: session.isSubmitting,
                  icon: Icons.arrow_forward_rounded,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  strings.loginHelp,
                  style: type.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(wide ? AppSpacing.xxl : AppSpacing.md),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: wide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: AppSpacing.xxl,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const BrandWordmark(),
                                const SizedBox(height: AppSpacing.xxl),
                                Text(
                                  strings.workspaceTitle,
                                  style: type.displaySmall,
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                Text(
                                  strings.workspaceSubtitle,
                                  style: type.bodyLarge?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xl),
                                Text(
                                  'CAPITAL HUMANO · GRUPO GPA',
                                  style: type.labelSmall?.copyWith(
                                    letterSpacing: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(child: form),
                      ],
                    )
                  : Column(
                      children: [
                        form,
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Capital Humano · Grupo GPA',
                          style: type.bodySmall,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
