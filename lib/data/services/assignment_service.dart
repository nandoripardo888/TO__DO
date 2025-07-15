import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/microtask_model.dart';
import '../models/user_microtask_model.dart';
import '../models/volunteer_profile_model.dart';
import '../services/microtask_service.dart';
import '../services/event_service.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Serviço responsável pelo sistema de atribuição múltipla de voluntários
class AssignmentService {
  final MicrotaskService _microtaskService;
  final EventService _eventService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AssignmentService({
    MicrotaskService? microtaskService,
    EventService? eventService,
  }) : _microtaskService = microtaskService ?? MicrotaskService(),
       _eventService = eventService ?? EventService();

  // Referência da coleção
  CollectionReference get _userMicrotasksCollection =>
      _firestore.collection('user_microtasks');

  /// Atribui um voluntário a uma microtask com validações completas
  Future<MicrotaskModel> assignVolunteerToMicrotask({
    required String microtaskId,
    required String userId,
    required String eventId,
  }) async {
    try {
      // Busca a microtask
      final microtask = await _microtaskService.getMicrotaskById(microtaskId);
      if (microtask == null) {
        throw ValidationException('Microtask não encontrada');
      }

      // Busca o perfil do voluntário no evento
      final volunteerProfile = await _eventService.getVolunteerProfile(
        userId,
        eventId,
      );
      if (volunteerProfile == null) {
        throw ValidationException('Perfil de voluntário não encontrado');
      }

      // Validações de atribuição
      await _validateAssignment(microtask, userId, volunteerProfile);
      print("ABACAXI5: assinando microtask");
      // Atribui o voluntário
      return await _microtaskService.assignVolunteer(microtaskId, userId);
    } catch (e) {
      if (e is ValidationException || e is DatabaseException) rethrow;
      throw DatabaseException('Erro ao atribuir voluntário: ${e.toString()}');
    }
  }

  /// Remove um voluntário de uma microtask
  Future<MicrotaskModel> unassignVolunteerFromMicrotask({
    required String microtaskId,
    required String userId,
  }) async {
    try {
      return await _microtaskService.unassignVolunteer(microtaskId, userId);
    } catch (e) {
      if (e is ValidationException || e is DatabaseException) rethrow;
      throw DatabaseException('Erro ao remover voluntário: ${e.toString()}');
    }
  }

  /// Busca voluntários compatíveis com uma microtask
  Future<List<VolunteerProfileModel>> getCompatibleVolunteers({
    required String eventId,
    required String microtaskId,
  }) async {
    try {
      // Busca a microtask
      final microtask = await _microtaskService.getMicrotaskById(microtaskId);
      if (microtask == null) {
        throw ValidationException('Microtask não encontrada');
      }

      // Busca todos os voluntários do evento
      final allVolunteers = await _eventService.getEventVolunteerProfiles(
        eventId,
      );

      // Filtra voluntários compatíveis
      final compatibleVolunteers = <VolunteerProfileModel>[];

      for (final volunteer in allVolunteers) {
        // Verifica se já está atribuído
        if (microtask.isAssignedTo(volunteer.userId)) {
          continue;
        }

        // Verifica compatibilidade de habilidades
        if (!microtask.isCompatibleWith(volunteer.skills)) {
          continue;
        }

        // TODO: Adicionar verificação de disponibilidade de horários
        // TODO: Adicionar verificação de recursos disponíveis

        compatibleVolunteers.add(volunteer);
      }

      // Ordena por score de compatibilidade
      compatibleVolunteers.sort((a, b) {
        final scoreA = microtask.getCompatibilityScore(a.skills);
        final scoreB = microtask.getCompatibilityScore(b.skills);
        return scoreB.compareTo(scoreA);
      });

      return compatibleVolunteers;
    } catch (e) {
      if (e is ValidationException || e is DatabaseException) rethrow;
      throw DatabaseException(
        'Erro ao buscar voluntários compatíveis: ${e.toString()}',
      );
    }
  }

  /// Busca microtasks disponíveis para um voluntário
  Future<List<MicrotaskModel>> getAvailableMicrotasksForVolunteer({
    required String eventId,
    required String userId,
  }) async {
    try {
      // Busca o perfil do voluntário
      final volunteerProfile = await _eventService.getVolunteerProfile(
        eventId,
        userId,
      );
      if (volunteerProfile == null) {
        throw ValidationException('Perfil de voluntário não encontrado');
      }

      // Busca todas as microtasks do evento
      final allMicrotasks = await _microtaskService.getMicrotasksByEventId(
        eventId,
      );

      // Filtra microtasks disponíveis
      final availableMicrotasks = <MicrotaskModel>[];

      for (final microtask in allMicrotasks) {
        // Verifica se já está atribuído
        if (microtask.isAssignedTo(userId)) {
          continue;
        }

        // Verifica se há vagas disponíveis
        if (!microtask.hasAvailableSlots) {
          continue;
        }

        // Verifica se não está cancelada
        if (microtask.isCancelled) {
          continue;
        }

        // Verifica compatibilidade de habilidades
        if (!microtask.isCompatibleWith(volunteerProfile.skills)) {
          continue;
        }

        availableMicrotasks.add(microtask);
      }

      // Ordena por prioridade e compatibilidade
      availableMicrotasks.sort((a, b) {
        // Primeiro por prioridade
        final priorityOrder = {'high': 3, 'medium': 2, 'low': 1};
        final priorityA = priorityOrder[a.priority] ?? 2;
        final priorityB = priorityOrder[b.priority] ?? 2;

        if (priorityA != priorityB) {
          return priorityB.compareTo(priorityA);
        }

        // Depois por score de compatibilidade
        final scoreA = a.getCompatibilityScore(volunteerProfile.skills);
        final scoreB = b.getCompatibilityScore(volunteerProfile.skills);
        return scoreB.compareTo(scoreA);
      });

      return availableMicrotasks;
    } catch (e) {
      if (e is ValidationException || e is DatabaseException) rethrow;
      throw DatabaseException(
        'Erro ao buscar microtasks disponíveis: ${e.toString()}',
      );
    }
  }

  /// Busca o status individual de um usuário em uma microtask
  Future<UserMicrotaskModel?> getUserMicrotaskStatus({
    required String userId,
    required String microtaskId,
  }) async {
    try {
      final querySnapshot = await _userMicrotasksCollection
          .where('userId', isEqualTo: userId)
          .where('microtaskId', isEqualTo: microtaskId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      return UserMicrotaskModel.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      throw DatabaseException(
        'Erro ao buscar status do usuário na microtask: ${e.toString()}',
      );
    }
  }

  /// Atualiza o status individual de um usuário em uma microtask
  Future<UserMicrotaskModel> updateUserMicrotaskStatus({
    required String userId,
    required String microtaskId,
    required UserMicrotaskStatus status,
    double? actualHours,
    String? notes,
  }) async {
    try {
      final userMicrotask = await getUserMicrotaskStatus(
        userId: userId,
        microtaskId: microtaskId,
      );

      if (userMicrotask == null) {
        throw ValidationException('Relação usuário-microtask não encontrada');
      }

      UserMicrotaskModel updatedUserMicrotask;
      switch (status) {
        case UserMicrotaskStatus.started:
          updatedUserMicrotask = userMicrotask.markAsStarted();
          break;
        case UserMicrotaskStatus.completed:
          updatedUserMicrotask = userMicrotask.markAsCompleted(
            actualHours: actualHours,
          );
          break;
        case UserMicrotaskStatus.cancelled:
          updatedUserMicrotask = userMicrotask.markAsCancelled();
          break;
        default:
          updatedUserMicrotask = userMicrotask.copyWith(
            status: status,
            updatedAt: DateTime.now(),
          );
      }

      if (notes != null) {
        updatedUserMicrotask = updatedUserMicrotask.updateNotes(notes);
      }

      // Salva no Firestore
      await _userMicrotasksCollection
          .doc(userMicrotask.id)
          .update(updatedUserMicrotask.toFirestore());

      // Verifica se precisa atualizar o status da microtask
      await _checkAndUpdateMicrotaskStatus(microtaskId);

      return updatedUserMicrotask;
    } catch (e) {
      if (e is ValidationException || e is DatabaseException) rethrow;
      throw DatabaseException(
        'Erro ao atualizar status do usuário: ${e.toString()}',
      );
    }
  }

  /// Busca todas as relações usuário-microtask de uma microtask
  Future<List<UserMicrotaskModel>> getUserMicrotasksByMicrotaskId(
    String microtaskId,
  ) async {
    try {
      final querySnapshot = await _userMicrotasksCollection
          .where('microtaskId', isEqualTo: microtaskId)
          .get();

      return querySnapshot.docs
          .map((doc) => UserMicrotaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException(
        'Erro ao buscar relações usuário-microtask: ${e.toString()}',
      );
    }
  }

  /// Busca todas as microtasks de um usuário com seus status
  Future<List<UserMicrotaskModel>> getUserMicrotasksByUserId(
    String userId,
  ) async {
    try {
      final querySnapshot = await _userMicrotasksCollection
          .where('userId', isEqualTo: userId)
          .orderBy('assignedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => UserMicrotaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException(
        'Erro ao buscar microtasks do usuário: ${e.toString()}',
      );
    }
  }

  /// Valida se um voluntário pode ser atribuído a uma microtask
  Future<void> _validateAssignment(
    MicrotaskModel microtask,
    String userId,
    VolunteerProfileModel volunteerProfile,
  ) async {
    // Verifica se já está atribuído
    if (microtask.isAssignedTo(userId)) {
      throw ValidationException(
        'Voluntário já está atribuído a esta microtask',
      );
    }

    // Verifica se há vagas disponíveis
    if (!microtask.hasAvailableSlots) {
      throw ValidationException('Não há vagas disponíveis nesta microtask');
    }

    // Verifica se a microtask não está cancelada
    if (microtask.isCancelled) {
      throw ValidationException(
        'Não é possível atribuir voluntário a microtask cancelada',
      );
    }

    // Verifica compatibilidade de habilidades
    if (!microtask.isCompatibleWith(volunteerProfile.skills)) {
      throw ValidationException(
        'Voluntário não possui as habilidades necessárias',
      );
    }

    // TODO: Adicionar validação de disponibilidade de horários
    // TODO: Adicionar validação de recursos disponíveis
  }

  /// Verifica e atualiza o status da microtask baseado nos status individuais
  Future<void> _checkAndUpdateMicrotaskStatus(String microtaskId) async {
    try {
      final microtask = await _microtaskService.getMicrotaskById(microtaskId);
      if (microtask == null) return;

      final userMicrotasks = await getUserMicrotasksByMicrotaskId(microtaskId);

      if (userMicrotasks.isEmpty) {
        // Sem voluntários atribuídos
        if (microtask.status != MicrotaskStatus.pending) {
          await _microtaskService.updateMicrotaskStatus(
            microtaskId,
            MicrotaskStatus.pending,
          );
        }
        return;
      }

      // Verifica se todos completaram
      final allCompleted = userMicrotasks.every((um) => um.isCompleted);
      if (allCompleted && microtask.status != MicrotaskStatus.completed) {
        await _microtaskService.updateMicrotaskStatus(
          microtaskId,
          MicrotaskStatus.completed,
        );
        return;
      }

      // Verifica se algum iniciou
      final anyStarted = userMicrotasks.any(
        (um) => um.isStarted || um.isCompleted,
      );
      if (anyStarted && microtask.status == MicrotaskStatus.assigned) {
        await _microtaskService.updateMicrotaskStatus(
          microtaskId,
          MicrotaskStatus.inProgress,
        );
        return;
      }
    } catch (e) {
      // Log do erro, mas não propaga para não quebrar o fluxo principal
      print('Erro ao atualizar status da microtask: $e');
    }
  }
}
