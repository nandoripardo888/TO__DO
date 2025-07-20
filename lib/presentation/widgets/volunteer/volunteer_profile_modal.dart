import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/volunteer_profile_model.dart';

/// Modal para exibir informações detalhadas do voluntário
class VolunteerProfileModal extends StatelessWidget {
  final UserModel user;
  final VolunteerProfileModel? profile;
  final int assignedMicrotasksCount;

  const VolunteerProfileModal({
    super.key,
    required this.user,
    this.profile,
    this.assignedMicrotasksCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 600,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.paddingLg),
                child: _buildContent(),
              ),
            ),
            // Actions
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withOpacity(0.2),
            backgroundImage: user.photoUrl != null
                ? NetworkImage(user.photoUrl!)
                : null,
            child: user.photoUrl == null
                ? Text(
                    user.name.isNotEmpty
                        ? user.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
                  user.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status de disponibilidade
        _buildAvailabilitySection(),
        
        if (assignedMicrotasksCount > 0) ...[
          const SizedBox(height: AppDimensions.spacingLg),
          _buildMicrotasksSection(),
        ],
        
        if (profile != null) ...[
          if (profile!.skills.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spacingLg),
            _buildSkillsSection(),
          ],
          
          if (profile!.resources.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spacingLg),
            _buildResourcesSection(),
          ],
          
          if (profile!.availableDays.isNotEmpty || profile!.isFullTimeAvailable) ...[
            const SizedBox(height: AppDimensions.spacingLg),
            _buildAvailabilityDetailsSection(),
          ],
        ],
      ],
    );
  }

  Widget _buildAvailabilitySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: _getAvailabilityColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getAvailabilityColor().withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            color: _getAvailabilityColor(),
            size: 20,
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status de Disponibilidade',
                  style: TextStyle(
                    fontSize: 12,
                    color: _getAvailabilityColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getAvailabilityText(),
                  style: TextStyle(
                    fontSize: 14,
                    color: _getAvailabilityColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMicrotasksSection() {
    final color = _getMicrotaskBadgeColor(assignedMicrotasksCount);
    
    return _buildSection(
      'Microtasks Atribuídas',
      Icons.assignment,
      color,
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
          vertical: AppDimensions.paddingSm,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.assignment, size: 16, color: color),
            const SizedBox(width: AppDimensions.spacingSm),
            Text(
              '$assignedMicrotasksCount microtask${assignedMicrotasksCount != 1 ? 's' : ''}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection() {
    return _buildSection(
      'Habilidades',
      Icons.construction_outlined,
      AppColors.primary,
      _buildChips(profile!.skills, AppColors.primary),
    );
  }

  Widget _buildResourcesSection() {
    return _buildSection(
      'Recursos Disponíveis',
      Icons.build_circle_outlined,
      AppColors.secondary,
      _buildChips(profile!.resources, AppColors.secondary),
    );
  }

  Widget _buildAvailabilityDetailsSection() {
    return _buildSection(
      'Disponibilidade Detalhada',
      Icons.event_available_outlined,
      AppColors.success,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (profile!.isFullTimeAvailable)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
                vertical: AppDimensions.paddingSm,
              ),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.all_inclusive, size: 16, color: AppColors.success),
                  SizedBox(width: AppDimensions.spacingSm),
                  Text(
                    'Disponível em tempo integral',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            )
          else ...[
            if (profile!.availableDays.isNotEmpty)
              _buildAvailabilityChips()
            else
              const Text(
                'Nenhum dia específico definido',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            
            if (profile!.availableHours.isValid()) ...[
              const SizedBox(height: AppDimensions.spacingSm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMd,
                  vertical: AppDimensions.paddingSm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.schedule, size: 16, color: AppColors.primary),
                    const SizedBox(width: AppDimensions.spacingSm),
                    Text(
                      'Horário: ${profile!.availableHours.start} - ${profile!.availableHours.end}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Color color, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: AppDimensions.spacingSm),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        content,
      ],
    );
  }

  Widget _buildChips(List<String> items, Color color) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: items.map((item) => _buildChip(item, color)).toList(),
    );
  }

  Widget _buildAvailabilityChips() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: profile!.availableDays.map((day) {
        return _buildChip(_getDayAbbreviation(day), AppColors.success);
      }).toList(),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(
          'Fechar',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Funções auxiliares
  Color _getAvailabilityColor() {
    if (profile == null) return AppColors.warning;

    if (profile!.isFullTimeAvailable) return AppColors.success;

    final now = DateTime.now();
    final currentDay = _getCurrentDayString(now);
    return profile!.availableDays.contains(currentDay)
        ? AppColors.success
        : AppColors.error;
  }

  String _getAvailabilityText() {
    if (profile == null) return 'Sem perfil de voluntário';

    if (profile!.isFullTimeAvailable) {
      return 'Disponível em tempo integral';
    }

    final now = DateTime.now();
    final currentDay = _getCurrentDayString(now);
    final isAvailableToday = profile!.availableDays.contains(currentDay);

    return isAvailableToday ? 'Disponível hoje' : 'Indisponível hoje';
  }

  Color _getMicrotaskBadgeColor(int count) {
    if (count == 0) return AppColors.textSecondary;
    if (count < 3) return AppColors.success;
    if (count < 5) return AppColors.warning;
    return AppColors.error;
  }

  String _getCurrentDayString(DateTime date) {
    const weekdays = [
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

  /// Mostra o modal de perfil do voluntário
  static void show({
    required BuildContext context,
    required UserModel user,
    VolunteerProfileModel? profile,
    int assignedMicrotasksCount = 0,
  }) {
    showDialog(
      context: context,
      builder: (context) => VolunteerProfileModal(
        user: user,
        profile: profile,
        assignedMicrotasksCount: assignedMicrotasksCount,
      ),
    );
  }
}