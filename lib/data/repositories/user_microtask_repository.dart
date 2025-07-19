import '../../core/exceptions/app_exceptions.dart';
import '../models/user_microtask_model.dart';
import '../services/assignment_service.dart';
import '../services/cloud_functions_service.dart';

/// Repository responsável por gerenciar operações relacionadas às relações usuário-microtask
/// Abstrai o acesso aos dados e fornece uma interface limpa para os controllers
/// Baseado no padrão Repository definido na arquitetura do projeto
class UserMicrotaskRepository {
  final AssignmentService _assignmentService;
  final CloudFunctionsService _cloudFunctionsService;

  UserMicrotaskRepository({
    AssignmentService? assignmentService,
    CloudFunctionsService? cloudFunctionsService,
  }) : _assignmentService = assignmentService ?? AssignmentService(),
       _cloudFunctionsService =
           cloudFunctionsService ?? CloudFunctionsService();

  /// Busca todas as microtasks de um usuário em uma campanha específico
  /// Conforme RN-01.4 e RN-01.5 do PRD - ordenadas por status e data de atribuição
  Future<List<UserMicrotaskModel>> getUserMicrotasksByEvent({
    required String userId,
    required String eventId,
  }) async {
    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }
      if (eventId.isEmpty) {
        throw ValidationException('ID da campanha é obrigatório');
      }

      return await _assignmentService.getUserMicrotasksByEvent(
        userId: userId,
        eventId: eventId,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
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
    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }
      if (eventId.isEmpty) {
        throw ValidationException('ID da campanha é obrigatório');
      }

      return _assignmentService.watchUserMicrotasksByEvent(
        userId: userId,
        eventId: eventId,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao criar stream de microtasks do usuário: ${e.toString()}',
      );
    }
  }

  /// Busca todas as microtasks de um usuário (todos as campanhas)
  Future<List<UserMicrotaskModel>> getUserMicrotasksByUserId(
    String userId,
  ) async {
    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }

      return await _assignmentService.getUserMicrotasksByUserId(userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar microtasks do usuário: ${e.toString()}',
      );
    }
  }

  /// Busca o status individual de um usuário em uma microtask específica
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
      throw RepositoryException(
        'Erro ao buscar status do usuário na microtask: ${e.toString()}',
      );
    }
  }

  /// Atualiza o status individual de um usuário em uma microtask
  /// Conforme RN-03 do PRD - controla as transições de status permitidas
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

      // Valida transições de status conforme RN-03.3 e RN-03.4 (apenas progressão)
      await _validateStatusTransition(userId, microtaskId, status);

      return await _assignmentService.updateUserMicrotaskStatus(
        userId: userId,
        microtaskId: microtaskId,
        status: status,
        actualHours: actualHours,
        notes: notes,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao atualizar status do usuário: ${e.toString()}',
      );
    }
  }

  /// Atualiza o status usando Cloud Functions (método alternativo)
  /// Utiliza as Cloud Functions para garantir validação e propagação automática
  /// Recomendado para operações críticas que requerem consistência de dados
  Future<bool> updateUserMicrotaskStatusWithCloudFunction({
    required String userId,
    required String microtaskId,
    required UserMicrotaskStatus status,
  }) async {
    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }
      if (microtaskId.isEmpty) {
        throw ValidationException('ID da microtask é obrigatório');
      }

      // Converte o enum para string
      String statusString;
      switch (status) {
        case UserMicrotaskStatus.assigned:
          statusString = 'assigned';
          break;
        case UserMicrotaskStatus.inProgress:
          statusString = 'in_progress';
          break;
        case UserMicrotaskStatus.completed:
          statusString = 'completed';
          break;
        case UserMicrotaskStatus.cancelled:
          statusString = 'cancelled';
          break;
      }

      // Chama a Cloud Function para atualizar o status
      return await _cloudFunctionsService.updateMicrotaskStatus(
        microtaskId: microtaskId,
        newStatus: statusString,
        userId: userId,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao atualizar status via Cloud Function: ${e.toString()}',
      );
    }
  }

  /// Busca todas as relações usuário-microtask de uma microtask específica
  Future<List<UserMicrotaskModel>> getUserMicrotasksByMicrotaskId(
    String microtaskId,
  ) async {
    try {
      if (microtaskId.isEmpty) {
        throw ValidationException('ID da microtask é obrigatório');
      }

      return await _assignmentService.getUserMicrotasksByMicrotaskId(
        microtaskId,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar relações usuário-microtask: ${e.toString()}',
      );
    }
  }

  /// Valida se a transição de status é permitida conforme regras do PRD
  /// RN-03.3: assigned → in_progress → completed (apenas progressão)
  /// RN-03.4: Impede qualquer tipo de regressão de status
  Future<void> _validateStatusTransition(
    String userId,
    String microtaskId,
    UserMicrotaskStatus newStatus,
  ) async {
    final currentUserMicrotask = await getUserMicrotaskStatus(
      userId: userId,
      microtaskId: microtaskId,
    );

    if (currentUserMicrotask == null) {
      throw ValidationException('Relação usuário-microtask não encontrada');
    }

    final currentStatus = currentUserMicrotask.status;

    // RN-03.4: Impede qualquer tipo de regressão de status
    if (_isStatusRegression(currentStatus, newStatus)) {
      throw ValidationException(
        'Não é possível regredir o status de uma microtask. '
        'Apenas progressão para frente é permitida.',
      );
    }

    // Valida progressão sequencial
    if (!_isValidProgression(currentStatus, newStatus)) {
      throw ValidationException(
        'Transição de status inválida. '
        'Siga a sequência: Atribuída → Em Andamento → Concluída.',
      );
    }
  }

  /// Verifica se a mudança de status representa uma regressão
  bool _isStatusRegression(
    UserMicrotaskStatus currentStatus,
    UserMicrotaskStatus newStatus,
  ) {
    const statusOrder = {
      UserMicrotaskStatus.assigned: 1,
      UserMicrotaskStatus.inProgress: 2,
      UserMicrotaskStatus.completed: 3,
    };

    final currentOrder = statusOrder[currentStatus] ?? 0;
    final newOrder = statusOrder[newStatus] ?? 0;

    return newOrder < currentOrder;
  }

  /// Verifica se a progressão de status é válida (sequencial)
  bool _isValidProgression(
    UserMicrotaskStatus currentStatus,
    UserMicrotaskStatus newStatus,
  ) {
    // Permite manter o mesmo status
    if (currentStatus == newStatus) return true;

    // Progressões válidas
    switch (currentStatus) {
      case UserMicrotaskStatus.assigned:
        return newStatus == UserMicrotaskStatus.inProgress;
      case UserMicrotaskStatus.inProgress:
        return newStatus == UserMicrotaskStatus.completed;
      case UserMicrotaskStatus.completed:
        return false; // Não permite mudança a partir de completed
      default:
        return false;
    }
  }
}
