import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/microtask_model.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/volunteer_profile_model.dart';

/// Widget de card para atribuição de microtask a voluntário
class MicrotaskAssignmentCard extends StatefulWidget {
  final MicrotaskModel microtask;
  final TaskModel? task;
  final bool isCompatible;
  final int availableSlots;
  final int maxVolunteers;
  final VolunteerProfileModel? volunteerProfile;
  final VoidCallback onAssign;

  const MicrotaskAssignmentCard({
    super.key,
    required this.microtask,
    this.task,
    required this.isCompatible,
    required this.availableSlots,
    required this.maxVolunteers,
    this.volunteerProfile,
    required this.onAssign,
  });

  @override
  State<MicrotaskAssignmentCard> createState() => _MicrotaskAssignmentCardState();
}

class _MicrotaskAssignmentCardState extends State<MicrotaskAssignmentCard>
    with TickerProviderStateMixin {
  bool _isAssigning = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _handleAssign() async {
    if (_isAssigning) return;
    
    setState(() {
      _isAssigning = true;
    });
    
    await _scaleController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    await _scaleController.reverse();
    
    widget.onAssign();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Card(
            margin: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
            elevation: _isAssigning ? 8 : 2,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: _isAssigning 
                    ? Border.all(color: AppColors.primary.withOpacity(0.5), width: 2)
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header com título e task pai
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.microtask.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (widget.task != null) ...[  
                                const SizedBox(height: 2),
                                Text(
                                  'Task: ${widget.task!.title}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (widget.isCompatible)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.success.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, size: 12, color: AppColors.success),
                                const SizedBox(width: 2),
                                Text(
                                  'Compatível',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: AppDimensions.spacingMd),

                    // Descrição
                    Text(
                      widget.microtask.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: AppDimensions.spacingMd),

                    // Informações da microtask
                    Wrap(
                      spacing: AppDimensions.spacingSm,
                      runSpacing: AppDimensions.spacingSm,
                      children: [
                        _buildInfoChip(
                          icon: Icons.schedule,
                          label: widget.microtask.hasSchedule
                              ? widget.microtask.periodFormatted
                              : 'Horário flexível',
                          color: AppColors.secondary,
                        ),
                        _buildInfoChip(
                          icon: Icons.people,
                          label: 'Vagas: ${widget.availableSlots} de ${widget.maxVolunteers}',
                          color: _getVacancyColor(
                            widget.availableSlots,
                            widget.maxVolunteers,
                          ),
                        ),
                        if (widget.microtask.status != MicrotaskStatus.pending)
                          _buildInfoChip(
                            icon: Icons.info_outline,
                            label: _getStatusText(widget.microtask.status),
                            color: _getStatusColor(widget.microtask.status),
                          ),
                      ],
                    ),

                    // Habilidades necessárias
                    if (widget.microtask.requiredSkills.isNotEmpty) ...[  
                      const SizedBox(height: AppDimensions.spacingMd),
                      _buildSkillsSection(),
                    ],

                    const SizedBox(height: AppDimensions.spacingMd),

                    // Botão de atribuição
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.availableSlots > 0 && !_isAssigning
                            ? _handleAssign
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.isCompatible
                              ? AppColors.success
                              : AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: _isAssigning
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('Atribuindo...'),
                                ],
                              )
                            : Text(
                                widget.availableSlots > 0
                                    ? (widget.isCompatible ? 'Atribuir (Compatível)' : 'Atribuir')
                                    : 'Sem vagas disponíveis',
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }



  // Widget de chip informativo
  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Cor baseada no número de vagas disponíveis
  Color _getVacancyColor(int available, int total) {
    final ratio = available / total;
    if (ratio > 0.5) return AppColors.success;
    if (ratio > 0.2) return AppColors.warning;
    return AppColors.error;
  }

  // Texto do status da microtask
  String _getStatusText(MicrotaskStatus status) {
    switch (status) {
      case MicrotaskStatus.pending:
        return 'Pendente';
      case MicrotaskStatus.assigned:
        return 'Atribuída';
      case MicrotaskStatus.inProgress:
        return 'Em andamento';
      case MicrotaskStatus.completed:
        return 'Concluída';
      case MicrotaskStatus.cancelled:
        return 'Cancelada';
    }
  }

  // Cor do status da microtask
  Color _getStatusColor(MicrotaskStatus status) {
    switch (status) {
      case MicrotaskStatus.pending:
        return AppColors.textSecondary;
      case MicrotaskStatus.assigned:
        return AppColors.primary;
      case MicrotaskStatus.inProgress:
        return AppColors.warning;
      case MicrotaskStatus.completed:
        return AppColors.success;
      case MicrotaskStatus.cancelled:
        return AppColors.error;
    }
  }

  // Seção de habilidades necessárias
  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Habilidades necessárias:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: widget.microtask.requiredSkills.map((skill) {
            final hasSkill = widget.volunteerProfile?.skills.contains(skill) ?? false;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: hasSkill
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.textSecondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: hasSkill
                      ? AppColors.success.withOpacity(0.3)
                      : AppColors.textSecondary.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasSkill)
                    Icon(
                      Icons.check_circle,
                      size: 10,
                      color: AppColors.success,
                    ),
                  if (hasSkill) const SizedBox(width: 2),
                  Text(
                    skill,
                    style: TextStyle(
                      fontSize: 10,
                      color: hasSkill
                          ? AppColors.success
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}