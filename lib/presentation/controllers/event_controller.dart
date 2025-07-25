import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../../data/models/event_model.dart';
import '../../data/models/user_model.dart';
import '../../data/models/volunteer_profile_model.dart';
import '../../data/repositories/event_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Controller responsável por gerenciar o estado das campanhas
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

  // Cache para perfis de voluntários por campanha
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

  /// Cria um nova campanha
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
        throw ValidationException('Nome da campanha é obrigatório');
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

      // Adiciona a campanha à lista de campanhas do usuário
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

  /// Busca uma campanha por tag
  Future<EventModel?> searchEventByTag(String tag) async {
    _isLoading = true;
    _errorMessage = null;
    _searchedEvent = null;
    notifyListeners();

    try {
      if (tag.trim().isEmpty) {
        throw ValidationException('Código da campanha é obrigatório');
      }

      if (!_eventRepository.isValidTag(tag)) {
        throw ValidationException(
          'Código deve ter exatamente 6 caracteres (letras e números)',
        );
      }

      final event = await _eventRepository.getEventByTag(tag);

      if (event == null) {
        throw NotFoundException(
          'campanha não encontrado com o código informado',
        );
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

  /// Participa de uma campanha
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
        throw ValidationException('ID da campanha é obrigatório');
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

      // Atualiza a lista de campanhas do usuário
      final index = _userEvents.indexWhere((e) => e.id == eventId);
      if (index >= 0) {
        _userEvents[index] = updatedEvent;
      } else {
        _userEvents.insert(0, updatedEvent);
      }

      // Atualiza a campanha atual se for o mesmo
      if (_currentEvent?.id == eventId) {
        _currentEvent = updatedEvent;
      }

      // Atualiza a campanha pesquisado se for o mesmo
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

  /// Carrega as campanhas do usuário
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

  /// Carrega uma campanha específico
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
        throw ValidationException('ID da campanha é obrigatório');
      }

      final event = await _eventRepository.getEventById(eventId);

      if (event == null) {
        throw NotFoundException('campanha não encontrado');
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

  /// Carrega os voluntários de uma campanha
  Future<void> loadEventVolunteers(String eventId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID da campanha é obrigatório');
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

  /// Busca dados completos de voluntários (usuários + perfis) para uma campanha
  Future<Map<String, dynamic>> getEventVolunteersWithUsers(
    String eventId,
  ) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID da campanha é obrigatório');
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
        throw ValidationException('ID da campanha é obrigatório');
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

  /// Verifica se o cache é válido para uma campanha
  bool _isCacheValid(String eventId) {
    if (!_volunteersCache.containsKey(eventId) ||
        !_cacheTimestamps.containsKey(eventId)) {
      return false;
    }

    final cacheTime = _cacheTimestamps[eventId]!;
    final now = DateTime.now();
    return now.difference(cacheTime) < _cacheExpiration;
  }

  /// Limpa o cache de voluntários para uma campanha específico
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

      // Atualiza a campanha na lista
      final index = _userEvents.indexWhere((e) => e.id == eventId);
      if (index >= 0) {
        _userEvents[index] = updatedEvent;
      }

      // Atualiza a campanha atual se for o mesmo
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

  /// Verifica se um usuário pode gerenciar uma campanha
  Future<bool> canManageEvent(String eventId, String userId) async {
    try {
      return await _eventRepository.canManageEvent(eventId, userId);
    } catch (e) {
      return false;
    }
  }

  /// Verifica se um usuário é participante de uma campanha
  Future<bool> isParticipant(String eventId, String userId) async {
    try {
      return await _eventRepository.isParticipant(eventId, userId);
    } catch (e) {
      return false;
    }
  }

  /// Limpa a campanha pesquisado
  void clearSearchedEvent() {
    _searchedEvent = null;
    notifyListeners();
  }

  /// Define a campanha atual
  void setCurrentEvent(EventModel? event) {
    _currentEvent = event;
    notifyListeners();
  }

  /// REQ-06: Atualiza uma campanha existente
  Future<bool> updateEvent(EventModel event) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Validações básicas
      if (event.name.trim().isEmpty) {
        throw ValidationException('Nome da campanha é obrigatório');
      }
      if (event.location.trim().isEmpty) {
        throw ValidationException('Localização é obrigatória');
      }

      final updatedEvent = await _eventRepository.updateEvent(event);

      // Atualiza a campanha atual se for o mesmo
      if (_currentEvent?.id == event.id) {
        _currentEvent = updatedEvent;
      }

      // Atualiza a lista de campanhas do usuário
      final eventIndex = _userEvents.indexWhere((e) => e.id == event.id);
      if (eventIndex != -1) {
        _userEvents[eventIndex] = updatedEvent;
      }

      // Atualiza a campanha pesquisado se for o mesmo
      if (_searchedEvent?.id == event.id) {
        _searchedEvent = updatedEvent;
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

  /// Atualiza uma campanha na lista
  void updateEventInList(EventModel updatedEvent) {
    final index = _userEvents.indexWhere((e) => e.id == updatedEvent.id);
    if (index >= 0) {
      _userEvents[index] = updatedEvent;
      notifyListeners();
    }
  }

  /// Remove uma campanha da lista
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

  /// Promove um voluntário a gerente da campanha
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

      // Atualiza a campanha atual se for o mesmo
      if (_currentEvent?.id == eventId) {
        _currentEvent = updatedEvent;
      }

      // Atualiza a lista de campanhas do usuário
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

  /// Recalcula os contadores para todos os voluntários de uma campanha
  Future<bool> recalculateEventVolunteerCounts(String eventId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _eventRepository.recalculateEventVolunteerCounts(eventId);

      // Recarrega os perfis de voluntários da campanha
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

  /// Atualiza o perfil de um voluntário
  Future<bool> updateVolunteerProfile(VolunteerProfileModel profile) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Atualiza o perfil no repositório
      final updatedProfile = await _eventRepository.updateVolunteerProfile(
        profile,
      );

      // Atualiza o perfil na lista local se disponível
      final profileIndex = _eventVolunteers.indexWhere(
        (p) => p.id == profile.id,
      );
      if (profileIndex != -1) {
        _eventVolunteers[profileIndex] = updatedProfile;
      }

      // Limpa o cache para forçar recarregamento
      _volunteersCache.remove(profile.eventId);
      _cacheTimestamps.remove(profile.eventId);

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
