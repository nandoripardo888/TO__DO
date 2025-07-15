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
  Future<EventModel> createEvent(EventModel event) async {
    try {
      // Gera um ID único para o evento
      final eventId = _uuid.v4();

      // Gera uma tag única
      String tag;
      do {
        tag = _generateUniqueTag();
      } while (await _isTagTaken(tag));

      // Cria o evento com ID e tag únicos
      final eventWithId = event.copyWith(id: eventId, tag: tag);

      // Valida os dados antes de salvar
      final validationErrors = eventWithId.validate();
      if (validationErrors.isNotEmpty) {
        throw ValidationException(
          'Dados inválidos: ${validationErrors.join(', ')}',
        );
      }

      // Salva no Firestore
      await _eventsCollection.doc(eventId).set(eventWithId.toFirestore());

      return eventWithId;
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
      // Valida os dados antes de salvar
      final validationErrors = event.validate();
      if (validationErrors.isNotEmpty) {
        throw ValidationException(
          'Dados inválidos: ${validationErrors.join(', ')}',
        );
      }

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
  Future<VolunteerProfileModel> createVolunteerProfile(
    VolunteerProfileModel profile,
  ) async {
    try {
      // Gera um ID único para o perfil
      final profileId = _uuid.v4();

      final profileWithId = profile.copyWith(id: profileId);

      // Valida os dados antes de salvar
      final validationErrors = profileWithId.validate();
      if (validationErrors.isNotEmpty) {
        throw ValidationException(
          'Dados inválidos: ${validationErrors.join(', ')}',
        );
      }

      // Salva no Firestore
      await _volunteerProfilesCollection
          .doc(profileId)
          .set(profileWithId.toFirestore());

      return profileWithId;
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

      return query.docs
          .map((doc) => VolunteerProfileModel.fromFirestore(doc))
          .toList();
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
        final currentCount = doc.data() as Map<String, dynamic>;
        final assignedCount =
            currentCount['assignedMicrotasksCount'] as int? ?? 0;

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
        final currentCount = doc.data() as Map<String, dynamic>;
        final assignedCount =
            currentCount['assignedMicrotasksCount'] as int? ?? 0;

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
}
