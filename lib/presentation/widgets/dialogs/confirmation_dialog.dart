import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Dialog genérico de confirmação reutilizável
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmButtonColor;
  final Color? confirmTextColor;
  final IconData? icon;
  final Color? iconColor;
  final bool isDestructive;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = 'Confirmar',
    this.cancelText = 'Cancelar',
    this.onConfirm,
    this.onCancel,
    this.confirmButtonColor,
    this.confirmTextColor,
    this.icon,
    this.iconColor,
    this.isDestructive = false,
  });

  /// Factory para criar um dialog de promoção de voluntário
  factory ConfirmationDialog.promoteVolunteer({
    required String volunteerName,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return ConfirmationDialog(
      title: 'Promover Voluntário',
      content: 'Tem certeza de que deseja promover "$volunteerName" a gerente?\n\n'
          'Esta ação concederá permissões de gerenciamento do evento ao usuário. '
          'O voluntário poderá criar tasks, gerenciar outros voluntários e '
          'modificar configurações do evento.\n\n'
          'Esta ação não pode ser desfeita facilmente.',
      confirmText: 'Confirmar Promoção',
      cancelText: 'Cancelar',
      onConfirm: onConfirm,
      onCancel: onCancel,
      confirmButtonColor: AppColors.warning,
      confirmTextColor: Colors.white,
      icon: Icons.admin_panel_settings,
      iconColor: AppColors.warning,
      isDestructive: false,
    );
  }

  /// Factory para criar um dialog de remoção/exclusão
  factory ConfirmationDialog.delete({
    required String title,
    required String itemName,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return ConfirmationDialog(
      title: title,
      content: 'Tem certeza de que deseja excluir "$itemName"?\n\n'
          'Esta ação não pode ser desfeita.',
      confirmText: 'Excluir',
      cancelText: 'Cancelar',
      onConfirm: onConfirm,
      onCancel: onCancel,
      confirmButtonColor: AppColors.error,
      confirmTextColor: Colors.white,
      icon: Icons.delete_forever,
      iconColor: AppColors.error,
      isDestructive: true,
    );
  }

  /// Factory para criar um dialog de saída/logout
  factory ConfirmationDialog.logout({
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return ConfirmationDialog(
      title: 'Sair da Conta',
      content: 'Tem certeza de que deseja sair da sua conta?',
      confirmText: 'Sair',
      cancelText: 'Cancelar',
      onConfirm: onConfirm,
      onCancel: onCancel,
      confirmButtonColor: AppColors.error,
      confirmTextColor: Colors.white,
      icon: Icons.logout,
      iconColor: AppColors.error,
      isDestructive: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: AppDimensions.spacingMd),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 300,
        ),
        child: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          child: Text(
            cancelText,
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm != null
              ? () {
                  onConfirm!();
                  Navigator.of(context).pop(true);
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmButtonColor ?? AppColors.primary,
            foregroundColor: confirmTextColor ?? Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }

  /// Método estático para mostrar o dialog e retornar o resultado
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    Color? confirmButtonColor,
    Color? confirmTextColor,
    IconData? icon,
    Color? iconColor,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmButtonColor: confirmButtonColor,
        confirmTextColor: confirmTextColor,
        icon: icon,
        iconColor: iconColor,
        isDestructive: isDestructive,
        onConfirm: () {}, // O callback será tratado pelo retorno do showDialog
      ),
    );
  }

  /// Método estático para mostrar dialog de promoção
  static Future<bool?> showPromoteVolunteer({
    required BuildContext context,
    required String volunteerName,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialog.promoteVolunteer(
        volunteerName: volunteerName,
        onConfirm: () {}, // O callback será tratado pelo retorno do showDialog
      ),
    );
  }

  /// Método estático para mostrar dialog de exclusão
  static Future<bool?> showDelete({
    required BuildContext context,
    required String title,
    required String itemName,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialog.delete(
        title: title,
        itemName: itemName,
        onConfirm: () {}, // O callback será tratado pelo retorno do showDialog
      ),
    );
  }

  /// Método estático para mostrar dialog de logout
  static Future<bool?> showLogout({
    required BuildContext context,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialog.logout(
        onConfirm: () {}, // O callback será tratado pelo retorno do showDialog
      ),
    );
  }
}
