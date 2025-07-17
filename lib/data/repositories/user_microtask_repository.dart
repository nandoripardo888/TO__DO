import '../../core/exceptions/app_exceptions.dart';
import '../models/user_microtask_model.dart';
import '../services/assignment_service.dart';

/// Repository responsável por gerenciar operações relacionadas às relações usuário-microtask
/// Abstrai o acesso aos dados e fornece uma interface limpa para os controllers
/// Baseado no padrão Repository definido na arquitetura do projeto
class UserMicrotaskRepository {
  final AssignmentService _assignmentService;

  UserMicrotaskRepository({AssignmentService? assignmentService})
      : _assignmentService = assignmentService ?? AssignmentService();

  /// Busca todas as microtasks de um usuário em um evento específico
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
        throw ValidationException('ID do evento é obrigatório');
      }

      return await _assignmentService.getUserMicrotasksByEvent(
        userId: userId,
        eventId: eventId,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar microtasks do usuário no evento: ${e.toString()}',
      );
    }
  }

  /// Stream para escutar mudanças nas microtasks de um usuário em um evento
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
        throw ValidationException('ID do evento é obrigatório');
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

  /// Busca todas as microtasks de um usuário (todos os eventos)
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

      // Valida transições de status conforme RN-03.3, RN-03.4 e RN-03.5
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
  /// RN-03.3: assigned → in_progress → completed
  /// RN-03.4: Permite regressão completed → in_progress → assigned
  /// RN-03.5: Impede transição direta completed → assigned
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

    // RN-03.2: assigned é estado inicial, não pode ser selecionado pelo usuário
    // (mas pode ser resultado de regressão)
    
    // RN-03.5: Impede transição direta de completed para assigned
    if (currentStatus == UserMicrotaskStatus.completed &&
        newStatus == UserMicrotaskStatus.assigned) {
      throw ValidationException(
        'Não é possível voltar diretamente de "Concluída" para "Atribuída". '
        'Primeiro mude para "Em Andamento".',
      );
    }

    // Todas as outras transições são permitidas conforme RN-03.3 e RN-03.4
  }
}
