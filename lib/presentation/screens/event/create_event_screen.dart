import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/event_model.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/event_controller.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/event/skill_chip.dart';

/// Tela para criação e edição de campanhas
/// REQ-05: Refatorada para aceitar campanha opcional para modo de edição
class CreateEventScreen extends StatefulWidget {
  /// campanha opcional para modo de edição
  final EventModel? eventToEdit;

  const CreateEventScreen({super.key, this.eventToEdit});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _skillController = TextEditingController();
  final _resourceController = TextEditingController();

  final List<String> _selectedSkills = [];
  final List<String> _selectedResources = [];

  /// REQ-05: Indica se está em modo de edição
  bool get _isEditMode => widget.eventToEdit != null;

  // Lista de habilidades pré-definidas
  final List<String> _predefinedSkills = [
    'Organização',
    'Comunicação',
    'Liderança',
    'Tecnologia',
    'Design',
    'Marketing',
    'Vendas',
    'Atendimento',
    'Logística',
    'Culinária',
    'Fotografia',
    'Música',
    'Arte',
    'Esportes',
    'Educação',
  ];

  // Lista de recursos pré-definidos
  final List<String> _predefinedResources = [
    'Carro',
    'Caminhão',
    'Equipamento de Som',
    'Projetor',
    'Notebook',
    'Câmera',
    'Microfone',
    'Mesa',
    'Cadeira',
    'Tenda',
    'Gerador',
    'Ferramentas',
    'Material de Limpeza',
    'Cozinha',
    'Refrigerador',
  ];

  @override
  void initState() {
    super.initState();
    // REQ-05: Pré-preenche os campos se estiver em modo de edição
    if (_isEditMode) {
      _populateFieldsForEdit();
    }
  }

  /// REQ-05: Pré-preenche os campos com os dados da campanha para edição
  void _populateFieldsForEdit() {
    final event = widget.eventToEdit!;
    _nameController.text = event.name;
    _descriptionController.text = event.description;
    _locationController.text = event.location;
    _selectedSkills.addAll(event.requiredSkills);
    _selectedResources.addAll(event.requiredResources);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _skillController.dispose();
    _resourceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: RoundedCustomAppBar(
        title: _isEditMode ? 'Editar campanha' : 'Criar campanha',
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
      ),
      body: Consumer2<AuthController, EventController>(
        builder: (context, authController, eventController, child) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informações básicas
                  _buildBasicInfoSection(),

                  const SizedBox(height: AppDimensions.spacingLg),

                  // Habilidades necessárias
                  _buildSkillsSection(),

                  const SizedBox(height: AppDimensions.spacingLg),

                  // Recursos necessários
                  _buildResourcesSection(),

                  const SizedBox(height: AppDimensions.spacingXl),

                  // REQ-05: Botões diferentes baseados no modo
                  _buildActionButtons(authController, eventController),

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
                              eventController.errorMessage ??
                                  'Erro desconhecido',
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informações Básicas',
          style: TextStyle(
            fontSize: AppDimensions.fontSizeLg,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),

        // Nome da campanha
        CustomTextField(
          controller: _nameController,
          label: 'Nome da campanha',
          hint: 'Digite o nome da campanha',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Nome da campanha é obrigatório';
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

        // Descrição
        CustomTextField(
          controller: _descriptionController,
          label: 'Descrição',
          hint: 'Descreva a campanha (opcional)',
          maxLines: 3,
          validator: (value) {
            if (value != null && value.length > 500) {
              return 'Descrição deve ter no máximo 500 caracteres';
            }
            return null;
          },
        ),

        const SizedBox(height: AppDimensions.spacingMd),

        // Localização
        CustomTextField(
          controller: _locationController,
          label: 'Localização',
          hint: 'Onde será realizado a campanha',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Localização é obrigatória';
            }
            if (value.trim().length > 200) {
              return 'Localização deve ter no máximo 200 caracteres';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Habilidades Necessárias',
          style: TextStyle(
            fontSize: AppDimensions.fontSizeLg,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        const Text(
          'Selecione as habilidades que os voluntários devem ter',
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

        // Habilidades pré-definidas
        const Text(
          'Ou selecione das opções abaixo:',
          style: TextStyle(
            fontSize: AppDimensions.fontSizeMd,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),

        Wrap(
          spacing: AppDimensions.spacingSm,
          runSpacing: AppDimensions.spacingSm,
          children: _predefinedSkills.map((skill) {
            final isSelected = _selectedSkills.contains(skill);
            return SkillChip(
              label: skill,
              isSelected: isSelected,
              onTap: () => _toggleSkill(skill),
            );
          }).toList(),
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
          'Recursos Necessários',
          style: TextStyle(
            fontSize: AppDimensions.fontSizeLg,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        const Text(
          'Selecione os recursos que os voluntários devem ter',
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

        // Recursos pré-definidos
        const Text(
          'Ou selecione das opções abaixo:',
          style: TextStyle(
            fontSize: AppDimensions.fontSizeMd,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),

        Wrap(
          spacing: AppDimensions.spacingSm,
          runSpacing: AppDimensions.spacingSm,
          children: _predefinedResources.map((resource) {
            final isSelected = _selectedResources.contains(resource);
            return SkillChip(
              label: resource,
              isSelected: isSelected,
              onTap: () => _toggleResource(resource),
            );
          }).toList(),
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

  /// REQ-05: Constrói os botões de ação baseado no modo (criar vs editar)
  Widget _buildActionButtons(
    AuthController authController,
    EventController eventController,
  ) {
    if (_isEditMode) {
      // Modo de edição: botões Cancelar e Salvar Alterações lado a lado
      return Row(
        children: [
          // Botão Cancelar
          Expanded(
            child: CustomButton.outline(
              text: 'Cancelar',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingMd),
          // Botão Salvar Alterações
          Expanded(
            child: CustomButton(
              text: 'Salvar Alterações',
              onPressed: () =>
                  _handleUpdateEvent(authController, eventController),
              isLoading: eventController.isLoading,
            ),
          ),
        ],
      );
    } else {
      // Modo de criação: botão Criar campanha
      return SizedBox(
        width: double.infinity,
        child: CustomButton(
          text: 'Criar campanha',
          onPressed: () => _handleCreateEvent(authController, eventController),
          isLoading: eventController.isCreatingEvent,
        ),
      );
    }
  }

  Future<void> _handleCreateEvent(
    AuthController authController,
    EventController eventController,
  ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = authController.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário não encontrado'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Limpa erros anteriores
    eventController.clearError();

    final event = await eventController.createEvent(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      createdBy: user.id,
      requiredSkills: _selectedSkills,
      requiredResources: _selectedResources,
    );

    if (event != null && mounted) {
      // Mostra dialog de sucesso com o código da campanha
      _showSuccessDialog(event.tag);
    }
  }

  /// REQ-06: Manipula a atualização da campanha
  Future<void> _handleUpdateEvent(
    AuthController authController,
    EventController eventController,
  ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = authController.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário não encontrado'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Limpa erros anteriores
    eventController.clearError();

    // Cria a campanha atualizado
    final updatedEvent = widget.eventToEdit!.copyWith(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      requiredSkills: List<String>.from(_selectedSkills),
      requiredResources: List<String>.from(_selectedResources),
    );

    // REQ-06: Chama o método updateEvent do controller
    final success = await eventController.updateEvent(updatedEvent);

    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('campanha atualizado com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    }
    // Se houve erro, a mensagem já é exibida pelo controller através do Consumer
  }

  void _showSuccessDialog(String eventTag) {
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
            Text('Campanha criada!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sua campanha foi criado com sucesso!',
              style: TextStyle(fontSize: AppDimensions.fontSizeMd),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            const Text(
              'Código da campanha:',
              style: TextStyle(
                fontSize: AppDimensions.fontSizeMd,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                eventTag,
                style: const TextStyle(
                  fontSize: AppDimensions.fontSizeXl,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            const Text(
              'Compartilhe este código com os voluntários para que eles possam participar da campanha.',
              style: TextStyle(
                fontSize: AppDimensions.fontSizeSm,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          CustomButton.outline(
            text: 'Copiar Código',
            onPressed: () => _copyEventTag(eventTag),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
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

  void _copyEventTag(String tag) {
    // TODO: Implementar cópia para clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Código copiado para a área de transferência'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
