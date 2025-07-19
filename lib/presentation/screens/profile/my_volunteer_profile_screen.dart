import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/volunteer_profile_model.dart';
import '../../../data/models/event_model.dart';
import '../../controllers/event_controller.dart';

import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/event/skill_chip.dart';

/// Tela de perfil de voluntário baseada exatamente no layout da join_event_screen.dart
/// Suporta modo de visualização e edição
class MyVolunteerProfileScreen extends StatefulWidget {
  final String eventId;
  final String userId;
  final bool isEditMode;
  final bool showAppBar; // Controla se deve mostrar o app bar

  const MyVolunteerProfileScreen({
    super.key,
    required this.eventId,
    required this.userId,
    this.isEditMode = false,
    this.showAppBar = true, // Por padrão mostra o app bar
  });

  @override
  State<MyVolunteerProfileScreen> createState() =>
      _MyVolunteerProfileScreenState();
}

class _MyVolunteerProfileScreenState extends State<MyVolunteerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _skillController = TextEditingController();
  final _resourceController = TextEditingController();

  // Estados do formulário
  VolunteerProfileModel? _profile;
  EventModel? _event;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isEditMode = false;
  String? _errorMessage;

  // Dados do formulário - exatamente como na join_event_screen.dart
  List<String> _selectedDays = [];
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);
  bool _isFullTimeAvailable = false;
  List<String> _selectedSkills = [];
  List<String> _selectedResources = [];

  // Dados originais para cancelar alterações
  List<String> _originalSelectedDays = [];
  TimeOfDay _originalStartTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _originalEndTime = const TimeOfDay(hour: 17, minute: 0);
  bool _originalIsFullTimeAvailable = false;
  List<String> _originalSelectedSkills = [];
  List<String> _originalSelectedResources = [];

  // Dias da semana - exatamente como na join_event_screen.dart
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
  void initState() {
    super.initState();
    _isEditMode = widget.isEditMode;
    _loadData();
  }

  @override
  void dispose() {
    _skillController.dispose();
    _resourceController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      if (mounted)
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });

      final eventController = Provider.of<EventController>(
        context,
        listen: false,
      );

      // Carrega o evento
      final event = await eventController.loadEvent(widget.eventId);
      if (event == null) {
        throw Exception('Evento não encontrado');
      }

      // Carrega o perfil do voluntário
      final profile = await eventController.getVolunteerProfile(
        widget.userId,
        widget.eventId,
      );
      if (profile == null) {
        throw Exception('Perfil de voluntário não encontrado');
      }

      // Inicializa os campos do formulário com os dados atuais
      _initializeFormData(profile);

      if (!mounted) return;
      setState(() {
        _event = event;
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _initializeFormData(VolunteerProfileModel profile) {
    // Inicializa dados atuais
    _selectedDays = List.from(profile.availableDays);
    _isFullTimeAvailable = profile.isFullTimeAvailable;
    _selectedSkills = List.from(profile.skills);
    _selectedResources = List.from(profile.resources);

    // Salva dados originais para cancelar alterações
    _originalSelectedDays = List.from(profile.availableDays);
    _originalIsFullTimeAvailable = profile.isFullTimeAvailable;
    _originalSelectedSkills = List.from(profile.skills);
    _originalSelectedResources = List.from(profile.resources);

    // Converte horários de string para TimeOfDay
    final startParts = profile.availableHours.start.split(':');
    final endParts = profile.availableHours.end.split(':');

    _startTime = TimeOfDay(
      hour: int.parse(startParts[0]),
      minute: int.parse(startParts[1]),
    );

    _endTime = TimeOfDay(
      hour: int.parse(endParts[0]),
      minute: int.parse(endParts[1]),
    );

    // Salva horários originais
    _originalStartTime = _startTime;
    _originalEndTime = _endTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: widget.showAppBar ? _buildAppBar() : null,
      body: _buildBody(),
      // 1 - Botão flutuante para editar quando estiver visualizando
      floatingActionButton: widget.showAppBar
          ? _buildFloatingActionButton()
          : null,
    );
  }

  /// Constrói o AppBar baseado no modo atual
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      title: Text(
        _isEditMode ? 'Editar Perfil' : 'Perfil',
        style: const TextStyle(
          fontSize: AppDimensions.fontSizeLg,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (_isEditMode) {
            // Se estiver editando, cancela as alterações e volta
            _cancelChanges();
          } else {
            // Se estiver visualizando, volta para a tela anterior
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    // Só mostra o FAB quando estiver visualizando (não editando) e não carregando
    if (_isEditMode || _isLoading || _isSaving) return null;

    return FloatingActionButton(
      onPressed: () {
        setState(() {
          _isEditMode = true;
        });
      },
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      tooltip: 'Editar Perfil',
      child: const Icon(Icons.edit),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: LoadingWidget());
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_profile == null || _event == null) {
      return const Center(
        child: Text(
          'Dados não encontrados',
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
      );
    }

    // Layout exatamente igual ao join_event_screen.dart
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informações do evento (substitui a busca de evento)
            _buildEventInfoCard(),

            const SizedBox(height: AppDimensions.spacingLg),

            // Formulário do perfil do voluntário (exatamente como join_event_screen.dart)
            _buildVolunteerProfileForm(),

            const SizedBox(height: AppDimensions.spacingXl),

            // 2 - Botões quando editando (substitui "Confirmar Participação")
            if (_isEditMode) ...[
              Row(
                children: [
                  // Botão Cancelar Alterações
                  Expanded(
                    child: CustomButton(
                      text: 'Cancelar',
                      onPressed: _isSaving ? null : _cancelChanges,
                      type: CustomButtonType.outline,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingMd),
                  // Botão Salvar Alterações
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      text: 'Salvar Alterações',
                      onPressed: _handleSave,
                      isLoading: _isSaving,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 80), // Espaço para o FAB
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          const Text(
            'Erro ao carregar dados',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadData,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
            ),
            child: const Text('Tentar Novamente'),
          ),
        ],
      ),
    );
  }

  // Informações do evento - baseado no _buildEventDetailsSection da join_event_screen.dart
  Widget _buildEventInfoCard() {
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
                  'Evento',
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
              _event!.name,
              style: const TextStyle(
                fontSize: AppDimensions.fontSizeXl,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: AppDimensions.spacingSm),

            // Descrição
            if (_event!.description.isNotEmpty) ...[
              Text(
                _event!.description,
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
                    _event!.location,
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
            if (_event!.requiredSkills.isNotEmpty) ...[
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
                spacing: 8,
                runSpacing: 8,
                children: _event!.requiredSkills.map((skill) {
                  return SkillChip(
                    label: skill,
                    isSelected: false,
                    onTap: null, // Não clicável na visualização do evento
                  );
                }).toList(),
              ),
              const SizedBox(height: AppDimensions.spacingMd),
            ],

            // Recursos necessários
            if (_event!.requiredResources.isNotEmpty) ...[
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
                spacing: 8,
                runSpacing: 8,
                children: _event!.requiredResources.map((resource) {
                  return SkillChip(
                    label: resource,
                    isSelected: false,
                    onTap: null, // Não clicável na visualização do evento
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Formulário do perfil - exatamente como na join_event_screen.dart
  Widget _buildVolunteerProfileForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isEditMode
              ? 'Editar Perfil de Voluntário'
              : 'Seu Perfil de Voluntário',
          style: const TextStyle(
            fontSize: AppDimensions.fontSizeLg,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        Text(
          _isEditMode
              ? 'Atualize suas informações de voluntário'
              : 'Suas informações de voluntário para este evento',
          style: const TextStyle(
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
    );
  }

  // Seção de disponibilidade - exatamente como na join_event_screen.dart
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
          onChanged: _isEditMode
              ? (bool? value) {
                  setState(() {
                    _isFullTimeAvailable = value ?? false;
                    if (_isFullTimeAvailable) {
                      // Limpa seleções específicas quando disponibilidade integral é marcada
                      _selectedDays.clear();
                    }
                  });
                }
              : null,
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
                onTap: _isEditMode ? () => _toggleDay(day['key']!) : null,
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
                  onTap: _isEditMode ? () => _selectTime(context, true) : null,
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingMd),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMd,
                      ),
                      color: _isEditMode ? null : AppColors.background,
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
                  onTap: _isEditMode ? () => _selectTime(context, false) : null,
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingMd),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMd,
                      ),
                      color: _isEditMode ? null : AppColors.background,
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

  // Métodos auxiliares - exatamente como na join_event_screen.dart
  void _toggleDay(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

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

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty && !_selectedSkills.contains(skill)) {
      setState(() {
        _selectedSkills.add(skill);
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _selectedSkills.remove(skill);
    });
  }

  void _addResource() {
    final resource = _resourceController.text.trim();
    if (resource.isNotEmpty && !_selectedResources.contains(resource)) {
      setState(() {
        _selectedResources.add(resource);
        _resourceController.clear();
      });
    }
  }

  void _removeResource(String resource) {
    setState(() {
      _selectedResources.remove(resource);
    });
  }

  void _cancelChanges() {
    // Se foi aberta diretamente em modo de edição, volta para a tela anterior
    if (widget.isEditMode) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      // Restaura dados originais
      _selectedDays = List.from(_originalSelectedDays);
      _startTime = _originalStartTime;
      _endTime = _originalEndTime;
      _isFullTimeAvailable = _originalIsFullTimeAvailable;
      _selectedSkills = List.from(_originalSelectedSkills);
      _selectedResources = List.from(_originalSelectedResources);

      // Limpa os controllers
      _skillController.clear();
      _resourceController.clear();

      // Sai do modo de edição
      _isEditMode = false;
    });
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validações específicas
    if (!_isFullTimeAvailable && _selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione pelo menos um dia de disponibilidade'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (!_isFullTimeAvailable && _startTime.hour >= _endTime.hour) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Horário de início deve ser anterior ao horário de fim',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final eventController = Provider.of<EventController>(
        context,
        listen: false,
      );

      // Converte TimeOfDay para string
      final startTimeString =
          '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}';
      final endTimeString =
          '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}';

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

      // Cria o perfil atualizado
      final updatedProfile = _profile!.copyWith(
        availableDays: availableDays,
        availableHours: timeRange,
        isFullTimeAvailable: _isFullTimeAvailable,
        skills: _selectedSkills,
        resources: _selectedResources,
      );

      // Salva no Firestore através do EventController
      final success = await eventController.updateVolunteerProfile(
        updatedProfile,
      );

      if (mounted) {
        if (success) {
          // Atualiza os dados originais com os novos valores salvos
          _initializeFormData(updatedProfile);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dados atualizados com sucesso!'),
              backgroundColor: AppColors.success,
            ),
          );

          // Se foi aberta diretamente em modo de edição, volta para a tela anterior
          if (widget.isEditMode) {
            Navigator.of(context).pop();
          } else {
            setState(() {
              _profile = updatedProfile;
              _isEditMode = false;
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Erro ao salvar: ${eventController.errorMessage ?? 'Erro desconhecido'}',
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // Seção de habilidades - baseada na join_event_screen.dart
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
        Text(
          _isEditMode
              ? 'Adicione ou remova suas habilidades'
              : 'Suas habilidades para este evento',
          style: const TextStyle(
            fontSize: AppDimensions.fontSizeMd,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),

        // Campo para adicionar nova habilidade (só no modo edição)
        if (_isEditMode) ...[
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
        ],

        // Habilidades necessárias do evento
        if (_event!.requiredSkills.isNotEmpty) ...[
          const Text(
            'Habilidades necessárias para este evento:',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeSm,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingSm,
            children: _event!.requiredSkills.map((skill) {
              final isSelected = _selectedSkills.contains(skill);
              return SkillChip(
                label: skill,
                isSelected: isSelected,
                onTap: _isEditMode
                    ? () {
                        setState(() {
                          if (isSelected) {
                            _selectedSkills.remove(skill);
                          } else {
                            _selectedSkills.add(skill);
                          }
                        });
                      }
                    : null,
                backgroundColor: isSelected
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.secondary.withValues(alpha: 0.1),
                textColor: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary,
                borderColor: isSelected
                    ? AppColors.primary
                    : AppColors.secondary,
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
        ],

        // Habilidades adicionais do usuário
        if (_selectedSkills
            .where((skill) => !_event!.requiredSkills.contains(skill))
            .isNotEmpty) ...[
          const Text(
            'Suas outras habilidades:',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeSm,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingSm,
            children: _selectedSkills
                .where((skill) => !_event!.requiredSkills.contains(skill))
                .map((skill) {
                  return SkillChip(
                    label: skill,
                    isSelected: true,
                    onTap: _isEditMode ? () => _removeSkill(skill) : null,
                    showRemove: _isEditMode,
                    backgroundColor: AppColors.success.withValues(alpha: 0.1),
                    textColor: AppColors.success,
                    borderColor: AppColors.success,
                  );
                })
                .toList(),
          ),
        ] else if (!_isEditMode && _selectedSkills.isEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              'Nenhuma habilidade cadastrada',
              style: TextStyle(
                fontSize: AppDimensions.fontSizeMd,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }

  // Seção de recursos - baseada na join_event_screen.dart
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
        Text(
          _isEditMode
              ? 'Adicione ou remova seus recursos'
              : 'Seus recursos para este evento',
          style: const TextStyle(
            fontSize: AppDimensions.fontSizeMd,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),

        // Campo para adicionar novo recurso (só no modo edição)
        if (_isEditMode) ...[
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
        ],

        // Recursos necessários do evento
        if (_event!.requiredResources.isNotEmpty) ...[
          const Text(
            'Recursos necessários para este evento:',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeSm,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingSm,
            children: _event!.requiredResources.map((resource) {
              final isSelected = _selectedResources.contains(resource);
              return SkillChip(
                label: resource,
                isSelected: isSelected,
                onTap: _isEditMode
                    ? () {
                        setState(() {
                          if (isSelected) {
                            _selectedResources.remove(resource);
                          } else {
                            _selectedResources.add(resource);
                          }
                        });
                      }
                    : null,
                backgroundColor: isSelected
                    ? AppColors.secondary.withValues(alpha: 0.2)
                    : AppColors.primary.withValues(alpha: 0.1),
                textColor: isSelected
                    ? AppColors.secondary
                    : AppColors.textSecondary,
                borderColor: isSelected
                    ? AppColors.secondary
                    : AppColors.primary,
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
        ],

        // Recursos adicionais do usuário
        if (_selectedResources
            .where((resource) => !_event!.requiredResources.contains(resource))
            .isNotEmpty) ...[
          const Text(
            'Seus outros recursos:',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeSm,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingSm,
            children: _selectedResources
                .where(
                  (resource) => !_event!.requiredResources.contains(resource),
                )
                .map((resource) {
                  return SkillChip(
                    label: resource,
                    isSelected: true,
                    onTap: _isEditMode ? () => _removeResource(resource) : null,
                    showRemove: _isEditMode,
                    backgroundColor: AppColors.warning.withValues(alpha: 0.1),
                    textColor: AppColors.warning,
                    borderColor: AppColors.warning,
                  );
                })
                .toList(),
          ),
        ] else if (!_isEditMode && _selectedResources.isEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              'Nenhum recurso cadastrado',
              style: TextStyle(
                fontSize: AppDimensions.fontSizeMd,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }
}
