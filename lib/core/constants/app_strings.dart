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
  static const String estimatedHours = 'Horas estimadas';
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
  static const String errorPasswordTooShort = 'Senha deve ter pelo menos 6 caracteres';
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
