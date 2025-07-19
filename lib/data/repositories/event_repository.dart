import '../models/event_model.dart';
import '../models/volunteer_profile_model.dart';
import '../services/event_service.dart';
import '../repositories/user_repository.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Repositório responsável por gerenciar dados de campanhas
/// Atua como uma camada de abstração entre os controllers e os services
class EventRepository {
  final EventService _eventService;
  final UserRepository _userRepository;

  EventRepository({EventService? eventService, UserRepository? userRepository})
    : _eventService = eventService ?? EventService(),
      _userRepository = userRepository ?? UserRepository();

  /// Cria um nova campanha
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
        tag: 'TEMP01', // Temporary tag for validation (6 characters)
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

      // REQ-01: Busca dados do usuário criador para criar o perfil de voluntário
      final userData = await _userRepository.getUserById(createdBy);
      if (userData == null) {
        throw NotFoundException('Usuário criador não encontrado');
      }

      // Repository delegates to service for creation with ID/tag generation
      return await _eventService.createEvent(
        name: name.trim(),
        description: description.trim(),
        location: location.trim(),
        createdBy: createdBy,
        requiredSkills: requiredSkills,
        requiredResources: requiredResources,
        creatorName: userData.name,
        creatorEmail: userData.email,
        creatorPhotoUrl: userData.photoUrl,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao criar campanha: ${e.toString()}');
    }
  }

  /// Busca uma campanha por ID
  Future<EventModel?> getEventById(String eventId) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID da campanha é obrigatório');
      }

      return await _eventService.getEventById(eventId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar campanha: ${e.toString()}');
    }
  }

  /// Busca uma campanha por tag/código
  Future<EventModel?> getEventByTag(String tag) async {
    try {
      if (tag.isEmpty) {
        throw ValidationException('Tag da campanha é obrigatória');
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
        'Erro ao buscar campanha por tag: ${e.toString()}',
      );
    }
  }

  /// Busca todos as campanhas do usuário
  Future<List<EventModel>> getUserEvents(String userId) async {
    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }

      return await _eventService.getUserEvents(userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar campanhas do usuário: ${e.toString()}',
      );
    }
  }

  /// Atualiza uma campanha
  Future<EventModel> updateEvent(EventModel event) async {
    try {
      return await _eventService.updateEvent(event);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao atualizar campanha: ${e.toString()}');
    }
  }

  /// Adiciona um voluntário aa campanha
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
        throw ValidationException('IDs da campanha e usuário são obrigatórios');
      }

      // Adiciona o voluntário aa campanha
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
        'Erro ao participar da campanha: ${e.toString()}',
      );
    }
  }

  /// Remove um voluntário da campanha
  Future<EventModel> leaveEvent(String eventId, String userId) async {
    try {
      if (eventId.isEmpty || userId.isEmpty) {
        throw ValidationException('IDs da campanha e usuário são obrigatórios');
      }

      // Remove o voluntário da campanha
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
      throw RepositoryException('Erro ao sair da campanha: ${e.toString()}');
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
        throw ValidationException('ID da campanha é obrigatório');
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
        throw NotFoundException('campanha não encontrado');
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

  /// Busca o perfil de um voluntário em uma campanha
  Future<VolunteerProfileModel?> getVolunteerProfile(
    String userId,
    String eventId,
  ) async {
    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }
      if (eventId.isEmpty) {
        throw ValidationException('ID da campanha é obrigatório');
      }

      return await _eventService.getVolunteerProfile(userId, eventId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar perfil de voluntário: ${e.toString()}',
      );
    }
  }

  /// Busca todos os perfis de voluntários de uma campanha
  Future<List<VolunteerProfileModel>> getEventVolunteers(String eventId) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID da campanha é obrigatório');
      }

      return await _eventService.getEventVolunteerProfiles(eventId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar voluntários da campanha: ${e.toString()}',
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

  /// Deleta uma campanha
  Future<void> deleteEvent(String eventId, String userId) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID da campanha é obrigatório');
      }
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }

      await _eventService.deleteEvent(eventId, userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao deletar campanha: ${e.toString()}');
    }
  }

  /// Verifica se um usuário pode gerenciar uma campanha
  Future<bool> canManageEvent(String eventId, String userId) async {
    try {
      final event = await getEventById(eventId);
      if (event == null) return false;

      return event.isManager(userId);
    } catch (e) {
      return false;
    }
  }

  /// Verifica se um usuário é participante de uma campanha
  Future<bool> isParticipant(String eventId, String userId) async {
    try {
      final event = await getEventById(eventId);
      if (event == null) return false;

      return event.isParticipant(userId);
    } catch (e) {
      return false;
    }
  }

  /// Stream para escutar mudanças em uma campanha
  Stream<EventModel?> watchEvent(String eventId) {
    return _eventService.watchEvent(eventId);
  }

  /// Stream para escutar mudanças nas campanhas do usuário
  Stream<List<EventModel>> watchUserEvents(String userId) {
    return _eventService.watchUserEvents(userId);
  }

  /// Busca campanhas compatíveis com as habilidades de um voluntário
  Future<List<EventModel>> getCompatibleEvents(String userId) async {
    try {
      // Por enquanto, retorna todos as campanhas do usuário
      // Pode ser expandido para incluir lógica de compatibilidade
      return await getUserEvents(userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar campanhas compatíveis: ${e.toString()}',
      );
    }
  }

  /// Valida se uma tag de campanha é válida
  bool isValidTag(String tag) {
    if (tag.isEmpty) return false;
    if (tag.length != 6) return false;

    // Verifica se contém apenas letras e números
    final regex = RegExp(r'^[A-Z0-9]+$');
    return regex.hasMatch(tag.toUpperCase());
  }

  /// Normaliza uma tag de campanha
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

  /// Recalcula os contadores para todos os voluntários de uma campanha
  Future<void> recalculateEventVolunteerCounts(String eventId) async {
    try {
      await _eventService.recalculateEventVolunteerCounts(eventId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao recalcular contadores da campanha: ${e.toString()}',
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
