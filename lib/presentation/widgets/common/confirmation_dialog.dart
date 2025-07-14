import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Dialog de confirmação customizável
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final IconData? icon;
  final Color? iconColor;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;
  final bool isDangerous;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.icon,
    this.iconColor,
    this.confirmButtonColor,
    this.cancelButtonColor,
    this.isDangerous = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? (isDangerous ? AppColors.error : AppColors.primary),
              size: 24,
            ),
            const SizedBox(width: AppDimensions.spacingSm),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.textSecondary,
          height: 1.4,
        ),
      ),
      actions: [
        // Botão Cancelar
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(
            foregroundColor: cancelButtonColor ?? AppColors.textSecondary,
          ),
          child: Text(cancelText ?? 'Cancelar'),
        ),
        
        // Botão Confirmar
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmButtonColor ?? 
                (isDangerous ? AppColors.error : AppColors.primary),
            foregroundColor: AppColors.textOnPrimary,
          ),
          child: Text(confirmText ?? 'Confirmar'),
        ),
      ],
    );
  }

  /// Método estático para mostrar o dialog
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    IconData? icon,
    Color? iconColor,
    Color? confirmButtonColor,
    Color? cancelButtonColor,
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        icon: icon,
        iconColor: iconColor,
        confirmButtonColor: confirmButtonColor,
        cancelButtonColor: cancelButtonColor,
        isDangerous: isDangerous,
      ),
    );
  }
}

/// Dialog de confirmação para ações perigosas
class DangerConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final VoidCallback? onConfirm;

  const DangerConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: title,
      message: message,
      confirmText: confirmText ?? 'Excluir',
      icon: Icons.warning,
      isDangerous: true,
      onConfirm: onConfirm,
    );
  }

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => DangerConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        onConfirm: onConfirm,
      ),
    );
  }
}

/// Dialog de confirmação simples
class SimpleConfirmationDialog extends StatelessWidget {
  final String message;
  final VoidCallback? onConfirm;

  const SimpleConfirmationDialog({
    super.key,
    required this.message,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Não'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
          ),
          child: const Text('Sim'),
        ),
      ],
    );
  }

  static Future<bool?> show({
    required BuildContext context,
    required String message,
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => SimpleConfirmationDialog(
        message: message,
        onConfirm: onConfirm,
      ),
    );
  }
}

/// Dialog de confirmação com input
class InputConfirmationDialog extends StatefulWidget {
  final String title;
  final String message;
  final String? hintText;
  final String? confirmText;
  final Function(String)? onConfirm;
  final bool isRequired;
  final String? Function(String?)? validator;

  const InputConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.hintText,
    this.confirmText,
    this.onConfirm,
    this.isRequired = true,
    this.validator,
  });

  @override
  State<InputConfirmationDialog> createState() => _InputConfirmationDialogState();

  static Future<String?> show({
    required BuildContext context,
    required String title,
    required String message,
    String? hintText,
    String? confirmText,
    Function(String)? onConfirm,
    bool isRequired = true,
    String? Function(String?)? validator,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => InputConfirmationDialog(
        title: title,
        message: message,
        hintText: hintText,
        confirmText: confirmText,
        onConfirm: onConfirm,
        isRequired: isRequired,
        validator: validator,
      ),
    );
  }
}

class _InputConfirmationDialogState extends State<InputConfirmationDialog> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        widget.title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.message,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: const OutlineInputBorder(),
              ),
              validator: widget.validator ?? (widget.isRequired 
                  ? (value) => value?.isEmpty == true ? 'Campo obrigatório' : null
                  : null),
              autofocus: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              final value = _controller.text;
              Navigator.of(context).pop(value);
              widget.onConfirm?.call(value);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
          ),
          child: Text(widget.confirmText ?? 'Confirmar'),
        ),
      ],
    );
  }
}
