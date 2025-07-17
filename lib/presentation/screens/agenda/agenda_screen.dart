import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../controllers/agenda_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_message_widget.dart';
import '../../../data/models/user_microtask_model.dart';
import 'widgets/microtask_agenda_card.dart';

/// Tela principal da aba AGENDA para voluntários
/// Conforme especificação do PRD - REQ-01: Nova Aba "AGENDA"
class AgendaScreen extends StatefulWidget {
  final String eventId;

  const AgendaScreen({super.key, required this.eventId});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  late AgendaController _agendaController;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _agendaController = AgendaController();
    _loadAgenda();
  }

  @override
  void dispose() {
    _agendaController.dispose();
    super.dispose();
  }

  void _loadAgenda() {
    final authController = Provider.of<AuthController>(context, listen: false);
    _currentUserId = authController.currentUser?.id;

    if (_currentUserId != null) {
      _agendaController.loadAgenda(
        userId: _currentUserId!,
        eventId: widget.eventId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _agendaController,
      child: Consumer<AgendaController>(
        builder: (context, controller, child) {
          return _buildBody(controller);
        },
      ),
    );
  }

  Widget _buildBody(AgendaController controller) {
    switch (controller.state) {
      case AgendaControllerState.initial:
      case AgendaControllerState.loading:
        return const LoadingWidget(message: 'Carregando sua agenda...');

      case AgendaControllerState.error:
        return ErrorMessageWidget(
          message: controller.errorMessage ?? 'Erro ao carregar agenda',
          onRetry: _loadAgenda,
        );

      case AgendaControllerState.loaded:
        return _buildLoadedContent(controller);
    }
  }

  Widget _buildLoadedContent(AgendaController controller) {
    final userMicrotasks = controller.filteredUserMicrotasks;

    if (userMicrotasks.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildFilterBar(controller),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _refreshAgenda(controller),
            child: _buildMicrotasksList(userMicrotasks, controller),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: AppDimensions.spacingLg),
          Text(
            'Nenhuma microtask atribuída',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Text(
            'Você ainda não possui microtasks\natribuídas neste evento.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(AgendaController controller) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_list, color: Colors.grey[600], size: 20),
          const SizedBox(width: AppDimensions.spacingSm),
          Text(
            'Filtrar por status:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    controller,
                    'Todos',
                    null,
                    controller.statusFilter == null,
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  _buildFilterChip(
                    controller,
                    'Atribuída',
                    UserMicrotaskStatus.assigned,
                    controller.statusFilter == UserMicrotaskStatus.assigned,
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  _buildFilterChip(
                    controller,
                    'Em Andamento',
                    UserMicrotaskStatus.inProgress,
                    controller.statusFilter == UserMicrotaskStatus.inProgress,
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  _buildFilterChip(
                    controller,
                    'Concluída',
                    UserMicrotaskStatus.completed,
                    controller.statusFilter == UserMicrotaskStatus.completed,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    AgendaController controller,
    String label,
    UserMicrotaskStatus? status,
    bool isSelected,
  ) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        controller.setStatusFilter(selected ? status : null);
      },
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : Colors.grey[700],
        fontSize: 12,
      ),
    );
  }

  Widget _buildMicrotasksList(
    List<UserMicrotaskModel> userMicrotasks,
    AgendaController controller,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      itemCount: userMicrotasks.length,
      itemBuilder: (context, index) {
        final userMicrotask = userMicrotasks[index];
        final microtask = controller.getMicrotaskById(
          userMicrotask.microtaskId,
        );
        final task = microtask != null
            ? controller.getTaskById(microtask.taskId)
            : null;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
          child: MicrotaskAgendaCard(
            userMicrotask: userMicrotask,
            microtask: microtask,
            task: task,
            onStatusChanged: (newStatus) =>
                _handleStatusChange(controller, userMicrotask, newStatus),
          ),
        );
      },
    );
  }

  Future<void> _refreshAgenda(AgendaController controller) async {
    if (_currentUserId != null) {
      await controller.refresh(
        userId: _currentUserId!,
        eventId: widget.eventId,
      );
    }
  }

  Future<void> _handleStatusChange(
    AgendaController controller,
    UserMicrotaskModel userMicrotask,
    UserMicrotaskStatus newStatus,
  ) async {
    final success = await controller.updateUserMicrotaskStatus(
      userId: userMicrotask.userId,
      microtaskId: userMicrotask.microtaskId,
      status: newStatus,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.errorMessage ?? 'Erro ao atualizar status'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
