import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/microtask_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/volunteer_profile_model.dart';

/// Dialog para atribuição de voluntários a microtasks
class AssignmentDialog extends StatefulWidget {
  final List<MicrotaskModel> availableMicrotasks;
  final UserModel volunteer;
  final VolunteerProfileModel? volunteerProfile;
  final Function(String microtaskId) onAssign;

  const AssignmentDialog({
    super.key,
    required this.availableMicrotasks,
    required this.volunteer,
    this.volunteerProfile,
    required this.onAssign,
  });

  @override
  State<AssignmentDialog> createState() => _AssignmentDialogState();
}

class _AssignmentDialogState extends State<AssignmentDialog> {
  String? _selectedMicrotaskId;
  List<MicrotaskModel> _filteredMicrotasks = [];
  bool _showOnlyCompatible = false;

  @override
  void initState() {
    super.initState();
    _filteredMicrotasks = widget.availableMicrotasks;
    _filterMicrotasks();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(
                  Icons.assignment,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Atribuir Microtask',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Para: ${widget.volunteer.name}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  color: AppColors.textSecondary,
                ),
              ],
            ),

            const SizedBox(height: AppDimensions.spacingLg),

            // Filtro de compatibilidade
            if (widget.volunteerProfile != null) _buildCompatibilityFilter(),

            const SizedBox(height: AppDimensions.spacingMd),

            // Lista de microtasks
            Expanded(
              child: _filteredMicrotasks.isEmpty
                  ? _buildEmptyState()
                  : _buildMicrotasksList(),
            ),

            const SizedBox(height: AppDimensions.spacingLg),

            // Botões de ação
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMd),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedMicrotaskId != null
                        ? () {
                            widget.onAssign(_selectedMicrotaskId!);
                            Navigator.of(context).pop();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                    ),
                    child: const Text('Atribuir'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompatibilityFilter() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_list, size: 20, color: AppColors.primary),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Text(
              'Mostrar apenas microtasks compatíveis',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Switch(
            value: _showOnlyCompatible,
            onChanged: (value) {
              setState(() {
                _showOnlyCompatible = value;
                _filterMicrotasks();
              });
            },
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
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
          const SizedBox(height: AppDimensions.spacingMd),
          Text(
            _showOnlyCompatible
                ? 'Nenhuma microtask compatível encontrada'
                : 'Nenhuma microtask disponível',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          if (_showOnlyCompatible) ...[
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              'Tente desabilitar o filtro de compatibilidade',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMicrotasksList() {
    return ListView.builder(
      itemCount: _filteredMicrotasks.length,
      itemBuilder: (context, index) {
        final microtask = _filteredMicrotasks[index];
        final isSelected = _selectedMicrotaskId == microtask.id;
        final isCompatible = _isCompatible(microtask);

        return Card(
          elevation: isSelected ? 4 : 1,
          margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedMicrotaskId = isSelected ? null : microtask.id;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: isSelected
                    ? Border.all(color: AppColors.primary, width: 2)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      // Indicador de compatibilidade
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isCompatible
                              ? AppColors.success
                              : AppColors.warning,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacingSm),

                      // Título
                      Expanded(
                        child: Text(
                          microtask.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),

                      // Badge de prioridade
                      _buildPriorityBadge(microtask.priority as int),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.spacingSm),

                  // Descrição
                  if (microtask.description.isNotEmpty)
                    Text(
                      microtask.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: AppDimensions.spacingSm),

                  // Informações
                  Row(
                    children: [
                      _buildInfoChip(
                        icon: Icons.schedule,
                        label: '${microtask.estimatedHours}h',
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: AppDimensions.spacingSm),
                      _buildInfoChip(
                        icon: Icons.people,
                        label:
                            '0/${microtask.maxVolunteers}', // TODO: Buscar voluntários atribuídos
                        color: AppColors.primary,
                      ),
                    ],
                  ),

                  // Habilidades e recursos necessários
                  if (microtask.requiredSkills.isNotEmpty ||
                      microtask.requiredResources.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.spacingSm),
                    _buildRequirementsInfo(microtask, isCompatible),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriorityBadge(int priority) {
    Color color;
    String text;

    switch (priority) {
      case 3: // high
        color = AppColors.error;
        text = 'Alta';
        break;
      case 2: // medium
        color = AppColors.warning;
        text = 'Média';
        break;
      case 1: // low
        color = AppColors.success;
        text = 'Baixa';
        break;
      default:
        color = AppColors.warning;
        text = 'Média';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementsInfo(MicrotaskModel microtask, bool isCompatible) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (microtask.requiredSkills.isNotEmpty) ...[
          Text(
            'Habilidades: ${microtask.requiredSkills.join(', ')}',
            style: TextStyle(
              fontSize: 10,
              color: isCompatible ? AppColors.success : AppColors.warning,
            ),
          ),
        ],
        if (microtask.requiredResources.isNotEmpty) ...[
          Text(
            'Recursos: ${microtask.requiredResources.join(', ')}',
            style: TextStyle(
              fontSize: 10,
              color: isCompatible ? AppColors.success : AppColors.warning,
            ),
          ),
        ],
      ],
    );
  }

  void _filterMicrotasks() {
    if (_showOnlyCompatible && widget.volunteerProfile != null) {
      _filteredMicrotasks = widget.availableMicrotasks
          .where((microtask) => _isCompatible(microtask))
          .toList();
    } else {
      _filteredMicrotasks = widget.availableMicrotasks;
    }
  }

  bool _isCompatible(MicrotaskModel microtask) {
    if (widget.volunteerProfile == null) return true;

    final volunteerSkills = widget.volunteerProfile!.skills;
    final volunteerResources = widget.volunteerProfile!.resources;

    // Verificar se o voluntário tem todas as habilidades necessárias
    final hasRequiredSkills = microtask.requiredSkills.every(
      (skill) => volunteerSkills.contains(skill),
    );

    // Verificar se o voluntário tem todos os recursos necessários
    final hasRequiredResources = microtask.requiredResources.every(
      (resource) => volunteerResources.contains(resource),
    );

    return hasRequiredSkills && hasRequiredResources;
  }
}
