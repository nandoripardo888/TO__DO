import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/volunteer_profile_model.dart';

/// Widget card para exibir informações de um voluntário
class VolunteerCard extends StatelessWidget {
  final UserModel user;
  final VolunteerProfileModel? profile;
  final VoidCallback? onTap;
  final VoidCallback? onAssignMicrotask;
  final VoidCallback? onPromoteToManager;
  final bool showActions;
  final bool isManager;
  final int assignedMicrotasksCount;

  const VolunteerCard({
    super.key,
    required this.user,
    this.profile,
    this.onTap,
    this.onAssignMicrotask,
    this.onPromoteToManager,
    this.showActions = true,
    this.isManager = false,
    this.assignedMicrotasksCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
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
              // Header com foto e informações básicas
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    backgroundImage: user.photoUrl != null
                        ? NetworkImage(user.photoUrl!)
                        : null,
                    child: user.photoUrl == null
                        ? Text(
                            user.name.isNotEmpty
                                ? user.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          )
                        : null,
                  ),

                  const SizedBox(width: AppDimensions.spacingMd),

                  // Informações do usuário
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.email,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Indicador de disponibilidade
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _getAvailabilityColor(),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getAvailabilityText(),
                              style: TextStyle(
                                fontSize: 11,
                                color: _getAvailabilityColor(),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Badge de microtasks atribuídas
                  if (assignedMicrotasksCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$assignedMicrotasksCount',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),

              // Informações do perfil (se disponível)
              if (profile != null) ...[
                const SizedBox(height: AppDimensions.spacingMd),

                // Disponibilidade de horários
                if (profile!.availableDays.isNotEmpty) ...[
                  _buildSectionTitle('Disponibilidade'),
                  const SizedBox(height: 4),
                  _buildAvailabilityInfo(),
                  const SizedBox(height: AppDimensions.spacingSm),
                ],

                // Habilidades
                if (profile!.skills.isNotEmpty) ...[
                  _buildSectionTitle('Habilidades'),
                  const SizedBox(height: 4),
                  _buildSkillsChips(),
                  const SizedBox(height: AppDimensions.spacingSm),
                ],

                // Recursos
                if (profile!.resources.isNotEmpty) ...[
                  _buildSectionTitle('Recursos'),
                  const SizedBox(height: 4),
                  _buildResourcesChips(),
                ],
              ],

              // Ações (se habilitadas)
              if (showActions && isManager) ...[
                const SizedBox(height: AppDimensions.spacingMd),
                _buildActionsSection(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildAvailabilityInfo() {
    if (profile == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dias disponíveis
        Wrap(
          spacing: 4,
          children: profile!.availableDays.map((day) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: Text(
                _getDayAbbreviation(day),
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.success,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),

        // TODO: Implementar horário disponível quando o campo for adicionado ao modelo
      ],
    );
  }

  Widget _buildSkillsChips() {
    if (profile == null || profile!.skills.isEmpty)
      return const SizedBox.shrink();

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: profile!.skills.map((skill) {
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
    );
  }

  Widget _buildResourcesChips() {
    if (profile == null || profile!.resources.isEmpty)
      return const SizedBox.shrink();

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: profile!.resources.map((resource) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
          ),
          child: Text(
            resource,
            style: const TextStyle(fontSize: 10, color: AppColors.secondary),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionsSection() {
    return Row(
      children: [
        // Botão Atribuir Microtask
        if (onAssignMicrotask != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onAssignMicrotask,
              icon: const Icon(Icons.assignment, size: 16),
              label: const Text('Atribuir'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),

        if (onAssignMicrotask != null && onPromoteToManager != null)
          const SizedBox(width: AppDimensions.spacingSm),

        // Botão Promover a Gerenciador
        if (onPromoteToManager != null)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onPromoteToManager,
              icon: const Icon(Icons.admin_panel_settings, size: 16),
              label: const Text('Promover'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.textOnPrimary,
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
      ],
    );
  }

  Color _getAvailabilityColor() {
    if (profile == null) return AppColors.warning;

    final now = DateTime.now();
    final currentDay = _getCurrentDayString();

    if (profile!.availableDays.contains(currentDay)) {
      return AppColors.success;
    } else {
      return AppColors.error;
    }
  }

  String _getAvailabilityText() {
    if (profile == null) return 'Sem perfil';

    final currentDay = _getCurrentDayString();

    if (profile!.availableDays.contains(currentDay)) {
      return 'Disponível hoje';
    } else {
      return 'Indisponível hoje';
    }
  }

  String _getCurrentDayString() {
    final weekdays = [
      'Segunda',
      'Terça',
      'Quarta',
      'Quinta',
      'Sexta',
      'Sábado',
      'Domingo',
    ];
    return weekdays[DateTime.now().weekday - 1];
  }

  String _getDayAbbreviation(String day) {
    switch (day) {
      case 'Segunda':
        return 'Seg';
      case 'Terça':
        return 'Ter';
      case 'Quarta':
        return 'Qua';
      case 'Quinta':
        return 'Qui';
      case 'Sexta':
        return 'Sex';
      case 'Sábado':
        return 'Sáb';
      case 'Domingo':
        return 'Dom';
      default:
        return day.substring(0, 3);
    }
  }
}
