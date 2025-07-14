import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/task_model.dart';
import '../../controllers/task_controller.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/skill_chip.dart';
import '../../widgets/task/task_card.dart';
import '../../widgets/task/microtask_card.dart';
import '../../widgets/task/task_progress_widget.dart';

/// Tela para acompanhamento de tasks (implementação básica)
class TrackTasksScreen extends StatefulWidget {
  final String eventId;

  const TrackTasksScreen({super.key, required this.eventId});

  @override
  State<TrackTasksScreen> createState() => _TrackTasksScreenState();
}

class _TrackTasksScreenState extends State<TrackTasksScreen> {
  final Set<String> _expandedTasks = {};
  String _searchQuery = '';
  TaskStatus? _statusFilter;
  TaskPriority? _priorityFilter;

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, taskController, child) {
        if (taskController.isLoading) {
          return const LoadingWidget(message: 'Carregando tasks...');
        }

        final allTasks = taskController.tasks;
        final filteredTasks = _getFilteredTasks(allTasks);

        if (filteredTasks.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          children: [
            _buildSearchAndFilters(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.paddingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(filteredTasks),
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
            'Ainda não há tasks criadas para este evento.\n\nVá para a aba "Criar Tasks" para começar a organizar o trabalho.',
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
                    AppColors.secondary,
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
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
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
          'Tasks do Evento',
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
    return ListTile(
      dense: true,
      leading: Icon(
        Icons.check_box_outline_blank,
        size: 16,
        color: AppColors.textSecondary,
      ),
      title: Text(
        microtask.title,
        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      ),
      subtitle: Text(
        'Voluntários: ${microtask.assignedTo.length}/${microtask.maxVolunteers}',
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      trailing: Text(
        microtask.status.toString().split('.').last,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
    );
  }

  List<TaskModel> _getFilteredTasks(List<TaskModel> tasks) {
    List<TaskModel> filtered = List.from(tasks);

    // Aplicar filtro de busca
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((task) {
        final title = task.title.toLowerCase();
        final description = task.description.toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || description.contains(query);
      }).toList();
    }

    // Aplicar filtro de status
    if (_statusFilter != null) {
      filtered = filtered
          .where((task) => task.status == _statusFilter)
          .toList();
    }

    // Aplicar filtro de prioridade
    if (_priorityFilter != null) {
      filtered = filtered
          .where((task) => task.priority == _priorityFilter)
          .toList();
    }

    return filtered;
  }

  Widget _buildSearchAndFilters() {
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
              setState(() {
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Text(
                  'Filtros:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingSm),

                // Filtro de status
                _buildStatusFilter(),
                const SizedBox(width: AppDimensions.spacingSm),

                // Filtro de prioridade
                _buildPriorityFilter(),

                // Botão limpar filtros
                if (_statusFilter != null || _priorityFilter != null) ...[
                  const SizedBox(width: AppDimensions.spacingSm),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _statusFilter = null;
                        _priorityFilter = null;
                      });
                    },
                    child: const Text('Limpar'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return PopupMenuButton<TaskStatus?>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _statusFilter != null
              ? AppColors.primary.withOpacity(0.1)
              : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.filter_list, size: 16),
            const SizedBox(width: 4),
            Text(
              _statusFilter != null ? _getStatusText(_statusFilter!) : 'Status',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(value: null, child: Text('Todos')),
        ...TaskStatus.values.map(
          (status) =>
              PopupMenuItem(value: status, child: Text(_getStatusText(status))),
        ),
      ],
      onSelected: (status) {
        setState(() {
          _statusFilter = status;
        });
      },
    );
  }

  Widget _buildPriorityFilter() {
    return PopupMenuButton<TaskPriority?>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _priorityFilter != null
              ? AppColors.primary.withOpacity(0.1)
              : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.priority_high, size: 16),
            const SizedBox(width: 4),
            Text(
              _priorityFilter != null
                  ? _getPriorityText(_priorityFilter!)
                  : 'Prioridade',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(value: null, child: Text('Todas')),
        ...TaskPriority.values.map(
          (priority) => PopupMenuItem(
            value: priority,
            child: Text(_getPriorityText(priority)),
          ),
        ),
      ],
      onSelected: (priority) {
        setState(() {
          _priorityFilter = priority;
        });
      },
    );
  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'Pendente';
      case TaskStatus.inProgress:
        return 'Em Progresso';
      case TaskStatus.completed:
        return 'Concluída';
      case TaskStatus.cancelled:
        return 'Cancelada';
    }
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 'Alta';
      case TaskPriority.medium:
        return 'Média';
      case TaskPriority.low:
        return 'Baixa';
    }
  }

  void _toggleTaskExpansion(String taskId) {
    setState(() {
      if (_expandedTasks.contains(taskId)) {
        _expandedTasks.remove(taskId);
      } else {
        _expandedTasks.add(taskId);
      }
    });
  }
}
