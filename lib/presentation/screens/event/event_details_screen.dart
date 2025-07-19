import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/task_model.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/event_controller.dart';
import '../../controllers/task_controller.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_message_widget.dart';
import '../../widgets/common/custom_app_bar.dart';

import '../../widgets/common/skill_chip.dart';
import 'manage_volunteers_screen.dart';
import 'track_tasks_screen.dart';
import '../profile/my_volunteer_profile_screen.dart';
import '../agenda/agenda_screen.dart';

/// Tela de detalhes do evento com sistema de tabs
class EventDetailsScreen extends StatefulWidget {
  final String eventId;

  const EventDetailsScreen({super.key, required this.eventId});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  EventModel? _event;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadEventDetails();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  /// REQ-02: Calcula o número de tabs baseado nas permissões do usuário
  int _getTabCount() {
    if (_event == null) return 3; // Default

    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUserId = authController.currentUser?.id;
    final isManager = _event!.isManager(currentUserId ?? '');
    final isVolunteer = _event!.isVolunteer(currentUserId ?? '');

    int count = 2; // Evento + Acompanhar (sempre visíveis)
    if (isVolunteer) count++; // AGENDA (RN-01.2: apenas para voluntários)
    if (isManager) count++; // Voluntários
    if (isVolunteer) count++; // Perfil

    return count;
  }

  /// REQ-02: Atualiza o TabController quando o evento é carregado
  void _updateTabController() {
    final newLength = _getTabCount();
    if (_tabController?.length != newLength) {
      _tabController?.dispose();
      _tabController = TabController(length: newLength, vsync: this);

      // Adiciona listener para detectar mudanças de aba
      _tabController?.addListener(() {
        if (mounted) {
          setState(() {}); // Força rebuild quando aba muda
        }
      });
    }
  }

  Future<void> _loadEventDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final eventController = Provider.of<EventController>(
        context,
        listen: false,
      );
      final event = await eventController.loadEvent(widget.eventId);

      if (event != null) {
        setState(() {
          _event = event;
        });

        // REQ-02: Atualiza o TabController baseado nas permissões
        _updateTabController();

        // Carrega tasks do evento
        if (mounted) {
          final taskController = Provider.of<TaskController>(
            context,
            listen: false,
          );
          await taskController.loadTasksByEventId(widget.eventId);
        }

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Evento não encontrado';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar evento: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: LoadingWidget(message: 'Carregando evento...'),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Detalhes do Evento'),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
        ),
        body: ErrorMessageWidget(
          message: _errorMessage!,
          onRetry: _loadEventDetails,
        ),
      );
    }

    if (_event == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Detalhes do Evento'),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
        ),
        body: const Center(child: Text('Evento não encontrado')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _tabController == null
          ? const LoadingWidget(message: 'Carregando...')
          : Column(
              children: [
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController!,
                    children: _buildTabViews(),
                  ),
                ),
              ],
            ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      title: _event!.name,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadEventDetails,
          tooltip: 'Atualizar',
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _shareEvent(),
          tooltip: 'Compartilhar',
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUserId = authController.currentUser?.id;
    final isManager = _event!.isManager(currentUserId ?? '');
    final isVolunteer = _event!.isVolunteer(currentUserId ?? '');

    // REQ-02: Constrói lista de tabs dinamicamente baseada nas permissões
    // RN-01.1: Ordem das tabs: "Evento" → "AGENDA" → "Perfil" → "Acompanhar"
    final tabs = <Widget>[
      const Tab(icon: Icon(Icons.info_outline), text: 'Evento'),
      if (isVolunteer) const Tab(icon: Icon(Icons.assignment), text: 'Agenda'),
      if (isManager) const Tab(icon: Icon(Icons.people), text: 'Voluntários'),
      if (isVolunteer) const Tab(icon: Icon(Icons.person), text: 'Perfil'),
      const Tab(icon: Icon(Icons.track_changes), text: 'Tasks'),
    ];

    return Container(
      color: AppColors.primary,
      child: TabBar(
        controller: _tabController!,
        indicatorColor: AppColors.textOnPrimary,
        labelColor: AppColors.textOnPrimary,
        unselectedLabelColor: AppColors.textOnPrimary.withValues(alpha: 0.7),
        tabs: tabs,
      ),
    );
  }

  /// REQ-02: Constrói lista de views dinamicamente baseada nas permissões
  List<Widget> _buildTabViews() {
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUserId = authController.currentUser?.id;
    final isManager = _event!.isManager(currentUserId ?? '');
    final isVolunteer = _event!.isVolunteer(currentUserId ?? '');

    final views = <Widget>[
      _buildEventTab(),
      if (isVolunteer) _buildAgendaTab(),
      if (isManager) _buildManageVolunteersTab(),
      if (isVolunteer) _buildMyDataTab(),
      _buildTrackTasksTab(),
    ];

    return views;
  }

  Widget _buildEventTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEventInfoCard(),
          const SizedBox(height: AppDimensions.spacingLg),
          _buildEventStatsCard(),
          const SizedBox(height: AppDimensions.spacingLg),
          _buildEventCodeCard(),
        ],
      ),
    );
  }

  Widget _buildManageVolunteersTab() {
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUserId = authController.currentUser?.id;
    final isManager = _event!.isManager(currentUserId ?? '');

    if (!isManager) {
      return const Center(
        child: Text(
          'Apenas gerenciadores podem gerenciar voluntários',
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
      );
    }

    return ManageVolunteersScreen(eventId: widget.eventId);
  }

  /// REQ-02: Nova aba "Perfil" para gerenciamento do perfil de voluntário
  Widget _buildMyDataTab() {
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUserId = authController.currentUser?.id;

    if (currentUserId == null) {
      return const Center(
        child: Text(
          'Usuário não encontrado',
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
      );
    }

    // REQ-03: Usa a nova tela unificada de perfil de voluntário
    return MyVolunteerProfileScreen(
      eventId: widget.eventId,
      userId: currentUserId,
      isEditMode: false,
      showAppBar: false, // Não mostra app bar quando usado dentro da aba
    );
  }

  /// RN-01: Nova aba "AGENDA" para voluntários
  Widget _buildAgendaTab() {
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUserId = authController.currentUser?.id;
    final isVolunteer = _event!.isVolunteer(currentUserId ?? '');

    if (!isVolunteer) {
      return const Center(
        child: Text(
          'Apenas voluntários podem acessar a agenda',
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
      );
    }

    return AgendaScreen(eventId: widget.eventId);
  }

  Widget _buildTrackTasksTab() {
    return TrackTasksScreen(eventId: widget.eventId);
  }

  Widget _buildEventInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.primary),
                const SizedBox(width: AppDimensions.spacingSm),
                const Text(
                  'Informações do Evento',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            _buildInfoRow('Nome', _event!.name),
            _buildInfoRow('Descrição', _event!.description),
            _buildInfoRow('Localização', _event!.location),
            _buildInfoRow('Status', _getStatusText(_event!.status)),
            _buildInfoRow('Criado em', _formatDate(_event!.createdAt)),

            // Habilidades necessárias
            if (_event!.requiredSkills.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spacingMd),
              SkillChipList(
                title: 'Habilidades Necessárias',
                items: _event!.requiredSkills,
                itemIcon: Icons.star,
                chipColor: AppColors.primary,
                isSmall: true,
              ),
            ],

            // Recursos necessários
            if (_event!.requiredResources.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spacingMd),
              SkillChipList(
                title: 'Recursos Necessários',
                items: _event!.requiredResources,
                itemIcon: Icons.build,
                chipColor: AppColors.secondary,
                isSmall: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEventStatsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics_outlined, color: AppColors.primary),
                const SizedBox(width: AppDimensions.spacingSm),
                const Text(
                  'Estatísticas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Gerenciadores',
                    _event!.managers.length.toString(),
                    Icons.admin_panel_settings,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMd),
                Expanded(
                  child: _buildStatItem(
                    'Voluntários',
                    _event!.volunteers.length.toString(),
                    Icons.people,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Consumer<TaskController>(
              builder: (context, taskController, child) {
                final tasks = taskController.tasks;
                final totalMicrotasks = tasks.fold<int>(
                  0,
                  (sum, task) => sum + task.microtaskCount,
                );
                final completedMicrotasks = tasks.fold<int>(
                  0,
                  (sum, task) => sum + task.completedMicrotasks,
                );

                return Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        'Tasks',
                        tasks.length.toString(),
                        Icons.task_alt,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingMd),
                    Expanded(
                      child: _buildStatItem(
                        'Microtasks',
                        '$completedMicrotasks/$totalMicrotasks',
                        Icons.checklist,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCodeCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.qr_code, color: AppColors.primary),
                const SizedBox(width: AppDimensions.spacingSm),
                const Text(
                  'Código do Evento',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.secondary),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _event!.tag,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 2,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: AppColors.primary),
                    onPressed: () => _copyToClipboard(_event!.tag),
                    tooltip: 'Copiar código',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            const Text(
              'Compartilhe este código para que outros possam participar do evento',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
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
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getStatusText(EventStatus status) {
    switch (status) {
      case EventStatus.active:
        return 'Ativo';
      case EventStatus.completed:
        return 'Concluído';
      case EventStatus.cancelled:
        return 'Cancelado';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Verifica se a aba atual é a aba "Evento" (sempre índice 0)
  bool _isCurrentTabEvent() {
    return _tabController?.index == 0;
  }

  /// Verifica se a aba atual é a aba "Perfil"
  bool _isCurrentTabMyData() {
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUserId = authController.currentUser?.id;
    final isManager = _event?.isManager(currentUserId ?? '') ?? false;
    final isVolunteer = _event?.isVolunteer(currentUserId ?? '') ?? false;

    if (!isVolunteer) return false; // Aba só existe para voluntários

    final currentIndex = _tabController?.index ?? -1;

    // Calcula o índice esperado da aba "Perfil"
    int expectedIndex = 1; // Após "Evento"
    if (isVolunteer) expectedIndex++; // Se tem "AGENDA", incrementa
    if (isManager) expectedIndex++; // Se tem "Voluntários", incrementa

    return currentIndex == expectedIndex;
  }

  /// REQ-04: Navega para a tela de edição do evento
  void _navigateToEditEvent() {
    if (_event == null) return;

    Navigator.pushNamed(
      context,
      '/create-event',
      arguments: _event, // Passa o evento atual como argumento para edição
    ).then((_) {
      // Recarrega os dados do evento após retornar da edição
      _loadEventDetails();
    });
  }

  /// Navega para a tela de edição do perfil do voluntário
  void _navigateToEditProfile() {
    if (_event == null) return;

    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUserId = authController.currentUser?.id;

    if (currentUserId == null) return;

    // Navega para a tela de perfil em modo de edição
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyVolunteerProfileScreen(
          eventId: _event!.id,
          userId: currentUserId,
          isEditMode: true, // Inicia diretamente no modo de edição
          showAppBar:
              true, // Mostra app bar quando navegando para tela separada
        ),
      ),
    ).then((_) {
      // Recarrega os dados do evento após retornar da edição
      _loadEventDetails();
    });
  }

  Widget? _buildFloatingActionButton() {
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUserId = authController.currentUser?.id;
    final isManager = _event?.isManager(currentUserId ?? '') ?? false;
    final isVolunteer = _event?.isVolunteer(currentUserId ?? '') ?? false;

    // Mostra FAB se for gerenciador OU voluntário (para aba "Perfil")
    if (!isManager && !isVolunteer) return null;

    // Aba "Evento": mostra botão de edição + botão de adicionar tasks (apenas para gerenciadores)
    if (_isCurrentTabEvent()) {
      // Apenas gerenciadores podem editar o evento e criar tasks
      if (isManager) {
        return Consumer<TaskController>(
          builder: (context, taskController, child) {
            final tasks = taskController.tasks;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // FAB de edição (acima)
                FloatingActionButton(
                  heroTag: "edit_event_fab",
                  onPressed: _navigateToEditEvent,
                  backgroundColor: AppColors.secondary,
                  child: const Icon(Icons.edit, color: AppColors.textOnPrimary),
                ),
                const SizedBox(height: 16),
                // FAB de adicionar tasks (abaixo)
                FloatingActionButton(
                  heroTag: "add_task_fab",
                  onPressed: () => _showCreateOptionsDialog(tasks),
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.add, color: AppColors.textOnPrimary),
                ),
              ],
            );
          },
        );
      } else {
        // Voluntários não veem nenhum FAB na aba "Evento"
        return null;
      }
    }

    // Aba "Perfil": mostra apenas botão de edição do perfil
    if (_isCurrentTabMyData()) {
      return FloatingActionButton(
        heroTag: "edit_profile_fab",
        onPressed: _navigateToEditProfile,
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.edit, color: AppColors.textOnPrimary),
      );
    }

    // Aba "Voluntários": apenas FAB de adicionar tasks (apenas para gerenciadores)
    if (isManager) {
      return Consumer<TaskController>(
        builder: (context, taskController, child) {
          final tasks = taskController.tasks;
          return FloatingActionButton(
            onPressed: () => _showCreateOptionsDialog(tasks),
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add, color: AppColors.textOnPrimary),
          );
        },
      );
    }

    // Outras abas (AGENDA, Acompanhar): nenhum FAB para voluntários
    return null;
  }

  void _showCreateOptionsDialog(List<TaskModel> tasks) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('O que deseja criar?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.task_alt, color: AppColors.primary),
              title: const Text('Nova Task'),
              subtitle: const Text('Criar uma nova task organizadora'),
              onTap: () {
                Navigator.of(context).pop();
                _navigateToCreateTask();
              },
            ),
            if (tasks.isNotEmpty)
              ListTile(
                leading: const Icon(
                  Icons.checklist,
                  color: AppColors.secondary,
                ),
                title: const Text('Nova Microtask'),
                subtitle: const Text('Criar uma microtask dentro de uma task'),
                onTap: () {
                  Navigator.of(context).pop();
                  _navigateToCreateMicrotask();
                },
              )
            else
              ListTile(
                leading: Icon(Icons.checklist, color: Colors.grey[400]),
                title: Text(
                  'Nova Microtask',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                subtitle: const Text('É preciso criar uma task primeiro'),
                enabled: false,
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

  void _navigateToCreateTask() {
    Navigator.of(context).pushNamed('/create-task', arguments: widget.eventId);
  }

  void _navigateToCreateMicrotask() {
    Navigator.of(
      context,
    ).pushNamed('/create-microtask', arguments: widget.eventId);
  }

  void _copyToClipboard(String text) {
    // TODO: Implementar cópia para clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Código copiado para a área de transferência'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _shareEvent() {
    // TODO: Implementar compartilhamento do evento
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compartilhar evento: ${_event!.name} (${_event!.tag})'),
        backgroundColor: AppColors.warning,
        action: SnackBarAction(
          label: 'Copiar Código',
          onPressed: () => _copyToClipboard(_event!.tag),
        ),
      ),
    );
  }
}
