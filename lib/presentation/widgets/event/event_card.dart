import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/event_model.dart';

/// Widget de card para exibir informações de uma campanha na lista
class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;
  final String? currentUserId;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
    this.currentUserId,
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
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com nome e status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.name,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontSizeLg,
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
              ),

              const SizedBox(height: AppDimensions.spacingSm),

              // Descrição
              if (event.description.isNotEmpty) ...[
                Text(
                  event.shortDescription,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontSizeMd,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.spacingSm),
              ],

              // Localização
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppDimensions.spacingXs),
                  Expanded(
                    child: Text(
                      event.location,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontSizeSm,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.spacingSm),

              // Papel do usuário e participantes
              Row(
                children: [
                  _buildUserRoleChip(),
                  const Spacer(),
                  _buildParticipantsInfo(),
                ],
              ),

              const SizedBox(height: AppDimensions.spacingSm),

              // Tag da Campanha e data
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingSm,
                      vertical: AppDimensions.paddingXs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSm,
                      ),
                    ),
                    child: Text(
                      event.tag,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontSizeSm,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    event.createdTimeAgo,
                    style: const TextStyle(
                      fontSize: AppDimensions.fontSizeSm,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (event.status) {
      case EventStatus.active:
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        text = 'Ativo';
        break;
      case EventStatus.completed:
        backgroundColor = AppColors.textSecondary.withValues(alpha: 0.1);
        textColor = AppColors.textSecondary;
        text = 'Concluído';
        break;
      case EventStatus.cancelled:
        backgroundColor = AppColors.error.withValues(alpha: 0.1);
        textColor = AppColors.error;
        text = 'Cancelado';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSm,
        vertical: AppDimensions.paddingXs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppDimensions.fontSizeSm,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildUserRoleChip() {
    if (currentUserId == null) {
      return const SizedBox.shrink();
    }

    final role = event.getUserRole(currentUserId!);
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
        horizontal: AppDimensions.paddingSm,
        vertical: AppDimensions.paddingXs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
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

  Widget _buildParticipantsInfo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.people, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: AppDimensions.spacingXs),
        Text(
          '${event.totalParticipants}',
          style: const TextStyle(
            fontSize: AppDimensions.fontSizeSm,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
