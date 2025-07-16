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

      // Se o perfil não tem dados do usuário, busca e adiciona
      VolunteerProfileModel profileWithUserData = profile;
      if (!profile.hasValidUserData) {
        final userData = await _getUserData(profile.userId);
        if (userData != null) {
          profileWithUserData = profile.updateUserData(
            userName: userData['name'] as String? ?? '',
            userEmail: userData['email'] as String? ?? '',
            userPhotoUrl: userData['photoUrl'] as String?,
          );
        }
      }

      final profileWithId = profileWithUserData.copyWith(id: profileId);

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
