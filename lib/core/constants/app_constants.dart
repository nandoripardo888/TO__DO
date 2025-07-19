/// Classe que define constantes gerais da aplicação
/// Inclui configurações, limites e valores padrão
class AppConstants {
  // Configurações de Autenticação
  static const int passwordMinLength = 6;
  static const int passwordMaxLength = 128;
  static const int nameMinLength = 2;
  static const int nameMaxLength = 50;

  // Configurações de campanhas
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

  // Status de campanhas
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
  static const List<String> allowedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];

  // Timeouts
  static const int networkTimeoutSeconds = 30;
  static const int authTimeoutSeconds = 60;

  // Regex Patterns
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
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
