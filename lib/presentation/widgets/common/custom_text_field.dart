import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Widget de campo de texto personalizado seguindo o design system
class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? maxLength;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.inputFormatters,
    this.focusNode,
    this.contentPadding,
  });

  /// Construtor para campo de email
  const CustomTextField.email({
    super.key,
    this.label = 'E-mail',
    this.hint = 'Digite seu e-mail',
    this.initialValue,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.contentPadding,
  }) : keyboardType = TextInputType.emailAddress,
       textInputAction = TextInputAction.next,
       obscureText = false,
       maxLines = 1,
       maxLength = null,
       prefixIcon = Icons.email_outlined,
       suffixIcon = null,
       onSuffixIconPressed = null,
       inputFormatters = null;

  /// Construtor para campo de senha
  const CustomTextField.password({
    super.key,
    this.label = 'Senha',
    this.hint = 'Digite sua senha',
    this.initialValue,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.contentPadding,
  }) : keyboardType = TextInputType.visiblePassword,
       textInputAction = TextInputAction.done,
       obscureText = true,
       maxLines = 1,
       maxLength = null,
       prefixIcon = Icons.lock_outlined,
       suffixIcon = null,
       onSuffixIconPressed = null,
       inputFormatters = null;

  /// Construtor para campo de nome
  const CustomTextField.name({
    super.key,
    this.label = 'Nome',
    this.hint = 'Digite seu nome',
    this.initialValue,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.contentPadding,
  }) : keyboardType = TextInputType.name,
       textInputAction = TextInputAction.next,
       obscureText = false,
       maxLines = 1,
       maxLength = 50,
       prefixIcon = Icons.person_outlined,
       suffixIcon = null,
       onSuffixIconPressed = null,
       inputFormatters = null;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  late TextEditingController _controller;
  bool _controllerCreatedInternally = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController(text: widget.initialValue);
      _controllerCreatedInternally = true;
    }
  }

  @override
  void dispose() {
    if (_controllerCreatedInternally) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: AppDimensions.fontSizeMd,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
        ],
        TextFormField(
          controller: _controller,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          focusNode: widget.focusNode,
          style: const TextStyle(
            fontSize: AppDimensions.fontSizeMd,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(
              color: AppColors.textLight,
              fontSize: AppDimensions.fontSizeMd,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: AppColors.textSecondary,
                    size: AppDimensions.iconSm,
                  )
                : null,
            suffixIcon: _buildSuffixIcon(),
            filled: true,
            fillColor: widget.enabled ? AppColors.surface : AppColors.disabled,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: const BorderSide(
                color: AppColors.border,
                width: AppDimensions.borderWidthThin,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: const BorderSide(
                color: AppColors.border,
                width: AppDimensions.borderWidthThin,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: AppDimensions.borderWidthMedium,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: AppDimensions.borderWidthThin,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: AppDimensions.borderWidthMedium,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: const BorderSide(
                color: AppColors.disabled,
                width: AppDimensions.borderWidthThin,
              ),
            ),
            contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMd,
              vertical: AppDimensions.paddingMd,
            ),
            counterStyle: const TextStyle(
              color: AppColors.textLight,
              fontSize: AppDimensions.fontSizeSm,
            ),
            errorStyle: const TextStyle(
              color: AppColors.error,
              fontSize: AppDimensions.fontSizeSm,
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    // Se é um campo de senha, mostra o ícone de visibilidade
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: AppColors.textSecondary,
          size: AppDimensions.iconSm,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    // Se tem um ícone de sufixo personalizado
    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          color: AppColors.textSecondary,
          size: AppDimensions.iconSm,
        ),
        onPressed: widget.onSuffixIconPressed,
      );
    }

    return null;
  }
}
