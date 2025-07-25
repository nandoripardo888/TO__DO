import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/volunteer_profile_model.dart';
import '../../../data/services/event_service.dart';
import '../../../data/services/assignment_service.dart';
import '../../controllers/task_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/event_controller.dart';
import '../../controllers/task_controller.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/volunteer/volunteer_profile_dialog.dart';

import '../../widgets/task/task_card.dart';
import '../../widgets/task/microtask_card.dart';
import '../../widgets/task/task_progress_widget.dart';
import '../../../data/models/microtask_model.dart';

/// Tela para acompanhamento de tasks (implementação básica)
class TrackTasksScreen extends StatefulWidget {
  final String eventId;

  const TrackTasksScreen({super.key, required this.eventId});

  @override
  State<TrackTasksScreen> createState() => _TrackTasksScreenState();
}

class _TrackTasksScreenState extends State<TrackTasksScreen>
    with AutomaticKeepAliveClientMixin {
  final Set<String> _expandedTasks = {};
  String _searchQuery = '';
  bool _isAutoAssigning = false;
  String? _autoAssigningTaskId;
  bool _disposed = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Widget _buildFilterBar(TaskController controller) {
    return Row(
      children: [
        Text(
          'Filtros:',
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
                  isStatus: true,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  controller,
                  'Pendente',
                  TaskStatus.pending,
                  controller.statusFilter == TaskStatus.pending,
                  isStatus: true,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  controller,
                  'Em Andamento',
                  TaskStatus.inProgress,
                  controller.statusFilter == TaskStatus.inProgress,
                  isStatus: true,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  controller,
                  'Concluída',
                  TaskStatus.completed,
                  controller.statusFilter == TaskStatus.completed,
                  isStatus: true,
                ),
                const SizedBox(width: 16),
                _buildFilterChip(
                  controller,
                  'Baixa',
                  TaskPriority.low,
                  controller.priorityFilter == TaskPriority.low,
                  isStatus: false,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  controller,
                  'Média',
                  TaskPriority.medium,
                  controller.priorityFilter == TaskPriority.medium,
                  isStatus: false,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  controller,
                  'Alta',
                  TaskPriority.high,
                  controller.priorityFilter == TaskPriority.high,
                  isStatus: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    TaskController controller,
    String label,
    dynamic value,
    bool isSelected, {
    required bool isStatus,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (isStatus) {
          controller.setStatusFilter(selected ? value as TaskStatus? : null);
        } else {
          controller.setPriorityFilter(
            selected ? value as TaskPriority? : null,
          );
        }
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<TaskController>(
      builder: (context, taskController, child) {
        if (taskController.isLoading) {
          return const LoadingWidget(message: 'Carregando tasks...');
        }

        final allTasks = taskController.tasks;
        final filteredTasks = _getFilteredTasks(allTasks, taskController);

        return Column(
          children: [
            _buildSearchAndFilters(),
            Expanded(
              child: filteredTasks.isEmpty
                  ? _buildEmptyState()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(AppDimensions.paddingLg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(allTasks),
                          const SizedBox(height: AppDimensions.spacingLg),
                          _buildTasksList(filteredTasks, taskController),
                        ],
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  // Método setState seguro que verifica se o widget ainda está montado
  void setStateIfMounted(VoidCallback fn) {
    if (mounted && !_disposed) {
      setState(fn);
    }
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 64,
            color: AppColors.primary.withOpacity(0.5),
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          const Text(
            'Nenhuma Task Criada',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          const Text(
            'Ainda não há tasks criadas para esta campanha.\n\nVá para a aba "Criar Tasks" para começar a organizar o trabalho.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(List<TaskModel> tasks) {
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final totalMicrotasks = tasks.fold<int>(
      0,
      (sum, task) => sum + task.microtaskCount,
    );
    final completedMicrotasks = tasks.fold<int>(
      0,
      (sum, task) => sum + task.completedMicrotasks,
    );

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
                  'Progresso Geral',
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
                  child: _buildProgressItem(
                    'Tasks',
                    completedTasks,
                    totalTasks,
                    Icons.task_alt,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMd),
                Expanded(
                  child: _buildProgressItem(
                    'Microtasks',
                    completedMicrotasks,
                    totalMicrotasks,
                    Icons.checklist,
                    AppColors.success, // Sempre verde
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(
    String label,
    int completed,
    int total,
    IconData icon,
    Color color,
  ) {
    final progress = total > 0 ? completed / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            '$completed/$total',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.success.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            '${(progress * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList(List<TaskModel> tasks, TaskController taskController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tasks da campanha',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        ...tasks.map((task) => _buildTaskCard(task, taskController)),
      ],
    );
  }

  Widget _buildTaskCard(TaskModel task, TaskController taskController) {
    final microtasks = taskController.getMicrotasksByTaskId(task.id);
    final pendingMicrotasks = microtasks
        .where((m) => m.status == MicrotaskStatus.pending)
        .length;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      child: ExpansionTile(
        leading: _buildTaskStatusIcon(task),
        title: Text(
          task.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXs),
            Row(
              children: [
                _buildPriorityChip(task.priority),
                const SizedBox(width: AppDimensions.spacingSm),
                Text(
                  '${task.completedMicrotasks}/${task.microtaskCount} microtasks',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          // Botão de Atribuição Automática
          if (pendingMicrotasks > 0) _buildAutoAssignButton(task),
          if (microtasks.isEmpty)
            const Padding(
              padding: EdgeInsets.all(AppDimensions.paddingMd),
              child: Text(
                'Nenhuma microtask criada ainda',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ...microtasks.map((microtask) => _buildMicrotaskItem(microtask)),
        ],
      ),
    );
  }

  Widget _buildTaskStatusIcon(TaskModel task) {
    IconData icon;
    Color color;

    switch (task.status) {
      case TaskStatus.pending:
        icon = Icons.schedule;
        color = AppColors.warning;
        break;
      case TaskStatus.inProgress:
        icon = Icons.play_circle;
        color = AppColors.primary;
        break;
      case TaskStatus.completed:
        icon = Icons.check_circle;
        color = AppColors.success;
        break;
      case TaskStatus.cancelled:
        icon = Icons.cancel;
        color = AppColors.error;
        break;
    }

    return Icon(icon, color: color);
  }

  Widget _buildPriorityChip(TaskPriority priority) {
    Color color;
    String text;

    switch (priority) {
      case TaskPriority.high:
        color = AppColors.error;
        text = 'Alta';
        break;
      case TaskPriority.medium:
        color = AppColors.warning;
        text = 'Média';
        break;
      case TaskPriority.low:
        color = AppColors.success;
        text = 'Baixa';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMicrotaskItem(microtask) {
    return Consumer2<AuthController, EventController>(
      builder: (context, authController, eventController, child) {
        final currentUser = authController.currentUser;
        final isManager =
            eventController.currentEvent?.isManager(currentUser?.id ?? '') ??
            false;

        return ListTile(
          dense: true,
          leading: Icon(
            microtask.status == MicrotaskStatus.completed
                ? Icons.check_box
                : Icons.check_box_outline_blank,
            size: 16,
            color: microtask.status == MicrotaskStatus.completed
                ? AppColors.success
                : AppColors.textSecondary,
          ),
          title: Text(
            microtask.title,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          ),
          subtitle: Text(
            'Voluntários:  ${microtask.assignedTo.length}/${microtask.maxVolunteers}',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Só mostra o botão de voluntários se for gerenciador OU se há voluntários atribuídos
              if (isManager || microtask.assignedTo.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    if (microtask.assignedTo.isNotEmpty) {
                      _showAssignedVolunteers(microtask);
                    } else if (isManager) {
                      _showAssignVolunteersModal(microtask);
                    }
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: microtask.assignedTo.isNotEmpty 
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.error.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: microtask.assignedTo.isNotEmpty 
                            ? AppColors.primary.withOpacity(0.3)
                            : AppColors.error.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.people,
                      size: 16,
                      color: microtask.assignedTo.isNotEmpty 
                          ? AppColors.primary
                          : AppColors.error,
                    ),
                  ),
                ),
              if (isManager || microtask.assignedTo.isNotEmpty)
                const SizedBox(width: 8),
              Text(
                microtask.status.toString().split('.').last,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<TaskModel> _getFilteredTasks(
    List<TaskModel> tasks,
    TaskController controller,
  ) {
    // Primeiro aplica os filtros do controller
    List<TaskModel> filtered = controller.getFilteredTasks();

    // Depois aplica o filtro de busca
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((task) {
        final title = task.title.toLowerCase();
        final description = task.description.toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || description.contains(query);
      }).toList();
    }
    return filtered;
  }

  Widget _buildSearchAndFilters() {
    return Consumer<TaskController>(
      builder: (context, controller, child) {
        return Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Column(
            children: [
              // Barra de busca
              TextField(
                onChanged: (value) {
                  setStateIfMounted(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Buscar tasks...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMd,
                    vertical: AppDimensions.paddingSm,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              // Filtros
              _buildFilterBar(controller),
            ],
          ),
        );
      },
    );
  }

  /// Constrói o botão de atribuição automática
  Widget _buildAutoAssignButton(TaskModel task) {
    return Consumer2<AuthController, EventController>(
      builder: (context, authController, eventController, child) {
        final currentUser = authController.currentUser;
        final isManager =
            eventController.currentEvent?.isManager(currentUser?.id ?? '') ??
            false;

        // Só mostra o botão para gerentes
        if (!isManager) return const SizedBox.shrink();

        final isLoading = _isAutoAssigning && _autoAssigningTaskId == task.id;

        return Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : () => _handleAutoAssign(task),
              icon: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.auto_awesome, size: 18),
              label: Text(
                isLoading ? 'Atribuindo...' : 'Atribuição Automática',
                style: const TextStyle(fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMd,
                  vertical: AppDimensions.paddingSm,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Executa a atribuição automática de voluntários
  Future<void> _handleAutoAssign(TaskModel task) async {
    try {
      setStateIfMounted(() {
        _isAutoAssigning = true;
        _autoAssigningTaskId = task.id;
      });

      // Chamar a Cloud Function
      final functions = FirebaseFunctions.instance;
      final callable = functions.httpsCallable('autoAssignVolunteers');

      final result = await callable.call({
        'eventId': widget.eventId,
        'taskId': task.id,
      });

      final data = result.data as Map<String, dynamic>;
      final assignedCount = data['assignedCount'] as int;
      final assignments = data['assignments'] as List<dynamic>;

      if (!mounted || _disposed) return;

      // Mostrar resultado
      if (assignedCount > 0) {
        _showSuccessDialog(assignedCount, assignments);

        // Recarregar dados
        final taskController = Provider.of<TaskController>(
          context,
          listen: false,
        );
        await taskController.loadTasksWithFilters(eventId: widget.eventId);
      } else {
        _showInfoDialog(
          'Nenhuma microtask foi atribuída. Verifique se há voluntários disponíveis e microtasks pendentes.',
        );
      }
    } catch (e) {
      if (!mounted || _disposed) return;

      String errorMessage = 'Erro ao executar atribuição automática';
      if (e.toString().contains('Apenas gerentes')) {
        errorMessage = 'Apenas gerentes podem executar a atribuição automática';
      } else if (e.toString().contains('Nenhum voluntário')) {
        errorMessage = 'Nenhum voluntário encontrado na campanha';
      }

      _showErrorDialog(errorMessage);
    } finally {
      if (mounted && !_disposed) {
        setStateIfMounted(() {
          _isAutoAssigning = false;
          _autoAssigningTaskId = null;
        });
      }
    }
  }

  /// Mostra dialog de sucesso
  void _showSuccessDialog(int assignedCount, List<dynamic> assignments) {
    if (!mounted || _disposed) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success),
            SizedBox(width: 8),
            Text('Atribuição Concluída'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$assignedCount microtask(s) foram atribuídas automaticamente.',
            ),
            const SizedBox(height: 16),
            if (assignments.isNotEmpty) ...[
              const Text(
                'Resumo das atribuições:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...assignments.take(3).map((assignment) {
                final microtaskTitle = assignment['microtaskTitle'] as String;
                final volunteers =
                    assignment['assignedVolunteers'] as List<dynamic>;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '• $microtaskTitle: ${volunteers.length} voluntário(s)',
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              }),
              if (assignments.length > 3)
                Text(
                  '... e mais ${assignments.length - 3} microtask(s)',
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Mostra dialog de informação
  void _showInfoDialog(String message) {
    if (!mounted || _disposed) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Informação'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Mostra dialog de erro
  void _showErrorDialog(String message) {
    if (!mounted || _disposed) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: AppColors.error),
            SizedBox(width: 8),
            Text('Erro'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Mostra modal com voluntários atribuídos à microtask
  void _showAssignedVolunteers(microtask) {
    if (!mounted || _disposed) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.people, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Voluntários - ${microtask.title}',
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Consumer<EventController>(
            builder: (context, eventController, child) {
              return FutureBuilder<List<Map<String, String>>>(
                future: _getVolunteersInfo(microtask.assignedTo),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          'Erro ao carregar voluntários',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    );
                  }

                  final volunteers = snapshot.data ?? [];

                  if (volunteers.isEmpty) {
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          'Nenhum voluntário encontrado',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    );
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: volunteers.length > 4 ? 200 : null,
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: volunteers.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final volunteer = volunteers[index];
                            return ListTile(
                              dense: true,
                              leading: CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.primary.withOpacity(
                                  0.1,
                                ),
                                child: Text(
                                  volunteer['name']?.isNotEmpty == true
                                      ? volunteer['name']![0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                volunteer['name'] ?? 'Nome não disponível',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                volunteer['email'] ?? 'Email não disponível',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              onTap: () {
                                final userId = microtask.assignedTo[index];
                                _showVolunteerProfile(userId);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
          // Só mostra o botão "Atribuir Voluntários" para gerenciadores
          Consumer2<AuthController, EventController>(
            builder: (context, authController, eventController, child) {
              final currentUser = authController.currentUser;
              final isManager =
                  eventController.currentEvent?.isManager(currentUser?.id ?? '') ??
                  false;

              if (!isManager) return const SizedBox.shrink();

              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showAssignVolunteersModal(microtask);
                },
                child: const Text('Atribuir Voluntários'),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Busca informações dos voluntários pelos IDs
  Future<List<Map<String, String>>> _getVolunteersInfo(
    List<String> userIds,  ) async {
    try {
      final eventController = Provider.of<EventController>(
        context,
        listen: false,
      );
      final volunteers = <Map<String, String>>[];

      for (final userId in userIds) {
        try {
          // Busca o perfil do voluntário no evento atual
          final volunteerProfile = await eventController.getVolunteerProfile(
            userId,
            widget.eventId,
          );

          if (volunteerProfile != null) {
            volunteers.add({
              'name': volunteerProfile.userName.isNotEmpty
                  ? volunteerProfile.userName
                  : 'Nome não disponível',
              'email': volunteerProfile.userEmail.isNotEmpty
                  ? volunteerProfile.userEmail
                  : 'Email não disponível',
            });
          } else {
            volunteers.add({
              'name': 'Voluntário não encontrado',
              'email': 'Email não disponível',
            });
          }
        } catch (e) {
          volunteers.add({
            'name': 'Erro ao carregar',
            'email': 'Email não disponível',
          });
        }
      }

      return volunteers;
    } catch (e) {
      return [];
    }
  }

  /// Mostra o modal com o perfil completo do voluntário
  void _showVolunteerProfile(String userId) {
    if (!mounted || _disposed) return;

    VolunteerProfileDialog.show(
      context: context,
      userId: userId,
      eventId: widget.eventId,
    );
  }

  /// Mostra modal para atribuir voluntários à microtask (apenas para gerenciadores)
  void _showAssignVolunteersModal(microtask) {
    if (!mounted || _disposed) return;

    // Verifica se o usuário é gerenciador antes de mostrar o modal
    final authController = Provider.of<AuthController>(context, listen: false);
    final eventController = Provider.of<EventController>(context, listen: false);
    final currentUser = authController.currentUser;
    final isManager = eventController.currentEvent?.isManager(currentUser?.id ?? '') ?? false;

    if (!isManager) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Apenas gerenciadores podem atribuir voluntários'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => _AssignVolunteersModal(
        microtask: microtask,
        eventId: widget.eventId,
        onVolunteerAssigned: () async {
          // Recarrega a lista de microtasks após atribuição
          final taskController = Provider.of<TaskController>(context, listen: false);
          await taskController.loadTasksWithFilters(eventId: widget.eventId);
        },
      ),
    );
  }
}

/// Modal para atribuir voluntários disponíveis à microtask
class _AssignVolunteersModal extends StatefulWidget {
  final dynamic microtask;
  final String eventId;
  final VoidCallback onVolunteerAssigned;

  const _AssignVolunteersModal({
    required this.microtask,
    required this.eventId,
    required this.onVolunteerAssigned,
  });

  @override
  State<_AssignVolunteersModal> createState() => _AssignVolunteersModalState();
}

class _AssignVolunteersModalState extends State<_AssignVolunteersModal> {
  final EventService _eventService = EventService();
  final AssignmentService _assignmentService = AssignmentService();
  
  List<VolunteerProfileModel> _availableVolunteers = [];
  Set<String> _selectedVolunteers = {};
  bool _isLoading = true;
  bool _isAssigning = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAvailableVolunteers();
  }

  Future<void> _loadAvailableVolunteers() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Busca todos os voluntários do evento
      final allVolunteers = await _eventService.getEventVolunteerProfiles(widget.eventId);
      
      // Filtra voluntários que ainda não estão atribuídos à microtask
      final availableVolunteers = allVolunteers
          .where((volunteer) => !widget.microtask.assignedTo.contains(volunteer.userId))
          .toList();

      if (mounted) {
        setState(() {
          _availableVolunteers = availableVolunteers;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _assignSelectedVolunteers() async {
    if (_selectedVolunteers.isEmpty) return;

    try {
      setState(() {
        _isAssigning = true;
      });

      // Atribui cada voluntário selecionado
      for (final userId in _selectedVolunteers) {
        await _assignmentService.assignVolunteerToMicrotask(
          microtaskId: widget.microtask.id,
          userId: userId,
          eventId: widget.eventId,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        widget.onVolunteerAssigned();
        
        // Mostra mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_selectedVolunteers.length} voluntário(s) atribuído(s) com sucesso!',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAssigning = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atribuir voluntários: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showVolunteerProfile(String userId) {
    VolunteerProfileDialog.show(
      context: context,
      userId: userId,
      eventId: widget.eventId,
    );
  }

  int get _maxSelectableVolunteers {
    final currentAssigned = widget.microtask.assignedTo.length;
    final maxVolunteers = widget.microtask.maxVolunteers;
    return maxVolunteers - currentAssigned;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.person_add, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Atribuir Voluntários - ${widget.microtask.title}',
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informações da microtask
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Voluntários: ${widget.microtask.assignedTo.length}/${widget.microtask.maxVolunteers}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  if (_maxSelectableVolunteers > 0)
                    Text(
                      'Você pode selecionar até $_maxSelectableVolunteers voluntário(s)',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  if (_maxSelectableVolunteers <= 0)
                    const Text(
                      'Esta microtask já atingiu o limite máximo de voluntários',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.error,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Lista de voluntários disponíveis
            Expanded(
              child: _buildVolunteersList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isAssigning ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isAssigning || _selectedVolunteers.isEmpty || _maxSelectableVolunteers <= 0
              ? null
              : _assignSelectedVolunteers,
          child: _isAssigning
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('Atribuir (${_selectedVolunteers.length})'),
        ),
      ],
    );
  }

  Widget _buildVolunteersList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar voluntários',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAvailableVolunteers,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_availableVolunteers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              color: AppColors.textSecondary,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'Nenhum voluntário disponível',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Todos os voluntários já estão atribuídos a esta microtask',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _availableVolunteers.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final volunteer = _availableVolunteers[index];
        final isSelected = _selectedVolunteers.contains(volunteer.userId);
        final canSelect = _selectedVolunteers.length < _maxSelectableVolunteers;

        return ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (canSelect || isSelected) ? (value) {
                  setState(() {
                    if (value == true) {
                      _selectedVolunteers.add(volunteer.userId);
                    } else {
                      _selectedVolunteers.remove(volunteer.userId);
                    }
                  });
                } : null,
              ),
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  volunteer.userName.isNotEmpty
                      ? volunteer.userName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            volunteer.userName.isNotEmpty
                ? volunteer.userName
                : 'Nome não disponível',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                volunteer.userEmail.isNotEmpty
                    ? volunteer.userEmail
                    : 'Email não disponível',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              if (volunteer.skills.isNotEmpty)
                Text(
                  'Habilidades: ${volunteer.skills.join(', ')}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
          onTap: () => _showVolunteerProfile(volunteer.userId),
          enabled: canSelect || isSelected,
        );
      },
    );
  }
}
