import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/volunteer_profile_model.dart';
import '../../../data/models/microtask_model.dart';
import '../../controllers/event_controller.dart';
import '../../controllers/task_controller.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/volunteer/volunteer_card.dart';
import '../../widgets/dialogs/assignment_dialog.dart';

/// Tela para gerenciamento de voluntários
class ManageVolunteersScreen extends StatefulWidget {
  final String eventId;

  const ManageVolunteersScreen({super.key, required this.eventId});

  @override
  State<ManageVolunteersScreen> createState() => _ManageVolunteersScreenState();
}

class _ManageVolunteersScreenState extends State<ManageVolunteersScreen> {
  EventModel? _event;
  List<UserModel> _volunteers = [];
  List<VolunteerProfileModel> _volunteerProfiles = [];
  List<MicrotaskModel> _availableMicrotasks = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _filterStatus = 'all'; // all, available, assigned

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final eventController = Provider.of<EventController>(
        context,
        listen: false,
      );
      final taskController = Provider.of<TaskController>(
        context,
        listen: false,
      );

      // Carrega evento
      final event = await eventController.loadEvent(widget.eventId);

      // Carrega tasks e microtasks
      await taskController.loadTasksByEventId(widget.eventId);

      // Carrega voluntários e perfis
      final volunteersData = await eventController.getEventVolunteersWithUsers(
        widget.eventId,
      );
      final volunteers = volunteersData['users'] as List<UserModel>;
      final profiles =
          volunteersData['profiles'] as List<VolunteerProfileModel>;

      // Se não há voluntários, você pode adicionar dados de teste aqui
      // _addTestVolunteers(); // Descomente para testar

      // Carrega microtasks disponíveis
      final availableMicrotasks = <MicrotaskModel>[];
      for (final task in taskController.tasks) {
        final microtasks = taskController.getMicrotasksByTaskId(task.id);
        availableMicrotasks.addAll(
          microtasks.where(
            (m) =>
                m.status != MicrotaskStatus.completed &&
                m.status != MicrotaskStatus.cancelled,
          ),
        );
      }

      if (mounted) {
        setState(() {
          _event = event;
          _volunteers = volunteers;
          _volunteerProfiles = profiles;
          _availableMicrotasks = availableMicrotasks;
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
            content: Text('Erro ao carregar dados: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingWidget(message: 'Carregando voluntários...');
    }

    if (_event == null) {
      return const Center(
        child: Text(
          'Erro ao carregar evento',
          style: TextStyle(fontSize: 16, color: AppColors.error),
        ),
      );
    }

    final filteredVolunteers = _getFilteredVolunteers();

    return Column(
      children: [
        // Header com busca e filtros
        _buildHeader(),

        // Lista de voluntários
        Expanded(
          child: filteredVolunteers.isEmpty
              ? _buildEmptyState()
              : _buildVolunteersList(filteredVolunteers),
        ),
      ],
    );
  }

  Widget _buildHeader() {
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
              hintText: 'Buscar voluntários...',
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
          Row(
            children: [
              const Text(
                'Filtrar:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSm),

              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Todos', 'all'),
                      const SizedBox(width: AppDimensions.spacingSm),
                      _buildFilterChip('Disponíveis', 'available'),
                      const SizedBox(width: AppDimensions.spacingSm),
                      _buildFilterChip('Com Tarefas', 'assigned'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterStatus == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterStatus = value;
        });
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          const Text(
            'Nenhum voluntário encontrado',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          const Text(
            'Compartilhe o código do evento para que\nvoluntários possam se inscrever.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppDimensions.spacingLg),

          // Código do evento
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.qr_code, color: AppColors.primary),
                const SizedBox(width: AppDimensions.spacingSm),
                Text(
                  'Código: ${_event?.tag ?? 'N/A'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVolunteersList(List<UserModel> volunteers) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingSm),
      itemCount: volunteers.length,
      itemBuilder: (context, index) {
        final volunteer = volunteers[index];
        final profile = _getVolunteerProfile(volunteer.id);

        return VolunteerCard(
          user: volunteer,
          profile: profile,
          isManager: true, // Supondo que esta tela seja para gerentes
          showActions: true,
          assignedMicrotasksCount: _getAssignedMicrotasksCount(volunteer.id),
          // Ação unificada que chama o novo diálogo de opções
          onShowActions: () => _showVolunteerActionsDialog(volunteer, profile),
        );
      },
    );
  }

  /// Exibe um diálogo com as ações disponíveis para um voluntário.
  void _showVolunteerActionsDialog(
    UserModel volunteer,
    VolunteerProfileModel? profile,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(volunteer.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.assignment_ind_outlined,
                color: AppColors.primary,
              ),
              title: const Text('Atribuir Microtask'),
              subtitle: const Text('Designar uma nova tarefa'),
              onTap: () {
                Navigator.of(context).pop(); // Fecha o diálogo de ações
                _showAssignmentDialog(
                  volunteer,
                  profile,
                ); // Abre o diálogo de atribuição
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.admin_panel_settings_outlined,
                color: AppColors.secondary,
              ),
              title: const Text('Promover a Gerente'),
              subtitle: const Text('Conceder permissões de gerenciamento'),
              onTap: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                _promoteToManager(volunteer);
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

  List<UserModel> _getFilteredVolunteers() {
    List<UserModel> filtered = List.from(_volunteers);

    // Aplicar filtro de busca
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((volunteer) {
        final name = volunteer.name.toLowerCase();
        final email = volunteer.email.toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || email.contains(query);
      }).toList();
    }

    // Aplicar filtro de status
    switch (_filterStatus) {
      case 'available':
        // Filtrar voluntários disponíveis hoje
        filtered = filtered.where((volunteer) {
          final profile = _getVolunteerProfile(volunteer.id);
          if (profile == null) return false;

          final currentDay = _getCurrentDayString();
          return profile.availableDays.contains(currentDay);
        }).toList();
        break;
      case 'assigned':
        // Filtrar voluntários com microtasks atribuídas
        filtered = filtered.where((volunteer) {
          return _getAssignedMicrotasksCount(volunteer.id) > 0;
        }).toList();
        break;
      case 'all':
      default:
        // Não aplicar filtro adicional
        break;
    }

    return filtered;
  }

  String _getCurrentDayString() {
    final now = DateTime.now();
    final weekdays = ['seg', 'ter', 'qua', 'qui', 'sex', 'sab', 'dom'];
    return weekdays[now.weekday - 1];
  }

  VolunteerProfileModel? _getVolunteerProfile(String userId) {
    try {
      return _volunteerProfiles.firstWhere((p) => p.userId == userId);
    } catch (e) {
      return null;
    }
  }

  int _getAssignedMicrotasksCount(String userId) {
    int count = 0;

    for (final microtask in _availableMicrotasks) {
      // Verificar se o usuário está atribuído a esta microtask
      // Por enquanto, retornamos 0 até implementarmos o sistema de atribuição
      // TODO: Implementar verificação real quando o sistema de atribuição estiver pronto
    }

    return count;
  }

  void _showAssignmentDialog(
    UserModel volunteer,
    VolunteerProfileModel? profile,
  ) {
    showDialog(
      context: context,
      builder: (context) => AssignmentDialog(
        availableMicrotasks: _availableMicrotasks,
        volunteer: volunteer,
        volunteerProfile: profile,
        onAssign: (microtaskId) => _assignMicrotask(volunteer.id, microtaskId),
      ),
    );
  }

  Future<void> _assignMicrotask(String volunteerId, String microtaskId) async {
    try {
      // TODO: Implementar atribuição real
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Funcionalidade em desenvolvimento'),
          backgroundColor: AppColors.warning,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atribuir microtask: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _promoteToManager(UserModel volunteer) async {
    try {
      // TODO: Implementar promoção real
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Funcionalidade em desenvolvimento'),
          backgroundColor: AppColors.warning,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao promover voluntário: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
