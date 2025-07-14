import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/task_model.dart';

/// Widget card para exibir informações de uma task
class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onExpand;
  final bool isExpanded;
  final Widget? expandedContent;
  final bool showProgress;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onExpand,
    this.isExpanded = false,
    this.expandedContent,
    this.showProgress = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingSm,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header com título e ações
                  Row(
                    children: [
                      // Ícone de status
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getStatusColor(),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacingSm),
                      
                      // Título
                      Expanded(
                        child: Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      
                      // Badge de prioridade
                      _buildPriorityBadge(),
                      
                      // Botão de expandir (se disponível)
                      if (onExpand != null) ...[
                        const SizedBox(width: AppDimensions.spacingSm),
                        IconButton(
                          onPressed: onExpand,
                          icon: Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: AppColors.textSecondary,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: AppDimensions.spacingSm),
                  
                  // Descrição
                  if (task.description.isNotEmpty)
                    Text(
                      task.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: isExpanded ? null : 2,
                      overflow: isExpanded ? null : TextOverflow.ellipsis,
                    ),
                  
                  const SizedBox(height: AppDimensions.spacingMd),
                  
                  // Informações da task
                  Row(
                    children: [
                      // Status
                      _buildInfoChip(
                        icon: Icons.info_outline,
                        label: _getStatusText(),
                        color: _getStatusColor(),
                      ),
                      
                      const SizedBox(width: AppDimensions.spacingSm),
                      
                      // Contador de microtasks
                      _buildInfoChip(
                        icon: Icons.checklist,
                        label: '${task.completedMicrotasks}/${task.microtaskCount}',
                        color: AppColors.secondary,
                      ),
                      
                      const Spacer(),
                      
                      // Data de criação
                      Text(
                        _formatDate(task.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  
                  // Barra de progresso (se habilitada)
                  if (showProgress && task.microtaskCount > 0) ...[
                    const SizedBox(height: AppDimensions.spacingMd),
                    _buildProgressBar(),
                  ],
                ],
              ),
            ),
          ),
          
          // Conteúdo expandido
          if (isExpanded && expandedContent != null)
            expandedContent!,
        ],
      ),
    );
  }

  Widget _buildPriorityBadge() {
    Color color;
    String text;
    
    switch (task.priority) {
      case TaskPriority.high:
        color = AppColors.error;
        text = 'Alta';
        break;
      case TaskPriority.medium:
        color = AppColors.warning;
        text = 'Média';
        break;
      case TaskPriority.low:
        color = AppColors.success;
        text = 'Baixa';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = task.microtaskCount > 0 
        ? task.completedMicrotasks / task.microtaskCount 
        : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Progresso',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.border,
          valueColor: AlwaysStoppedAnimation<Color>(
            progress == 1.0 ? AppColors.success : AppColors.primary,
          ),
          minHeight: 6,
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (task.status) {
      case TaskStatus.pending:
        return AppColors.warning;
      case TaskStatus.inProgress:
        return AppColors.primary;
      case TaskStatus.completed:
        return AppColors.success;
      case TaskStatus.cancelled:
        return AppColors.error;
    }
  }

  String _getStatusText() {
    switch (task.status) {
      case TaskStatus.pending:
        return 'Pendente';
      case TaskStatus.inProgress:
        return 'Em Progresso';
      case TaskStatus.completed:
        return 'Concluída';
      case TaskStatus.cancelled:
        return 'Cancelada';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Hoje';
    } else if (difference.inDays == 1) {
      return 'Ontem';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dias atrás';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
