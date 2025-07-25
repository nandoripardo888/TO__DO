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
import '../../controllers/auth_controller.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/volunteer/volunteer_card.dart';
import '../../widgets/dialogs/confirmation_dialog.dart';
import '../assignment/assignment_screen.dart';

/// Tela para gerenciamento de voluntários
class ManageVolunteersScreen extends StatefulWidget {
  final String eventId;

  const ManageVolunteersScreen({super.key, required this.eventId});

  @override
  State<ManageVolunteersScreen> createState() => _ManageVolunteersScreenState();
}

class _ManageVolunteersScreenState extends State<ManageVolunteersScreen> with AutomaticKeepAliveClientMixin {
  EventModel? _event;
  List<UserModel> _volunteers = [];
  List<VolunteerProfileModel> _volunteerProfiles = [];
  List<MicrotaskModel> _availableMicrotasks = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _filterStatus = 'all'; // all, available, assigned
  final List<String> _selectedSkillsFilter =
      []; // Filtro por habilidades selecionadas
  List<String> _availableSkills =
      []; // Todas as habilidades disponíveis na campanha

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

      // Carrega campanha
      final event = await eventController.loadEvent(widget.eventId);

      // Carrega tasks e microtasks
      await taskController.loadTasksByEventId(widget.eventId);
      
      // Aguarda um pouco para garantir que as microtasks sejam carregadas
      await Future.delayed(const Duration(milliseconds: 500));

      // Carrega voluntários e perfis (OTIMIZADO - dados denormalizados)
      final profiles = await eventController.getEventVolunteersOptimized(
        widget.eventId,
      );

      // DEBUG: Carregados ${profiles.length} perfis de voluntários

      // Não precisamos mais buscar usuários separadamente - dados estão nos perfis
      final volunteers = <UserModel>[]; // Mantido para compatibilidade

      // Se não há voluntários, você pode adicionar dados de teste aqui
      // _addTestVolunteers(); // Descomente para testar

      // Carrega microtasks disponíveis
      final availableMicrotasks = <MicrotaskModel>[];
      final allSkills = <String>{};
      
      for (final task in taskController.tasks) {
        final microtasks = taskController.getMicrotasksByTaskId(task.id);
        
        // Filtra microtasks que podem receber novos voluntários
        final filteredMicrotasks = microtasks.where(
          (m) =>
              m.status != MicrotaskStatus.completed &&
              m.status != MicrotaskStatus.cancelled &&
              m.assignedTo.length < m.maxVolunteers,
        ).toList();
        
        availableMicrotasks.addAll(filteredMicrotasks);

        // Coleta todas as habilidades necessárias das microtasks
        for (final microtask in microtasks) {
          allSkills.addAll(microtask.requiredSkills);
        }
      }

      // Adiciona habilidades da campanha se disponíveis
      if (event != null && event.requiredSkills.isNotEmpty) {
        allSkills.addAll(event.requiredSkills);
      }

      if (mounted) {
        setState(() {
          _event = event;
          _volunteers = volunteers;
          _volunteerProfiles = profiles;
          _availableMicrotasks = availableMicrotasks;
          _availableSkills = allSkills.toList()..sort();
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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    if (_isLoading) {
      return const LoadingWidget(message: 'Carregando voluntários...');
    }

    if (_event == null) {
      return const Center(
        child: Text(
          'Erro ao carregar campanha',
          style: TextStyle(fontSize: 16, color: AppColors.error),
        ),
      );
    }

    final filteredProfiles = _getFilteredProfiles();

    return Column(
      children: [
        // Header com busca e filtros
        _buildHeader(),

        // Lista de voluntários
        Expanded(
          child: filteredProfiles.isEmpty
              ? _buildEmptyState()
              : _buildVolunteersList(filteredProfiles),
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
                      const SizedBox(width: AppDimensions.spacingSm),
                      _buildSkillsFilterButton(),
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

  // Botão de filtro por habilidades
  Widget _buildSkillsFilterButton() {
    final hasActiveFilter = _selectedSkillsFilter.isNotEmpty;

    return GestureDetector(
      onTap: _availableSkills.isNotEmpty ? _showSkillsFilterDialog : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingSm,
          vertical: AppDimensions.paddingSm / 2,
        ),
        decoration: BoxDecoration(
          color: hasActiveFilter
              ? AppColors.primary.withOpacity(0.2)
              : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasActiveFilter ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_list,
              size: 16,
              color: hasActiveFilter
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              hasActiveFilter
                  ? 'Habilidades (${_selectedSkillsFilter.length})'
                  : 'Habilidades',
              style: TextStyle(
                fontSize: 12,
                color: hasActiveFilter
                    ? AppColors.primary
                    : AppColors.textSecondary,
                fontWeight: hasActiveFilter
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
            if (hasActiveFilter) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSkillsFilter.clear();
                  });
                },
                child: Icon(Icons.close, size: 14, color: AppColors.primary),
              ),
            ],
          ],
        ),
      ),
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
            'Compartilhe o código da campanha para que\nvoluntários possam se inscrever.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppDimensions.spacingLg),

          // Código da campanha
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

  Widget _buildVolunteersList(List<VolunteerProfileModel> profiles) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingSm),
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        final profile = profiles[index];

        // Cria um UserModel temporário para compatibilidade com VolunteerCard
        final user = UserModel(
          id: profile.userId,
          name: profile.userName,
          email: profile.userEmail,
          photoUrl: profile.userPhotoUrl,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        return VolunteerCard(
          user: user,
          profile: profile,
          isManager: true,
          showActions: true,
          assignedMicrotasksCount: _getAssignedMicrotasksCount(profile.userId),
          isCompatible: _isVolunteerCompatible(profile),
          showDetailedAvailability: true,
          onShowActions: () => _showVolunteerActionsDialog(user, profile),
        );
      },
    );
  }



  /// Exibe um diálogo com as ações disponíveis para um voluntário.
  void _showVolunteerActionsDialog(
    UserModel volunteer,
    VolunteerProfileModel? profile,
  ) {
    // Atualiza as microtasks disponíveis antes de exibir o diálogo
    _updateAvailableMicrotasks();
    
    final assignedCount = _getAssignedMicrotasksCount(volunteer.id);
    
    // Conta microtasks disponíveis para este voluntário específico
    final availableMicrotasksCount = _availableMicrotasks
        .where(
          (m) => !m.assignedTo.contains(volunteer.id),
        )
        .length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              backgroundImage: volunteer.photoUrl != null
                  ? NetworkImage(volunteer.photoUrl!)
                  : null,
              child: volunteer.photoUrl == null
                  ? Text(
                      volunteer.name.isNotEmpty
                          ? volunteer.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 14,
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
                    volunteer.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (profile != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      profile.workloadLevel,
                      style: TextStyle(
                        fontSize: 12,
                        color: _getMicrotaskBadgeColor(assignedCount),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Informações do voluntário
            if (profile != null) ...[
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingSm),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.assignment,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Microtasks: $assignedCount atribuídas',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          profile.isFullTimeAvailable
                              ? 'Disponibilidade integral'
                              : 'Disponível: ${profile.availableDays.join(', ')}',
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    if (profile.skills.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.construction,
                            size: 16,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Habilidades: ${profile.skills.join(', ')}',
                              style: const TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingMd),
            ],

            // Ações disponíveis
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.assignment_ind_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              title: const Text('Atribuir Microtask'),
              subtitle: Text(
                availableMicrotasksCount > 0
                    ? '$availableMicrotasksCount microtasks disponíveis'
                    : 'Nenhuma microtask disponível',
              ),
              enabled: availableMicrotasksCount > 0,
              onTap: availableMicrotasksCount > 0
                  ? () {
                      Navigator.of(context).pop();
                      _showAssignmentDialog(volunteer, profile);
                    }
                  : null,
            ),

            const Divider(),

            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.admin_panel_settings_outlined,
                  color: AppColors.warning,
                  size: 20,
                ),
              ),
              title: const Text('Promover a Gerente'),
              subtitle: const Text('Conceder permissões de gerenciamento'),
              onTap: () {
                Navigator.of(context).pop();
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

  List<VolunteerProfileModel> _getFilteredProfiles() {
    List<VolunteerProfileModel> filtered = List.from(_volunteerProfiles);

    // Aplicar filtro de busca
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((profile) {
        final name = profile.userName.toLowerCase();
        final email = profile.userEmail.toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || email.contains(query);
      }).toList();
    }

    // Aplicar filtro de status
    switch (_filterStatus) {
      case 'available':
        // Filtrar voluntários disponíveis (sem microtasks atribuídas)
        filtered = filtered.where((profile) {
          final assignedCount = _getAssignedMicrotasksCount(profile.userId);
          return assignedCount == 0;
        }).toList();
        break;
      case 'assigned':
        // Filtrar voluntários com microtasks atribuídas
        filtered = filtered.where((profile) {
          final assignedCount = _getAssignedMicrotasksCount(profile.userId);
          return assignedCount > 0;
        }).toList();
        break;
      case 'all':
      default:
        // Não aplicar filtro adicional
        break;
    }

    // Aplicar filtro por habilidades
    if (_selectedSkillsFilter.isNotEmpty) {
      filtered = filtered.where((profile) {
        // O voluntário deve possuir TODAS as habilidades selecionadas no filtro
        return _selectedSkillsFilter.every(
          (skill) => profile.skills.contains(skill),
        );
      }).toList();
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

  // Verifica se o voluntário é compatível com os filtros de habilidades ativos
  bool _isVolunteerCompatible(VolunteerProfileModel? profile) {
    if (profile == null || _selectedSkillsFilter.isEmpty) return false;

    // Retorna true se o voluntário possui todas as habilidades do filtro
    return _selectedSkillsFilter.every(
      (skill) => profile.skills.contains(skill),
    );
  }

  // Cor do badge baseada na carga de trabalho
  Color _getMicrotaskBadgeColor(int count) {
    if (count == 0) return AppColors.textSecondary;
    if (count < 3) return AppColors.success;
    if (count < 5) return AppColors.warning;
    return AppColors.error;
  }

  int _getAssignedMicrotasksCount(String userId) {
    // Primeiro, tenta usar o contador do perfil se disponível
    final profile = _getVolunteerProfile(userId);
    if (profile != null) {
      return profile.assignedMicrotasksCount;
    }

    // Fallback: conta manualmente nas microtasks
    int count = 0;
    for (final microtask in _availableMicrotasks) {
      if (microtask.assignedTo.contains(userId)) {
        count++;
      }
    }

    return count;
  }

  // Modal de seleção de habilidades para filtro
  void _showSkillsFilterDialog() {
    // Cria uma cópia local do filtro para manipular no modal
    List<String> tempSelectedSkills = List.from(_selectedSkillsFilter);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrar por Habilidades'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selecione as habilidades para filtrar voluntários:',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _availableSkills.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 2),
                  itemBuilder: (context, index) {
                    final skill = _availableSkills[index];
                    return StatefulBuilder(
                      builder: (context, setModalState) {
                        final isSelected = tempSelectedSkills.contains(skill);
                        return CheckboxListTile(
                          title: Text(skill),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setModalState(() {
                              if (value == true) {
                                tempSelectedSkills.add(skill);
                              } else {
                                tempSelectedSkills.remove(skill);
                              }
                            });
                          },
                          activeColor: AppColors.primary,
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 8,
                          ),
                          visualDensity: VisualDensity.compact,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedSkillsFilter.clear();
              });
              Navigator.of(context).pop();
            },
            child: const Text('Limpar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedSkillsFilter
                  ..clear()
                  ..addAll(tempSelectedSkills);
              });
              Navigator.of(context).pop();
            },
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }

  void _showAssignmentDialog(
    UserModel volunteer,
    VolunteerProfileModel? profile,
  ) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => AssignmentScreen(
              eventId: widget.eventId,
              volunteer: volunteer,
              volunteerProfile: profile,
            ),
          ),
        )
        .then((result) {
          // Se a atribuição foi bem-sucedida, recarrega os dados
          if (result == true) {
            _loadData();
          }
        });
  }

  /// Atualiza as microtasks disponíveis em tempo real
  void _updateAvailableMicrotasks() {
    final taskController = Provider.of<TaskController>(
      context,
      listen: false,
    );
    
    final availableMicrotasks = <MicrotaskModel>[];
    
    for (final task in taskController.tasks) {
      final microtasks = taskController.getMicrotasksByTaskId(task.id);
      
      // Filtra microtasks que podem receber novos voluntários
      final filteredMicrotasks = microtasks.where(
        (m) =>
            m.status != MicrotaskStatus.completed &&
            m.status != MicrotaskStatus.cancelled &&
            m.assignedTo.length < m.maxVolunteers,
      ).toList();
      
      availableMicrotasks.addAll(filteredMicrotasks);
    }
    
    setState(() {
      _availableMicrotasks = availableMicrotasks;
    });
  }

  Future<void> _promoteToManager(UserModel volunteer) async {
    final confirmed = await ConfirmationDialog.showPromoteVolunteer(
      context: context,
      volunteerName: volunteer.name,
    );

    if (confirmed == true && mounted) {
      try {
        final eventController = Provider.of<EventController>(
          context,
          listen: false,
        );
        final currentUser = Provider.of<AuthController>(
          context,
          listen: false,
        ).currentUser;

        if (currentUser == null) {
          throw Exception('Usuário não autenticado');
        }

        final success = await eventController.promoteVolunteerToManager(
          eventId: widget.eventId,
          volunteerId: volunteer.id,
          managerId: currentUser.id,
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${volunteer.name} foi promovido(a) a gerente com sucesso!',
              ),
              backgroundColor: AppColors.success,
            ),
          );

          // Recarrega os dados para refletir as mudanças
          _loadData();
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                eventController.errorMessage ?? 'Erro ao promover voluntário',
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao promover voluntário: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}
