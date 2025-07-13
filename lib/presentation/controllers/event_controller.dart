import 'package:flutter/foundation.dart';
import '../../data/models/event_model.dart';
import '../../data/models/volunteer_profile_model.dart';
import '../../data/repositories/event_repository.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Controller responsável por gerenciar o estado dos eventos
class EventController extends ChangeNotifier {
  final EventRepository _eventRepository;

  EventController({EventRepository? eventRepository})
      : _eventRepository = eventRepository ?? EventRepository();

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
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  bool get isCreatingEvent => _isCreatingEvent;
  bool get isJoiningEvent => _isJoiningEvent;
  bool get isLoadingUserEvents => _isLoadingUserEvents;
  List<EventModel> get userEvents => List.unmodifiable(_userEvents);
  EventModel? get currentEvent => _currentEvent;
  EventModel? get searchedEvent => _searchedEvent;
  List<VolunteerProfileModel> get eventVolunteers => List.unmodifiable(_eventVolunteers);
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
        throw ValidationException('Código deve ter exatamente 6 caracteres (letras e números)');
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
      if (availableDays.isEmpty) {
        throw ValidationException('Selecione pelo menos um dia de disponibilidade');
      }
      if (!availableHours.isValid()) {
        throw ValidationException('Horário de disponibilidade inválido');
      }

      final updatedEvent = await _eventRepository.joinEvent(
        eventId: eventId,
        userId: userId,
        availableDays: availableDays,
        availableHours: availableHours,
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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

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
      notifyListeners();
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

      final volunteers = await _eventRepository.getEventVolunteers(eventId);
      _eventVolunteers = volunteers;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _eventVolunteers = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Promove um voluntário a gerenciador
  Future<bool> promoteVolunteer(String eventId, String userId, String managerId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedEvent = await _eventRepository.promoteVolunteer(eventId, userId, managerId);

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
    notifyListeners();
  }
}
