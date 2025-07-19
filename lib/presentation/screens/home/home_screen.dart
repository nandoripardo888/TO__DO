import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/event_controller.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/event/event_card.dart';
import '../../routes/app_routes.dart';

/// Tela home principal do aplicativo
/// Exibe lista de campanhas do usuário e opções para criar/participar de campanhas
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserEvents();
    });
  }

  void _loadUserEvents() {
    final authController = Provider.of<AuthController>(context, listen: false);
    final eventController = Provider.of<EventController>(
      context,
      listen: false,
    );

    if (authController.currentUser != null) {
      eventController.loadUserEvents(authController.currentUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Consumer2<AuthController, EventController>(
        builder: (context, authController, eventController, child) {
          final user = authController.currentUser;

          if (user == null) {
            return const Center(child: Text('Usuário não encontrado'));
          }

          return RefreshIndicator(
            onRefresh: () async => _loadUserEvents(),
            child: Column(
              children: [
                // Seção de boas-vindas
                _buildWelcomeSection(user.displayName),

                // Lista de campanhas
                Expanded(child: _buildEventsList(eventController)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      elevation: 0,
      title: const Text(
        'ConTask',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        Consumer<AuthController>(
          builder: (context, authController, child) {
            final user = authController.currentUser;

            return Padding(
              padding: const EdgeInsets.only(right: AppDimensions.paddingMd),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Foto do usuário ou iniciais
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.secondary,
                    backgroundImage: user?.hasPhoto == true
                        ? NetworkImage(user!.photoUrl!)
                        : null,
                    child: user?.hasPhoto != true
                        ? Text(
                            user?.initials ?? 'U',
                            style: const TextStyle(
                              color: AppColors.textOnPrimary,
                              fontSize: AppDimensions.fontSizeSm,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  // Menu de opções
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'logout') {
                        _handleLogout(context);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, size: 20),
                            SizedBox(width: AppDimensions.spacingSm),
                            Text('Sair'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(String userName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDimensions.radiusLg),
          bottomRight: Radius.circular(AppDimensions.radiusLg),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Olá, ${userName.split(' ').first}!',
            style: const TextStyle(
              fontSize: AppDimensions.fontSizeXl,
              fontWeight: FontWeight.bold,
              color: AppColors.textOnPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            'Gerencie suas campanhas e tarefas',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeMd,
              color: AppColors.textOnPrimary.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(EventController eventController) {
    if (eventController.isLoadingUserEvents) {
      return const Center(child: CircularProgressIndicator());
    }

    if (eventController.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              eventController.errorMessage ?? 'Erro desconhecido',
              style: const TextStyle(
                fontSize: AppDimensions.fontSizeMd,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            CustomButton.outline(
              text: 'Tentar novamente',
              onPressed: _loadUserEvents,
            ),
          ],
        ),
      );
    }

    if (eventController.userEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.event_note,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            const Text(
              'Nenhuma campanha encontrado',
              style: TextStyle(
                fontSize: AppDimensions.fontSizeLg,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            const Text(
              'Crie um nova Campanha ou participe de um existente',
              style: TextStyle(
                fontSize: AppDimensions.fontSizeMd,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            CustomButton(
              text: 'Criar campanha',
              onPressed: () => _navigateToCreateEvent(),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            CustomButton.outline(
              text: 'Participar de campanha',
              onPressed: () => _navigateToJoinEvent(),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      itemCount: eventController.userEvents.length,
      itemBuilder: (context, index) {
        final event = eventController.userEvents[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
          child: EventCard(
            event: event,
            onTap: () => _navigateToEventDetails(event.id),
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _showActionDialog(),
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.add, color: AppColors.textOnPrimary),
    );
  }

  void _showActionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('O que você gostaria de fazer?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add_circle, color: AppColors.primary),
              title: const Text('Criar campanha'),
              subtitle: const Text('Organize um nova Campanha'),
              onTap: () {
                Navigator.of(context).pop(); // Fecha o dialog
                _navigateToCreateEvent();
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add, color: AppColors.secondary),
              title: const Text('Participar de campanha'),
              subtitle: const Text('Entre em uma campanha existente'),
              onTap: () {
                Navigator.of(context).pop(); // Fecha o dialog
                _navigateToJoinEvent();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showActionBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLg),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Indicador visual
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),

            // Título
            const Text(
              'O que você gostaria de fazer?',
              style: TextStyle(
                fontSize: AppDimensions.fontSizeLg,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),

            // Opções
            ListTile(
              leading: const Icon(Icons.add_circle, color: AppColors.primary),
              title: const Text('Criar campanha'),
              subtitle: const Text('Organize um nova Campanha'),
              onTap: () {
                Navigator.pop(context);
                _navigateToCreateEvent();
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add, color: AppColors.secondary),
              title: const Text('Participar de campanha'),
              subtitle: const Text('Entre em uma campanha existente'),
              onTap: () {
                Navigator.pop(context);
                _navigateToJoinEvent();
              },
            ),

            const SizedBox(height: AppDimensions.spacingMd),
          ],
        ),
      ),
    );
  }

  void _navigateToCreateEvent() {
    AppRoutes.goToCreateEvent(context);
  }

  void _navigateToJoinEvent() {
    AppRoutes.goToJoinEvent(context);
  }

  void _navigateToEventDetails(String eventId) {
    AppRoutes.goToEventDetails(context, eventId);
  }

  Future<void> _handleLogout(BuildContext context) async {
    final authController = Provider.of<AuthController>(context, listen: false);

    await authController.signOut();

    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }
}
