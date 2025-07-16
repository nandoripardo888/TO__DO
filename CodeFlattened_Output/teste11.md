# Project Export

## Project Statistics

- Total files: 66

## Folder Structure

```
lib
  core
    constants
      app_colors.dart
      app_constants.dart
      app_dimensions.dart
      app_strings.dart
    exceptions
      app_exceptions.dart
    theme
      app_theme.dart
    utils
      date_helpers.dart
      error_handler.dart
      form_validators.dart
      string_helpers.dart
      validators.dart
  data
    models
      event_model.dart
      microtask_model.dart
      task_model.dart
      user_microtask_model.dart
      user_model.dart
      volunteer_profile_model.dart
    repositories
      auth_repository.dart
      event_repository.dart
      microtask_repository.dart
      task_repository.dart
      user_repository.dart
    services
      assignment_service.dart
      auth_service.dart
      event_service.dart
      microtask_service.dart
      task_service.dart
      user_service.dart
  firebase_options.dart
  main.dart
  presentation
    controllers
      auth_controller.dart
      event_controller.dart
      task_controller.dart
    routes
      app_routes.dart
    screens
      assignment
        assignment_screen.dart
      auth
        login_screen.dart
        register_screen.dart
      event
        create_event_screen.dart
        create_tasks_screen.dart
        event_details_screen.dart
        join_event_screen.dart
        manage_volunteers_screen.dart
        track_tasks_screen.dart
      home
        home_screen.dart
      task
        create_microtask_screen.dart
        create_task_screen.dart
    widgets
      common
        confirmation_dialog.dart
        custom_app_bar.dart
        custom_button.dart
        custom_text_field.dart
        error_message_widget.dart
        error_widget.dart
        loading_widget.dart
        skill_chip.dart
      dialogs
        assignment_dialog.dart
        confirmation_dialog.dart
      event
        event_card.dart
        event_info_card.dart
        event_stats_widget.dart
        skill_chip.dart
      task
        microtask_card.dart
        task_card.dart
        task_progress_widget.dart
      volunteer
        volunteer_card.dart
        volunteer_list_widget.dart
  utils
    migration_utils.dart

```

### lib\core\constants\app_colors.dart

```dart
import 'package:flutter/material.dart';

/// Classe que define todas as cores utilizadas no aplicativo
/// Baseado no Design System especificado no SPEC_GERAL.md
class AppColors {
  // Cores Principais
  static const Color primary = Color(0xFF6B46C1); // Roxo principal
  static const Color secondary = Color(0xFFA78BFA); // Roxo claro
  
  // Cores de Fundo
  static const Color background = Color(0xFFFFFFFF); // Branco
  static const Color surface = Color(0xFFF9FAFB); // Branco levemente acinzentado
  static const Color cardBackground = Color(0xFFFFFFFF); // Branco para cards
  
  // Cores de Texto
  static const Color textPrimary = Color(0xFF374151); // Cinza escuro
  static const Color textSecondary = Color(0xFF6B7280); // Cinza médio
  static const Color textLight = Color(0xFF9CA3AF); // Cinza claro
  static const Color textOnPrimary = Color(0xFFFFFFFF); // Branco para texto em fundo roxo
  
  // Cores de Status
  static const Color success = Color(0xFF10B981); // Verde
  static const Color error = Color(0xFFEF4444); // Vermelho
  static const Color warning = Color(0xFFF59E0B); // Amarelo/Laranja
  static const Color info = Color(0xFF3B82F6); // Azul
  
  // Cores de Estado
  static const Color disabled = Color(0xFFD1D5DB); // Cinza para elementos desabilitados
  static const Color border = Color(0xFFE5E7EB); // Cinza para bordas
  static const Color divider = Color(0xFFF3F4F6); // Cinza muito claro para divisores
  
  // Cores de Prioridade (para tasks)
  static const Color priorityHigh = Color(0xFFEF4444); // Vermelho
  static const Color priorityMedium = Color(0xFFF59E0B); // Amarelo/Laranja
  static const Color priorityLow = Color(0xFF10B981); // Verde
  
  // Cores de Status de Task/Microtask
  static const Color statusPending = Color(0xFF6B7280); // Cinza
  static const Color statusInProgress = Color(0xFF3B82F6); // Azul
  static const Color statusCompleted = Color(0xFF10B981); // Verde
  static const Color statusCancelled = Color(0xFFEF4444); // Vermelho
  
  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Sombras
  static const Color shadowLight = Color(0x0F000000); // Sombra leve
  static const Color shadowMedium = Color(0x1A000000); // Sombra média
  static const Color shadowDark = Color(0x26000000); // Sombra escura
}

```

### lib\core\constants\app_constants.dart

```dart
/// Classe que define constantes gerais da aplicação
/// Inclui configurações, limites e valores padrão
class AppConstants {
  // Configurações de Autenticação
  static const int passwordMinLength = 6;
  static const int passwordMaxLength = 128;
  static const int nameMinLength = 2;
  static const int nameMaxLength = 50;
  
  // Configurações de Eventos
  static const int eventNameMinLength = 3;
  static const int eventNameMaxLength = 100;
  static const int eventDescriptionMaxLength = 500;
  static const int eventLocationMaxLength = 200;
  static const int eventTagLength = 6; // Código alfanumérico de 6 caracteres
  static const int maxSkillsPerEvent = 20;
  static const int maxResourcesPerEvent = 20;
  
  // Configurações de Tasks
  static const int taskNameMinLength = 3;
  static const int taskNameMaxLength = 100;
  static const int taskDescriptionMaxLength = 500;
  static const int microtaskNameMinLength = 3;
  static const int microtaskNameMaxLength = 100;
  static const int microtaskDescriptionMaxLength = 1000;
  static const int maxMicrotasksPerTask = 50;
  static const double maxEstimatedHours = 100.0;
  static const double minEstimatedHours = 0.5;
  
  // Configurações de Voluntários
  static const int maxSkillsPerVolunteer = 15;
  static const int maxResourcesPerVolunteer = 15;
  static const int maxVolunteersPerEvent = 500;
  
  // Status de Eventos
  static const String eventStatusActive = 'active';
  static const String eventStatusCompleted = 'completed';
  static const String eventStatusCancelled = 'cancelled';
  
  // Status de Tasks
  static const String taskStatusPending = 'pending';
  static const String taskStatusInProgress = 'in_progress';
  static const String taskStatusCompleted = 'completed';
  
  // Status de Microtasks
  static const String microtaskStatusPending = 'pending';
  static const String microtaskStatusAssigned = 'assigned';
  static const String microtaskStatusInProgress = 'in_progress';
  static const String microtaskStatusCompleted = 'completed';
  static const String microtaskStatusCancelled = 'cancelled';
  
  // Prioridades
  static const String priorityHigh = 'high';
  static const String priorityMedium = 'medium';
  static const String priorityLow = 'low';
  
  // Roles de Usuário
  static const String roleManager = 'manager';
  static const String roleVolunteer = 'volunteer';
  
  // Dias da Semana
  static const String dayMonday = 'monday';
  static const String dayTuesday = 'tuesday';
  static const String dayWednesday = 'wednesday';
  static const String dayThursday = 'thursday';
  static const String dayFriday = 'friday';
  static const String daySaturday = 'saturday';
  static const String daySunday = 'sunday';
  
  static const List<String> weekDays = [
    dayMonday,
    dayTuesday,
    dayWednesday,
    dayThursday,
    dayFriday,
    daySaturday,
    daySunday,
  ];
  
  // Coleções do Firestore
  static const String usersCollection = 'users';
  static const String eventsCollection = 'events';
  static const String tasksCollection = 'tasks';
  static const String microtasksCollection = 'microtasks';
  static const String volunteerProfilesCollection = 'volunteer_profiles';
  
  // Configurações de Cache
  static const int cacheExpirationHours = 24;
  static const int maxCacheSize = 100; // MB
  
  // Configurações de Paginação
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Configurações de Imagem
  static const int maxImageSizeMB = 5;
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
  
  // Timeouts
  static const int networkTimeoutSeconds = 30;
  static const int authTimeoutSeconds = 60;
  
  // Regex Patterns
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String eventTagPattern = r'^[A-Z0-9]{6}$';
  static const String phonePattern = r'^\+?[1-9]\d{1,14}$';
  
  // Configurações de Notificação (para futuras implementações)
  static const String notificationChannelId = 'contask_notifications';
  static const String notificationChannelName = 'ConTask Notifications';
  
  // URLs e Links
  static const String privacyPolicyUrl = 'https://contask.app/privacy';
  static const String termsOfServiceUrl = 'https://contask.app/terms';
  static const String supportEmail = 'support@contask.app';
  
  // Configurações de Debug
  static const bool enableDebugMode = true;
  static const bool enableAnalytics = false; // Para produção
  
  // Habilidades Padrão (podem ser expandidas pelos usuários)
  static const List<String> defaultSkills = [
    'Organização',
    'Comunicação',
    'Liderança',
    'Trabalho em equipe',
    'Criatividade',
    'Resolução de problemas',
    'Gestão de tempo',
    'Tecnologia',
    'Design',
    'Marketing',
    'Vendas',
    'Atendimento ao cliente',
    'Logística',
    'Segurança',
    'Primeiros socorros',
  ];
  
  // Recursos Padrão (podem ser expandidos pelos usuários)
  static const List<String> defaultResources = [
    'Veículo próprio',
    'Notebook/Computador',
    'Smartphone',
    'Câmera fotográfica',
    'Equipamento de som',
    'Microfone',
    'Projetor',
    'Material de escritório',
    'Ferramentas básicas',
    'Equipamento de limpeza',
    'Mesa e cadeiras',
    'Tendas/Barracas',
    'Equipamento de cozinha',
    'Material esportivo',
    'Instrumentos musicais',
  ];
}

```

### lib\core\constants\app_dimensions.dart

```dart
/// Classe que define todas as dimensões utilizadas no aplicativo
/// Padroniza espaçamentos, tamanhos e bordas para consistência visual
class AppDimensions {
  // Espaçamentos
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;
  
  // Padding
  static const double paddingXs = 4.0;
  static const double paddingSm = 8.0;
  static const double paddingMd = 16.0;
  static const double paddingLg = 24.0;
  static const double paddingXl = 32.0;
  
  // Margin
  static const double marginXs = 4.0;
  static const double marginSm = 8.0;
  static const double marginMd = 16.0;
  static const double marginLg = 24.0;
  static const double marginXl = 32.0;
  
  // Border Radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusRound = 50.0;
  
  // Tamanhos de Botões
  static const double buttonHeightSm = 36.0;
  static const double buttonHeightMd = 48.0;
  static const double buttonHeightLg = 56.0;
  static const double buttonMinWidth = 88.0;
  
  // Tamanhos de Ícones
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;
  
  // Tamanhos de Avatar
  static const double avatarSm = 32.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 64.0;
  static const double avatarXl = 96.0;
  
  // Alturas de Componentes
  static const double textFieldHeight = 56.0;
  static const double appBarHeight = 56.0;
  static const double cardMinHeight = 80.0;
  static const double listItemHeight = 72.0;
  
  // Larguras
  static const double maxContentWidth = 600.0;
  static const double minButtonWidth = 120.0;
  static const double fabSize = 56.0;
  
  // Elevações (Material Design)
  static const double elevationNone = 0.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 16.0;
  
  // Bordas
  static const double borderWidthThin = 1.0;
  static const double borderWidthMedium = 2.0;
  static const double borderWidthThick = 4.0;
  
  // Tamanhos de Fonte (complementar ao tema)
  static const double fontSizeXs = 10.0;
  static const double fontSizeSm = 12.0;
  static const double fontSizeMd = 14.0;
  static const double fontSizeLg = 16.0;
  static const double fontSizeXl = 18.0;
  static const double fontSizeXxl = 20.0;
  static const double fontSizeTitle = 24.0;
  static const double fontSizeHeading = 32.0;
  
  // Opacidades
  static const double opacityDisabled = 0.38;
  static const double opacityMedium = 0.54;
  static const double opacityHigh = 0.87;
  static const double opacityFull = 1.0;
  
  // Duração de Animações
  static const int animationDurationFast = 150;
  static const int animationDurationMedium = 300;
  static const int animationDurationSlow = 500;
  
  // Breakpoints para Responsividade
  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 900.0;
  static const double breakpointDesktop = 1200.0;
}

```

### lib\core\constants\app_strings.dart

```dart
/// Classe que define todas as strings utilizadas no aplicativo
/// Centraliza textos para facilitar manutenção e futura internacionalização
class AppStrings {
  // App
  static const String appName = 'ConTask';
  static const String appDescription = 'Gerenciador de Tarefas para Eventos';

  // Autenticação
  static const String login = 'Entrar';
  static const String loginWithGoogle = 'Entrar com Google';
  static const String register = 'Criar conta';
  static const String alreadyHaveAccount = 'Já tenho conta';
  static const String dontHaveAccount = 'Não tenho conta';
  static const String logout = 'Sair';

  // Campos de Formulário
  static const String name = 'Nome';
  static const String fullName = 'Nome completo';
  static const String email = 'E-mail';
  static const String password = 'Senha';
  static const String confirmPassword = 'Confirmar senha';
  static const String description = 'Descrição';
  static const String location = 'Localização';

  // Eventos
  static const String events = 'Eventos';
  static const String createEvent = 'Criar Evento';
  static const String joinEvent = 'Participar de Evento';
  static const String eventName = 'Nome do evento';
  static const String eventDescription = 'Descrição do evento';
  static const String eventLocation = 'Localização do evento';
  static const String eventCode = 'Código do evento';
  static const String eventTag = 'Tag do evento';
  static const String requiredSkills = 'Habilidades necessárias';
  static const String requiredResources = 'Recursos necessários';
  static const String eventDetails = 'Detalhes do Evento';
  static const String eventCreated = 'Evento criado com sucesso!';
  static const String joinedEvent = 'Você ingressou no evento!';

  // Tarefas
  static const String tasks = 'Tarefas';
  static const String createTask = 'Criar Tarefa';
  static const String createTasks = 'Criar Tasks';
  static const String taskName = 'Nome da tarefa';
  static const String taskDescription = 'Descrição da tarefa';
  static const String microtasks = 'Microtarefas';
  static const String createMicrotask = 'Criar Microtarefa';
  static const String microtaskName = 'Nome da microtarefa';
  static const String microtaskDescription = 'Descrição da microtarefa';
  static const String startDateTime = 'Data e hora inicial';
  static const String endDateTime = 'Data e hora final';
  static const String estimatedHours =
      'Duração estimada'; // Mantido para compatibilidade
  static const String actualHours = 'Horas realizadas';
  static const String trackTasks = 'Acompanhar Tasks';

  // Voluntários
  static const String volunteers = 'Voluntários';
  static const String manageVolunteers = 'Gerenciar Voluntários';
  static const String volunteerProfile = 'Perfil do Voluntário';
  static const String assignMicrotask = 'Atribuir Microtarefa';
  static const String promoteToManager = 'Promover a Gerenciador';
  static const String availableDays = 'Dias disponíveis';
  static const String availableHours = 'Horários disponíveis';
  static const String skills = 'Habilidades';
  static const String resources = 'Recursos';
  static const String availability = 'Disponibilidade';

  // Status
  static const String pending = 'Pendente';
  static const String inProgress = 'Em Progresso';
  static const String completed = 'Concluído';
  static const String cancelled = 'Cancelado';
  static const String assigned = 'Atribuído';
  static const String active = 'Ativo';

  // Prioridades
  static const String priority = 'Prioridade';
  static const String high = 'Alta';
  static const String medium = 'Média';
  static const String low = 'Baixa';

  // Ações
  static const String save = 'Salvar';
  static const String cancel = 'Cancelar';
  static const String delete = 'Excluir';
  static const String edit = 'Editar';
  static const String confirm = 'Confirmar';
  static const String search = 'Buscar';
  static const String filter = 'Filtrar';
  static const String add = 'Adicionar';
  static const String remove = 'Remover';
  static const String start = 'Iniciar';
  static const String finish = 'Finalizar';
  static const String assign = 'Atribuir';

  // Navegação
  static const String home = 'Início';
  static const String profile = 'Perfil';
  static const String settings = 'Configurações';
  static const String back = 'Voltar';

  // Mensagens de Erro
  static const String errorGeneric = 'Ocorreu um erro inesperado';
  static const String errorNetwork = 'Erro de conexão com a internet';
  static const String errorAuth = 'Erro de autenticação';
  static const String errorInvalidEmail = 'E-mail inválido';
  static const String errorPasswordTooShort =
      'Senha deve ter pelo menos 6 caracteres';
  static const String errorPasswordsDontMatch = 'Senhas não coincidem';
  static const String errorEventNotFound = 'Evento não encontrado';
  static const String errorInvalidEventCode = 'Código de evento inválido';

  // Mensagens de Sucesso
  static const String successGeneric = 'Operação realizada com sucesso';
  static const String successSaved = 'Salvo com sucesso';
  static const String successDeleted = 'Excluído com sucesso';

  // Dias da Semana
  static const String monday = 'Segunda-feira';
  static const String tuesday = 'Terça-feira';
  static const String wednesday = 'Quarta-feira';
  static const String thursday = 'Quinta-feira';
  static const String friday = 'Sexta-feira';
  static const String saturday = 'Sábado';
  static const String sunday = 'Domingo';

  // Roles
  static const String manager = 'Gerenciador';
  static const String volunteer = 'Voluntário';

  // Placeholders
  static const String noEventsFound = 'Nenhum evento encontrado';
  static const String noTasksFound = 'Nenhuma tarefa encontrada';
  static const String noVolunteersFound = 'Nenhum voluntário encontrado';
  static const String loading = 'Carregando...';
}

```

### lib\core\exceptions\app_exceptions.dart

```dart
/// Classe base para todas as exceções personalizadas da aplicação
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  const AppException(this.message, {this.code, this.originalException});

  @override
  String toString() => 'AppException: $message';
}

/// Exceções relacionadas à autenticação
class AuthException extends AppException {
  const AuthException(super.message, {super.code, super.originalException});

  @override
  String toString() => 'AuthException: $message';
}

/// Exceções relacionadas à rede/conectividade
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.originalException});

  @override
  String toString() => 'NetworkException: $message';
}

/// Exceções relacionadas ao Firestore
class FirestoreException extends AppException {
  const FirestoreException(
    super.message, {
    super.code,
    super.originalException,
  });

  @override
  String toString() => 'FirestoreException: $message';
}

/// Exceções relacionadas à validação de dados
class ValidationException extends AppException {
  const ValidationException(
    super.message, {
    super.code,
    super.originalException,
  });

  @override
  String toString() => 'ValidationException: $message';
}

/// Exceções relacionadas a eventos
class EventException extends AppException {
  const EventException(super.message, {super.code, super.originalException});

  @override
  String toString() => 'EventException: $message';
}

/// Exceções relacionadas a tarefas
class TaskException extends AppException {
  const TaskException(super.message, {super.code, super.originalException});

  @override
  String toString() => 'TaskException: $message';
}

/// Exceções relacionadas a voluntários
class VolunteerException extends AppException {
  const VolunteerException(
    super.message, {
    super.code,
    super.originalException,
  });

  @override
  String toString() => 'VolunteerException: $message';
}

/// Exceções relacionadas a permissões
class PermissionException extends AppException {
  const PermissionException(
    super.message, {
    super.code,
    super.originalException,
  });

  @override
  String toString() => 'PermissionException: $message';
}

/// Exceções relacionadas ao cache/storage
class StorageException extends AppException {
  const StorageException(super.message, {super.code, super.originalException});

  @override
  String toString() => 'StorageException: $message';
}

/// Exceções relacionadas ao banco de dados
class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.code, super.originalException});

  @override
  String toString() => 'DatabaseException: $message';
}

/// Exceções relacionadas ao repositório
class RepositoryException extends AppException {
  const RepositoryException(
    super.message, {
    super.code,
    super.originalException,
  });

  @override
  String toString() => 'RepositoryException: $message';
}

/// Exceções relacionadas a operações não encontradas
class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.code, super.originalException});

  @override
  String toString() => 'NotFoundException: $message';
}

/// Exceções relacionadas a operações não autorizadas
class UnauthorizedException extends AppException {
  const UnauthorizedException(
    super.message, {
    super.code,
    super.originalException,
  });

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// Exceções relacionadas a conflitos de dados
class ConflictException extends AppException {
  final String resource;

  const ConflictException(
    this.resource, {
    String? customMessage,
    super.code,
    super.originalException,
  }) : super(customMessage ?? 'Conflict with resource: $resource');

  @override
  String toString() => 'ConflictException: $resource';
}

/// Classe utilitária para tratamento de exceções
class ExceptionHandler {
  /// Converte exceções do Firebase Auth em exceções personalizadas
  static AuthException handleAuthException(dynamic exception) {
    final errorString = exception.toString().toLowerCase();
    String userMessage;
    String? code;

    if (errorString.contains('user-not-found')) {
      userMessage = 'Usuário não encontrado. Verifique o e-mail digitado.';
      code = 'user-not-found';
    } else if (errorString.contains('wrong-password')) {
      userMessage = 'Senha incorreta. Tente novamente ou redefina sua senha.';
      code = 'wrong-password';
    } else if (errorString.contains('email-already-in-use')) {
      userMessage =
          'Este e-mail já está em uso. Tente fazer login ou use outro e-mail.';
      code = 'email-already-in-use';
    } else if (errorString.contains('weak-password')) {
      userMessage = 'Senha muito fraca. Use pelo menos 6 caracteres.';
      code = 'weak-password';
    } else if (errorString.contains('invalid-email')) {
      userMessage = 'E-mail inválido. Verifique o formato do e-mail.';
      code = 'invalid-email';
    } else if (errorString.contains('network-request-failed')) {
      userMessage =
          'Erro de conexão. Verifique sua internet e tente novamente.';
      code = 'network-request-failed';
    } else if (errorString.contains('too-many-requests')) {
      userMessage =
          'Muitas tentativas. Aguarde alguns minutos antes de tentar novamente.';
      code = 'too-many-requests';
    } else if (errorString.contains('user-disabled')) {
      userMessage =
          'Esta conta foi desabilitada. Entre em contato com o suporte.';
      code = 'user-disabled';
    } else if (errorString.contains('operation-not-allowed')) {
      userMessage = 'Operação não permitida. Entre em contato com o suporte.';
      code = 'operation-not-allowed';
    } else if (errorString.contains('invalid-credential')) {
      userMessage = 'Credenciais inválidas. Verifique e-mail e senha.';
      code = 'invalid-credential';
    } else {
      // Para erros não mapeados, inclui a mensagem original
      userMessage =
          'Erro de autenticação: ${_extractFirebaseErrorMessage(exception)}';
      code = 'unknown';
    }

    return AuthException(userMessage, code: code, originalException: exception);
  }

  /// Extrai a mensagem de erro do Firebase de forma mais limpa
  static String _extractFirebaseErrorMessage(dynamic exception) {
    final errorString = exception.toString();

    // Tenta extrair a mensagem entre colchetes ou após dois pontos
    final regex = RegExp(r'\[(.*?)\]|:\s*(.+)$');
    final match = regex.firstMatch(errorString);

    if (match != null) {
      return match.group(1) ?? match.group(2) ?? errorString;
    }

    return errorString;
  }

  /// Converte exceções do Firestore em exceções personalizadas
  static FirestoreException handleFirestoreException(dynamic exception) {
    final errorString = exception.toString().toLowerCase();
    String userMessage;
    String? code;

    if (errorString.contains('permission-denied')) {
      userMessage = 'Permissão negada. Você não tem acesso a este recurso.';
      code = 'permission-denied';
    } else if (errorString.contains('not-found')) {
      userMessage = 'Dados não encontrados. O item pode ter sido removido.';
      code = 'not-found';
    } else if (errorString.contains('already-exists')) {
      userMessage = 'Este item já existe. Tente usar um nome diferente.';
      code = 'already-exists';
    } else if (errorString.contains('unavailable')) {
      userMessage =
          'Serviço temporariamente indisponível. Tente novamente em alguns minutos.';
      code = 'unavailable';
    } else if (errorString.contains('deadline-exceeded')) {
      userMessage =
          'Operação demorou muito para responder. Verifique sua conexão.';
      code = 'deadline-exceeded';
    } else if (errorString.contains('resource-exhausted')) {
      userMessage = 'Limite de uso excedido. Tente novamente mais tarde.';
      code = 'resource-exhausted';
    } else {
      userMessage =
          'Erro no banco de dados: ${_extractFirebaseErrorMessage(exception)}';
      code = 'unknown';
    }

    return FirestoreException(
      userMessage,
      code: code,
      originalException: exception,
    );
  }

  /// Converte exceções de rede em exceções personalizadas
  static NetworkException handleNetworkException(dynamic exception) {
    final errorString = exception.toString().toLowerCase();
    String userMessage;

    if (errorString.contains('timeout')) {
      userMessage =
          'Conexão expirou. Verifique sua internet e tente novamente.';
    } else if (errorString.contains('host lookup failed')) {
      userMessage =
          'Não foi possível conectar ao servidor. Verifique sua internet.';
    } else if (errorString.contains('connection refused')) {
      userMessage = 'Servidor indisponível. Tente novamente mais tarde.';
    } else {
      userMessage =
          'Erro de conexão: ${_extractFirebaseErrorMessage(exception)}';
    }

    return NetworkException(userMessage, originalException: exception);
  }

  /// Método genérico para tratar qualquer exceção
  static AppException handleGenericException(dynamic exception) {
    if (exception is AppException) {
      return exception;
    }

    // Retorna uma exceção concreta em vez da classe abstrata
    return NetworkException(
      'Erro inesperado: ${_extractFirebaseErrorMessage(exception)}',
      originalException: exception,
    );
  }
}

```

### lib\core\theme\app_theme.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Classe responsável por definir o tema da aplicação
/// Implementa Material Design 3 com as cores personalizadas
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: AppDimensions.elevationSm,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppDimensions.fontSizeXl,
          fontWeight: FontWeight.w600,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: AppDimensions.elevationSm,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.marginMd,
          vertical: AppDimensions.marginSm,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: AppDimensions.elevationSm,
          minimumSize: const Size(
            AppDimensions.minButtonWidth,
            AppDimensions.buttonHeightMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: AppDimensions.fontSizeLg,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(
            color: AppColors.primary,
            width: AppDimensions.borderWidthThin,
          ),
          minimumSize: const Size(
            AppDimensions.minButtonWidth,
            AppDimensions.buttonHeightMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: AppDimensions.fontSizeLg,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(
            AppDimensions.buttonMinWidth,
            AppDimensions.buttonHeightMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: AppDimensions.fontSizeLg,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: AppDimensions.borderWidthThin,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: AppDimensions.borderWidthThin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: AppDimensions.borderWidthMedium,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: AppDimensions.borderWidthThin,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: AppDimensions.borderWidthMedium,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
          vertical: AppDimensions.paddingMd,
        ),
        hintStyle: const TextStyle(
          color: AppColors.textLight,
          fontSize: AppDimensions.fontSizeMd,
        ),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppDimensions.fontSizeMd,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: AppDimensions.elevationMd,
        shape: CircleBorder(),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.secondary,
        labelStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppDimensions.fontSizeSm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingSm,
          vertical: AppDimensions.paddingXs,
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: AppDimensions.borderWidthThin,
        space: AppDimensions.spacingMd,
      ),

      // List Tile Theme
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
          vertical: AppDimensions.paddingSm,
        ),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppDimensions.fontSizeMd,
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppDimensions.fontSizeSm,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        type: BottomNavigationBarType.fixed,
        elevation: AppDimensions.elevationMd,
      ),

      // Tab Bar Theme
      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        labelStyle: TextStyle(
          fontSize: AppDimensions.fontSizeMd,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: AppDimensions.fontSizeMd,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.background,
        elevation: AppDimensions.elevationLg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppDimensions.fontSizeXl,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppDimensions.fontSizeMd,
        ),
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: const TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: AppDimensions.fontSizeMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

```

### lib\core\utils\date_helpers.dart

```dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Classe utilitária para manipulação de datas
class DateHelpers {
  /// Formatador para data completa (dd/MM/yyyy)
  static final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy');

  /// Formatador para data e hora (dd/MM/yyyy HH:mm)
  static final DateFormat _dateTimeFormatter = DateFormat('dd/MM/yyyy HH:mm');

  /// Formatador para hora (HH:mm)
  static final DateFormat _timeFormatter = DateFormat('HH:mm');

  /// Formatador para data abreviada (dd/MM)
  static final DateFormat _shortDateFormatter = DateFormat('dd/MM');

  /// Formatador para mês e ano (MMM yyyy)
  static final DateFormat _monthYearFormatter = DateFormat('MMM yyyy', 'pt_BR');

  /// Converte DateTime para string no formato dd/MM/yyyy
  static String formatDate(DateTime date) {
    return _dateFormatter.format(date);
  }

  /// Converte DateTime para string no formato dd/MM/yyyy HH:mm
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormatter.format(dateTime);
  }

  /// Converte DateTime para string no formato HH:mm
  static String formatTime(DateTime time) {
    return _timeFormatter.format(time);
  }

  /// Converte DateTime para string no formato dd/MM
  static String formatShortDate(DateTime date) {
    return _shortDateFormatter.format(date);
  }

  /// Converte DateTime para string no formato MMM yyyy
  static String formatMonthYear(DateTime date) {
    return _monthYearFormatter.format(date);
  }

  /// Converte string no formato dd/MM/yyyy para DateTime
  static DateTime? parseDate(String dateString) {
    try {
      return _dateFormatter.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Converte string no formato dd/MM/yyyy HH:mm para DateTime
  static DateTime? parseDateTime(String dateTimeString) {
    try {
      return _dateTimeFormatter.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  /// Converte string no formato HH:mm para TimeOfDay
  static TimeOfDay? parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length == 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      // Ignora erro de parsing
    }
    return null;
  }

  /// Converte TimeOfDay para string no formato HH:mm
  static String timeOfDayToString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Retorna a diferença em dias entre duas datas
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  /// Retorna a diferença em horas entre dois DateTimes
  static double hoursBetween(DateTime from, DateTime to) {
    return to.difference(from).inMinutes / 60.0;
  }

  /// Verifica se uma data é hoje
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Verifica se uma data é amanhã
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Verifica se uma data é ontem
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Retorna uma string relativa para a data (hoje, ontem, amanhã, ou data formatada)
  static String getRelativeDateString(DateTime date) {
    if (isToday(date)) {
      return 'Hoje';
    } else if (isTomorrow(date)) {
      return 'Amanhã';
    } else if (isYesterday(date)) {
      return 'Ontem';
    } else {
      return formatDate(date);
    }
  }

  /// Retorna o início do dia (00:00:00)
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Retorna o fim do dia (23:59:59.999)
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Retorna o início da semana (segunda-feira)
  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  /// Retorna o fim da semana (domingo)
  static DateTime endOfWeek(DateTime date) {
    final daysToSunday = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysToSunday)));
  }

  /// Retorna o início do mês
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Retorna o fim do mês
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }

  /// Converte um dia da semana em string para número (1 = segunda, 7 = domingo)
  static int weekdayFromString(String weekday) {
    switch (weekday.toLowerCase()) {
      case 'monday':
      case 'segunda':
        return 1;
      case 'tuesday':
      case 'terça':
        return 2;
      case 'wednesday':
      case 'quarta':
        return 3;
      case 'thursday':
      case 'quinta':
        return 4;
      case 'friday':
      case 'sexta':
        return 5;
      case 'saturday':
      case 'sábado':
        return 6;
      case 'sunday':
      case 'domingo':
        return 7;
      default:
        return 1;
    }
  }

  /// Converte um número do dia da semana para string em português
  static String weekdayToString(int weekday) {
    switch (weekday) {
      case 1:
        return 'Segunda-feira';
      case 2:
        return 'Terça-feira';
      case 3:
        return 'Quarta-feira';
      case 4:
        return 'Quinta-feira';
      case 5:
        return 'Sexta-feira';
      case 6:
        return 'Sábado';
      case 7:
        return 'Domingo';
      default:
        return 'Segunda-feira';
    }
  }

  /// Converte um número do dia da semana para string abreviada
  static String weekdayToShortString(int weekday) {
    switch (weekday) {
      case 1:
        return 'Seg';
      case 2:
        return 'Ter';
      case 3:
        return 'Qua';
      case 4:
        return 'Qui';
      case 5:
        return 'Sex';
      case 6:
        return 'Sáb';
      case 7:
        return 'Dom';
      default:
        return 'Seg';
    }
  }
}

```

### lib\core\utils\error_handler.dart

```dart
import 'package:firebase_auth/firebase_auth.dart';
import '../exceptions/app_exceptions.dart';

/// Classe utilitária para tratamento de erros
class ErrorHandler {
  ErrorHandler._();

  /// Converte exceções do Firebase Auth em mensagens amigáveis
  static String handleFirebaseAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return 'Usuário não encontrado. Verifique o e-mail informado.';
      case 'wrong-password':
        return 'Senha incorreta. Tente novamente.';
      case 'email-already-in-use':
        return 'Este e-mail já está sendo usado por outra conta.';
      case 'weak-password':
        return 'A senha é muito fraca. Use pelo menos 6 caracteres.';
      case 'invalid-email':
        return 'E-mail inválido. Verifique o formato do e-mail.';
      case 'user-disabled':
        return 'Esta conta foi desabilitada. Entre em contato com o suporte.';
      case 'too-many-requests':
        return 'Muitas tentativas de login. Tente novamente mais tarde.';
      case 'operation-not-allowed':
        return 'Operação não permitida. Entre em contato com o suporte.';
      case 'invalid-credential':
        return 'Credenciais inválidas. Verifique e-mail e senha.';
      case 'account-exists-with-different-credential':
        return 'Já existe uma conta com este e-mail usando outro método de login.';
      case 'requires-recent-login':
        return 'Esta operação requer login recente. Faça login novamente.';
      case 'network-request-failed':
        return 'Erro de conexão. Verifique sua internet e tente novamente.';
      default:
        return 'Erro de autenticação: ${error.message ?? 'Erro desconhecido'}';
    }
  }

  /// Converte exceções do Firestore em mensagens amigáveis
  static String handleFirestoreError(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return 'Você não tem permissão para realizar esta operação.';
      case 'not-found':
        return 'Documento não encontrado.';
      case 'already-exists':
        return 'Este documento já existe.';
      case 'resource-exhausted':
        return 'Limite de operações excedido. Tente novamente mais tarde.';
      case 'failed-precondition':
        return 'Operação não pode ser realizada no estado atual.';
      case 'aborted':
        return 'Operação foi cancelada devido a conflito.';
      case 'out-of-range':
        return 'Parâmetros fora do intervalo válido.';
      case 'unimplemented':
        return 'Operação não implementada.';
      case 'internal':
        return 'Erro interno do servidor. Tente novamente.';
      case 'unavailable':
        return 'Serviço temporariamente indisponível. Tente novamente.';
      case 'data-loss':
        return 'Perda de dados detectada. Entre em contato com o suporte.';
      case 'unauthenticated':
        return 'Você precisa estar logado para realizar esta operação.';
      case 'deadline-exceeded':
        return 'Operação demorou muito para ser concluída. Tente novamente.';
      case 'cancelled':
        return 'Operação foi cancelada.';
      case 'invalid-argument':
        return 'Parâmetros inválidos fornecidos.';
      default:
        return 'Erro do banco de dados: ${error.message ?? 'Erro desconhecido'}';
    }
  }

  /// Converte exceções personalizadas da aplicação em mensagens amigáveis
  static String handleAppException(AppException error) {
    switch (error.runtimeType) {
      case ValidationException:
        return error.message;
      case NotFoundException:
        return error.message;
      case UnauthorizedException:
        return error.message;
      case DatabaseException:
        return 'Erro de banco de dados. Tente novamente.';
      case NetworkException:
        return 'Erro de conexão. Verifique sua internet e tente novamente.';
      case StorageException:
        return 'Erro de armazenamento. Tente novamente.';
      case RepositoryException:
        return 'Erro interno. Tente novamente.';
      default:
        return error.message;
    }
  }

  /// Método principal para tratar qualquer tipo de erro
  static String handleError(dynamic error) {
    if (error is FirebaseAuthException) {
      return handleFirebaseAuthError(error);
    } else if (error is FirebaseException) {
      return handleFirestoreError(error);
    } else if (error is AppException) {
      return handleAppException(error);
    } else if (error is Exception) {
      return 'Erro inesperado: ${error.toString()}';
    } else {
      return 'Erro desconhecido. Tente novamente.';
    }
  }

  /// Verifica se o erro é relacionado à rede
  static bool isNetworkError(dynamic error) {
    if (error is FirebaseAuthException) {
      return error.code == 'network-request-failed';
    } else if (error is FirebaseException) {
      return error.code == 'unavailable' || error.code == 'deadline-exceeded';
    } else if (error is NetworkException) {
      return true;
    }
    return false;
  }

  /// Verifica se o erro é relacionado à autenticação
  static bool isAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      return true;
    } else if (error is FirebaseException) {
      return error.code == 'unauthenticated';
    } else if (error is UnauthorizedException) {
      return true;
    }
    return false;
  }

  /// Verifica se o erro é relacionado à validação
  static bool isValidationError(dynamic error) {
    return error is ValidationException ||
        (error is FirebaseException && error.code == 'invalid-argument');
  }

  /// Verifica se o erro é temporário (pode ser resolvido tentando novamente)
  static bool isTemporaryError(dynamic error) {
    if (error is FirebaseAuthException) {
      return error.code == 'too-many-requests' ||
          error.code == 'network-request-failed';
    } else if (error is FirebaseException) {
      return error.code == 'unavailable' ||
          error.code == 'deadline-exceeded' ||
          error.code == 'resource-exhausted' ||
          error.code == 'aborted';
    } else if (error is NetworkException) {
      return true;
    }
    return false;
  }

  /// Gera sugestões de ação baseadas no tipo de erro
  static List<String> getErrorSuggestions(dynamic error) {
    final suggestions = <String>[];

    if (isNetworkError(error)) {
      suggestions.addAll([
        'Verifique sua conexão com a internet',
        'Tente novamente em alguns segundos',
        'Verifique se o Wi-Fi está funcionando',
      ]);
    } else if (isAuthError(error)) {
      suggestions.addAll([
        'Faça login novamente',
        'Verifique suas credenciais',
        'Entre em contato com o suporte se o problema persistir',
      ]);
    } else if (isValidationError(error)) {
      suggestions.addAll([
        'Verifique os dados informados',
        'Certifique-se de preencher todos os campos obrigatórios',
        'Verifique o formato dos dados',
      ]);
    } else if (isTemporaryError(error)) {
      suggestions.addAll([
        'Tente novamente em alguns minutos',
        'Verifique sua conexão',
        'Entre em contato com o suporte se o problema persistir',
      ]);
    } else {
      suggestions.addAll([
        'Tente novamente',
        'Reinicie o aplicativo se necessário',
        'Entre em contato com o suporte se o problema persistir',
      ]);
    }

    return suggestions;
  }

  /// Registra o erro para análise (pode ser expandido para usar serviços como Crashlytics)
  static void logError(
    dynamic error, {
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    // Por enquanto, apenas imprime no console
    // Em produção, isso deveria enviar para um serviço de monitoramento
    print('ERROR: $error');
    if (stackTrace != null) {
      print('STACK TRACE: $stackTrace');
    }
    if (context != null) {
      print('CONTEXT: $context');
    }
  }

  /// Cria uma mensagem de erro formatada para exibição
  static String formatErrorMessage(dynamic error, {String? context}) {
    final message = handleError(error);

    if (context != null) {
      return '$context: $message';
    }

    return message;
  }

  /// Verifica se deve mostrar detalhes técnicos do erro (apenas em desenvolvimento)
  static bool shouldShowTechnicalDetails() {
    // Em produção, isso deveria retornar false
    // Por enquanto, sempre mostra detalhes para facilitar o desenvolvimento
    return true;
  }

  /// Cria uma mensagem de erro com detalhes técnicos (se apropriado)
  static String createDetailedErrorMessage(
    dynamic error, {
    String? userMessage,
  }) {
    final baseMessage = userMessage ?? handleError(error);

    if (shouldShowTechnicalDetails()) {
      return '$baseMessage\n\nDetalhes técnicos: ${error.toString()}';
    }

    return baseMessage;
  }
}

```

### lib\core\utils\form_validators.dart

```dart
/// Classe utilitária para validações de formulários
class FormValidators {
  FormValidators._();

  /// Valida se o campo não está vazio
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Campo'} é obrigatório';
    }
    return null;
  }

  /// Valida email
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-mail é obrigatório';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'E-mail inválido';
    }

    return null;
  }

  /// Valida senha
  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < minLength) {
      return 'Senha deve ter pelo menos $minLength caracteres';
    }

    return null;
  }

  /// Valida confirmação de senha
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }

    if (value != originalPassword) {
      return 'Senhas não coincidem';
    }

    return null;
  }

  /// Valida nome
  static String? name(String? value, {int minLength = 2, int maxLength = 100}) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome é obrigatório';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < minLength) {
      return 'Nome deve ter pelo menos $minLength caracteres';
    }

    if (trimmedValue.length > maxLength) {
      return 'Nome deve ter no máximo $maxLength caracteres';
    }

    // Verifica se contém apenas letras, espaços e alguns caracteres especiais
    final nameRegex = RegExp(r"^[a-zA-ZÀ-ÿ\s'-]+$");
    if (!nameRegex.hasMatch(trimmedValue)) {
      return 'Nome contém caracteres inválidos';
    }

    return null;
  }

  /// Valida nome de evento
  static String? eventName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome do evento é obrigatório';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < 3) {
      return 'Nome deve ter pelo menos 3 caracteres';
    }

    if (trimmedValue.length > 100) {
      return 'Nome deve ter no máximo 100 caracteres';
    }

    return null;
  }

  /// Valida descrição
  static String? description(String? value, {int maxLength = 500}) {
    if (value != null && value.length > maxLength) {
      return 'Descrição deve ter no máximo $maxLength caracteres';
    }

    return null;
  }

  /// Valida localização
  static String? location(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Localização é obrigatória';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length > 200) {
      return 'Localização deve ter no máximo 200 caracteres';
    }

    return null;
  }

  /// Valida tag/código de evento
  static String? eventTag(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Código do evento é obrigatório';
    }

    final trimmedValue = value.trim().toUpperCase();

    if (trimmedValue.length != 6) {
      return 'Código deve ter exatamente 6 caracteres';
    }

    // Verifica se contém apenas letras e números
    final tagRegex = RegExp(r'^[A-Z0-9]+$');
    if (!tagRegex.hasMatch(trimmedValue)) {
      return 'Código deve conter apenas letras e números';
    }

    return null;
  }

  /// Valida lista não vazia
  static String? nonEmptyList(List<dynamic>? list, {String? fieldName}) {
    if (list == null || list.isEmpty) {
      return '${fieldName ?? 'Lista'} não pode estar vazia';
    }
    return null;
  }

  /// Valida horário
  static String? timeRange(String? startTime, String? endTime) {
    if (startTime == null || startTime.isEmpty) {
      return 'Horário de início é obrigatório';
    }

    if (endTime == null || endTime.isEmpty) {
      return 'Horário de fim é obrigatório';
    }

    // Converte strings para comparação
    final start = _parseTime(startTime);
    final end = _parseTime(endTime);

    if (start == null) {
      return 'Horário de início inválido';
    }

    if (end == null) {
      return 'Horário de fim inválido';
    }

    if (start.isAfter(end) || start.isAtSameMomentAs(end)) {
      return 'Horário de início deve ser anterior ao horário de fim';
    }

    return null;
  }

  /// Valida URL
  static String? url(String? value, {bool required = false}) {
    if (!required && (value == null || value.trim().isEmpty)) {
      return null;
    }

    if (value == null || value.trim().isEmpty) {
      return 'URL é obrigatória';
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value.trim())) {
      return 'URL inválida';
    }

    return null;
  }

  /// Valida telefone (formato brasileiro)
  static String? phone(String? value, {bool required = false}) {
    if (!required && (value == null || value.trim().isEmpty)) {
      return null;
    }

    if (value == null || value.trim().isEmpty) {
      return 'Telefone é obrigatório';
    }

    // Remove caracteres não numéricos
    final numbersOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Verifica se tem 10 ou 11 dígitos (telefone brasileiro)
    if (numbersOnly.length < 10 || numbersOnly.length > 11) {
      return 'Telefone deve ter 10 ou 11 dígitos';
    }

    return null;
  }

  /// Combina múltiplos validadores
  static String? combine(List<String? Function()> validators) {
    for (final validator in validators) {
      final result = validator();
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  /// Valida se o valor está dentro de um range numérico
  static String? numberRange(
    String? value, {
    required double min,
    required double max,
    String? fieldName,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Campo'} é obrigatório';
    }

    final number = double.tryParse(value.trim());
    if (number == null) {
      return '${fieldName ?? 'Campo'} deve ser um número válido';
    }

    if (number < min || number > max) {
      return '${fieldName ?? 'Campo'} deve estar entre $min e $max';
    }

    return null;
  }

  /// Valida comprimento mínimo e máximo
  static String? length(
    String? value, {
    int? min,
    int? max,
    String? fieldName,
  }) {
    if (value == null) {
      return '${fieldName ?? 'Campo'} é obrigatório';
    }

    final length = value.length;

    if (min != null && length < min) {
      return '${fieldName ?? 'Campo'} deve ter pelo menos $min caracteres';
    }

    if (max != null && length > max) {
      return '${fieldName ?? 'Campo'} deve ter no máximo $max caracteres';
    }

    return null;
  }

  /// Método auxiliar para converter string de tempo em DateTime
  static DateTime? _parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) return null;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        return null;
      }

      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (e) {
      return null;
    }
  }
}

```

### lib\core\utils\string_helpers.dart

```dart
import 'dart:math';

/// Classe utilitária para manipulação de strings
class StringHelpers {
  /// Capitaliza a primeira letra de uma string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Capitaliza a primeira letra de cada palavra
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  /// Remove espaços extras e quebras de linha
  static String cleanText(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Trunca o texto se exceder o limite de caracteres
  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - suffix.length) + suffix;
  }

  /// Gera um código alfanumérico aleatório
  static String generateRandomCode(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  /// Gera um ID único baseado em timestamp e random
  static String generateUniqueId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(9999);
    return '${timestamp}_$random';
  }

  /// Valida se uma string contém apenas letras e espaços
  static bool isValidName(String text) {
    return RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(text);
  }

  /// Valida se uma string é um email válido
  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  /// Remove acentos de uma string
  static String removeAccents(String text) {
    const withAccents = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëÇçÌÍÎÏìíîïÙÚÛÜùúûüÿÑñ';
    const withoutAccents = 'AAAAAAaaaaaaOOOOOOooooooEEEEeeeeeCcIIIIiiiiUUUUuuuuyNn';
    
    String result = text;
    for (int i = 0; i < withAccents.length; i++) {
      result = result.replaceAll(withAccents[i], withoutAccents[i]);
    }
    return result;
  }

  /// Converte string para formato de busca (sem acentos, minúscula)
  static String toSearchFormat(String text) {
    return removeAccents(text.toLowerCase().trim());
  }

  /// Extrai iniciais de um nome
  static String getInitials(String name, {int maxInitials = 2}) {
    if (name.isEmpty) return '';
    
    final words = name.trim().split(' ');
    final initials = words
        .where((word) => word.isNotEmpty)
        .take(maxInitials)
        .map((word) => word[0].toUpperCase())
        .join();
    
    return initials;
  }

  /// Formata um número de telefone
  static String formatPhoneNumber(String phone) {
    // Remove todos os caracteres não numéricos
    final numbers = phone.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (numbers.length == 11) {
      // Formato: (XX) XXXXX-XXXX
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 7)}-${numbers.substring(7)}';
    } else if (numbers.length == 10) {
      // Formato: (XX) XXXX-XXXX
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 6)}-${numbers.substring(6)}';
    }
    
    return phone; // Retorna original se não conseguir formatar
  }

  /// Converte uma lista de strings em uma string separada por vírgulas
  static String joinWithComma(List<String> items) {
    return items.join(', ');
  }

  /// Converte uma string separada por vírgulas em lista
  static List<String> splitByComma(String text) {
    return text.split(',').map((item) => item.trim()).where((item) => item.isNotEmpty).toList();
  }

  /// Verifica se uma string está vazia ou contém apenas espaços
  static bool isNullOrEmpty(String? text) {
    return text == null || text.trim().isEmpty;
  }

  /// Verifica se uma string não está vazia
  static bool isNotNullOrEmpty(String? text) {
    return !isNullOrEmpty(text);
  }

  /// Conta o número de palavras em um texto
  static int countWords(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }

  /// Estima o tempo de leitura em minutos (baseado em 200 palavras por minuto)
  static int estimateReadingTime(String text) {
    final wordCount = countWords(text);
    return (wordCount / 200).ceil();
  }

  /// Converte uma string para slug (URL-friendly)
  static String toSlug(String text) {
    return removeAccents(text)
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  /// Mascara informações sensíveis (ex: email, telefone)
  static String maskSensitiveInfo(String text, {int visibleChars = 3}) {
    if (text.length <= visibleChars * 2) return text;
    
    final start = text.substring(0, visibleChars);
    final end = text.substring(text.length - visibleChars);
    final middle = '*' * (text.length - visibleChars * 2);
    
    return start + middle + end;
  }

  /// Converte bytes para string legível (KB, MB, GB)
  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Converte duração em segundos para string legível
  static String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${remainingSeconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${remainingSeconds}s';
    } else {
      return '${remainingSeconds}s';
    }
  }

  /// Pluraliza uma palavra baseada na quantidade
  static String pluralize(int count, String singular, String plural) {
    return count == 1 ? singular : plural;
  }

  /// Formata um número com separadores de milhares
  static String formatNumber(num number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]}.',
    );
  }

  /// Converte uma string para camelCase
  static String toCamelCase(String text) {
    final words = text.toLowerCase().split(RegExp(r'[\s_-]+'));
    if (words.isEmpty) return '';
    
    return words.first + words.skip(1).map(capitalize).join();
  }

  /// Converte uma string para snake_case
  static String toSnakeCase(String text) {
    return text
        .replaceAll(RegExp(r'([A-Z])'), '_\$1')
        .toLowerCase()
        .replaceAll(RegExp(r'^_'), '')
        .replaceAll(RegExp(r'[\s-]+'), '_');
  }
}

```

### lib\core\utils\validators.dart

```dart
import '../constants/app_constants.dart';

/// Classe utilitária para validações de formulários
class Validators {
  /// Valida se o email tem formato válido
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-mail é obrigatório';
    }
    
    final emailRegex = RegExp(AppConstants.emailPattern);
    if (!emailRegex.hasMatch(value)) {
      return 'E-mail inválido';
    }
    
    return null;
  }

  /// Valida senha
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    
    if (value.length < AppConstants.passwordMinLength) {
      return 'Senha deve ter pelo menos ${AppConstants.passwordMinLength} caracteres';
    }
    
    if (value.length > AppConstants.passwordMaxLength) {
      return 'Senha deve ter no máximo ${AppConstants.passwordMaxLength} caracteres';
    }
    
    return null;
  }

  /// Valida confirmação de senha
  static String? validatePasswordConfirmation(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }
    
    if (value != password) {
      return 'Senhas não coincidem';
    }
    
    return null;
  }

  /// Valida nome
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }
    
    if (value.length < AppConstants.nameMinLength) {
      return 'Nome deve ter pelo menos ${AppConstants.nameMinLength} caracteres';
    }
    
    if (value.length > AppConstants.nameMaxLength) {
      return 'Nome deve ter no máximo ${AppConstants.nameMaxLength} caracteres';
    }
    
    return null;
  }

  /// Valida nome do evento
  static String? validateEventName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome do evento é obrigatório';
    }
    
    if (value.length < AppConstants.eventNameMinLength) {
      return 'Nome deve ter pelo menos ${AppConstants.eventNameMinLength} caracteres';
    }
    
    if (value.length > AppConstants.eventNameMaxLength) {
      return 'Nome deve ter no máximo ${AppConstants.eventNameMaxLength} caracteres';
    }
    
    return null;
  }

  /// Valida descrição do evento
  static String? validateEventDescription(String? value) {
    if (value != null && value.length > AppConstants.eventDescriptionMaxLength) {
      return 'Descrição deve ter no máximo ${AppConstants.eventDescriptionMaxLength} caracteres';
    }
    
    return null;
  }

  /// Valida localização do evento
  static String? validateEventLocation(String? value) {
    if (value != null && value.length > AppConstants.eventLocationMaxLength) {
      return 'Localização deve ter no máximo ${AppConstants.eventLocationMaxLength} caracteres';
    }
    
    return null;
  }

  /// Valida código/tag do evento
  static String? validateEventTag(String? value) {
    if (value == null || value.isEmpty) {
      return 'Código do evento é obrigatório';
    }
    
    final tagRegex = RegExp(AppConstants.eventTagPattern);
    if (!tagRegex.hasMatch(value)) {
      return 'Código deve ter 6 caracteres alfanuméricos maiúsculos';
    }
    
    return null;
  }

  /// Valida nome da task
  static String? validateTaskName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome da tarefa é obrigatório';
    }
    
    if (value.length < AppConstants.taskNameMinLength) {
      return 'Nome deve ter pelo menos ${AppConstants.taskNameMinLength} caracteres';
    }
    
    if (value.length > AppConstants.taskNameMaxLength) {
      return 'Nome deve ter no máximo ${AppConstants.taskNameMaxLength} caracteres';
    }
    
    return null;
  }

  /// Valida descrição da task
  static String? validateTaskDescription(String? value) {
    if (value != null && value.length > AppConstants.taskDescriptionMaxLength) {
      return 'Descrição deve ter no máximo ${AppConstants.taskDescriptionMaxLength} caracteres';
    }
    
    return null;
  }

  /// Valida nome da microtask
  static String? validateMicrotaskName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome da microtarefa é obrigatório';
    }
    
    if (value.length < AppConstants.microtaskNameMinLength) {
      return 'Nome deve ter pelo menos ${AppConstants.microtaskNameMinLength} caracteres';
    }
    
    if (value.length > AppConstants.microtaskNameMaxLength) {
      return 'Nome deve ter no máximo ${AppConstants.microtaskNameMaxLength} caracteres';
    }
    
    return null;
  }

  /// Valida descrição da microtask
  static String? validateMicrotaskDescription(String? value) {
    if (value != null && value.length > AppConstants.microtaskDescriptionMaxLength) {
      return 'Descrição deve ter no máximo ${AppConstants.microtaskDescriptionMaxLength} caracteres';
    }
    
    return null;
  }

  /// Valida horas estimadas
  static String? validateEstimatedHours(String? value) {
    if (value == null || value.isEmpty) {
      return 'Horas estimadas são obrigatórias';
    }
    
    final hours = double.tryParse(value);
    if (hours == null) {
      return 'Valor inválido';
    }
    
    if (hours < AppConstants.minEstimatedHours) {
      return 'Mínimo de ${AppConstants.minEstimatedHours} horas';
    }
    
    if (hours > AppConstants.maxEstimatedHours) {
      return 'Máximo de ${AppConstants.maxEstimatedHours} horas';
    }
    
    return null;
  }

  /// Valida se uma lista não está vazia
  static String? validateRequiredList(List<dynamic>? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    
    return null;
  }

  /// Valida se um valor não é nulo nem vazio
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    
    return null;
  }
}

```

### lib\data\models\event_model.dart

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de dados para representar um evento no sistema
/// Baseado na estrutura definida no SPEC_GERAL.md
class EventModel {
  final String id;
  final String name;
  final String description;
  final String tag;
  final String location;
  final String createdBy;
  final List<String> managers;
  final List<String> volunteers;
  final List<String> requiredSkills;
  final List<String> requiredResources;
  final EventStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EventModel({
    required this.id,
    required this.name,
    required this.description,
    required this.tag,
    required this.location,
    required this.createdBy,
    required this.managers,
    required this.volunteers,
    required this.requiredSkills,
    required this.requiredResources,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Cria uma instância de EventModel a partir de um Map (JSON)
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      tag: map['tag'] as String,
      location: map['location'] as String,
      createdBy: map['createdBy'] as String,
      managers: List<String>.from(map['managers'] as List),
      volunteers: List<String>.from(map['volunteers'] as List),
      requiredSkills: List<String>.from(map['requiredSkills'] as List),
      requiredResources: List<String>.from(map['requiredResources'] as List),
      status: EventStatus.fromString(map['status'] as String),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Cria uma instância de EventModel a partir de um DocumentSnapshot do Firestore
  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel.fromMap({'id': doc.id, ...data});
  }

  /// Converte a instância para um Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tag': tag,
      'location': location,
      'createdBy': createdBy,
      'managers': managers,
      'volunteers': volunteers,
      'requiredSkills': requiredSkills,
      'requiredResources': requiredResources,
      'status': status.value,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Converte para Map sem o ID (usado para criar documentos no Firestore)
  Map<String, dynamic> toFirestore() {
    final map = toMap();
    map.remove('id'); // Remove o ID pois será gerado pelo Firestore
    return map;
  }

  /// Cria uma cópia da instância com alguns campos alterados
  EventModel copyWith({
    String? id,
    String? name,
    String? description,
    String? tag,
    String? location,
    String? createdBy,
    List<String>? managers,
    List<String>? volunteers,
    List<String>? requiredSkills,
    List<String>? requiredResources,
    EventStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      tag: tag ?? this.tag,
      location: location ?? this.location,
      createdBy: createdBy ?? this.createdBy,
      managers: managers ?? List<String>.from(this.managers),
      volunteers: volunteers ?? List<String>.from(this.volunteers),
      requiredSkills: requiredSkills ?? List<String>.from(this.requiredSkills),
      requiredResources:
          requiredResources ?? List<String>.from(this.requiredResources),
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Cria uma nova instância com updatedAt atualizado para agora
  EventModel withUpdatedTimestamp() {
    return copyWith(updatedAt: DateTime.now());
  }

  /// Verifica se o usuário é gerenciador do evento
  bool isManager(String userId) {
    return managers.contains(userId);
  }

  /// Verifica se o usuário é voluntário do evento
  bool isVolunteer(String userId) {
    return volunteers.contains(userId);
  }

  /// Verifica se o usuário é participante (gerenciador ou voluntário)
  bool isParticipant(String userId) {
    return isManager(userId) || isVolunteer(userId);
  }

  /// Verifica se o usuário é o criador do evento
  bool isCreator(String userId) {
    return createdBy == userId;
  }

  /// Adiciona um voluntário ao evento
  EventModel addVolunteer(String userId) {
    if (volunteers.contains(userId)) return this;

    final newVolunteers = List<String>.from(volunteers)..add(userId);
    return copyWith(volunteers: newVolunteers).withUpdatedTimestamp();
  }

  /// Remove um voluntário do evento
  EventModel removeVolunteer(String userId) {
    if (!volunteers.contains(userId)) return this;

    final newVolunteers = List<String>.from(volunteers)..remove(userId);
    return copyWith(volunteers: newVolunteers).withUpdatedTimestamp();
  }

  /// Promove um voluntário a gerenciador
  EventModel promoteToManager(String userId) {
    if (managers.contains(userId)) return this;

    final newManagers = List<String>.from(managers)..add(userId);
    final newVolunteers = List<String>.from(volunteers)..remove(userId);

    return copyWith(
      managers: newManagers,
      volunteers: newVolunteers,
    ).withUpdatedTimestamp();
  }

  /// Remove um gerenciador (não pode remover o criador)
  EventModel removeManager(String userId) {
    if (userId == createdBy || !managers.contains(userId)) return this;

    final newManagers = List<String>.from(managers)..remove(userId);
    return copyWith(managers: newManagers).withUpdatedTimestamp();
  }

  /// Retorna o número total de participantes
  int get totalParticipants => managers.length + volunteers.length;

  /// Retorna o papel do usuário no evento
  UserRole getUserRole(String userId) {
    if (createdBy == userId) return UserRole.creator;
    if (managers.contains(userId)) return UserRole.manager;
    if (volunteers.contains(userId)) return UserRole.volunteer;
    return UserRole.none;
  }

  /// Valida se os dados do evento são válidos
  bool isValid() {
    return id.isNotEmpty &&
        name.isNotEmpty &&
        tag.isNotEmpty &&
        location.isNotEmpty &&
        createdBy.isNotEmpty &&
        managers.isNotEmpty &&
        managers.contains(createdBy);
  }

  /// Factory para criar um novo evento
  /// Note: ID, tag e timestamps devem ser definidos pelo service
  factory EventModel.create({
    required String id,
    required String name,
    required String description,
    required String tag,
    required String location,
    required String createdBy,
    required List<String> requiredSkills,
    required List<String> requiredResources,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    return EventModel(
      id: id,
      name: name,
      description: description,
      tag: tag,
      location: location,
      createdBy: createdBy,
      managers: [createdBy], // Criador é automaticamente gerenciador
      volunteers: [],
      requiredSkills: requiredSkills,
      requiredResources: requiredResources,
      status: EventStatus.active,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Converte para string para debug
  @override
  String toString() {
    return 'EventModel(id: $id, name: $name, tag: $tag, status: ${status.value}, participants: $totalParticipants)';
  }

  /// Implementa igualdade baseada no ID
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventModel && other.id == id;
  }

  /// Implementa hashCode baseado no ID
  @override
  int get hashCode => id.hashCode;

  /// Método para validar dados antes de salvar
  List<String> validate() {
    final errors = <String>[];

    if (id.isEmpty) {
      errors.add('ID é obrigatório');
    }

    if (name.isEmpty) {
      errors.add('Nome é obrigatório');
    } else if (name.length < 3) {
      errors.add('Nome deve ter pelo menos 3 caracteres');
    } else if (name.length > 100) {
      errors.add('Nome deve ter no máximo 100 caracteres');
    }

    if (description.length > 500) {
      errors.add('Descrição deve ter no máximo 500 caracteres');
    }

    if (tag.isEmpty) {
      errors.add('Tag é obrigatória');
    } else if (tag.length != 6) {
      errors.add('Tag deve ter exatamente 6 caracteres');
    }

    if (location.isEmpty) {
      errors.add('Localização é obrigatória');
    } else if (location.length > 200) {
      errors.add('Localização deve ter no máximo 200 caracteres');
    }

    if (createdBy.isEmpty) {
      errors.add('Criador é obrigatório');
    }

    if (managers.isEmpty) {
      errors.add('Deve haver pelo menos um gerenciador');
    }

    if (!managers.contains(createdBy)) {
      errors.add('Criador deve ser um gerenciador');
    }

    return errors;
  }

  /// Retorna há quanto tempo o evento foi criado
  String get createdTimeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} dia${difference.inDays > 1 ? 's' : ''} atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''} atrás';
    } else {
      return 'Agora mesmo';
    }
  }

  /// Retorna há quanto tempo o evento foi atualizado
  String get updatedTimeAgo {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} dia${difference.inDays > 1 ? 's' : ''} atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''} atrás';
    } else {
      return 'Agora mesmo';
    }
  }

  /// Verifica se o evento foi criado recentemente (últimas 24 horas)
  bool get isNewEvent {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inHours < 24;
  }

  /// Retorna uma versão resumida da descrição
  String get shortDescription {
    if (description.length <= 100) return description;
    return '${description.substring(0, 97)}...';
  }

  /// Retorna as habilidades como string formatada
  String get skillsText {
    if (requiredSkills.isEmpty) return 'Nenhuma habilidade específica';
    return requiredSkills.join(', ');
  }

  /// Retorna os recursos como string formatada
  String get resourcesText {
    if (requiredResources.isEmpty) return 'Nenhum recurso específico';
    return requiredResources.join(', ');
  }

  /// Atualiza o status do evento
  EventModel updateStatus(EventStatus newStatus) {
    return copyWith(status: newStatus).withUpdatedTimestamp();
  }

  /// Adiciona uma habilidade necessária
  EventModel addRequiredSkill(String skill) {
    if (requiredSkills.contains(skill)) return this;

    final newSkills = List<String>.from(requiredSkills)..add(skill);
    return copyWith(requiredSkills: newSkills).withUpdatedTimestamp();
  }

  /// Remove uma habilidade necessária
  EventModel removeRequiredSkill(String skill) {
    if (!requiredSkills.contains(skill)) return this;

    final newSkills = List<String>.from(requiredSkills)..remove(skill);
    return copyWith(requiredSkills: newSkills).withUpdatedTimestamp();
  }

  /// Adiciona um recurso necessário
  EventModel addRequiredResource(String resource) {
    if (requiredResources.contains(resource)) return this;

    final newResources = List<String>.from(requiredResources)..add(resource);
    return copyWith(requiredResources: newResources).withUpdatedTimestamp();
  }

  /// Remove um recurso necessário
  EventModel removeRequiredResource(String resource) {
    if (!requiredResources.contains(resource)) return this;

    final newResources = List<String>.from(requiredResources)..remove(resource);
    return copyWith(requiredResources: newResources).withUpdatedTimestamp();
  }
}

/// Enum para representar o status do evento
enum EventStatus {
  active('active'),
  completed('completed'),
  cancelled('cancelled');

  const EventStatus(this.value);
  final String value;

  static EventStatus fromString(String value) {
    return EventStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => EventStatus.active,
    );
  }

  String get displayName {
    switch (this) {
      case EventStatus.active:
        return 'Ativo';
      case EventStatus.completed:
        return 'Concluído';
      case EventStatus.cancelled:
        return 'Cancelado';
    }
  }
}

/// Enum para representar o papel do usuário no evento
enum UserRole {
  creator('creator'),
  manager('manager'),
  volunteer('volunteer'),
  none('none');

  const UserRole(this.value);
  final String value;

  String get displayName {
    switch (this) {
      case UserRole.creator:
        return 'Criador';
      case UserRole.manager:
        return 'Gerenciador';
      case UserRole.volunteer:
        return 'Voluntário';
      case UserRole.none:
        return 'Não participante';
    }
  }
}

```

### lib\data\models\microtask_model.dart

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Enums para status das microtasks
enum MicrotaskStatus {
  pending('pending'),
  assigned('assigned'),
  inProgress('in_progress'),
  completed('completed'),
  cancelled('cancelled');

  const MicrotaskStatus(this.value);
  final String value;

  static MicrotaskStatus fromString(String value) {
    return MicrotaskStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => MicrotaskStatus.pending,
    );
  }

  @override
  String toString() => value;
}

/// Modelo de dados para representar uma microtask no sistema
/// Microtasks são as unidades de trabalho que podem ter múltiplos voluntários
/// Baseado na estrutura definida no SPEC_GERAL.md
class MicrotaskModel {
  final String id;
  final String taskId;
  final String eventId;
  final String title;
  final String description;
  final List<String> assignedTo;
  final int maxVolunteers;
  final List<String> requiredSkills;
  final List<String> requiredResources;
  final DateTime?
  startDateTime; // Data e hora inicial da microtask (dd/mm/yyyy HH:MM)
  final DateTime?
  endDateTime; // Data e hora final da microtask (dd/mm/yyyy HH:MM)
  final String priority; // Usa string para compatibilidade com TaskPriority
  final MicrotaskStatus status;
  final String createdBy;
  final DateTime? assignedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MicrotaskModel({
    required this.id,
    required this.taskId,
    required this.eventId,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.maxVolunteers,
    required this.requiredSkills,
    required this.requiredResources,
    this.startDateTime,
    this.endDateTime,
    required this.priority,
    required this.status,
    required this.createdBy,
    this.assignedAt,
    this.startedAt,
    this.completedAt,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Cria uma instância de MicrotaskModel a partir de um Map (JSON)
  factory MicrotaskModel.fromMap(Map<String, dynamic> map) {
    return MicrotaskModel(
      id: map['id'] as String,
      taskId: map['taskId'] as String,
      eventId: map['eventId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      assignedTo: List<String>.from(map['assignedTo'] as List? ?? []),
      maxVolunteers: map['maxVolunteers'] as int? ?? 1,
      requiredSkills: List<String>.from(map['requiredSkills'] as List? ?? []),
      requiredResources: List<String>.from(
        map['requiredResources'] as List? ?? [],
      ),
      startDateTime: map['startDateTime'] != null
          ? (map['startDateTime'] as Timestamp).toDate()
          : null,
      endDateTime: map['endDateTime'] != null
          ? (map['endDateTime'] as Timestamp).toDate()
          : null,
      priority: map['priority'] as String? ?? 'medium',
      status: MicrotaskStatus.fromString(map['status'] as String? ?? 'pending'),
      createdBy: map['createdBy'] as String,
      assignedAt: map['assignedAt'] != null
          ? (map['assignedAt'] as Timestamp).toDate()
          : null,
      startedAt: map['startedAt'] != null
          ? (map['startedAt'] as Timestamp).toDate()
          : null,
      completedAt: map['completedAt'] != null
          ? (map['completedAt'] as Timestamp).toDate()
          : null,
      notes: map['notes'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Cria uma instância de MicrotaskModel a partir de um DocumentSnapshot do Firestore
  factory MicrotaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MicrotaskModel.fromMap({'id': doc.id, ...data});
  }

  /// Converte a instância para um Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'eventId': eventId,
      'title': title,
      'description': description,
      'assignedTo': assignedTo,
      'maxVolunteers': maxVolunteers,
      'requiredSkills': requiredSkills,
      'requiredResources': requiredResources,
      'startDateTime': startDateTime != null
          ? Timestamp.fromDate(startDateTime!)
          : null,
      'endDateTime': endDateTime != null
          ? Timestamp.fromDate(endDateTime!)
          : null,
      'priority': priority,
      'status': status.value,
      'createdBy': createdBy,
      'assignedAt': assignedAt != null ? Timestamp.fromDate(assignedAt!) : null,
      'startedAt': startedAt != null ? Timestamp.fromDate(startedAt!) : null,
      'completedAt': completedAt != null
          ? Timestamp.fromDate(completedAt!)
          : null,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Converte para formato do Firestore (sem o ID)
  Map<String, dynamic> toFirestore() {
    final map = toMap();
    map.remove('id');
    return map;
  }

  /// Cria uma cópia da instância com alguns campos alterados
  MicrotaskModel copyWith({
    String? id,
    String? taskId,
    String? eventId,
    String? title,
    String? description,
    List<String>? assignedTo,
    int? maxVolunteers,
    List<String>? requiredSkills,
    List<String>? requiredResources,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? priority,
    MicrotaskStatus? status,
    String? createdBy,
    DateTime? assignedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MicrotaskModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      eventId: eventId ?? this.eventId,
      title: title ?? this.title,
      description: description ?? this.description,
      assignedTo: assignedTo ?? List<String>.from(this.assignedTo),
      maxVolunteers: maxVolunteers ?? this.maxVolunteers,
      requiredSkills: requiredSkills ?? List<String>.from(this.requiredSkills),
      requiredResources:
          requiredResources ?? List<String>.from(this.requiredResources),
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      assignedAt: assignedAt ?? this.assignedAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Cria uma nova instância com updatedAt atualizado para agora
  MicrotaskModel withUpdatedTimestamp() {
    return copyWith(updatedAt: DateTime.now());
  }

  /// Factory para criar uma nova microtask
  /// Note: ID e timestamps devem ser definidos pelo service
  factory MicrotaskModel.create({
    required String id,
    required String taskId,
    required String eventId,
    required String title,
    required String description,
    required List<String> requiredSkills,
    required List<String> requiredResources,
    DateTime? startDateTime,
    DateTime? endDateTime,
    required String priority,
    required int maxVolunteers,
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? notes,
  }) {
    return MicrotaskModel(
      id: id,
      taskId: taskId,
      eventId: eventId,
      title: title,
      description: description,
      assignedTo: [],
      maxVolunteers: maxVolunteers > 0 ? maxVolunteers : 1,
      requiredSkills: requiredSkills,
      requiredResources: requiredResources,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      priority: priority,
      status: MicrotaskStatus.pending,
      createdBy: createdBy,
      notes: notes ?? '',
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Valida se os dados da microtask são válidos
  List<String> validate() {
    final errors = <String>[];

    if (taskId.isEmpty) {
      errors.add('ID da task pai é obrigatório');
    }

    if (eventId.isEmpty) {
      errors.add('ID do evento é obrigatório');
    }

    if (title.isEmpty) {
      errors.add('Título da microtask é obrigatório');
    } else if (title.length < 3) {
      errors.add('Título deve ter pelo menos 3 caracteres');
    } else if (title.length > 100) {
      errors.add('Título deve ter no máximo 100 caracteres');
    }

    if (description.isEmpty) {
      errors.add('Descrição da microtask é obrigatória');
    } else if (description.length > 1000) {
      errors.add('Descrição deve ter no máximo 1000 caracteres');
    }

    if (maxVolunteers <= 0) {
      errors.add('Número máximo de voluntários deve ser maior que zero');
    }

    if (assignedTo.length > maxVolunteers) {
      errors.add('Número de voluntários atribuídos excede o máximo permitido');
    }

    if (startDateTime != null &&
        endDateTime != null &&
        startDateTime!.isAfter(endDateTime!)) {
      errors.add('Data/hora inicial deve ser anterior à data/hora final');
    }

    if (createdBy.isEmpty) {
      errors.add('Criador da microtask é obrigatório');
    }

    return errors;
  }

  /// Verifica se a microtask é válida
  bool isValid() => validate().isEmpty;

  /// Verifica se há vagas disponíveis para voluntários
  bool get hasAvailableSlots => assignedTo.length < maxVolunteers;

  /// Número de vagas disponíveis
  int get availableSlots => maxVolunteers - assignedTo.length;

  /// Verifica se a microtask está concluída
  bool get isCompleted => status == MicrotaskStatus.completed;

  /// Verifica se a microtask está em progresso
  bool get isInProgress => status == MicrotaskStatus.inProgress;

  /// Verifica se a microtask está pendente
  bool get isPending => status == MicrotaskStatus.pending;

  /// Verifica se a microtask foi cancelada
  bool get isCancelled => status == MicrotaskStatus.cancelled;

  /// Verifica se a microtask tem voluntários atribuídos
  bool get hasAssignedVolunteers => assignedTo.isNotEmpty;

  /// Verifica se um usuário específico está atribuído à microtask
  bool isAssignedTo(String userId) => assignedTo.contains(userId);

  /// Adiciona um voluntário à microtask
  MicrotaskModel assignVolunteer(String userId) {
    if (isAssignedTo(userId)) {
      return this; // Já está atribuído
    }

    if (!hasAvailableSlots) {
      return this; // Não há vagas disponíveis
    }

    final newAssignedTo = List<String>.from(assignedTo)..add(userId);
    final now = DateTime.now();

    return copyWith(
      assignedTo: newAssignedTo,
      status: MicrotaskStatus.assigned,
      assignedAt: assignedAt ?? now,
      updatedAt: now,
    );
  }

  /// Remove um voluntário da microtask
  MicrotaskModel unassignVolunteer(String userId) {
    if (!isAssignedTo(userId)) {
      return this; // Não está atribuído
    }

    final newAssignedTo = List<String>.from(assignedTo)..remove(userId);
    final now = DateTime.now();

    // Atualiza o status baseado no número de voluntários restantes
    MicrotaskStatus newStatus;
    if (newAssignedTo.isEmpty) {
      newStatus = MicrotaskStatus.pending;
    } else {
      newStatus = status; // Mantém o status atual se ainda há voluntários
    }

    return copyWith(
      assignedTo: newAssignedTo,
      status: newStatus,
      updatedAt: now,
    );
  }

  /// Marca a microtask como iniciada
  MicrotaskModel markAsStarted() {
    if (status == MicrotaskStatus.pending ||
        status == MicrotaskStatus.assigned) {
      final now = DateTime.now();
      return copyWith(
        status: MicrotaskStatus.inProgress,
        startedAt: startedAt ?? now,
        updatedAt: now,
      );
    }
    return this;
  }

  /// Marca a microtask como concluída
  MicrotaskModel markAsCompleted() {
    final now = DateTime.now();
    return copyWith(
      status: MicrotaskStatus.completed,
      completedAt: completedAt ?? now,
      updatedAt: now,
    );
  }

  /// Marca a microtask como cancelada
  MicrotaskModel markAsCancelled() {
    final now = DateTime.now();
    return copyWith(status: MicrotaskStatus.cancelled, updatedAt: now);
  }

  /// Atualiza as notas da microtask
  MicrotaskModel updateNotes(String newNotes) {
    return copyWith(notes: newNotes, updatedAt: DateTime.now());
  }

  /// Verifica se a microtask é compatível com as habilidades de um voluntário
  bool isCompatibleWith(List<String> volunteerSkills) {
    if (requiredSkills.isEmpty) return true;

    return requiredSkills.every((skill) => volunteerSkills.contains(skill));
  }

  /// Calcula a porcentagem de compatibilidade com as habilidades de um voluntário
  double getCompatibilityScore(List<String> volunteerSkills) {
    if (requiredSkills.isEmpty) return 1.0;

    final matchingSkills = requiredSkills
        .where((skill) => volunteerSkills.contains(skill))
        .length;
    return matchingSkills / requiredSkills.length;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MicrotaskModel &&
        other.id == id &&
        other.taskId == taskId &&
        other.eventId == eventId &&
        other.title == title &&
        other.description == description &&
        other.maxVolunteers == maxVolunteers &&
        other.startDateTime == startDateTime &&
        other.endDateTime == endDateTime &&
        other.priority == priority &&
        other.status == status &&
        other.createdBy == createdBy;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      taskId,
      eventId,
      title,
      description,
      maxVolunteers,
      startDateTime,
      endDateTime,
      priority,
      status,
      createdBy,
    );
  }

  /// Retorna a duração estimada em horas (para compatibilidade)
  double get estimatedHours {
    if (startDateTime == null || endDateTime == null) return 0.0;
    final duration = endDateTime!.difference(startDateTime!);
    return duration.inMinutes / 60.0;
  }

  /// Retorna a data/hora inicial formatada
  String get startDateTimeFormatted {
    if (startDateTime == null) return 'Não definida';
    return '${startDateTime!.day.toString().padLeft(2, '0')}/${startDateTime!.month.toString().padLeft(2, '0')}/${startDateTime!.year} ${startDateTime!.hour.toString().padLeft(2, '0')}:${startDateTime!.minute.toString().padLeft(2, '0')}';
  }

  /// Retorna a data/hora final formatada
  String get endDateTimeFormatted {
    if (endDateTime == null) return 'Não definida';
    return '${endDateTime!.day.toString().padLeft(2, '0')}/${endDateTime!.month.toString().padLeft(2, '0')}/${endDateTime!.year} ${endDateTime!.hour.toString().padLeft(2, '0')}:${endDateTime!.minute.toString().padLeft(2, '0')}';
  }

  /// Retorna o período formatado
  String get periodFormatted {
    if (startDateTime == null || endDateTime == null) {
      return 'Período não definido';
    }
    return '$startDateTimeFormatted - $endDateTimeFormatted';
  }

  /// Verifica se a microtask tem horário definido
  bool get hasSchedule => startDateTime != null && endDateTime != null;

  @override
  String toString() {
    return 'MicrotaskModel(id: $id, title: $title, status: $status, assigned: ${assignedTo.length}/$maxVolunteers)';
  }
}

```

### lib\data\models\task_model.dart

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Enums para status e prioridade das tasks
enum TaskStatus {
  pending('pending'),
  inProgress('in_progress'),
  completed('completed'),
  cancelled('cancelled');

  const TaskStatus(this.value);
  final String value;

  static TaskStatus fromString(String value) {
    return TaskStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TaskStatus.pending,
    );
  }

  @override
  String toString() => value;
}

enum TaskPriority {
  low('low'),
  medium('medium'),
  high('high');

  const TaskPriority(this.value);
  final String value;

  static TaskPriority fromString(String value) {
    return TaskPriority.values.firstWhere(
      (priority) => priority.value == value,
      orElse: () => TaskPriority.medium,
    );
  }

  @override
  String toString() => value;
}

/// Modelo de dados para representar uma task (organizadora) no sistema
/// Tasks servem como agrupadores organizacionais para microtasks
/// Baseado na estrutura definida no SPEC_GERAL.md
class TaskModel {
  final String id;
  final String eventId;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskStatus status;
  final String createdBy;
  final int microtaskCount;
  final int completedMicrotasks;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaskModel({
    required this.id,
    required this.eventId,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdBy,
    required this.microtaskCount,
    required this.completedMicrotasks,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Cria uma instância de TaskModel a partir de um Map (JSON)
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      eventId: map['eventId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      priority: TaskPriority.fromString(map['priority'] as String),
      status: TaskStatus.fromString(map['status'] as String),
      createdBy: map['createdBy'] as String,
      microtaskCount: map['microtaskCount'] as int? ?? 0,
      completedMicrotasks: map['completedMicrotasks'] as int? ?? 0,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Cria uma instância de TaskModel a partir de um DocumentSnapshot do Firestore
  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel.fromMap({'id': doc.id, ...data});
  }

  /// Converte a instância para um Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventId': eventId,
      'title': title,
      'description': description,
      'priority': priority.value,
      'status': status.value,
      'createdBy': createdBy,
      'microtaskCount': microtaskCount,
      'completedMicrotasks': completedMicrotasks,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Converte para formato do Firestore (sem o ID)
  Map<String, dynamic> toFirestore() {
    final map = toMap();
    map.remove('id');
    return map;
  }

  /// Cria uma cópia da instância com alguns campos alterados
  TaskModel copyWith({
    String? id,
    String? eventId,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    String? createdBy,
    int? microtaskCount,
    int? completedMicrotasks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      microtaskCount: microtaskCount ?? this.microtaskCount,
      completedMicrotasks: completedMicrotasks ?? this.completedMicrotasks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Cria uma nova instância com updatedAt atualizado para agora
  TaskModel withUpdatedTimestamp() {
    return copyWith(updatedAt: DateTime.now());
  }

  /// Factory para criar uma nova task
  /// Note: ID e timestamps devem ser definidos pelo service
  factory TaskModel.create({
    required String id,
    required String eventId,
    required String title,
    required String description,
    required TaskPriority priority,
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    return TaskModel(
      id: id,
      eventId: eventId,
      title: title,
      description: description,
      priority: priority,
      status: TaskStatus.pending,
      createdBy: createdBy,
      microtaskCount: 0,
      completedMicrotasks: 0,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Valida se os dados da task são válidos
  List<String> validate() {
    final errors = <String>[];

    if (eventId.isEmpty) {
      errors.add('ID do evento é obrigatório');
    }

    if (title.isEmpty) {
      errors.add('Título da task é obrigatório');
    } else if (title.length < 3) {
      errors.add('Título deve ter pelo menos 3 caracteres');
    } else if (title.length > 100) {
      errors.add('Título deve ter no máximo 100 caracteres');
    }

    if (description.isEmpty) {
      errors.add('Descrição da task é obrigatória');
    } else if (description.length > 500) {
      errors.add('Descrição deve ter no máximo 500 caracteres');
    }

    if (createdBy.isEmpty) {
      errors.add('Criador da task é obrigatório');
    }

    if (microtaskCount < 0) {
      errors.add('Número de microtasks não pode ser negativo');
    }

    if (completedMicrotasks < 0) {
      errors.add('Número de microtasks concluídas não pode ser negativo');
    }

    if (completedMicrotasks > microtaskCount) {
      errors.add(
        'Número de microtasks concluídas não pode ser maior que o total',
      );
    }

    return errors;
  }

  /// Verifica se a task é válida
  bool isValid() => validate().isEmpty;

  /// Calcula o progresso da task (0.0 a 1.0)
  double get progress {
    if (microtaskCount == 0) return 0.0;
    return completedMicrotasks / microtaskCount;
  }

  /// Verifica se a task está concluída
  bool get isCompleted => status == TaskStatus.completed;

  /// Verifica se a task está em progresso
  bool get isInProgress => status == TaskStatus.inProgress;

  /// Verifica se a task está pendente
  bool get isPending => status == TaskStatus.pending;

  /// Verifica se a task foi cancelada
  bool get isCancelled => status == TaskStatus.cancelled;

  /// Atualiza o status baseado no progresso das microtasks
  TaskModel updateStatusFromMicrotasks() {
    TaskStatus newStatus;

    if (completedMicrotasks == 0) {
      newStatus = TaskStatus.pending;
    } else if (completedMicrotasks == microtaskCount) {
      newStatus = TaskStatus.completed;
    } else {
      newStatus = TaskStatus.inProgress;
    }

    return copyWith(status: newStatus, updatedAt: DateTime.now());
  }

  /// Incrementa o contador de microtasks
  TaskModel incrementMicrotaskCount() {
    return copyWith(
      microtaskCount: microtaskCount + 1,
      updatedAt: DateTime.now(),
    );
  }

  /// Decrementa o contador de microtasks
  TaskModel decrementMicrotaskCount() {
    final newCount = microtaskCount > 0 ? microtaskCount - 1 : 0;
    final newCompleted = completedMicrotasks > newCount
        ? newCount
        : completedMicrotasks;

    return copyWith(
      microtaskCount: newCount,
      completedMicrotasks: newCompleted,
      updatedAt: DateTime.now(),
    );
  }

  /// Incrementa o contador de microtasks concluídas
  TaskModel incrementCompletedMicrotasks() {
    final newCompleted = completedMicrotasks < microtaskCount
        ? completedMicrotasks + 1
        : completedMicrotasks;

    return copyWith(
      completedMicrotasks: newCompleted,
      updatedAt: DateTime.now(),
    );
  }

  /// Decrementa o contador de microtasks concluídas
  TaskModel decrementCompletedMicrotasks() {
    final newCompleted = completedMicrotasks > 0 ? completedMicrotasks - 1 : 0;

    return copyWith(
      completedMicrotasks: newCompleted,
      updatedAt: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskModel &&
        other.id == id &&
        other.eventId == eventId &&
        other.title == title &&
        other.description == description &&
        other.priority == priority &&
        other.status == status &&
        other.createdBy == createdBy &&
        other.microtaskCount == microtaskCount &&
        other.completedMicrotasks == completedMicrotasks;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      eventId,
      title,
      description,
      priority,
      status,
      createdBy,
      microtaskCount,
      completedMicrotasks,
    );
  }

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, status: $status, progress: ${(progress * 100).toStringAsFixed(1)}%)';
  }
}

```

### lib\data\models\user_microtask_model.dart

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Enums para status individual do usuário na microtask
enum UserMicrotaskStatus {
  assigned('assigned'),
  started('started'),
  completed('completed'),
  cancelled('cancelled');

  const UserMicrotaskStatus(this.value);
  final String value;

  static UserMicrotaskStatus fromString(String value) {
    return UserMicrotaskStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => UserMicrotaskStatus.assigned,
    );
  }

  @override
  String toString() => value;
}

/// Modelo de dados para representar a relação entre um usuário e uma microtask
/// Controla o status individual de cada voluntário em uma microtask
/// Baseado na estrutura definida no SPEC_GERAL.md
class UserMicrotaskModel {
  final String id;
  final String userId;
  final String microtaskId;
  final String eventId;
  final UserMicrotaskStatus status;
  final DateTime assignedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final double? actualHours;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserMicrotaskModel({
    required this.id,
    required this.userId,
    required this.microtaskId,
    required this.eventId,
    required this.status,
    required this.assignedAt,
    this.startedAt,
    this.completedAt,
    this.actualHours,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Cria uma instância de UserMicrotaskModel a partir de um Map (JSON)
  factory UserMicrotaskModel.fromMap(Map<String, dynamic> map) {
    return UserMicrotaskModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      microtaskId: map['microtaskId'] as String,
      eventId: map['eventId'] as String,
      status: UserMicrotaskStatus.fromString(map['status'] as String),
      assignedAt: (map['assignedAt'] as Timestamp).toDate(),
      startedAt: map['startedAt'] != null
          ? (map['startedAt'] as Timestamp).toDate()
          : null,
      completedAt: map['completedAt'] != null
          ? (map['completedAt'] as Timestamp).toDate()
          : null,
      actualHours: (map['actualHours'] as num?)?.toDouble(),
      notes: map['notes'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Cria uma instância de UserMicrotaskModel a partir de um DocumentSnapshot do Firestore
  factory UserMicrotaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserMicrotaskModel.fromMap({'id': doc.id, ...data});
  }

  /// Converte a instância para um Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'microtaskId': microtaskId,
      'eventId': eventId,
      'status': status.value,
      'assignedAt': Timestamp.fromDate(assignedAt),
      'startedAt': startedAt != null ? Timestamp.fromDate(startedAt!) : null,
      'completedAt': completedAt != null
          ? Timestamp.fromDate(completedAt!)
          : null,
      'actualHours': actualHours,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Converte para formato do Firestore (sem o ID)
  Map<String, dynamic> toFirestore() {
    final map = toMap();
    map.remove('id');
    return map;
  }

  /// Cria uma cópia da instância com alguns campos alterados
  UserMicrotaskModel copyWith({
    String? id,
    String? userId,
    String? microtaskId,
    String? eventId,
    UserMicrotaskStatus? status,
    DateTime? assignedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    double? actualHours,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserMicrotaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      microtaskId: microtaskId ?? this.microtaskId,
      eventId: eventId ?? this.eventId,
      status: status ?? this.status,
      assignedAt: assignedAt ?? this.assignedAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      actualHours: actualHours ?? this.actualHours,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Cria uma nova instância com updatedAt atualizado para agora
  UserMicrotaskModel withUpdatedTimestamp() {
    return copyWith(updatedAt: DateTime.now());
  }

  /// Factory para criar uma nova relação usuário-microtask
  /// Note: ID e timestamps devem ser definidos pelo service
  factory UserMicrotaskModel.create({
    required String id,
    required String userId,
    required String microtaskId,
    required String eventId,
    required DateTime assignedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    return UserMicrotaskModel(
      id: id,
      userId: userId,
      microtaskId: microtaskId,
      eventId: eventId,
      status: UserMicrotaskStatus.assigned,
      assignedAt: assignedAt,
      notes: '',
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Valida se os dados da relação são válidos
  List<String> validate() {
    final errors = <String>[];

    if (userId.isEmpty) {
      errors.add('ID do usuário é obrigatório');
    }

    if (microtaskId.isEmpty) {
      errors.add('ID da microtask é obrigatório');
    }

    if (eventId.isEmpty) {
      errors.add('ID do evento é obrigatório');
    }

    if (actualHours != null && actualHours! < 0) {
      errors.add('Horas trabalhadas não podem ser negativas');
    }

    if (startedAt != null && startedAt!.isBefore(assignedAt)) {
      errors.add('Data de início não pode ser anterior à data de atribuição');
    }

    if (completedAt != null &&
        startedAt != null &&
        completedAt!.isBefore(startedAt!)) {
      errors.add('Data de conclusão não pode ser anterior à data de início');
    }

    return errors;
  }

  /// Verifica se a relação é válida
  bool isValid() => validate().isEmpty;

  /// Verifica se o usuário completou a microtask
  bool get isCompleted => status == UserMicrotaskStatus.completed;

  /// Verifica se o usuário iniciou a microtask
  bool get isStarted => status == UserMicrotaskStatus.started;

  /// Verifica se o usuário foi apenas atribuído (não iniciou)
  bool get isAssigned => status == UserMicrotaskStatus.assigned;

  /// Verifica se foi cancelado
  bool get isCancelled => status == UserMicrotaskStatus.cancelled;

  /// Marca como iniciado
  UserMicrotaskModel markAsStarted() {
    if (status == UserMicrotaskStatus.assigned) {
      final now = DateTime.now();
      return copyWith(
        status: UserMicrotaskStatus.started,
        startedAt: now,
        updatedAt: now,
      );
    }
    return this;
  }

  /// Marca como concluído
  UserMicrotaskModel markAsCompleted({double? actualHours}) {
    final now = DateTime.now();
    return copyWith(
      status: UserMicrotaskStatus.completed,
      completedAt: now,
      actualHours: actualHours ?? this.actualHours,
      updatedAt: now,
    );
  }

  /// Marca como cancelado
  UserMicrotaskModel markAsCancelled() {
    final now = DateTime.now();
    return copyWith(status: UserMicrotaskStatus.cancelled, updatedAt: now);
  }

  /// Atualiza as notas
  UserMicrotaskModel updateNotes(String newNotes) {
    return copyWith(notes: newNotes, updatedAt: DateTime.now());
  }

  /// Atualiza as horas trabalhadas
  UserMicrotaskModel updateActualHours(double hours) {
    return copyWith(
      actualHours: hours >= 0 ? hours : 0,
      updatedAt: DateTime.now(),
    );
  }

  /// Calcula a duração do trabalho (se iniciado e concluído)
  Duration? get workDuration {
    if (startedAt != null && completedAt != null) {
      return completedAt!.difference(startedAt!);
    }
    return null;
  }

  /// Calcula a duração desde a atribuição até agora (se não concluído)
  Duration get durationSinceAssigned {
    final endTime = completedAt ?? DateTime.now();
    return endTime.difference(assignedAt);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserMicrotaskModel &&
        other.id == id &&
        other.userId == userId &&
        other.microtaskId == microtaskId &&
        other.eventId == eventId &&
        other.status == status;
  }

  @override
  int get hashCode {
    return Object.hash(id, userId, microtaskId, eventId, status);
  }

  @override
  String toString() {
    return 'UserMicrotaskModel(id: $id, userId: $userId, microtaskId: $microtaskId, status: $status)';
  }
}

```

### lib\data\models\user_model.dart

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de dados para representar um usuário no sistema
/// Baseado na estrutura definida no SPEC_GERAL.md
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Cria uma instância de UserModel a partir de um Map (JSON)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      photoUrl: map['photoUrl'] as String?,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Cria uma instância de UserModel a partir de um DocumentSnapshot do Firestore
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap({'id': doc.id, ...data});
  }

  /// Converte a instância para um Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Converte para Map sem o ID (usado para criar documentos no Firestore)
  Map<String, dynamic> toFirestore() {
    final map = toMap();
    map.remove('id'); // Remove o ID pois será gerado pelo Firestore
    return map;
  }

  /// Cria uma cópia da instância com alguns campos alterados
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Cria uma nova instância com updatedAt atualizado para agora
  UserModel withUpdatedTimestamp() {
    return copyWith(updatedAt: DateTime.now());
  }

  /// Valida se os dados do usuário são válidos
  bool isValid() {
    return id.isNotEmpty &&
        name.isNotEmpty &&
        email.isNotEmpty &&
        _isValidEmail(email);
  }

  /// Valida se o email tem formato válido
  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  /// Retorna as iniciais do nome do usuário
  String get initials {
    if (name.isEmpty) return '';

    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }

    return '${words[0][0]}${words[words.length - 1][0]}'.toUpperCase();
  }

  /// Retorna o primeiro nome do usuário
  String get firstName {
    if (name.isEmpty) return '';
    return name.split(' ')[0];
  }

  /// Retorna o nome completo formatado
  String get displayName {
    return name.trim();
  }

  /// Verifica se o usuário tem foto de perfil
  bool get hasPhoto {
    return photoUrl != null && photoUrl!.isNotEmpty;
  }

  /// Retorna a URL da foto ou null se não houver
  String? get profileImageUrl {
    return hasPhoto ? photoUrl : null;
  }

  /// Factory para criar um usuário a partir dos dados do Google Sign-In
  factory UserModel.fromGoogleSignIn({
    required String uid,
    required String name,
    required String email,
    String? photoUrl,
  }) {
    final now = DateTime.now();
    return UserModel(
      id: uid,
      name: name,
      email: email,
      photoUrl: photoUrl,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Factory para criar um usuário a partir do cadastro manual
  factory UserModel.fromRegistration({
    required String uid,
    required String name,
    required String email,
  }) {
    final now = DateTime.now();
    return UserModel(
      id: uid,
      name: name,
      email: email,
      photoUrl: null,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Converte para string para debug
  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, photoUrl: $photoUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  /// Implementa igualdade baseada no ID
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  /// Implementa hashCode baseado no ID
  @override
  int get hashCode => id.hashCode;

  /// Método para validar dados antes de salvar
  List<String> validate() {
    final errors = <String>[];

    if (id.isEmpty) {
      errors.add('ID é obrigatório');
    }

    if (name.isEmpty) {
      errors.add('Nome é obrigatório');
    } else if (name.length < 2) {
      errors.add('Nome deve ter pelo menos 2 caracteres');
    } else if (name.length > 50) {
      errors.add('Nome deve ter no máximo 50 caracteres');
    }

    if (email.isEmpty) {
      errors.add('E-mail é obrigatório');
    } else if (!_isValidEmail(email)) {
      errors.add('E-mail inválido');
    }

    if (photoUrl != null && photoUrl!.isNotEmpty) {
      final uri = Uri.tryParse(photoUrl!);
      if (uri == null || !uri.hasAbsolutePath) {
        errors.add('URL da foto inválida');
      }
    }

    return errors;
  }

  /// Verifica se o usuário foi criado recentemente (últimas 24 horas)
  bool get isNewUser {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inHours < 24;
  }

  /// Retorna há quanto tempo o usuário foi criado
  String get createdTimeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} dia${difference.inDays > 1 ? 's' : ''} atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''} atrás';
    } else {
      return 'Agora mesmo';
    }
  }

  /// Retorna há quanto tempo o usuário foi atualizado
  String get updatedTimeAgo {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} dia${difference.inDays > 1 ? 's' : ''} atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''} atrás';
    } else {
      return 'Agora mesmo';
    }
  }
}

```

### lib\data\models\volunteer_profile_model.dart

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de dados para representar o perfil de um voluntário em um evento
/// Baseado na estrutura definida no SPEC_GERAL.md
/// Inclui dados denormalizados do usuário para otimizar consultas
class VolunteerProfileModel {
  final String id;
  final String userId;
  final String eventId;
  final List<String> availableDays;
  final TimeRange availableHours;
  final bool
  isFullTimeAvailable; // Disponibilidade integral (sem restrições de data/hora)
  final List<String> skills;
  final List<String> resources;
  final int assignedMicrotasksCount; // Contador de microtasks atribuídas
  final DateTime joinedAt;

  // Dados denormalizados do usuário para otimização de consultas
  final String userName;
  final String userEmail;
  final String? userPhotoUrl;

  const VolunteerProfileModel({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.availableDays,
    required this.availableHours,
    required this.isFullTimeAvailable,
    required this.skills,
    required this.resources,
    required this.assignedMicrotasksCount,
    required this.joinedAt,
    required this.userName,
    required this.userEmail,
    this.userPhotoUrl,
  });

  /// Cria uma instância de VolunteerProfileModel a partir de um Map (JSON)
  factory VolunteerProfileModel.fromMap(Map<String, dynamic> map) {
    return VolunteerProfileModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      eventId: map['eventId'] as String,
      availableDays: List<String>.from(map['availableDays'] as List),
      availableHours: TimeRange.fromMap(
        map['availableHours'] as Map<String, dynamic>,
      ),
      isFullTimeAvailable: map['isFullTimeAvailable'] as bool? ?? false,
      skills: List<String>.from(map['skills'] as List),
      resources: List<String>.from(map['resources'] as List),
      assignedMicrotasksCount: map['assignedMicrotasksCount'] as int? ?? 0,
      joinedAt: (map['joinedAt'] as Timestamp).toDate(),
      userName: map['userName'] as String? ?? '',
      userEmail: map['userEmail'] as String? ?? '',
      userPhotoUrl: map['userPhotoUrl'] as String?,
    );
  }

  /// Cria uma instância de VolunteerProfileModel a partir de um DocumentSnapshot do Firestore
  factory VolunteerProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VolunteerProfileModel.fromMap({'id': doc.id, ...data});
  }

  /// Converte a instância para um Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'eventId': eventId,
      'availableDays': availableDays,
      'availableHours': availableHours.toMap(),
      'isFullTimeAvailable': isFullTimeAvailable,
      'skills': skills,
      'resources': resources,
      'assignedMicrotasksCount': assignedMicrotasksCount,
      'joinedAt': Timestamp.fromDate(joinedAt),
      'userName': userName,
      'userEmail': userEmail,
      'userPhotoUrl': userPhotoUrl,
    };
  }

  /// Converte para Map sem o ID (usado para criar documentos no Firestore)
  Map<String, dynamic> toFirestore() {
    final map = toMap();
    map.remove('id'); // Remove o ID pois será gerado pelo Firestore
    return map;
  }

  /// Cria uma cópia da instância com alguns campos alterados
  VolunteerProfileModel copyWith({
    String? id,
    String? userId,
    String? eventId,
    List<String>? availableDays,
    TimeRange? availableHours,
    bool? isFullTimeAvailable,
    List<String>? skills,
    List<String>? resources,
    int? assignedMicrotasksCount,
    DateTime? joinedAt,
    String? userName,
    String? userEmail,
    String? userPhotoUrl,
  }) {
    return VolunteerProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      eventId: eventId ?? this.eventId,
      availableDays: availableDays ?? List<String>.from(this.availableDays),
      availableHours: availableHours ?? this.availableHours,
      isFullTimeAvailable: isFullTimeAvailable ?? this.isFullTimeAvailable,
      skills: skills ?? List<String>.from(this.skills),
      resources: resources ?? List<String>.from(this.resources),
      assignedMicrotasksCount:
          assignedMicrotasksCount ?? this.assignedMicrotasksCount,
      joinedAt: joinedAt ?? this.joinedAt,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
    );
  }

  /// Verifica se o voluntário tem uma habilidade específica
  bool hasSkill(String skill) {
    return skills.contains(skill);
  }

  /// Verifica se o voluntário tem um recurso específico
  bool hasResource(String resource) {
    return resources.contains(resource);
  }

  /// Verifica se o voluntário está disponível em um dia específico
  bool isAvailableOnDay(String day) {
    return availableDays.contains(day);
  }

  /// Verifica se o voluntário está disponível em um horário específico
  bool isAvailableAtTime(String time) {
    return availableHours.contains(time);
  }

  /// Adiciona uma habilidade ao perfil
  VolunteerProfileModel addSkill(String skill) {
    if (skills.contains(skill)) return this;

    final newSkills = List<String>.from(skills)..add(skill);
    return copyWith(skills: newSkills);
  }

  /// Remove uma habilidade do perfil
  VolunteerProfileModel removeSkill(String skill) {
    if (!skills.contains(skill)) return this;

    final newSkills = List<String>.from(skills)..remove(skill);
    return copyWith(skills: newSkills);
  }

  /// Adiciona um recurso ao perfil
  VolunteerProfileModel addResource(String resource) {
    if (resources.contains(resource)) return this;

    final newResources = List<String>.from(resources)..add(resource);
    return copyWith(resources: newResources);
  }

  /// Remove um recurso do perfil
  VolunteerProfileModel removeResource(String resource) {
    if (!resources.contains(resource)) return this;

    final newResources = List<String>.from(resources)..remove(resource);
    return copyWith(resources: newResources);
  }

  /// Adiciona um dia de disponibilidade
  VolunteerProfileModel addAvailableDay(String day) {
    if (availableDays.contains(day)) return this;

    final newDays = List<String>.from(availableDays)..add(day);
    return copyWith(availableDays: newDays);
  }

  /// Remove um dia de disponibilidade
  VolunteerProfileModel removeAvailableDay(String day) {
    if (!availableDays.contains(day)) return this;

    final newDays = List<String>.from(availableDays)..remove(day);
    return copyWith(availableDays: newDays);
  }

  /// Atualiza o horário de disponibilidade
  VolunteerProfileModel updateAvailableHours(TimeRange newHours) {
    return copyWith(availableHours: newHours);
  }

  /// Verifica compatibilidade com habilidades necessárias
  bool isCompatibleWithSkills(List<String> requiredSkills) {
    if (requiredSkills.isEmpty) return true;
    return requiredSkills.any((skill) => skills.contains(skill));
  }

  /// Verifica compatibilidade com recursos necessários
  bool isCompatibleWithResources(List<String> requiredResources) {
    if (requiredResources.isEmpty) return true;
    return requiredResources.any((resource) => resources.contains(resource));
  }

  /// Verifica compatibilidade geral (habilidades E recursos)
  bool isCompatibleWith({
    List<String>? requiredSkills,
    List<String>? requiredResources,
  }) {
    final skillsMatch =
        requiredSkills == null ||
        requiredSkills.isEmpty ||
        isCompatibleWithSkills(requiredSkills);

    final resourcesMatch =
        requiredResources == null ||
        requiredResources.isEmpty ||
        isCompatibleWithResources(requiredResources);

    return skillsMatch && resourcesMatch;
  }

  /// Retorna as habilidades como string formatada
  String get skillsText {
    if (skills.isEmpty) return 'Nenhuma habilidade informada';
    return skills.join(', ');
  }

  /// Retorna os recursos como string formatada
  String get resourcesText {
    if (resources.isEmpty) return 'Nenhum recurso informado';
    return resources.join(', ');
  }

  /// Retorna os dias disponíveis como string formatada
  String get availableDaysText {
    if (availableDays.isEmpty) return 'Nenhum dia informado';

    final dayNames = {
      'monday': 'Segunda',
      'tuesday': 'Terça',
      'wednesday': 'Quarta',
      'thursday': 'Quinta',
      'friday': 'Sexta',
      'saturday': 'Sábado',
      'sunday': 'Domingo',
    };

    final translatedDays = availableDays
        .map((day) => dayNames[day] ?? day)
        .toList();

    return translatedDays.join(', ');
  }

  /// Retorna há quanto tempo o voluntário se juntou ao evento
  String get joinedTimeAgo {
    final now = DateTime.now();
    final difference = now.difference(joinedAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} dia${difference.inDays > 1 ? 's' : ''} atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''} atrás';
    } else {
      return 'Agora mesmo';
    }
  }

  /// Factory para criar um novo perfil de voluntário
  /// Note: ID e timestamp devem ser definidos pelo service
  factory VolunteerProfileModel.create({
    required String id,
    required String userId,
    required String eventId,
    required List<String> availableDays,
    required TimeRange availableHours,
    bool isFullTimeAvailable = false,
    required List<String> skills,
    required List<String> resources,
    int assignedMicrotasksCount = 0,
    required String userName,
    required String userEmail,
    String? userPhotoUrl,
    required DateTime joinedAt,
  }) {
    return VolunteerProfileModel(
      id: id,
      userId: userId,
      eventId: eventId,
      availableDays: availableDays,
      availableHours: availableHours,
      isFullTimeAvailable: isFullTimeAvailable,
      skills: skills,
      resources: resources,
      assignedMicrotasksCount: assignedMicrotasksCount,
      joinedAt: joinedAt,
      userName: userName,
      userEmail: userEmail,
      userPhotoUrl: userPhotoUrl,
    );
  }

  /// Factory para criar um perfil com dados do usuário (para compatibilidade)
  /// Note: ID e timestamp devem ser definidos pelo service
  factory VolunteerProfileModel.createWithUserData({
    required String id,
    required String userId,
    required String eventId,
    required List<String> availableDays,
    required TimeRange availableHours,
    bool isFullTimeAvailable = false,
    required List<String> skills,
    required List<String> resources,
    int assignedMicrotasksCount = 0,
    required String userName,
    required String userEmail,
    String? userPhotoUrl,
    required DateTime joinedAt,
  }) {
    return VolunteerProfileModel.create(
      id: id,
      userId: userId,
      eventId: eventId,
      availableDays: availableDays,
      availableHours: availableHours,
      isFullTimeAvailable: isFullTimeAvailable,
      skills: skills,
      resources: resources,
      assignedMicrotasksCount: assignedMicrotasksCount,
      userName: userName,
      userEmail: userEmail,
      userPhotoUrl: userPhotoUrl,
      joinedAt: joinedAt,
    );
  }

  /// Atualiza os dados do usuário no perfil
  VolunteerProfileModel updateUserData({
    required String userName,
    required String userEmail,
    String? userPhotoUrl,
  }) {
    return copyWith(
      userName: userName,
      userEmail: userEmail,
      userPhotoUrl: userPhotoUrl,
    );
  }

  /// Verifica se tem dados do usuário válidos
  bool get hasValidUserData {
    return userName.isNotEmpty && userEmail.isNotEmpty;
  }

  /// Retorna as iniciais do nome do usuário
  String get userInitials {
    if (userName.isEmpty) return '';

    final words = userName.trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }

    return '${words[0][0]}${words[words.length - 1][0]}'.toUpperCase();
  }

  /// Retorna o primeiro nome do usuário
  String get userFirstName {
    if (userName.isEmpty) return '';
    return userName.split(' ')[0];
  }

  /// Verifica se o usuário tem foto de perfil
  bool get hasUserPhoto {
    return userPhotoUrl != null && userPhotoUrl!.isNotEmpty;
  }

  /// Valida se os dados do perfil são válidos
  bool isValid() {
    return id.isNotEmpty &&
        userId.isNotEmpty &&
        eventId.isNotEmpty &&
        (isFullTimeAvailable ||
            (availableDays.isNotEmpty && availableHours.isValid()));
  }

  /// Método para validar dados antes de salvar
  List<String> validate() {
    final errors = <String>[];

    if (userId.isEmpty) {
      errors.add('ID do usuário é obrigatório');
    }

    if (eventId.isEmpty) {
      errors.add('ID do evento é obrigatório');
    }

    if (!isFullTimeAvailable) {
      if (availableDays.isEmpty) {
        errors.add('Pelo menos um dia de disponibilidade é obrigatório');
      }

      if (!availableHours.isValid()) {
        errors.add('Horário de disponibilidade inválido');
      }
    }

    return errors;
  }

  /// Retorna a disponibilidade como string formatada
  String get availabilityText {
    if (isFullTimeAvailable) {
      return 'Disponibilidade integral (qualquer horário)';
    }

    if (availableDays.isEmpty) return 'Disponibilidade não informada';

    return '$availableDaysText - ${availableHours.formatted}';
  }

  /// Verifica se o voluntário está disponível em um horário específico
  bool isAvailableAt(DateTime dateTime) {
    if (isFullTimeAvailable) return true;

    // Verifica o dia da semana
    final dayNames = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    final dayOfWeek = dayNames[dateTime.weekday - 1];

    if (!availableDays.contains(dayOfWeek)) return false;

    // Verifica o horário
    final timeString =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return availableHours.contains(timeString);
  }

  /// Verifica se o voluntário está disponível em um período
  bool isAvailableForPeriod(DateTime startDateTime, DateTime endDateTime) {
    if (isFullTimeAvailable) return true;

    // Para simplicidade, verifica apenas o horário de início
    // Em uma implementação mais robusta, verificaria todo o período
    return isAvailableAt(startDateTime);
  }

  /// Incrementa o contador de microtasks atribuídas
  VolunteerProfileModel incrementAssignedMicrotasks() {
    return copyWith(assignedMicrotasksCount: assignedMicrotasksCount + 1);
  }

  /// Decrementa o contador de microtasks atribuídas
  VolunteerProfileModel decrementAssignedMicrotasks() {
    return copyWith(
      assignedMicrotasksCount: assignedMicrotasksCount > 0
          ? assignedMicrotasksCount - 1
          : 0,
    );
  }

  /// Atualiza o contador de microtasks atribuídas
  VolunteerProfileModel updateAssignedMicrotasksCount(int count) {
    return copyWith(assignedMicrotasksCount: count >= 0 ? count : 0);
  }

  /// Verifica se o voluntário tem carga de trabalho baixa (menos de 3 microtasks)
  bool get hasLowWorkload => assignedMicrotasksCount < 3;

  /// Verifica se o voluntário tem carga de trabalho alta (5 ou mais microtasks)
  bool get hasHighWorkload => assignedMicrotasksCount >= 5;

  /// Retorna o nível de carga de trabalho como string
  String get workloadLevel {
    if (assignedMicrotasksCount == 0) return 'Sem tarefas';
    if (assignedMicrotasksCount < 3) return 'Carga baixa';
    if (assignedMicrotasksCount < 5) return 'Carga média';
    return 'Carga alta';
  }

  /// Converte para string para debug
  @override
  String toString() {
    return 'VolunteerProfileModel(id: $id, userId: $userId, eventId: $eventId, skills: ${skills.length}, resources: ${resources.length})';
  }

  /// Implementa igualdade baseada no ID
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VolunteerProfileModel && other.id == id;
  }

  /// Implementa hashCode baseado no ID
  @override
  int get hashCode => id.hashCode;
}

/// Classe para representar um intervalo de tempo
class TimeRange {
  final String start;
  final String end;

  const TimeRange({required this.start, required this.end});

  /// Cria uma instância de TimeRange a partir de um Map
  factory TimeRange.fromMap(Map<String, dynamic> map) {
    return TimeRange(start: map['start'] as String, end: map['end'] as String);
  }

  /// Converte a instância para um Map
  Map<String, dynamic> toMap() {
    return {'start': start, 'end': end};
  }

  /// Verifica se um horário está dentro do intervalo
  bool contains(String time) {
    // Implementação simplificada - pode ser melhorada
    return time.compareTo(start) >= 0 && time.compareTo(end) <= 0;
  }

  /// Verifica se o intervalo é válido
  bool isValid() {
    return start.isNotEmpty && end.isNotEmpty && start.compareTo(end) < 0;
  }

  /// Retorna o intervalo formatado
  String get formatted => '$start - $end';

  @override
  String toString() => formatted;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}

```

### lib\data\repositories\auth_repository.dart

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_constants.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Repositório responsável por gerenciar dados de autenticação
/// Combina Firebase Auth com Firestore para persistir dados do usuário
class AuthRepository {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Referência para a coleção de usuários no Firestore
  CollectionReference get _usersCollection => 
      _firestore.collection(AppConstants.usersCollection);

  /// Stream que monitora mudanças no estado de autenticação
  Stream<UserModel?> get authStateChanges {
    return _authService.authStateChanges.asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      
      try {
        // Busca os dados completos do usuário no Firestore
        final userDoc = await _usersCollection.doc(firebaseUser.uid).get();
        
        if (userDoc.exists) {
          return UserModel.fromFirestore(userDoc);
        } else {
          // Se não existe no Firestore, cria um novo registro
          final userModel = UserModel.fromGoogleSignIn(
            uid: firebaseUser.uid,
            name: firebaseUser.displayName ?? '',
            email: firebaseUser.email ?? '',
            photoUrl: firebaseUser.photoURL,
          );
          
          await _saveUserToFirestore(userModel);
          return userModel;
        }
      } catch (e) {
        // Em caso de erro, retorna dados básicos do Firebase Auth
        return _authService.firebaseUserToUserModel(firebaseUser);
      }
    });
  }

  /// Retorna o usuário atual
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = _authService.currentUser;
      if (firebaseUser == null) return null;

      final userDoc = await _usersCollection.doc(firebaseUser.uid).get();
      
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      }
      
      return null;
    } catch (e) {
      throw FirestoreException('Erro ao buscar usuário atual', originalException: e);
    }
  }

  /// Faz login com email e senha
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const AuthException('Erro ao obter dados do usuário após login');
      }

      // Busca ou cria o usuário no Firestore
      return await _getOrCreateUser(firebaseUser);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Erro durante login', originalException: e);
    }
  }

  /// Cria uma nova conta com email e senha
  Future<UserModel> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const AuthException('Erro ao obter dados do usuário após cadastro');
      }

      // Atualiza o nome no Firebase Auth
      await _authService.updateProfile(displayName: name);

      // Cria o modelo do usuário
      final userModel = UserModel.fromRegistration(
        uid: firebaseUser.uid,
        name: name,
        email: email,
      );

      // Salva no Firestore
      await _saveUserToFirestore(userModel);

      return userModel;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Erro durante cadastro', originalException: e);
    }
  }

  /// Faz login com Google
  Future<UserModel> signInWithGoogle() async {
    try {
      final credential = await _authService.signInWithGoogle();
      
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const AuthException('Erro ao obter dados do usuário após login com Google');
      }

      // Busca ou cria o usuário no Firestore
      return await _getOrCreateUser(firebaseUser);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Erro durante login com Google', originalException: e);
    }
  }

  /// Faz logout
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      throw AuthException('Erro durante logout', originalException: e);
    }
  }

  /// Envia email de redefinição de senha
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Erro ao enviar email de redefinição', originalException: e);
    }
  }

  /// Atualiza os dados do usuário
  Future<UserModel> updateUser(UserModel user) async {
    try {
      final updatedUser = user.withUpdatedTimestamp();
      
      // Atualiza no Firestore
      await _usersCollection.doc(user.id).update(updatedUser.toFirestore());
      
      // Atualiza no Firebase Auth se necessário
      final currentFirebaseUser = _authService.currentUser;
      if (currentFirebaseUser != null) {
        if (currentFirebaseUser.displayName != user.name) {
          await _authService.updateProfile(
            displayName: user.name,
            photoURL: user.photoUrl,
          );
        }
      }

      return updatedUser;
    } catch (e) {
      throw FirestoreException('Erro ao atualizar usuário', originalException: e);
    }
  }

  /// Deleta a conta do usuário
  Future<void> deleteAccount() async {
    try {
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        throw const AuthException('Usuário não está logado');
      }

      // Remove do Firestore
      await _usersCollection.doc(currentUser.uid).delete();
      
      // Remove do Firebase Auth
      await _authService.deleteAccount();
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Erro ao deletar conta', originalException: e);
    }
  }

  /// Busca um usuário por ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final userDoc = await _usersCollection.doc(userId).get();
      
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      }
      
      return null;
    } catch (e) {
      throw FirestoreException('Erro ao buscar usuário por ID', originalException: e);
    }
  }

  /// Busca um usuário por email
  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final querySnapshot = await _usersCollection
          .where('email', isEqualTo: email.trim().toLowerCase())
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        return UserModel.fromFirestore(querySnapshot.docs.first);
      }
      
      return null;
    } catch (e) {
      throw FirestoreException('Erro ao buscar usuário por email', originalException: e);
    }
  }

  /// Verifica se um email já está em uso
  Future<bool> isEmailInUse(String email) async {
    try {
      final user = await getUserByEmail(email);
      return user != null;
    } catch (e) {
      throw FirestoreException('Erro ao verificar email', originalException: e);
    }
  }

  /// Busca ou cria um usuário no Firestore baseado no Firebase User
  Future<UserModel> _getOrCreateUser(User firebaseUser) async {
    try {
      final userDoc = await _usersCollection.doc(firebaseUser.uid).get();
      
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      } else {
        // Cria um novo usuário no Firestore
        final userModel = UserModel.fromGoogleSignIn(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          photoUrl: firebaseUser.photoURL,
        );
        
        await _saveUserToFirestore(userModel);
        return userModel;
      }
    } catch (e) {
      throw FirestoreException('Erro ao buscar ou criar usuário', originalException: e);
    }
  }

  /// Salva um usuário no Firestore
  Future<void> _saveUserToFirestore(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).set(user.toFirestore());
    } catch (e) {
      throw FirestoreException('Erro ao salvar usuário no Firestore', originalException: e);
    }
  }

  /// Verifica se há um usuário logado
  bool get isLoggedIn => _authService.isLoggedIn;

  /// Retorna o ID do usuário atual
  String? get currentUserId => _authService.currentUserId;

  /// Envia email de verificação
  Future<void> sendEmailVerification() async {
    try {
      await _authService.sendEmailVerification();
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Erro ao enviar verificação de email', originalException: e);
    }
  }

  /// Verifica se o email está verificado
  bool get isEmailVerified => _authService.isEmailVerified;
}

```

### lib\data\repositories\event_repository.dart

```dart
import '../models/event_model.dart';
import '../models/volunteer_profile_model.dart';
import '../services/event_service.dart';
import '../repositories/user_repository.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Repositório responsável por gerenciar dados de eventos
/// Atua como uma camada de abstração entre os controllers e os services
class EventRepository {
  final EventService _eventService;
  final UserRepository _userRepository;

  EventRepository({EventService? eventService, UserRepository? userRepository})
    : _eventService = eventService ?? EventService(),
      _userRepository = userRepository ?? UserRepository();

  /// Cria um novo evento
  Future<EventModel> createEvent({
    required String name,
    required String description,
    required String location,
    required String createdBy,
    required List<String> requiredSkills,
    required List<String> requiredResources,
  }) async {
    try {
      // Create a temporary event for validation
      final tempEvent = EventModel.create(
        id: 'temp', // Temporary ID for validation
        name: name.trim(),
        description: description.trim(),
        tag: 'temp', // Temporary tag for validation
        location: location.trim(),
        createdBy: createdBy,
        requiredSkills: requiredSkills,
        requiredResources: requiredResources,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Validate before calling service
      final validationErrors = tempEvent.validate();
      if (validationErrors.isNotEmpty) {
        throw ValidationException(
          'Dados inválidos: ${validationErrors.join(', ')}',
        );
      }

      // Repository delegates to service for creation with ID/tag generation
      return await _eventService.createEvent(
        name: name.trim(),
        description: description.trim(),
        location: location.trim(),
        createdBy: createdBy,
        requiredSkills: requiredSkills,
        requiredResources: requiredResources,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao criar evento: ${e.toString()}');
    }
  }

  /// Busca um evento por ID
  Future<EventModel?> getEventById(String eventId) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      return await _eventService.getEventById(eventId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar evento: ${e.toString()}');
    }
  }

  /// Busca um evento por tag/código
  Future<EventModel?> getEventByTag(String tag) async {
    try {
      if (tag.isEmpty) {
        throw ValidationException('Tag do evento é obrigatória');
      }

      // Normaliza a tag (maiúscula, sem espaços)
      final normalizedTag = tag.trim().toUpperCase();

      if (normalizedTag.length != 6) {
        throw ValidationException('Tag deve ter exatamente 6 caracteres');
      }

      return await _eventService.getEventByTag(normalizedTag);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar evento por tag: ${e.toString()}',
      );
    }
  }

  /// Busca todos os eventos do usuário
  Future<List<EventModel>> getUserEvents(String userId) async {
    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }

      return await _eventService.getUserEvents(userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar eventos do usuário: ${e.toString()}',
      );
    }
  }

  /// Atualiza um evento
  Future<EventModel> updateEvent(EventModel event) async {
    try {
      return await _eventService.updateEvent(event);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao atualizar evento: ${e.toString()}');
    }
  }

  /// Adiciona um voluntário ao evento
  Future<EventModel> joinEvent({
    required String eventId,
    required String userId,
    required List<String> availableDays,
    required TimeRange availableHours,
    bool isFullTimeAvailable = false,
    required List<String> skills,
    required List<String> resources,
  }) async {
    try {
      // Basic parameter validation (detailed validation should be in models/controllers)
      if (eventId.isEmpty || userId.isEmpty) {
        throw ValidationException('IDs do evento e usuário são obrigatórios');
      }

      // Adiciona o voluntário ao evento
      final updatedEvent = await _eventService.addVolunteerToEvent(
        eventId,
        userId,
      );

      // Busca dados do usuário para denormalização
      final userData = await _userRepository.getUserById(userId);
      if (userData == null) {
        throw NotFoundException('Usuário não encontrado');
      }

      // Cria o perfil do voluntário delegando ao service
      await _eventService.createVolunteerProfile(
        userId: userId,
        eventId: eventId,
        availableDays: availableDays,
        availableHours: availableHours,
        isFullTimeAvailable: isFullTimeAvailable,
        skills: skills,
        resources: resources,
        userName: userData.name,
        userEmail: userData.email,
        userPhotoUrl: userData.photoUrl,
      );

      return updatedEvent;
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao participar do evento: ${e.toString()}',
      );
    }
  }

  /// Remove um voluntário do evento
  Future<EventModel> leaveEvent(String eventId, String userId) async {
    try {
      if (eventId.isEmpty || userId.isEmpty) {
        throw ValidationException('IDs do evento e usuário são obrigatórios');
      }

      // Remove o voluntário do evento
      final updatedEvent = await _eventService.removeVolunteerFromEvent(
        eventId,
        userId,
      );

      // Remove o perfil do voluntário (se existir)
      final profile = await _eventService.getVolunteerProfile(userId, eventId);
      if (profile != null) {
        // Aqui seria necessário um método para deletar o perfil
        // Por enquanto, deixamos como está
      }

      return updatedEvent;
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao sair do evento: ${e.toString()}');
    }
  }

  /// Promove um voluntário a gerenciador
  Future<EventModel> promoteVolunteer(
    String eventId,
    String userId,
    String managerId,
  ) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }
      if (managerId.isEmpty) {
        throw ValidationException('ID do gerenciador é obrigatório');
      }

      // Verifica se quem está promovendo é gerenciador
      final event = await getEventById(eventId);
      if (event == null) {
        throw NotFoundException('Evento não encontrado');
      }

      if (!event.isManager(managerId)) {
        throw UnauthorizedException(
          'Apenas gerenciadores podem promover voluntários',
        );
      }

      return await _eventService.promoteVolunteerToManager(eventId, userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao promover voluntário: ${e.toString()}');
    }
  }

  /// Busca o perfil de um voluntário em um evento
  Future<VolunteerProfileModel?> getVolunteerProfile(
    String userId,
    String eventId,
  ) async {
    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      return await _eventService.getVolunteerProfile(userId, eventId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar perfil de voluntário: ${e.toString()}',
      );
    }
  }

  /// Busca todos os perfis de voluntários de um evento
  Future<List<VolunteerProfileModel>> getEventVolunteers(String eventId) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      return await _eventService.getEventVolunteerProfiles(eventId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar voluntários do evento: ${e.toString()}',
      );
    }
  }

  /// Incrementa o contador de microtasks atribuídas para um voluntário
  Future<void> incrementVolunteerMicrotaskCount(
    String eventId,
    String userId,
  ) async {
    try {
      await _eventService.incrementVolunteerMicrotaskCount(eventId, userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao incrementar contador de microtasks: ${e.toString()}',
      );
    }
  }

  /// Decrementa o contador de microtasks atribuídas para um voluntário
  Future<void> decrementVolunteerMicrotaskCount(
    String eventId,
    String userId,
  ) async {
    try {
      await _eventService.decrementVolunteerMicrotaskCount(eventId, userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao decrementar contador de microtasks: ${e.toString()}',
      );
    }
  }

  /// Atualiza o perfil de um voluntário
  Future<VolunteerProfileModel> updateVolunteerProfile(
    VolunteerProfileModel profile,
  ) async {
    try {
      return await _eventService.updateVolunteerProfile(profile);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao atualizar perfil de voluntário: ${e.toString()}',
      );
    }
  }

  /// Deleta um evento
  Future<void> deleteEvent(String eventId, String userId) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }

      await _eventService.deleteEvent(eventId, userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao deletar evento: ${e.toString()}');
    }
  }

  /// Verifica se um usuário pode gerenciar um evento
  Future<bool> canManageEvent(String eventId, String userId) async {
    try {
      final event = await getEventById(eventId);
      if (event == null) return false;

      return event.isManager(userId);
    } catch (e) {
      return false;
    }
  }

  /// Verifica se um usuário é participante de um evento
  Future<bool> isParticipant(String eventId, String userId) async {
    try {
      final event = await getEventById(eventId);
      if (event == null) return false;

      return event.isParticipant(userId);
    } catch (e) {
      return false;
    }
  }

  /// Stream para escutar mudanças em um evento
  Stream<EventModel?> watchEvent(String eventId) {
    return _eventService.watchEvent(eventId);
  }

  /// Stream para escutar mudanças nos eventos do usuário
  Stream<List<EventModel>> watchUserEvents(String userId) {
    return _eventService.watchUserEvents(userId);
  }

  /// Busca eventos compatíveis com as habilidades de um voluntário
  Future<List<EventModel>> getCompatibleEvents(String userId) async {
    try {
      // Por enquanto, retorna todos os eventos do usuário
      // Pode ser expandido para incluir lógica de compatibilidade
      return await getUserEvents(userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar eventos compatíveis: ${e.toString()}',
      );
    }
  }

  /// Valida se uma tag de evento é válida
  bool isValidTag(String tag) {
    if (tag.isEmpty) return false;
    if (tag.length != 6) return false;

    // Verifica se contém apenas letras e números
    final regex = RegExp(r'^[A-Z0-9]+$');
    return regex.hasMatch(tag.toUpperCase());
  }

  /// Normaliza uma tag de evento
  String normalizeTag(String tag) {
    return tag.trim().toUpperCase();
  }

  /// Migra perfis de voluntários existentes para incluir o campo assignedMicrotasksCount
  Future<void> migrateVolunteerProfilesTaskCounts() async {
    try {
      await _eventService.migrateVolunteerProfilesTaskCounts();
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao migrar perfis de voluntários: ${e.toString()}',
      );
    }
  }

  /// Recalcula e corrige o contador de microtasks para um voluntário específico
  Future<void> recalculateVolunteerMicrotaskCount(
    String eventId,
    String userId,
  ) async {
    try {
      await _eventService.recalculateVolunteerMicrotaskCount(eventId, userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao recalcular contador de microtasks: ${e.toString()}',
      );
    }
  }

  /// Recalcula os contadores para todos os voluntários de um evento
  Future<void> recalculateEventVolunteerCounts(String eventId) async {
    try {
      await _eventService.recalculateEventVolunteerCounts(eventId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao recalcular contadores do evento: ${e.toString()}',
      );
    }
  }

  /// Atualiza dados do usuário em todos os perfis de voluntário
  Future<void> updateUserDataInVolunteerProfiles(
    String userId,
    String userName,
    String userEmail,
    String? userPhotoUrl,
  ) async {
    try {
      await _eventService.updateUserDataInVolunteerProfiles(
        userId,
        userName,
        userEmail,
        userPhotoUrl,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao atualizar dados do usuário nos perfis: ${e.toString()}',
      );
    }
  }
}

```

### lib\data\repositories\microtask_repository.dart

```dart
import '../models/microtask_model.dart';
import '../models/user_microtask_model.dart';
import '../models/volunteer_profile_model.dart';
import '../services/microtask_service.dart';
import '../services/assignment_service.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Repositório responsável por gerenciar dados de microtasks
/// Atua como uma camada de abstração entre os controllers e os services
class MicrotaskRepository {
  final MicrotaskService _microtaskService;
  final AssignmentService _assignmentService;

  MicrotaskRepository({
    MicrotaskService? microtaskService,
    AssignmentService? assignmentService,
  }) : _microtaskService = microtaskService ?? MicrotaskService(),
       _assignmentService = assignmentService ?? AssignmentService();

  /// Cria uma nova microtask
  Future<MicrotaskModel> createMicrotask({
    required String taskId,
    required String eventId,
    required String title,
    required String description,
    required List<String> requiredSkills,
    required List<String> requiredResources,
    DateTime? startDateTime,
    DateTime? endDateTime,
    required String priority,
    required int maxVolunteers,
    required String createdBy,
    String? notes,
  }) async {
    try {
      // Create a temporary microtask for validation
      final tempMicrotask = MicrotaskModel.create(
        id: 'temp', // Temporary ID for validation
        taskId: taskId,
        eventId: eventId,
        title: title.trim(),
        description: description.trim(),
        requiredSkills: requiredSkills,
        requiredResources: requiredResources,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        priority: priority,
        maxVolunteers: maxVolunteers,
        createdBy: createdBy,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        notes: notes?.trim(),
      );

      // Validate before calling service
      final validationErrors = tempMicrotask.validate();
      if (validationErrors.isNotEmpty) {
        throw ValidationException(
          'Dados inválidos: ${validationErrors.join(', ')}',
        );
      }

      // Repository delegates to service for creation with ID/timestamp generation
      return await _microtaskService.createMicrotask(
        taskId: taskId,
        eventId: eventId,
        title: title.trim(),
        description: description.trim(),
        requiredSkills: requiredSkills,
        requiredResources: requiredResources,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        priority: priority,
        maxVolunteers: maxVolunteers,
        createdBy: createdBy,
        notes: notes?.trim(),
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao criar microtask: ${e.toString()}');
    }
  }

  /// Busca uma microtask por ID
  Future<MicrotaskModel?> getMicrotaskById(String microtaskId) async {
    try {
      if (microtaskId.isEmpty) {
        throw ValidationException('ID da microtask é obrigatório');
      }

      return await _microtaskService.getMicrotaskById(microtaskId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar microtask: ${e.toString()}');
    }
  }

  /// Busca todas as microtasks de uma task
  Future<List<MicrotaskModel>> getMicrotasksByTaskId(String taskId) async {
    try {
      if (taskId.isEmpty) {
        throw ValidationException('ID da task é obrigatório');
      }

      return await _microtaskService.getMicrotasksByTaskId(taskId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar microtasks da task: ${e.toString()}',
      );
    }
  }

  /// Busca todas as microtasks de um evento
  Future<List<MicrotaskModel>> getMicrotasksByEventId(String eventId) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      return await _microtaskService.getMicrotasksByEventId(eventId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar microtasks do evento: ${e.toString()}',
      );
    }
  }

  /// Busca microtasks atribuídas a um usuário específico
  Future<List<MicrotaskModel>> getMicrotasksByUserId(String userId) async {
    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }

      return await _microtaskService.getMicrotasksByUserId(userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar microtasks do usuário: ${e.toString()}',
      );
    }
  }

  /// Busca microtasks por status
  Future<List<MicrotaskModel>> getMicrotasksByStatus(
    String eventId,
    MicrotaskStatus status,
  ) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      return await _microtaskService.getMicrotasksByStatus(eventId, status);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar microtasks por status: ${e.toString()}',
      );
    }
  }

  /// Atualiza uma microtask
  Future<MicrotaskModel> updateMicrotask(MicrotaskModel microtask) async {
    try {
      if (microtask.id.isEmpty) {
        throw ValidationException(
          'ID da microtask é obrigatório para atualização',
        );
      }

      return await _microtaskService.updateMicrotask(microtask);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao atualizar microtask: ${e.toString()}');
    }
  }

  /// Atribui um voluntário a uma microtask
  Future<MicrotaskModel> assignVolunteer({
    required String microtaskId,
    required String userId,
    required String eventId,
  }) async {
    try {
      if (microtaskId.isEmpty || userId.isEmpty || eventId.isEmpty) {
        throw ValidationException(
          'IDs da microtask, usuário e evento são obrigatórios',
        );
      }

      print("ABACAXI4: assinando microtask");
      return await _assignmentService.assignVolunteerToMicrotask(
        microtaskId: microtaskId,
        userId: userId,
        eventId: eventId,
      );
    } catch (e) {
      print("ABACAX_A3: assinando microtask$e");
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao atribuir voluntário: ${e.toString()}');
    }
  }

  /// Remove um voluntário de uma microtask
  Future<MicrotaskModel> unassignVolunteer({
    required String microtaskId,
    required String userId,
  }) async {
    try {
      if (microtaskId.isEmpty) {
        throw ValidationException('ID da microtask é obrigatório');
      }
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }

      return await _assignmentService.unassignVolunteerFromMicrotask(
        microtaskId: microtaskId,
        userId: userId,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao remover voluntário: ${e.toString()}');
    }
  }

  /// Busca voluntários compatíveis com uma microtask
  Future<List<VolunteerProfileModel>> getCompatibleVolunteers({
    required String eventId,
    required String microtaskId,
  }) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }
      if (microtaskId.isEmpty) {
        throw ValidationException('ID da microtask é obrigatório');
      }

      return await _assignmentService.getCompatibleVolunteers(
        eventId: eventId,
        microtaskId: microtaskId,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar voluntários compatíveis: ${e.toString()}',
      );
    }
  }

  /// Busca microtasks disponíveis para um voluntário
  Future<List<MicrotaskModel>> getAvailableMicrotasksForVolunteer({
    required String eventId,
    required String userId,
  }) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }

      return await _assignmentService.getAvailableMicrotasksForVolunteer(
        eventId: eventId,
        userId: userId,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar microtasks disponíveis: ${e.toString()}',
      );
    }
  }

  /// Atualiza o status de uma microtask
  Future<MicrotaskModel> updateMicrotaskStatus(
    String microtaskId,
    MicrotaskStatus status,
  ) async {
    try {
      if (microtaskId.isEmpty) {
        throw ValidationException('ID da microtask é obrigatório');
      }

      return await _microtaskService.updateMicrotaskStatus(microtaskId, status);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao atualizar status da microtask: ${e.toString()}',
      );
    }
  }

  /// Busca o status individual de um usuário em uma microtask
  Future<UserMicrotaskModel?> getUserMicrotaskStatus({
    required String userId,
    required String microtaskId,
  }) async {
    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }
      if (microtaskId.isEmpty) {
        throw ValidationException('ID da microtask é obrigatório');
      }

      return await _assignmentService.getUserMicrotaskStatus(
        userId: userId,
        microtaskId: microtaskId,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar status do usuário: ${e.toString()}',
      );
    }
  }

  /// Atualiza o status individual de um usuário em uma microtask
  Future<UserMicrotaskModel> updateUserMicrotaskStatus({
    required String userId,
    required String microtaskId,
    required UserMicrotaskStatus status,
    double? actualHours,
    String? notes,
  }) async {
    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }
      if (microtaskId.isEmpty) {
        throw ValidationException('ID da microtask é obrigatório');
      }

      return await _assignmentService.updateUserMicrotaskStatus(
        userId: userId,
        microtaskId: microtaskId,
        status: status,
        actualHours: actualHours,
        notes: notes,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao atualizar status do usuário: ${e.toString()}',
      );
    }
  }

  /// Busca todas as relações usuário-microtask de uma microtask
  Future<List<UserMicrotaskModel>> getUserMicrotasksByMicrotaskId(
    String microtaskId,
  ) async {
    try {
      if (microtaskId.isEmpty) {
        throw ValidationException('ID da microtask é obrigatório');
      }

      return await _assignmentService.getUserMicrotasksByMicrotaskId(
        microtaskId,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar relações usuário-microtask: ${e.toString()}',
      );
    }
  }

  /// Busca todas as microtasks de um usuário com seus status
  Future<List<UserMicrotaskModel>> getUserMicrotasksByUserId(
    String userId,
  ) async {
    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }

      return await _assignmentService.getUserMicrotasksByUserId(userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar microtasks do usuário: ${e.toString()}',
      );
    }
  }

  /// Deleta uma microtask
  Future<void> deleteMicrotask(String microtaskId) async {
    try {
      if (microtaskId.isEmpty) {
        throw ValidationException('ID da microtask é obrigatório');
      }

      await _microtaskService.deleteMicrotask(microtaskId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao deletar microtask: ${e.toString()}');
    }
  }

  /// Deleta todas as microtasks de uma task
  Future<void> deleteMicrotasksByTaskId(String taskId) async {
    try {
      if (taskId.isEmpty) {
        throw ValidationException('ID da task é obrigatório');
      }

      await _microtaskService.deleteMicrotasksByTaskId(taskId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao deletar microtasks da task: ${e.toString()}',
      );
    }
  }

  /// Stream para escutar mudanças em uma microtask
  Stream<MicrotaskModel?> watchMicrotask(String microtaskId) {
    if (microtaskId.isEmpty) {
      throw ValidationException('ID da microtask é obrigatório');
    }

    return _microtaskService.watchMicrotask(microtaskId);
  }

  /// Stream para escutar mudanças nas microtasks de uma task
  Stream<List<MicrotaskModel>> watchMicrotasksByTaskId(String taskId) {
    if (taskId.isEmpty) {
      throw ValidationException('ID da task é obrigatório');
    }

    return _microtaskService.watchMicrotasksByTaskId(taskId);
  }

  /// Stream para escutar mudanças nas microtasks de um evento
  Stream<List<MicrotaskModel>> watchMicrotasksByEventId(String eventId) {
    if (eventId.isEmpty) {
      throw ValidationException('ID do evento é obrigatório');
    }

    return _microtaskService.watchMicrotasksByEventId(eventId);
  }

  /// Valida se os dados de uma microtask são válidos
  bool validateMicrotaskData({
    required String title,
    required String description,
    required String taskId,
    required String eventId,
    required String createdBy,
    required int maxVolunteers,
    DateTime? startDateTime,
    DateTime? endDateTime,
  }) {
    if (title.trim().isEmpty) return false;
    if (title.trim().length < 3) return false;
    if (title.trim().length > 100) return false;
    if (description.trim().isEmpty) return false;
    if (description.trim().length > 1000) return false;
    if (taskId.isEmpty) return false;
    if (eventId.isEmpty) return false;
    if (createdBy.isEmpty) return false;
    if (maxVolunteers <= 0) return false;

    // Validação de data/hora (opcional, mas se fornecida deve ser válida)
    if (startDateTime != null && endDateTime != null) {
      if (startDateTime.isAfter(endDateTime)) return false;
    }

    return true;
  }
}

```

### lib\data\repositories\task_repository.dart

```dart
import '../models/task_model.dart';
import '../services/task_service.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Repositório responsável por gerenciar dados de tasks
/// Atua como uma camada de abstração entre os controllers e os services
class TaskRepository {
  final TaskService _taskService;

  TaskRepository({TaskService? taskService})
    : _taskService = taskService ?? TaskService();

  /// Cria uma nova task
  Future<TaskModel> createTask({
    required String eventId,
    required String title,
    required String description,
    required TaskPriority priority,
    required String createdBy,
  }) async {
    try {
      // Create a temporary task for validation
      final tempTask = TaskModel.create(
        id: 'temp', // Temporary ID for validation
        eventId: eventId,
        title: title.trim(),
        description: description.trim(),
        priority: priority,
        createdBy: createdBy,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Validate before calling service
      final validationErrors = tempTask.validate();
      if (validationErrors.isNotEmpty) {
        throw ValidationException(
          'Dados inválidos: ${validationErrors.join(', ')}',
        );
      }

      // Repository delegates to service for creation with ID/timestamp generation
      return await _taskService.createTask(
        eventId: eventId,
        title: title.trim(),
        description: description.trim(),
        priority: priority,
        createdBy: createdBy,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao criar task: ${e.toString()}');
    }
  }

  /// Busca uma task por ID
  Future<TaskModel?> getTaskById(String taskId) async {
    try {
      if (taskId.isEmpty) {
        throw ValidationException('ID da task é obrigatório');
      }

      return await _taskService.getTaskById(taskId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar task: ${e.toString()}');
    }
  }

  /// Busca todas as tasks de um evento
  Future<List<TaskModel>> getTasksByEventId(String eventId) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      return await _taskService.getTasksByEventId(eventId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar tasks do evento: ${e.toString()}',
      );
    }
  }

  /// Busca tasks criadas por um usuário específico
  Future<List<TaskModel>> getTasksByCreator(String userId) async {
    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }

      return await _taskService.getTasksByCreator(userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar tasks do usuário: ${e.toString()}',
      );
    }
  }

  /// Busca tasks por status
  Future<List<TaskModel>> getTasksByStatus(
    String eventId,
    TaskStatus status,
  ) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      return await _taskService.getTasksByStatus(eventId, status);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar tasks por status: ${e.toString()}',
      );
    }
  }

  /// Busca tasks por prioridade
  Future<List<TaskModel>> getTasksByPriority(
    String eventId,
    TaskPriority priority,
  ) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      return await _taskService.getTasksByPriority(eventId, priority);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar tasks por prioridade: ${e.toString()}',
      );
    }
  }

  /// Atualiza uma task
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      if (task.id.isEmpty) {
        throw ValidationException('ID da task é obrigatório para atualização');
      }

      return await _taskService.updateTask(task);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao atualizar task: ${e.toString()}');
    }
  }

  /// Atualiza o status de uma task
  Future<TaskModel> updateTaskStatus(String taskId, TaskStatus status) async {
    try {
      if (taskId.isEmpty) {
        throw ValidationException('ID da task é obrigatório');
      }

      return await _taskService.updateTaskStatus(taskId, status);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao atualizar status da task: ${e.toString()}',
      );
    }
  }

  /// Atualiza os contadores de microtasks
  Future<TaskModel> updateMicrotaskCounters({
    required String taskId,
    required int microtaskCount,
    required int completedMicrotasks,
  }) async {
    try {
      if (taskId.isEmpty) {
        throw ValidationException('ID da task é obrigatório');
      }

      if (microtaskCount < 0) {
        throw ValidationException('Número de microtasks não pode ser negativo');
      }

      if (completedMicrotasks < 0) {
        throw ValidationException(
          'Número de microtasks concluídas não pode ser negativo',
        );
      }

      if (completedMicrotasks > microtaskCount) {
        throw ValidationException(
          'Número de microtasks concluídas não pode ser maior que o total',
        );
      }

      return await _taskService.updateMicrotaskCounters(
        taskId: taskId,
        microtaskCount: microtaskCount,
        completedMicrotasks: completedMicrotasks,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao atualizar contadores da task: ${e.toString()}',
      );
    }
  }

  /// Incrementa o contador de microtasks
  Future<TaskModel> incrementMicrotaskCount(String taskId) async {
    try {
      if (taskId.isEmpty) {
        throw ValidationException('ID da task é obrigatório');
      }

      return await _taskService.incrementMicrotaskCount(taskId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao incrementar contador de microtasks: ${e.toString()}',
      );
    }
  }

  /// Decrementa o contador de microtasks
  Future<TaskModel> decrementMicrotaskCount(String taskId) async {
    try {
      if (taskId.isEmpty) {
        throw ValidationException('ID da task é obrigatório');
      }

      return await _taskService.decrementMicrotaskCount(taskId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao decrementar contador de microtasks: ${e.toString()}',
      );
    }
  }

  /// Incrementa o contador de microtasks concluídas
  Future<TaskModel> incrementCompletedMicrotasks(String taskId) async {
    try {
      if (taskId.isEmpty) {
        throw ValidationException('ID da task é obrigatório');
      }

      return await _taskService.incrementCompletedMicrotasks(taskId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao incrementar microtasks concluídas: ${e.toString()}',
      );
    }
  }

  /// Decrementa o contador de microtasks concluídas
  Future<TaskModel> decrementCompletedMicrotasks(String taskId) async {
    try {
      if (taskId.isEmpty) {
        throw ValidationException('ID da task é obrigatório');
      }

      return await _taskService.decrementCompletedMicrotasks(taskId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao decrementar microtasks concluídas: ${e.toString()}',
      );
    }
  }

  /// Deleta uma task
  Future<void> deleteTask(String taskId) async {
    try {
      if (taskId.isEmpty) {
        throw ValidationException('ID da task é obrigatório');
      }

      await _taskService.deleteTask(taskId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao deletar task: ${e.toString()}');
    }
  }

  /// Deleta todas as tasks de um evento
  Future<void> deleteTasksByEventId(String eventId) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      await _taskService.deleteTasksByEventId(eventId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao deletar tasks do evento: ${e.toString()}',
      );
    }
  }

  /// Stream para escutar mudanças em uma task
  Stream<TaskModel?> watchTask(String taskId) {
    if (taskId.isEmpty) {
      throw ValidationException('ID da task é obrigatório');
    }

    return _taskService.watchTask(taskId);
  }

  /// Stream para escutar mudanças nas tasks de um evento
  Stream<List<TaskModel>> watchTasksByEventId(String eventId) {
    if (eventId.isEmpty) {
      throw ValidationException('ID do evento é obrigatório');
    }

    return _taskService.watchTasksByEventId(eventId);
  }

  /// Busca tasks com filtros múltiplos
  Future<List<TaskModel>> getTasksWithFilters({
    required String eventId,
    TaskStatus? status,
    TaskPriority? priority,
    String? createdBy,
  }) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      return await _taskService.getTasksWithFilters(
        eventId: eventId,
        status: status,
        priority: priority,
        createdBy: createdBy,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar tasks com filtros: ${e.toString()}',
      );
    }
  }

  /// Valida se os dados de uma task são válidos
  bool validateTaskData({
    required String title,
    required String description,
    required String eventId,
    required String createdBy,
  }) {
    if (title.trim().isEmpty) return false;
    if (title.trim().length < 3) return false;
    if (title.trim().length > 100) return false;
    if (description.trim().isEmpty) return false;
    if (description.trim().length > 500) return false;
    if (eventId.isEmpty) return false;
    if (createdBy.isEmpty) return false;

    return true;
  }

  /// Calcula estatísticas das tasks de um evento
  Future<Map<String, dynamic>> getTaskStatistics(String eventId) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      final tasks = await getTasksByEventId(eventId);

      final stats = <String, dynamic>{
        'total': tasks.length,
        'pending': tasks.where((t) => t.isPending).length,
        'inProgress': tasks.where((t) => t.isInProgress).length,
        'completed': tasks.where((t) => t.isCompleted).length,
        'cancelled': tasks.where((t) => t.isCancelled).length,
        'highPriority': tasks
            .where((t) => t.priority == TaskPriority.high)
            .length,
        'mediumPriority': tasks
            .where((t) => t.priority == TaskPriority.medium)
            .length,
        'lowPriority': tasks
            .where((t) => t.priority == TaskPriority.low)
            .length,
        'totalMicrotasks': tasks.fold<int>(
          0,
          (sum, task) => sum + task.microtaskCount,
        ),
        'completedMicrotasks': tasks.fold<int>(
          0,
          (sum, task) => sum + task.completedMicrotasks,
        ),
      };

      // Calcula progresso geral
      final totalMicrotasks = stats['totalMicrotasks'] as int;
      final completedMicrotasks = stats['completedMicrotasks'] as int;
      stats['overallProgress'] = totalMicrotasks > 0
          ? (completedMicrotasks / totalMicrotasks).toDouble()
          : 0.0;

      return stats;
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao calcular estatísticas das tasks: ${e.toString()}',
      );
    }
  }
}

```

### lib\data\repositories\user_repository.dart

```dart
import '../../core/exceptions/app_exceptions.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

/// Repositório responsável por operações relacionadas a usuários
/// Implementa o padrão Repository para abstrair o acesso aos dados
class UserRepository {
  final UserService _userService;

  UserRepository({UserService? userService}) 
      : _userService = userService ?? UserService();

  /// Busca um usuário pelo ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }

      return await _userService.getUserById(userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar usuário: ${e.toString()}');
    }
  }

  /// Busca múltiplos usuários pelos IDs
  Future<List<UserModel>> getUsersByIds(List<String> userIds) async {
    try {
      if (userIds.isEmpty) {
        return [];
      }

      return await _userService.getUsersByIds(userIds);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar usuários: ${e.toString()}');
    }
  }

  /// Busca usuários por email
  Future<List<UserModel>> searchUsersByEmail(String emailQuery) async {
    try {
      if (emailQuery.isEmpty) {
        return [];
      }

      return await _userService.searchUsersByEmail(emailQuery);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar usuários por email: ${e.toString()}');
    }
  }

  /// Busca usuários por nome
  Future<List<UserModel>> searchUsersByName(String nameQuery) async {
    try {
      if (nameQuery.isEmpty) {
        return [];
      }

      return await _userService.searchUsersByName(nameQuery);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar usuários por nome: ${e.toString()}');
    }
  }

  /// Atualiza informações do usuário
  Future<UserModel> updateUser(UserModel user) async {
    try {
      return await _userService.updateUser(user);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao atualizar usuário: ${e.toString()}');
    }
  }

  /// Cria ou atualiza um usuário
  Future<UserModel> createOrUpdateUser(UserModel user) async {
    try {
      return await _userService.createOrUpdateUser(user);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao criar/atualizar usuário: ${e.toString()}');
    }
  }

  /// Verifica se um usuário existe
  Future<bool> userExists(String userId) async {
    try {
      if (userId.isEmpty) {
        return false;
      }

      return await _userService.userExists(userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao verificar existência do usuário: ${e.toString()}');
    }
  }

  /// Stream para monitorar mudanças em um usuário
  Stream<UserModel?> watchUser(String userId) {
    try {
      if (userId.isEmpty) {
        return Stream.value(null);
      }

      return _userService.watchUser(userId);
    } catch (e) {
      throw RepositoryException('Erro ao monitorar usuário: ${e.toString()}');
    }
  }

  /// Busca usuários recentes
  Future<List<UserModel>> getRecentUsers({int limit = 10}) async {
    try {
      return await _userService.getRecentUsers(limit: limit);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar usuários recentes: ${e.toString()}');
    }
  }

  /// Busca usuários com filtro combinado (nome ou email)
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      if (query.isEmpty) {
        return [];
      }

      // Se contém @, busca por email, senão por nome
      if (query.contains('@')) {
        return await searchUsersByEmail(query);
      } else {
        return await searchUsersByName(query);
      }
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar usuários: ${e.toString()}');
    }
  }
}

```

### lib\data\services\assignment_service.dart

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/microtask_model.dart';
import '../models/user_microtask_model.dart';
import '../models/volunteer_profile_model.dart';
import '../services/microtask_service.dart';
import '../services/event_service.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Serviço responsável pelo sistema de atribuição múltipla de voluntários
///
/// ARCHITECTURAL NOTE: This service currently violates clean architecture
/// by depending on other services (MicrotaskService, EventService).
/// In proper clean architecture, this coordination should be done in repositories.
///
/// TODO: Refactor to move business logic to repositories and make this service
/// handle only direct database operations for assignment-related data.
class AssignmentService {
  final MicrotaskService _microtaskService;
  final EventService _eventService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AssignmentService({
    MicrotaskService? microtaskService,
    EventService? eventService,
  }) : _microtaskService = microtaskService ?? MicrotaskService(),
       _eventService = eventService ?? EventService();

  // Referência da coleção
  CollectionReference get _userMicrotasksCollection =>
      _firestore.collection('user_microtasks');

  /// Atribui um voluntário a uma microtask com validações completas
  Future<MicrotaskModel> assignVolunteerToMicrotask({
    required String microtaskId,
    required String userId,
    required String eventId,
  }) async {
    try {
      // Busca a microtask
      final microtask = await _microtaskService.getMicrotaskById(microtaskId);
      if (microtask == null) {
        throw ValidationException('Microtask não encontrada');
      }

      // Busca o perfil do voluntário no evento
      final volunteerProfile = await _eventService.getVolunteerProfile(
        userId,
        eventId,
      );
      if (volunteerProfile == null) {
        throw ValidationException('Perfil de voluntário não encontrado');
      }

      // Validações de atribuição
      await _validateAssignment(microtask, userId, volunteerProfile);
      print("ABACAXI5: assinando microtask");

      // Atribui o voluntário
      final updatedMicrotask = await _microtaskService.assignVolunteer(
        microtaskId,
        userId,
      );

      // Incrementa o contador de microtasks atribuídas para o voluntário
      await _eventService.incrementVolunteerMicrotaskCount(eventId, userId);

      return updatedMicrotask;
    } catch (e) {
      if (e is ValidationException || e is DatabaseException) rethrow;
      throw DatabaseException('Erro ao atribuir voluntário: ${e.toString()}');
    }
  }

  /// Remove um voluntário de uma microtask
  Future<MicrotaskModel> unassignVolunteerFromMicrotask({
    required String microtaskId,
    required String userId,
  }) async {
    try {
      // Busca a microtask para obter o eventId
      final microtask = await _microtaskService.getMicrotaskById(microtaskId);
      if (microtask == null) {
        throw ValidationException('Microtask não encontrada');
      }

      // Remove o voluntário
      final updatedMicrotask = await _microtaskService.unassignVolunteer(
        microtaskId,
        userId,
      );

      // Decrementa o contador de microtasks atribuídas para o voluntário
      await _eventService.decrementVolunteerMicrotaskCount(
        microtask.eventId,
        userId,
      );

      return updatedMicrotask;
    } catch (e) {
      if (e is ValidationException || e is DatabaseException) rethrow;
      throw DatabaseException('Erro ao remover voluntário: ${e.toString()}');
    }
  }

  /// Busca voluntários compatíveis com uma microtask
  Future<List<VolunteerProfileModel>> getCompatibleVolunteers({
    required String eventId,
    required String microtaskId,
  }) async {
    try {
      // Busca a microtask
      final microtask = await _microtaskService.getMicrotaskById(microtaskId);
      if (microtask == null) {
        throw ValidationException('Microtask não encontrada');
      }

      // Busca todos os voluntários do evento
      final allVolunteers = await _eventService.getEventVolunteerProfiles(
        eventId,
      );

      // Filtra voluntários compatíveis
      final compatibleVolunteers = <VolunteerProfileModel>[];

      for (final volunteer in allVolunteers) {
        // Verifica se já está atribuído
        if (microtask.isAssignedTo(volunteer.userId)) {
          continue;
        }

        // Verifica compatibilidade de habilidades
        if (!microtask.isCompatibleWith(volunteer.skills)) {
          continue;
        }

        // TODO: Adicionar verificação de disponibilidade de horários
        // TODO: Adicionar verificação de recursos disponíveis

        compatibleVolunteers.add(volunteer);
      }

      // Ordena por score de compatibilidade
      compatibleVolunteers.sort((a, b) {
        final scoreA = microtask.getCompatibilityScore(a.skills);
        final scoreB = microtask.getCompatibilityScore(b.skills);
        return scoreB.compareTo(scoreA);
      });

      return compatibleVolunteers;
    } catch (e) {
      if (e is ValidationException || e is DatabaseException) rethrow;
      throw DatabaseException(
        'Erro ao buscar voluntários compatíveis: ${e.toString()}',
      );
    }
  }

  /// Busca microtasks disponíveis para um voluntário
  Future<List<MicrotaskModel>> getAvailableMicrotasksForVolunteer({
    required String eventId,
    required String userId,
  }) async {
    try {
      // Busca o perfil do voluntário
      final volunteerProfile = await _eventService.getVolunteerProfile(
        eventId,
        userId,
      );
      if (volunteerProfile == null) {
        throw ValidationException('Perfil de voluntário não encontrado');
      }

      // Busca todas as microtasks do evento
      final allMicrotasks = await _microtaskService.getMicrotasksByEventId(
        eventId,
      );

      // Filtra microtasks disponíveis
      final availableMicrotasks = <MicrotaskModel>[];

      for (final microtask in allMicrotasks) {
        // Verifica se já está atribuído
        if (microtask.isAssignedTo(userId)) {
          continue;
        }

        // Verifica se há vagas disponíveis
        if (!microtask.hasAvailableSlots) {
          continue;
        }

        // Verifica se não está cancelada
        if (microtask.isCancelled) {
          continue;
        }

        // Verifica compatibilidade de habilidades
        if (!microtask.isCompatibleWith(volunteerProfile.skills)) {
          continue;
        }

        availableMicrotasks.add(microtask);
      }

      // Ordena por prioridade e compatibilidade
      availableMicrotasks.sort((a, b) {
        // Primeiro por prioridade
        final priorityOrder = {'high': 3, 'medium': 2, 'low': 1};
        final priorityA = priorityOrder[a.priority] ?? 2;
        final priorityB = priorityOrder[b.priority] ?? 2;

        if (priorityA != priorityB) {
          return priorityB.compareTo(priorityA);
        }

        // Depois por score de compatibilidade
        final scoreA = a.getCompatibilityScore(volunteerProfile.skills);
        final scoreB = b.getCompatibilityScore(volunteerProfile.skills);
        return scoreB.compareTo(scoreA);
      });

      return availableMicrotasks;
    } catch (e) {
      if (e is ValidationException || e is DatabaseException) rethrow;
      throw DatabaseException(
        'Erro ao buscar microtasks disponíveis: ${e.toString()}',
      );
    }
  }

  /// Busca o status individual de um usuário em uma microtask
  Future<UserMicrotaskModel?> getUserMicrotaskStatus({
    required String userId,
    required String microtaskId,
  }) async {
    try {
      final querySnapshot = await _userMicrotasksCollection
          .where('userId', isEqualTo: userId)
          .where('microtaskId', isEqualTo: microtaskId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      return UserMicrotaskModel.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      throw DatabaseException(
        'Erro ao buscar status do usuário na microtask: ${e.toString()}',
      );
    }
  }

  /// Atualiza o status individual de um usuário em uma microtask
  Future<UserMicrotaskModel> updateUserMicrotaskStatus({
    required String userId,
    required String microtaskId,
    required UserMicrotaskStatus status,
    double? actualHours,
    String? notes,
  }) async {
    try {
      final userMicrotask = await getUserMicrotaskStatus(
        userId: userId,
        microtaskId: microtaskId,
      );

      if (userMicrotask == null) {
        throw ValidationException('Relação usuário-microtask não encontrada');
      }

      UserMicrotaskModel updatedUserMicrotask;
      switch (status) {
        case UserMicrotaskStatus.started:
          updatedUserMicrotask = userMicrotask.markAsStarted();
          break;
        case UserMicrotaskStatus.completed:
          updatedUserMicrotask = userMicrotask.markAsCompleted(
            actualHours: actualHours,
          );
          break;
        case UserMicrotaskStatus.cancelled:
          updatedUserMicrotask = userMicrotask.markAsCancelled();
          break;
        default:
          updatedUserMicrotask = userMicrotask.copyWith(
            status: status,
            updatedAt: DateTime.now(),
          );
      }

      if (notes != null) {
        updatedUserMicrotask = updatedUserMicrotask.updateNotes(notes);
      }

      // Salva no Firestore
      await _userMicrotasksCollection
          .doc(userMicrotask.id)
          .update(updatedUserMicrotask.toFirestore());

      // Verifica se precisa atualizar o status da microtask
      await _checkAndUpdateMicrotaskStatus(microtaskId);

      return updatedUserMicrotask;
    } catch (e) {
      if (e is ValidationException || e is DatabaseException) rethrow;
      throw DatabaseException(
        'Erro ao atualizar status do usuário: ${e.toString()}',
      );
    }
  }

  /// Busca todas as relações usuário-microtask de uma microtask
  Future<List<UserMicrotaskModel>> getUserMicrotasksByMicrotaskId(
    String microtaskId,
  ) async {
    try {
      final querySnapshot = await _userMicrotasksCollection
          .where('microtaskId', isEqualTo: microtaskId)
          .get();

      return querySnapshot.docs
          .map((doc) => UserMicrotaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException(
        'Erro ao buscar relações usuário-microtask: ${e.toString()}',
      );
    }
  }

  /// Busca todas as microtasks de um usuário com seus status
  Future<List<UserMicrotaskModel>> getUserMicrotasksByUserId(
    String userId,
  ) async {
    try {
      final querySnapshot = await _userMicrotasksCollection
          .where('userId', isEqualTo: userId)
          .orderBy('assignedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => UserMicrotaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException(
        'Erro ao buscar microtasks do usuário: ${e.toString()}',
      );
    }
  }

  /// Valida se um voluntário pode ser atribuído a uma microtask
  Future<void> _validateAssignment(
    MicrotaskModel microtask,
    String userId,
    VolunteerProfileModel volunteerProfile,
  ) async {
    // Verifica se já está atribuído
    if (microtask.isAssignedTo(userId)) {
      throw ValidationException(
        'Voluntário já está atribuído a esta microtask',
      );
    }

    // Verifica se há vagas disponíveis
    if (!microtask.hasAvailableSlots) {
      throw ValidationException('Não há vagas disponíveis nesta microtask');
    }

    // Verifica se a microtask não está cancelada
    if (microtask.isCancelled) {
      throw ValidationException(
        'Não é possível atribuir voluntário a microtask cancelada',
      );
    }

    // Verifica compatibilidade de habilidades
    if (!microtask.isCompatibleWith(volunteerProfile.skills)) {
      throw ValidationException(
        'Voluntário não possui as habilidades necessárias',
      );
    }

    // TODO: Adicionar validação de disponibilidade de horários
    // TODO: Adicionar validação de recursos disponíveis
  }

  /// Verifica e atualiza o status da microtask baseado nos status individuais
  Future<void> _checkAndUpdateMicrotaskStatus(String microtaskId) async {
    try {
      final microtask = await _microtaskService.getMicrotaskById(microtaskId);
      if (microtask == null) return;

      final userMicrotasks = await getUserMicrotasksByMicrotaskId(microtaskId);

      if (userMicrotasks.isEmpty) {
        // Sem voluntários atribuídos
        if (microtask.status != MicrotaskStatus.pending) {
          await _microtaskService.updateMicrotaskStatus(
            microtaskId,
            MicrotaskStatus.pending,
          );
        }
        return;
      }

      // Verifica se todos completaram
      final allCompleted = userMicrotasks.every((um) => um.isCompleted);
      if (allCompleted && microtask.status != MicrotaskStatus.completed) {
        await _microtaskService.updateMicrotaskStatus(
          microtaskId,
          MicrotaskStatus.completed,
        );
        return;
      }

      // Verifica se algum iniciou
      final anyStarted = userMicrotasks.any(
        (um) => um.isStarted || um.isCompleted,
      );
      if (anyStarted && microtask.status == MicrotaskStatus.assigned) {
        await _microtaskService.updateMicrotaskStatus(
          microtaskId,
          MicrotaskStatus.inProgress,
        );
        return;
      }
    } catch (e) {
      // Log do erro, mas não propaga para não quebrar o fluxo principal
      print('Erro ao atualizar status da microtask: $e');
    }
  }
}

```

### lib\data\services\auth_service.dart

```dart
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../models/user_model.dart';

/// Serviço responsável pela autenticação com Firebase Auth
/// Implementa login com email/senha e Google Sign-In
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  /*caso implemente para ANDROID E IOS */
  //final GoogleSignIn _googleSignIn; = GoogleSignIn();

  /// Retorna o usuário atualmente logado
  User? get currentUser => _firebaseAuth.currentUser;

  /// Stream que monitora mudanças no estado de autenticação
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Verifica se há um usuário logado
  bool get isLoggedIn => currentUser != null;

  /// Retorna o UID do usuário atual
  String? get currentUserId => currentUser?.uid;

  /// Faz login com email e senha
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw ExceptionHandler.handleAuthException(e);
    } catch (e) {
      throw AuthException(
        'Erro inesperado durante o login',
        originalException: e,
      );
    }
  }

  /// Cria uma nova conta com email e senha
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw ExceptionHandler.handleAuthException(e);
    } catch (e) {
      throw AuthException(
        'Erro inesperado durante o cadastro',
        originalException: e,
      );
    }
  }

  /// Faz login com Google (compatível com Web e Mobile)
  Future<UserCredential> signInWithGoogle() async {
    try {
      /* ANDROID E AIOS
      if (kIsWeb) {
     */
      // Fluxo para Web
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // Adiciona escopos se necessário
      googleProvider.addScope('email');
      googleProvider.addScope('profile');

      // Faz login diretamente com popup no web
      final userCredential = await _firebaseAuth.signInWithPopup(
        googleProvider,
      );

      return userCredential;
      /* ANDROID E AIOS
      }
      else {
        // Fluxo para Mobile (Android/iOS)
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          throw const AuthException('Login com Google cancelado pelo usuário');
        }

        // Obtém os detalhes de autenticação
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Cria uma credencial do Firebase
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Faz login no Firebase com a credencial do Google
        final userCredential = await _firebaseAuth.signInWithCredential(
          credential,
        );

        return userCredential;
      }*/
    } on FirebaseAuthException catch (e) {
      throw ExceptionHandler.handleAuthException(e);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(
        'Erro durante login com Google',
        originalException: e,
      );
    }
  }

  /// Faz logout
  Future<void> signOut() async {
    try {
      // Faz logout do Google se estiver logado
      /*ANDROID E AIOS
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      */

      // Faz logout do Firebase
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException('Erro durante logout', originalException: e);
    }
  }

  /// Envia email de redefinição de senha
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw ExceptionHandler.handleAuthException(e);
    } catch (e) {
      throw AuthException(
        'Erro ao enviar email de redefinição',
        originalException: e,
      );
    }
  }

  /// Atualiza o perfil do usuário (nome e foto)
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AuthException('Usuário não está logado');
      }

      await user.updateDisplayName(displayName);
      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }

      // Recarrega o usuário para obter as informações atualizadas
      await user.reload();
    } on FirebaseAuthException catch (e) {
      throw ExceptionHandler.handleAuthException(e);
    } catch (e) {
      throw AuthException('Erro ao atualizar perfil', originalException: e);
    }
  }

  /// Atualiza o email do usuário
  Future<void> updateEmail(String newEmail) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AuthException('Usuário não está logado');
      }

      await user.verifyBeforeUpdateEmail(newEmail.trim());
    } on FirebaseAuthException catch (e) {
      throw ExceptionHandler.handleAuthException(e);
    } catch (e) {
      throw AuthException('Erro ao atualizar email', originalException: e);
    }
  }

  /// Atualiza a senha do usuário
  Future<void> updatePassword(String newPassword) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AuthException('Usuário não está logado');
      }

      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw ExceptionHandler.handleAuthException(e);
    } catch (e) {
      throw AuthException('Erro ao atualizar senha', originalException: e);
    }
  }

  /// Reautentica o usuário com email e senha
  Future<void> reauthenticateWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AuthException('Usuário não está logado');
      }

      final credential = EmailAuthProvider.credential(
        email: email.trim(),
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw ExceptionHandler.handleAuthException(e);
    } catch (e) {
      throw AuthException('Erro durante reautenticação', originalException: e);
    }
  }

  /// Deleta a conta do usuário
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AuthException('Usuário não está logado');
      }

      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw ExceptionHandler.handleAuthException(e);
    } catch (e) {
      throw AuthException('Erro ao deletar conta', originalException: e);
    }
  }

  /// Envia email de verificação
  Future<void> sendEmailVerification() async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AuthException('Usuário não está logado');
      }

      if (user.emailVerified) {
        throw const AuthException('Email já está verificado');
      }

      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw ExceptionHandler.handleAuthException(e);
    } catch (e) {
      throw AuthException(
        'Erro ao enviar verificação de email',
        originalException: e,
      );
    }
  }

  /// Recarrega as informações do usuário atual
  Future<void> reloadUser() async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AuthException('Usuário não está logado');
      }

      await user.reload();
    } catch (e) {
      throw AuthException('Erro ao recarregar usuário', originalException: e);
    }
  }

  /// Converte User do Firebase para UserModel
  UserModel? firebaseUserToUserModel(User? firebaseUser) {
    if (firebaseUser == null) return null;

    return UserModel.fromGoogleSignIn(
      uid: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      photoUrl: firebaseUser.photoURL,
    );
  }

  /// Verifica se o email está verificado
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  /// Retorna informações básicas do usuário atual
  Map<String, dynamic>? get currentUserInfo {
    final user = currentUser;
    if (user == null) return null;

    return {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'emailVerified': user.emailVerified,
      'creationTime': user.metadata.creationTime?.toIso8601String(),
      'lastSignInTime': user.metadata.lastSignInTime?.toIso8601String(),
    };
  }
}

```

### lib\data\services\event_service.dart

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/event_model.dart';
import '../models/volunteer_profile_model.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Serviço responsável por operações relacionadas a eventos no Firebase
class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // Referências das coleções
  CollectionReference get _eventsCollection => _firestore.collection('events');
  CollectionReference get _volunteerProfilesCollection =>
      _firestore.collection('volunteer_profiles');

  /// Cria um novo evento
  Future<EventModel> createEvent({
    required String name,
    required String description,
    required String location,
    required String createdBy,
    required List<String> requiredSkills,
    required List<String> requiredResources,
  }) async {
    try {
      // Gera um ID único para o evento
      final eventId = _uuid.v4();

      // Gera uma tag única
      String tag;
      do {
        tag = _generateUniqueTag();
      } while (await _isTagTaken(tag));

      // Gera timestamps
      final now = DateTime.now();

      // Cria o evento com dados gerados pelo service
      final event = EventModel.create(
        id: eventId,
        name: name,
        description: description,
        tag: tag,
        location: location,
        createdBy: createdBy,
        requiredSkills: requiredSkills,
        requiredResources: requiredResources,
        createdAt: now,
        updatedAt: now,
      );

      // Note: Validation should be done by repository/controller before calling service

      // Salva no Firestore
      await _eventsCollection.doc(eventId).set(event.toFirestore());

      return event;
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Erro ao criar evento: ${e.toString()}');
    }
  }

  /// Busca um evento por ID
  Future<EventModel?> getEventById(String eventId) async {
    try {
      final doc = await _eventsCollection.doc(eventId).get();

      if (!doc.exists) return null;

      return EventModel.fromFirestore(doc);
    } catch (e) {
      throw DatabaseException('Erro ao buscar evento: ${e.toString()}');
    }
  }

  /// Busca um evento por tag
  Future<EventModel?> getEventByTag(String tag) async {
    try {
      final query = await _eventsCollection
          .where('tag', isEqualTo: tag.toUpperCase())
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;

      return EventModel.fromFirestore(query.docs.first);
    } catch (e) {
      throw DatabaseException('Erro ao buscar evento por tag: ${e.toString()}');
    }
  }

  /// Busca eventos onde o usuário é participante (gerenciador ou voluntário)
  Future<List<EventModel>> getUserEvents(String userId) async {
    try {
      // Busca eventos onde o usuário é gerenciador
      final managerQuery = await _eventsCollection
          .where('managers', arrayContains: userId)
          .get();

      // Busca eventos onde o usuário é voluntário
      final volunteerQuery = await _eventsCollection
          .where('volunteers', arrayContains: userId)
          .get();

      // Combina os resultados evitando duplicatas
      final eventIds = <String>{};
      final events = <EventModel>[];

      for (final doc in [...managerQuery.docs, ...volunteerQuery.docs]) {
        if (!eventIds.contains(doc.id)) {
          eventIds.add(doc.id);
          events.add(EventModel.fromFirestore(doc));
        }
      }

      // Ordena por data de criação (mais recentes primeiro)
      events.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return events;
    } catch (e) {
      throw DatabaseException(
        'Erro ao buscar eventos do usuário: ${e.toString()}',
      );
    }
  }

  /// Atualiza um evento
  Future<EventModel> updateEvent(EventModel event) async {
    try {
      // Note: Validation should be done by repository/controller before calling service

      final updatedEvent = event.withUpdatedTimestamp();

      await _eventsCollection.doc(event.id).update(updatedEvent.toFirestore());

      return updatedEvent;
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Erro ao atualizar evento: ${e.toString()}');
    }
  }

  /// Adiciona um voluntário ao evento
  Future<EventModel> addVolunteerToEvent(String eventId, String userId) async {
    try {
      final event = await getEventById(eventId);
      if (event == null) {
        throw NotFoundException('Evento não encontrado');
      }

      // Verifica se o usuário já é participante
      if (event.isParticipant(userId)) {
        throw ValidationException('Usuário já é participante do evento');
      }

      final updatedEvent = event.addVolunteer(userId);
      return await updateEvent(updatedEvent);
    } catch (e) {
      if (e is AppException) rethrow;
      throw DatabaseException('Erro ao adicionar voluntário: ${e.toString()}');
    }
  }

  /// Remove um voluntário do evento
  Future<EventModel> removeVolunteerFromEvent(
    String eventId,
    String userId,
  ) async {
    try {
      final event = await getEventById(eventId);
      if (event == null) {
        throw NotFoundException('Evento não encontrado');
      }

      if (!event.isVolunteer(userId)) {
        throw ValidationException('Usuário não é voluntário do evento');
      }

      final updatedEvent = event.removeVolunteer(userId);
      return await updateEvent(updatedEvent);
    } catch (e) {
      if (e is AppException) rethrow;
      throw DatabaseException('Erro ao remover voluntário: ${e.toString()}');
    }
  }

  /// Promove um voluntário a gerenciador
  Future<EventModel> promoteVolunteerToManager(
    String eventId,
    String userId,
  ) async {
    try {
      final event = await getEventById(eventId);
      if (event == null) {
        throw NotFoundException('Evento não encontrado');
      }

      if (!event.isVolunteer(userId)) {
        throw ValidationException('Usuário não é voluntário do evento');
      }

      final updatedEvent = event.promoteToManager(userId);
      return await updateEvent(updatedEvent);
    } catch (e) {
      if (e is AppException) rethrow;
      throw DatabaseException('Erro ao promover voluntário: ${e.toString()}');
    }
  }

  /// Cria um perfil de voluntário
  Future<VolunteerProfileModel> createVolunteerProfile({
    required String userId,
    required String eventId,
    required List<String> availableDays,
    required TimeRange availableHours,
    bool isFullTimeAvailable = false,
    required List<String> skills,
    required List<String> resources,
    required String userName,
    required String userEmail,
    String? userPhotoUrl,
  }) async {
    try {
      // Gera um ID único para o perfil
      final profileId = _uuid.v4();
      final now = DateTime.now();

      // Cria o perfil com dados gerados pelo service
      final profile = VolunteerProfileModel.create(
        id: profileId,
        userId: userId,
        eventId: eventId,
        availableDays: availableDays,
        availableHours: availableHours,
        isFullTimeAvailable: isFullTimeAvailable,
        skills: skills,
        resources: resources,
        assignedMicrotasksCount: 0,
        userName: userName,
        userEmail: userEmail,
        userPhotoUrl: userPhotoUrl,
        joinedAt: now,
      );

      // Note: Validation should be done by repository/controller before calling service

      // Salva no Firestore
      await _volunteerProfilesCollection
          .doc(profileId)
          .set(profile.toFirestore());

      return profile;
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException(
        'Erro ao criar perfil de voluntário: ${e.toString()}',
      );
    }
  }

  /// Busca o perfil de um voluntário em um evento
  Future<VolunteerProfileModel?> getVolunteerProfile(
    String userId,
    String eventId,
  ) async {
    try {
      print('ABACAXI_B1:$userId $eventId');
      final query = await _volunteerProfilesCollection
          .where('userId', isEqualTo: userId)
          .where('eventId', isEqualTo: eventId)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;

      return VolunteerProfileModel.fromFirestore(query.docs.first);
    } catch (e) {
      print('Erro ao buscar perfil de voluntário: ${e.toString()}');
      throw DatabaseException(
        'Erro ao buscar perfil de voluntário: ${e.toString()}',
      );
    }
  }

  /// Busca todos os perfis de voluntários de um evento
  Future<List<VolunteerProfileModel>> getEventVolunteerProfiles(
    String eventId,
  ) async {
    try {
      final query = await _volunteerProfilesCollection
          .where('eventId', isEqualTo: eventId)
          .get();

      final profiles = <VolunteerProfileModel>[];

      for (final doc in query.docs) {
        var profile = VolunteerProfileModel.fromFirestore(doc);

        // Se o perfil não tem dados do usuário, busca e atualiza
        if (!profile.hasValidUserData) {
          final userData = await _getUserData(profile.userId);
          if (userData != null) {
            profile = profile.updateUserData(
              userName: userData['name'] as String? ?? '',
              userEmail: userData['email'] as String? ?? '',
              userPhotoUrl: userData['photoUrl'] as String?,
            );

            // Atualiza o perfil no banco com os dados do usuário
            try {
              await _volunteerProfilesCollection.doc(profile.id).update({
                'userName': profile.userName,
                'userEmail': profile.userEmail,
                'userPhotoUrl': profile.userPhotoUrl,
              });
            } catch (e) {
              // Ignora erros de atualização para não quebrar o fluxo
            }
          }
        }

        profiles.add(profile);
      }

      return profiles;
    } catch (e) {
      print('Erro ao buscar perfil de voluntário: ${e.toString()}');
      throw DatabaseException(
        'Erro ao buscar perfis de voluntários: ${e.toString()}',
      );
    }
  }

  /// Atualiza um perfil de voluntário
  Future<VolunteerProfileModel> updateVolunteerProfile(
    VolunteerProfileModel profile,
  ) async {
    try {
      // Valida os dados antes de salvar
      final validationErrors = profile.validate();
      if (validationErrors.isNotEmpty) {
        throw ValidationException(
          'Dados inválidos: ${validationErrors.join(', ')}',
        );
      }

      await _volunteerProfilesCollection
          .doc(profile.id)
          .update(profile.toFirestore());

      return profile;
    } catch (e) {
      print('Erro ao buscar perfil de voluntário: ${e.toString()}');
      if (e is ValidationException) rethrow;
      throw DatabaseException(
        'Erro ao atualizar perfil de voluntário: ${e.toString()}',
      );
    }
  }

  /// Deleta um evento (apenas o criador pode fazer isso)
  Future<void> deleteEvent(String eventId, String userId) async {
    try {
      final event = await getEventById(eventId);
      if (event == null) {
        throw NotFoundException('Evento não encontrado');
      }

      if (!event.isCreator(userId)) {
        throw UnauthorizedException('Apenas o criador pode deletar o evento');
      }

      // Deleta todos os perfis de voluntários relacionados
      final profiles = await getEventVolunteerProfiles(eventId);
      for (final profile in profiles) {
        await _volunteerProfilesCollection.doc(profile.id).delete();
      }

      // Deleta o evento
      await _eventsCollection.doc(eventId).delete();
    } catch (e) {
      if (e is AppException) rethrow;
      throw DatabaseException('Erro ao deletar evento: ${e.toString()}');
    }
  }

  /// Verifica se uma tag já está sendo usada
  Future<bool> _isTagTaken(String tag) async {
    try {
      final query = await _eventsCollection
          .where('tag', isEqualTo: tag)
          .limit(1)
          .get();

      return query.docs.isNotEmpty;
    } catch (e) {
      return false; // Em caso de erro, assume que não está sendo usada
    }
  }

  /// Gera uma tag única para o evento
  String _generateUniqueTag() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    var result = '';

    for (int i = 0; i < 6; i++) {
      result += chars[(random + i * 7) % chars.length];
    }

    return result;
  }

  /// Incrementa o contador de microtasks atribuídas para um voluntário
  Future<void> incrementVolunteerMicrotaskCount(
    String eventId,
    String userId,
  ) async {
    try {
      final profileQuery = await _volunteerProfilesCollection
          .where('eventId', isEqualTo: eventId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (profileQuery.docs.isNotEmpty) {
        final doc = profileQuery.docs.first;
        final currentData = doc.data() as Map<String, dynamic>;

        // Verifica se o campo existe, se não, inicializa com contagem real
        int assignedCount;
        if (currentData.containsKey('assignedMicrotasksCount')) {
          assignedCount = currentData['assignedMicrotasksCount'] as int? ?? 0;
        } else {
          // Campo não existe, calcula a contagem real e inicializa
          assignedCount = await _calculateActualMicrotaskCount(eventId, userId);
        }

        await doc.reference.update({
          'assignedMicrotasksCount': assignedCount + 1,
        });
      }
    } catch (e) {
      throw DatabaseException(
        'Erro ao incrementar contador de microtasks: ${e.toString()}',
      );
    }
  }

  /// Decrementa o contador de microtasks atribuídas para um voluntário
  Future<void> decrementVolunteerMicrotaskCount(
    String eventId,
    String userId,
  ) async {
    try {
      final profileQuery = await _volunteerProfilesCollection
          .where('eventId', isEqualTo: eventId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (profileQuery.docs.isNotEmpty) {
        final doc = profileQuery.docs.first;
        final currentData = doc.data() as Map<String, dynamic>;

        // Verifica se o campo existe, se não, inicializa com contagem real
        int assignedCount;
        if (currentData.containsKey('assignedMicrotasksCount')) {
          assignedCount = currentData['assignedMicrotasksCount'] as int? ?? 0;
        } else {
          // Campo não existe, calcula a contagem real e inicializa
          assignedCount = await _calculateActualMicrotaskCount(eventId, userId);
        }

        await doc.reference.update({
          'assignedMicrotasksCount': assignedCount > 0 ? assignedCount - 1 : 0,
        });
      }
    } catch (e) {
      throw DatabaseException(
        'Erro ao decrementar contador de microtasks: ${e.toString()}',
      );
    }
  }

  /// Stream para escutar mudanças em um evento
  Stream<EventModel?> watchEvent(String eventId) {
    return _eventsCollection.doc(eventId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return EventModel.fromFirestore(doc);
    });
  }

  /// Stream para escutar mudanças nos eventos do usuário
  Stream<List<EventModel>> watchUserEvents(String userId) {
    // Implementação simplificada - pode ser otimizada
    return Stream.periodic(
      const Duration(seconds: 5),
    ).asyncMap((_) => getUserEvents(userId));
  }

  /// Calcula a contagem real de microtasks atribuídas a um voluntário
  /// consultando diretamente as microtasks no banco de dados
  Future<int> _calculateActualMicrotaskCount(
    String eventId,
    String userId,
  ) async {
    try {
      final microtasksQuery = await _firestore
          .collection('microtasks')
          .where('eventId', isEqualTo: eventId)
          .where('assignedTo', arrayContains: userId)
          .get();

      return microtasksQuery.docs.length;
    } catch (e) {
      // Em caso de erro, retorna 0 para não quebrar o fluxo
      print('Erro ao calcular contagem real de microtasks: $e');
      return 0;
    }
  }

  /// Migra perfis de voluntários existentes para incluir o campo assignedMicrotasksCount
  /// Este método deve ser chamado uma vez para migrar dados existentes
  Future<void> migrateVolunteerProfilesTaskCounts() async {
    try {
      // Busca todos os perfis que não têm o campo assignedMicrotasksCount
      final profilesQuery = await _volunteerProfilesCollection.get();

      final batch = _firestore.batch();
      int batchCount = 0;

      for (final doc in profilesQuery.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // Verifica se o campo não existe
        if (!data.containsKey('assignedMicrotasksCount')) {
          final eventId = data['eventId'] as String;
          final userId = data['userId'] as String;

          // Calcula a contagem real
          final actualCount = await _calculateActualMicrotaskCount(
            eventId,
            userId,
          );

          // Adiciona a atualização ao batch
          batch.update(doc.reference, {'assignedMicrotasksCount': actualCount});

          batchCount++;

          // Executa o batch a cada 500 operações para evitar limites do Firestore
          if (batchCount >= 500) {
            await batch.commit();
            batchCount = 0;
          }
        }
      }

      // Executa o batch final se houver operações pendentes
      if (batchCount > 0) {
        await batch.commit();
      }

      print('Migração de perfis de voluntários concluída com sucesso');
    } catch (e) {
      throw DatabaseException(
        'Erro ao migrar perfis de voluntários: ${e.toString()}',
      );
    }
  }

  /// Recalcula e corrige o contador de microtasks para um voluntário específico
  Future<void> recalculateVolunteerMicrotaskCount(
    String eventId,
    String userId,
  ) async {
    try {
      final profileQuery = await _volunteerProfilesCollection
          .where('eventId', isEqualTo: eventId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (profileQuery.docs.isNotEmpty) {
        final doc = profileQuery.docs.first;
        final actualCount = await _calculateActualMicrotaskCount(
          eventId,
          userId,
        );

        await doc.reference.update({'assignedMicrotasksCount': actualCount});
      }
    } catch (e) {
      throw DatabaseException(
        'Erro ao recalcular contador de microtasks: ${e.toString()}',
      );
    }
  }

  /// Recalcula os contadores para todos os voluntários de um evento
  Future<void> recalculateEventVolunteerCounts(String eventId) async {
    try {
      final profilesQuery = await _volunteerProfilesCollection
          .where('eventId', isEqualTo: eventId)
          .get();

      final batch = _firestore.batch();
      int batchCount = 0;

      for (final doc in profilesQuery.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final userId = data['userId'] as String;

        final actualCount = await _calculateActualMicrotaskCount(
          eventId,
          userId,
        );

        batch.update(doc.reference, {'assignedMicrotasksCount': actualCount});

        batchCount++;

        // Executa o batch a cada 500 operações
        if (batchCount >= 500) {
          await batch.commit();
          batchCount = 0;
        }
      }

      // Executa o batch final se houver operações pendentes
      if (batchCount > 0) {
        await batch.commit();
      }
    } catch (e) {
      throw DatabaseException(
        'Erro ao recalcular contadores do evento: ${e.toString()}',
      );
    }
  }

  /// Busca dados do usuário para denormalização
  Future<Map<String, dynamic>?> _getUserData(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data();
      }
      return null;
    } catch (e) {
      // Em caso de erro, retorna null para não quebrar o fluxo
      print('Erro ao buscar dados do usuário: $e');
      return null;
    }
  }

  /// Atualiza dados do usuário em todos os perfis de voluntário
  Future<void> updateUserDataInVolunteerProfiles(
    String userId,
    String userName,
    String userEmail,
    String? userPhotoUrl,
  ) async {
    try {
      final profilesQuery = await _volunteerProfilesCollection
          .where('userId', isEqualTo: userId)
          .get();

      final batch = _firestore.batch();
      int batchCount = 0;

      for (final doc in profilesQuery.docs) {
        batch.update(doc.reference, {
          'userName': userName,
          'userEmail': userEmail,
          'userPhotoUrl': userPhotoUrl,
        });

        batchCount++;

        // Executa o batch a cada 500 operações
        if (batchCount >= 500) {
          await batch.commit();
          batchCount = 0;
        }
      }

      // Executa o batch final se houver operações pendentes
      if (batchCount > 0) {
        await batch.commit();
      }
    } catch (e) {
      throw DatabaseException(
        'Erro ao atualizar dados do usuário nos perfis: ${e.toString()}',
      );
    }
  }
}

```

### lib\data\services\microtask_service.dart

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/microtask_model.dart';
import '../models/user_microtask_model.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Serviço responsável por operações relacionadas a microtasks no Firebase
class MicrotaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // Referências das coleções
  CollectionReference get _microtasksCollection =>
      _firestore.collection('microtasks');
  CollectionReference get _userMicrotasksCollection =>
      _firestore.collection('user_microtasks');

  /// Cria uma nova microtask
  Future<MicrotaskModel> createMicrotask({
    required String taskId,
    required String eventId,
    required String title,
    required String description,
    required List<String> requiredSkills,
    required List<String> requiredResources,
    DateTime? startDateTime,
    DateTime? endDateTime,
    required String priority,
    required int maxVolunteers,
    required String createdBy,
    String? notes,
  }) async {
    try {
      // Gera um ID único para a microtask
      final microtaskId = _uuid.v4();
      final now = DateTime.now();

      // Cria a microtask com dados gerados pelo service
      final microtask = MicrotaskModel.create(
        id: microtaskId,
        taskId: taskId,
        eventId: eventId,
        title: title,
        description: description,
        requiredSkills: requiredSkills,
        requiredResources: requiredResources,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        priority: priority,
        maxVolunteers: maxVolunteers,
        createdBy: createdBy,
        createdAt: now,
        updatedAt: now,
        notes: notes,
      );

      // Note: Validation should be done by repository/controller before calling service

      // Salva no Firestore
      await _microtasksCollection.doc(microtaskId).set(microtask.toFirestore());

      return microtask;
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Erro ao criar microtask: ${e.toString()}');
    }
  }

  /// Busca uma microtask por ID
  Future<MicrotaskModel?> getMicrotaskById(String microtaskId) async {
    try {
      final doc = await _microtasksCollection.doc(microtaskId).get();

      if (!doc.exists) return null;

      return MicrotaskModel.fromFirestore(doc);
    } catch (e) {
      throw DatabaseException('Erro ao buscar microtask: ${e.toString()}');
    }
  }

  /// Busca todas as microtasks de uma task
  Future<List<MicrotaskModel>> getMicrotasksByTaskId(String taskId) async {
    try {
      final querySnapshot = await _microtasksCollection
          .where('taskId', isEqualTo: taskId)
          .orderBy('createdAt', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => MicrotaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Erro ao buscar microtasks da task: ${e.toString()}');
      throw DatabaseException(
        'Erro ao buscar microtasks da task: ${e.toString()}',
      );
    }
  }

  /// Busca todas as microtasks de um evento
  Future<List<MicrotaskModel>> getMicrotasksByEventId(String eventId) async {
    try {
      final querySnapshot = await _microtasksCollection
          .where('eventId', isEqualTo: eventId)
          .orderBy('createdAt', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => MicrotaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException(
        'Erro ao buscar microtasks do evento: ${e.toString()}',
      );
    }
  }

  /// Busca microtasks atribuídas a um usuário específico
  Future<List<MicrotaskModel>> getMicrotasksByUserId(String userId) async {
    try {
      final querySnapshot = await _microtasksCollection
          .where('assignedTo', arrayContains: userId)
          .orderBy('createdAt', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => MicrotaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException(
        'Erro ao buscar microtasks do usuário: ${e.toString()}',
      );
    }
  }

  /// Busca microtasks por status
  Future<List<MicrotaskModel>> getMicrotasksByStatus(
    String eventId,
    MicrotaskStatus status,
  ) async {
    try {
      final querySnapshot = await _microtasksCollection
          .where('eventId', isEqualTo: eventId)
          .where('status', isEqualTo: status.value)
          .orderBy('createdAt', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => MicrotaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException(
        'Erro ao buscar microtasks por status: ${e.toString()}',
      );
    }
  }

  /// Atualiza uma microtask
  Future<MicrotaskModel> updateMicrotask(MicrotaskModel microtask) async {
    try {
      if (microtask.id.isEmpty) {
        throw ValidationException(
          'ID da microtask é obrigatório para atualização',
        );
      }

      // Valida os dados antes de salvar
      final validationErrors = microtask.validate();
      if (validationErrors.isNotEmpty) {
        throw ValidationException(
          'Dados inválidos: ${validationErrors.join(', ')}',
        );
      }

      // Atualiza o timestamp
      final updatedMicrotask = microtask.withUpdatedTimestamp();

      // Salva no Firestore
      await _microtasksCollection
          .doc(microtask.id)
          .update(updatedMicrotask.toFirestore());

      return updatedMicrotask;
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Erro ao atualizar microtask: ${e.toString()}');
    }
  }

  /// Atribui um voluntário a uma microtask
  Future<MicrotaskModel> assignVolunteer(
    String microtaskId,
    String userId,
  ) async {
    try {
      final microtask = await getMicrotaskById(microtaskId);
      if (microtask == null) {
        throw DatabaseException('Microtask não encontrada');
      }

      // Verifica se já está atribuído
      if (microtask.isAssignedTo(userId)) {
        throw ValidationException('Usuário já está atribuído a esta microtask');
      }

      // Verifica se há vagas disponíveis
      if (!microtask.hasAvailableSlots) {
        throw ValidationException('Não há vagas disponíveis nesta microtask');
      }

      // Atribui o voluntário
      final updatedMicrotask = microtask.assignVolunteer(userId);

      // Salva a microtask atualizada
      final savedMicrotask = await updateMicrotask(updatedMicrotask);

      // Cria o registro de relação usuário-microtask
      await _createUserMicrotaskRelation(
        userId,
        microtaskId,
        microtask.eventId,
      );

      print('Voluntário atribuído com sucesso!');

      return savedMicrotask;
    } catch (e) {
      if (e is DatabaseException || e is ValidationException) rethrow;
      throw DatabaseException('Erro ao atribuir voluntário: ${e.toString()}');
    }
  }

  /// Remove um voluntário de uma microtask
  Future<MicrotaskModel> unassignVolunteer(
    String microtaskId,
    String userId,
  ) async {
    try {
      final microtask = await getMicrotaskById(microtaskId);
      if (microtask == null) {
        throw DatabaseException('Microtask não encontrada');
      }

      // Verifica se está atribuído
      if (!microtask.isAssignedTo(userId)) {
        throw ValidationException(
          'Usuário não está atribuído a esta microtask',
        );
      }

      // Remove o voluntário
      final updatedMicrotask = microtask.unassignVolunteer(userId);

      // Salva a microtask atualizada
      final savedMicrotask = await updateMicrotask(updatedMicrotask);

      // Remove o registro de relação usuário-microtask
      await _deleteUserMicrotaskRelation(userId, microtaskId);

      return savedMicrotask;
    } catch (e) {
      if (e is DatabaseException || e is ValidationException) rethrow;
      throw DatabaseException('Erro ao remover voluntário: ${e.toString()}');
    }
  }

  /// Atualiza o status de uma microtask
  Future<MicrotaskModel> updateMicrotaskStatus(
    String microtaskId,
    MicrotaskStatus status,
  ) async {
    try {
      final microtask = await getMicrotaskById(microtaskId);
      if (microtask == null) {
        throw DatabaseException('Microtask não encontrada');
      }

      MicrotaskModel updatedMicrotask;
      switch (status) {
        case MicrotaskStatus.inProgress:
          updatedMicrotask = microtask.markAsStarted();
          break;
        case MicrotaskStatus.completed:
          updatedMicrotask = microtask.markAsCompleted();
          break;
        case MicrotaskStatus.cancelled:
          updatedMicrotask = microtask.markAsCancelled();
          break;
        default:
          updatedMicrotask = microtask.copyWith(
            status: status,
            updatedAt: DateTime.now(),
          );
      }

      return await updateMicrotask(updatedMicrotask);
    } catch (e) {
      if (e is DatabaseException || e is ValidationException) rethrow;
      throw DatabaseException(
        'Erro ao atualizar status da microtask: ${e.toString()}',
      );
    }
  }

  /// Deleta uma microtask
  Future<void> deleteMicrotask(String microtaskId) async {
    try {
      // Remove todas as relações usuário-microtask
      await _deleteAllUserMicrotaskRelations(microtaskId);

      // Remove a microtask
      await _microtasksCollection.doc(microtaskId).delete();
    } catch (e) {
      throw DatabaseException('Erro ao deletar microtask: ${e.toString()}');
    }
  }

  /// Deleta todas as microtasks de uma task
  Future<void> deleteMicrotasksByTaskId(String taskId) async {
    try {
      final microtasks = await getMicrotasksByTaskId(taskId);

      final batch = _firestore.batch();
      for (final microtask in microtasks) {
        // Decrementa o contador para cada voluntário atribuído
        for (final userId in microtask.assignedTo) {
          try {
            await _decrementVolunteerMicrotaskCount(microtask.eventId, userId);
          } catch (e) {
            // Log do erro, mas não interrompe o processo de deleção
            print('Erro ao decrementar contador para usuário $userId: $e');
          }
        }

        // Remove relações usuário-microtask
        await _deleteAllUserMicrotaskRelations(microtask.id);

        // Adiciona remoção da microtask ao batch
        batch.delete(_microtasksCollection.doc(microtask.id));
      }

      await batch.commit();
    } catch (e) {
      throw DatabaseException(
        'Erro ao deletar microtasks da task: ${e.toString()}',
      );
    }
  }

  /// Stream para escutar mudanças em uma microtask
  Stream<MicrotaskModel?> watchMicrotask(String microtaskId) {
    return _microtasksCollection.doc(microtaskId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return MicrotaskModel.fromFirestore(doc);
    });
  }

  /// Stream para escutar mudanças nas microtasks de uma task
  Stream<List<MicrotaskModel>> watchMicrotasksByTaskId(String taskId) {
    return _microtasksCollection
        .where('taskId', isEqualTo: taskId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MicrotaskModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Stream para escutar mudanças nas microtasks de um evento
  Stream<List<MicrotaskModel>> watchMicrotasksByEventId(String eventId) {
    return _microtasksCollection
        .where('eventId', isEqualTo: eventId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MicrotaskModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Cria uma relação usuário-microtask
  Future<void> _createUserMicrotaskRelation(
    String userId,
    String microtaskId,
    String eventId,
  ) async {
    try {
      final relationId = _uuid.v4();
      final now = DateTime.now();

      final userMicrotask = UserMicrotaskModel.create(
        id: relationId,
        userId: userId,
        microtaskId: microtaskId,
        eventId: eventId,
        assignedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      await _userMicrotasksCollection
          .doc(relationId)
          .set(userMicrotask.toFirestore());
      print('Relação usuário-microtask criada com sucesso!');
    } catch (e) {
      print('Erro ao criar relação usuário-microtask: ${e.toString()}');
      throw DatabaseException(
        'Erro ao criar relação usuário-microtask: ${e.toString()}',
      );
    }
  }

  /// Remove uma relação usuário-microtask específica
  Future<void> _deleteUserMicrotaskRelation(
    String userId,
    String microtaskId,
  ) async {
    try {
      final querySnapshot = await _userMicrotasksCollection
          .where('userId', isEqualTo: userId)
          .where('microtaskId', isEqualTo: microtaskId)
          .get();

      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw DatabaseException(
        'Erro ao remover relação usuário-microtask: ${e.toString()}',
      );
    }
  }

  /// Remove todas as relações usuário-microtask de uma microtask
  Future<void> _deleteAllUserMicrotaskRelations(String microtaskId) async {
    try {
      final querySnapshot = await _userMicrotasksCollection
          .where('microtaskId', isEqualTo: microtaskId)
          .get();

      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw DatabaseException(
        'Erro ao remover relações usuário-microtask: ${e.toString()}',
      );
    }
  }

  /// Decrementa o contador de microtasks atribuídas para um voluntário
  /// Implementação local para evitar dependência circular com EventService
  Future<void> _decrementVolunteerMicrotaskCount(
    String eventId,
    String userId,
  ) async {
    try {
      final profileQuery = await _firestore
          .collection('volunteer_profiles')
          .where('eventId', isEqualTo: eventId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (profileQuery.docs.isNotEmpty) {
        final doc = profileQuery.docs.first;
        final currentData = doc.data();

        // Verifica se o campo existe, se não, inicializa com contagem real
        int assignedCount;
        if (currentData.containsKey('assignedMicrotasksCount')) {
          assignedCount = currentData['assignedMicrotasksCount'] as int? ?? 0;
        } else {
          // Campo não existe, calcula a contagem real e inicializa
          assignedCount = await _calculateActualMicrotaskCount(eventId, userId);
        }

        await doc.reference.update({
          'assignedMicrotasksCount': assignedCount > 0 ? assignedCount - 1 : 0,
        });
      }
    } catch (e) {
      throw DatabaseException(
        'Erro ao decrementar contador de microtasks: ${e.toString()}',
      );
    }
  }

  /// Calcula a contagem real de microtasks atribuídas a um voluntário
  /// Implementação local para evitar dependência circular
  Future<int> _calculateActualMicrotaskCount(
    String eventId,
    String userId,
  ) async {
    try {
      final microtasksQuery = await _microtasksCollection
          .where('eventId', isEqualTo: eventId)
          .where('assignedTo', arrayContains: userId)
          .get();

      return microtasksQuery.docs.length;
    } catch (e) {
      // Em caso de erro, retorna 0 para não quebrar o fluxo
      print('Erro ao calcular contagem real de microtasks: $e');
      return 0;
    }
  }
}

```

### lib\data\services\task_service.dart

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Serviço responsável por operações relacionadas a tasks no Firebase
class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // Referência da coleção
  CollectionReference get _tasksCollection => _firestore.collection('tasks');

  /// Cria uma nova task
  Future<TaskModel> createTask({
    required String eventId,
    required String title,
    required String description,
    required TaskPriority priority,
    required String createdBy,
  }) async {
    try {
      // Gera um ID único para a task
      final taskId = _uuid.v4();
      final now = DateTime.now();

      // Cria a task com dados gerados pelo service
      final task = TaskModel.create(
        id: taskId,
        eventId: eventId,
        title: title,
        description: description,
        priority: priority,
        createdBy: createdBy,
        createdAt: now,
        updatedAt: now,
      );

      // Note: Validation should be done by repository/controller before calling service

      // Salva no Firestore
      await _tasksCollection.doc(taskId).set(task.toFirestore());

      return task;
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Erro ao criar task: ${e.toString()}');
    }
  }

  /// Busca uma task por ID
  Future<TaskModel?> getTaskById(String taskId) async {
    try {
      final doc = await _tasksCollection.doc(taskId).get();

      if (!doc.exists) return null;

      return TaskModel.fromFirestore(doc);
    } catch (e) {
      throw DatabaseException('Erro ao buscar task: ${e.toString()}');
    }
  }

  /*
  /// Busca todas as tasks de um evento
  Future<List<TaskModel>> getTasksByEventId(String eventId) async {
    try {
      final querySnapshot = await _tasksCollection
          .where('eventId', isEqualTo: eventId)
          .get();

      return querySnapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException(
        'Erro ao buscar tasks do evento: ${e.toString()}',
      );
    }
  }
  */

  Future<List<TaskModel>> getTasksByEventId(String eventId) async {
    try {
      final querySnapshot = await _tasksCollection
          .where('eventId', isEqualTo: eventId)
          .orderBy('createdAt', descending: true) // agora funciona
          .get();

      return querySnapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Erro ao buscar tasks do evento: ${e.toString()}');
      throw DatabaseException(
        'Erro ao buscar tasks do evento: ${e.toString()}',
      );
    }
  }

  /// Busca tasks criadas por um usuário específico
  Future<List<TaskModel>> getTasksByCreator(String userId) async {
    try {
      final querySnapshot = await _tasksCollection
          .where('createdBy', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException(
        'Erro ao buscar tasks do usuário: ${e.toString()}',
      );
    }
  }

  /// Busca tasks por status
  Future<List<TaskModel>> getTasksByStatus(
    String eventId,
    TaskStatus status,
  ) async {
    try {
      final querySnapshot = await _tasksCollection
          .where('eventId', isEqualTo: eventId)
          .where('status', isEqualTo: status.value)
          .orderBy('createdAt', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException(
        'Erro ao buscar tasks por status: ${e.toString()}',
      );
    }
  }

  /// Busca tasks por prioridade
  Future<List<TaskModel>> getTasksByPriority(
    String eventId,
    TaskPriority priority,
  ) async {
    try {
      final querySnapshot = await _tasksCollection
          .where('eventId', isEqualTo: eventId)
          .where('priority', isEqualTo: priority.value)
          .orderBy('createdAt', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException(
        'Erro ao buscar tasks por prioridade: ${e.toString()}',
      );
    }
  }

  /// Atualiza uma task
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      if (task.id.isEmpty) {
        throw ValidationException('ID da task é obrigatório para atualização');
      }

      // Note: Validation should be done by repository/controller before calling service

      // Atualiza o timestamp
      final updatedTask = task.withUpdatedTimestamp();

      // Salva no Firestore
      await _tasksCollection.doc(task.id).update(updatedTask.toFirestore());

      return updatedTask;
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Erro ao atualizar task: ${e.toString()}');
    }
  }

  /// Atualiza o status de uma task
  Future<TaskModel> updateTaskStatus(String taskId, TaskStatus status) async {
    try {
      final task = await getTaskById(taskId);
      if (task == null) {
        throw DatabaseException('Task não encontrada');
      }

      final updatedTask = task.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );

      return await updateTask(updatedTask);
    } catch (e) {
      if (e is DatabaseException || e is ValidationException) rethrow;
      throw DatabaseException(
        'Erro ao atualizar status da task: ${e.toString()}',
      );
    }
  }

  /// Atualiza os contadores de microtasks
  Future<TaskModel> updateMicrotaskCounters({
    required String taskId,
    required int microtaskCount,
    required int completedMicrotasks,
  }) async {
    try {
      final task = await getTaskById(taskId);
      if (task == null) {
        throw DatabaseException('Task não encontrada');
      }

      final updatedTask = task
          .copyWith(
            microtaskCount: microtaskCount,
            completedMicrotasks: completedMicrotasks,
            updatedAt: DateTime.now(),
          )
          .updateStatusFromMicrotasks();

      return await updateTask(updatedTask);
    } catch (e) {
      if (e is DatabaseException || e is ValidationException) rethrow;
      throw DatabaseException(
        'Erro ao atualizar contadores da task: ${e.toString()}',
      );
    }
  }

  /// Incrementa o contador de microtasks
  Future<TaskModel> incrementMicrotaskCount(String taskId) async {
    try {
      final task = await getTaskById(taskId);
      if (task == null) {
        throw DatabaseException('Task não encontrada');
      }

      final updatedTask = task.incrementMicrotaskCount();
      return await updateTask(updatedTask);
    } catch (e) {
      if (e is DatabaseException || e is ValidationException) rethrow;
      throw DatabaseException(
        'Erro ao incrementar contador de microtasks: ${e.toString()}',
      );
    }
  }

  /// Decrementa o contador de microtasks
  Future<TaskModel> decrementMicrotaskCount(String taskId) async {
    try {
      final task = await getTaskById(taskId);
      if (task == null) {
        throw DatabaseException('Task não encontrada');
      }

      final updatedTask = task.decrementMicrotaskCount();
      return await updateTask(updatedTask);
    } catch (e) {
      if (e is DatabaseException || e is ValidationException) rethrow;
      throw DatabaseException(
        'Erro ao decrementar contador de microtasks: ${e.toString()}',
      );
    }
  }

  /// Incrementa o contador de microtasks concluídas
  Future<TaskModel> incrementCompletedMicrotasks(String taskId) async {
    try {
      final task = await getTaskById(taskId);
      if (task == null) {
        throw DatabaseException('Task não encontrada');
      }

      final updatedTask = task
          .incrementCompletedMicrotasks()
          .updateStatusFromMicrotasks();
      return await updateTask(updatedTask);
    } catch (e) {
      if (e is DatabaseException || e is ValidationException) rethrow;
      throw DatabaseException(
        'Erro ao incrementar microtasks concluídas: ${e.toString()}',
      );
    }
  }

  /// Decrementa o contador de microtasks concluídas
  Future<TaskModel> decrementCompletedMicrotasks(String taskId) async {
    try {
      final task = await getTaskById(taskId);
      if (task == null) {
        throw DatabaseException('Task não encontrada');
      }

      final updatedTask = task
          .decrementCompletedMicrotasks()
          .updateStatusFromMicrotasks();
      return await updateTask(updatedTask);
    } catch (e) {
      if (e is DatabaseException || e is ValidationException) rethrow;
      throw DatabaseException(
        'Erro ao decrementar microtasks concluídas: ${e.toString()}',
      );
    }
  }

  /// Deleta uma task
  Future<void> deleteTask(String taskId) async {
    try {
      await _tasksCollection.doc(taskId).delete();
    } catch (e) {
      throw DatabaseException('Erro ao deletar task: ${e.toString()}');
    }
  }

  /// Deleta todas as tasks de um evento
  Future<void> deleteTasksByEventId(String eventId) async {
    try {
      final querySnapshot = await _tasksCollection
          .where('eventId', isEqualTo: eventId)
          .get();

      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw DatabaseException(
        'Erro ao deletar tasks do evento: ${e.toString()}',
      );
    }
  }

  /// Stream para escutar mudanças em uma task
  Stream<TaskModel?> watchTask(String taskId) {
    return _tasksCollection.doc(taskId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return TaskModel.fromFirestore(doc);
    });
  }

  /// Stream para escutar mudanças nas tasks de um evento
  Stream<List<TaskModel>> watchTasksByEventId(String eventId) {
    return _tasksCollection
        .where('eventId', isEqualTo: eventId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList(),
        );
  }

  /// Busca tasks com filtros múltiplos
  Future<List<TaskModel>> getTasksWithFilters({
    required String eventId,
    TaskStatus? status,
    TaskPriority? priority,
    String? createdBy,
  }) async {
    try {
      Query query = _tasksCollection.where('eventId', isEqualTo: eventId);

      if (status != null) {
        query = query.where('status', isEqualTo: status.value);
      }

      if (priority != null) {
        query = query.where('priority', isEqualTo: priority.value);
      }

      if (createdBy != null && createdBy.isNotEmpty) {
        query = query.where('createdBy', isEqualTo: createdBy);
      }

      // Removido orderBy temporariamente para evitar problemas de índice
      query = query.orderBy('createdAt', descending: false);

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException(
        'Erro ao buscar tasks com filtros: ${e.toString()}',
      );
    }
  }
}

```

### lib\data\services\user_service.dart

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../models/user_model.dart';

/// Serviço responsável por operações relacionadas a usuários
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _usersCollection;

  UserService() {
    _usersCollection = _firestore.collection('users');
  }

  /// Busca um usuário pelo ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }

      final doc = await _usersCollection.doc(userId).get();
      
      if (!doc.exists) {
        return null;
      }

      return UserModel.fromFirestore(doc);
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Erro ao buscar usuário: ${e.toString()}');
    }
  }

  /// Busca múltiplos usuários pelos IDs
  Future<List<UserModel>> getUsersByIds(List<String> userIds) async {
    try {
      if (userIds.isEmpty) {
        return [];
      }

      // Remove IDs duplicados e vazios
      final cleanIds = userIds.where((id) => id.isNotEmpty).toSet().toList();
      
      if (cleanIds.isEmpty) {
        return [];
      }

      // Firestore tem limite de 10 itens por consulta 'in'
      // Vamos dividir em chunks se necessário
      final users = <UserModel>[];
      const chunkSize = 10;
      
      for (int i = 0; i < cleanIds.length; i += chunkSize) {
        final chunk = cleanIds.skip(i).take(chunkSize).toList();
        
        final querySnapshot = await _usersCollection
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        
        final chunkUsers = querySnapshot.docs
            .map((doc) => UserModel.fromFirestore(doc))
            .toList();
        
        users.addAll(chunkUsers);
      }

      return users;
    } catch (e) {
      throw DatabaseException('Erro ao buscar usuários: ${e.toString()}');
    }
  }

  /// Busca usuários por email (para busca/filtro)
  Future<List<UserModel>> searchUsersByEmail(String emailQuery) async {
    try {
      if (emailQuery.isEmpty) {
        return [];
      }

      // Busca por email que comece com o termo
      final querySnapshot = await _usersCollection
          .where('email', isGreaterThanOrEqualTo: emailQuery.toLowerCase())
          .where('email', isLessThan: '${emailQuery.toLowerCase()}z')
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException('Erro ao buscar usuários por email: ${e.toString()}');
    }
  }

  /// Busca usuários por nome (para busca/filtro)
  Future<List<UserModel>> searchUsersByName(String nameQuery) async {
    try {
      if (nameQuery.isEmpty) {
        return [];
      }

      // Busca por nome que comece com o termo
      final querySnapshot = await _usersCollection
          .where('name', isGreaterThanOrEqualTo: nameQuery)
          .where('name', isLessThan: '${nameQuery}z')
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException('Erro ao buscar usuários por nome: ${e.toString()}');
    }
  }

  /// Atualiza informações do usuário
  Future<UserModel> updateUser(UserModel user) async {
    try {
      final validationErrors = user.validate();
      if (validationErrors.isNotEmpty) {
        throw ValidationException(
          'Dados inválidos: ${validationErrors.join(', ')}',
        );
      }

      await _usersCollection.doc(user.id).update(user.toFirestore());
      
      return user;
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Erro ao atualizar usuário: ${e.toString()}');
    }
  }

  /// Cria ou atualiza um usuário
  Future<UserModel> createOrUpdateUser(UserModel user) async {
    try {
      final validationErrors = user.validate();
      if (validationErrors.isNotEmpty) {
        throw ValidationException(
          'Dados inválidos: ${validationErrors.join(', ')}',
        );
      }

      await _usersCollection.doc(user.id).set(user.toFirestore(), SetOptions(merge: true));
      
      return user;
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Erro ao criar/atualizar usuário: ${e.toString()}');
    }
  }

  /// Verifica se um usuário existe
  Future<bool> userExists(String userId) async {
    try {
      if (userId.isEmpty) {
        return false;
      }

      final doc = await _usersCollection.doc(userId).get();
      return doc.exists;
    } catch (e) {
      throw DatabaseException('Erro ao verificar existência do usuário: ${e.toString()}');
    }
  }

  /// Stream para monitorar mudanças em um usuário
  Stream<UserModel?> watchUser(String userId) {
    if (userId.isEmpty) {
      return Stream.value(null);
    }

    return _usersCollection
        .doc(userId)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return null;
          return UserModel.fromFirestore(doc);
        });
  }

  /// Busca usuários recentes (últimos cadastrados)
  Future<List<UserModel>> getRecentUsers({int limit = 10}) async {
    try {
      final querySnapshot = await _usersCollection
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException('Erro ao buscar usuários recentes: ${e.toString()}');
    }
  }
}

```

### lib\firebase_options.dart

```dart
// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC5gDe0YhtXoinP2Zb5NkJBDOBOITzEtck',
    appId: '1:407007104181:web:e47996ce88ac6067d942fc',
    messagingSenderId: '407007104181',
    projectId: 'contask-52156',
    authDomain: 'contask-52156.firebaseapp.com',
    storageBucket: 'contask-52156.firebasestorage.app',
    measurementId: 'G-JY0KQ9T96E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyByenvoJbzLpxtG8J1omzZ5R1Y4JhVnPK8',
    appId: '1:407007104181:android:5deaa18342a8bb50d942fc',
    messagingSenderId: '407007104181',
    projectId: 'contask-52156',
    storageBucket: 'contask-52156.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDx90MacKn-KCQQYVac0VKEtD6s0HkT24I',
    appId: '1:407007104181:ios:1d95291a2dc4a755d942fc',
    messagingSenderId: '407007104181',
    projectId: 'contask-52156',
    storageBucket: 'contask-52156.firebasestorage.app',
    iosClientId: '407007104181-4rhd2d3mhu8j35rq9ehbuj3r4lov2jva.apps.googleusercontent.com',
    iosBundleId: 'com.example.contask',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDx90MacKn-KCQQYVac0VKEtD6s0HkT24I',
    appId: '1:407007104181:ios:1d95291a2dc4a755d942fc',
    messagingSenderId: '407007104181',
    projectId: 'contask-52156',
    storageBucket: 'contask-52156.firebasestorage.app',
    iosClientId: '407007104181-4rhd2d3mhu8j35rq9ehbuj3r4lov2jva.apps.googleusercontent.com',
    iosBundleId: 'com.example.contask',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC5gDe0YhtXoinP2Zb5NkJBDOBOITzEtck',
    appId: '1:407007104181:web:54e10aaa1ec1c479d942fc',
    messagingSenderId: '407007104181',
    projectId: 'contask-52156',
    authDomain: 'contask-52156.firebaseapp.com',
    storageBucket: 'contask-52156.firebasestorage.app',
    measurementId: 'G-EWHDP21GD0',
  );

}
```

### lib\main.dart

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/controllers/event_controller.dart';
import 'presentation/controllers/task_controller.dart';
import 'presentation/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ConTaskApp());
}

class ConTaskApp extends StatelessWidget {
  const ConTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthController()..initialize(),
        ),
        ChangeNotifierProvider(create: (context) => EventController()),
        ChangeNotifierProvider(create: (context) => TaskController()),
      ],
      child: Consumer<AuthController>(
        builder: (context, authController, child) {
          return MaterialApp(
            title: 'ConTask',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,

            // Configuração de rotas
            initialRoute: _getInitialRoute(authController),
            routes: AppRoutes.routes,
            onGenerateRoute: AppRoutes.onGenerateRoute,

            // Builder para interceptar mudanças de autenticação
            builder: (context, child) {
              return _AuthWrapper(child: child!);
            },
          );
        },
      ),
    );
  }

  String _getInitialRoute(AuthController authController) {
    // Se está autenticado, vai para home, senão vai para login
    if (authController.isAuthenticated) {
      return AppRoutes.home;
    }
    return AppRoutes.login;
  }
}

/// Widget que monitora mudanças de autenticação e redireciona conforme necessário
class _AuthWrapper extends StatefulWidget {
  final Widget child;

  const _AuthWrapper({required this.child});

  @override
  State<_AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<_AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, _) {
        // Monitora mudanças no estado de autenticação apenas após o build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          final navigator = Navigator.maybeOf(context);
          if (navigator == null) return;

          final currentRoute = ModalRoute.of(context)?.settings.name;

          if (authController.isAuthenticated &&
              currentRoute == AppRoutes.login) {
            // Se está autenticado mas na tela de login, vai para home
            navigator.pushReplacementNamed(AppRoutes.home);
          } else if (authController.isUnauthenticated &&
              currentRoute != AppRoutes.login &&
              currentRoute != AppRoutes.register) {
            // Se não está autenticado mas não está na tela de login/cadastro, vai para login
            navigator.pushNamedAndRemoveUntil(
              AppRoutes.login,
              (route) => false,
            );
          }
        });

        return widget.child;
      },
    );
  }
}

```

### lib\presentation\controllers\auth_controller.dart

```dart
import 'package:flutter/foundation.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

/// Estados possíveis da autenticação
enum AuthState { initial, loading, authenticated, unauthenticated, error }

/// Controller responsável por gerenciar o estado de autenticação
/// Usa Provider para notificar mudanças na UI
class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  // Estado atual
  AuthState _state = AuthState.initial;
  UserModel? _currentUser;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  AuthState get state => _state;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated =>
      _state == AuthState.authenticated && _currentUser != null;
  bool get isUnauthenticated => _state == AuthState.unauthenticated;

  /// Inicializa o controller e monitora mudanças de autenticação
  void initialize() {
    _authRepository.authStateChanges.listen(
      (user) {
        _currentUser = user;
        if (user != null) {
          _setState(AuthState.authenticated);
        } else {
          _setState(AuthState.unauthenticated);
        }
      },
      onError: (error) {
        _setError('Erro ao monitorar autenticação: ${error.toString()}');
      },
    );
  }

  /// Faz login com email e senha
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final user = await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _currentUser = user;
      _setState(AuthState.authenticated);
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado durante o login');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Cria uma nova conta com email e senha
  Future<bool> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final user = await _authRepository.createUserWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );

      _currentUser = user;
      _setState(AuthState.authenticated);
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado durante o cadastro');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Faz login com Google
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();

      final user = await _authRepository.signInWithGoogle();

      _currentUser = user;
      _setState(AuthState.authenticated);
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado durante o login com Google');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Faz logout
  Future<void> signOut() async {
    try {
      _setLoading(true);
      _clearError();

      await _authRepository.signOut();

      _currentUser = null;
      _setState(AuthState.unauthenticated);
    } on AuthException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Erro inesperado durante o logout');
    } finally {
      _setLoading(false);
    }
  }

  /// Envia email de redefinição de senha
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      _setLoading(true);
      _clearError();

      await _authRepository.sendPasswordResetEmail(email);
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado ao enviar email de redefinição');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Atualiza os dados do usuário
  Future<bool> updateUser(UserModel updatedUser) async {
    try {
      _setLoading(true);
      _clearError();

      final user = await _authRepository.updateUser(updatedUser);
      _currentUser = user;
      notifyListeners();
      return true;
    } on FirestoreException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado ao atualizar usuário');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Deleta a conta do usuário
  Future<bool> deleteAccount() async {
    try {
      _setLoading(true);
      _clearError();

      await _authRepository.deleteAccount();

      _currentUser = null;
      _setState(AuthState.unauthenticated);
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado ao deletar conta');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Envia email de verificação
  Future<bool> sendEmailVerification() async {
    try {
      _setLoading(true);
      _clearError();

      await _authRepository.sendEmailVerification();
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado ao enviar verificação de email');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Recarrega os dados do usuário atual
  Future<void> refreshUser() async {
    try {
      if (_currentUser == null) return;

      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro ao recarregar usuário: $e');
    }
  }

  /// Verifica se um email já está em uso
  Future<bool> isEmailInUse(String email) async {
    try {
      return await _authRepository.isEmailInUse(email);
    } catch (e) {
      debugPrint('Erro ao verificar email: $e');
      return false;
    }
  }

  /// Define o estado de loading
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Define um erro
  void _setError(String error) {
    _errorMessage = error;
    _state = AuthState.error;
    notifyListeners();
  }

  /// Limpa o erro atual
  void _clearError() {
    _errorMessage = null;
    if (_state == AuthState.error) {
      _state = _currentUser != null
          ? AuthState.authenticated
          : AuthState.unauthenticated;
    }
    notifyListeners();
  }

  /// Define o estado atual
  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Limpa o erro manualmente (para ser chamado da UI)
  void clearError() {
    _clearError();
  }

  /// Verifica se o email está verificado
  bool get isEmailVerified => _authRepository.isEmailVerified;

  /// Retorna informações básicas do usuário para debug
  Map<String, dynamic>? get userInfo {
    if (_currentUser == null) return null;

    return {
      'id': _currentUser!.id,
      'name': _currentUser!.name,
      'email': _currentUser!.email,
      'hasPhoto': _currentUser!.hasPhoto,
      'isNewUser': _currentUser!.isNewUser,
    };
  }

  /// Método para validar dados antes de operações
  bool _validateUserData({String? name, String? email, String? password}) {
    if (name != null && name.trim().isEmpty) {
      _setError('Nome é obrigatório');
      return false;
    }

    if (email != null && email.trim().isEmpty) {
      _setError('E-mail é obrigatório');
      return false;
    }

    if (email != null && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _setError('E-mail inválido');
      return false;
    }

    if (password != null && password.length < 6) {
      _setError('Senha deve ter pelo menos 6 caracteres');
      return false;
    }

    return true;
  }

  /// Método de conveniência para login com validação
  Future<bool> signInWithValidation({
    required String email,
    required String password,
  }) async {
    if (!_validateUserData(email: email, password: password)) {
      return false;
    }

    return await signInWithEmailAndPassword(email: email, password: password);
  }

  /// Método de conveniência para cadastro com validação
  Future<bool> createUserWithValidation({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!_validateUserData(name: name, email: email, password: password)) {
      return false;
    }

    return await createUserWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
    );
  }
}

```

### lib\presentation\controllers\event_controller.dart

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../../data/models/event_model.dart';
import '../../data/models/user_model.dart';
import '../../data/models/volunteer_profile_model.dart';
import '../../data/repositories/event_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Controller responsável por gerenciar o estado dos eventos
class EventController extends ChangeNotifier {
  final EventRepository _eventRepository;
  final UserRepository _userRepository;

  EventController({
    EventRepository? eventRepository,
    UserRepository? userRepository,
  }) : _eventRepository = eventRepository ?? EventRepository(),
       _userRepository = userRepository ?? UserRepository();

  // Estados de loading
  bool _isLoading = false;
  bool _isCreatingEvent = false;
  bool _isJoiningEvent = false;
  bool _isLoadingUserEvents = false;

  // Dados
  List<EventModel> _userEvents = [];
  EventModel? _currentEvent;
  EventModel? _searchedEvent;
  List<VolunteerProfileModel> _eventVolunteers = [];
  final List<UserModel> _eventVolunteerUsers = [];
  String? _errorMessage;

  // Cache para perfis de voluntários por evento
  final Map<String, List<VolunteerProfileModel>> _volunteersCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiration = Duration(minutes: 5);

  // Getters
  bool get isLoading => _isLoading;
  bool get isCreatingEvent => _isCreatingEvent;
  bool get isJoiningEvent => _isJoiningEvent;
  bool get isLoadingUserEvents => _isLoadingUserEvents;
  List<EventModel> get userEvents => List.unmodifiable(_userEvents);
  EventModel? get currentEvent => _currentEvent;
  EventModel? get searchedEvent => _searchedEvent;
  List<VolunteerProfileModel> get eventVolunteers =>
      List.unmodifiable(_eventVolunteers);
  List<UserModel> get eventVolunteerUsers =>
      List.unmodifiable(_eventVolunteerUsers);
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Limpa mensagens de erro
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Define uma mensagem de erro
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Cria um novo evento
  Future<EventModel?> createEvent({
    required String name,
    required String description,
    required String location,
    required String createdBy,
    required List<String> requiredSkills,
    required List<String> requiredResources,
  }) async {
    _isCreatingEvent = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Validações básicas
      if (name.trim().isEmpty) {
        throw ValidationException('Nome do evento é obrigatório');
      }
      if (location.trim().isEmpty) {
        throw ValidationException('Localização é obrigatória');
      }
      if (createdBy.isEmpty) {
        throw ValidationException('Usuário criador é obrigatório');
      }

      final event = await _eventRepository.createEvent(
        name: name,
        description: description,
        location: location,
        createdBy: createdBy,
        requiredSkills: requiredSkills,
        requiredResources: requiredResources,
      );

      // Adiciona o evento à lista de eventos do usuário
      _userEvents.insert(0, event);
      _currentEvent = event;

      return event;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return null;
    } finally {
      _isCreatingEvent = false;
      notifyListeners();
    }
  }

  /// Busca um evento por tag
  Future<EventModel?> searchEventByTag(String tag) async {
    _isLoading = true;
    _errorMessage = null;
    _searchedEvent = null;
    notifyListeners();

    try {
      if (tag.trim().isEmpty) {
        throw ValidationException('Código do evento é obrigatório');
      }

      if (!_eventRepository.isValidTag(tag)) {
        throw ValidationException(
          'Código deve ter exatamente 6 caracteres (letras e números)',
        );
      }

      final event = await _eventRepository.getEventByTag(tag);

      if (event == null) {
        throw NotFoundException('Evento não encontrado com o código informado');
      }

      _searchedEvent = event;
      return event;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Participa de um evento
  Future<bool> joinEvent({
    required String eventId,
    required String userId,
    required List<String> availableDays,
    required TimeRange availableHours,
    bool isFullTimeAvailable = false,
    required List<String> skills,
    required List<String> resources,
  }) async {
    _isJoiningEvent = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Validações básicas
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }
      if (userId.isEmpty) {
        throw ValidationException('Usuário é obrigatório');
      }
      if (!isFullTimeAvailable && availableDays.isEmpty) {
        throw ValidationException(
          'Selecione pelo menos um dia de disponibilidade',
        );
      }
      if (!availableHours.isValid()) {
        throw ValidationException('Horário de disponibilidade inválido');
      }

      final updatedEvent = await _eventRepository.joinEvent(
        eventId: eventId,
        userId: userId,
        availableDays: availableDays,
        availableHours: availableHours,
        isFullTimeAvailable: isFullTimeAvailable,
        skills: skills,
        resources: resources,
      );

      // Atualiza a lista de eventos do usuário
      final index = _userEvents.indexWhere((e) => e.id == eventId);
      if (index >= 0) {
        _userEvents[index] = updatedEvent;
      } else {
        _userEvents.insert(0, updatedEvent);
      }

      // Atualiza o evento atual se for o mesmo
      if (_currentEvent?.id == eventId) {
        _currentEvent = updatedEvent;
      }

      // Atualiza o evento pesquisado se for o mesmo
      if (_searchedEvent?.id == eventId) {
        _searchedEvent = updatedEvent;
      }

      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _isJoiningEvent = false;
      notifyListeners();
    }
  }

  /// Carrega os eventos do usuário
  Future<void> loadUserEvents(String userId) async {
    _isLoadingUserEvents = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }

      final events = await _eventRepository.getUserEvents(userId);
      _userEvents = events;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _userEvents = [];
    } finally {
      _isLoadingUserEvents = false;
      notifyListeners();
    }
  }

  /// Carrega um evento específico
  Future<EventModel?> loadEvent(String eventId) async {
    if (_isLoading) {
      return _currentEvent; // Evita múltiplas chamadas simultâneas
    }

    _isLoading = true;
    _errorMessage = null;

    // Usar WidgetsBinding para evitar setState durante build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      final event = await _eventRepository.getEventById(eventId);

      if (event == null) {
        throw NotFoundException('Evento não encontrado');
      }

      _currentEvent = event;
      return event;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return null;
    } finally {
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  /// Carrega os voluntários de um evento
  Future<void> loadEventVolunteers(String eventId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      // Carrega os perfis dos voluntários
      final volunteers = await _eventRepository.getEventVolunteers(eventId);
      _eventVolunteers = volunteers;

      // Carrega os dados dos usuários
      final userIds = volunteers.map((v) => v.userId).toList();
      if (userIds.isNotEmpty) {
        final users = await _userRepository.getUsersByIds(userIds);
        _eventVolunteerUsers.clear();
        _eventVolunteerUsers.addAll(users);
      } else {
        _eventVolunteerUsers.clear();
      }
    } catch (e) {
      _setError(_getErrorMessage(e));
      _eventVolunteers = [];
      _eventVolunteerUsers.clear();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Busca um voluntário específico com seus dados completos
  Future<UserModel?> getVolunteerUser(String userId) async {
    try {
      if (userId.isEmpty) {
        return null;
      }

      return await _userRepository.getUserById(userId);
    } catch (e) {
      _setError(_getErrorMessage(e));
      return null;
    }
  }

  /// Busca o perfil de um voluntário específico
  Future<VolunteerProfileModel?> getVolunteerProfile(
    String userId,
    String eventId,
  ) async {
    try {
      if (userId.isEmpty || eventId.isEmpty) {
        return null;
      }

      return await _eventRepository.getVolunteerProfile(userId, eventId);
    } catch (e) {
      _setError(_getErrorMessage(e));
      return null;
    }
  }

  /// Busca dados completos de voluntários (usuários + perfis) para um evento
  Future<Map<String, dynamic>> getEventVolunteersWithUsers(
    String eventId,
  ) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      // Carrega os perfis dos voluntários
      final profiles = await _eventRepository.getEventVolunteers(eventId);

      // Carrega os dados dos usuários
      final userIds = profiles.map((p) => p.userId).toList();
      final users = userIds.isNotEmpty
          ? await _userRepository.getUsersByIds(userIds)
          : <UserModel>[];

      return {'profiles': profiles, 'users': users};
    } catch (e) {
      _setError(_getErrorMessage(e));
      return {'profiles': <VolunteerProfileModel>[], 'users': <UserModel>[]};
    }
  }

  /// Busca dados de voluntários otimizado (com cache e dados denormalizados)
  Future<List<VolunteerProfileModel>> getEventVolunteersOptimized(
    String eventId,
  ) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      // Verifica se tem dados válidos no cache
      if (_isCacheValid(eventId)) {
        return List.from(_volunteersCache[eventId]!);
      }

      // Busca os perfis de voluntários (com dados denormalizados)
      final profiles = await _eventRepository.getEventVolunteers(eventId);

      // Atualiza o cache
      _volunteersCache[eventId] = List.from(profiles);
      _cacheTimestamps[eventId] = DateTime.now();

      return profiles;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return <VolunteerProfileModel>[];
    }
  }

  /// Verifica se o cache é válido para um evento
  bool _isCacheValid(String eventId) {
    if (!_volunteersCache.containsKey(eventId) ||
        !_cacheTimestamps.containsKey(eventId)) {
      return false;
    }

    final cacheTime = _cacheTimestamps[eventId]!;
    final now = DateTime.now();
    return now.difference(cacheTime) < _cacheExpiration;
  }

  /// Limpa o cache de voluntários para um evento específico
  void clearVolunteersCache(String eventId) {
    _volunteersCache.remove(eventId);
    _cacheTimestamps.remove(eventId);
  }

  /// Limpa todo o cache de voluntários
  void clearAllVolunteersCache() {
    _volunteersCache.clear();
    _cacheTimestamps.clear();
  }

  /// Promove um voluntário a gerenciador
  Future<bool> promoteVolunteer(
    String eventId,
    String userId,
    String managerId,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedEvent = await _eventRepository.promoteVolunteer(
        eventId,
        userId,
        managerId,
      );

      // Atualiza o evento na lista
      final index = _userEvents.indexWhere((e) => e.id == eventId);
      if (index >= 0) {
        _userEvents[index] = updatedEvent;
      }

      // Atualiza o evento atual se for o mesmo
      if (_currentEvent?.id == eventId) {
        _currentEvent = updatedEvent;
      }

      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Verifica se um usuário pode gerenciar um evento
  Future<bool> canManageEvent(String eventId, String userId) async {
    try {
      return await _eventRepository.canManageEvent(eventId, userId);
    } catch (e) {
      return false;
    }
  }

  /// Verifica se um usuário é participante de um evento
  Future<bool> isParticipant(String eventId, String userId) async {
    try {
      return await _eventRepository.isParticipant(eventId, userId);
    } catch (e) {
      return false;
    }
  }

  /// Limpa o evento pesquisado
  void clearSearchedEvent() {
    _searchedEvent = null;
    notifyListeners();
  }

  /// Define o evento atual
  void setCurrentEvent(EventModel? event) {
    _currentEvent = event;
    notifyListeners();
  }

  /// Atualiza um evento na lista
  void updateEventInList(EventModel updatedEvent) {
    final index = _userEvents.indexWhere((e) => e.id == updatedEvent.id);
    if (index >= 0) {
      _userEvents[index] = updatedEvent;
      notifyListeners();
    }
  }

  /// Remove um evento da lista
  void removeEventFromList(String eventId) {
    _userEvents.removeWhere((e) => e.id == eventId);

    if (_currentEvent?.id == eventId) {
      _currentEvent = null;
    }

    if (_searchedEvent?.id == eventId) {
      _searchedEvent = null;
    }

    notifyListeners();
  }

  /// Promove um voluntário a gerente do evento
  Future<bool> promoteVolunteerToManager({
    required String eventId,
    required String volunteerId,
    required String managerId,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Promove o voluntário
      final updatedEvent = await _eventRepository.promoteVolunteer(
        eventId,
        volunteerId,
        managerId,
      );

      // Atualiza o evento atual se for o mesmo
      if (_currentEvent?.id == eventId) {
        _currentEvent = updatedEvent;
      }

      // Atualiza a lista de eventos do usuário
      final eventIndex = _userEvents.indexWhere((e) => e.id == eventId);
      if (eventIndex != -1) {
        _userEvents[eventIndex] = updatedEvent;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  /// Incrementa o contador de microtasks atribuídas para um voluntário
  Future<bool> incrementVolunteerMicrotaskCount(
    String eventId,
    String userId,
  ) async {
    try {
      await _eventRepository.incrementVolunteerMicrotaskCount(eventId, userId);

      // Atualiza o perfil local se disponível
      final profileIndex = _eventVolunteers.indexWhere(
        (p) => p.userId == userId,
      );
      if (profileIndex != -1) {
        _eventVolunteers[profileIndex] = _eventVolunteers[profileIndex]
            .incrementAssignedMicrotasks();
        notifyListeners();
      }

      return true;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  /// Decrementa o contador de microtasks atribuídas para um voluntário
  Future<bool> decrementVolunteerMicrotaskCount(
    String eventId,
    String userId,
  ) async {
    try {
      await _eventRepository.decrementVolunteerMicrotaskCount(eventId, userId);

      // Atualiza o perfil local se disponível
      final profileIndex = _eventVolunteers.indexWhere(
        (p) => p.userId == userId,
      );
      if (profileIndex != -1) {
        _eventVolunteers[profileIndex] = _eventVolunteers[profileIndex]
            .decrementAssignedMicrotasks();
        notifyListeners();
      }

      return true;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  /// Converte exceções em mensagens de erro amigáveis
  String _getErrorMessage(dynamic error) {
    if (error is ValidationException) {
      return error.message;
    } else if (error is NotFoundException) {
      return error.message;
    } else if (error is UnauthorizedException) {
      return error.message;
    } else if (error is DatabaseException) {
      return 'Erro de conexão. Tente novamente.';
    } else if (error is RepositoryException) {
      return 'Erro interno. Tente novamente.';
    } else {
      return 'Erro inesperado. Tente novamente.';
    }
  }

  /// Migra perfis de voluntários existentes para incluir o campo assignedMicrotasksCount
  Future<bool> migrateVolunteerProfilesTaskCounts() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _eventRepository.migrateVolunteerProfilesTaskCounts();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  /// Recalcula e corrige o contador de microtasks para um voluntário específico
  Future<bool> recalculateVolunteerMicrotaskCount(
    String eventId,
    String userId,
  ) async {
    try {
      await _eventRepository.recalculateVolunteerMicrotaskCount(
        eventId,
        userId,
      );

      // Atualiza o perfil local se disponível
      final profileIndex = _eventVolunteers.indexWhere(
        (p) => p.userId == userId,
      );
      if (profileIndex != -1) {
        // Recarrega o perfil atualizado
        final updatedProfile = await _eventRepository.getVolunteerProfile(
          userId,
          eventId,
        );
        if (updatedProfile != null) {
          _eventVolunteers[profileIndex] = updatedProfile;
          notifyListeners();
        }
      }

      return true;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  /// Recalcula os contadores para todos os voluntários de um evento
  Future<bool> recalculateEventVolunteerCounts(String eventId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _eventRepository.recalculateEventVolunteerCounts(eventId);

      // Recarrega os perfis de voluntários do evento
      await loadEventVolunteers(eventId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  /// Limpa todos os dados
  void clear() {
    _userEvents.clear();
    _currentEvent = null;
    _searchedEvent = null;
    _eventVolunteers.clear();
    _errorMessage = null;
    _isLoading = false;
    _isCreatingEvent = false;
    _isJoiningEvent = false;
    _isLoadingUserEvents = false;
    clearAllVolunteersCache();
    notifyListeners();
  }
}

```

### lib\presentation\controllers\task_controller.dart

```dart
import 'package:flutter/foundation.dart';
import '../../data/models/task_model.dart';
import '../../data/models/microtask_model.dart';
import '../../data/models/user_microtask_model.dart';
import '../../data/models/volunteer_profile_model.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/repositories/microtask_repository.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Estados possíveis do controller de tasks
enum TaskControllerState { initial, loading, loaded, error }

/// Controller responsável por gerenciar o estado das tasks e microtasks
class TaskController extends ChangeNotifier {
  final TaskRepository _taskRepository;
  final MicrotaskRepository _microtaskRepository;

  TaskController({
    TaskRepository? taskRepository,
    MicrotaskRepository? microtaskRepository,
  }) : _taskRepository = taskRepository ?? TaskRepository(),
       _microtaskRepository = microtaskRepository ?? MicrotaskRepository();

  // Estado atual
  TaskControllerState _state = TaskControllerState.initial;
  String? _errorMessage;
  bool _isLoading = false;

  // Dados das tasks
  List<TaskModel> _tasks = [];
  final Map<String, List<MicrotaskModel>> _microtasksByTask = {};
  final Map<String, List<UserMicrotaskModel>> _userMicrotasksByMicrotask = {};

  // Filtros
  TaskStatus? _statusFilter;
  TaskPriority? _priorityFilter;
  String? _creatorFilter;
  MicrotaskStatus? _microtaskStatusFilter;

  // Getters
  TaskControllerState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  List<TaskModel> get tasks => List.unmodifiable(_tasks);
  Map<String, List<MicrotaskModel>> get microtasksByTask =>
      Map.unmodifiable(_microtasksByTask);
  Map<String, List<UserMicrotaskModel>> get userMicrotasksByMicrotask =>
      Map.unmodifiable(_userMicrotasksByMicrotask);

  // Getters de filtros
  TaskStatus? get statusFilter => _statusFilter;
  TaskPriority? get priorityFilter => _priorityFilter;
  String? get creatorFilter => _creatorFilter;
  MicrotaskStatus? get microtaskStatusFilter => _microtaskStatusFilter;

  /// Carrega todas as tasks de um evento
  Future<void> loadTasksByEventId(String eventId) async {
    try {
      _setLoading(true);
      _clearError();

      final tasks = await _taskRepository.getTasksByEventId(eventId);
      _tasks = tasks;

      // Carrega microtasks para cada task
      await _loadMicrotasksForTasks();

      _setState(TaskControllerState.loaded);
    } on AppException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Erro inesperado ao carregar tasks');
    } finally {
      _setLoading(false);
    }
  }

  /// Carrega tasks com filtros
  Future<void> loadTasksWithFilters({
    required String eventId,
    TaskStatus? status,
    TaskPriority? priority,
    String? createdBy,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      _statusFilter = status;
      _priorityFilter = priority;
      _creatorFilter = createdBy;

      final tasks = await _taskRepository.getTasksWithFilters(
        eventId: eventId,
        status: status,
        priority: priority,
        createdBy: createdBy,
      );
      _tasks = tasks;

      // Carrega microtasks para cada task
      await _loadMicrotasksForTasks();

      _setState(TaskControllerState.loaded);
    } on AppException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Erro inesperado ao carregar tasks com filtros');
    } finally {
      _setLoading(false);
    }
  }

  /// Cria uma nova task
  Future<bool> createTask({
    required String eventId,
    required String title,
    required String description,
    required TaskPriority priority,
    required String createdBy,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final task = await _taskRepository.createTask(
        eventId: eventId,
        title: title,
        description: description,
        priority: priority,
        createdBy: createdBy,
      );

      // Adiciona à lista local
      _tasks.add(task);
      _microtasksByTask[task.id] = [];

      _setState(TaskControllerState.loaded);
      return true;
    } on AppException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado ao criar task');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Cria uma nova microtask
  Future<bool> createMicrotask({
    required String taskId,
    required String eventId,
    required String title,
    required String description,
    required List<String> requiredSkills,
    required List<String> requiredResources,
    DateTime? startDateTime,
    DateTime? endDateTime,
    required String priority,
    required int maxVolunteers,
    required String createdBy,
    String? notes,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final microtask = await _microtaskRepository.createMicrotask(
        taskId: taskId,
        eventId: eventId,
        title: title,
        description: description,
        requiredSkills: requiredSkills,
        requiredResources: requiredResources,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        priority: priority,
        maxVolunteers: maxVolunteers,
        createdBy: createdBy,
        notes: notes,
      );

      // Adiciona à lista local
      if (_microtasksByTask.containsKey(taskId)) {
        _microtasksByTask[taskId]!.add(microtask);
      } else {
        _microtasksByTask[taskId] = [microtask];
      }

      // Atualiza contador da task pai
      await _taskRepository.incrementMicrotaskCount(taskId);
      await _refreshTask(taskId);

      _setState(TaskControllerState.loaded);
      return true;
    } on AppException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado ao criar microtask');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Atribui um voluntário a uma microtask
  Future<bool> assignVolunteerToMicrotask({
    required String microtaskId,
    required String userId,
    required String eventId,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      print("ABACAXIA1: assinando microtask");
      final updatedMicrotask = await _microtaskRepository.assignVolunteer(
        microtaskId: microtaskId,
        userId: userId,
        eventId: eventId,
      );

      // Atualiza na lista local
      _updateMicrotaskInList(updatedMicrotask);

      // Carrega relações usuário-microtask
      await _loadUserMicrotasksForMicrotask(microtaskId);

      _setState(TaskControllerState.loaded);
      return true;
    } on AppException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado ao atribuir voluntário');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Remove um voluntário de uma microtask
  Future<bool> unassignVolunteerFromMicrotask({
    required String microtaskId,
    required String userId,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final updatedMicrotask = await _microtaskRepository.unassignVolunteer(
        microtaskId: microtaskId,
        userId: userId,
      );

      // Atualiza na lista local
      _updateMicrotaskInList(updatedMicrotask);

      // Carrega relações usuário-microtask
      await _loadUserMicrotasksForMicrotask(microtaskId);

      _setState(TaskControllerState.loaded);
      return true;
    } on AppException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado ao remover voluntário');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Busca voluntários compatíveis com uma microtask
  Future<List<VolunteerProfileModel>> getCompatibleVolunteers({
    required String eventId,
    required String microtaskId,
  }) async {
    try {
      return await _microtaskRepository.getCompatibleVolunteers(
        eventId: eventId,
        microtaskId: microtaskId,
      );
    } on AppException catch (e) {
      _setError(e.message);
      return [];
    } catch (e) {
      _setError('Erro inesperado ao buscar voluntários compatíveis');
      return [];
    }
  }

  /// Atualiza o status individual de um usuário em uma microtask
  Future<bool> updateUserMicrotaskStatus({
    required String userId,
    required String microtaskId,
    required UserMicrotaskStatus status,
    double? actualHours,
    String? notes,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final updatedUserMicrotask = await _microtaskRepository
          .updateUserMicrotaskStatus(
            userId: userId,
            microtaskId: microtaskId,
            status: status,
            actualHours: actualHours,
            notes: notes,
          );

      // Atualiza na lista local
      if (_userMicrotasksByMicrotask.containsKey(microtaskId)) {
        final index = _userMicrotasksByMicrotask[microtaskId]!.indexWhere(
          (um) => um.userId == userId,
        );
        if (index != -1) {
          _userMicrotasksByMicrotask[microtaskId]![index] =
              updatedUserMicrotask;
        }
      }

      // Recarrega a microtask para pegar status atualizado
      final microtask = await _microtaskRepository.getMicrotaskById(
        microtaskId,
      );
      if (microtask != null) {
        _updateMicrotaskInList(microtask);
      }

      _setState(TaskControllerState.loaded);
      return true;
    } on AppException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado ao atualizar status do usuário');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Busca microtasks de uma task específica
  List<MicrotaskModel> getMicrotasksByTaskId(String taskId) {
    return _microtasksByTask[taskId] ?? [];
  }

  /// Busca relações usuário-microtask de uma microtask específica
  List<UserMicrotaskModel> getUserMicrotasksByMicrotaskId(String microtaskId) {
    return _userMicrotasksByMicrotask[microtaskId] ?? [];
  }

  /// Limpa os filtros
  void clearFilters() {
    _statusFilter = null;
    _priorityFilter = null;
    _creatorFilter = null;
    _microtaskStatusFilter = null;
    notifyListeners();
  }

  /// Aplica filtro de status de microtask
  void setMicrotaskStatusFilter(MicrotaskStatus? status) {
    _microtaskStatusFilter = status;
    notifyListeners();
  }

  /// Busca estatísticas das tasks
  Future<Map<String, dynamic>> getTaskStatistics(String eventId) async {
    try {
      return await _taskRepository.getTaskStatistics(eventId);
    } on AppException catch (e) {
      _setError(e.message);
      return {};
    } catch (e) {
      _setError('Erro inesperado ao calcular estatísticas');
      return {};
    }
  }

  /// Carrega microtasks para todas as tasks
  Future<void> _loadMicrotasksForTasks() async {
    _microtasksByTask.clear();

    for (final task in _tasks) {
      final microtasks = await _microtaskRepository.getMicrotasksByTaskId(
        task.id,
      );
      _microtasksByTask[task.id] = microtasks;

      // Carrega relações usuário-microtask para cada microtask
      for (final microtask in microtasks) {
        await _loadUserMicrotasksForMicrotask(microtask.id);
      }
    }
  }

  /// Carrega relações usuário-microtask para uma microtask específica
  Future<void> _loadUserMicrotasksForMicrotask(String microtaskId) async {
    final userMicrotasks = await _microtaskRepository
        .getUserMicrotasksByMicrotaskId(microtaskId);
    _userMicrotasksByMicrotask[microtaskId] = userMicrotasks;
  }

  /// Atualiza uma microtask na lista local
  void _updateMicrotaskInList(MicrotaskModel updatedMicrotask) {
    for (final taskId in _microtasksByTask.keys) {
      final microtasks = _microtasksByTask[taskId]!;
      final index = microtasks.indexWhere((m) => m.id == updatedMicrotask.id);
      if (index != -1) {
        microtasks[index] = updatedMicrotask;
        break;
      }
    }
  }

  /// Recarrega uma task específica
  Future<void> _refreshTask(String taskId) async {
    final task = await _taskRepository.getTaskById(taskId);
    if (task != null) {
      final index = _tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        _tasks[index] = task;
      }
    }
  }

  /// Define o estado de loading
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Define o estado
  void _setState(TaskControllerState state) {
    _state = state;
    notifyListeners();
  }

  /// Define uma mensagem de erro
  void _setError(String message) {
    _errorMessage = message;
    _setState(TaskControllerState.error);
  }

  /// Limpa a mensagem de erro
  void _clearError() {
    _errorMessage = null;
  }

  /// Limpa todos os dados
  void clear() {
    _tasks.clear();
    _microtasksByTask.clear();
    _userMicrotasksByMicrotask.clear();
    clearFilters();
    _setState(TaskControllerState.initial);
  }
}

```

### lib\presentation\routes\app_routes.dart

```dart
import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/event/create_event_screen.dart';
import '../screens/event/join_event_screen.dart';
import '../screens/event/event_details_screen.dart';
import '../screens/task/create_task_screen.dart';
import '../screens/task/create_microtask_screen.dart';

/// Classe responsável por definir todas as rotas da aplicação
class AppRoutes {
  // Nomes das rotas
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String createEvent = '/create-event';
  static const String joinEvent = '/join-event';
  static const String eventDetails = '/event-details';
  static const String createTask = '/create-task';
  static const String createMicrotask = '/create-microtask';
  static const String createTasks = '/create-tasks';
  static const String manageVolunteers = '/manage-volunteers';
  static const String trackTasks = '/track-tasks';
  static const String profile = '/profile';

  /// Rota inicial da aplicação
  static const String initialRoute = login;

  /// Mapa de todas as rotas da aplicação
  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
      createEvent: (context) => const CreateEventScreen(),
      joinEvent: (context) => const JoinEventScreen(),
      // Outras rotas serão adicionadas conforme implementadas
    };
  }

  /// Gerador de rotas para rotas dinâmicas
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return _createRoute(const LoginScreen());
      case register:
        return _createRoute(const RegisterScreen());
      case home:
        return _createRoute(const HomeScreen());
      case createEvent:
        return _createRoute(const CreateEventScreen());
      case joinEvent:
        return _createRoute(const JoinEventScreen());

      // Rotas com parâmetros
      case eventDetails:
        final eventId = settings.arguments as String;
        return _createRoute(EventDetailsScreen(eventId: eventId));

      case createTask:
        final eventId = settings.arguments as String;
        return _createRoute(CreateTaskScreen(eventId: eventId));

      case createMicrotask:
        final eventId = settings.arguments as String;
        return _createRoute(CreateMicrotaskScreen(eventId: eventId));

      default:
        return _createRoute(const NotFoundScreen());
    }
  }

  /// Cria uma rota com animação personalizada
  static PageRoute<T> _createRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Navega para uma rota removendo todas as anteriores
  static void pushAndRemoveUntil(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Navega para uma rota substituindo a atual
  static void pushReplacement(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
  }

  /// Navega para uma rota
  static void push(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  /// Volta para a rota anterior
  static void pop(BuildContext context, [Object? result]) {
    Navigator.of(context).pop(result);
  }

  /// Verifica se pode voltar
  static bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  /// Navega para a tela de login removendo todas as rotas anteriores
  static void goToLogin(BuildContext context) {
    pushAndRemoveUntil(context, login);
  }

  /// Navega para a tela home removendo todas as rotas anteriores
  static void goToHome(BuildContext context) {
    pushAndRemoveUntil(context, home);
  }

  /// Navega para a tela de cadastro
  static void goToRegister(BuildContext context) {
    push(context, register);
  }

  /// Navega para a tela de criar evento
  static void goToCreateEvent(BuildContext context) {
    push(context, createEvent);
  }

  /// Navega para a tela de participar de evento
  static void goToJoinEvent(BuildContext context) {
    push(context, joinEvent);
  }

  /// Navega para os detalhes de um evento
  static void goToEventDetails(BuildContext context, String eventId) {
    push(context, eventDetails, arguments: eventId);
  }

  /// Navega para a tela de criar tasks
  static void goToCreateTasks(BuildContext context, String eventId) {
    push(context, createTasks, arguments: eventId);
  }

  /// Navega para a tela de gerenciar voluntários
  static void goToManageVolunteers(BuildContext context, String eventId) {
    push(context, manageVolunteers, arguments: eventId);
  }

  /// Navega para a tela de acompanhar tasks
  static void goToTrackTasks(BuildContext context, String eventId) {
    push(context, trackTasks, arguments: eventId);
  }

  /// Navega para a tela de perfil
  static void goToProfile(BuildContext context) {
    push(context, profile);
  }
}

/// Tela exibida quando uma rota não é encontrada
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página não encontrada')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Página não encontrada',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'A página que você está procurando não existe.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

```

### lib\presentation\screens\assignment\assignment_screen.dart

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/volunteer_profile_model.dart';
import '../../../data/models/microtask_model.dart';
import '../../../data/models/task_model.dart';
import '../../controllers/task_controller.dart';
import '../../widgets/common/loading_widget.dart';

/// Tela dedicada para atribuição de microtasks a voluntários
class AssignmentScreen extends StatefulWidget {
  final String eventId;
  final UserModel volunteer;
  final VolunteerProfileModel? volunteerProfile;

  const AssignmentScreen({
    super.key,
    required this.eventId,
    required this.volunteer,
    this.volunteerProfile,
  });

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  List<MicrotaskModel> _availableMicrotasks = [];
  List<TaskModel> _tasks = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadMicrotasks();
  }

  Future<void> _loadMicrotasks() async {
    try {
      final taskController = Provider.of<TaskController>(
        context,
        listen: false,
      );

      // Carrega tasks do evento
      await taskController.loadTasksByEventId(widget.eventId);

      // Coleta todas as microtasks disponíveis
      final availableMicrotasks = <MicrotaskModel>[];
      for (final task in taskController.tasks) {
        final microtasks = taskController.getMicrotasksByTaskId(task.id);
        availableMicrotasks.addAll(
          microtasks.where(
            (m) =>
                m.status != MicrotaskStatus.completed &&
                m.status != MicrotaskStatus.cancelled &&
                m.assignedTo.length < m.maxVolunteers &&
                !m.assignedTo.contains(widget.volunteer.id),
          ),
        );
      }

      if (mounted) {
        setState(() {
          _tasks = taskController.tasks;
          _availableMicrotasks = _sortMicrotasksByCompatibility(
            availableMicrotasks,
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar microtasks: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  // Ordena microtasks por compatibilidade com as habilidades do voluntário
  List<MicrotaskModel> _sortMicrotasksByCompatibility(
    List<MicrotaskModel> microtasks,
  ) {
    if (widget.volunteerProfile == null) return microtasks;

    final volunteerSkills = widget.volunteerProfile!.skills;

    // Separa microtasks compatíveis e não compatíveis
    final compatible = <MicrotaskModel>[];
    final notCompatible = <MicrotaskModel>[];

    for (final microtask in microtasks) {
      if (microtask.requiredSkills.isEmpty ||
          microtask.requiredSkills.any(
            (skill) => volunteerSkills.contains(skill),
          )) {
        compatible.add(microtask);
      } else {
        notCompatible.add(microtask);
      }
    }

    // Ordena compatíveis por número de habilidades em comum (mais compatíveis primeiro)
    compatible.sort((a, b) {
      final aMatches = a.requiredSkills
          .where((skill) => volunteerSkills.contains(skill))
          .length;
      final bMatches = b.requiredSkills
          .where((skill) => volunteerSkills.contains(skill))
          .length;
      return bMatches.compareTo(aMatches);
    });

    return [...compatible, ...notCompatible];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atribuir Microtask'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          Expanded(
            child: _isLoading
                ? const LoadingWidget(message: 'Carregando microtasks...')
                : _buildMicrotasksList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: widget.volunteer.photoUrl != null
                ? NetworkImage(widget.volunteer.photoUrl!)
                : null,
            child: widget.volunteer.photoUrl == null
                ? Text(
                    widget.volunteer.name.isNotEmpty
                        ? widget.volunteer.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.volunteer.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Selecione uma microtask para atribuir',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (widget.volunteerProfile != null &&
                    widget.volunteerProfile!.skills.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Habilidades: ${widget.volunteerProfile!.skills.join(', ')}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Buscar microtasks...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMd,
            vertical: AppDimensions.paddingSm,
          ),
        ),
      ),
    );
  }

  Widget _buildMicrotasksList() {
    final filteredMicrotasks = _getFilteredMicrotasks();

    if (filteredMicrotasks.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingSm),
      itemCount: filteredMicrotasks.length,
      itemBuilder: (context, index) {
        final microtask = filteredMicrotasks[index];
        final task = _getTaskForMicrotask(microtask.taskId);
        return _buildMicrotaskAssignmentCard(microtask, task);
      },
    );
  }

  List<MicrotaskModel> _getFilteredMicrotasks() {
    if (_searchQuery.isEmpty) return _availableMicrotasks;

    return _availableMicrotasks.where((microtask) {
      final query = _searchQuery.toLowerCase();
      final task = _getTaskForMicrotask(microtask.taskId);

      return microtask.title.toLowerCase().contains(query) ||
          microtask.description.toLowerCase().contains(query) ||
          (task?.title.toLowerCase().contains(query) ?? false) ||
          microtask.requiredSkills.any(
            (skill) => skill.toLowerCase().contains(query),
          );
    }).toList();
  }

  TaskModel? _getTaskForMicrotask(String taskId) {
    try {
      return _tasks.firstWhere((task) => task.id == taskId);
    } catch (e) {
      return null;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          const Text(
            'Nenhuma microtask disponível',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          const Text(
            'Não há microtasks disponíveis para atribuição no momento.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMicrotaskAssignmentCard(
    MicrotaskModel microtask,
    TaskModel? task,
  ) {
    final isCompatible = _isVolunteerCompatible(microtask);
    final availableSlots =
        microtask.maxVolunteers - microtask.assignedTo.length;

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      elevation: 2,
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
                        microtask.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (task != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Task: ${task.title}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isCompatible)
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
              microtask.description,
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
                  label: microtask.hasSchedule
                      ? microtask.periodFormatted
                      : 'Horário flexível',
                  color: AppColors.secondary,
                ),
                _buildInfoChip(
                  icon: Icons.people,
                  label: 'Vagas: $availableSlots de ${microtask.maxVolunteers}',
                  color: _getVacancyColor(
                    availableSlots,
                    microtask.maxVolunteers,
                  ),
                ),
                if (microtask.status != MicrotaskStatus.pending)
                  _buildInfoChip(
                    icon: Icons.info_outline,
                    label: _getStatusText(microtask.status),
                    color: _getStatusColor(microtask.status),
                  ),
              ],
            ),

            // Habilidades necessárias
            if (microtask.requiredSkills.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spacingMd),
              _buildSkillsSection(microtask),
            ],

            const SizedBox(height: AppDimensions.spacingMd),

            // Botão de atribuição
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: availableSlots > 0
                    ? () => _assignMicrotask(microtask)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompatible
                      ? AppColors.success
                      : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  availableSlots > 0
                      ? (isCompatible ? 'Atribuir (Compatível)' : 'Atribuir')
                      : 'Sem vagas disponíveis',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Verifica se o voluntário é compatível com a microtask
  bool _isVolunteerCompatible(MicrotaskModel microtask) {
    if (widget.volunteerProfile == null || microtask.requiredSkills.isEmpty) {
      return false;
    }

    final volunteerSkills = widget.volunteerProfile!.skills;
    return microtask.requiredSkills.any(
      (skill) => volunteerSkills.contains(skill),
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
  Widget _buildSkillsSection(MicrotaskModel microtask) {
    final volunteerSkills = widget.volunteerProfile?.skills ?? [];

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
          children: microtask.requiredSkills.map((skill) {
            final hasSkill = volunteerSkills.contains(skill);
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

  // Atribui a microtask ao voluntário
  Future<void> _assignMicrotask(MicrotaskModel microtask) async {
    try {
      final taskController = Provider.of<TaskController>(
        context,
        listen: false,
      );

      // Atribui a microtask
      await taskController.assignVolunteerToMicrotask(
        microtaskId: microtask.id,
        userId: widget.volunteer.id,
        eventId: widget.eventId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Microtask "${microtask.title}" atribuída com sucesso!',
            ),
            backgroundColor: AppColors.success,
          ),
        );

        // Volta para a tela anterior
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atribuir microtask: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

```

### lib\presentation\screens\auth\login_screen.dart

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

/// Tela de login conforme especificado no SPEC_GERAL.md
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<AuthController>(
          builder: (context, authController, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingLg),
              child: Column(
                children: [
                  const SizedBox(height: AppDimensions.spacingXxl),

                  // Logo centralizado
                  _buildLogo(),

                  const SizedBox(height: AppDimensions.spacingXxl),

                  // Formulário de login
                  _buildLoginForm(authController),

                  const SizedBox(height: AppDimensions.spacingLg),

                  // Botão "Entrar com Google"
                  _buildGoogleSignInButton(authController),

                  const SizedBox(height: AppDimensions.spacingLg),

                  // Link "Criar conta"
                  _buildCreateAccountLink(),

                  const SizedBox(height: AppDimensions.spacingMd),

                  // Link "Esqueci minha senha"
                  _buildForgotPasswordLink(authController),

                  // Mensagem de erro
                  if (authController.errorMessage != null) ...[
                    const SizedBox(height: AppDimensions.spacingMd),
                    _buildErrorMessage(authController.errorMessage!),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowMedium,
                blurRadius: AppDimensions.elevationMd,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.task_alt,
            size: 60,
            color: AppColors.textOnPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        const Text(
          AppStrings.appName,
          style: TextStyle(
            fontSize: AppDimensions.fontSizeHeading,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        const Text(
          AppStrings.appDescription,
          style: TextStyle(
            fontSize: AppDimensions.fontSizeMd,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm(AuthController authController) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Campo de email
          CustomTextField.email(
            controller: _emailController,
            focusNode: _emailFocusNode,
            validator: Validators.validateEmail,
            onSubmitted: (_) => _passwordFocusNode.requestFocus(),
          ),

          const SizedBox(height: AppDimensions.spacingMd),

          // Campo de senha
          CustomTextField.password(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            validator: Validators.validatePassword,
            onSubmitted: (_) => _handleLogin(authController),
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Botão de login
          CustomButton.primary(
            text: AppStrings.login,
            onPressed: () => _handleLogin(authController),
            isLoading: authController.isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleSignInButton(AuthController authController) {
    return CustomButton.google(
      text: AppStrings.loginWithGoogle,
      onPressed: () => _handleGoogleSignIn(authController),
      isLoading: authController.isLoading,
    );
  }

  Widget _buildCreateAccountLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          AppStrings.dontHaveAccount,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: AppDimensions.fontSizeMd,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        GestureDetector(
          onTap: _navigateToRegister,
          child: const Text(
            AppStrings.register,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: AppDimensions.fontSizeMd,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordLink(AuthController authController) {
    return GestureDetector(
      onTap: () => _handleForgotPassword(authController),
      child: const Text(
        'Esqueci minha senha',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: AppDimensions.fontSizeSm,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
          width: AppDimensions.borderWidthThin,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: AppDimensions.iconSm,
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: AppDimensions.fontSizeSm,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXs),
                GestureDetector(
                  onTap: () {
                    Provider.of<AuthController>(
                      context,
                      listen: false,
                    ).clearError();
                  },
                  child: const Text(
                    'Toque para fechar',
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: AppDimensions.fontSizeXs,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin(AuthController authController) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await authController.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      // Navegar para a tela principal
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<void> _handleGoogleSignIn(AuthController authController) async {
    final success = await authController.signInWithGoogle();

    if (success && mounted) {
      // Navegar para a tela principal
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void _navigateToRegister() {
    Navigator.of(context).pushNamed('/register');
  }

  Future<void> _handleForgotPassword(AuthController authController) async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSnackBar('Digite seu e-mail para redefinir a senha');
      return;
    }

    final success = await authController.sendPasswordResetEmail(email);

    if (success && mounted) {
      _showSnackBar('E-mail de redefinição enviado com sucesso!');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
    );
  }
}

```

### lib\presentation\screens\auth\register_screen.dart

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

/// Tela de cadastro conforme especificado no SPEC_GERAL.md
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          AppStrings.register,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppDimensions.fontSizeXl,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<AuthController>(
          builder: (context, authController, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingLg),
              child: Column(
                children: [
                  const SizedBox(height: AppDimensions.spacingLg),

                  // Formulário de cadastro
                  _buildRegisterForm(authController),

                  const SizedBox(height: AppDimensions.spacingLg),

                  // Link "Já tenho conta"
                  _buildLoginLink(),

                  // Mensagem de erro
                  if (authController.errorMessage != null) ...[
                    const SizedBox(height: AppDimensions.spacingMd),
                    _buildErrorMessage(authController.errorMessage!),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRegisterForm(AuthController authController) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Campo de nome
          CustomTextField.name(
            controller: _nameController,
            focusNode: _nameFocusNode,
            validator: Validators.validateName,
            onSubmitted: (_) => _emailFocusNode.requestFocus(),
          ),

          const SizedBox(height: AppDimensions.spacingMd),

          // Campo de email
          CustomTextField.email(
            controller: _emailController,
            focusNode: _emailFocusNode,
            validator: Validators.validateEmail,
            onSubmitted: (_) => _passwordFocusNode.requestFocus(),
          ),

          const SizedBox(height: AppDimensions.spacingMd),

          // Campo de senha
          CustomTextField.password(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            validator: Validators.validatePassword,
            onSubmitted: (_) => _confirmPasswordFocusNode.requestFocus(),
          ),

          const SizedBox(height: AppDimensions.spacingMd),

          // Campo de confirmar senha
          CustomTextField(
            label: AppStrings.confirmPassword,
            hint: 'Confirme sua senha',
            controller: _confirmPasswordController,
            focusNode: _confirmPasswordFocusNode,
            obscureText: true,
            prefixIcon: Icons.lock_outlined,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            validator: (value) => Validators.validatePasswordConfirmation(
              value,
              _passwordController.text,
            ),
            onSubmitted: (_) => _handleRegister(authController),
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // Botão de cadastro
          CustomButton.primary(
            text: AppStrings.register,
            onPressed: () => _handleRegister(authController),
            isLoading: authController.isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          AppStrings.alreadyHaveAccount,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: AppDimensions.fontSizeMd,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        GestureDetector(
          onTap: _navigateToLogin,
          child: const Text(
            AppStrings.login,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: AppDimensions.fontSizeMd,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
          width: AppDimensions.borderWidthThin,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: AppDimensions.iconSm,
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: AppDimensions.fontSizeSm,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXs),
                GestureDetector(
                  onTap: () {
                    Provider.of<AuthController>(
                      context,
                      listen: false,
                    ).clearError();
                  },
                  child: const Text(
                    'Toque para fechar',
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: AppDimensions.fontSizeXs,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRegister(AuthController authController) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await authController.createUserWithEmailAndPassword(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      // Mostrar mensagem de sucesso
      _showSnackBar('Conta criada com sucesso!');

      // Navegar para a tela principal
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pop();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
    );
  }
}

```

### lib\presentation\screens\event\create_event_screen.dart

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/event_controller.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/event/skill_chip.dart';

/// Tela para criação de novos eventos
class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

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
      appBar: AppBar(
        title: const Text('Criar Evento'),
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

                  // Botão de criar
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Criar Evento',
                      onPressed: () =>
                          _handleCreateEvent(authController, eventController),
                      isLoading: eventController.isCreatingEvent,
                    ),
                  ),

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

        // Nome do evento
        CustomTextField(
          controller: _nameController,
          label: 'Nome do Evento',
          hint: 'Digite o nome do evento',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Nome do evento é obrigatório';
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
          hint: 'Descreva o evento (opcional)',
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
          hint: 'Onde será realizado o evento',
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
      // Mostra dialog de sucesso com o código do evento
      _showSuccessDialog(event.tag);
    }
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
            Text('Evento Criado!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seu evento foi criado com sucesso!',
              style: TextStyle(fontSize: AppDimensions.fontSizeMd),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            const Text(
              'Código do evento:',
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
              'Compartilhe este código com os voluntários para que eles possam participar do evento.',
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

```

### lib\presentation\screens\event\create_tasks_screen.dart

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/task_model.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/task_controller.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/loading_widget.dart';

/// Tela para criação de tasks e microtasks
class CreateTasksScreen extends StatefulWidget {
  final String eventId;

  const CreateTasksScreen({super.key, required this.eventId});

  @override
  State<CreateTasksScreen> createState() => _CreateTasksScreenState();
}

class _CreateTasksScreenState extends State<CreateTasksScreen> {
  final _taskFormKey = GlobalKey<FormState>();
  final _microtaskFormKey = GlobalKey<FormState>();

  // Controllers para Task
  final _taskTitleController = TextEditingController();
  final _taskDescriptionController = TextEditingController();
  TaskPriority _taskPriority = TaskPriority.medium;

  // Controllers para Microtask
  final _microtaskTitleController = TextEditingController();
  final _microtaskDescriptionController = TextEditingController();
  final _maxVolunteersController = TextEditingController();
  final _notesController = TextEditingController();

  // Data e hora da microtask
  DateTime? _startDateTime;
  DateTime? _endDateTime;

  String? _selectedTaskId;
  TaskPriority _microtaskPriority = TaskPriority.medium;
  final List<String> _selectedSkills = [];
  final List<String> _selectedResources = [];

  // Lista de habilidades pré-definidas
  final List<String> _predefinedSkills = [
    'Organização',
    'Comunicação',
    'Liderança',
    'Trabalho em Equipe',
    'Criatividade',
    'Planejamento',
    'Montagem',
    'Limpeza',
    'Cozinha',
    'Atendimento',
    'Vendas',
    'Marketing',
    'Design',
    'Fotografia',
    'Música',
    'Dança',
    'Esportes',
    'Primeiros Socorros',
    'Segurança',
    'Transporte',
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
  void dispose() {
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    _microtaskTitleController.dispose();
    _microtaskDescriptionController.dispose();
    _maxVolunteersController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthController, TaskController>(
      builder: (context, authController, taskController, child) {
        if (taskController.isLoading) {
          return const LoadingWidget(message: 'Processando...');
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTaskSection(authController, taskController),
              const SizedBox(height: AppDimensions.spacingXl),
              _buildMicrotaskSection(authController, taskController),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTaskSection(
    AuthController authController,
    TaskController taskController,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Form(
          key: _taskFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.task_alt, color: AppColors.primary),
                  const SizedBox(width: AppDimensions.spacingSm),
                  const Text(
                    'Criar Task',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingMd),

              CustomTextField(
                controller: _taskTitleController,
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
                controller: _taskDescriptionController,
                label: 'Descrição',
                hint: 'Descreva o objetivo desta task...',
                maxLines: 3,
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

              _buildPrioritySelector(
                'Prioridade da Task',
                _taskPriority,
                (priority) => setState(() => _taskPriority = priority),
              ),

              const SizedBox(height: AppDimensions.spacingLg),

              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Criar Task',
                  onPressed: () =>
                      _handleCreateTask(authController, taskController),
                  isLoading: taskController.isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMicrotaskSection(
    AuthController authController,
    TaskController taskController,
  ) {
    final tasks = taskController.tasks;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Form(
          key: _microtaskFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.checklist, color: AppColors.secondary),
                  const SizedBox(width: AppDimensions.spacingSm),
                  const Text(
                    'Criar Microtask',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingMd),

              // Seleção da task pai
              _buildTaskSelector(tasks),

              const SizedBox(height: AppDimensions.spacingMd),

              CustomTextField(
                controller: _microtaskTitleController,
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
                controller: _microtaskDescriptionController,
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
                  padding: const EdgeInsets.all(AppDimensions.paddingMd),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
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
                  padding: const EdgeInsets.all(AppDimensions.paddingMd),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
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

              _buildPrioritySelector(
                'Prioridade da Microtask',
                _microtaskPriority,
                (priority) => setState(() => _microtaskPriority = priority),
              ),

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

  Widget _buildPrioritySelector(
    String title,
    TaskPriority currentPriority,
    Function(TaskPriority) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        Row(
          children: TaskPriority.values.map((priority) {
            final isSelected = currentPriority == priority;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: AppDimensions.spacingSm),
                child: GestureDetector(
                  onTap: () => onChanged(priority),
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
        Wrap(
          spacing: AppDimensions.spacingSm,
          runSpacing: AppDimensions.spacingSm,
          children: _predefinedSkills.map((skill) {
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
        Wrap(
          spacing: AppDimensions.spacingSm,
          runSpacing: AppDimensions.spacingSm,
          children: _predefinedResources.map((resource) {
            final isSelected = _selectedResources.contains(resource);
            return GestureDetector(
              onTap: () => _toggleResource(resource),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMd,
                  vertical: AppDimensions.paddingSm,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.secondary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.secondary : AppColors.border,
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

  Future<void> _handleCreateTask(
    AuthController authController,
    TaskController taskController,
  ) async {
    if (!_taskFormKey.currentState!.validate()) return;

    final success = await taskController.createTask(
      eventId: widget.eventId,
      title: _taskTitleController.text.trim(),
      description: _taskDescriptionController.text.trim(),
      priority: _taskPriority,
      createdBy: authController.currentUser!.id,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task criada com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );

      // Limpa o formulário
      _taskTitleController.clear();
      _taskDescriptionController.clear();
      setState(() {
        _taskPriority = TaskPriority.medium;
      });
    } else if (mounted && taskController.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(taskController.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
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
    if (!_microtaskFormKey.currentState!.validate()) return;

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
      title: _microtaskTitleController.text.trim(),
      description: _microtaskDescriptionController.text.trim(),
      requiredSkills: _selectedSkills,
      requiredResources: _selectedResources,
      startDateTime: _startDateTime,
      endDateTime: _endDateTime,
      priority: _microtaskPriority.value,
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

      // Limpa o formulário
      _microtaskTitleController.clear();
      _microtaskDescriptionController.clear();
      _maxVolunteersController.clear();
      _notesController.clear();
      setState(() {
        _selectedTaskId = null;
        _microtaskPriority = TaskPriority.medium;
        _selectedSkills.clear();
        _selectedResources.clear();
        _startDateTime = null;
        _endDateTime = null;
      });
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

```

### lib\presentation\screens\event\event_details_screen.dart

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/task_model.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/event_controller.dart';
import '../../controllers/task_controller.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_message_widget.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/skill_chip.dart';
import 'manage_volunteers_screen.dart';
import 'track_tasks_screen.dart';

/// Tela de detalhes do evento com sistema de tabs
class EventDetailsScreen extends StatefulWidget {
  final String eventId;

  const EventDetailsScreen({super.key, required this.eventId});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  EventModel? _event;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadEventDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadEventDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final eventController = Provider.of<EventController>(
        context,
        listen: false,
      );
      final event = await eventController.loadEvent(widget.eventId);

      if (event != null) {
        setState(() {
          _event = event;
        });

        // Carrega tasks do evento
        if (mounted) {
          final taskController = Provider.of<TaskController>(
            context,
            listen: false,
          );
          await taskController.loadTasksByEventId(widget.eventId);
        }

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Evento não encontrado';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar evento: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: LoadingWidget(message: 'Carregando evento...'),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Detalhes do Evento'),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
        ),
        body: ErrorMessageWidget(
          message: _errorMessage!,
          onRetry: _loadEventDetails,
        ),
      );
    }

    if (_event == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Detalhes do Evento'),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
        ),
        body: const Center(child: Text('Evento não encontrado')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEventTab(),
                _buildManageVolunteersTab(),
                _buildTrackTasksTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      title: _event!.name,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadEventDetails,
          tooltip: 'Atualizar',
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _shareEvent(),
          tooltip: 'Compartilhar',
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUserId = authController.currentUser?.id;
    final isManager = _event!.isManager(currentUserId ?? '');

    return Container(
      color: AppColors.primary,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.textOnPrimary,
        labelColor: AppColors.textOnPrimary,
        unselectedLabelColor: AppColors.textOnPrimary.withOpacity(0.7),
        tabs: [
          const Tab(icon: Icon(Icons.info_outline), text: 'Evento'),
          if (isManager)
            const Tab(icon: Icon(Icons.people), text: 'Voluntários'),
          const Tab(icon: Icon(Icons.track_changes), text: 'Acompanhar'),
        ],
      ),
    );
  }

  Widget _buildEventTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEventInfoCard(),
          const SizedBox(height: AppDimensions.spacingLg),
          _buildEventStatsCard(),
          const SizedBox(height: AppDimensions.spacingLg),
          _buildEventCodeCard(),
        ],
      ),
    );
  }

  Widget _buildManageVolunteersTab() {
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUserId = authController.currentUser?.id;
    final isManager = _event!.isManager(currentUserId ?? '');

    if (!isManager) {
      return const Center(
        child: Text(
          'Apenas gerenciadores podem gerenciar voluntários',
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
      );
    }

    return ManageVolunteersScreen(eventId: widget.eventId);
  }

  Widget _buildTrackTasksTab() {
    return TrackTasksScreen(eventId: widget.eventId);
  }

  Widget _buildEventInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.primary),
                const SizedBox(width: AppDimensions.spacingSm),
                const Text(
                  'Informações do Evento',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            _buildInfoRow('Nome', _event!.name),
            _buildInfoRow('Descrição', _event!.description),
            _buildInfoRow('Localização', _event!.location),
            _buildInfoRow('Status', _getStatusText(_event!.status)),
            _buildInfoRow('Criado em', _formatDate(_event!.createdAt)),

            // Habilidades necessárias
            if (_event!.requiredSkills.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spacingMd),
              SkillChipList(
                title: 'Habilidades Necessárias',
                items: _event!.requiredSkills,
                itemIcon: Icons.star,
                chipColor: AppColors.primary,
                isSmall: true,
              ),
            ],

            // Recursos necessários
            if (_event!.requiredResources.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spacingMd),
              SkillChipList(
                title: 'Recursos Necessários',
                items: _event!.requiredResources,
                itemIcon: Icons.build,
                chipColor: AppColors.secondary,
                isSmall: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEventStatsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics_outlined, color: AppColors.primary),
                const SizedBox(width: AppDimensions.spacingSm),
                const Text(
                  'Estatísticas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Gerenciadores',
                    _event!.managers.length.toString(),
                    Icons.admin_panel_settings,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMd),
                Expanded(
                  child: _buildStatItem(
                    'Voluntários',
                    _event!.volunteers.length.toString(),
                    Icons.people,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Consumer<TaskController>(
              builder: (context, taskController, child) {
                final tasks = taskController.tasks;
                final totalMicrotasks = tasks.fold<int>(
                  0,
                  (sum, task) => sum + task.microtaskCount,
                );
                final completedMicrotasks = tasks.fold<int>(
                  0,
                  (sum, task) => sum + task.completedMicrotasks,
                );

                return Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        'Tasks',
                        tasks.length.toString(),
                        Icons.task_alt,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingMd),
                    Expanded(
                      child: _buildStatItem(
                        'Microtasks',
                        '$completedMicrotasks/$totalMicrotasks',
                        Icons.checklist,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCodeCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.qr_code, color: AppColors.primary),
                const SizedBox(width: AppDimensions.spacingSm),
                const Text(
                  'Código do Evento',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.secondary),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _event!.tag,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 2,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: AppColors.primary),
                    onPressed: () => _copyToClipboard(_event!.tag),
                    tooltip: 'Copiar código',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            const Text(
              'Compartilhe este código para que outros possam participar do evento',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getStatusText(EventStatus status) {
    switch (status) {
      case EventStatus.active:
        return 'Ativo';
      case EventStatus.completed:
        return 'Concluído';
      case EventStatus.cancelled:
        return 'Cancelado';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget? _buildFloatingActionButton() {
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUserId = authController.currentUser?.id;
    final isManager = _event?.isManager(currentUserId ?? '') ?? false;

    if (!isManager) return null;

    return Consumer<TaskController>(
      builder: (context, taskController, child) {
        final tasks = taskController.tasks;

        return FloatingActionButton(
          onPressed: () => _showCreateOptionsDialog(tasks),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: AppColors.textOnPrimary),
        );
      },
    );
  }

  void _showCreateOptionsDialog(List<TaskModel> tasks) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('O que deseja criar?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.task_alt, color: AppColors.primary),
              title: const Text('Nova Task'),
              subtitle: const Text('Criar uma nova task organizadora'),
              onTap: () {
                Navigator.of(context).pop();
                _navigateToCreateTask();
              },
            ),
            if (tasks.isNotEmpty)
              ListTile(
                leading: const Icon(
                  Icons.checklist,
                  color: AppColors.secondary,
                ),
                title: const Text('Nova Microtask'),
                subtitle: const Text('Criar uma microtask dentro de uma task'),
                onTap: () {
                  Navigator.of(context).pop();
                  _navigateToCreateMicrotask();
                },
              )
            else
              ListTile(
                leading: Icon(Icons.checklist, color: Colors.grey[400]),
                title: Text(
                  'Nova Microtask',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                subtitle: const Text('É preciso criar uma task primeiro'),
                enabled: false,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _navigateToCreateTask() {
    Navigator.of(context).pushNamed('/create-task', arguments: widget.eventId);
  }

  void _navigateToCreateMicrotask() {
    Navigator.of(
      context,
    ).pushNamed('/create-microtask', arguments: widget.eventId);
  }

  void _copyToClipboard(String text) {
    // TODO: Implementar cópia para clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Código copiado para a área de transferência'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _shareEvent() {
    // TODO: Implementar compartilhamento do evento
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compartilhar evento: ${_event!.name} (${_event!.tag})'),
        backgroundColor: AppColors.warning,
        action: SnackBarAction(
          label: 'Copiar Código',
          onPressed: () => _copyToClipboard(_event!.tag),
        ),
      ),
    );
  }
}

```

### lib\presentation\screens\event\join_event_screen.dart

```dart
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

```

### lib\presentation\screens\event\manage_volunteers_screen.dart

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/volunteer_profile_model.dart';
import '../../../data/models/microtask_model.dart';
import '../../controllers/event_controller.dart';
import '../../controllers/task_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/volunteer/volunteer_card.dart';
import '../../widgets/dialogs/confirmation_dialog.dart';
import '../assignment/assignment_screen.dart';

/// Tela para gerenciamento de voluntários
class ManageVolunteersScreen extends StatefulWidget {
  final String eventId;

  const ManageVolunteersScreen({super.key, required this.eventId});

  @override
  State<ManageVolunteersScreen> createState() => _ManageVolunteersScreenState();
}

class _ManageVolunteersScreenState extends State<ManageVolunteersScreen> {
  EventModel? _event;
  List<UserModel> _volunteers = [];
  List<VolunteerProfileModel> _volunteerProfiles = [];
  List<MicrotaskModel> _availableMicrotasks = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _filterStatus = 'all'; // all, available, assigned
  final List<String> _selectedSkillsFilter =
      []; // Filtro por habilidades selecionadas
  List<String> _availableSkills =
      []; // Todas as habilidades disponíveis no evento

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final eventController = Provider.of<EventController>(
        context,
        listen: false,
      );
      final taskController = Provider.of<TaskController>(
        context,
        listen: false,
      );

      // Carrega evento
      final event = await eventController.loadEvent(widget.eventId);

      // Carrega tasks e microtasks
      await taskController.loadTasksByEventId(widget.eventId);

      // Carrega voluntários e perfis (OTIMIZADO - dados denormalizados)
      final profiles = await eventController.getEventVolunteersOptimized(
        widget.eventId,
      );

      // DEBUG: Carregados ${profiles.length} perfis de voluntários

      // Não precisamos mais buscar usuários separadamente - dados estão nos perfis
      final volunteers = <UserModel>[]; // Mantido para compatibilidade

      // Se não há voluntários, você pode adicionar dados de teste aqui
      // _addTestVolunteers(); // Descomente para testar

      // Carrega microtasks disponíveis
      final availableMicrotasks = <MicrotaskModel>[];
      final allSkills = <String>{};

      for (final task in taskController.tasks) {
        final microtasks = taskController.getMicrotasksByTaskId(task.id);
        availableMicrotasks.addAll(
          microtasks.where(
            (m) =>
                m.status != MicrotaskStatus.completed &&
                m.status != MicrotaskStatus.cancelled,
          ),
        );

        // Coleta todas as habilidades necessárias das microtasks
        for (final microtask in microtasks) {
          allSkills.addAll(microtask.requiredSkills);
        }
      }

      // Adiciona habilidades do evento se disponíveis
      if (event != null && event.requiredSkills.isNotEmpty) {
        allSkills.addAll(event.requiredSkills);
      }

      if (mounted) {
        setState(() {
          _event = event;
          _volunteers = volunteers;
          _volunteerProfiles = profiles;
          _availableMicrotasks = availableMicrotasks;
          _availableSkills = allSkills.toList()..sort();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar dados: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingWidget(message: 'Carregando voluntários...');
    }

    if (_event == null) {
      return const Center(
        child: Text(
          'Erro ao carregar evento',
          style: TextStyle(fontSize: 16, color: AppColors.error),
        ),
      );
    }

    final filteredVolunteers = _getFilteredVolunteers();

    return Column(
      children: [
        // Header com busca e filtros
        _buildHeader(),

        // Lista de voluntários
        Expanded(
          child: filteredVolunteers.isEmpty
              ? _buildEmptyState()
              : _buildVolunteersList(filteredVolunteers),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          // Barra de busca
          TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Buscar voluntários...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
                vertical: AppDimensions.paddingSm,
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.spacingMd),

          // Filtros
          Row(
            children: [
              const Text(
                'Filtrar:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSm),

              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Todos', 'all'),
                      const SizedBox(width: AppDimensions.spacingSm),
                      _buildFilterChip('Disponíveis', 'available'),
                      const SizedBox(width: AppDimensions.spacingSm),
                      _buildFilterChip('Com Tarefas', 'assigned'),
                      const SizedBox(width: AppDimensions.spacingSm),
                      _buildSkillsFilterButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterStatus == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterStatus = value;
        });
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  // Botão de filtro por habilidades
  Widget _buildSkillsFilterButton() {
    final hasActiveFilter = _selectedSkillsFilter.isNotEmpty;

    return GestureDetector(
      onTap: _availableSkills.isNotEmpty ? _showSkillsFilterDialog : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingSm,
          vertical: AppDimensions.paddingSm / 2,
        ),
        decoration: BoxDecoration(
          color: hasActiveFilter
              ? AppColors.primary.withOpacity(0.2)
              : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasActiveFilter ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_list,
              size: 16,
              color: hasActiveFilter
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              hasActiveFilter
                  ? 'Habilidades (${_selectedSkillsFilter.length})'
                  : 'Filtrar por Habilidade',
              style: TextStyle(
                fontSize: 12,
                color: hasActiveFilter
                    ? AppColors.primary
                    : AppColors.textSecondary,
                fontWeight: hasActiveFilter
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
            if (hasActiveFilter) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSkillsFilter.clear();
                  });
                },
                child: Icon(Icons.close, size: 14, color: AppColors.primary),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          const Text(
            'Nenhum voluntário encontrado',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          const Text(
            'Compartilhe o código do evento para que\nvoluntários possam se inscrever.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppDimensions.spacingLg),

          // Código do evento
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.qr_code, color: AppColors.primary),
                const SizedBox(width: AppDimensions.spacingSm),
                Text(
                  'Código: ${_event?.tag ?? 'N/A'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVolunteersList(List<UserModel> volunteers) {
    // Agora usamos os perfis diretamente (com dados denormalizados)
    final profiles = _volunteerProfiles.where((profile) {
      return _shouldShowVolunteer(profile);
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingSm),
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        final profile = profiles[index];

        // Cria um UserModel temporário para compatibilidade com VolunteerCard
        final user = UserModel(
          id: profile.userId,
          name: profile.userName,
          email: profile.userEmail,
          photoUrl: profile.userPhotoUrl,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        return VolunteerCard(
          user: user,
          profile: profile,
          isManager: true,
          showActions: true,
          assignedMicrotasksCount: _getAssignedMicrotasksCount(profile.userId),
          isCompatible: _isVolunteerCompatible(profile),
          showDetailedAvailability: true,
          onShowActions: () => _showVolunteerActionsDialog(user, profile),
        );
      },
    );
  }

  /// Verifica se um voluntário deve ser mostrado baseado nos filtros
  bool _shouldShowVolunteer(VolunteerProfileModel profile) {
    // Filtro por status
    if (_filterStatus == 'available') {
      final assignedCount = _getAssignedMicrotasksCount(profile.userId);
      if (assignedCount > 0) return false;
    } else if (_filterStatus == 'assigned') {
      final assignedCount = _getAssignedMicrotasksCount(profile.userId);
      if (assignedCount == 0) return false;
    }

    // Filtro por habilidades
    if (!_hasRequiredSkills(profile)) return false;

    return true;
  }

  /// Verifica se o perfil tem as habilidades necessárias (filtro)
  bool _hasRequiredSkills(VolunteerProfileModel profile) {
    if (_selectedSkillsFilter.isEmpty) return true;
    return _selectedSkillsFilter.every(
      (skill) => profile.skills.contains(skill),
    );
  }

  /// Exibe um diálogo com as ações disponíveis para um voluntário.
  void _showVolunteerActionsDialog(
    UserModel volunteer,
    VolunteerProfileModel? profile,
  ) {
    final assignedCount = _getAssignedMicrotasksCount(volunteer.id);
    final availableMicrotasksCount = _availableMicrotasks
        .where(
          (m) =>
              m.assignedTo.length < m.maxVolunteers &&
              !m.assignedTo.contains(volunteer.id),
        )
        .length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              backgroundImage: volunteer.photoUrl != null
                  ? NetworkImage(volunteer.photoUrl!)
                  : null,
              child: volunteer.photoUrl == null
                  ? Text(
                      volunteer.name.isNotEmpty
                          ? volunteer.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: AppDimensions.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    volunteer.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (profile != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      profile.workloadLevel,
                      style: TextStyle(
                        fontSize: 12,
                        color: _getMicrotaskBadgeColor(assignedCount),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Informações do voluntário
            if (profile != null) ...[
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingSm),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.assignment,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Microtasks: $assignedCount atribuídas',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          profile.isFullTimeAvailable
                              ? 'Disponibilidade integral'
                              : 'Disponível: ${profile.availableDays.join(', ')}',
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    if (profile.skills.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.construction,
                            size: 16,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Habilidades: ${profile.skills.join(', ')}',
                              style: const TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingMd),
            ],

            // Ações disponíveis
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.assignment_ind_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              title: const Text('Atribuir Microtask'),
              subtitle: Text(
                availableMicrotasksCount > 0
                    ? '$availableMicrotasksCount microtasks disponíveis'
                    : 'Nenhuma microtask disponível',
              ),
              enabled: availableMicrotasksCount > 0,
              onTap: availableMicrotasksCount > 0
                  ? () {
                      Navigator.of(context).pop();
                      _showAssignmentDialog(volunteer, profile);
                    }
                  : null,
            ),

            const Divider(),

            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.admin_panel_settings_outlined,
                  color: AppColors.warning,
                  size: 20,
                ),
              ),
              title: const Text('Promover a Gerente'),
              subtitle: const Text('Conceder permissões de gerenciamento'),
              onTap: () {
                Navigator.of(context).pop();
                _promoteToManager(volunteer);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  List<UserModel> _getFilteredVolunteers() {
    // Agora criamos UserModels a partir dos perfis (dados denormalizados)
    List<UserModel> filtered = _volunteerProfiles.map((profile) {
      return UserModel(
        id: profile.userId,
        name: profile.userName,
        email: profile.userEmail,
        photoUrl: profile.userPhotoUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }).toList();

    // Aplicar filtro de busca
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((volunteer) {
        final name = volunteer.name.toLowerCase();
        final email = volunteer.email.toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || email.contains(query);
      }).toList();
    }

    // Aplicar filtro de status
    switch (_filterStatus) {
      case 'available':
        // Filtrar voluntários disponíveis hoje
        filtered = filtered.where((volunteer) {
          final profile = _getVolunteerProfile(volunteer.id);
          if (profile == null) return false;

          final currentDay = _getCurrentDayString();
          return profile.availableDays.contains(currentDay);
        }).toList();
        break;
      case 'assigned':
        // Filtrar voluntários com microtasks atribuídas
        filtered = filtered.where((volunteer) {
          return _getAssignedMicrotasksCount(volunteer.id) > 0;
        }).toList();
        break;
      case 'all':
      default:
        // Não aplicar filtro adicional
        break;
    }

    // Aplicar filtro por habilidades
    if (_selectedSkillsFilter.isNotEmpty) {
      filtered = filtered.where((volunteer) {
        final profile = _getVolunteerProfile(volunteer.id);
        if (profile == null) return false;

        // O voluntário deve possuir TODAS as habilidades selecionadas no filtro
        return _selectedSkillsFilter.every(
          (skill) => profile.skills.contains(skill),
        );
      }).toList();
    }

    return filtered;
  }

  String _getCurrentDayString() {
    final now = DateTime.now();
    final weekdays = ['seg', 'ter', 'qua', 'qui', 'sex', 'sab', 'dom'];
    return weekdays[now.weekday - 1];
  }

  VolunteerProfileModel? _getVolunteerProfile(String userId) {
    try {
      return _volunteerProfiles.firstWhere((p) => p.userId == userId);
    } catch (e) {
      return null;
    }
  }

  // Verifica se o voluntário é compatível com os filtros de habilidades ativos
  bool _isVolunteerCompatible(VolunteerProfileModel? profile) {
    if (profile == null || _selectedSkillsFilter.isEmpty) return false;

    // Retorna true se o voluntário possui todas as habilidades do filtro
    return _selectedSkillsFilter.every(
      (skill) => profile.skills.contains(skill),
    );
  }

  // Cor do badge baseada na carga de trabalho
  Color _getMicrotaskBadgeColor(int count) {
    if (count == 0) return AppColors.textSecondary;
    if (count < 3) return AppColors.success;
    if (count < 5) return AppColors.warning;
    return AppColors.error;
  }

  int _getAssignedMicrotasksCount(String userId) {
    // Primeiro, tenta usar o contador do perfil se disponível
    final profile = _getVolunteerProfile(userId);
    if (profile != null) {
      return profile.assignedMicrotasksCount;
    }

    // Fallback: conta manualmente nas microtasks
    int count = 0;
    for (final microtask in _availableMicrotasks) {
      if (microtask.assignedTo.contains(userId)) {
        count++;
      }
    }

    return count;
  }

  // Modal de seleção de habilidades para filtro
  void _showSkillsFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrar por Habilidades'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selecione as habilidades para filtrar voluntários:',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _availableSkills.length,
                  itemBuilder: (context, index) {
                    final skill = _availableSkills[index];
                    final isSelected = _selectedSkillsFilter.contains(skill);

                    return CheckboxListTile(
                      title: Text(skill),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedSkillsFilter.add(skill);
                          } else {
                            _selectedSkillsFilter.remove(skill);
                          }
                        });
                      },
                      activeColor: AppColors.primary,
                      dense: true,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedSkillsFilter.clear();
              });
              Navigator.of(context).pop();
            },
            child: const Text('Limpar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }

  void _showAssignmentDialog(
    UserModel volunteer,
    VolunteerProfileModel? profile,
  ) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => AssignmentScreen(
              eventId: widget.eventId,
              volunteer: volunteer,
              volunteerProfile: profile,
            ),
          ),
        )
        .then((result) {
          // Se a atribuição foi bem-sucedida, recarrega os dados
          if (result == true) {
            _loadData();
          }
        });
  }

  Future<void> _promoteToManager(UserModel volunteer) async {
    final confirmed = await ConfirmationDialog.showPromoteVolunteer(
      context: context,
      volunteerName: volunteer.name,
    );

    if (confirmed == true && mounted) {
      try {
        final eventController = Provider.of<EventController>(
          context,
          listen: false,
        );
        final currentUser = Provider.of<AuthController>(
          context,
          listen: false,
        ).currentUser;

        if (currentUser == null) {
          throw Exception('Usuário não autenticado');
        }

        final success = await eventController.promoteVolunteerToManager(
          eventId: widget.eventId,
          volunteerId: volunteer.id,
          managerId: currentUser.id,
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${volunteer.name} foi promovido(a) a gerente com sucesso!',
              ),
              backgroundColor: AppColors.success,
            ),
          );

          // Recarrega os dados para refletir as mudanças
          _loadData();
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                eventController.errorMessage ?? 'Erro ao promover voluntário',
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao promover voluntário: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}

```

### lib\presentation\screens\event\track_tasks_screen.dart

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/task_model.dart';
import '../../controllers/task_controller.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/skill_chip.dart';
import '../../widgets/task/task_card.dart';
import '../../widgets/task/microtask_card.dart';
import '../../widgets/task/task_progress_widget.dart';

/// Tela para acompanhamento de tasks (implementação básica)
class TrackTasksScreen extends StatefulWidget {
  final String eventId;

  const TrackTasksScreen({super.key, required this.eventId});

  @override
  State<TrackTasksScreen> createState() => _TrackTasksScreenState();
}

class _TrackTasksScreenState extends State<TrackTasksScreen> {
  final Set<String> _expandedTasks = {};
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, taskController, child) {
        if (taskController.isLoading) {
          return const LoadingWidget(message: 'Carregando tasks...');
        }

        final allTasks = taskController.tasks;
        final filteredTasks = _getFilteredTasks(allTasks);

        return Column(
          children: [
            _buildSearchAndFilters(),
            Expanded(
              child: filteredTasks.isEmpty
                  ? _buildEmptyState()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(AppDimensions.paddingLg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(allTasks),
                          const SizedBox(height: AppDimensions.spacingLg),
                          _buildTasksList(allTasks, taskController),
                        ],
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 64,
            color: AppColors.primary.withOpacity(0.5),
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          const Text(
            'Nenhuma Task Criada',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          const Text(
            'Ainda não há tasks criadas para este evento.\n\nVá para a aba "Criar Tasks" para começar a organizar o trabalho.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(List<TaskModel> tasks) {
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final totalMicrotasks = tasks.fold<int>(
      0,
      (sum, task) => sum + task.microtaskCount,
    );
    final completedMicrotasks = tasks.fold<int>(
      0,
      (sum, task) => sum + task.completedMicrotasks,
    );

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics_outlined, color: AppColors.primary),
                const SizedBox(width: AppDimensions.spacingSm),
                const Text(
                  'Progresso Geral',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Row(
              children: [
                Expanded(
                  child: _buildProgressItem(
                    'Tasks',
                    completedTasks,
                    totalTasks,
                    Icons.task_alt,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMd),
                Expanded(
                  child: _buildProgressItem(
                    'Microtasks',
                    completedMicrotasks,
                    totalMicrotasks,
                    Icons.checklist,
                    AppColors.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(
    String label,
    int completed,
    int total,
    IconData icon,
    Color color,
  ) {
    final progress = total > 0 ? completed / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            '$completed/$total',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            '${(progress * 100).toStringAsFixed(0)}%',
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

  Widget _buildTasksList(List<TaskModel> tasks, TaskController taskController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tasks do Evento',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        ...tasks.map((task) => _buildTaskCard(task, taskController)),
      ],
    );
  }

  Widget _buildTaskCard(TaskModel task, TaskController taskController) {
    final microtasks = taskController.getMicrotasksByTaskId(task.id);

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      child: ExpansionTile(
        leading: _buildTaskStatusIcon(task),
        title: Text(
          task.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXs),
            Row(
              children: [
                _buildPriorityChip(task.priority),
                const SizedBox(width: AppDimensions.spacingSm),
                Text(
                  '${task.completedMicrotasks}/${task.microtaskCount} microtasks',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          if (microtasks.isEmpty)
            const Padding(
              padding: EdgeInsets.all(AppDimensions.paddingMd),
              child: Text(
                'Nenhuma microtask criada ainda',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ...microtasks.map((microtask) => _buildMicrotaskItem(microtask)),
        ],
      ),
    );
  }

  Widget _buildTaskStatusIcon(TaskModel task) {
    IconData icon;
    Color color;

    switch (task.status) {
      case TaskStatus.pending:
        icon = Icons.schedule;
        color = AppColors.warning;
        break;
      case TaskStatus.inProgress:
        icon = Icons.play_circle;
        color = AppColors.primary;
        break;
      case TaskStatus.completed:
        icon = Icons.check_circle;
        color = AppColors.success;
        break;
      case TaskStatus.cancelled:
        icon = Icons.cancel;
        color = AppColors.error;
        break;
    }

    return Icon(icon, color: color);
  }

  Widget _buildPriorityChip(TaskPriority priority) {
    Color color;
    String text;

    switch (priority) {
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
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMicrotaskItem(microtask) {
    return ListTile(
      dense: true,
      leading: Icon(
        Icons.check_box_outline_blank,
        size: 16,
        color: AppColors.textSecondary,
      ),
      title: Text(
        microtask.title,
        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      ),
      subtitle: Text(
        'Voluntários: ${microtask.assignedTo.length}/${microtask.maxVolunteers}',
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      trailing: Text(
        microtask.status.toString().split('.').last,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
    );
  }

  List<TaskModel> _getFilteredTasks(List<TaskModel> tasks) {
    List<TaskModel> filtered = List.from(tasks);

    // Aplicar filtro de busca
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((task) {
        final title = task.title.toLowerCase();
        final description = task.description.toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || description.contains(query);
      }).toList();
    }
    return filtered;
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          // Barra de busca
          TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Buscar tasks...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
                vertical: AppDimensions.paddingSm,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
        ],
      ),
    );
  }
}

```

### lib\presentation\screens\home\home_screen.dart

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/event_controller.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/event/event_card.dart';
import '../../routes/app_routes.dart';

/// Tela home principal do aplicativo
/// Exibe lista de eventos do usuário e opções para criar/participar de eventos
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserEvents();
    });
  }

  void _loadUserEvents() {
    final authController = Provider.of<AuthController>(context, listen: false);
    final eventController = Provider.of<EventController>(
      context,
      listen: false,
    );

    if (authController.currentUser != null) {
      eventController.loadUserEvents(authController.currentUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Consumer2<AuthController, EventController>(
        builder: (context, authController, eventController, child) {
          final user = authController.currentUser;

          if (user == null) {
            return const Center(child: Text('Usuário não encontrado'));
          }

          return RefreshIndicator(
            onRefresh: () async => _loadUserEvents(),
            child: Column(
              children: [
                // Seção de boas-vindas
                _buildWelcomeSection(user.displayName),

                // Lista de eventos
                Expanded(child: _buildEventsList(eventController)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      elevation: 0,
      title: const Text(
        'ConTask',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        Consumer<AuthController>(
          builder: (context, authController, child) {
            final user = authController.currentUser;

            return Padding(
              padding: const EdgeInsets.only(right: AppDimensions.paddingMd),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Foto do usuário ou iniciais
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.secondary,
                    backgroundImage: user?.hasPhoto == true
                        ? NetworkImage(user!.photoUrl!)
                        : null,
                    child: user?.hasPhoto != true
                        ? Text(
                            user?.initials ?? 'U',
                            style: const TextStyle(
                              color: AppColors.textOnPrimary,
                              fontSize: AppDimensions.fontSizeSm,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  // Menu de opções
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'logout') {
                        _handleLogout(context);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, size: 20),
                            SizedBox(width: AppDimensions.spacingSm),
                            Text('Sair'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(String userName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDimensions.radiusLg),
          bottomRight: Radius.circular(AppDimensions.radiusLg),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Olá, ${userName.split(' ').first}!',
            style: const TextStyle(
              fontSize: AppDimensions.fontSizeXl,
              fontWeight: FontWeight.bold,
              color: AppColors.textOnPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            'Gerencie seus eventos e tarefas',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeMd,
              color: AppColors.textOnPrimary.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(EventController eventController) {
    if (eventController.isLoadingUserEvents) {
      return const Center(child: CircularProgressIndicator());
    }

    if (eventController.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              eventController.errorMessage ?? 'Erro desconhecido',
              style: const TextStyle(
                fontSize: AppDimensions.fontSizeMd,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            CustomButton.outline(
              text: 'Tentar novamente',
              onPressed: _loadUserEvents,
            ),
          ],
        ),
      );
    }

    if (eventController.userEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.event_note,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            const Text(
              'Nenhum evento encontrado',
              style: TextStyle(
                fontSize: AppDimensions.fontSizeLg,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            const Text(
              'Crie um novo evento ou participe de um existente',
              style: TextStyle(
                fontSize: AppDimensions.fontSizeMd,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            CustomButton(
              text: 'Criar Evento',
              onPressed: () => _navigateToCreateEvent(),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            CustomButton.outline(
              text: 'Participar de Evento',
              onPressed: () => _navigateToJoinEvent(),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      itemCount: eventController.userEvents.length,
      itemBuilder: (context, index) {
        final event = eventController.userEvents[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
          child: EventCard(
            event: event,
            onTap: () => _navigateToEventDetails(event.id),
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _showActionDialog(),
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.add, color: AppColors.textOnPrimary),
    );
  }

  void _showActionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('O que você gostaria de fazer?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add_circle, color: AppColors.primary),
              title: const Text('Criar Evento'),
              subtitle: const Text('Organize um novo evento'),
              onTap: () {
                Navigator.of(context).pop(); // Fecha o dialog
                _navigateToCreateEvent();
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add, color: AppColors.secondary),
              title: const Text('Participar de Evento'),
              subtitle: const Text('Entre em um evento existente'),
              onTap: () {
                Navigator.of(context).pop(); // Fecha o dialog
                _navigateToJoinEvent();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showActionBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLg),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Indicador visual
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),

            // Título
            const Text(
              'O que você gostaria de fazer?',
              style: TextStyle(
                fontSize: AppDimensions.fontSizeLg,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),

            // Opções
            ListTile(
              leading: const Icon(Icons.add_circle, color: AppColors.primary),
              title: const Text('Criar Evento'),
              subtitle: const Text('Organize um novo evento'),
              onTap: () {
                Navigator.pop(context);
                _navigateToCreateEvent();
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add, color: AppColors.secondary),
              title: const Text('Participar de Evento'),
              subtitle: const Text('Entre em um evento existente'),
              onTap: () {
                Navigator.pop(context);
                _navigateToJoinEvent();
              },
            ),

            const SizedBox(height: AppDimensions.spacingMd),
          ],
        ),
      ),
    );
  }

  void _navigateToCreateEvent() {
    AppRoutes.goToCreateEvent(context);
  }

  void _navigateToJoinEvent() {
    AppRoutes.goToJoinEvent(context);
  }

  void _navigateToEventDetails(String eventId) {
    AppRoutes.goToEventDetails(context, eventId);
  }

  Future<void> _handleLogout(BuildContext context) async {
    final authController = Provider.of<AuthController>(context, listen: false);

    await authController.signOut();

    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }
}

```

### lib\presentation\screens\task\create_microtask_screen.dart

```dart
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
        body: LoadingWidget(message: 'Carregando evento...'),
      );
    }

    if (_event == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: 'Criar Microtask'),
        body: Center(child: Text('Erro ao carregar evento')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Criar Microtask'),
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
              'Nenhuma habilidade definida no evento.',
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
              'Nenhum recurso definido no evento.',
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

```

### lib\presentation\screens\task\create_task_screen.dart

```dart
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
      appBar: const CustomAppBar(title: 'Criar Task'),
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

```

### lib\presentation\widgets\common\confirmation_dialog.dart

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Dialog de confirmação customizável
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final IconData? icon;
  final Color? iconColor;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;
  final bool isDangerous;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.icon,
    this.iconColor,
    this.confirmButtonColor,
    this.cancelButtonColor,
    this.isDangerous = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? (isDangerous ? AppColors.error : AppColors.primary),
              size: 24,
            ),
            const SizedBox(width: AppDimensions.spacingSm),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.textSecondary,
          height: 1.4,
        ),
      ),
      actions: [
        // Botão Cancelar
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(
            foregroundColor: cancelButtonColor ?? AppColors.textSecondary,
          ),
          child: Text(cancelText ?? 'Cancelar'),
        ),
        
        // Botão Confirmar
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmButtonColor ?? 
                (isDangerous ? AppColors.error : AppColors.primary),
            foregroundColor: AppColors.textOnPrimary,
          ),
          child: Text(confirmText ?? 'Confirmar'),
        ),
      ],
    );
  }

  /// Método estático para mostrar o dialog
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    IconData? icon,
    Color? iconColor,
    Color? confirmButtonColor,
    Color? cancelButtonColor,
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        icon: icon,
        iconColor: iconColor,
        confirmButtonColor: confirmButtonColor,
        cancelButtonColor: cancelButtonColor,
        isDangerous: isDangerous,
      ),
    );
  }
}

/// Dialog de confirmação para ações perigosas
class DangerConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final VoidCallback? onConfirm;

  const DangerConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: title,
      message: message,
      confirmText: confirmText ?? 'Excluir',
      icon: Icons.warning,
      isDangerous: true,
      onConfirm: onConfirm,
    );
  }

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => DangerConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        onConfirm: onConfirm,
      ),
    );
  }
}

/// Dialog de confirmação simples
class SimpleConfirmationDialog extends StatelessWidget {
  final String message;
  final VoidCallback? onConfirm;

  const SimpleConfirmationDialog({
    super.key,
    required this.message,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Não'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
          ),
          child: const Text('Sim'),
        ),
      ],
    );
  }

  static Future<bool?> show({
    required BuildContext context,
    required String message,
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => SimpleConfirmationDialog(
        message: message,
        onConfirm: onConfirm,
      ),
    );
  }
}

/// Dialog de confirmação com input
class InputConfirmationDialog extends StatefulWidget {
  final String title;
  final String message;
  final String? hintText;
  final String? confirmText;
  final Function(String)? onConfirm;
  final bool isRequired;
  final String? Function(String?)? validator;

  const InputConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.hintText,
    this.confirmText,
    this.onConfirm,
    this.isRequired = true,
    this.validator,
  });

  @override
  State<InputConfirmationDialog> createState() => _InputConfirmationDialogState();

  static Future<String?> show({
    required BuildContext context,
    required String title,
    required String message,
    String? hintText,
    String? confirmText,
    Function(String)? onConfirm,
    bool isRequired = true,
    String? Function(String?)? validator,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => InputConfirmationDialog(
        title: title,
        message: message,
        hintText: hintText,
        confirmText: confirmText,
        onConfirm: onConfirm,
        isRequired: isRequired,
        validator: validator,
      ),
    );
  }
}

class _InputConfirmationDialogState extends State<InputConfirmationDialog> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        widget.title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.message,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: const OutlineInputBorder(),
              ),
              validator: widget.validator ?? (widget.isRequired 
                  ? (value) => value?.isEmpty == true ? 'Campo obrigatório' : null
                  : null),
              autofocus: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              final value = _controller.text;
              Navigator.of(context).pop(value);
              widget.onConfirm?.call(value);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
          ),
          child: Text(widget.confirmText ?? 'Confirmar'),
        ),
      ],
    );
  }
}

```

### lib\presentation\widgets\common\custom_app_bar.dart

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// AppBar customizada para o aplicativo
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onBackPressed;
  final IconData? backIcon;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.onBackPressed,
    this.backIcon,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? AppColors.textOnPrimary,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? AppColors.textOnPrimary,
      elevation: elevation ?? 2,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading ?? (automaticallyImplyLeading && Navigator.canPop(context)
          ? IconButton(
              icon: Icon(backIcon ?? Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null),
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );
}

/// AppBar com gradiente
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final List<Color>? gradientColors;
  final double? elevation;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onBackPressed;

  const GradientAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.gradientColors,
    this.elevation,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors ?? [
            AppColors.primary,
            AppColors.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textOnPrimary,
          ),
        ),
        centerTitle: centerTitle,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textOnPrimary,
        elevation: elevation ?? 0,
        automaticallyImplyLeading: automaticallyImplyLeading,
        leading: leading ?? (automaticallyImplyLeading && Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBackPressed ?? () => Navigator.pop(context),
              )
            : null),
        actions: actions,
        bottom: bottom,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );
}

/// AppBar com busca
class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String hintText;
  final Function(String) onSearchChanged;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final VoidCallback? onBackPressed;

  const SearchAppBar({
    super.key,
    required this.title,
    required this.hintText,
    required this.onSearchChanged,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.onBackPressed,
  });

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: AppColors.textOnPrimary.withOpacity(0.7),
                ),
              ),
              style: const TextStyle(
                color: AppColors.textOnPrimary,
                fontSize: 16,
              ),
              onChanged: widget.onSearchChanged,
            )
          : Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textOnPrimary,
              ),
            ),
      centerTitle: widget.centerTitle,
      backgroundColor: widget.backgroundColor ?? AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      leading: widget.leading ?? (Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onBackPressed ?? () => Navigator.pop(context),
            )
          : null),
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
                widget.onSearchChanged('');
              }
            });
          },
        ),
        ...?widget.actions,
      ],
    );
  }
}

/// AppBar com tabs
class TabAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Tab> tabs;
  final TabController? controller;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final VoidCallback? onBackPressed;

  const TabAppBar({
    super.key,
    required this.title,
    required this.tabs,
    this.controller,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textOnPrimary,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      leading: leading ?? (Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null),
      actions: actions,
      bottom: TabBar(
        controller: controller,
        tabs: tabs,
        indicatorColor: AppColors.textOnPrimary,
        labelColor: AppColors.textOnPrimary,
        unselectedLabelColor: AppColors.textOnPrimary.withOpacity(0.7),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);
}

```

### lib\presentation\widgets\common\custom_button.dart

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Tipos de botão disponíveis
enum CustomButtonType {
  primary,
  secondary,
  outline,
  text,
  google,
}

/// Widget de botão personalizado seguindo o design system
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = CustomButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.width,
    this.height,
    this.padding,
  });

  /// Construtor para botão primário
  const CustomButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.width,
    this.height,
    this.padding,
  }) : type = CustomButtonType.primary;

  /// Construtor para botão secundário
  const CustomButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.width,
    this.height,
    this.padding,
  }) : type = CustomButtonType.secondary;

  /// Construtor para botão outline
  const CustomButton.outline({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.width,
    this.height,
    this.padding,
  }) : type = CustomButtonType.outline;

  /// Construtor para botão de texto
  const CustomButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.width,
    this.height,
    this.padding,
  }) : type = CustomButtonType.text;

  /// Construtor para botão do Google
  const CustomButton.google({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width,
    this.height,
    this.padding,
  }) : type = CustomButtonType.google,
       icon = null;

  @override
  Widget build(BuildContext context) {
    final buttonWidth = isFullWidth ? double.infinity : width;
    final buttonHeight = height ?? AppDimensions.buttonHeightMd;

    Widget button = _buildButton(context);

    if (buttonWidth != null) {
      button = SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: button,
      );
    }

    return button;
  }

  Widget _buildButton(BuildContext context) {
    switch (type) {
      case CustomButtonType.primary:
        return _buildElevatedButton(context);
      case CustomButtonType.secondary:
        return _buildSecondaryButton(context);
      case CustomButtonType.outline:
        return _buildOutlinedButton(context);
      case CustomButtonType.text:
        return _buildTextButton(context);
      case CustomButtonType.google:
        return _buildGoogleButton(context);
    }
  }

  Widget _buildElevatedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        disabledBackgroundColor: AppColors.disabled,
        elevation: AppDimensions.elevationSm,
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLg,
          vertical: AppDimensions.paddingMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.textPrimary,
        disabledBackgroundColor: AppColors.disabled,
        elevation: AppDimensions.elevationSm,
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLg,
          vertical: AppDimensions.paddingMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildOutlinedButton(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.disabled,
        side: BorderSide(
          color: onPressed != null ? AppColors.primary : AppColors.disabled,
          width: AppDimensions.borderWidthThin,
        ),
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLg,
          vertical: AppDimensions.paddingMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.disabled,
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
          vertical: AppDimensions.paddingSm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildGoogleButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        disabledBackgroundColor: AppColors.disabled,
        elevation: AppDimensions.elevationSm,
        side: const BorderSide(
          color: AppColors.border,
          width: AppDimensions.borderWidthThin,
        ),
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLg,
          vertical: AppDimensions.paddingMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
      child: _buildGoogleButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        width: AppDimensions.iconSm,
        height: AppDimensions.iconSm,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppDimensions.iconSm,
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Text(
            text,
            style: const TextStyle(
              fontSize: AppDimensions.fontSizeLg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: const TextStyle(
        fontSize: AppDimensions.fontSizeLg,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildGoogleButtonContent() {
    if (isLoading) {
      return const SizedBox(
        width: AppDimensions.iconSm,
        height: AppDimensions.iconSm,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Ícone do Google (pode ser substituído por um asset)
        Container(
          width: AppDimensions.iconSm,
          height: AppDimensions.iconSm,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.g_mobiledata,
            color: Colors.white,
            size: AppDimensions.iconSm,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingMd),
        Text(
          text,
          style: const TextStyle(
            fontSize: AppDimensions.fontSizeLg,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

```

### lib\presentation\widgets\common\custom_text_field.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Widget de campo de texto personalizado seguindo o design system
class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? maxLength;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.inputFormatters,
    this.focusNode,
    this.contentPadding,
  });

  /// Construtor para campo de email
  const CustomTextField.email({
    super.key,
    this.label = 'E-mail',
    this.hint = 'Digite seu e-mail',
    this.initialValue,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.contentPadding,
  }) : keyboardType = TextInputType.emailAddress,
       textInputAction = TextInputAction.next,
       obscureText = false,
       maxLines = 1,
       maxLength = null,
       prefixIcon = Icons.email_outlined,
       suffixIcon = null,
       onSuffixIconPressed = null,
       inputFormatters = null;

  /// Construtor para campo de senha
  const CustomTextField.password({
    super.key,
    this.label = 'Senha',
    this.hint = 'Digite sua senha',
    this.initialValue,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.contentPadding,
  }) : keyboardType = TextInputType.visiblePassword,
       textInputAction = TextInputAction.done,
       obscureText = true,
       maxLines = 1,
       maxLength = null,
       prefixIcon = Icons.lock_outlined,
       suffixIcon = null,
       onSuffixIconPressed = null,
       inputFormatters = null;

  /// Construtor para campo de nome
  const CustomTextField.name({
    super.key,
    this.label = 'Nome',
    this.hint = 'Digite seu nome',
    this.initialValue,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.contentPadding,
  }) : keyboardType = TextInputType.name,
       textInputAction = TextInputAction.next,
       obscureText = false,
       maxLines = 1,
       maxLength = 50,
       prefixIcon = Icons.person_outlined,
       suffixIcon = null,
       onSuffixIconPressed = null,
       inputFormatters = null;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  late TextEditingController _controller;
  bool _controllerCreatedInternally = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController(text: widget.initialValue);
      _controllerCreatedInternally = true;
    }
  }

  @override
  void dispose() {
    if (_controllerCreatedInternally) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: AppDimensions.fontSizeMd,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
        ],
        TextFormField(
          controller: _controller,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          focusNode: widget.focusNode,
          style: const TextStyle(
            fontSize: AppDimensions.fontSizeMd,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(
              color: AppColors.textLight,
              fontSize: AppDimensions.fontSizeMd,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: AppColors.textSecondary,
                    size: AppDimensions.iconSm,
                  )
                : null,
            suffixIcon: _buildSuffixIcon(),
            filled: true,
            fillColor: widget.enabled ? AppColors.surface : AppColors.disabled,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: const BorderSide(
                color: AppColors.border,
                width: AppDimensions.borderWidthThin,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: const BorderSide(
                color: AppColors.border,
                width: AppDimensions.borderWidthThin,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: AppDimensions.borderWidthMedium,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: AppDimensions.borderWidthThin,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: AppDimensions.borderWidthMedium,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: const BorderSide(
                color: AppColors.disabled,
                width: AppDimensions.borderWidthThin,
              ),
            ),
            contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMd,
              vertical: AppDimensions.paddingMd,
            ),
            counterStyle: const TextStyle(
              color: AppColors.textLight,
              fontSize: AppDimensions.fontSizeSm,
            ),
            errorStyle: const TextStyle(
              color: AppColors.error,
              fontSize: AppDimensions.fontSizeSm,
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    // Se é um campo de senha, mostra o ícone de visibilidade
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: AppColors.textSecondary,
          size: AppDimensions.iconSm,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    // Se tem um ícone de sufixo personalizado
    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          color: AppColors.textSecondary,
          size: AppDimensions.iconSm,
        ),
        onPressed: widget.onSuffixIconPressed,
      );
    }

    return null;
  }
}

```

### lib\presentation\widgets\common\error_message_widget.dart

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Widget para exibir mensagens de erro de forma consistente
class ErrorMessageWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final bool showRetryButton;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const ErrorMessageWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.showRetryButton = true,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  /// Factory para erro de rede
  factory ErrorMessageWidget.network({
    required String message,
    VoidCallback? onRetry,
  }) {
    return ErrorMessageWidget(
      message: message,
      onRetry: onRetry,
      icon: Icons.wifi_off,
      showRetryButton: true,
    );
  }

  /// Factory para erro de validação
  factory ErrorMessageWidget.validation({required String message}) {
    return ErrorMessageWidget(
      message: message,
      icon: Icons.warning,
      showRetryButton: false,
      backgroundColor: AppColors.warning.withValues(alpha: 0.1),
      textColor: AppColors.warning,
      borderColor: AppColors.warning.withValues(alpha: 0.3),
    );
  }

  /// Factory para erro de permissão
  factory ErrorMessageWidget.permission({
    required String message,
    VoidCallback? onRetry,
  }) {
    return ErrorMessageWidget(
      message: message,
      onRetry: onRetry,
      icon: Icons.lock,
      showRetryButton: false,
      backgroundColor: AppColors.error.withValues(alpha: 0.1),
      textColor: AppColors.error,
      borderColor: AppColors.error.withValues(alpha: 0.3),
    );
  }

  /// Factory para erro genérico
  factory ErrorMessageWidget.generic({
    required String message,
    VoidCallback? onRetry,
  }) {
    return ErrorMessageWidget(
      message: message,
      onRetry: onRetry,
      icon: Icons.error_outline,
      showRetryButton: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor =
        backgroundColor ?? AppColors.error.withValues(alpha: 0.1);
    final effectiveTextColor = textColor ?? AppColors.error;
    final effectiveBorderColor =
        borderColor ?? AppColors.error.withValues(alpha: 0.3);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: effectiveBorderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon ?? Icons.error_outline,
                color: effectiveTextColor,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: effectiveTextColor,
                    fontSize: AppDimensions.fontSizeMd,
                  ),
                ),
              ),
            ],
          ),

          if (showRetryButton && onRetry != null) ...[
            const SizedBox(height: AppDimensions.spacingMd),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar Novamente'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: effectiveTextColor,
                  side: BorderSide(color: effectiveTextColor),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget para exibir estado vazio
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? action;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon ?? Icons.inbox, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              title,
              style: const TextStyle(
                fontSize: AppDimensions.fontSizeLg,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: AppDimensions.fontSizeMd,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppDimensions.spacingLg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget para exibir feedback de sucesso
class SuccessMessageWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;
  final bool showDismissButton;

  const SuccessMessageWidget({
    super.key,
    required this.message,
    this.onDismiss,
    this.showDismissButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 20),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.success,
                fontSize: AppDimensions.fontSizeMd,
              ),
            ),
          ),
          if (showDismissButton && onDismiss != null) ...[
            const SizedBox(width: AppDimensions.spacingSm),
            IconButton(
              onPressed: onDismiss,
              icon: const Icon(Icons.close, color: AppColors.success, size: 18),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget para exibir informações importantes
class InfoMessageWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;
  final bool showDismissButton;

  const InfoMessageWidget({
    super.key,
    required this.message,
    this.onDismiss,
    this.showDismissButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info, color: AppColors.info, size: 20),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.info,
                fontSize: AppDimensions.fontSizeMd,
              ),
            ),
          ),
          if (showDismissButton && onDismiss != null) ...[
            const SizedBox(width: AppDimensions.spacingSm),
            IconButton(
              onPressed: onDismiss,
              icon: const Icon(Icons.close, color: AppColors.info, size: 18),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
            ),
          ],
        ],
      ),
    );
  }
}

```

### lib\presentation\widgets\common\error_widget.dart

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Widget customizado para exibir erros
class CustomErrorWidget extends StatelessWidget {
  final String message;
  final String? title;
  final IconData? icon;
  final VoidCallback? onRetry;
  final String? retryText;
  final bool showIcon;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.title,
    this.icon,
    this.onRetry,
    this.retryText,
    this.showIcon = true,
    this.iconColor,
    this.textColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone de erro
            if (showIcon) ...[
              Icon(
                icon ?? Icons.error_outline,
                size: iconSize ?? 64,
                color: iconColor ?? AppColors.error,
              ),
              const SizedBox(height: AppDimensions.spacingLg),
            ],

            // Título (opcional)
            if (title != null) ...[
              Text(
                title!,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingMd),
            ],

            // Mensagem de erro
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: textColor ?? AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            // Botão de retry (opcional)
            if (onRetry != null) ...[
              const SizedBox(height: AppDimensions.spacingLg),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryText ?? 'Tentar Novamente'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingLg,
                    vertical: AppDimensions.paddingMd,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget de erro compacto para usar em cards ou listas
class CompactErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final Color? color;

  const CompactErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: (color ?? AppColors.error).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (color ?? AppColors.error).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon ?? Icons.warning_amber,
            color: color ?? AppColors.error,
            size: 20,
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: color ?? AppColors.error,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: AppDimensions.spacingSm),
            IconButton(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              color: color ?? AppColors.error,
              iconSize: 20,
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget de erro para conexão de rede
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? customMessage;

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'Sem Conexão',
      message: customMessage ?? 
          'Verifique sua conexão com a internet e tente novamente.',
      icon: Icons.wifi_off,
      iconColor: AppColors.warning,
      onRetry: onRetry,
      retryText: 'Tentar Novamente',
    );
  }
}

/// Widget de erro para dados não encontrados
class NotFoundErrorWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onAction;
  final String? actionText;
  final IconData? icon;

  const NotFoundErrorWidget({
    super.key,
    this.title,
    this.message,
    this.onAction,
    this.actionText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: title ?? 'Nada Encontrado',
      message: message ?? 'Não foram encontrados dados para exibir.',
      icon: icon ?? Icons.search_off,
      iconColor: AppColors.textSecondary,
      onRetry: onAction,
      retryText: actionText,
    );
  }
}

/// Widget de erro para permissões
class PermissionErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRequestPermission;

  const PermissionErrorWidget({
    super.key,
    this.message,
    this.onRequestPermission,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'Permissão Necessária',
      message: message ?? 
          'Esta funcionalidade requer permissões específicas para funcionar.',
      icon: Icons.lock_outline,
      iconColor: AppColors.warning,
      onRetry: onRequestPermission,
      retryText: 'Conceder Permissão',
    );
  }
}

/// Widget de erro genérico com diferentes tipos
class ErrorDisplayWidget extends StatelessWidget {
  final ErrorType type;
  final String? customMessage;
  final VoidCallback? onAction;
  final String? actionText;

  const ErrorDisplayWidget({
    super.key,
    required this.type,
    this.customMessage,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ErrorType.network:
        return NetworkErrorWidget(
          onRetry: onAction,
          customMessage: customMessage,
        );
      case ErrorType.notFound:
        return NotFoundErrorWidget(
          message: customMessage,
          onAction: onAction,
          actionText: actionText,
        );
      case ErrorType.permission:
        return PermissionErrorWidget(
          message: customMessage,
          onRequestPermission: onAction,
        );
      case ErrorType.server:
        return CustomErrorWidget(
          title: 'Erro do Servidor',
          message: customMessage ?? 'Ocorreu um erro no servidor. Tente novamente.',
          icon: Icons.cloud_off,
          iconColor: AppColors.error,
          onRetry: onAction,
          retryText: actionText ?? 'Tentar Novamente',
        );
      case ErrorType.validation:
        return CompactErrorWidget(
          message: customMessage ?? 'Dados inválidos fornecidos.',
          color: AppColors.warning,
          icon: Icons.warning_amber,
        );
      case ErrorType.generic:
      default:
        return CustomErrorWidget(
          message: customMessage ?? 'Ocorreu um erro inesperado.',
          onRetry: onAction,
          retryText: actionText,
        );
    }
  }
}

/// Tipos de erro suportados
enum ErrorType {
  network,
  notFound,
  permission,
  server,
  validation,
  generic,
}

```

### lib\presentation\widgets\common\loading_widget.dart

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Widget para exibir indicador de carregamento
class LoadingWidget extends StatelessWidget {
  final String? message;
  final Color? color;
  final double? size;

  const LoadingWidget({
    super.key,
    this.message,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size ?? 40,
            height: size ?? 40,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppColors.primary,
              ),
              strokeWidth: 3,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              message!,
              style: const TextStyle(
                fontSize: AppDimensions.fontSizeMd,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

```

### lib\presentation\widgets\common\skill_chip.dart

```dart
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

```

### lib\presentation\widgets\dialogs\assignment_dialog.dart

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/microtask_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/volunteer_profile_model.dart';

/// Dialog para atribuição de voluntários a microtasks
class AssignmentDialog extends StatefulWidget {
  final List<MicrotaskModel> availableMicrotasks;
  final UserModel volunteer;
  final VolunteerProfileModel? volunteerProfile;
  final Function(String microtaskId) onAssign;

  const AssignmentDialog({
    super.key,
    required this.availableMicrotasks,
    required this.volunteer,
    this.volunteerProfile,
    required this.onAssign,
  });

  @override
  State<AssignmentDialog> createState() => _AssignmentDialogState();
}

class _AssignmentDialogState extends State<AssignmentDialog> {
  String? _selectedMicrotaskId;
  List<MicrotaskModel> _filteredMicrotasks = [];
  bool _showOnlyCompatible = false;

  @override
  void initState() {
    super.initState();
    _filteredMicrotasks = widget.availableMicrotasks;
    _filterMicrotasks();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(
                  Icons.assignment,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Atribuir Microtask',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Para: ${widget.volunteer.name}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  color: AppColors.textSecondary,
                ),
              ],
            ),

            const SizedBox(height: AppDimensions.spacingLg),

            // Filtro de compatibilidade
            if (widget.volunteerProfile != null) _buildCompatibilityFilter(),

            const SizedBox(height: AppDimensions.spacingMd),

            // Lista de microtasks
            Expanded(
              child: _filteredMicrotasks.isEmpty
                  ? _buildEmptyState()
                  : _buildMicrotasksList(),
            ),

            const SizedBox(height: AppDimensions.spacingLg),

            // Botões de ação
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMd),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedMicrotaskId != null
                        ? () {
                            widget.onAssign(_selectedMicrotaskId!);
                            Navigator.of(context).pop();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                    ),
                    child: const Text('Atribuir'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompatibilityFilter() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_list, size: 20, color: AppColors.primary),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Text(
              'Mostrar apenas microtasks compatíveis',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Switch(
            value: _showOnlyCompatible,
            onChanged: (value) {
              setState(() {
                _showOnlyCompatible = value;
                _filterMicrotasks();
              });
            },
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Text(
            _showOnlyCompatible
                ? 'Nenhuma microtask compatível encontrada'
                : 'Nenhuma microtask disponível',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          if (_showOnlyCompatible) ...[
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              'Tente desabilitar o filtro de compatibilidade',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMicrotasksList() {
    return ListView.builder(
      itemCount: _filteredMicrotasks.length,
      itemBuilder: (context, index) {
        final microtask = _filteredMicrotasks[index];
        final isSelected = _selectedMicrotaskId == microtask.id;
        final isCompatible = _isCompatible(microtask);

        return Card(
          elevation: isSelected ? 4 : 1,
          margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedMicrotaskId = isSelected ? null : microtask.id;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: isSelected
                    ? Border.all(color: AppColors.primary, width: 2)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      // Indicador de compatibilidade
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isCompatible
                              ? AppColors.success
                              : AppColors.warning,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacingSm),

                      // Título
                      Expanded(
                        child: Text(
                          microtask.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),

                      // Badge de prioridade
                      _buildPriorityBadge(microtask.priority as int),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.spacingSm),

                  // Descrição
                  if (microtask.description.isNotEmpty)
                    Text(
                      microtask.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: AppDimensions.spacingSm),

                  // Informações
                  Row(
                    children: [
                      _buildInfoChip(
                        icon: Icons.schedule,
                        label: microtask.hasSchedule
                            ? '${microtask.estimatedHours.toStringAsFixed(1)}h'
                            : 'Não definido',
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: AppDimensions.spacingSm),
                      _buildInfoChip(
                        icon: Icons.people,
                        label:
                            '0/${microtask.maxVolunteers}', // TODO: Buscar voluntários atribuídos
                        color: AppColors.primary,
                      ),
                    ],
                  ),

                  // Habilidades e recursos necessários
                  if (microtask.requiredSkills.isNotEmpty ||
                      microtask.requiredResources.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.spacingSm),
                    _buildRequirementsInfo(microtask, isCompatible),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriorityBadge(int priority) {
    Color color;
    String text;

    switch (priority) {
      case 3: // high
        color = AppColors.error;
        text = 'Alta';
        break;
      case 2: // medium
        color = AppColors.warning;
        text = 'Média';
        break;
      case 1: // low
        color = AppColors.success;
        text = 'Baixa';
        break;
      default:
        color = AppColors.warning;
        text = 'Média';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
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

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementsInfo(MicrotaskModel microtask, bool isCompatible) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (microtask.requiredSkills.isNotEmpty) ...[
          Text(
            'Habilidades: ${microtask.requiredSkills.join(', ')}',
            style: TextStyle(
              fontSize: 10,
              color: isCompatible ? AppColors.success : AppColors.warning,
            ),
          ),
        ],
        if (microtask.requiredResources.isNotEmpty) ...[
          Text(
            'Recursos: ${microtask.requiredResources.join(', ')}',
            style: TextStyle(
              fontSize: 10,
              color: isCompatible ? AppColors.success : AppColors.warning,
            ),
          ),
        ],
      ],
    );
  }

  void _filterMicrotasks() {
    if (_showOnlyCompatible && widget.volunteerProfile != null) {
      _filteredMicrotasks = widget.availableMicrotasks
          .where((microtask) => _isCompatible(microtask))
          .toList();
    } else {
      _filteredMicrotasks = widget.availableMicrotasks;
    }
  }

  bool _isCompatible(MicrotaskModel microtask) {
    if (widget.volunteerProfile == null) return true;

    final volunteerSkills = widget.volunteerProfile!.skills;
    final volunteerResources = widget.volunteerProfile!.resources;

    // Verificar se o voluntário tem todas as habilidades necessárias
    final hasRequiredSkills = microtask.requiredSkills.every(
      (skill) => volunteerSkills.contains(skill),
    );

    // Verificar se o voluntário tem todos os recursos necessários
    final hasRequiredResources = microtask.requiredResources.every(
      (resource) => volunteerResources.contains(resource),
    );

    return hasRequiredSkills && hasRequiredResources;
  }
}

```

### lib\presentation\widgets\dialogs\confirmation_dialog.dart

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Dialog genérico de confirmação reutilizável
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmButtonColor;
  final Color? confirmTextColor;
  final IconData? icon;
  final Color? iconColor;
  final bool isDestructive;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = 'Confirmar',
    this.cancelText = 'Cancelar',
    this.onConfirm,
    this.onCancel,
    this.confirmButtonColor,
    this.confirmTextColor,
    this.icon,
    this.iconColor,
    this.isDestructive = false,
  });

  /// Factory para criar um dialog de promoção de voluntário
  factory ConfirmationDialog.promoteVolunteer({
    required String volunteerName,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return ConfirmationDialog(
      title: 'Promover Voluntário',
      content: 'Tem certeza de que deseja promover "$volunteerName" a gerente?\n\n'
          'Esta ação concederá permissões de gerenciamento do evento ao usuário. '
          'O voluntário poderá criar tasks, gerenciar outros voluntários e '
          'modificar configurações do evento.\n\n'
          'Esta ação não pode ser desfeita facilmente.',
      confirmText: 'Confirmar Promoção',
      cancelText: 'Cancelar',
      onConfirm: onConfirm,
      onCancel: onCancel,
      confirmButtonColor: AppColors.warning,
      confirmTextColor: Colors.white,
      icon: Icons.admin_panel_settings,
      iconColor: AppColors.warning,
      isDestructive: false,
    );
  }

  /// Factory para criar um dialog de remoção/exclusão
  factory ConfirmationDialog.delete({
    required String title,
    required String itemName,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return ConfirmationDialog(
      title: title,
      content: 'Tem certeza de que deseja excluir "$itemName"?\n\n'
          'Esta ação não pode ser desfeita.',
      confirmText: 'Excluir',
      cancelText: 'Cancelar',
      onConfirm: onConfirm,
      onCancel: onCancel,
      confirmButtonColor: AppColors.error,
      confirmTextColor: Colors.white,
      icon: Icons.delete_forever,
      iconColor: AppColors.error,
      isDestructive: true,
    );
  }

  /// Factory para criar um dialog de saída/logout
  factory ConfirmationDialog.logout({
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return ConfirmationDialog(
      title: 'Sair da Conta',
      content: 'Tem certeza de que deseja sair da sua conta?',
      confirmText: 'Sair',
      cancelText: 'Cancelar',
      onConfirm: onConfirm,
      onCancel: onCancel,
      confirmButtonColor: AppColors.error,
      confirmTextColor: Colors.white,
      icon: Icons.logout,
      iconColor: AppColors.error,
      isDestructive: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: AppDimensions.spacingMd),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 300,
        ),
        child: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          child: Text(
            cancelText,
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm != null
              ? () {
                  onConfirm!();
                  Navigator.of(context).pop(true);
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmButtonColor ?? AppColors.primary,
            foregroundColor: confirmTextColor ?? Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }

  /// Método estático para mostrar o dialog e retornar o resultado
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    Color? confirmButtonColor,
    Color? confirmTextColor,
    IconData? icon,
    Color? iconColor,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmButtonColor: confirmButtonColor,
        confirmTextColor: confirmTextColor,
        icon: icon,
        iconColor: iconColor,
        isDestructive: isDestructive,
        onConfirm: () {}, // O callback será tratado pelo retorno do showDialog
      ),
    );
  }

  /// Método estático para mostrar dialog de promoção
  static Future<bool?> showPromoteVolunteer({
    required BuildContext context,
    required String volunteerName,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialog.promoteVolunteer(
        volunteerName: volunteerName,
        onConfirm: () {}, // O callback será tratado pelo retorno do showDialog
      ),
    );
  }

  /// Método estático para mostrar dialog de exclusão
  static Future<bool?> showDelete({
    required BuildContext context,
    required String title,
    required String itemName,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialog.delete(
        title: title,
        itemName: itemName,
        onConfirm: () {}, // O callback será tratado pelo retorno do showDialog
      ),
    );
  }

  /// Método estático para mostrar dialog de logout
  static Future<bool?> showLogout({
    required BuildContext context,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialog.logout(
        onConfirm: () {}, // O callback será tratado pelo retorno do showDialog
      ),
    );
  }
}

```

### lib\presentation\widgets\event\event_card.dart

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/event_model.dart';

/// Widget de card para exibir informações de um evento na lista
class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;
  final String? currentUserId;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppDimensions.elevationSm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com nome e status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.name,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontSizeLg,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  _buildStatusChip(),
                ],
              ),
              
              const SizedBox(height: AppDimensions.spacingSm),
              
              // Descrição
              if (event.description.isNotEmpty) ...[
                Text(
                  event.shortDescription,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontSizeMd,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
                        fontSize: AppDimensions.fontSizeSm,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppDimensions.spacingSm),
              
              // Papel do usuário e participantes
              Row(
                children: [
                  _buildUserRoleChip(),
                  const Spacer(),
                  _buildParticipantsInfo(),
                ],
              ),
              
              const SizedBox(height: AppDimensions.spacingSm),
              
              // Tag do evento e data
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingSm,
                      vertical: AppDimensions.paddingXs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: Text(
                      event.tag,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontSizeSm,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    event.createdTimeAgo,
                    style: const TextStyle(
                      fontSize: AppDimensions.fontSizeSm,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (event.status) {
      case EventStatus.active:
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        text = 'Ativo';
        break;
      case EventStatus.completed:
        backgroundColor = AppColors.textSecondary.withValues(alpha: 0.1);
        textColor = AppColors.textSecondary;
        text = 'Concluído';
        break;
      case EventStatus.cancelled:
        backgroundColor = AppColors.error.withValues(alpha: 0.1);
        textColor = AppColors.error;
        text = 'Cancelado';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSm,
        vertical: AppDimensions.paddingXs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppDimensions.fontSizeSm,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildUserRoleChip() {
    if (currentUserId == null) {
      return const SizedBox.shrink();
    }

    final role = event.getUserRole(currentUserId!);
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String text;

    switch (role) {
      case UserRole.creator:
        backgroundColor = AppColors.primary.withValues(alpha: 0.1);
        textColor = AppColors.primary;
        icon = Icons.star;
        text = 'Criador';
        break;
      case UserRole.manager:
        backgroundColor = AppColors.secondary.withValues(alpha: 0.1);
        textColor = AppColors.secondary;
        icon = Icons.admin_panel_settings;
        text = 'Gerenciador';
        break;
      case UserRole.volunteer:
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        icon = Icons.volunteer_activism;
        text = 'Voluntário';
        break;
      case UserRole.none:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSm,
        vertical: AppDimensions.paddingXs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: textColor,
          ),
          const SizedBox(width: AppDimensions.spacingXs),
          Text(
            text,
            style: TextStyle(
              fontSize: AppDimensions.fontSizeSm,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsInfo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.people,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppDimensions.spacingXs),
        Text(
          '${event.totalParticipants}',
          style: const TextStyle(
            fontSize: AppDimensions.fontSizeSm,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

```

### lib\presentation\widgets\event\event_info_card.dart

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/event_model.dart';
import 'skill_chip.dart';

/// Widget de card para exibir informações detalhadas de um evento
class EventInfoCard extends StatelessWidget {
  final EventModel event;
  final String? currentUserId;
  final VoidCallback? onTap;
  final bool showFullDescription;
  final bool showParticipants;
  final bool showRequirements;

  const EventInfoCard({
    super.key,
    required this.event,
    this.currentUserId,
    this.onTap,
    this.showFullDescription = false,
    this.showParticipants = true,
    this.showRequirements = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppDimensions.elevationSm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com nome e status
              _buildHeader(),
              
              const SizedBox(height: AppDimensions.spacingMd),
              
              // Descrição
              if (event.description.isNotEmpty) ...[
                _buildDescription(),
                const SizedBox(height: AppDimensions.spacingMd),
              ],
              
              // Localização
              _buildLocation(),
              
              const SizedBox(height: AppDimensions.spacingMd),
              
              // Papel do usuário e participantes
              if (showParticipants) ...[
                _buildParticipantsInfo(),
                const SizedBox(height: AppDimensions.spacingMd),
              ],
              
              // Habilidades necessárias
              if (showRequirements && event.requiredSkills.isNotEmpty) ...[
                _buildRequiredSkills(),
                const SizedBox(height: AppDimensions.spacingMd),
              ],
              
              // Recursos necessários
              if (showRequirements && event.requiredResources.isNotEmpty) ...[
                _buildRequiredResources(),
                const SizedBox(height: AppDimensions.spacingMd),
              ],
              
              // Footer com tag e data
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            event.name,
            style: const TextStyle(
              fontSize: AppDimensions.fontSizeXl,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        _buildStatusChip(),
      ],
    );
  }

  Widget _buildDescription() {
    final description = showFullDescription ? event.description : event.shortDescription;
    
    return Text(
      description,
      style: const TextStyle(
        fontSize: AppDimensions.fontSizeMd,
        color: AppColors.textSecondary,
        height: 1.4,
      ),
      maxLines: showFullDescription ? null : 3,
      overflow: showFullDescription ? null : TextOverflow.ellipsis,
    );
  }

  Widget _buildLocation() {
    return Row(
      children: [
        const Icon(
          Icons.location_on,
          size: 18,
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantsInfo() {
    return Row(
      children: [
        // Papel do usuário
        if (currentUserId != null) ...[
          _buildUserRoleChip(),
          const Spacer(),
        ],
        
        // Número de participantes
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.people,
              size: 18,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppDimensions.spacingXs),
            Text(
              '${event.totalParticipants} participante${event.totalParticipants != 1 ? 's' : ''}',
              style: const TextStyle(
                fontSize: AppDimensions.fontSizeMd,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRequiredSkills() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            return SkillChip(
              label: skill,
              isSelected: false,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              textColor: AppColors.primary,
              borderColor: AppColors.primary.withValues(alpha: 0.3),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRequiredResources() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            return SkillChip(
              label: resource,
              isSelected: false,
              backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
              textColor: AppColors.secondary,
              borderColor: AppColors.secondary.withValues(alpha: 0.3),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        // Tag do evento
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMd,
            vertical: AppDimensions.paddingSm,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.tag,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppDimensions.spacingXs),
              Text(
                event.tag,
                style: const TextStyle(
                  fontSize: AppDimensions.fontSizeSm,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        
        const Spacer(),
        
        // Data de criação
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Criado ${event.createdTimeAgo}',
              style: const TextStyle(
                fontSize: AppDimensions.fontSizeSm,
                color: AppColors.textSecondary,
              ),
            ),
            if (event.createdAt != event.updatedAt) ...[
              const SizedBox(height: AppDimensions.spacingXs),
              Text(
                'Atualizado ${event.updatedTimeAgo}',
                style: const TextStyle(
                  fontSize: AppDimensions.fontSizeXs,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip() {
    Color backgroundColor;
    Color textColor;
    String text;
    IconData icon;

    switch (event.status) {
      case EventStatus.active:
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        text = 'Ativo';
        icon = Icons.play_circle;
        break;
      case EventStatus.completed:
        backgroundColor = AppColors.statusCompleted.withValues(alpha: 0.1);
        textColor = AppColors.statusCompleted;
        text = 'Concluído';
        icon = Icons.check_circle;
        break;
      case EventStatus.cancelled:
        backgroundColor = AppColors.error.withValues(alpha: 0.1);
        textColor = AppColors.error;
        text = 'Cancelado';
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingSm,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: textColor,
          ),
          const SizedBox(width: AppDimensions.spacingXs),
          Text(
            text,
            style: TextStyle(
              fontSize: AppDimensions.fontSizeSm,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRoleChip() {
    if (currentUserId == null) {
      return const SizedBox.shrink();
    }

    final role = event.getUserRole(currentUserId!);
    if (role == UserRole.none) {
      return const SizedBox.shrink();
    }

    Color backgroundColor;
    Color textColor;
    IconData icon;
    String text;

    switch (role) {
      case UserRole.creator:
        backgroundColor = AppColors.primary.withValues(alpha: 0.1);
        textColor = AppColors.primary;
        icon = Icons.star;
        text = 'Criador';
        break;
      case UserRole.manager:
        backgroundColor = AppColors.secondary.withValues(alpha: 0.1);
        textColor = AppColors.secondary;
        icon = Icons.admin_panel_settings;
        text = 'Gerenciador';
        break;
      case UserRole.volunteer:
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        icon = Icons.volunteer_activism;
        text = 'Voluntário';
        break;
      case UserRole.none:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingSm,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: textColor,
          ),
          const SizedBox(width: AppDimensions.spacingXs),
          Text(
            text,
            style: TextStyle(
              fontSize: AppDimensions.fontSizeSm,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

```

### lib\presentation\widgets\event\event_stats_widget.dart

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/event_model.dart';

/// Widget para exibir estatísticas de um evento
class EventStatsWidget extends StatelessWidget {
  final EventModel event;
  final bool showDetailed;

  const EventStatsWidget({
    super.key,
    required this.event,
    this.showDetailed = false,
  });

  @override
  Widget build(BuildContext context) {
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
            // Título
            const Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: AppColors.primary,
                  size: 24,
                ),
                SizedBox(width: AppDimensions.spacingSm),
                Text(
                  'Estatísticas do Evento',
                  style: TextStyle(
                    fontSize: AppDimensions.fontSizeLg,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.spacingLg),
            
            // Estatísticas básicas
            _buildBasicStats(),
            
            if (showDetailed) ...[
              const SizedBox(height: AppDimensions.spacingLg),
              const Divider(),
              const SizedBox(height: AppDimensions.spacingLg),
              
              // Estatísticas detalhadas
              _buildDetailedStats(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBasicStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            icon: Icons.people,
            label: 'Participantes',
            value: event.totalParticipants.toString(),
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingMd),
        Expanded(
          child: _buildStatItem(
            icon: Icons.admin_panel_settings,
            label: 'Gerenciadores',
            value: event.managers.length.toString(),
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingMd),
        Expanded(
          child: _buildStatItem(
            icon: Icons.volunteer_activism,
            label: 'Voluntários',
            value: event.volunteers.length.toString(),
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Habilidades necessárias
        _buildRequirementStats(
          title: 'Habilidades Necessárias',
          icon: Icons.psychology,
          items: event.requiredSkills,
          color: AppColors.info,
        ),
        
        const SizedBox(height: AppDimensions.spacingLg),
        
        // Recursos necessários
        _buildRequirementStats(
          title: 'Recursos Necessários',
          icon: Icons.inventory,
          items: event.requiredResources,
          color: AppColors.warning,
        ),
        
        const SizedBox(height: AppDimensions.spacingLg),
        
        // Informações temporais
        _buildTemporalInfo(),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            value,
            style: TextStyle(
              fontSize: AppDimensions.fontSizeXl,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppDimensions.fontSizeSm,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementStats({
    required String title,
    required IconData icon,
    required List<String> items,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            Text(
              title,
              style: TextStyle(
                fontSize: AppDimensions.fontSizeMd,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingSm,
                vertical: AppDimensions.paddingXs,
              ),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Text(
                items.length.toString(),
                style: TextStyle(
                  fontSize: AppDimensions.fontSizeSm,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppDimensions.spacingSm),
        
        if (items.isEmpty)
          Text(
            'Nenhum item especificado',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeMd,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
              fontStyle: FontStyle.italic,
            ),
          )
        else
          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingSm,
            children: items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingSm,
                  vertical: AppDimensions.paddingXs,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: AppDimensions.fontSizeSm,
                    color: color,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildTemporalInfo() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.schedule,
                color: AppColors.textSecondary,
                size: 20,
              ),
              SizedBox(width: AppDimensions.spacingSm),
              Text(
                'Informações Temporais',
                style: TextStyle(
                  fontSize: AppDimensions.fontSizeMd,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppDimensions.spacingMd),
          
          // Data de criação
          _buildTemporalItem(
            icon: Icons.add_circle,
            label: 'Criado em',
            value: _formatDate(event.createdAt),
            subtitle: event.createdTimeAgo,
          ),
          
          const SizedBox(height: AppDimensions.spacingSm),
          
          // Data de atualização
          if (event.createdAt != event.updatedAt)
            _buildTemporalItem(
              icon: Icons.update,
              label: 'Última atualização',
              value: _formatDate(event.updatedAt),
              subtitle: event.updatedTimeAgo,
            ),
          
          const SizedBox(height: AppDimensions.spacingSm),
          
          // Indicador de evento novo
          if (event.isNewEvent)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingSm,
                vertical: AppDimensions.paddingXs,
              ),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.new_releases,
                    size: 16,
                    color: AppColors.success,
                  ),
                  SizedBox(width: AppDimensions.spacingXs),
                  Text(
                    'Evento Novo',
                    style: TextStyle(
                      fontSize: AppDimensions.fontSizeSm,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTemporalItem({
    required IconData icon,
    required String label,
    required String value,
    String? subtitle,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: AppDimensions.fontSizeSm,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: AppDimensions.fontSizeMd,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontSizeXs,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

```

### lib\presentation\widgets\event\skill_chip.dart

```dart
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

```

### lib\presentation\widgets\task\microtask_card.dart

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/microtask_model.dart';
import '../../../data/models/user_model.dart';

/// Widget card para exibir informações de uma microtask com múltiplos voluntários
class MicrotaskCard extends StatelessWidget {
  final MicrotaskModel microtask;
  final List<UserModel> assignedVolunteers;
  final VoidCallback? onTap;
  final VoidCallback? onAssignVolunteer;
  final Function(String userId)? onRemoveVolunteer;
  final Function(String userId, String status)? onUpdateStatus;
  final bool showActions;
  final bool isManager;

  const MicrotaskCard({
    super.key,
    required this.microtask,
    this.assignedVolunteers = const [],
    this.onTap,
    this.onAssignVolunteer,
    this.onRemoveVolunteer,
    this.onUpdateStatus,
    this.showActions = true,
    this.isManager = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingSm,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // Ícone de status
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),

                  // Título
                  Expanded(
                    child: Text(
                      microtask.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  // Badge de prioridade
                  _buildPriorityBadge(),
                ],
              ),

              const SizedBox(height: AppDimensions.spacingSm),

              // Descrição
              if (microtask.description.isNotEmpty)
                Text(
                  microtask.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                  maxLines: 2,
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
                    label: microtask.hasSchedule
                        ? microtask.periodFormatted
                        : 'Horário não definido',
                    color: AppColors.secondary,
                  ),
                  _buildInfoChip(
                    icon: Icons.people,
                    label:
                        '${assignedVolunteers.length}/${microtask.maxVolunteers}',
                    color: _getVolunteerCountColor(),
                  ),
                  _buildInfoChip(
                    icon: Icons.info_outline,
                    label: _getStatusText(),
                    color: _getStatusColor(),
                  ),
                ],
              ),

              // Habilidades necessárias
              if (microtask.requiredSkills.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.spacingMd),
                _buildSkillsSection(),
              ],

              // Recursos necessários
              if (microtask.requiredResources.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.spacingSm),
                _buildResourcesSection(),
              ],

              // Lista de voluntários atribuídos
              if (assignedVolunteers.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.spacingMd),
                _buildVolunteersSection(),
              ],

              // Ações (se habilitadas)
              if (showActions) ...[
                const SizedBox(height: AppDimensions.spacingMd),
                _buildActionsSection(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge() {
    Color color;
    String text;

    final priorityValue = microtask.priority is int
        ? microtask.priority as int
        : 2;

    switch (priorityValue) {
      case 3: // high
        color = AppColors.error;
        text = 'Alta';
        break;
      case 2: // medium
        color = AppColors.warning;
        text = 'Média';
        break;
      case 1: // low
        color = AppColors.success;
        text = 'Baixa';
        break;
      default:
        color = AppColors.warning;
        text = 'Média';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
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
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Habilidades:',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: microtask.requiredSkills.map((skill) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Text(
                skill,
                style: const TextStyle(fontSize: 10, color: AppColors.primary),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildResourcesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recursos:',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: microtask.requiredResources.map((resource) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
              ),
              child: Text(
                resource,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.secondary,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildVolunteersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Voluntários:',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        ...assignedVolunteers.map(
          (volunteer) => _buildVolunteerItem(volunteer),
        ),
      ],
    );
  }

  Widget _buildVolunteerItem(UserModel volunteer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              volunteer.name.isNotEmpty ? volunteer.name[0].toUpperCase() : '?',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              volunteer.name,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (isManager && onRemoveVolunteer != null)
            IconButton(
              onPressed: () => onRemoveVolunteer!(volunteer.id),
              icon: const Icon(Icons.remove_circle_outline),
              iconSize: 16,
              color: AppColors.error,
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              padding: EdgeInsets.zero,
            ),
        ],
      ),
    );
  }

  Widget _buildActionsSection() {
    return Row(
      children: [
        if (isManager &&
            onAssignVolunteer != null &&
            assignedVolunteers.length < microtask.maxVolunteers)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onAssignVolunteer,
              icon: const Icon(Icons.person_add, size: 16),
              label: const Text('Atribuir'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (microtask.status) {
      case MicrotaskStatus.pending:
        return AppColors.warning;
      case MicrotaskStatus.assigned:
        return AppColors.primary;
      case MicrotaskStatus.inProgress:
        return AppColors.secondary;
      case MicrotaskStatus.completed:
        return AppColors.success;
      case MicrotaskStatus.cancelled:
        return AppColors.error;
    }
  }

  String _getStatusText() {
    switch (microtask.status) {
      case MicrotaskStatus.pending:
        return 'Pendente';
      case MicrotaskStatus.assigned:
        return 'Atribuída';
      case MicrotaskStatus.inProgress:
        return 'Em Progresso';
      case MicrotaskStatus.completed:
        return 'Concluída';
      case MicrotaskStatus.cancelled:
        return 'Cancelada';
    }
  }

  Color _getVolunteerCountColor() {
    if (assignedVolunteers.length == microtask.maxVolunteers) {
      return AppColors.success;
    } else if (assignedVolunteers.isEmpty) {
      return AppColors.warning;
    } else {
      return AppColors.primary;
    }
  }
}

```

### lib\presentation\widgets\task\task_card.dart

```dart
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

```

### lib\presentation\widgets\task\task_progress_widget.dart

```dart
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

        if (showDetails) const SizedBox(height: 4),

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
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
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
          microtask!.hasSchedule
              ? 'Duração: ${microtask!.estimatedHours.toStringAsFixed(1)}h'
              : 'Horário não definido',
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
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

        ...items.map(
          (item) => Padding(
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
          ),
        ),
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

  const ProgressItem({required this.label, required this.progress, this.color});
}

```

### lib\presentation\widgets\volunteer\volunteer_card.dart

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/volunteer_profile_model.dart';

/// Widget card para exibir informações de um voluntário (versão compacta)
class VolunteerCard extends StatelessWidget {
  final UserModel user;
  final VolunteerProfileModel? profile;
  final VoidCallback? onTap;
  final VoidCallback?
  onShowActions; // Callback unificado para mostrar o menu de ações
  final bool showActions;
  final bool isManager;
  final int assignedMicrotasksCount;
  final bool
  isCompatible; // Indica se o voluntário é compatível com filtros ativos
  final bool
  showDetailedAvailability; // Mostra horário detalhado de disponibilidade

  const VolunteerCard({
    super.key,
    required this.user,
    this.profile,
    this.onTap,
    this.onShowActions, // Ação unificada
    this.showActions = true,
    this.isManager = false,
    this.assignedMicrotasksCount = 0,
    this.isCompatible = false,
    this.showDetailedAvailability = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSm, // Menor margem horizontal
        vertical: AppDimensions.paddingSm / 2, // Menor margem vertical
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingSm,
            vertical: AppDimensions.paddingSm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header principal com ListTile
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  backgroundImage: user.photoUrl != null
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null
                      ? Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        )
                      : null,
                ),
                title: Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildAvailabilityIndicator(),
                  ],
                ),
                // Indicadores visuais e ações
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Indicador de compatibilidade (estrela)
                    if (isCompatible)
                      Container(
                        margin: const EdgeInsets.only(right: 4),
                        child: Icon(
                          Icons.star,
                          size: 16,
                          color: AppColors.warning,
                        ),
                      ),
                    // Contador de microtasks atribuídas
                    if (assignedMicrotasksCount > 0) _buildMicrotaskBadge(),
                    // Botão de ações
                    if (showActions && isManager)
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: onShowActions,
                        tooltip: 'Mais opções',
                      ),
                  ],
                ),
              ),

              // Informações do perfil (se disponível)
              if (profile != null &&
                  (profile!.skills.isNotEmpty ||
                      profile!.resources.isNotEmpty ||
                      profile!.availableDays.isNotEmpty)) ...[
                const Divider(height: AppDimensions.spacingMd),
                _buildProfileInfo(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Indicador de disponibilidade (exibido no subtítulo)
  Widget _buildAvailabilityIndicator() {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: _getAvailabilityColor(),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            _getAvailabilityText(),
            style: TextStyle(
              fontSize: 11,
              color: _getAvailabilityColor(),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Badge de contagem de microtasks
  Widget _buildMicrotaskBadge() {
    final count = profile?.assignedMicrotasksCount ?? assignedMicrotasksCount;
    final color = _getMicrotaskBadgeColor(count);

    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.assignment, size: 12, color: color),
          const SizedBox(width: 2),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Cor do badge baseada na carga de trabalho
  Color _getMicrotaskBadgeColor(int count) {
    if (count == 0) return AppColors.textSecondary;
    if (count < 3) return AppColors.success;
    if (count < 5) return AppColors.warning;
    return AppColors.error;
  }

  // Seção de informações do perfil (Habilidades, Recursos, etc.)
  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (profile!.availableDays.isNotEmpty) ...[
            _buildInfoRow(
              Icons.event_available_outlined,
              _buildAvailabilityChips(),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
          ],
          if (profile!.skills.isNotEmpty) ...[
            _buildInfoRow(
              Icons.construction_outlined,
              _buildChips(profile!.skills, AppColors.primary),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
          ],
          if (profile!.resources.isNotEmpty) ...[
            _buildInfoRow(
              Icons.build_circle_outlined,
              _buildChips(profile!.resources, AppColors.secondary),
            ),
          ],
        ],
      ),
    );
  }

  // Linha de informação genérica (Ícone + Conteúdo)
  Widget _buildInfoRow(IconData icon, Widget content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: AppDimensions.spacingSm),
        Expanded(child: content),
      ],
    );
  }

  // Chips de dias disponíveis
  Widget _buildAvailabilityChips() {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: profile!.availableDays.map((day) {
        return _buildChip(_getDayAbbreviation(day), AppColors.success);
      }).toList(),
    );
  }

  // Chips genéricos para Habilidades e Recursos
  Widget _buildChips(List<String> items, Color color) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: items.map((item) => _buildChip(item, color)).toList(),
    );
  }

  // Widget de chip customizado
  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Funções de lógica
  Color _getAvailabilityColor() {
    if (profile == null) return AppColors.warning;

    // Se disponibilidade integral está ativa, sempre verde
    if (profile!.isFullTimeAvailable) return AppColors.success;

    final now = DateTime.now();
    final currentDay = _getCurrentDayString(now);
    return profile!.availableDays.contains(currentDay)
        ? AppColors.success
        : AppColors.error;
  }

  String _getAvailabilityText() {
    if (profile == null) return 'Sem perfil';

    // Se disponibilidade integral está ativa
    if (profile!.isFullTimeAvailable) {
      return showDetailedAvailability
          ? 'Disponível integral (qualquer horário)'
          : 'Disponível integral';
    }

    final now = DateTime.now();
    final currentDay = _getCurrentDayString(now);
    final isAvailableToday = profile!.availableDays.contains(currentDay);

    if (showDetailedAvailability && profile!.availableHours.isValid()) {
      final hours =
          '${profile!.availableHours.start}-${profile!.availableHours.end}';
      return isAvailableToday ? 'Hoje: $hours' : 'Indisponível hoje ($hours)';
    }

    return isAvailableToday ? 'Disponível hoje' : 'Indisponível hoje';
  }

  String _getCurrentDayString(DateTime date) {
    final weekdays = [
      'Segunda',
      'Terça',
      'Quarta',
      'Quinta',
      'Sexta',
      'Sábado',
      'Domingo',
    ];
    return weekdays[date.weekday - 1];
  }

  String _getDayAbbreviation(String day) {
    const abbreviations = {
      'Segunda': 'Seg',
      'Terça': 'Ter',
      'Quarta': 'Qua',
      'Quinta': 'Qui',
      'Sexta': 'Sex',
      'Sábado': 'Sáb',
      'Domingo': 'Dom',
    };
    return abbreviations[day] ?? day.substring(0, 3);
  }
}

```

### lib\presentation\widgets\volunteer\volunteer_list_widget.dart

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/volunteer_profile_model.dart';
import 'volunteer_card.dart';

/// Widget para exibir lista de voluntários
class VolunteerListWidget extends StatelessWidget {
  final List<UserModel> volunteers;
  final List<VolunteerProfileModel> profiles;
  final Function(UserModel)? onVolunteerTap;
  final Function(UserModel)? onAssignMicrotask;
  final Function(UserModel)? onRemoveVolunteer;
  final Function(UserModel)? onPromoteToManager;
  final bool showActions;
  final bool isManager;
  final String? emptyMessage;
  final Widget? emptyWidget;
  final bool isLoading;

  const VolunteerListWidget({
    super.key,
    required this.volunteers,
    required this.profiles,
    this.onVolunteerTap,
    this.onAssignMicrotask,
    this.onRemoveVolunteer,
    this.onPromoteToManager,
    this.showActions = true,
    this.isManager = false,
    this.emptyMessage,
    this.emptyWidget,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (volunteers.isEmpty) {
      return emptyWidget ?? _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingSm),
      itemCount: volunteers.length,
      itemBuilder: (context, index) {
        final volunteer = volunteers[index];
        final profile = _getVolunteerProfile(volunteer.id);

        return VolunteerCard(
          user: volunteer,
          profile: profile,
          isManager: true, // Supondo que esta tela seja para gerentes
          showActions: true,
          assignedMicrotasksCount: _getAssignedMicrotasksCount(volunteer.id),
          // Ação unificada que chama o novo diálogo de opções
          onShowActions: () => {},
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Text(
              emptyMessage ?? 'Nenhum voluntário encontrado',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  VolunteerProfileModel? _getVolunteerProfile(String userId) {
    try {
      return profiles.firstWhere((p) => p.userId == userId);
    } catch (e) {
      return null;
    }
  }

  int _getAssignedMicrotasksCount(String userId) {
    final profile = _getVolunteerProfile(userId);
    return profile?.assignedMicrotasksCount ?? 0;
  }
}

/// Widget compacto para lista de voluntários em microtasks
class CompactVolunteerList extends StatelessWidget {
  final List<UserModel> volunteers;
  final int maxVolunteers;
  final Function(UserModel)? onVolunteerTap;
  final VoidCallback? onAddVolunteer;
  final Function(UserModel)? onRemoveVolunteer;
  final bool showAddButton;
  final bool showRemoveButton;

  const CompactVolunteerList({
    super.key,
    required this.volunteers,
    required this.maxVolunteers,
    this.onVolunteerTap,
    this.onAddVolunteer,
    this.onRemoveVolunteer,
    this.showAddButton = true,
    this.showRemoveButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header com contador
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Voluntários (${volunteers.length}/$maxVolunteers)',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (showAddButton && volunteers.length < maxVolunteers)
              IconButton(
                onPressed: onAddVolunteer,
                icon: const Icon(Icons.add),
                color: AppColors.primary,
                iconSize: 20,
              ),
          ],
        ),

        const SizedBox(height: AppDimensions.spacingSm),

        // Lista de voluntários
        if (volunteers.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.person_add_outlined,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                SizedBox(width: AppDimensions.spacingSm),
                Text(
                  'Nenhum voluntário atribuído',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          )
        else
          ...volunteers.map((volunteer) => _buildVolunteerItem(volunteer)),
      ],
    );
  }

  Widget _buildVolunteerItem(UserModel volunteer) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      padding: const EdgeInsets.all(AppDimensions.paddingSm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: volunteer.photoUrl != null
                ? NetworkImage(volunteer.photoUrl!)
                : null,
            child: volunteer.photoUrl == null
                ? Text(
                    volunteer.name.isNotEmpty
                        ? volunteer.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),

          const SizedBox(width: AppDimensions.spacingSm),

          // Informações do voluntário
          Expanded(
            child: GestureDetector(
              onTap: onVolunteerTap != null
                  ? () => onVolunteerTap!(volunteer)
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    volunteer.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    volunteer.email,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botão de remover
          if (showRemoveButton)
            IconButton(
              onPressed: onRemoveVolunteer != null
                  ? () => onRemoveVolunteer!(volunteer)
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
              color: AppColors.error,
              iconSize: 20,
            ),
        ],
      ),
    );
  }
}

/// Widget para exibir avatares dos voluntários em linha
class VolunteerAvatarList extends StatelessWidget {
  final List<UserModel> volunteers;
  final int maxVisible;
  final double avatarSize;
  final Function(UserModel)? onVolunteerTap;
  final VoidCallback? onShowAll;

  const VolunteerAvatarList({
    super.key,
    required this.volunteers,
    this.maxVisible = 3,
    this.avatarSize = 32,
    this.onVolunteerTap,
    this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    if (volunteers.isEmpty) {
      return const SizedBox.shrink();
    }

    final visibleVolunteers = volunteers.take(maxVisible).toList();
    final remainingCount = volunteers.length - maxVisible;

    return Row(
      children: [
        ...visibleVolunteers.asMap().entries.map((entry) {
          final index = entry.key;
          final volunteer = entry.value;

          return Container(
            margin: EdgeInsets.only(left: index > 0 ? -8 : 0),
            child: GestureDetector(
              onTap: onVolunteerTap != null
                  ? () => onVolunteerTap!(volunteer)
                  : null,
              child: CircleAvatar(
                radius: avatarSize / 2,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                backgroundImage: volunteer.photoUrl != null
                    ? NetworkImage(volunteer.photoUrl!)
                    : null,
                child: volunteer.photoUrl == null
                    ? Text(
                        volunteer.name.isNotEmpty
                            ? volunteer.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: avatarSize * 0.4,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      )
                    : null,
              ),
            ),
          );
        }),

        // Indicador de mais voluntários
        if (remainingCount > 0)
          Container(
            margin: const EdgeInsets.only(left: -8),
            child: GestureDetector(
              onTap: onShowAll,
              child: CircleAvatar(
                radius: avatarSize / 2,
                backgroundColor: AppColors.textSecondary.withOpacity(0.2),
                child: Text(
                  '+$remainingCount',
                  style: TextStyle(
                    fontSize: avatarSize * 0.3,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

```

### lib\utils\migration_utils.dart

```dart
import 'package:flutter/material.dart';
import '../data/repositories/event_repository.dart';
import '../presentation/controllers/event_controller.dart';

/// Utilitários para migração de dados do banco
class MigrationUtils {
  static final EventRepository _eventRepository = EventRepository();

  /// Executa a migração de perfis de voluntários para incluir o campo assignedMicrotasksCount
  /// Este método deve ser executado uma única vez após a implementação do sistema de contagem
  static Future<bool> runVolunteerProfilesMigration() async {
    try {
      await _eventRepository.migrateVolunteerProfilesTaskCounts();
      return true;
    } catch (e) {
      print('Erro na migração: $e');
      return false;
    }
  }

  /// Recalcula os contadores para um evento específico
  static Future<bool> recalculateEventCounts(String eventId) async {
    try {
      await _eventRepository.recalculateEventVolunteerCounts(eventId);
      return true;
    } catch (e) {
      print('Erro ao recalcular contadores: $e');
      return false;
    }
  }

  /// Recalcula o contador para um voluntário específico
  static Future<bool> recalculateVolunteerCount(String eventId, String userId) async {
    try {
      await _eventRepository.recalculateVolunteerMicrotaskCount(eventId, userId);
      return true;
    } catch (e) {
      print('Erro ao recalcular contador do voluntário: $e');
      return false;
    }
  }

  /// Mostra um diálogo para executar a migração
  static void showMigrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Migração de Dados'),
        content: const Text(
          'Esta operação irá migrar todos os perfis de voluntários existentes '
          'para incluir o campo de contagem de microtasks. Esta operação deve '
          'ser executada apenas uma vez.\n\n'
          'Deseja continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              _showMigrationProgress(context);
            },
            child: const Text('Executar Migração'),
          ),
        ],
      ),
    );
  }

  /// Mostra o progresso da migração
  static void _showMigrationProgress(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Executando Migração'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Migrando perfis de voluntários...'),
          ],
        ),
      ),
    );

    runVolunteerProfilesMigration().then((success) {
      Navigator.of(context).pop(); // Fecha o diálogo de progresso
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(success ? 'Sucesso' : 'Erro'),
          content: Text(
            success 
              ? 'Migração executada com sucesso!'
              : 'Erro ao executar a migração. Verifique os logs.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  /// Mostra um diálogo para recalcular contadores de um evento
  static void showRecalculateEventDialog(BuildContext context, String eventId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recalcular Contadores'),
        content: const Text(
          'Esta operação irá recalcular os contadores de microtasks '
          'para todos os voluntários deste evento baseado nas '
          'atribuições reais no banco de dados.\n\n'
          'Deseja continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              final success = await recalculateEventCounts(eventId);
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success 
                        ? 'Contadores recalculados com sucesso!'
                        : 'Erro ao recalcular contadores.',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Recalcular'),
          ),
        ],
      ),
    );
  }
}

```
