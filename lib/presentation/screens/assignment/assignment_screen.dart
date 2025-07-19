import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/volunteer_profile_model.dart';
import '../../../data/models/microtask_model.dart';
import '../../../data/models/task_model.dart';
import '../../controllers/task_controller.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/assignment/volunteer_header.dart';
import '../../widgets/assignment/microtask_assignment_card.dart';
import '../../widgets/assignment/empty_microtasks_widget.dart';

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

class _AssignmentScreenState extends State<AssignmentScreen>
    with TickerProviderStateMixin {
  List<MicrotaskModel> _availableMicrotasks = [];
  List<TaskModel> _tasks = [];
  bool _isLoading = true;
  String _searchQuery = '';
  late AnimationController _listAnimationController;
  late Animation<double> _listAnimation;

  @override
  void initState() {
    super.initState();
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _listAnimation = CurvedAnimation(
      parent: _listAnimationController,
      curve: Curves.easeInOut,
    );
    _loadMicrotasks();
  }

  @override
  void dispose() {
    _listAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadMicrotasks() async {
    try {
      final taskController = Provider.of<TaskController>(
        context,
        listen: false,
      );

      // Carrega tasks da Campanha
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
          VolunteerHeader(
            volunteer: widget.volunteer,
            volunteerProfile: widget.volunteerProfile,
          ),
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

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingSm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Buscar microtasks...',
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            vertical: AppDimensions.paddingSm,
            horizontal: AppDimensions.paddingMd,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.trim();
          });
        },
      ),
    );
  }

  Widget _buildMicrotasksList() {
    final filteredMicrotasks = _getFilteredMicrotasks();

    if (filteredMicrotasks.isEmpty) {
      return const EmptyMicrotasksWidget();
    }

    return AnimatedList(
      padding: const EdgeInsets.only(
        top: AppDimensions.paddingMd,
        bottom: AppDimensions.paddingLg,
      ),
      initialItemCount: filteredMicrotasks.length,
      itemBuilder: (context, index, animation) {
        if (index >= filteredMicrotasks.length) {
          return const SizedBox.shrink();
        }

        final microtask = filteredMicrotasks[index];
        final task = _getTaskForMicrotask(microtask.taskId);

        return SlideTransition(
          position: animation.drive(
            Tween(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOut)),
          ),
          child: FadeTransition(
            opacity: animation,
            child: _buildMicrotaskAssignmentCard(microtask, task),
          ),
        );
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

  Widget _buildMicrotaskAssignmentCard(
    MicrotaskModel microtask,
    TaskModel? task,
  ) {
    // Verifica compatibilidade do voluntário com a microtask
    bool isCompatible = true;
    if (widget.volunteerProfile != null &&
        microtask.requiredSkills.isNotEmpty) {
      final volunteerSkills = widget.volunteerProfile!.skills;
      if (volunteerSkills.isEmpty) {
        isCompatible = false;
      } else {
        isCompatible = microtask.requiredSkills.any(
          (skill) => volunteerSkills.contains(skill),
        );
      }
    }

    final availableSlots =
        microtask.maxVolunteers - microtask.assignedTo.length;

    return Container(
      key: ValueKey('microtask_${microtask.id}'),
      child: MicrotaskAssignmentCard(
        microtask: microtask,
        task: task,
        isCompatible: isCompatible,
        availableSlots: availableSlots,
        maxVolunteers: microtask.maxVolunteers,
        volunteerProfile: widget.volunteerProfile,
        onAssign: () => _assignMicrotaskWithAnimation(microtask),
      ),
    );
  }

  // Atribui a microtask ao voluntário com animação
  Future<void> _assignMicrotaskWithAnimation(MicrotaskModel microtask) async {
    try {
      // Remove a microtask da lista local imediatamente para feedback visual
      final currentIndex = _availableMicrotasks.indexWhere(
        (m) => m.id == microtask.id,
      );
      if (currentIndex != -1) {
        setState(() {
          _availableMicrotasks.removeAt(currentIndex);
        });

        // Pequeno delay para mostrar a animação de remoção
        await Future.delayed(const Duration(milliseconds: 300));
      }

      final taskController = Provider.of<TaskController>(
        context,
        listen: false,
      );

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
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(AppDimensions.paddingMd),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

        // Volta para a tela anterior após um pequeno delay
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      // Se houve erro, restaura a microtask na lista
      if (mounted) {
        setState(() {
          _availableMicrotasks = _sortMicrotasksByCompatibility([
            ..._availableMicrotasks,
            microtask,
          ]);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atribuir microtask: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(AppDimensions.paddingMd),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  // Método original mantido para compatibilidade
  Future<void> _assignMicrotask(MicrotaskModel microtask) async {
    return _assignMicrotaskWithAnimation(microtask);
  }
}
