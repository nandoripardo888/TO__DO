import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/volunteer_profile_model.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/event_controller.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/event/skill_chip.dart';

/// Tela para participar de eventos existentes via código/tag
class JoinEventScreen extends StatefulWidget {
  const JoinEventScreen({super.key});

  @override
  State<JoinEventScreen> createState() => _JoinEventScreenState();
}

class _JoinEventScreenState extends State<JoinEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tagController = TextEditingController();

  // Controllers para o perfil do voluntário
  final _skillController = TextEditingController();
  final _resourceController = TextEditingController();

  // Estado da busca
  bool _hasSearched = false;

  // Dados do perfil do voluntário
  final List<String> _selectedSkills = [];
  final List<String> _selectedResources = [];
  final List<String> _selectedDays = [];
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 18, minute: 0);
  bool _isFullTimeAvailable = false; // Disponibilidade integral

  // Dias da semana
  final List<Map<String, String>> _weekDays = [
    {'key': 'monday', 'label': 'Segunda-feira'},
    {'key': 'tuesday', 'label': 'Terça-feira'},
    {'key': 'wednesday', 'label': 'Quarta-feira'},
    {'key': 'thursday', 'label': 'Quinta-feira'},
    {'key': 'friday', 'label': 'Sexta-feira'},
    {'key': 'saturday', 'label': 'Sábado'},
    {'key': 'sunday', 'label': 'Domingo'},
  ];

  @override
  void dispose() {
    _tagController.dispose();
    _skillController.dispose();
    _resourceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Participar de Evento'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
      ),
      body: Consumer2<AuthController, EventController>(
        builder: (context, authController, eventController, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Seção de busca do evento
                _buildSearchSection(eventController),

                // Exibe detalhes do evento encontrado
                if (_hasSearched && eventController.searchedEvent != null) ...[
                  const SizedBox(height: AppDimensions.spacingLg),
                  _buildEventDetailsSection(
                    eventController.searchedEvent!,
                    authController.currentUser?.id,
                  ),

                  // Só mostra formulário e botão se usuário não for participante
                  if (!_isUserParticipant(
                    eventController.searchedEvent!,
                    authController.currentUser?.id,
                  )) ...[
                    const SizedBox(height: AppDimensions.spacingLg),

                    // Formulário do perfil do voluntário
                    _buildVolunteerProfileForm(),

                    const SizedBox(height: AppDimensions.spacingXl),

                    // Botão de participar
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: 'Confirmar Participação',
                        onPressed: () =>
                            _handleJoinEvent(authController, eventController),
                        isLoading: eventController.isJoiningEvent,
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: AppDimensions.spacingLg),
                    _buildAlreadyParticipantMessage(
                      eventController.searchedEvent!,
                      authController.currentUser?.id,
                    ),
                  ],
                ],

                // Mensagem de erro
                if (eventController.hasError) ...[
                  const SizedBox(height: AppDimensions.spacingMd),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimensions.paddingMd),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMd,
                      ),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 20,
                        ),
                        const SizedBox(width: AppDimensions.spacingSm),
                        Expanded(
                          child: Text(
                            eventController.errorMessage ?? 'Erro desconhecido',
                            style: const TextStyle(
                              color: AppColors.error,
                              fontSize: AppDimensions.fontSizeMd,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchSection(EventController eventController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Buscar Evento',
          style: TextStyle(
            fontSize: AppDimensions.fontSizeLg,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        const Text(
          'Digite o código do evento que você deseja participar',
          style: TextStyle(
            fontSize: AppDimensions.fontSizeMd,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: CustomTextField(
                controller: _tagController,
                label: 'Código do Evento',
                hint: 'Ex: ABC123',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Código do evento é obrigatório';
                  }
                  if (value.trim().length != 6) {
                    return 'Código deve ter exatamente 6 caracteres';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: CustomButton(
                text: 'Buscar',
                onPressed: () => _handleSearchEvent(eventController),
                isLoading: eventController.isLoading,
                isFullWidth: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventDetailsSection(EventModel event, String? currentUserId) {
    return Card(
      elevation: AppDimensions.elevationSm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.event, color: AppColors.primary, size: 28),
                const SizedBox(width: AppDimensions.spacingSm),
                const Text(
                  'Evento Encontrado',
                  style: TextStyle(
                    fontSize: AppDimensions.fontSizeLg,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimensions.spacingMd),

            // Nome do evento
            Text(
              event.name,
              style: const TextStyle(
                fontSize: AppDimensions.fontSizeXl,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: AppDimensions.spacingSm),

            // Descrição
            if (event.description.isNotEmpty) ...[
              Text(
                event.description,
                style: const TextStyle(
                  fontSize: AppDimensions.fontSizeMd,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
            ],

            // Localização
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppDimensions.spacingXs),
                Expanded(
                  child: Text(
                    event.location,
                    style: const TextStyle(
                      fontSize: AppDimensions.fontSizeMd,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimensions.spacingMd),

            // Habilidades necessárias
            if (event.requiredSkills.isNotEmpty) ...[
              const Text(
                'Habilidades necessárias:',
                style: TextStyle(
                  fontSize: AppDimensions.fontSizeMd,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Wrap(
                spacing: AppDimensions.spacingSm,
                runSpacing: AppDimensions.spacingSm,
                children: event.requiredSkills.map((skill) {
                  return SkillChip(label: skill, isSelected: false);
                }).toList(),
              ),
              const SizedBox(height: AppDimensions.spacingMd),
            ],

            // Recursos necessários
            if (event.requiredResources.isNotEmpty) ...[
              const Text(
                'Recursos necessários:',
                style: TextStyle(
                  fontSize: AppDimensions.fontSizeMd,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Wrap(
                spacing: AppDimensions.spacingSm,
                runSpacing: AppDimensions.spacingSm,
                children: event.requiredResources.map((resource) {
                  return SkillChip(label: resource, isSelected: false);
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVolunteerProfileForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Seu Perfil de Voluntário',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeLg,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          const Text(
            'Preencha suas informações para participar do evento',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeMd,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLg),

          // Disponibilidade - Dias
          _buildAvailabilitySection(),

          const SizedBox(height: AppDimensions.spacingLg),

          // Habilidades
          _buildSkillsSection(),

          const SizedBox(height: AppDimensions.spacingLg),

          // Recursos
          _buildResourcesSection(),
        ],
      ),
    );
  }

  Widget _buildAvailabilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Disponibilidade',
          style: TextStyle(
            fontSize: AppDimensions.fontSizeMd,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),

        // Opção de disponibilidade integral
        CheckboxListTile(
          title: const Text(
            'Disponibilidade integral (qualquer horário)',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeMd,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: const Text(
            'Marque esta opção se você está disponível a qualquer momento',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeSm,
              color: AppColors.textSecondary,
            ),
          ),
          value: _isFullTimeAvailable,
          onChanged: (bool? value) {
            setState(() {
              _isFullTimeAvailable = value ?? false;
              if (_isFullTimeAvailable) {
                // Limpa seleções específicas quando disponibilidade integral é marcada
                _selectedDays.clear();
              }
            });
          },
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
        ),

        const SizedBox(height: AppDimensions.spacingMd),

        // Seção de disponibilidade específica (só aparece se não for integral)
        if (!_isFullTimeAvailable) ...[
          // Dias da semana
          const Text(
            'Dias disponíveis:',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeMd,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),

          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingSm,
            children: _weekDays.map((day) {
              final isSelected = _selectedDays.contains(day['key']);
              return SkillChip(
                label: day['label']!,
                isSelected: isSelected,
                onTap: () => _toggleDay(day['key']!),
              );
            }).toList(),
          ),

          const SizedBox(height: AppDimensions.spacingMd),

          // Horários
          const Text(
            'Horário disponível:',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeMd,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectTime(context, true),
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingMd),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMd,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Início',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSizeSm,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingXs),
                        Text(
                          _startTime.format(context),
                          style: const TextStyle(
                            fontSize: AppDimensions.fontSizeLg,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingMd),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectTime(context, false),
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingMd),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMd,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Fim',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSizeSm,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingXs),
                        Text(
                          _endTime.format(context),
                          style: const TextStyle(
                            fontSize: AppDimensions.fontSizeLg,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ], // Fecha a seção condicional
      ],
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Suas Habilidades',
          style: TextStyle(
            fontSize: AppDimensions.fontSizeMd,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        const Text(
          'Selecione suas habilidades',
          style: TextStyle(
            fontSize: AppDimensions.fontSizeMd,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),

        // Campo para adicionar nova habilidade
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: CustomTextField(
                controller: _skillController,
                label: 'Nova Habilidade',
                hint: 'Digite uma habilidade',
              ),
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: CustomButton(
                text: 'Adicionar',
                onPressed: _addSkill,
                isFullWidth: false,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.spacingMd),

        // Habilidades necessárias do evento
        Consumer<EventController>(
          builder: (context, eventController, child) {
            final event = eventController.searchedEvent;
            if (event != null && event.requiredSkills.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Habilidades necessárias para este evento:',
                    style: TextStyle(
                      fontSize: AppDimensions.fontSizeMd,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),

                  Wrap(
                    spacing: AppDimensions.spacingSm,
                    runSpacing: AppDimensions.spacingSm,
                    children: event.requiredSkills.map((skill) {
                      final isSelected = _selectedSkills.contains(skill);
                      return SkillChip(
                        label: skill,
                        isSelected: isSelected,
                        onTap: () => _toggleSkill(skill),
                        backgroundColor: isSelected
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : AppColors.warning.withValues(alpha: 0.1),
                        textColor: isSelected
                            ? AppColors.primary
                            : AppColors.warning,
                        borderColor: isSelected
                            ? AppColors.primary.withValues(alpha: 0.3)
                            : AppColors.warning.withValues(alpha: 0.3),
                      );
                    }).toList(),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),

        // Habilidades selecionadas
        if (_selectedSkills.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.spacingMd),
          const Text(
            'Habilidades selecionadas:',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeMd,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingSm,
            children: _selectedSkills.map((skill) {
              return SkillChip(
                label: skill,
                isSelected: true,
                onTap: () => _removeSkill(skill),
                showRemove: true,
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildResourcesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seus Recursos',
          style: TextStyle(
            fontSize: AppDimensions.fontSizeMd,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        const Text(
          'Selecione os recursos que você possui',
          style: TextStyle(
            fontSize: AppDimensions.fontSizeMd,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),

        // Campo para adicionar novo recurso
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: CustomTextField(
                controller: _resourceController,
                label: 'Novo Recurso',
                hint: 'Digite um recurso',
              ),
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: CustomButton(
                text: 'Adicionar',
                onPressed: _addResource,
                isFullWidth: false,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.spacingMd),

        // Recursos necessários do evento
        Consumer<EventController>(
          builder: (context, eventController, child) {
            final event = eventController.searchedEvent;
            if (event != null && event.requiredResources.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recursos necessários para este evento:',
                    style: TextStyle(
                      fontSize: AppDimensions.fontSizeMd,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),

                  Wrap(
                    spacing: AppDimensions.spacingSm,
                    runSpacing: AppDimensions.spacingSm,
                    children: event.requiredResources.map((resource) {
                      final isSelected = _selectedResources.contains(resource);
                      return SkillChip(
                        label: resource,
                        isSelected: isSelected,
                        onTap: () => _toggleResource(resource),
                        backgroundColor: isSelected
                            ? AppColors.secondary.withValues(alpha: 0.1)
                            : AppColors.info.withValues(alpha: 0.1),
                        textColor: isSelected
                            ? AppColors.secondary
                            : AppColors.info,
                        borderColor: isSelected
                            ? AppColors.secondary.withValues(alpha: 0.3)
                            : AppColors.info.withValues(alpha: 0.3),
                      );
                    }).toList(),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),

        // Recursos selecionados
        if (_selectedResources.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.spacingMd),
          const Text(
            'Recursos selecionados:',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeMd,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingSm,
            children: _selectedResources.map((resource) {
              return SkillChip(
                label: resource,
                isSelected: true,
                onTap: () => _removeResource(resource),
                showRemove: true,
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  // Métodos para gerenciar dias da semana
  void _toggleDay(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  // Métodos para gerenciar horários
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  // Métodos para gerenciar habilidades
  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty && !_selectedSkills.contains(skill)) {
      setState(() {
        _selectedSkills.add(skill);
        _skillController.clear();
      });
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

  void _removeSkill(String skill) {
    setState(() {
      _selectedSkills.remove(skill);
    });
  }

  // Métodos para gerenciar recursos
  void _addResource() {
    final resource = _resourceController.text.trim();
    if (resource.isNotEmpty && !_selectedResources.contains(resource)) {
      setState(() {
        _selectedResources.add(resource);
        _resourceController.clear();
      });
    }
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

  void _removeResource(String resource) {
    setState(() {
      _selectedResources.remove(resource);
    });
  }

  // Método para buscar evento
  Future<void> _handleSearchEvent(EventController eventController) async {
    final tag = _tagController.text.trim();
    if (tag.isEmpty) {
      return;
    }

    eventController.clearError();

    final event = await eventController.searchEventByTag(tag);

    setState(() {
      _hasSearched = true;
    });

    if (event == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Evento não encontrado'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  // Método para participar do evento
  Future<void> _handleJoinEvent(
    AuthController authController,
    EventController eventController,
  ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = authController.currentUser;
    final event = eventController.searchedEvent;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário não encontrado'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (event == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Evento não encontrado'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Validações específicas
    if (!_isFullTimeAvailable && _selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Selecione pelo menos um dia de disponibilidade ou marque disponibilidade integral',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Converte horários para string (ou usa valores padrão para disponibilidade integral)
    final startTimeString = _isFullTimeAvailable
        ? '00:00'
        : '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}';
    final endTimeString = _isFullTimeAvailable
        ? '23:59'
        : '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}';

    final timeRange = TimeRange(start: startTimeString, end: endTimeString);

    // Para disponibilidade integral, usa todos os dias da semana
    final availableDays = _isFullTimeAvailable
        ? [
            'monday',
            'tuesday',
            'wednesday',
            'thursday',
            'friday',
            'saturday',
            'sunday',
          ]
        : _selectedDays;

    // Limpa erros anteriores
    eventController.clearError();

    final success = await eventController.joinEvent(
      eventId: event.id,
      userId: user.id,
      availableDays: availableDays,
      availableHours: timeRange,
      isFullTimeAvailable: _isFullTimeAvailable,
      skills: _selectedSkills,
      resources: _selectedResources,
    );

    if (success && mounted) {
      // Mostra dialog de sucesso
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 28),
            SizedBox(width: AppDimensions.spacingSm),
            Text('Participação Confirmada!'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Você agora faz parte deste evento!',
              style: TextStyle(fontSize: AppDimensions.fontSizeMd),
            ),
            SizedBox(height: AppDimensions.spacingMd),
            Text(
              'Você pode acompanhar o evento na tela inicial e receber atualizações dos organizadores.',
              style: TextStyle(
                fontSize: AppDimensions.fontSizeSm,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          CustomButton(
            text: 'Continuar',
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o dialog
              Navigator.of(context).pop(); // Volta para a tela anterior
            },
          ),
        ],
      ),
    );
  }

  // Verifica se o usuário já é participante do evento
  bool _isUserParticipant(EventModel event, String? userId) {
    if (userId == null) return false;
    return event.isParticipant(userId);
  }

  // Widget para mostrar que o usuário já é participante
  Widget _buildAlreadyParticipantMessage(EventModel event, String? userId) {
    if (userId == null) return const SizedBox.shrink();

    final userRole = event.getUserRole(userId);
    String roleText;
    Color roleColor;
    IconData roleIcon;

    switch (userRole) {
      case UserRole.creator:
        roleText = 'Você é o criador deste evento';
        roleColor = AppColors.primary;
        roleIcon = Icons.star;
        break;
      case UserRole.manager:
        roleText = 'Você é gerenciador deste evento';
        roleColor = AppColors.secondary;
        roleIcon = Icons.admin_panel_settings;
        break;
      case UserRole.volunteer:
        roleText = 'Você já é voluntário neste evento';
        roleColor = AppColors.success;
        roleIcon = Icons.volunteer_activism;
        break;
      case UserRole.none:
        return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      decoration: BoxDecoration(
        color: roleColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: roleColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(roleIcon, size: 48, color: roleColor),
          const SizedBox(height: AppDimensions.spacingMd),
          Text(
            roleText,
            style: TextStyle(
              fontSize: AppDimensions.fontSizeLg,
              fontWeight: FontWeight.bold,
              color: roleColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            'Você pode acompanhar este evento na tela inicial.',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeMd,
              color: roleColor.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          SizedBox(
            width: double.infinity,
            child: CustomButton.outline(
              text: 'Voltar à Tela Inicial',
              onPressed: () {
                Navigator.of(context).pop(); // Volta para a tela anterior
              },
            ),
          ),
        ],
      ),
    );
  }
}
