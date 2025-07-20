import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/event_model.dart';
import '../models/volunteer_profile_model.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Serviço responsável por operações relacionadas a campanhas no Firebase
class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // Referências das coleções
  CollectionReference get _eventsCollection => _firestore.collection('events');
  CollectionReference get _volunteerProfilesCollection =>
      _firestore.collection('volunteer_profiles');

  /// Cria um nova campanha
  Future<EventModel> createEvent({
    required String name,
    required String description,
    required String location,
    required String createdBy,
    required List<String> requiredSkills,
    required List<String> requiredResources,
    required String creatorName,
    required String creatorEmail,
    String? creatorPhotoUrl,
  }) async {
    try {
      // Gera um ID único para a campanha
      final eventId = _uuid.v4();

      // Gera uma tag única
      String tag;
      do {
        tag = _generateUniqueTag();
      } while (await _isTagTaken(tag));

      // Gera timestamps
      final now = DateTime.now();

      // Cria a campanha com dados gerados pelo service
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

      // REQ-01: Cria automaticamente um perfil de voluntário para o criador da campanha
      // com valores padrão que podem ser preenchidos posteriormente
      await createVolunteerProfile(
        userId: createdBy,
        eventId: eventId,
        availableDays:
            [], // Valores padrão vazios - usuário deve preencher depois
        availableHours: const TimeRange(
          start: '09:00',
          end: '17:00',
        ), // Horário padrão
        isFullTimeAvailable: false,
        skills: [], // Valores padrão vazios - usuário deve preencher depois
        resources: [], // Valores padrão vazios - usuário deve preencher depois
        userName: creatorName,
        userEmail: creatorEmail,
        userPhotoUrl: creatorPhotoUrl,
      );

      return event;
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Erro ao criar campanha: ${e.toString()}');
    }
  }

  /// Busca uma campanha por ID
  Future<EventModel?> getEventById(String eventId) async {
    try {
      final doc = await _eventsCollection.doc(eventId).get();

      if (!doc.exists) return null;

      return EventModel.fromFirestore(doc);
    } catch (e) {
      throw DatabaseException('Erro ao buscar campanha: ${e.toString()}');
    }
  }

  /// Busca uma campanha por tag
  Future<EventModel?> getEventByTag(String tag) async {
    try {
      final query = await _eventsCollection
          .where('tag', isEqualTo: tag.toUpperCase())
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;

      return EventModel.fromFirestore(query.docs.first);
    } catch (e) {
      throw DatabaseException(
        'Erro ao buscar campanha por tag: ${e.toString()}',
      );
    }
  }

  /// Busca campanhas onde o usuário é participante (gerenciador ou voluntário)
  Future<List<EventModel>> getUserEvents(String userId) async {
    try {
      // Busca campanhas onde o usuário é gerenciador
      final managerQuery = await _eventsCollection
          .where('managers', arrayContains: userId)
          .get();

      // Busca campanhas onde o usuário é voluntário
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
        'Erro ao buscar campanhas do usuário: ${e.toString()}',
      );
    }
  }

  /// Atualiza uma campanha
  Future<EventModel> updateEvent(EventModel event) async {
    try {
      // Note: Validation should be done by repository/controller before calling service

      final updatedEvent = event.withUpdatedTimestamp();

      await _eventsCollection.doc(event.id).update(updatedEvent.toFirestore());

      return updatedEvent;
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Erro ao atualizar campanha: ${e.toString()}');
    }
  }

  /// Adiciona um voluntário aa campanha
  Future<EventModel> addVolunteerToEvent(String eventId, String userId) async {
    try {
      final event = await getEventById(eventId);
      if (event == null) {
        throw NotFoundException('campanha não encontrado');
      }

      // Verifica se o usuário já é participante
      if (event.isParticipant(userId)) {
        throw ValidationException('Usuário já é participante da campanha');
      }

      final updatedEvent = event.addVolunteer(userId);
      return await updateEvent(updatedEvent);
    } catch (e) {
      if (e is AppException) rethrow;
      throw DatabaseException('Erro ao adicionar voluntário: ${e.toString()}');
    }
  }

  /// Remove um voluntário da campanha
  Future<EventModel> removeVolunteerFromEvent(
    String eventId,
    String userId,
  ) async {
    try {
      final event = await getEventById(eventId);
      if (event == null) {
        throw NotFoundException('campanha não encontrado');
      }

      if (!event.isVolunteer(userId)) {
        throw ValidationException('Usuário não é voluntário da campanha');
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
        throw NotFoundException('campanha não encontrado');
      }

      if (!event.isVolunteer(userId)) {
        throw ValidationException('Usuário não é voluntário da campanha');
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

  /// Busca o perfil de um voluntário em uma campanha
  Future<VolunteerProfileModel?> getVolunteerProfile(
    String userId,
    String eventId,
  ) async {
    try {
      final query = await _volunteerProfilesCollection
          .where('userId', isEqualTo: userId)
          .where('eventId', isEqualTo: eventId)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;

      return VolunteerProfileModel.fromFirestore(query.docs.first);
    } catch (e) {
      throw DatabaseException(
        'Erro ao buscar perfil de voluntário: ${e.toString()}',
      );
    }
  }

  /// Busca todos os perfis de voluntários de uma campanha
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
      if (e is ValidationException) rethrow;
      throw DatabaseException(
        'Erro ao atualizar perfil de voluntário: ${e.toString()}',
      );
    }
  }

  /// Deleta uma campanha (apenas o criador pode fazer isso)
  Future<void> deleteEvent(String eventId, String userId) async {
    try {
      final event = await getEventById(eventId);
      if (event == null) {
        throw NotFoundException('campanha não encontrado');
      }

      if (!event.isCreator(userId)) {
        throw UnauthorizedException('Apenas o criador pode deletar a campanha');
      }

      // Deleta todos os perfis de voluntários relacionados
      final profiles = await getEventVolunteerProfiles(eventId);
      for (final profile in profiles) {
        await _volunteerProfilesCollection.doc(profile.id).delete();
      }

      // Deleta a campanha
      await _eventsCollection.doc(eventId).delete();
    } catch (e) {
      if (e is AppException) rethrow;
      throw DatabaseException('Erro ao deletar campanha: ${e.toString()}');
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

  /// Gera uma tag única para a campanha
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

  /// Stream para escutar mudanças em uma campanha
  Stream<EventModel?> watchEvent(String eventId) {
    return _eventsCollection.doc(eventId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return EventModel.fromFirestore(doc);
    });
  }

  /// Stream para escutar mudanças nas campanhas do usuário
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

  /// Recalcula os contadores para todos os voluntários de uma campanha
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
        'Erro ao recalcular contadores da campanha: ${e.toString()}',
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
