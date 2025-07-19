import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/microtask_model.dart';
import '../models/user_microtask_model.dart';
import '../models/volunteer_profile_model.dart';
import '../models/task_model.dart';
import '../services/microtask_service.dart';
import '../services/event_service.dart';
import '../services/task_service.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Serviço responsável pelo sistema de atribuição múltipla de voluntários
///
/// ARCHITECTURAL NOTE: This service currently violates clean architecture
/// by depending on other services (MicrotaskService, EventService).
/// In proper clean architecture, this coordination should be done in repositories.
///
/// TODO: Refactor to move business logic to repositories and make this service
/// handle only direct database operations for assignment-related data.
class AssignmentService {
  final MicrotaskService _microtaskService;
  final EventService _eventService;
  final TaskService _taskService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AssignmentService({
    MicrotaskService? microtaskService,
    EventService? eventService,
    TaskService? taskService,
  }) : _microtaskService = microtaskService ?? MicrotaskService(),
       _eventService = eventService ?? EventService(),
       _taskService = taskService ?? TaskService();

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

      // Busca o perfil do voluntário na campanha
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
      final updatedMicrotask = await _microtaskService.assignVolunteer(
        microtaskId,
        userId,
      );

      // Incrementa o contador de microtasks atribuídas para o voluntário
      await _eventService.incrementVolunteerMicrotaskCount(eventId, userId);

      return updatedMicrotask;
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
      // Busca a microtask para obter o eventId
      final microtask = await _microtaskService.getMicrotaskById(microtaskId);
      if (microtask == null) {
        throw ValidationException('Microtask não encontrada');
      }

      // Remove o voluntário
      final updatedMicrotask = await _microtaskService.unassignVolunteer(
        microtaskId,
        userId,
      );

      // Decrementa o contador de microtasks atribuídas para o voluntário
      await _eventService.decrementVolunteerMicrotaskCount(
        microtask.eventId,
        userId,
      );

      return updatedMicrotask;
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

      // Busca todos os voluntários da campanha
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

      // Busca todas as microtasks da campanha
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
  /// DEPRECATED: Use Cloud Functions para operações críticas de atualização de status
  /// Este método mantido apenas para compatibilidade com código legado
  @Deprecated('Use CloudFunctionsService.updateMicrotaskStatus instead')
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
        case UserMicrotaskStatus.inProgress:
          updatedUserMicrotask = userMicrotask.markAsStarted();
          break;
        case UserMicrotaskStatus.assigned:
          updatedUserMicrotask = userMicrotask.markAsAssigned();
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

  /// Busca todas as microtasks de um usuário em uma campanha específico
  /// Ordenadas por status (assigned → in_progress → completed) e depois por assignedAt
  /// Conforme RN-01.4 e RN-01.5 do PRD
  Future<List<UserMicrotaskModel>> getUserMicrotasksByEvent({
    required String userId,
    required String eventId,
  }) async {
    try {
      final querySnapshot = await _userMicrotasksCollection
          .where('userId', isEqualTo: userId)
          .where('eventId', isEqualTo: eventId)
          .orderBy('assignedAt', descending: false)
          .get();

      final userMicrotasks = querySnapshot.docs
          .map((doc) => UserMicrotaskModel.fromFirestore(doc))
          .toList();

      // Ordena por status conforme RN-01.5: assigned → in_progress → completed
      userMicrotasks.sort((a, b) {
        // Primeiro ordena por status
        final statusOrder = {
          UserMicrotaskStatus.assigned: 0,
          UserMicrotaskStatus.inProgress: 1,
          UserMicrotaskStatus.completed: 2,
          UserMicrotaskStatus.cancelled: 3,
        };

        final statusComparison = (statusOrder[a.status] ?? 99).compareTo(
          statusOrder[b.status] ?? 99,
        );

        if (statusComparison != 0) {
          return statusComparison;
        }

        // Se o status for igual, ordena por data de atribuição
        return a.assignedAt.compareTo(b.assignedAt);
      });

      return userMicrotasks;
    } catch (e) {
      throw DatabaseException(
        'Erro ao buscar microtasks do usuário na campanha: ${e.toString()}',
      );
    }
  }

  /// Stream para escutar mudanças nas microtasks de um usuário em uma campanha
  /// Para atualizações em tempo real da agenda
  Stream<List<UserMicrotaskModel>> watchUserMicrotasksByEvent({
    required String userId,
    required String eventId,
  }) {
    return _userMicrotasksCollection
        .where('userId', isEqualTo: userId)
        .where('eventId', isEqualTo: eventId)
        .orderBy('assignedAt', descending: false)
        .snapshots()
        .map((snapshot) {
          final userMicrotasks = snapshot.docs
              .map((doc) => UserMicrotaskModel.fromFirestore(doc))
              .toList();

          // Ordena por status conforme RN-01.5: assigned → in_progress → completed
          userMicrotasks.sort((a, b) {
            final statusOrder = {
              UserMicrotaskStatus.assigned: 0,
              UserMicrotaskStatus.inProgress: 1,
              UserMicrotaskStatus.completed: 2,
              UserMicrotaskStatus.cancelled: 3,
            };

            final statusComparison = (statusOrder[a.status] ?? 99).compareTo(
              statusOrder[b.status] ?? 99,
            );

            if (statusComparison != 0) {
              return statusComparison;
            }

            return a.assignedAt.compareTo(b.assignedAt);
          });

          return userMicrotasks;
        });
  }

  /// Stream para escutar mudanças nas relações usuário-microtask de uma microtask específica
  /// Para atualizações em tempo real do progresso das tasks
  Stream<List<UserMicrotaskModel>> watchUserMicrotasksByMicrotaskId(
    String microtaskId,
  ) {
    return _userMicrotasksCollection
        .where('microtaskId', isEqualTo: microtaskId)
        .orderBy('assignedAt', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => UserMicrotaskModel.fromFirestore(doc))
              .toList();
        });
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
  /// Implementa as regras RN-04.1 a RN-04.4 do PRD
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

      // RN-04.3: Microtarefa para "Concluída" - todos os voluntários devem ter completed
      final allCompleted = userMicrotasks.every((um) => um.isCompleted);
      if (allCompleted && microtask.status != MicrotaskStatus.completed) {
        await _microtaskService.updateMicrotaskStatus(
          microtaskId,
          MicrotaskStatus.completed,
        );
        // RN-04.4: Propaga para a task pai
        await _checkAndUpdateTaskStatus(microtask.taskId);
        return;
      }

      // RN-04.1: Microtarefa para "Em Andamento" - pelo menos 1 voluntário em in_progress
      final anyStarted = userMicrotasks.any(
        (um) => um.isStarted || um.isCompleted,
      );
      if (anyStarted && microtask.status != MicrotaskStatus.inProgress) {
        await _microtaskService.updateMicrotaskStatus(
          microtaskId,
          MicrotaskStatus.inProgress,
        );
        // RN-04.2: Propaga para a task pai
        await _checkAndUpdateTaskStatus(microtask.taskId);
        return;
      }

      // Se nenhum voluntário iniciou, volta para assigned
      if (!anyStarted && microtask.status == MicrotaskStatus.inProgress) {
        await _microtaskService.updateMicrotaskStatus(
          microtaskId,
          MicrotaskStatus.assigned,
        );
        // Verifica se a task pai precisa ser atualizada
        await _checkAndUpdateTaskStatus(microtask.taskId);
      }
    } catch (e) {
      // Log do erro, mas não propaga para não quebrar o fluxo principal
      print('Erro ao atualizar status da microtask: $e');
    }
  }

  /// Verifica e atualiza o status da task baseado nos status das microtasks
  /// Implementa as regras RN-04.2 e RN-04.4 do PRD
  Future<void> _checkAndUpdateTaskStatus(String taskId) async {
    try {
      final task = await _taskService.getTaskById(taskId);
      if (task == null) return;

      // Busca todas as microtasks da task
      final microtasks = await _microtaskService.getMicrotasksByTaskId(taskId);

      if (microtasks.isEmpty) {
        // Sem microtasks, task fica pending
        if (task.status != TaskStatus.pending) {
          await _taskService.updateTaskStatus(taskId, TaskStatus.pending);
        }
        return;
      }

      // RN-04.4: Task para "Concluída" - todas as microtasks devem estar completed
      final allMicrotasksCompleted = microtasks.every(
        (microtask) => microtask.status == MicrotaskStatus.completed,
      );
      if (allMicrotasksCompleted && task.status != TaskStatus.completed) {
        await _taskService.updateTaskStatus(taskId, TaskStatus.completed);
        return;
      }

      // RN-04.2: Task para "Em Andamento" - pelo menos uma microtask em in_progress
      final anyMicrotaskInProgress = microtasks.any(
        (microtask) =>
            microtask.status == MicrotaskStatus.inProgress ||
            microtask.status == MicrotaskStatus.completed,
      );
      if (anyMicrotaskInProgress && task.status != TaskStatus.inProgress) {
        await _taskService.updateTaskStatus(taskId, TaskStatus.inProgress);
        return;
      }

      // Se nenhuma microtask está em progresso, volta para pending
      if (!anyMicrotaskInProgress && task.status == TaskStatus.inProgress) {
        await _taskService.updateTaskStatus(taskId, TaskStatus.pending);
      }
    } catch (e) {
      // Log do erro, mas não propaga para não quebrar o fluxo principal
      print('Erro ao atualizar status da task: $e');
    }
  }
}
