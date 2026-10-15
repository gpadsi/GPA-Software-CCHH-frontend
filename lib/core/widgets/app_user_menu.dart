import 'package:flutter/material.dart';

import '../auth/auth_models.dart';
import '../design_system/colors.dart';
import '../design_system/spacing.dart';
import 'app_avatar.dart';
import 'appearance_dialog.dart';

/// Menú de cuenta compartido por la cabecera general y los editores.
class AppUserMenu extends StatelessWidget {
  const AppUserMenu({
    super.key,
    required this.user,
    required this.onLogout,
    this.compact = false,
  });
  final SessionUser? user;
  final VoidCallback onLogout;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: compact ? 56 : 230),
      child: PopupMenuButton<String>(
        tooltip: 'Menú de usuario',
        position: PopupMenuPosition.under,
        onSelected: (value) {
          if (value == 'appearance') showAppearanceDialog(context);
          if (value == 'logout') onLogout();
        },
        itemBuilder: (context) => const [
          PopupMenuItem<String>(
            value: 'appearance',
            child: _UserMenuEntry(
              icon: Icons.palette_outlined,
              label: 'Apariencia',
            ),
          ),
          PopupMenuItem<String>(
            value: 'logout',
            child: _UserMenuEntry(
              icon: Icons.logout_rounded,
              label: 'Cerrar sesión',
            ),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppAvatar(name: user?.displayName ?? '', size: 40),
              if (!compact) ...[
                const SizedBox(width: AppSpacing.sm),
                // Flexible + ellipsis: sin esto, a escala de texto 1.5x
                // este bloque puede pedir más ancho del que el topbar
                // tiene disponible y desbordar (visto en pruebas).
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.displayName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user?.username ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelSmall?.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: context.colors.textSecondary,
                  size: 18,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _UserMenuEntry extends StatelessWidget {
  const _UserMenuEntry({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 20, color: context.colors.textSecondary),
      const SizedBox(width: AppSpacing.md),
      Text(label),
    ],
  );
}
