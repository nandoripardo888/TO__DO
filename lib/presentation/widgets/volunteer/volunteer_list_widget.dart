import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/volunteer_profile_model.dart';
import 'volunteer_card.dart';

/// Widget para exibir lista de voluntários
class VolunteerListWidget extends StatelessWidget {
  final List<UserModel> volunteers;
  final List<VolunteerProfileModel> profiles;
  final Function(UserModel)? onVolunteerTap;
  final Function(UserModel)? onAssignMicrotask;
  final Function(UserModel)? onRemoveVolunteer;
  final Function(UserModel)? onPromoteToManager;
  final bool showActions;
  final bool isManager;
  final String? emptyMessage;
  final Widget? emptyWidget;
  final bool isLoading;

  const VolunteerListWidget({
    super.key,
    required this.volunteers,
    required this.profiles,
    this.onVolunteerTap,
    this.onAssignMicrotask,
    this.onRemoveVolunteer,
    this.onPromoteToManager,
    this.showActions = true,
    this.isManager = false,
    this.emptyMessage,
    this.emptyWidget,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (volunteers.isEmpty) {
      return emptyWidget ?? _buildEmptyState();
    }

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
          onShowActions: () => {},
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Text(
              emptyMessage ?? 'Nenhum voluntário encontrado',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  VolunteerProfileModel? _getVolunteerProfile(String userId) {
    try {
      return profiles.firstWhere((p) => p.userId == userId);
    } catch (e) {
      return null;
    }
  }

  int _getAssignedMicrotasksCount(String userId) {
    // TODO: Implementar contagem real de microtasks atribuídas
    return 0;
  }
}

/// Widget compacto para lista de voluntários em microtasks
class CompactVolunteerList extends StatelessWidget {
  final List<UserModel> volunteers;
  final int maxVolunteers;
  final Function(UserModel)? onVolunteerTap;
  final VoidCallback? onAddVolunteer;
  final Function(UserModel)? onRemoveVolunteer;
  final bool showAddButton;
  final bool showRemoveButton;

  const CompactVolunteerList({
    super.key,
    required this.volunteers,
    required this.maxVolunteers,
    this.onVolunteerTap,
    this.onAddVolunteer,
    this.onRemoveVolunteer,
    this.showAddButton = true,
    this.showRemoveButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header com contador
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Voluntários (${volunteers.length}/$maxVolunteers)',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (showAddButton && volunteers.length < maxVolunteers)
              IconButton(
                onPressed: onAddVolunteer,
                icon: const Icon(Icons.add),
                color: AppColors.primary,
                iconSize: 20,
              ),
          ],
        ),

        const SizedBox(height: AppDimensions.spacingSm),

        // Lista de voluntários
        if (volunteers.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.person_add_outlined,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                SizedBox(width: AppDimensions.spacingSm),
                Text(
                  'Nenhum voluntário atribuído',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          )
        else
          ...volunteers.map((volunteer) => _buildVolunteerItem(volunteer)),
      ],
    );
  }

  Widget _buildVolunteerItem(UserModel volunteer) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      padding: const EdgeInsets.all(AppDimensions.paddingSm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 16,
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

          const SizedBox(width: AppDimensions.spacingSm),

          // Informações do voluntário
          Expanded(
            child: GestureDetector(
              onTap: onVolunteerTap != null
                  ? () => onVolunteerTap!(volunteer)
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    volunteer.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    volunteer.email,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botão de remover
          if (showRemoveButton)
            IconButton(
              onPressed: onRemoveVolunteer != null
                  ? () => onRemoveVolunteer!(volunteer)
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
              color: AppColors.error,
              iconSize: 20,
            ),
        ],
      ),
    );
  }
}

/// Widget para exibir avatares dos voluntários em linha
class VolunteerAvatarList extends StatelessWidget {
  final List<UserModel> volunteers;
  final int maxVisible;
  final double avatarSize;
  final Function(UserModel)? onVolunteerTap;
  final VoidCallback? onShowAll;

  const VolunteerAvatarList({
    super.key,
    required this.volunteers,
    this.maxVisible = 3,
    this.avatarSize = 32,
    this.onVolunteerTap,
    this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    if (volunteers.isEmpty) {
      return const SizedBox.shrink();
    }

    final visibleVolunteers = volunteers.take(maxVisible).toList();
    final remainingCount = volunteers.length - maxVisible;

    return Row(
      children: [
        ...visibleVolunteers.asMap().entries.map((entry) {
          final index = entry.key;
          final volunteer = entry.value;

          return Container(
            margin: EdgeInsets.only(left: index > 0 ? -8 : 0),
            child: GestureDetector(
              onTap: onVolunteerTap != null
                  ? () => onVolunteerTap!(volunteer)
                  : null,
              child: CircleAvatar(
                radius: avatarSize / 2,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                backgroundImage: volunteer.photoUrl != null
                    ? NetworkImage(volunteer.photoUrl!)
                    : null,
                child: volunteer.photoUrl == null
                    ? Text(
                        volunteer.name.isNotEmpty
                            ? volunteer.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: avatarSize * 0.4,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      )
                    : null,
              ),
            ),
          );
        }),

        // Indicador de mais voluntários
        if (remainingCount > 0)
          Container(
            margin: const EdgeInsets.only(left: -8),
            child: GestureDetector(
              onTap: onShowAll,
              child: CircleAvatar(
                radius: avatarSize / 2,
                backgroundColor: AppColors.textSecondary.withOpacity(0.2),
                child: Text(
                  '+$remainingCount',
                  style: TextStyle(
                    fontSize: avatarSize * 0.3,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
