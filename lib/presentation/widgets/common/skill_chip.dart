import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Chip para exibir habilidades e recursos
class SkillChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool isSelected;
  final bool isSmall;
  final bool showBorder;

  const SkillChip({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.onDelete,
    this.isSelected = false,
    this.isSmall = false,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = isSelected 
        ? AppColors.primary 
        : (color ?? AppColors.textSecondary);
    
    final chipBackgroundColor = isSelected
        ? AppColors.primary.withOpacity(0.1)
        : (backgroundColor ?? chipColor.withOpacity(0.1));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 8 : 12,
          vertical: isSmall ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: chipBackgroundColor,
          borderRadius: BorderRadius.circular(isSmall ? 12 : 16),
          border: showBorder ? Border.all(
            color: borderColor ?? chipColor.withOpacity(0.3),
            width: 1,
          ) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: isSmall ? 14 : 16,
                color: chipColor,
              ),
              SizedBox(width: isSmall ? 4 : 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: isSmall ? 11 : 13,
                fontWeight: FontWeight.w500,
                color: chipColor,
              ),
            ),
            if (onDelete != null) ...[
              SizedBox(width: isSmall ? 4 : 6),
              GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Icons.close,
                  size: isSmall ? 14 : 16,
                  color: chipColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Chip para habilidades específicas
class SkillTagChip extends StatelessWidget {
  final String skill;
  final bool isRequired;
  final bool hasSkill;
  final VoidCallback? onTap;

  const SkillTagChip({
    super.key,
    required this.skill,
    this.isRequired = false,
    this.hasSkill = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color chipColor;
    IconData? icon;

    if (isRequired && !hasSkill) {
      chipColor = AppColors.error;
      icon = Icons.warning;
    } else if (hasSkill) {
      chipColor = AppColors.success;
      icon = Icons.check_circle;
    } else {
      chipColor = AppColors.textSecondary;
    }

    return SkillChip(
      label: skill,
      icon: icon,
      color: chipColor,
      onTap: onTap,
      isSmall: true,
    );
  }
}

/// Chip para recursos
class ResourceChip extends StatelessWidget {
  final String resource;
  final bool isAvailable;
  final VoidCallback? onTap;

  const ResourceChip({
    super.key,
    required this.resource,
    this.isAvailable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SkillChip(
      label: resource,
      icon: isAvailable ? Icons.check : Icons.close,
      color: isAvailable ? AppColors.success : AppColors.error,
      onTap: onTap,
      isSmall: true,
    );
  }
}

/// Chip selecionável para filtros
class FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const FilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SkillChip(
      label: label,
      icon: icon,
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}

/// Widget para exibir lista de chips
class SkillChipList extends StatelessWidget {
  final List<String> items;
  final String? title;
  final IconData? itemIcon;
  final Color? chipColor;
  final bool isSmall;
  final bool showTitle;
  final Function(String)? onItemTap;
  final Function(String)? onItemDelete;
  final int? maxItems;
  final String? moreText;

  const SkillChipList({
    super.key,
    required this.items,
    this.title,
    this.itemIcon,
    this.chipColor,
    this.isSmall = false,
    this.showTitle = true,
    this.onItemTap,
    this.onItemDelete,
    this.maxItems,
    this.moreText,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final displayItems = maxItems != null && items.length > maxItems!
        ? items.take(maxItems!).toList()
        : items;
    
    final remainingCount = maxItems != null && items.length > maxItems!
        ? items.length - maxItems!
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle && title != null) ...[
          Text(
            title!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
        ],
        Wrap(
          spacing: AppDimensions.spacingXs,
          runSpacing: AppDimensions.spacingXs,
          children: [
            ...displayItems.map((item) => SkillChip(
              label: item,
              icon: itemIcon,
              color: chipColor,
              isSmall: isSmall,
              onTap: onItemTap != null ? () => onItemTap!(item) : null,
              onDelete: onItemDelete != null ? () => onItemDelete!(item) : null,
            )),
            if (remainingCount > 0)
              SkillChip(
                label: moreText ?? '+$remainingCount',
                color: AppColors.textSecondary,
                isSmall: isSmall,
              ),
          ],
        ),
      ],
    );
  }
}

/// Widget para seleção de habilidades
class SkillSelector extends StatefulWidget {
  final List<String> availableSkills;
  final List<String> selectedSkills;
  final Function(List<String>) onSelectionChanged;
  final String? title;
  final bool allowCustomSkills;

  const SkillSelector({
    super.key,
    required this.availableSkills,
    required this.selectedSkills,
    required this.onSelectionChanged,
    this.title,
    this.allowCustomSkills = false,
  });

  @override
  State<SkillSelector> createState() => _SkillSelectorState();
}

class _SkillSelectorState extends State<SkillSelector> {
  late List<String> _selectedSkills;
  final TextEditingController _customSkillController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedSkills = List.from(widget.selectedSkills);
  }

  @override
  void dispose() {
    _customSkillController.dispose();
    super.dispose();
  }

  void _toggleSkill(String skill) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        _selectedSkills.remove(skill);
      } else {
        _selectedSkills.add(skill);
      }
    });
    widget.onSelectionChanged(_selectedSkills);
  }

  void _addCustomSkill() {
    final skill = _customSkillController.text.trim();
    if (skill.isNotEmpty && !_selectedSkills.contains(skill)) {
      setState(() {
        _selectedSkills.add(skill);
        _customSkillController.clear();
      });
      widget.onSelectionChanged(_selectedSkills);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
        ],
        
        // Habilidades disponíveis
        Wrap(
          spacing: AppDimensions.spacingSm,
          runSpacing: AppDimensions.spacingSm,
          children: widget.availableSkills.map((skill) => FilterChip(
            label: skill,
            isSelected: _selectedSkills.contains(skill),
            onTap: () => _toggleSkill(skill),
          )).toList(),
        ),
        
        // Campo para habilidades customizadas
        if (widget.allowCustomSkills) ...[
          const SizedBox(height: AppDimensions.spacingMd),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customSkillController,
                  decoration: const InputDecoration(
                    hintText: 'Adicionar habilidade personalizada',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onSubmitted: (_) => _addCustomSkill(),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              IconButton(
                onPressed: _addCustomSkill,
                icon: const Icon(Icons.add),
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ],
    );
  }
}
