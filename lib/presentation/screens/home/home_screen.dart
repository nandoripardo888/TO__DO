import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/custom_button.dart';

/// Tela home temporária para testar a autenticação
/// Será substituída pela implementação completa na Fase 2
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.home),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: Consumer<AuthController>(
        builder: (context, authController, child) {
          final user = authController.currentUser;
          
          return Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Saudação ao usuário
                _buildWelcomeSection(user?.name ?? 'Usuário'),
                
                const SizedBox(height: AppDimensions.spacingLg),
                
                // Informações do usuário
                _buildUserInfo(user),
                
                const SizedBox(height: AppDimensions.spacingLg),
                
                // Botões de ação temporários
                _buildActionButtons(context),
                
                const Spacer(),
                
                // Botão de logout
                CustomButton.outline(
                  text: AppStrings.logout,
                  onPressed: () => _handleLogout(context),
                  isLoading: authController.isLoading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection(String userName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bem-vindo!',
          style: const TextStyle(
            fontSize: AppDimensions.fontSizeHeading,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        Text(
          userName,
          style: const TextStyle(
            fontSize: AppDimensions.fontSizeXl,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        const Text(
          'Você está logado com sucesso no ConTask!',
          style: TextStyle(
            fontSize: AppDimensions.fontSizeMd,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo(dynamic user) {
    if (user == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMd),
          child: Text(
            'Informações do usuário não disponíveis',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: AppDimensions.elevationSm,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informações do Usuário',
              style: TextStyle(
                fontSize: AppDimensions.fontSizeLg,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            _buildInfoRow('Nome:', user.name),
            _buildInfoRow('E-mail:', user.email),
            _buildInfoRow('ID:', user.id),
            if (user.hasPhoto)
              _buildInfoRow('Foto:', 'Disponível')
            else
              _buildInfoRow('Foto:', 'Não disponível'),
            _buildInfoRow('Usuário novo:', user.isNewUser ? 'Sim' : 'Não'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Próximas funcionalidades:',
          style: TextStyle(
            fontSize: AppDimensions.fontSizeLg,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        CustomButton.outline(
          text: 'Criar Evento',
          onPressed: null, // Será implementado na Fase 2
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        CustomButton.outline(
          text: 'Participar de Evento',
          onPressed: null, // Será implementado na Fase 2
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        CustomButton.outline(
          text: 'Meus Eventos',
          onPressed: null, // Será implementado na Fase 2
        ),
      ],
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final authController = Provider.of<AuthController>(context, listen: false);
    
    await authController.signOut();
    
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    }
  }
}
