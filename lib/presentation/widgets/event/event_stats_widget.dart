import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/event_model.dart';

/// Widget para exibir estatísticas de um evento
class EventStatsWidget extends StatelessWidget {
  final EventModel event;
  final bool showDetailed;

  const EventStatsWidget({
    super.key,
    required this.event,
    this.showDetailed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppDimensions.elevationSm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            const Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: AppColors.primary,
                  size: 24,
                ),
                SizedBox(width: AppDimensions.spacingSm),
                Text(
                  'Estatísticas do Evento',
                  style: TextStyle(
                    fontSize: AppDimensions.fontSizeLg,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.spacingLg),
            
            // Estatísticas básicas
            _buildBasicStats(),
            
            if (showDetailed) ...[
              const SizedBox(height: AppDimensions.spacingLg),
              const Divider(),
              const SizedBox(height: AppDimensions.spacingLg),
              
              // Estatísticas detalhadas
              _buildDetailedStats(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBasicStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            icon: Icons.people,
            label: 'Participantes',
            value: event.totalParticipants.toString(),
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingMd),
        Expanded(
          child: _buildStatItem(
            icon: Icons.admin_panel_settings,
            label: 'Gerenciadores',
            value: event.managers.length.toString(),
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingMd),
        Expanded(
          child: _buildStatItem(
            icon: Icons.volunteer_activism,
            label: 'Voluntários',
            value: event.volunteers.length.toString(),
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Habilidades necessárias
        _buildRequirementStats(
          title: 'Habilidades Necessárias',
          icon: Icons.psychology,
          items: event.requiredSkills,
          color: AppColors.info,
        ),
        
        const SizedBox(height: AppDimensions.spacingLg),
        
        // Recursos necessários
        _buildRequirementStats(
          title: 'Recursos Necessários',
          icon: Icons.inventory,
          items: event.requiredResources,
          color: AppColors.warning,
        ),
        
        const SizedBox(height: AppDimensions.spacingLg),
        
        // Informações temporais
        _buildTemporalInfo(),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            value,
            style: TextStyle(
              fontSize: AppDimensions.fontSizeXl,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppDimensions.fontSizeSm,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementStats({
    required String title,
    required IconData icon,
    required List<String> items,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            Text(
              title,
              style: TextStyle(
                fontSize: AppDimensions.fontSizeMd,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingSm,
                vertical: AppDimensions.paddingXs,
              ),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Text(
                items.length.toString(),
                style: TextStyle(
                  fontSize: AppDimensions.fontSizeSm,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppDimensions.spacingSm),
        
        if (items.isEmpty)
          Text(
            'Nenhum item especificado',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeMd,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
              fontStyle: FontStyle.italic,
            ),
          )
        else
          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingSm,
            children: items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingSm,
                  vertical: AppDimensions.paddingXs,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: AppDimensions.fontSizeSm,
                    color: color,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildTemporalInfo() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.schedule,
                color: AppColors.textSecondary,
                size: 20,
              ),
              SizedBox(width: AppDimensions.spacingSm),
              Text(
                'Informações Temporais',
                style: TextStyle(
                  fontSize: AppDimensions.fontSizeMd,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppDimensions.spacingMd),
          
          // Data de criação
          _buildTemporalItem(
            icon: Icons.add_circle,
            label: 'Criado em',
            value: _formatDate(event.createdAt),
            subtitle: event.createdTimeAgo,
          ),
          
          const SizedBox(height: AppDimensions.spacingSm),
          
          // Data de atualização
          if (event.createdAt != event.updatedAt)
            _buildTemporalItem(
              icon: Icons.update,
              label: 'Última atualização',
              value: _formatDate(event.updatedAt),
              subtitle: event.updatedTimeAgo,
            ),
          
          const SizedBox(height: AppDimensions.spacingSm),
          
          // Indicador de evento novo
          if (event.isNewEvent)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingSm,
                vertical: AppDimensions.paddingXs,
              ),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.new_releases,
                    size: 16,
                    color: AppColors.success,
                  ),
                  SizedBox(width: AppDimensions.spacingXs),
                  Text(
                    'Evento Novo',
                    style: TextStyle(
                      fontSize: AppDimensions.fontSizeSm,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTemporalItem({
    required IconData icon,
    required String label,
    required String value,
    String? subtitle,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: AppDimensions.fontSizeSm,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: AppDimensions.fontSizeMd,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontSizeXs,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
