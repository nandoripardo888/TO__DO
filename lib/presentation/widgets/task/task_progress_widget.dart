import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/microtask_model.dart';

/// Widget para exibir o progresso de uma task ou microtask
class TaskProgressWidget extends StatelessWidget {
  final TaskModel? task;
  final MicrotaskModel? microtask;
  final bool showDetails;
  final bool showPercentage;
  final double? customProgress;
  final String? customLabel;

  const TaskProgressWidget({
    super.key,
    this.task,
    this.microtask,
    this.showDetails = true,
    this.showPercentage = true,
    this.customProgress,
    this.customLabel,
  }) : assert(task != null || microtask != null || customProgress != null);

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress();
    final color = _getProgressColor(progress);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header com título e porcentagem
        if (showDetails)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                customLabel ?? _getProgressLabel(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              if (showPercentage)
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
            ],
          ),
        
        if (showDetails)
          const SizedBox(height: 4),
        
        // Barra de progresso
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.border,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
        ),
        
        // Detalhes adicionais
        if (showDetails && (task != null || microtask != null)) ...[
          const SizedBox(height: 4),
          _buildProgressDetails(),
        ],
      ],
    );
  }

  Widget _buildProgressDetails() {
    if (task != null) {
      return _buildTaskDetails();
    } else if (microtask != null) {
      return _buildMicrotaskDetails();
    }
    return const SizedBox.shrink();
  }

  Widget _buildTaskDetails() {
    if (task == null) return const SizedBox.shrink();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${task!.completedMicrotasks} de ${task!.microtaskCount} microtasks',
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
        _buildStatusChip(task!.status.toString().split('.').last),
      ],
    );
  }

  Widget _buildMicrotaskDetails() {
    if (microtask == null) return const SizedBox.shrink();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Estimado: ${microtask!.estimatedHours}h',
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
        _buildStatusChip(microtask!.status.toString().split('.').last),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String text;
    
    switch (status.toLowerCase()) {
      case 'pending':
        color = AppColors.warning;
        text = 'Pendente';
        break;
      case 'assigned':
        color = AppColors.primary;
        text = 'Atribuída';
        break;
      case 'inprogress':
        color = AppColors.secondary;
        text = 'Em Progresso';
        break;
      case 'completed':
        color = AppColors.success;
        text = 'Concluída';
        break;
      case 'cancelled':
        color = AppColors.error;
        text = 'Cancelada';
        break;
      default:
        color = AppColors.textSecondary;
        text = status;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  double _calculateProgress() {
    if (customProgress != null) {
      return customProgress!.clamp(0.0, 1.0);
    }
    
    if (task != null) {
      if (task!.microtaskCount == 0) return 0.0;
      return (task!.completedMicrotasks / task!.microtaskCount).clamp(0.0, 1.0);
    }
    
    if (microtask != null) {
      switch (microtask!.status) {
        case MicrotaskStatus.pending:
          return 0.0;
        case MicrotaskStatus.assigned:
          return 0.1;
        case MicrotaskStatus.inProgress:
          return 0.5;
        case MicrotaskStatus.completed:
          return 1.0;
        case MicrotaskStatus.cancelled:
          return 0.0;
      }
    }
    
    return 0.0;
  }

  Color _getProgressColor(double progress) {
    if (progress == 0.0) {
      return AppColors.warning;
    } else if (progress == 1.0) {
      return AppColors.success;
    } else {
      return AppColors.primary;
    }
  }

  String _getProgressLabel() {
    if (task != null) {
      return 'Progresso da Task';
    } else if (microtask != null) {
      return 'Progresso da Microtask';
    } else {
      return 'Progresso';
    }
  }
}

/// Widget para exibir progresso circular
class CircularTaskProgressWidget extends StatelessWidget {
  final double progress;
  final double size;
  final Color? color;
  final String? centerText;
  final bool showPercentage;

  const CircularTaskProgressWidget({
    super.key,
    required this.progress,
    this.size = 60,
    this.color,
    this.centerText,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? _getProgressColor(progress);
    
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Círculo de progresso
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 4,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
          
          // Texto central
          if (showPercentage || centerText != null)
            Text(
              centerText ?? '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: size * 0.2,
                fontWeight: FontWeight.bold,
                color: progressColor,
              ),
            ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress == 0.0) {
      return AppColors.warning;
    } else if (progress == 1.0) {
      return AppColors.success;
    } else {
      return AppColors.primary;
    }
  }
}

/// Widget para exibir múltiplos progressos (ex: por voluntário)
class MultiProgressWidget extends StatelessWidget {
  final List<ProgressItem> items;
  final String title;

  const MultiProgressWidget({
    super.key,
    required this.items,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${(item.progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: item.color ?? _getProgressColor(item.progress),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              LinearProgressIndicator(
                value: item.progress,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(
                  item.color ?? _getProgressColor(item.progress),
                ),
                minHeight: 4,
              ),
            ],
          ),
        )),
      ],
    );
  }

  Color _getProgressColor(double progress) {
    if (progress == 0.0) {
      return AppColors.warning;
    } else if (progress == 1.0) {
      return AppColors.success;
    } else {
      return AppColors.primary;
    }
  }
}

/// Classe para representar um item de progresso
class ProgressItem {
  final String label;
  final double progress;
  final Color? color;

  const ProgressItem({
    required this.label,
    required this.progress,
    this.color,
  });
}
