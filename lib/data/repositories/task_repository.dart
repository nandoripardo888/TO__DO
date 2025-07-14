import '../models/task_model.dart';
import '../services/task_service.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Repositório responsável por gerenciar dados de tasks
/// Atua como uma camada de abstração entre os controllers e os services
class TaskRepository {
  final TaskService _taskService;

  TaskRepository({TaskService? taskService})
    : _taskService = taskService ?? TaskService();

  /// Cria uma nova task
  Future<TaskModel> createTask({
    required String eventId,
    required String title,
    required String description,
    required TaskPriority priority,
    required String createdBy,
  }) async {
    try {
      final task = TaskModel.create(
        eventId: eventId,
        title: title.trim(),
        description: description.trim(),
        priority: priority,
        createdBy: createdBy,
      );

      return await _taskService.createTask(task);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao criar task: ${e.toString()}');
    }
  }

  /// Busca uma task por ID
  Future<TaskModel?> getTaskById(String taskId) async {
    try {
      if (taskId.isEmpty) {
        throw ValidationException('ID da task é obrigatório');
      }

      return await _taskService.getTaskById(taskId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar task: ${e.toString()}');
    }
  }

  /// Busca todas as tasks de um evento
  Future<List<TaskModel>> getTasksByEventId(String eventId) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      return await _taskService.getTasksByEventId(eventId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar tasks do evento: ${e.toString()}',
      );
    }
  }

  /// Busca tasks criadas por um usuário específico
  Future<List<TaskModel>> getTasksByCreator(String userId) async {
    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }

      return await _taskService.getTasksByCreator(userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar tasks do usuário: ${e.toString()}',
      );
    }
  }

  /// Busca tasks por status
  Future<List<TaskModel>> getTasksByStatus(
    String eventId,
    TaskStatus status,
  ) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      return await _taskService.getTasksByStatus(eventId, status);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar tasks por status: ${e.toString()}',
      );
    }
  }

  /// Busca tasks por prioridade
  Future<List<TaskModel>> getTasksByPriority(
    String eventId,
    TaskPriority priority,
  ) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      return await _taskService.getTasksByPriority(eventId, priority);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar tasks por prioridade: ${e.toString()}',
      );
    }
  }

  /// Atualiza uma task
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      if (task.id.isEmpty) {
        throw ValidationException('ID da task é obrigatório para atualização');
      }

      return await _taskService.updateTask(task);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao atualizar task: ${e.toString()}');
    }
  }

  /// Atualiza o status de uma task
  Future<TaskModel> updateTaskStatus(String taskId, TaskStatus status) async {
    try {
      if (taskId.isEmpty) {
        throw ValidationException('ID da task é obrigatório');
      }

      return await _taskService.updateTaskStatus(taskId, status);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao atualizar status da task: ${e.toString()}',
      );
    }
  }

  /// Atualiza os contadores de microtasks
  Future<TaskModel> updateMicrotaskCounters({
    required String taskId,
    required int microtaskCount,
    required int completedMicrotasks,
  }) async {
    try {
      if (taskId.isEmpty) {
        throw ValidationException('ID da task é obrigatório');
      }

      if (microtaskCount < 0) {
        throw ValidationException('Número de microtasks não pode ser negativo');
      }

      if (completedMicrotasks < 0) {
        throw ValidationException(
          'Número de microtasks concluídas não pode ser negativo',
        );
      }

      if (completedMicrotasks > microtaskCount) {
        throw ValidationException(
          'Número de microtasks concluídas não pode ser maior que o total',
        );
      }

      return await _taskService.updateMicrotaskCounters(
        taskId: taskId,
        microtaskCount: microtaskCount,
        completedMicrotasks: completedMicrotasks,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao atualizar contadores da task: ${e.toString()}',
      );
    }
  }

  /// Incrementa o contador de microtasks
  Future<TaskModel> incrementMicrotaskCount(String taskId) async {
    try {
      if (taskId.isEmpty) {
        throw ValidationException('ID da task é obrigatório');
      }

      return await _taskService.incrementMicrotaskCount(taskId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao incrementar contador de microtasks: ${e.toString()}',
      );
    }
  }

  /// Decrementa o contador de microtasks
  Future<TaskModel> decrementMicrotaskCount(String taskId) async {
    try {
      if (taskId.isEmpty) {
        throw ValidationException('ID da task é obrigatório');
      }

      return await _taskService.decrementMicrotaskCount(taskId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao decrementar contador de microtasks: ${e.toString()}',
      );
    }
  }

  /// Incrementa o contador de microtasks concluídas
  Future<TaskModel> incrementCompletedMicrotasks(String taskId) async {
    try {
      if (taskId.isEmpty) {
        throw ValidationException('ID da task é obrigatório');
      }

      return await _taskService.incrementCompletedMicrotasks(taskId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao incrementar microtasks concluídas: ${e.toString()}',
      );
    }
  }

  /// Decrementa o contador de microtasks concluídas
  Future<TaskModel> decrementCompletedMicrotasks(String taskId) async {
    try {
      if (taskId.isEmpty) {
        throw ValidationException('ID da task é obrigatório');
      }

      return await _taskService.decrementCompletedMicrotasks(taskId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao decrementar microtasks concluídas: ${e.toString()}',
      );
    }
  }

  /// Deleta uma task
  Future<void> deleteTask(String taskId) async {
    try {
      if (taskId.isEmpty) {
        throw ValidationException('ID da task é obrigatório');
      }

      await _taskService.deleteTask(taskId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao deletar task: ${e.toString()}');
    }
  }

  /// Deleta todas as tasks de um evento
  Future<void> deleteTasksByEventId(String eventId) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      await _taskService.deleteTasksByEventId(eventId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao deletar tasks do evento: ${e.toString()}',
      );
    }
  }

  /// Stream para escutar mudanças em uma task
  Stream<TaskModel?> watchTask(String taskId) {
    if (taskId.isEmpty) {
      throw ValidationException('ID da task é obrigatório');
    }

    return _taskService.watchTask(taskId);
  }

  /// Stream para escutar mudanças nas tasks de um evento
  Stream<List<TaskModel>> watchTasksByEventId(String eventId) {
    if (eventId.isEmpty) {
      throw ValidationException('ID do evento é obrigatório');
    }

    return _taskService.watchTasksByEventId(eventId);
  }

  /// Busca tasks com filtros múltiplos
  Future<List<TaskModel>> getTasksWithFilters({
    required String eventId,
    TaskStatus? status,
    TaskPriority? priority,
    String? createdBy,
  }) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      return await _taskService.getTasksWithFilters(
        eventId: eventId,
        status: status,
        priority: priority,
        createdBy: createdBy,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao buscar tasks com filtros: ${e.toString()}',
      );
    }
  }

  /// Valida se os dados de uma task são válidos
  bool validateTaskData({
    required String title,
    required String description,
    required String eventId,
    required String createdBy,
  }) {
    if (title.trim().isEmpty) return false;
    if (title.trim().length < 3) return false;
    if (title.trim().length > 100) return false;
    if (description.trim().isEmpty) return false;
    if (description.trim().length > 500) return false;
    if (eventId.isEmpty) return false;
    if (createdBy.isEmpty) return false;

    return true;
  }

  /// Calcula estatísticas das tasks de um evento
  Future<Map<String, dynamic>> getTaskStatistics(String eventId) async {
    try {
      if (eventId.isEmpty) {
        throw ValidationException('ID do evento é obrigatório');
      }

      final tasks = await getTasksByEventId(eventId);

      final stats = <String, dynamic>{
        'total': tasks.length,
        'pending': tasks.where((t) => t.isPending).length,
        'inProgress': tasks.where((t) => t.isInProgress).length,
        'completed': tasks.where((t) => t.isCompleted).length,
        'cancelled': tasks.where((t) => t.isCancelled).length,
        'highPriority': tasks
            .where((t) => t.priority == TaskPriority.high)
            .length,
        'mediumPriority': tasks
            .where((t) => t.priority == TaskPriority.medium)
            .length,
        'lowPriority': tasks
            .where((t) => t.priority == TaskPriority.low)
            .length,
        'totalMicrotasks': tasks.fold<int>(
          0,
          (sum, task) => sum + task.microtaskCount,
        ),
        'completedMicrotasks': tasks.fold<int>(
          0,
          (sum, task) => sum + task.completedMicrotasks,
        ),
      };

      // Calcula progresso geral
      final totalMicrotasks = stats['totalMicrotasks'] as int;
      final completedMicrotasks = stats['completedMicrotasks'] as int;
      stats['overallProgress'] = totalMicrotasks > 0
          ? (completedMicrotasks / totalMicrotasks).toDouble()
          : 0.0;

      return stats;
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException(
        'Erro ao calcular estatísticas das tasks: ${e.toString()}',
      );
    }
  }
}
