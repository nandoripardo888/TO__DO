import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Widget de chip para exibir habilidades e recursos
/// Pode ser usado tanto para seleção quanto para exibição
class SkillChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showRemove;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const SkillChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.showRemove = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? 
        (isSelected 
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.surface);
    
    final effectiveTextColor = textColor ?? 
        (isSelected 
            ? AppColors.primary
            : AppColors.textSecondary);
    
    final effectiveBorderColor = borderColor ?? 
        (isSelected 
            ? AppColors.primary.withValues(alpha: 0.3)
            : AppColors.border);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
          vertical: AppDimensions.paddingSm,
        ),
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: effectiveBorderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícone de seleção
            if (isSelected && !showRemove) ...[
              Icon(
                Icons.check_circle,
                size: 16,
                color: effectiveTextColor,
              ),
              const SizedBox(width: AppDimensions.spacingXs),
            ],
            
            // Texto do label
            Text(
              label,
              style: TextStyle(
                fontSize: AppDimensions.fontSizeSm,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: effectiveTextColor,
              ),
            ),
            
            // Ícone de remoção
            if (showRemove) ...[
              const SizedBox(width: AppDimensions.spacingXs),
              Icon(
                Icons.close,
                size: 16,
                color: effectiveTextColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Variação do SkillChip para habilidades
class SkillChipVariant extends SkillChip {
  const SkillChipVariant({
    super.key,
    required super.label,
    super.isSelected = false,
    super.onTap,
    super.showRemove = false,
  }) : super(
          backgroundColor: null,
          textColor: null,
          borderColor: null,
        );
}

/// Variação do SkillChip para recursos
class ResourceChip extends SkillChip {
  const ResourceChip({
    super.key,
    required super.label,
    super.isSelected = false,
    super.onTap,
    super.showRemove = false,
  }) : super(
          backgroundColor: null,
          textColor: null,
          borderColor: null,
        );
}

/// Variação do SkillChip para prioridades
class PriorityChip extends SkillChip {
  const PriorityChip({
    super.key,
    required super.label,
    super.isSelected = false,
    super.onTap,
    super.showRemove = false,
    required PriorityLevel priority,
  }) : super(
          backgroundColor: priority == PriorityLevel.high
              ? AppColors.priorityHigh
              : priority == PriorityLevel.medium
                  ? AppColors.priorityMedium
                  : AppColors.priorityLow,
          textColor: AppColors.textOnPrimary,
          borderColor: null,
        );
}

/// Enum para níveis de prioridade
enum PriorityLevel {
  high,
  medium,
  low,
}

/// Variação do SkillChip para status
class StatusChip extends SkillChip {
  const StatusChip({
    super.key,
    required super.label,
    super.isSelected = false,
    super.onTap,
    super.showRemove = false,
    required StatusType status,
  }) : super(
          backgroundColor: status == StatusType.pending
              ? AppColors.statusPending
              : status == StatusType.inProgress
                  ? AppColors.statusInProgress
                  : status == StatusType.completed
                      ? AppColors.statusCompleted
                      : AppColors.statusCancelled,
          textColor: AppColors.textOnPrimary,
          borderColor: null,
        );
}

/// Enum para tipos de status
enum StatusType {
  pending,
  inProgress,
  completed,
  cancelled,
}

/// Widget para exibir uma lista de chips de habilidades
class SkillChipList extends StatelessWidget {
  final List<String> skills;
  final List<String> selectedSkills;
  final Function(String) onSkillToggle;
  final bool showRemoveButton;

  const SkillChipList({
    super.key,
    required this.skills,
    required this.selectedSkills,
    required this.onSkillToggle,
    this.showRemoveButton = false,
  });

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) {
      return const Text(
        'Nenhuma habilidade disponível',
        style: TextStyle(
          fontSize: AppDimensions.fontSizeMd,
          color: AppColors.textSecondary,
        ),
      );
    }

    return Wrap(
      spacing: AppDimensions.spacingSm,
      runSpacing: AppDimensions.spacingSm,
      children: skills.map((skill) {
        final isSelected = selectedSkills.contains(skill);
        return SkillChip(
          label: skill,
          isSelected: isSelected,
          onTap: () => onSkillToggle(skill),
          showRemove: showRemoveButton && isSelected,
        );
      }).toList(),
    );
  }
}

/// Widget para exibir uma lista de chips de recursos
class ResourceChipList extends StatelessWidget {
  final List<String> resources;
  final List<String> selectedResources;
  final Function(String) onResourceToggle;
  final bool showRemoveButton;

  const ResourceChipList({
    super.key,
    required this.resources,
    required this.selectedResources,
    required this.onResourceToggle,
    this.showRemoveButton = false,
  });

  @override
  Widget build(BuildContext context) {
    if (resources.isEmpty) {
      return const Text(
        'Nenhum recurso disponível',
        style: TextStyle(
          fontSize: AppDimensions.fontSizeMd,
          color: AppColors.textSecondary,
        ),
      );
    }

    return Wrap(
      spacing: AppDimensions.spacingSm,
      runSpacing: AppDimensions.spacingSm,
      children: resources.map((resource) {
        final isSelected = selectedResources.contains(resource);
        return ResourceChip(
          label: resource,
          isSelected: isSelected,
          onTap: () => onResourceToggle(resource),
          showRemove: showRemoveButton && isSelected,
        );
      }).toList(),
    );
  }
}
