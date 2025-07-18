import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/volunteer_profile_model.dart';

/// Widget de cabeçalho com informações do voluntário
class VolunteerHeader extends StatelessWidget {
  final UserModel volunteer;
  final VolunteerProfileModel? volunteerProfile;

  const VolunteerHeader({
    super.key,
    required this.volunteer,
    this.volunteerProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
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
                      fontSize: 18,
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
                const SizedBox(height: 2),
                Text(
                  'Selecione uma microtask para atribuir',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (volunteerProfile != null &&
                    volunteerProfile!.skills.isNotEmpty) ...[  
                  const SizedBox(height: 4),
                  Text(
                    'Habilidades: ${volunteerProfile!.skills.join(', ')}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}