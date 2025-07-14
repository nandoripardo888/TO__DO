import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/microtask_model.dart';
import '../../../data/models/user_model.dart';

/// Widget card para exibir informações de uma microtask com múltiplos voluntários
class MicrotaskCard extends StatelessWidget {
  final MicrotaskModel microtask;
  final List<UserModel> assignedVolunteers;
  final VoidCallback? onTap;
  final VoidCallback? onAssignVolunteer;
  final Function(String userId)? onRemoveVolunteer;
  final Function(String userId, String status)? onUpdateStatus;
  final bool showActions;
  final bool isManager;

  const MicrotaskCard({
    super.key,
    required this.microtask,
    this.assignedVolunteers = const [],
    this.onTap,
    this.onAssignVolunteer,
    this.onRemoveVolunteer,
    this.onUpdateStatus,
    this.showActions = true,
    this.isManager = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingSm,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // Ícone de status
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
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
                  _buildPriorityBadge(),
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

              const SizedBox(height: AppDimensions.spacingMd),

              // Informações da microtask
              Wrap(
                spacing: AppDimensions.spacingSm,
                runSpacing: AppDimensions.spacingSm,
                children: [
                  _buildInfoChip(
                    icon: Icons.schedule,
                    label: '${microtask.estimatedHours}h',
                    color: AppColors.secondary,
                  ),
                  _buildInfoChip(
                    icon: Icons.people,
                    label:
                        '${assignedVolunteers.length}/${microtask.maxVolunteers}',
                    color: _getVolunteerCountColor(),
                  ),
                  _buildInfoChip(
                    icon: Icons.info_outline,
                    label: _getStatusText(),
                    color: _getStatusColor(),
                  ),
                ],
              ),

              // Habilidades necessárias
              if (microtask.requiredSkills.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.spacingMd),
                _buildSkillsSection(),
              ],

              // Recursos necessários
              if (microtask.requiredResources.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.spacingSm),
                _buildResourcesSection(),
              ],

              // Lista de voluntários atribuídos
              if (assignedVolunteers.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.spacingMd),
                _buildVolunteersSection(),
              ],

              // Ações (se habilitadas)
              if (showActions) ...[
                const SizedBox(height: AppDimensions.spacingMd),
                _buildActionsSection(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge() {
    Color color;
    String text;

    final priorityValue = microtask.priority is int
        ? microtask.priority as int
        : 2;

    switch (priorityValue) {
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Habilidades:',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: microtask.requiredSkills.map((skill) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Text(
                skill,
                style: const TextStyle(fontSize: 10, color: AppColors.primary),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildResourcesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recursos:',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: microtask.requiredResources.map((resource) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
              ),
              child: Text(
                resource,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.secondary,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildVolunteersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Voluntários:',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        ...assignedVolunteers.map(
          (volunteer) => _buildVolunteerItem(volunteer),
        ),
      ],
    );
  }

  Widget _buildVolunteerItem(UserModel volunteer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              volunteer.name.isNotEmpty ? volunteer.name[0].toUpperCase() : '?',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              volunteer.name,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (isManager && onRemoveVolunteer != null)
            IconButton(
              onPressed: () => onRemoveVolunteer!(volunteer.id),
              icon: const Icon(Icons.remove_circle_outline),
              iconSize: 16,
              color: AppColors.error,
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              padding: EdgeInsets.zero,
            ),
        ],
      ),
    );
  }

  Widget _buildActionsSection() {
    return Row(
      children: [
        if (isManager &&
            onAssignVolunteer != null &&
            assignedVolunteers.length < microtask.maxVolunteers)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onAssignVolunteer,
              icon: const Icon(Icons.person_add, size: 16),
              label: const Text('Atribuir'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (microtask.status) {
      case MicrotaskStatus.pending:
        return AppColors.warning;
      case MicrotaskStatus.assigned:
        return AppColors.primary;
      case MicrotaskStatus.inProgress:
        return AppColors.secondary;
      case MicrotaskStatus.completed:
        return AppColors.success;
      case MicrotaskStatus.cancelled:
        return AppColors.error;
    }
  }

  String _getStatusText() {
    switch (microtask.status) {
      case MicrotaskStatus.pending:
        return 'Pendente';
      case MicrotaskStatus.assigned:
        return 'Atribuída';
      case MicrotaskStatus.inProgress:
        return 'Em Progresso';
      case MicrotaskStatus.completed:
        return 'Concluída';
      case MicrotaskStatus.cancelled:
        return 'Cancelada';
    }
  }

  Color _getVolunteerCountColor() {
    if (assignedVolunteers.length == microtask.maxVolunteers) {
      return AppColors.success;
    } else if (assignedVolunteers.isEmpty) {
      return AppColors.warning;
    } else {
      return AppColors.primary;
    }
  }
}
