import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Widget para exibir mensagens de erro de forma consistente
class ErrorMessageWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final bool showRetryButton;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const ErrorMessageWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.showRetryButton = true,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  /// Factory para erro de rede
  factory ErrorMessageWidget.network({
    required String message,
    VoidCallback? onRetry,
  }) {
    return ErrorMessageWidget(
      message: message,
      onRetry: onRetry,
      icon: Icons.wifi_off,
      showRetryButton: true,
    );
  }

  /// Factory para erro de validação
  factory ErrorMessageWidget.validation({required String message}) {
    return ErrorMessageWidget(
      message: message,
      icon: Icons.warning,
      showRetryButton: false,
      backgroundColor: AppColors.warning.withValues(alpha: 0.1),
      textColor: AppColors.warning,
      borderColor: AppColors.warning.withValues(alpha: 0.3),
    );
  }

  /// Factory para erro de permissão
  factory ErrorMessageWidget.permission({
    required String message,
    VoidCallback? onRetry,
  }) {
    return ErrorMessageWidget(
      message: message,
      onRetry: onRetry,
      icon: Icons.lock,
      showRetryButton: false,
      backgroundColor: AppColors.error.withValues(alpha: 0.1),
      textColor: AppColors.error,
      borderColor: AppColors.error.withValues(alpha: 0.3),
    );
  }

  /// Factory para erro genérico
  factory ErrorMessageWidget.generic({
    required String message,
    VoidCallback? onRetry,
  }) {
    return ErrorMessageWidget(
      message: message,
      onRetry: onRetry,
      icon: Icons.error_outline,
      showRetryButton: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor =
        backgroundColor ?? AppColors.error.withValues(alpha: 0.1);
    final effectiveTextColor = textColor ?? AppColors.error;
    final effectiveBorderColor =
        borderColor ?? AppColors.error.withValues(alpha: 0.3);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: effectiveBorderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon ?? Icons.error_outline,
                color: effectiveTextColor,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: effectiveTextColor,
                    fontSize: AppDimensions.fontSizeMd,
                  ),
                ),
              ),
            ],
          ),

          if (showRetryButton && onRetry != null) ...[
            const SizedBox(height: AppDimensions.spacingMd),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar Novamente'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: effectiveTextColor,
                  side: BorderSide(color: effectiveTextColor),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget para exibir estado vazio
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? action;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon ?? Icons.inbox, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              title,
              style: const TextStyle(
                fontSize: AppDimensions.fontSizeLg,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: AppDimensions.fontSizeMd,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppDimensions.spacingLg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget para exibir feedback de sucesso
class SuccessMessageWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;
  final bool showDismissButton;

  const SuccessMessageWidget({
    super.key,
    required this.message,
    this.onDismiss,
    this.showDismissButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 20),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.success,
                fontSize: AppDimensions.fontSizeMd,
              ),
            ),
          ),
          if (showDismissButton && onDismiss != null) ...[
            const SizedBox(width: AppDimensions.spacingSm),
            IconButton(
              onPressed: onDismiss,
              icon: const Icon(Icons.close, color: AppColors.success, size: 18),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget para exibir informações importantes
class InfoMessageWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;
  final bool showDismissButton;

  const InfoMessageWidget({
    super.key,
    required this.message,
    this.onDismiss,
    this.showDismissButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info, color: AppColors.info, size: 20),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.info,
                fontSize: AppDimensions.fontSizeMd,
              ),
            ),
          ),
          if (showDismissButton && onDismiss != null) ...[
            const SizedBox(width: AppDimensions.spacingSm),
            IconButton(
              onPressed: onDismiss,
              icon: const Icon(Icons.close, color: AppColors.info, size: 18),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
            ),
          ],
        ],
      ),
    );
  }
}
