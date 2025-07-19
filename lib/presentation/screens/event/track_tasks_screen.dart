import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/task_model.dart';
import '../../controllers/task_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/event_controller.dart';
import '../../controllers/task_controller.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/skill_chip.dart';
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

class _TrackTasksScreenState extends State<TrackTasksScreen> with AutomaticKeepAliveClientMixin {
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Consumer<TaskController>(
      builder: (context, taskController, child) {
        if (taskController.isLoading) {
          return const LoadingWidget(message: 'Carregando tasks...');
        }

        final allTasks = taskController.tasks;
        final filteredTasks = _getFilteredTasks(allTasks);

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
                          _buildTasksList(allTasks, taskController),
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
          'Tasks da Campanha',
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
    final pendingMicrotasks = microtasks.where((m) => m.status == MicrotaskStatus.pending).length;

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
          if (microtask.assignedTo.isNotEmpty)
            GestureDetector(
              onTap: () => _showAssignedVolunteers(microtask),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.people,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
            ),
          const SizedBox(width: 8),
          Text(
            microtask.status.toString().split('.').last,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
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
        ],
      ),
    );
  }

  /// Constrói o botão de atribuição automática
  Widget _buildAutoAssignButton(TaskModel task) {
    return Consumer2<AuthController, EventController>(
      builder: (context, authController, eventController, child) {
        final currentUser = authController.currentUser;
        final isManager = eventController.currentEvent?.isManager(currentUser?.id ?? '') ?? false;
        
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
        final taskController = Provider.of<TaskController>(context, listen: false);
        await taskController.loadTasksWithFilters(eventId: widget.eventId);
      } else {
        _showInfoDialog('Nenhuma microtask foi atribuída. Verifique se há voluntários disponíveis e microtasks pendentes.');
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
            Text('$assignedCount microtask(s) foram atribuídas automaticamente.'),
            const SizedBox(height: 16),
            if (assignments.isNotEmpty) ...[  
               const Text(
                 'Resumo das atribuições:',
                 style: TextStyle(fontWeight: FontWeight.bold),
               ),
              const SizedBox(height: 8),
              ...assignments.take(3).map((assignment) {
                final microtaskTitle = assignment['microtaskTitle'] as String;
                final volunteers = assignment['assignedVolunteers'] as List<dynamic>;
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
                  style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
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
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
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
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final volunteer = volunteers[index];
                            return ListTile(
                              dense: true,
                              leading: CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.primary.withOpacity(0.1),
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
        ],
      ),
    );
  }

  /// Busca informações dos voluntários pelos IDs
  Future<List<Map<String, String>>> _getVolunteersInfo(List<String> userIds) async {
    try {
      final eventController = Provider.of<EventController>(context, listen: false);
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
}
