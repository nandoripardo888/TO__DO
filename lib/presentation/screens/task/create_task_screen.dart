import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/task_model.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/task_controller.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/loading_widget.dart';

/// Tela para criação de tasks
class CreateTaskScreen extends StatefulWidget {
  final String eventId;

  const CreateTaskScreen({super.key, required this.eventId});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TaskPriority _priority = TaskPriority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const RoundedCustomAppBar(title: 'Criar Task'),
      body: Consumer2<AuthController, TaskController>(
        builder: (context, authController, taskController, child) {
          if (taskController.isLoading) {
            return const LoadingWidget(message: 'Criando task...');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingLg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.paddingLg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.task_alt,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: AppDimensions.spacingSm),
                              const Text(
                                'Nova Task',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.spacingLg),

                          CustomTextField(
                            controller: _titleController,
                            label: 'Nome da Task',
                            hint: 'Ex: Organização do Local',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Nome da task é obrigatório';
                              }
                              if (value.trim().length < 3) {
                                return 'Nome deve ter pelo menos 3 caracteres';
                              }
                              if (value.trim().length > 100) {
                                return 'Nome deve ter no máximo 100 caracteres';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: AppDimensions.spacingMd),

                          CustomTextField(
                            controller: _descriptionController,
                            label: 'Descrição',
                            hint: 'Descreva o objetivo desta task...',
                            maxLines: 4,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Descrição é obrigatória';
                              }
                              if (value.trim().length > 500) {
                                return 'Descrição deve ter no máximo 500 caracteres';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: AppDimensions.spacingMd),

                          _buildPrioritySelector(),

                          const SizedBox(height: AppDimensions.spacingLg),

                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              text: 'Criar Task',
                              onPressed: () => _handleCreateTask(
                                authController,
                                taskController,
                              ),
                              isLoading: taskController.isLoading,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.spacingLg),

                  Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.paddingMd),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: AppDimensions.spacingSm),
                              const Text(
                                'Sobre Tasks',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.spacingSm),
                          const Text(
                            'Tasks são organizadores de trabalho que agrupam microtasks relacionadas. '
                            'Após criar uma task, você poderá adicionar microtasks específicas que '
                            'podem ser atribuídas a múltiplos voluntários.',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prioridade',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        Row(
          children: TaskPriority.values.map((priority) {
            final isSelected = _priority == priority;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: AppDimensions.spacingSm),
                child: GestureDetector(
                  onTap: () => setState(() => _priority = priority),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.paddingSm,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      _getPriorityText(priority),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.textOnPrimary
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 'Alta';
      case TaskPriority.medium:
        return 'Média';
      case TaskPriority.low:
        return 'Baixa';
    }
  }

  Future<void> _handleCreateTask(
    AuthController authController,
    TaskController taskController,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await taskController.createTask(
      eventId: widget.eventId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _priority,
      createdBy: authController.currentUser!.id,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task criada com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );

      // Volta para a tela anterior
      Navigator.of(context).pop();
    } else if (mounted && taskController.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(taskController.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
