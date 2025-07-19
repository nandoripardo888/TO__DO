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

  /// Busca todas as microtasks de uma campanha
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
        'Erro ao buscar microtasks da campanha: ${e.toString()}',
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

  /// Stream para escutar mudanças nas microtasks de uma campanha
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
