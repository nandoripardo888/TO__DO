import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

/// Tela de login conforme especificado no SPEC_GERAL.md
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<AuthController>(
          builder: (context, authController, child) {
            if (isLandscape && screenWidth > 800) {
               // Layout para telas maiores em landscape
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Row(
                      children: [
                        // Ilustração na lateral esquerda (60%)
                        Expanded(
                          flex: 6,
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: AppDimensions.paddingLg,
                              top: AppDimensions.paddingLg,
                              bottom: AppDimensions.paddingLg,
                            ),
                            child: Center(
                              child: Opacity(
                                opacity: 0.8,
                                child: SvgPicture.asset(
                                  'assets/20250719_1213_Volunteer Aid Collaboration_simple_compose_01k0hq9640ftgv3zp47z8wjzzq.svg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Componentes de login na direita (40%)
                        Expanded(
                          flex: 4,
                          child: Container(
                            padding: const EdgeInsets.only(
                              right: AppDimensions.paddingLg,
                              top: AppDimensions.paddingLg,
                              bottom: AppDimensions.paddingLg,
                            ),
                            child: Center(
                              child: SingleChildScrollView(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 400),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Logo centralizado
                                      _buildLogo(),
                                      
                                      const SizedBox(height: AppDimensions.spacingXxl),
                                      
                                      // Formulário de login
                                      _buildLoginForm(authController),
                                      
                                      const SizedBox(height: AppDimensions.spacingLg),
                                      
                                      // Botão "Entrar com Google"
                                      _buildGoogleSignInButton(authController),
                                      
                                      const SizedBox(height: AppDimensions.spacingLg),
                                      
                                      // Link "Criar conta"
                                      _buildCreateAccountLink(),
                                      
                                      const SizedBox(height: AppDimensions.spacingMd),
                                      
                                      // Link "Esqueci minha senha"
                                      _buildForgotPasswordLink(authController),
                                      
                                      // Mensagem de erro
                                      if (authController.errorMessage != null) ...[
                                        const SizedBox(height: AppDimensions.spacingMd),
                                        _buildErrorMessage(authController.errorMessage!),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
            } else {
              // Layout para mobile/portrait (layout original com ilustração de fundo)
              return Stack(
                children: [
                  // Ilustração de fundo centralizada com efeito de esfumaçamento nas bordas
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 2.4,
                      height: (MediaQuery.of(context).size.width * 2.4) * (9/16),
                      child: ShaderMask(
                         shaderCallback: (Rect bounds) {
                           return LinearGradient(
                             begin: Alignment.centerLeft,
                             end: Alignment.centerRight,
                             colors: const [
                               Colors.transparent,
                               Colors.white,
                               Colors.white,
                               Colors.transparent,
                             ],
                             stops: const [0.0, 0.2, 0.8, 1.0],
                           ).createShader(bounds);
                         },
                         blendMode: BlendMode.dstIn,
                         child: ShaderMask(
                           shaderCallback: (Rect bounds) {
                             return RadialGradient(
                               center: Alignment.center,
                               radius: 0.8,
                               colors: const [
                                 Colors.white,
                                 Colors.white,
                                 Colors.transparent,
                               ],
                               stops: const [0.0, 0.6, 1.0],
                             ).createShader(bounds);
                           },
                           blendMode: BlendMode.dstIn,
                           child: Opacity(
                             opacity: 0.3,
                             child: SvgPicture.asset(
                               'assets/20250719_1213_Volunteer Aid Collaboration_simple_compose_01k0hq9640ftgv3zp47z8wjzzq.svg',
                               fit: BoxFit.contain,
                             ),
                           ),
                         ),
                       ),
                     ),
                   ),
                  // Conteúdo principal
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(AppDimensions.paddingLg),
                    child: Column(
                      children: [
                        const SizedBox(height: AppDimensions.spacingXxl),
                        
                        // Logo centralizado
                        _buildLogo(),
                        
                        const SizedBox(height: AppDimensions.spacingXxl),
                        
                        // Formulário de login
                        _buildLoginForm(authController),
                        
                        const SizedBox(height: AppDimensions.spacingLg),
                        
                        // Botão "Entrar com Google"
                        _buildGoogleSignInButton(authController),
                        
                        const SizedBox(height: AppDimensions.spacingLg),
                        
                        // Link "Criar conta"
                        _buildCreateAccountLink(),
                        
                        const SizedBox(height: AppDimensions.spacingMd),
                        
                        // Link "Esqueci minha senha"
                        _buildForgotPasswordLink(authController),
                        
                        // Mensagem de erro
                        if (authController.errorMessage != null) ...[
                          const SizedBox(height: AppDimensions.spacingMd),
                          _buildErrorMessage(authController.errorMessage!),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowMedium,
                blurRadius: AppDimensions.elevationMd,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.volunteer_activism,
            size: 60,
            color: AppColors.textOnPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        const Text(
          AppStrings.appName,
          style: TextStyle(
            fontSize: AppDimensions.fontSizeHeading,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        const Text(
          AppStrings.appDescription,
          style: TextStyle(
            fontSize: AppDimensions.fontSizeMd,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm(AuthController authController) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
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
            onSubmitted: (_) => _handleLogin(authController),
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Botão de login
          CustomButton.primary(
            text: AppStrings.login,
            onPressed: () => _handleLogin(authController),
            isLoading: authController.isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleSignInButton(AuthController authController) {
    return CustomButton.google(
      text: AppStrings.loginWithGoogle,
      onPressed: () => _handleGoogleSignIn(authController),
      isLoading: authController.isLoading,
    );
  }

  Widget _buildCreateAccountLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          AppStrings.dontHaveAccount,
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: AppDimensions.fontSizeMd,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        GestureDetector(
          onTap: _navigateToRegister,
          child: const Text(
            AppStrings.register,
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

  Widget _buildForgotPasswordLink(AuthController authController) {
    return GestureDetector(
      onTap: () => _handleForgotPassword(authController),
      child: const Text(
        'Esqueci minha senha',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: AppDimensions.fontSizeSm,
          fontWeight: FontWeight.w500,
        ),
      ),
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

  Future<void> _handleLogin(AuthController authController) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await authController.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      // Navegar para a tela principal
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<void> _handleGoogleSignIn(AuthController authController) async {
    final success = await authController.signInWithGoogle();

    if (success && mounted) {
      // Navegar para a tela principal
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void _navigateToRegister() {
    Navigator.of(context).pushNamed('/register');
  }

  Future<void> _handleForgotPassword(AuthController authController) async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSnackBar('Digite seu e-mail para redefinir a senha');
      return;
    }

    final success = await authController.sendPasswordResetEmail(email);

    if (success && mounted) {
      _showSnackBar('E-mail de redefinição enviado com sucesso!');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
    );
  }
}
