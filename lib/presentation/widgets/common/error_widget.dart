import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Widget customizado para exibir erros
class CustomErrorWidget extends StatelessWidget {
  final String message;
  final String? title;
  final IconData? icon;
  final VoidCallback? onRetry;
  final String? retryText;
  final bool showIcon;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.title,
    this.icon,
    this.onRetry,
    this.retryText,
    this.showIcon = true,
    this.iconColor,
    this.textColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone de erro
            if (showIcon) ...[
              Icon(
                icon ?? Icons.error_outline,
                size: iconSize ?? 64,
                color: iconColor ?? AppColors.error,
              ),
              const SizedBox(height: AppDimensions.spacingLg),
            ],

            // Título (opcional)
            if (title != null) ...[
              Text(
                title!,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingMd),
            ],

            // Mensagem de erro
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: textColor ?? AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            // Botão de retry (opcional)
            if (onRetry != null) ...[
              const SizedBox(height: AppDimensions.spacingLg),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryText ?? 'Tentar Novamente'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingLg,
                    vertical: AppDimensions.paddingMd,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget de erro compacto para usar em cards ou listas
class CompactErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final Color? color;

  const CompactErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: (color ?? AppColors.error).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (color ?? AppColors.error).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon ?? Icons.warning_amber,
            color: color ?? AppColors.error,
            size: 20,
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: color ?? AppColors.error,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: AppDimensions.spacingSm),
            IconButton(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              color: color ?? AppColors.error,
              iconSize: 20,
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget de erro para conexão de rede
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? customMessage;

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'Sem Conexão',
      message: customMessage ?? 
          'Verifique sua conexão com a internet e tente novamente.',
      icon: Icons.wifi_off,
      iconColor: AppColors.warning,
      onRetry: onRetry,
      retryText: 'Tentar Novamente',
    );
  }
}

/// Widget de erro para dados não encontrados
class NotFoundErrorWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onAction;
  final String? actionText;
  final IconData? icon;

  const NotFoundErrorWidget({
    super.key,
    this.title,
    this.message,
    this.onAction,
    this.actionText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: title ?? 'Nada Encontrado',
      message: message ?? 'Não foram encontrados dados para exibir.',
      icon: icon ?? Icons.search_off,
      iconColor: AppColors.textSecondary,
      onRetry: onAction,
      retryText: actionText,
    );
  }
}

/// Widget de erro para permissões
class PermissionErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRequestPermission;

  const PermissionErrorWidget({
    super.key,
    this.message,
    this.onRequestPermission,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'Permissão Necessária',
      message: message ?? 
          'Esta funcionalidade requer permissões específicas para funcionar.',
      icon: Icons.lock_outline,
      iconColor: AppColors.warning,
      onRetry: onRequestPermission,
      retryText: 'Conceder Permissão',
    );
  }
}

/// Widget de erro genérico com diferentes tipos
class ErrorDisplayWidget extends StatelessWidget {
  final ErrorType type;
  final String? customMessage;
  final VoidCallback? onAction;
  final String? actionText;

  const ErrorDisplayWidget({
    super.key,
    required this.type,
    this.customMessage,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ErrorType.network:
        return NetworkErrorWidget(
          onRetry: onAction,
          customMessage: customMessage,
        );
      case ErrorType.notFound:
        return NotFoundErrorWidget(
          message: customMessage,
          onAction: onAction,
          actionText: actionText,
        );
      case ErrorType.permission:
        return PermissionErrorWidget(
          message: customMessage,
          onRequestPermission: onAction,
        );
      case ErrorType.server:
        return CustomErrorWidget(
          title: 'Erro do Servidor',
          message: customMessage ?? 'Ocorreu um erro no servidor. Tente novamente.',
          icon: Icons.cloud_off,
          iconColor: AppColors.error,
          onRetry: onAction,
          retryText: actionText ?? 'Tentar Novamente',
        );
      case ErrorType.validation:
        return CompactErrorWidget(
          message: customMessage ?? 'Dados inválidos fornecidos.',
          color: AppColors.warning,
          icon: Icons.warning_amber,
        );
      case ErrorType.generic:
      default:
        return CustomErrorWidget(
          message: customMessage ?? 'Ocorreu um erro inesperado.',
          onRetry: onAction,
          retryText: actionText,
        );
    }
  }
}

/// Tipos de erro suportados
enum ErrorType {
  network,
  notFound,
  permission,
  server,
  validation,
  generic,
}
