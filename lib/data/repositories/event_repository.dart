import '../models/event_model.dart';
import '../models/volunteer_profile_model.dart';
import '../services/event_service.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Repositório responsável por gerenciar dados de eventos
/// Atua como uma camada de abstração entre os controllers e os services
class EventRepository {
  final EventService _eventService;

  EventRepository({EventService? eventService})
    : _eventService = eventService ?? EventService();

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
      final event = EventModel.create(
        name: name.trim(),
        description: description.trim(),
        location: location.trim(),
        createdBy: createdBy,
        requiredSkills: requiredSkills,
        requiredResources: requiredResources,
      );

      return await _eventService.createEvent(event);
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
      // Valida os parâmetros
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }
      if (!isFullTimeAvailable && availableDays.isEmpty) {
        throw ValidationException(
          'Pelo menos um dia de disponibilidade é obrigatório',
        );
      }
      if (!availableHours.isValid()) {
        throw ValidationException('Horário de disponibilidade inválido');
      }

      // Adiciona o voluntário ao evento
      final updatedEvent = await _eventService.addVolunteerToEvent(
        eventId,
        userId,
      );

      // Cria o perfil do voluntário
      final profile = VolunteerProfileModel.create(
        userId: userId,
        eventId: eventId,
        availableDays: availableDays,
        availableHours: availableHours,
        isFullTimeAvailable: isFullTimeAvailable,
        skills: skills,
        resources: resources,
      );

      await _eventService.createVolunteerProfile(profile);

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
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
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
}
