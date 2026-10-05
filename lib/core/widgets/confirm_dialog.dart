import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../design_system/colors.dart';
import '../design_system/spacing.dart';
import '../network/api_failure.dart';
import 'app_button.dart';
import 'app_overlays.dart';

/// Nota que acompaña a todo borrado: el sistema puede negarse si el registro
/// tiene otros vinculados.
const deleteLinkedRecordsHint =
    'Si tiene registros vinculados, el sistema puede impedir su eliminación.';

/// Mensaje de error de una acción de borrado (el genérico de `apiErrorMessage`
/// habla de "acceso a información", que no dice nada al eliminar).
String deleteErrorMessage(Object error) {
  if (error is DioException) {
    final code = error.response?.statusCode;
    if (code == 403) {
      return 'Tu cuenta no tiene permiso para eliminar este registro.';
    }
    if (code == 404) {
      return 'El registro ya no está disponible. Actualiza la lista.';
    }
    if (error.response != null && code != 401 && code != 429) {
      return 'No se pudo eliminar. Si tiene registros vinculados, deben resolverse antes.';
    }
  }
  return apiErrorMessage(error);
}

/// Diálogo de confirmación único de la app. Reemplaza a las ~6 clases de
/// "¿Eliminar…?" que había copiadas pantalla por pantalla, y arregla un
/// defecto de varias: si la acción fallaba, el diálogo se cerraba en
/// silencio como si nada. Aquí el error se muestra DENTRO del diálogo, que
/// sigue abierto para reintentar o cancelar.
///
/// [onConfirm] hace el trabajo (la llamada a la API) y lanza si falla; este
/// diálogo se encarga del estado de carga y del mensaje. Devuelve true solo si
/// la acción terminó bien.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required Future<void> Function() onConfirm,
  String? details,
  String confirmLabel = 'Eliminar',
  bool destructive = true,
  String Function(Object error)? errorMessage,
}) async {
  final confirmed = await showAppDialog<bool>(
    context: context,
    builder: (_) => _ConfirmDialog(
      title: title,
      message: message,
      details: details,
      confirmLabel: confirmLabel,
      destructive: destructive,
      onConfirm: onConfirm,
      errorMessage:
          errorMessage ?? (destructive ? deleteErrorMessage : apiErrorMessage),
    ),
  );
  return confirmed == true;
}

class _ConfirmDialog extends StatefulWidget {
  const _ConfirmDialog({
    required this.title,
    required this.message,
    required this.details,
    required this.confirmLabel,
    required this.destructive,
    required this.onConfirm,
    required this.errorMessage,
  });

  final String title;
  final String message;
  final String? details;
  final String confirmLabel;
  final bool destructive;
  final Future<void> Function() onConfirm;
  final String Function(Object error) errorMessage;

  @override
  State<_ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<_ConfirmDialog> {
  bool _busy = false;
  String? _error;

  Future<void> _confirm() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.onConfirm();
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _busy = false;
          // El motivo del servidor ("lo usan 3 posiciones") dice más que
          // cualquier texto genérico de la pantalla que abrió el diálogo.
          _error = conflictDetail(error) ?? widget.errorMessage(error);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = Theme.of(context).textTheme;
    final tint = widget.destructive ? AppColors.error : AppColors.primary;
    final tintSurface = widget.destructive
        ? AppColors.errorSurface
        : AppColors.primarySurface;
    return PopScope(
      canPop: !_busy,
      child: Dialog(
        insetPadding: const EdgeInsets.all(AppSpacing.md),
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          side: const BorderSide(color: AppColors.border),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: tintSurface,
                    borderRadius: BorderRadius.circular(
                      AppSpacing.controlRadius,
                    ),
                  ),
                  child: Icon(
                    widget.destructive
                        ? Icons.delete_outline_rounded
                        : Icons.help_outline_rounded,
                    color: tint,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(widget.title, style: type.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  widget.message,
                  style: type.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (widget.details != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(widget.details!, style: type.bodySmall),
                ],
                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Semantics(
                    liveRegion: true,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.sm + 4),
                      decoration: BoxDecoration(
                        color: AppColors.errorSurface,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.controlRadius,
                        ),
                      ),
                      child: Text(
                        _error!,
                        style: type.bodySmall?.copyWith(color: AppColors.error),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    AppButton(
                      label: 'Cancelar',
                      variant: AppButtonVariant.secondary,
                      onPressed: _busy
                          ? null
                          : () => Navigator.of(context).pop(false),
                    ),
                    AppButton(
                      label: widget.confirmLabel,
                      variant: widget.destructive
                          ? AppButtonVariant.danger
                          : AppButtonVariant.primary,
                      isLoading: _busy,
                      onPressed: _confirm,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
