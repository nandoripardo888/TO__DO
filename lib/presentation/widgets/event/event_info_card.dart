import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/event_model.dart';
import 'skill_chip.dart';

/// Widget de card para exibir informações detalhadas de uma campanha
class EventInfoCard extends StatelessWidget {
  final EventModel event;
  final String? currentUserId;
  final VoidCallback? onTap;
  final bool showFullDescription;
  final bool showParticipants;
  final bool showRequirements;

  const EventInfoCard({
    super.key,
    required this.event,
    this.currentUserId,
    this.onTap,
    this.showFullDescription = false,
    this.showParticipants = true,
    this.showRequirements = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppDimensions.elevationSm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com nome e status
              _buildHeader(),

              const SizedBox(height: AppDimensions.spacingMd),

              // Descrição
              if (event.description.isNotEmpty) ...[
                _buildDescription(),
                const SizedBox(height: AppDimensions.spacingMd),
              ],

              // Localização
              _buildLocation(),

              const SizedBox(height: AppDimensions.spacingMd),

              // Papel do usuário e participantes
              if (showParticipants) ...[
                _buildParticipantsInfo(),
                const SizedBox(height: AppDimensions.spacingMd),
              ],

              // Habilidades necessárias
              if (showRequirements && event.requiredSkills.isNotEmpty) ...[
                _buildRequiredSkills(),
                const SizedBox(height: AppDimensions.spacingMd),
              ],

              // Recursos necessários
              if (showRequirements && event.requiredResources.isNotEmpty) ...[
                _buildRequiredResources(),
                const SizedBox(height: AppDimensions.spacingMd),
              ],

              // Footer com tag e data
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            event.name,
            style: const TextStyle(
              fontSize: AppDimensions.fontSizeXl,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        _buildStatusChip(),
      ],
    );
  }

  Widget _buildDescription() {
    final description = showFullDescription
        ? event.description
        : event.shortDescription;

    return Text(
      description,
      style: const TextStyle(
        fontSize: AppDimensions.fontSizeMd,
        color: AppColors.textSecondary,
        height: 1.4,
      ),
      maxLines: showFullDescription ? null : 3,
      overflow: showFullDescription ? null : TextOverflow.ellipsis,
    );
  }

  Widget _buildLocation() {
    return Row(
      children: [
        const Icon(Icons.location_on, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: AppDimensions.spacingXs),
        Expanded(
          child: Text(
            event.location,
            style: const TextStyle(
              fontSize: AppDimensions.fontSizeMd,
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantsInfo() {
    return Row(
      children: [
        // Papel do usuário
        if (currentUserId != null) ...[_buildUserRoleChip(), const Spacer()],

        // Número de participantes
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.people, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: AppDimensions.spacingXs),
            Text(
              '${event.totalParticipants} participante${event.totalParticipants != 1 ? 's' : ''}',
              style: const TextStyle(
                fontSize: AppDimensions.fontSizeMd,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRequiredSkills() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Habilidades necessárias:',
          style: TextStyle(
            fontSize: AppDimensions.fontSizeMd,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        Wrap(
          spacing: AppDimensions.spacingSm,
          runSpacing: AppDimensions.spacingSm,
          children: event.requiredSkills.map((skill) {
            return SkillChip(
              label: skill,
              isSelected: false,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              textColor: AppColors.primary,
              borderColor: AppColors.primary.withValues(alpha: 0.3),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRequiredResources() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recursos necessários:',
          style: TextStyle(
            fontSize: AppDimensions.fontSizeMd,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        Wrap(
          spacing: AppDimensions.spacingSm,
          runSpacing: AppDimensions.spacingSm,
          children: event.requiredResources.map((resource) {
            return SkillChip(
              label: resource,
              isSelected: false,
              backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
              textColor: AppColors.secondary,
              borderColor: AppColors.secondary.withValues(alpha: 0.3),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        // Tag da campanha
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMd,
            vertical: AppDimensions.paddingSm,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.tag, size: 16, color: AppColors.primary),
              const SizedBox(width: AppDimensions.spacingXs),
              Text(
                event.tag,
                style: const TextStyle(
                  fontSize: AppDimensions.fontSizeSm,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Data de criação
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Criado ${event.createdTimeAgo}',
              style: const TextStyle(
                fontSize: AppDimensions.fontSizeSm,
                color: AppColors.textSecondary,
              ),
            ),
            if (event.createdAt != event.updatedAt) ...[
              const SizedBox(height: AppDimensions.spacingXs),
              Text(
                'Atualizado ${event.updatedTimeAgo}',
                style: const TextStyle(
                  fontSize: AppDimensions.fontSizeXs,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip() {
    Color backgroundColor;
    Color textColor;
    String text;
    IconData icon;

    switch (event.status) {
      case EventStatus.active:
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        text = 'Ativo';
        icon = Icons.play_circle;
        break;
      case EventStatus.completed:
        backgroundColor = AppColors.statusCompleted.withValues(alpha: 0.1);
        textColor = AppColors.statusCompleted;
        text = 'Concluído';
        icon = Icons.check_circle;
        break;
      case EventStatus.cancelled:
        backgroundColor = AppColors.error.withValues(alpha: 0.1);
        textColor = AppColors.error;
        text = 'Cancelado';
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingSm,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: AppDimensions.spacingXs),
          Text(
            text,
            style: TextStyle(
              fontSize: AppDimensions.fontSizeSm,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRoleChip() {
    if (currentUserId == null) {
      return const SizedBox.shrink();
    }

    final role = event.getUserRole(currentUserId!);
    if (role == UserRole.none) {
      return const SizedBox.shrink();
    }

    Color backgroundColor;
    Color textColor;
    IconData icon;
    String text;

    switch (role) {
      case UserRole.creator:
        backgroundColor = AppColors.primary.withValues(alpha: 0.1);
        textColor = AppColors.primary;
        icon = Icons.star;
        text = 'Criador';
        break;
      case UserRole.manager:
        backgroundColor = AppColors.secondary.withValues(alpha: 0.1);
        textColor = AppColors.secondary;
        icon = Icons.admin_panel_settings;
        text = 'Gerenciador';
        break;
      case UserRole.volunteer:
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        icon = Icons.volunteer_activism;
        text = 'Voluntário';
        break;
      case UserRole.none:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingSm,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: AppDimensions.spacingXs),
          Text(
            text,
            style: TextStyle(
              fontSize: AppDimensions.fontSizeSm,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
