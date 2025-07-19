import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/event_model.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/task_controller.dart';
import '../../controllers/event_controller.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/loading_widget.dart';

/// Tela para criação de microtasks
class CreateMicrotaskScreen extends StatefulWidget {
  final String eventId;

  const CreateMicrotaskScreen({super.key, required this.eventId});

  @override
  State<CreateMicrotaskScreen> createState() => _CreateMicrotaskScreenState();
}

class _CreateMicrotaskScreenState extends State<CreateMicrotaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _maxVolunteersController = TextEditingController();
  final _notesController = TextEditingController();

  // Data e hora da microtask
  DateTime? _startDateTime;
  DateTime? _endDateTime;

  String? _selectedTaskId;
  TaskPriority _priority = TaskPriority.medium;
  final List<String> _selectedSkills = [];
  final List<String> _selectedResources = [];

  EventModel? _event;
  bool _isLoadingEvent = true;

  @override
  void initState() {
    super.initState();
    _loadEventDetails();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _maxVolunteersController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadEventDetails() async {
    try {
      final eventController = Provider.of<EventController>(
        context,
        listen: false,
      );
      final event = await eventController.loadEvent(widget.eventId);

      if (mounted) {
        setState(() {
          _event = event;
          _isLoadingEvent = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingEvent = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingEvent) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: LoadingWidget(message: 'Carreganda campanha...'),
      );
    }

    if (_event == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: 'Criar Microtask'),
        body: Center(child: Text('Erro ao carregar event')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const RoundedCustomAppBar(title: 'Criar Microtask'),
      body: Consumer2<AuthController, TaskController>(
        builder: (context, authController, taskController, child) {
          if (taskController.isLoading) {
            return const LoadingWidget(message: 'Criando microtask...');
          }

          final tasks = taskController.tasks;

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
                                Icons.checklist,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: AppDimensions.spacingSm),
                              const Text(
                                'Nova Microtask',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.spacingLg),

                          // Seleção da task pai
                          _buildTaskSelector(tasks),

                          const SizedBox(height: AppDimensions.spacingMd),

                          CustomTextField(
                            controller: _titleController,
                            label: 'Nome da Microtask',
                            hint: 'Ex: Montagem de Palco',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Nome da microtask é obrigatório';
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
                            label: 'Descrição Detalhada',
                            hint: 'Descreva exatamente o que deve ser feito...',
                            maxLines: 4,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Descrição é obrigatória';
                              }
                              if (value.trim().length > 1000) {
                                return 'Descrição deve ter no máximo 1000 caracteres';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: AppDimensions.spacingMd),

                          // Data e hora inicial
                          const Text(
                            'Data e Hora Inicial:',
                            style: TextStyle(
                              fontSize: AppDimensions.fontSizeMd,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacingSm),

                          GestureDetector(
                            onTap: () => _selectStartDateTime(context),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(
                                AppDimensions.paddingMd,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.border),
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMd,
                                ),
                              ),
                              child: Text(
                                _startDateTime != null
                                    ? '${_startDateTime!.day.toString().padLeft(2, '0')}/${_startDateTime!.month.toString().padLeft(2, '0')}/${_startDateTime!.year} ${_startDateTime!.hour.toString().padLeft(2, '0')}:${_startDateTime!.minute.toString().padLeft(2, '0')}'
                                    : 'Selecionar data e hora inicial',
                                style: TextStyle(
                                  fontSize: AppDimensions.fontSizeMd,
                                  color: _startDateTime != null
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: AppDimensions.spacingMd),

                          // Data e hora final
                          const Text(
                            'Data e Hora Final:',
                            style: TextStyle(
                              fontSize: AppDimensions.fontSizeMd,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacingSm),

                          GestureDetector(
                            onTap: () => _selectEndDateTime(context),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(
                                AppDimensions.paddingMd,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.border),
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMd,
                                ),
                              ),
                              child: Text(
                                _endDateTime != null
                                    ? '${_endDateTime!.day.toString().padLeft(2, '0')}/${_endDateTime!.month.toString().padLeft(2, '0')}/${_endDateTime!.year} ${_endDateTime!.hour.toString().padLeft(2, '0')}:${_endDateTime!.minute.toString().padLeft(2, '0')}'
                                    : 'Selecionar data e hora final',
                                style: TextStyle(
                                  fontSize: AppDimensions.fontSizeMd,
                                  color: _endDateTime != null
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: AppDimensions.spacingMd),

                          Row(
                            children: [
                              const SizedBox(width: AppDimensions.spacingMd),
                              Expanded(
                                child: CustomTextField(
                                  controller: _maxVolunteersController,
                                  label: 'Máx. Voluntários',
                                  hint: '3',
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Número máximo é obrigatório';
                                    }
                                    final max = int.tryParse(value.trim());
                                    if (max == null || max <= 0) {
                                      return 'Digite um número válido maior que 0';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppDimensions.spacingMd),

                          _buildPrioritySelector(),

                          const SizedBox(height: AppDimensions.spacingMd),

                          _buildSkillsSelector(),

                          const SizedBox(height: AppDimensions.spacingMd),

                          _buildResourcesSelector(),

                          const SizedBox(height: AppDimensions.spacingMd),

                          CustomTextField(
                            controller: _notesController,
                            label: 'Observações (Opcional)',
                            hint: 'Informações adicionais...',
                            maxLines: 2,
                          ),

                          const SizedBox(height: AppDimensions.spacingLg),

                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              text: 'Criar Microtask',
                              onPressed: _selectedTaskId != null
                                  ? () => _handleCreateMicrotask(
                                      authController,
                                      taskController,
                                    )
                                  : null,
                              isLoading: taskController.isLoading,
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

  Widget _buildTaskSelector(List<TaskModel> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Task Pai',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),

        if (tasks.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.error.withOpacity(0.3)),
            ),
            child: const Text(
              'Nenhuma task disponível. Crie uma task primeiro.',
              style: TextStyle(color: AppColors.error),
            ),
          )
        else
          DropdownButtonFormField<String>(
            value: _selectedTaskId,
            decoration: const InputDecoration(
              hintText: 'Selecione uma task',
              border: OutlineInputBorder(),
            ),
            items: tasks.map((task) {
              return DropdownMenuItem<String>(
                value: task.id,
                child: Text(task.title, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedTaskId = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Selecione uma task pai';
              }
              return null;
            },
          ),
      ],
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

  Widget _buildSkillsSelector() {
    final eventSkills = _event?.requiredSkills ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Habilidades Necessárias',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),

        if (eventSkills.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.warning.withOpacity(0.3)),
            ),
            child: const Text(
              'Nenhuma habilidade definida na campanha.',
              style: TextStyle(color: AppColors.warning),
            ),
          )
        else
          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingSm,
            children: eventSkills.map((skill) {
              final isSelected = _selectedSkills.contains(skill);
              return GestureDetector(
                onTap: () => _toggleSkill(skill),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMd,
                    vertical: AppDimensions.paddingSm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Text(
                    skill,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.textOnPrimary
                          : AppColors.textPrimary,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildResourcesSelector() {
    final eventResources = _event?.requiredResources ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recursos Necessários',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),

        if (eventResources.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.warning.withOpacity(0.3)),
            ),
            child: const Text(
              'Nenhum recurso definido na campanha.',
              style: TextStyle(color: AppColors.warning),
            ),
          )
        else
          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingSm,
            children: eventResources.map((resource) {
              final isSelected = _selectedResources.contains(resource);
              return GestureDetector(
                onTap: () => _toggleResource(resource),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMd,
                    vertical: AppDimensions.paddingSm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.secondary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.secondary
                          : AppColors.border,
                    ),
                  ),
                  child: Text(
                    resource,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.textOnPrimary
                          : AppColors.textPrimary,
                      fontSize: 12,
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

  void _toggleSkill(String skill) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        _selectedSkills.remove(skill);
      } else {
        _selectedSkills.add(skill);
      }
    });
  }

  void _toggleResource(String resource) {
    setState(() {
      if (_selectedResources.contains(resource)) {
        _selectedResources.remove(resource);
      } else {
        _selectedResources.add(resource);
      }
    });
  }

  Future<void> _selectStartDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_startDateTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          _startDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _selectEndDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDateTime ?? _startDateTime ?? DateTime.now(),
      firstDate: _startDateTime ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_endDateTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          _endDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _handleCreateMicrotask(
    AuthController authController,
    TaskController taskController,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    // Validação de data/hora
    if (_startDateTime == null || _endDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione a data e hora inicial e final'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_startDateTime!.isAfter(_endDateTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data/hora inicial deve ser anterior à final'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final success = await taskController.createMicrotask(
      taskId: _selectedTaskId!,
      eventId: widget.eventId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      requiredSkills: _selectedSkills,
      requiredResources: _selectedResources,
      startDateTime: _startDateTime,
      endDateTime: _endDateTime,
      priority: _priority.value,
      maxVolunteers: int.parse(_maxVolunteersController.text.trim()),
      createdBy: authController.currentUser!.id,
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microtask criada com sucesso!'),
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
