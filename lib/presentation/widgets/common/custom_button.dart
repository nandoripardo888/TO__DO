import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Tipos de botão disponíveis
enum CustomButtonType {
  primary,
  secondary,
  outline,
  text,
  google,
}

/// Widget de botão personalizado seguindo o design system
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = CustomButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.width,
    this.height,
    this.padding,
  });

  /// Construtor para botão primário
  const CustomButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.width,
    this.height,
    this.padding,
  }) : type = CustomButtonType.primary;

  /// Construtor para botão secundário
  const CustomButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.width,
    this.height,
    this.padding,
  }) : type = CustomButtonType.secondary;

  /// Construtor para botão outline
  const CustomButton.outline({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.width,
    this.height,
    this.padding,
  }) : type = CustomButtonType.outline;

  /// Construtor para botão de texto
  const CustomButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.width,
    this.height,
    this.padding,
  }) : type = CustomButtonType.text;

  /// Construtor para botão do Google
  const CustomButton.google({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width,
    this.height,
    this.padding,
  }) : type = CustomButtonType.google,
       icon = null;

  @override
  Widget build(BuildContext context) {
    final buttonWidth = isFullWidth ? double.infinity : width;
    final buttonHeight = height ?? AppDimensions.buttonHeightMd;

    Widget button = _buildButton(context);

    if (buttonWidth != null) {
      button = SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: button,
      );
    }

    return button;
  }

  Widget _buildButton(BuildContext context) {
    switch (type) {
      case CustomButtonType.primary:
        return _buildElevatedButton(context);
      case CustomButtonType.secondary:
        return _buildSecondaryButton(context);
      case CustomButtonType.outline:
        return _buildOutlinedButton(context);
      case CustomButtonType.text:
        return _buildTextButton(context);
      case CustomButtonType.google:
        return _buildGoogleButton(context);
    }
  }

  Widget _buildElevatedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        disabledBackgroundColor: AppColors.disabled,
        elevation: AppDimensions.elevationSm,
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLg,
          vertical: AppDimensions.paddingMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.textPrimary,
        disabledBackgroundColor: AppColors.disabled,
        elevation: AppDimensions.elevationSm,
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLg,
          vertical: AppDimensions.paddingMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildOutlinedButton(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.disabled,
        side: BorderSide(
          color: onPressed != null ? AppColors.primary : AppColors.disabled,
          width: AppDimensions.borderWidthThin,
        ),
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLg,
          vertical: AppDimensions.paddingMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.disabled,
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
          vertical: AppDimensions.paddingSm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildGoogleButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        disabledBackgroundColor: AppColors.disabled,
        elevation: AppDimensions.elevationSm,
        side: const BorderSide(
          color: AppColors.border,
          width: AppDimensions.borderWidthThin,
        ),
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLg,
          vertical: AppDimensions.paddingMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
      child: _buildGoogleButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        width: AppDimensions.iconSm,
        height: AppDimensions.iconSm,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppDimensions.iconSm,
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Text(
            text,
            style: const TextStyle(
              fontSize: AppDimensions.fontSizeLg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: const TextStyle(
        fontSize: AppDimensions.fontSizeLg,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildGoogleButtonContent() {
    if (isLoading) {
      return const SizedBox(
        width: AppDimensions.iconSm,
        height: AppDimensions.iconSm,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo do Google
        Image.asset(
          'assets/Google__G__logo.svg.png',
          width: AppDimensions.iconSm,
          height: AppDimensions.iconSm,
        ),
        const SizedBox(width: AppDimensions.spacingMd),
        Text(
          text,
          style: const TextStyle(
            fontSize: AppDimensions.fontSizeLg,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
