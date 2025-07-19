import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_app_bar.dart';
/// Tela de cadastro conforme especificado no SPEC_GERAL.md
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: AppStrings.register,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Consumer<AuthController>(
          builder: (context, authController, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingLg),
              child: Column(
                children: [
                  const SizedBox(height: AppDimensions.spacingLg),

                  // Formulário de cadastro
                  _buildRegisterForm(authController),

                  const SizedBox(height: AppDimensions.spacingLg),

                  // Link "Já tenho conta"
                  _buildLoginLink(),

                  // Mensagem de erro
                  if (authController.errorMessage != null) ...[
                    const SizedBox(height: AppDimensions.spacingMd),
                    _buildErrorMessage(authController.errorMessage!),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRegisterForm(AuthController authController) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Campo de nome
          CustomTextField.name(
            controller: _nameController,
            focusNode: _nameFocusNode,
            validator: Validators.validateName,
            onSubmitted: (_) => _emailFocusNode.requestFocus(),
          ),

          const SizedBox(height: AppDimensions.spacingMd),

          // Campo de email
          CustomTextField.email(
            controller: _emailController,
            focusNode: _emailFocusNode,
            validator: Validators.validateEmail,
            onSubmitted: (_) => _passwordFocusNode.requestFocus(),
          ),

          const SizedBox(height: AppDimensions.spacingMd),

          // Campo de senha
          CustomTextField.password(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            validator: Validators.validatePassword,
            onSubmitted: (_) => _confirmPasswordFocusNode.requestFocus(),
          ),

          const SizedBox(height: AppDimensions.spacingMd),

          // Campo de confirmar senha
          CustomTextField(
            label: AppStrings.confirmPassword,
            hint: 'Confirme sua senha',
            controller: _confirmPasswordController,
            focusNode: _confirmPasswordFocusNode,
            obscureText: true,
            prefixIcon: Icons.lock_outlined,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            validator: (value) => Validators.validatePasswordConfirmation(
              value,
              _passwordController.text,
            ),
            onSubmitted: (_) => _handleRegister(authController),
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Botão de cadastro
          CustomButton.primary(
            text: AppStrings.register,
            onPressed: () => _handleRegister(authController),
            isLoading: authController.isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          AppStrings.alreadyHaveAccount,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: AppDimensions.fontSizeMd,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        GestureDetector(
          onTap: _navigateToLogin,
          child: const Text(
            AppStrings.login,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: AppDimensions.fontSizeMd,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
          width: AppDimensions.borderWidthThin,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: AppDimensions.iconSm,
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: AppDimensions.fontSizeSm,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXs),
                GestureDetector(
                  onTap: () {
                    Provider.of<AuthController>(
                      context,
                      listen: false,
                    ).clearError();
                  },
                  child: const Text(
                    'Toque para fechar',
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: AppDimensions.fontSizeXs,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRegister(AuthController authController) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await authController.createUserWithEmailAndPassword(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      // Mostrar mensagem de sucesso
      _showSnackBar('Conta criada com sucesso!');

      // Navegar para a tela principal
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pop();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
    );
  }
}
