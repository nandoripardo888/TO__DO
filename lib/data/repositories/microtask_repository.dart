import '../models/microtask_model.dart';
import '../models/user_microtask_model.dart';
import '../models/volunteer_profile_model.dart';
import '../services/microtask_service.dart';
import '../services/assignment_service.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Repositório responsável por gerenciar dados de microtasks
/// Atua como uma camada de abstração entre os controllers e os services
class MicrotaskRepository {
  final MicrotaskService _microtaskService;
  final AssignmentService _assignmentService;

  MicrotaskRepository({
    MicrotaskService? microtaskService,
    AssignmentService? assignmentService,
  }) : _microtaskService = microtaskService ?? MicrotaskService(),
        _assignmentService = assignmentService ?? AssignmentService();

  /// Cria uma nova microtask
  Future<MicrotaskModel> createMicrotask({
    required String taskId,
    required String eventId,
    required String title,
    required String description,
    required List<String> requiredSkills,
    required List<String> requiredResources,
    required double estimatedHours,
    required String priority,
    required int maxVolunteers,
    required String createdBy,
    String? notes,
  }) async {
    try {
      final microtask = MicrotaskModel.create(
        taskId: taskId,
        eventId: eventId,
        title: title.trim(),
        description: description.trim(),
        requiredSkills: requiredSkills,
        requiredResources: requiredResources,
        estimatedHours: estimatedHours,
        priority: priority,
        maxVolunteers: maxVolunteers,
        createdBy: createdBy,
        notes: notes?.trim(),
      );

      return await _microtaskService.createMicrotask(microtask);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao criar microtask: ${e.toString()}');
    }
  }

  /// Busca uma microtask por ID
  Future<MicrotaskModel?> getMicrotaskById(String microtaskId) async {
    try {
      if (microtaskId.isEmpty) {
        throw ValidationException('ID da microtask é obrigatório');
      }

      return await _microtaskService.getMicrotaskById(microtaskId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar microtask: ${e.toString()}');
    }
  }

  /// Busca todas as microtasks de uma task
  Future<List<MicrotaskModel>> getMicrotasksByTaskId(String taskId) async {
    try {
      if (taskId.isEmpty) {
        throw ValidationException('ID da task é obrigatório');
      }

      return await _microtaskService.getMicrotasksByTaskId(taskId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar microtasks da task: ${e.toString()}');
    }
  }

  /// Busca todas as microtasks de um evento
  Future<List<MicrotaskModel>> getMicrotasksByEventId(String eventId) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      return await _microtaskService.getMicrotasksByEventId(eventId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar microtasks do evento: ${e.toString()}');
    }
  }

  /// Busca microtasks atribuídas a um usuário específico
  Future<List<MicrotaskModel>> getMicrotasksByUserId(String userId) async {
    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }

      return await _microtaskService.getMicrotasksByUserId(userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar microtasks do usuário: ${e.toString()}');
    }
  }

  /// Busca microtasks por status
  Future<List<MicrotaskModel>> getMicrotasksByStatus(String eventId, MicrotaskStatus status) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      return await _microtaskService.getMicrotasksByStatus(eventId, status);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar microtasks por status: ${e.toString()}');
    }
  }

  /// Atualiza uma microtask
  Future<MicrotaskModel> updateMicrotask(MicrotaskModel microtask) async {
    try {
      if (microtask.id.isEmpty) {
        throw ValidationException('ID da microtask é obrigatório para atualização');
      }

      return await _microtaskService.updateMicrotask(microtask);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao atualizar microtask: ${e.toString()}');
    }
  }

  /// Atribui um voluntário a uma microtask
  Future<MicrotaskModel> assignVolunteer({
    required String microtaskId,
    required String userId,
    required String eventId,
  }) async {
    try {
      if (microtaskId.isEmpty) {
        throw ValidationException('ID da microtask é obrigatório');
      }
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      return await _assignmentService.assignVolunteerToMicrotask(
        microtaskId: microtaskId,
        userId: userId,
        eventId: eventId,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao atribuir voluntário: ${e.toString()}');
    }
  }

  /// Remove um voluntário de uma microtask
  Future<MicrotaskModel> unassignVolunteer({
    required String microtaskId,
    required String userId,
  }) async {
    try {
      if (microtaskId.isEmpty) {
        throw ValidationException('ID da microtask é obrigatório');
      }
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }

      return await _assignmentService.unassignVolunteerFromMicrotask(
        microtaskId: microtaskId,
        userId: userId,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao remover voluntário: ${e.toString()}');
    }
  }

  /// Busca voluntários compatíveis com uma microtask
  Future<List<VolunteerProfileModel>> getCompatibleVolunteers({
    required String eventId,
    required String microtaskId,
  }) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }
      if (microtaskId.isEmpty) {
        throw ValidationException('ID da microtask é obrigatório');
      }

      return await _assignmentService.getCompatibleVolunteers(
        eventId: eventId,
        microtaskId: microtaskId,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar voluntários compatíveis: ${e.toString()}');
    }
  }

  /// Busca microtasks disponíveis para um voluntário
  Future<List<MicrotaskModel>> getAvailableMicrotasksForVolunteer({
    required String eventId,
    required String userId,
  }) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }

      return await _assignmentService.getAvailableMicrotasksForVolunteer(
        eventId: eventId,
        userId: userId,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar microtasks disponíveis: ${e.toString()}');
    }
  }

  /// Atualiza o status de uma microtask
  Future<MicrotaskModel> updateMicrotaskStatus(String microtaskId, MicrotaskStatus status) async {
    try {
      if (microtaskId.isEmpty) {
        throw ValidationException('ID da microtask é obrigatório');
      }

      return await _microtaskService.updateMicrotaskStatus(microtaskId, status);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao atualizar status da microtask: ${e.toString()}');
    }
  }

  /// Busca o status individual de um usuário em uma microtask
  Future<UserMicrotaskModel?> getUserMicrotaskStatus({
    required String userId,
    required String microtaskId,
  }) async {
    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }
      if (microtaskId.isEmpty) {
        throw ValidationException('ID da microtask é obrigatório');
      }

      return await _assignmentService.getUserMicrotaskStatus(
        userId: userId,
        microtaskId: microtaskId,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar status do usuário: ${e.toString()}');
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
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }
      if (microtaskId.isEmpty) {
        throw ValidationException('ID da microtask é obrigatório');
      }

      return await _assignmentService.updateUserMicrotaskStatus(
        userId: userId,
        microtaskId: microtaskId,
        status: status,
        actualHours: actualHours,
        notes: notes,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao atualizar status do usuário: ${e.toString()}');
    }
  }

  /// Busca todas as relações usuário-microtask de uma microtask
  Future<List<UserMicrotaskModel>> getUserMicrotasksByMicrotaskId(String microtaskId) async {
    try {
      if (microtaskId.isEmpty) {
        throw ValidationException('ID da microtask é obrigatório');
      }

      return await _assignmentService.getUserMicrotasksByMicrotaskId(microtaskId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar relações usuário-microtask: ${e.toString()}');
    }
  }

  /// Busca todas as microtasks de um usuário com seus status
  Future<List<UserMicrotaskModel>> getUserMicrotasksByUserId(String userId) async {
    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }

      return await _assignmentService.getUserMicrotasksByUserId(userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar microtasks do usuário: ${e.toString()}');
    }
  }

  /// Deleta uma microtask
  Future<void> deleteMicrotask(String microtaskId) async {
    try {
      if (microtaskId.isEmpty) {
        throw ValidationException('ID da microtask é obrigatório');
      }

      await _microtaskService.deleteMicrotask(microtaskId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao deletar microtask: ${e.toString()}');
    }
  }

  /// Deleta todas as microtasks de uma task
  Future<void> deleteMicrotasksByTaskId(String taskId) async {
    try {
      if (taskId.isEmpty) {
        throw ValidationException('ID da task é obrigatório');
      }

      await _microtaskService.deleteMicrotasksByTaskId(taskId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao deletar microtasks da task: ${e.toString()}');
    }
  }

  /// Stream para escutar mudanças em uma microtask
  Stream<MicrotaskModel?> watchMicrotask(String microtaskId) {
    if (microtaskId.isEmpty) {
      throw ValidationException('ID da microtask é obrigatório');
    }

    return _microtaskService.watchMicrotask(microtaskId);
  }

  /// Stream para escutar mudanças nas microtasks de uma task
  Stream<List<MicrotaskModel>> watchMicrotasksByTaskId(String taskId) {
    if (taskId.isEmpty) {
      throw ValidationException('ID da task é obrigatório');
    }

    return _microtaskService.watchMicrotasksByTaskId(taskId);
  }

  /// Stream para escutar mudanças nas microtasks de um evento
  Stream<List<MicrotaskModel>> watchMicrotasksByEventId(String eventId) {
    if (eventId.isEmpty) {
      throw ValidationException('ID do evento é obrigatório');
    }

    return _microtaskService.watchMicrotasksByEventId(eventId);
  }

  /// Valida se os dados de uma microtask são válidos
  bool validateMicrotaskData({
    required String title,
    required String description,
    required String taskId,
    required String eventId,
    required String createdBy,
    required int maxVolunteers,
    required double estimatedHours,
  }) {
    if (title.trim().isEmpty) return false;
    if (title.trim().length < 3) return false;
    if (title.trim().length > 100) return false;
    if (description.trim().isEmpty) return false;
    if (description.trim().length > 1000) return false;
    if (taskId.isEmpty) return false;
    if (eventId.isEmpty) return false;
    if (createdBy.isEmpty) return false;
    if (maxVolunteers <= 0) return false;
    if (estimatedHours < 0) return false;

    return true;
  }
}
