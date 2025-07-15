import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/volunteer_profile_model.dart';

/// Widget card para exibir informações de um voluntário (versão compacta)
class VolunteerCard extends StatelessWidget {
  final UserModel user;
  final VolunteerProfileModel? profile;
  final VoidCallback? onTap;
  final VoidCallback?
  onShowActions; // Callback unificado para mostrar o menu de ações
  final bool showActions;
  final bool isManager;
  final int assignedMicrotasksCount;
  final bool
  isCompatible; // Indica se o voluntário é compatível com filtros ativos
  final bool
  showDetailedAvailability; // Mostra horário detalhado de disponibilidade

  const VolunteerCard({
    super.key,
    required this.user,
    this.profile,
    this.onTap,
    this.onShowActions, // Ação unificada
    this.showActions = true,
    this.isManager = false,
    this.assignedMicrotasksCount = 0,
    this.isCompatible = false,
    this.showDetailedAvailability = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSm, // Menor margem horizontal
        vertical: AppDimensions.paddingSm / 2, // Menor margem vertical
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingSm,
            vertical: AppDimensions.paddingSm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header principal com ListTile
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 22,
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        )
                      : null,
                ),
                title: Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildAvailabilityIndicator(),
                  ],
                ),
                // Indicadores visuais e ações
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Indicador de compatibilidade (estrela)
                    if (isCompatible)
                      Container(
                        margin: const EdgeInsets.only(right: 4),
                        child: Icon(
                          Icons.star,
                          size: 16,
                          color: AppColors.warning,
                        ),
                      ),
                    // Contador de microtasks atribuídas
                    if (assignedMicrotasksCount > 0) _buildMicrotaskBadge(),
                    // Botão de ações
                    if (showActions && isManager)
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: onShowActions,
                        tooltip: 'Mais opções',
                      ),
                  ],
                ),
              ),

              // Informações do perfil (se disponível)
              if (profile != null &&
                  (profile!.skills.isNotEmpty ||
                      profile!.resources.isNotEmpty ||
                      profile!.availableDays.isNotEmpty)) ...[
                const Divider(height: AppDimensions.spacingMd),
                _buildProfileInfo(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Indicador de disponibilidade (exibido no subtítulo)
  Widget _buildAvailabilityIndicator() {
    return Row(
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
        Expanded(
          child: Text(
            _getAvailabilityText(),
            style: TextStyle(
              fontSize: 11,
              color: _getAvailabilityColor(),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Badge de contagem de microtasks
  Widget _buildMicrotaskBadge() {
    final count = profile?.assignedMicrotasksCount ?? assignedMicrotasksCount;
    final color = _getMicrotaskBadgeColor(count);

    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.assignment, size: 12, color: color),
          const SizedBox(width: 2),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Cor do badge baseada na carga de trabalho
  Color _getMicrotaskBadgeColor(int count) {
    if (count == 0) return AppColors.textSecondary;
    if (count < 3) return AppColors.success;
    if (count < 5) return AppColors.warning;
    return AppColors.error;
  }

  // Seção de informações do perfil (Habilidades, Recursos, etc.)
  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (profile!.availableDays.isNotEmpty) ...[
            _buildInfoRow(
              Icons.event_available_outlined,
              _buildAvailabilityChips(),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
          ],
          if (profile!.skills.isNotEmpty) ...[
            _buildInfoRow(
              Icons.construction_outlined,
              _buildChips(profile!.skills, AppColors.primary),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
          ],
          if (profile!.resources.isNotEmpty) ...[
            _buildInfoRow(
              Icons.build_circle_outlined,
              _buildChips(profile!.resources, AppColors.secondary),
            ),
          ],
        ],
      ),
    );
  }

  // Linha de informação genérica (Ícone + Conteúdo)
  Widget _buildInfoRow(IconData icon, Widget content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: AppDimensions.spacingSm),
        Expanded(child: content),
      ],
    );
  }

  // Chips de dias disponíveis
  Widget _buildAvailabilityChips() {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: profile!.availableDays.map((day) {
        return _buildChip(_getDayAbbreviation(day), AppColors.success);
      }).toList(),
    );
  }

  // Chips genéricos para Habilidades e Recursos
  Widget _buildChips(List<String> items, Color color) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: items.map((item) => _buildChip(item, color)).toList(),
    );
  }

  // Widget de chip customizado
  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Funções de lógica
  Color _getAvailabilityColor() {
    if (profile == null) return AppColors.warning;

    // Se disponibilidade integral está ativa, sempre verde
    if (profile!.isFullTimeAvailable) return AppColors.success;

    final now = DateTime.now();
    final currentDay = _getCurrentDayString(now);
    return profile!.availableDays.contains(currentDay)
        ? AppColors.success
        : AppColors.error;
  }

  String _getAvailabilityText() {
    if (profile == null) return 'Sem perfil';

    // Se disponibilidade integral está ativa
    if (profile!.isFullTimeAvailable) {
      return showDetailedAvailability
          ? 'Disponível integral (qualquer horário)'
          : 'Disponível integral';
    }

    final now = DateTime.now();
    final currentDay = _getCurrentDayString(now);
    final isAvailableToday = profile!.availableDays.contains(currentDay);

    if (showDetailedAvailability && profile!.availableHours.isValid()) {
      final hours =
          '${profile!.availableHours.start}-${profile!.availableHours.end}';
      return isAvailableToday ? 'Hoje: $hours' : 'Indisponível hoje ($hours)';
    }

    return isAvailableToday ? 'Disponível hoje' : 'Indisponível hoje';
  }

  String _getCurrentDayString(DateTime date) {
    final weekdays = [
      'Segunda',
      'Terça',
      'Quarta',
      'Quinta',
      'Sexta',
      'Sábado',
      'Domingo',
    ];
    return weekdays[date.weekday - 1];
  }

  String _getDayAbbreviation(String day) {
    const abbreviations = {
      'Segunda': 'Seg',
      'Terça': 'Ter',
      'Quarta': 'Qua',
      'Quinta': 'Qui',
      'Sexta': 'Sex',
      'Sábado': 'Sáb',
      'Domingo': 'Dom',
    };
    return abbreviations[day] ?? day.substring(0, 3);
  }
}
