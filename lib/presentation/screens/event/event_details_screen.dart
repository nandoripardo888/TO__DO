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
import 'manage_volunteers_screen.dart';
import 'track_tasks_screen.dart';

/// Tela de detalhes do evento com sistema de tabs
class EventDetailsScreen extends StatefulWidget {
  final String eventId;

  const EventDetailsScreen({super.key, required this.eventId});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  EventModel? _event;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadEventDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEventTab(),
                _buildManageVolunteersTab(),
                _buildTrackTasksTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(_event!.name),
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadEventDetails,
          tooltip: 'Atualizar',
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUserId = authController.currentUser?.id;
    final isManager = _event!.isManager(currentUserId ?? '');

    return Container(
      color: AppColors.primary,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.textOnPrimary,
        labelColor: AppColors.textOnPrimary,
        unselectedLabelColor: AppColors.textOnPrimary.withOpacity(0.7),
        tabs: [
          const Tab(icon: Icon(Icons.info_outline), text: 'Evento'),
          if (isManager)
            const Tab(icon: Icon(Icons.people), text: 'Voluntários'),
          const Tab(icon: Icon(Icons.track_changes), text: 'Acompanhar'),
        ],
      ),
    );
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
                color: AppColors.secondary.withOpacity(0.1),
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
        color: AppColors.primary.withOpacity(0.1),
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

  Widget? _buildFloatingActionButton() {
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUserId = authController.currentUser?.id;
    final isManager = _event?.isManager(currentUserId ?? '') ?? false;

    if (!isManager) return null;

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
}
