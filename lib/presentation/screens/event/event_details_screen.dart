import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/task_model.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/event_controller.dart';
import '../../controllers/task_controller.dart';
import '../../controllers/agenda_controller.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_message_widget.dart';
import '../../widgets/common/custom_app_bar.dart';

import '../../widgets/common/skill_chip.dart';
import 'manage_volunteers_screen.dart';
import 'track_tasks_screen.dart';
import '../profile/my_volunteer_profile_screen.dart';
import '../agenda/agenda_screen.dart';

/// Tela de detalhes da Campanha com sistema de tabs
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
    if (!mounted) return 3; // Default se o widget não estiver montado

    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUserId = authController.currentUser?.id;
    final isManager = _event!.isManager(currentUserId ?? '');
    final isVolunteer = _event!.isVolunteer(currentUserId ?? '');

    int count = 2; // campanha + Acompanhar (sempre visíveis)
    if (isVolunteer) count++; // AGENDA (RN-01.2: apenas para voluntários)
    if (isManager) count++; // Voluntários

    return count;
  }

  /// REQ-02: Atualiza o TabController quando a Campanha é carregado
  void _updateTabController() {
    if (!mounted) return;

    final newLength = _getTabCount();
    if (_tabController?.length != newLength) {
      _tabController?.dispose();
      _tabController = TabController(length: newLength, vsync: this);

      // Adiciona listener para detectar mudanças de aba
      _tabController?.addListener(() {
        if (mounted) {
          setState(() {}); // Força rebuild quando aba muda
          _handleTabChange();
        }
      });
    }
  }

  /// Gerencia streams com base na tab ativa
  void _handleTabChange() {
    if (_tabController == null || !mounted) return;

    // Verifica se os providers estão disponíveis (só após o MultiProvider ser criado)
    try {
      final authController = Provider.of<AuthController>(context, listen: false);
      final currentUserId = authController.currentUser?.id;
      final isVolunteer = _event?.isVolunteer(currentUserId ?? '') ?? false;

      // Índice da tab Agenda (pode variar dependendo das permissões)
      int agendaTabIndex = -1;
      if (isVolunteer) {
        agendaTabIndex = 1; // Campanha (0), Agenda (1), Tasks (2)
      }

      // Índice da tab TrackTasks (sempre a última)
      final trackTasksTabIndex = _tabController!.length - 1;

      // Gerencia streams da Agenda
      if (isVolunteer && agendaTabIndex >= 0) {
        final agendaController = Provider.of<AgendaController>(
          context,
          listen: false,
        );
        if (_tabController!.index == agendaTabIndex) {
          // Ativa streams da Agenda
          agendaController.resumeStreams();
        } else {
          // Pausa streams da Agenda
          agendaController.pauseStreams();
        }
      }

      // Gerencia streams do TrackTasks
      final taskController = Provider.of<TaskController>(context, listen: false);
      if (_tabController!.index == trackTasksTabIndex) {
        // Ativa streams do TrackTasks
        taskController.resumeStreams();
      } else {
        // Pausa streams do TrackTasks
        taskController.pauseStreams();
      }
    } catch (e) {
      // Providers ainda não estão disponíveis, ignora silenciosamente
      // Isso acontece durante o carregamento inicial
    }
  }

  Future<void> _loadEventDetails() async {
    try {
      if (!mounted) return;

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
        if (!mounted) return;

        setState(() {
          _event = event;
        });

        // REQ-02: Atualiza o TabController baseado nas permissões
        _updateTabController();

        // Carrega tasks da Campanha
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
          // Inicializa o gerenciamento de streams após carregar os dados
          _handleTabChange();
        }
      } else {
        if (!mounted) return;

        setState(() {
          _errorMessage = 'campanha não encontrado';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Erro ao carregar campanha: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: LoadingWidget(message: 'Carreganda Campanha...'),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Detalhes da Campanha'),
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
          title: const Text('Detalhes da Campanha'),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
        ),
        body: const Center(child: Text('campanha não encontrado')),
      );
    }

    // Fornece controllers necessários para as tabs
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AgendaController>(
          create: (context) => AgendaController(),
        ),
        ChangeNotifierProvider<TaskController>(
          create: (context) => TaskController(),
        ),
      ],
      child: Scaffold(
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
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUserId = authController.currentUser?.id;
    final isVolunteer = _event?.isVolunteer(currentUserId ?? '') ?? false;
    final isManager = _event?.isManager(currentUserId ?? '') ?? false;

    return CustomAppBar(
      title: _event!.name,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadEventDetails,
          tooltip: 'Atualizar',
        ),
        if (isVolunteer || isManager)
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _navigateToProfileScreen,
            tooltip: 'Perfil',
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
    // RN-01.1: Ordem das tabs: "campanha" → "AGENDA" → "Acompanhar"
    final tabs = <Widget>[
      const Tab(icon: Icon(Icons.info_outline), text: 'campanha'),
      if (isVolunteer) const Tab(icon: Icon(Icons.assignment), text: 'Agenda'),
      if (isManager) const Tab(icon: Icon(Icons.people), text: 'Voluntários'),
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

    // AgendaController já está disponível no contexto superior
    return AgendaScreen(eventId: widget.eventId);
  }

  Widget _buildTrackTasksTab() {
    // TaskController já está disponível no contexto superior
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
                  'Informações da Campanha',
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
                  'Código da Campanha',
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
              'Compartilhe este código para que outros possam participar da Campanha',
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

  /// Verifica se a aba atual é a aba "campanha" (sempre índice 0)
  bool _isCurrentTabEvent() {
    return _tabController?.index == 0;
  }

  /// REQ-04: Navega para a tela de edição da Campanha
  void _navigateToEditEvent() {
    if (_event == null) return;

    Navigator.pushNamed(
      context,
      '/create-event',
      arguments: _event, // Passa a Campanha atual como argumento para edição
    ).then((_) {
      // Recarrega os dados da Campanha após retornar da edição
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

    // Aba "campanha": mostra botão de edição + botão de adicionar tasks (apenas para gerenciadores)
    if (_isCurrentTabEvent()) {
      // Apenas gerenciadores podem editar a Campanha e criar tasks
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
        // Voluntários não veem nenhum FAB na aba "campanha"
        return null;
      }
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

  void _navigateToProfileScreen() {
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUserId = authController.currentUser?.id;

    if (currentUserId == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyVolunteerProfileScreen(
          eventId: _event!.id,
          userId: currentUserId,
          isEditMode: false,
          showAppBar: true,
        ),
      ),
    ).then((_) {
      // Verifica se o widget ainda está montado antes de chamar _loadEventDetails
      if (mounted) {
        _loadEventDetails();
      }
    });
  }
}
