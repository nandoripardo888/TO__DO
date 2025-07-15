import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/volunteer_profile_model.dart';
import '../../../data/models/microtask_model.dart';
import '../../../data/models/task_model.dart';
import '../../controllers/task_controller.dart';
import '../../widgets/common/loading_widget.dart';

/// Tela dedicada para atribuição de microtasks a voluntários
class AssignmentScreen extends StatefulWidget {
  final String eventId;
  final UserModel volunteer;
  final VolunteerProfileModel? volunteerProfile;

  const AssignmentScreen({
    super.key,
    required this.eventId,
    required this.volunteer,
    this.volunteerProfile,
  });

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  List<MicrotaskModel> _availableMicrotasks = [];
  List<TaskModel> _tasks = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadMicrotasks();
  }

  Future<void> _loadMicrotasks() async {
    try {
      final taskController = Provider.of<TaskController>(
        context,
        listen: false,
      );

      // Carrega tasks do evento
      await taskController.loadTasksByEventId(widget.eventId);

      // Coleta todas as microtasks disponíveis
      final availableMicrotasks = <MicrotaskModel>[];
      for (final task in taskController.tasks) {
        final microtasks = taskController.getMicrotasksByTaskId(task.id);
        availableMicrotasks.addAll(
          microtasks.where(
            (m) =>
                m.status != MicrotaskStatus.completed &&
                m.status != MicrotaskStatus.cancelled &&
                m.assignedTo.length < m.maxVolunteers &&
                !m.assignedTo.contains(widget.volunteer.id),
          ),
        );
      }

      if (mounted) {
        setState(() {
          _tasks = taskController.tasks;
          _availableMicrotasks = _sortMicrotasksByCompatibility(
            availableMicrotasks,
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar microtasks: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  // Ordena microtasks por compatibilidade com as habilidades do voluntário
  List<MicrotaskModel> _sortMicrotasksByCompatibility(
    List<MicrotaskModel> microtasks,
  ) {
    if (widget.volunteerProfile == null) return microtasks;

    final volunteerSkills = widget.volunteerProfile!.skills;

    // Separa microtasks compatíveis e não compatíveis
    final compatible = <MicrotaskModel>[];
    final notCompatible = <MicrotaskModel>[];

    for (final microtask in microtasks) {
      if (microtask.requiredSkills.isEmpty ||
          microtask.requiredSkills.any(
            (skill) => volunteerSkills.contains(skill),
          )) {
        compatible.add(microtask);
      } else {
        notCompatible.add(microtask);
      }
    }

    // Ordena compatíveis por número de habilidades em comum (mais compatíveis primeiro)
    compatible.sort((a, b) {
      final aMatches = a.requiredSkills
          .where((skill) => volunteerSkills.contains(skill))
          .length;
      final bMatches = b.requiredSkills
          .where((skill) => volunteerSkills.contains(skill))
          .length;
      return bMatches.compareTo(aMatches);
    });

    return [...compatible, ...notCompatible];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atribuir Microtask'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          Expanded(
            child: _isLoading
                ? const LoadingWidget(message: 'Carregando microtasks...')
                : _buildMicrotasksList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: widget.volunteer.photoUrl != null
                ? NetworkImage(widget.volunteer.photoUrl!)
                : null,
            child: widget.volunteer.photoUrl == null
                ? Text(
                    widget.volunteer.name.isNotEmpty
                        ? widget.volunteer.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.volunteer.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Selecione uma microtask para atribuir',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (widget.volunteerProfile != null &&
                    widget.volunteerProfile!.skills.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Habilidades: ${widget.volunteerProfile!.skills.join(', ')}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Buscar microtasks...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMd,
            vertical: AppDimensions.paddingSm,
          ),
        ),
      ),
    );
  }

  Widget _buildMicrotasksList() {
    final filteredMicrotasks = _getFilteredMicrotasks();

    if (filteredMicrotasks.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingSm),
      itemCount: filteredMicrotasks.length,
      itemBuilder: (context, index) {
        final microtask = filteredMicrotasks[index];
        final task = _getTaskForMicrotask(microtask.taskId);
        return _buildMicrotaskAssignmentCard(microtask, task);
      },
    );
  }

  List<MicrotaskModel> _getFilteredMicrotasks() {
    if (_searchQuery.isEmpty) return _availableMicrotasks;

    return _availableMicrotasks.where((microtask) {
      final query = _searchQuery.toLowerCase();
      final task = _getTaskForMicrotask(microtask.taskId);

      return microtask.title.toLowerCase().contains(query) ||
          microtask.description.toLowerCase().contains(query) ||
          (task?.title.toLowerCase().contains(query) ?? false) ||
          microtask.requiredSkills.any(
            (skill) => skill.toLowerCase().contains(query),
          );
    }).toList();
  }

  TaskModel? _getTaskForMicrotask(String taskId) {
    try {
      return _tasks.firstWhere((task) => task.id == taskId);
    } catch (e) {
      return null;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          const Text(
            'Nenhuma microtask disponível',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          const Text(
            'Não há microtasks disponíveis para atribuição no momento.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMicrotaskAssignmentCard(
    MicrotaskModel microtask,
    TaskModel? task,
  ) {
    final isCompatible = _isVolunteerCompatible(microtask);
    final availableSlots =
        microtask.maxVolunteers - microtask.assignedTo.length;

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com título e task pai
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        microtask.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (task != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Task: ${task.title}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isCompatible)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 12, color: AppColors.success),
                        const SizedBox(width: 2),
                        Text(
                          'Compatível',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.success,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: AppDimensions.spacingMd),

            // Descrição
            Text(
              microtask.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: AppDimensions.spacingMd),

            // Informações da microtask
            Wrap(
              spacing: AppDimensions.spacingSm,
              runSpacing: AppDimensions.spacingSm,
              children: [
                _buildInfoChip(
                  icon: Icons.schedule,
                  label: microtask.hasSchedule
                      ? microtask.periodFormatted
                      : 'Horário flexível',
                  color: AppColors.secondary,
                ),
                _buildInfoChip(
                  icon: Icons.people,
                  label: 'Vagas: $availableSlots de ${microtask.maxVolunteers}',
                  color: _getVacancyColor(
                    availableSlots,
                    microtask.maxVolunteers,
                  ),
                ),
                if (microtask.status != MicrotaskStatus.pending)
                  _buildInfoChip(
                    icon: Icons.info_outline,
                    label: _getStatusText(microtask.status),
                    color: _getStatusColor(microtask.status),
                  ),
              ],
            ),

            // Habilidades necessárias
            if (microtask.requiredSkills.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spacingMd),
              _buildSkillsSection(microtask),
            ],

            const SizedBox(height: AppDimensions.spacingMd),

            // Botão de atribuição
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: availableSlots > 0
                    ? () => _assignMicrotask(microtask)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompatible
                      ? AppColors.success
                      : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  availableSlots > 0
                      ? (isCompatible ? 'Atribuir (Compatível)' : 'Atribuir')
                      : 'Sem vagas disponíveis',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Verifica se o voluntário é compatível com a microtask
  bool _isVolunteerCompatible(MicrotaskModel microtask) {
    if (widget.volunteerProfile == null || microtask.requiredSkills.isEmpty) {
      return false;
    }

    final volunteerSkills = widget.volunteerProfile!.skills;
    return microtask.requiredSkills.any(
      (skill) => volunteerSkills.contains(skill),
    );
  }

  // Widget de chip informativo
  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
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

  // Cor baseada no número de vagas disponíveis
  Color _getVacancyColor(int available, int total) {
    final ratio = available / total;
    if (ratio > 0.5) return AppColors.success;
    if (ratio > 0.2) return AppColors.warning;
    return AppColors.error;
  }

  // Texto do status da microtask
  String _getStatusText(MicrotaskStatus status) {
    switch (status) {
      case MicrotaskStatus.pending:
        return 'Pendente';
      case MicrotaskStatus.assigned:
        return 'Atribuída';
      case MicrotaskStatus.inProgress:
        return 'Em andamento';
      case MicrotaskStatus.completed:
        return 'Concluída';
      case MicrotaskStatus.cancelled:
        return 'Cancelada';
    }
  }

  // Cor do status da microtask
  Color _getStatusColor(MicrotaskStatus status) {
    switch (status) {
      case MicrotaskStatus.pending:
        return AppColors.textSecondary;
      case MicrotaskStatus.assigned:
        return AppColors.primary;
      case MicrotaskStatus.inProgress:
        return AppColors.warning;
      case MicrotaskStatus.completed:
        return AppColors.success;
      case MicrotaskStatus.cancelled:
        return AppColors.error;
    }
  }

  // Seção de habilidades necessárias
  Widget _buildSkillsSection(MicrotaskModel microtask) {
    final volunteerSkills = widget.volunteerProfile?.skills ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Habilidades necessárias:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: microtask.requiredSkills.map((skill) {
            final hasSkill = volunteerSkills.contains(skill);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: hasSkill
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.textSecondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: hasSkill
                      ? AppColors.success.withOpacity(0.3)
                      : AppColors.textSecondary.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasSkill)
                    Icon(
                      Icons.check_circle,
                      size: 10,
                      color: AppColors.success,
                    ),
                  if (hasSkill) const SizedBox(width: 2),
                  Text(
                    skill,
                    style: TextStyle(
                      fontSize: 10,
                      color: hasSkill
                          ? AppColors.success
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Atribui a microtask ao voluntário
  Future<void> _assignMicrotask(MicrotaskModel microtask) async {
    try {
      final taskController = Provider.of<TaskController>(
        context,
        listen: false,
      );

      print("ABACAXI: assinando microtask");

      // Atribui a microtask
      await taskController.assignVolunteerToMicrotask(
        microtaskId: microtask.id,
        userId: widget.volunteer.id,
        eventId: widget.eventId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Microtask "${microtask.title}" atribuída com sucesso!',
            ),
            backgroundColor: AppColors.success,
          ),
        );

        // Volta para a tela anterior
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atribuir microtask: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
