import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Serviço responsável por operações relacionadas a tasks no Firebase
class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // Referência da coleção
  CollectionReference get _tasksCollection => _firestore.collection('tasks');

  /// Cria uma nova task
  Future<TaskModel> createTask({
    required String eventId,
    required String title,
    required String description,
    required TaskPriority priority,
    required String createdBy,
  }) async {
    try {
      // Gera um ID único para a task
      final taskId = _uuid.v4();
      final now = DateTime.now();

      // Cria a task com dados gerados pelo service
      final task = TaskModel.create(
        id: taskId,
        eventId: eventId,
        title: title,
        description: description,
        priority: priority,
        createdBy: createdBy,
        createdAt: now,
        updatedAt: now,
      );

      // Note: Validation should be done by repository/controller before calling service

      // Salva no Firestore
      await _tasksCollection.doc(taskId).set(task.toFirestore());

      return task;
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Erro ao criar task: ${e.toString()}');
    }
  }

  /// Busca uma task por ID
  Future<TaskModel?> getTaskById(String taskId) async {
    try {
      final doc = await _tasksCollection.doc(taskId).get();

      if (!doc.exists) return null;

      return TaskModel.fromFirestore(doc);
    } catch (e) {
      throw DatabaseException('Erro ao buscar task: ${e.toString()}');
    }
  }

  /*
  /// Busca todas as tasks de uma campanha
  Future<List<TaskModel>> getTasksByEventId(String eventId) async {
    try {
      final querySnapshot = await _tasksCollection
          .where('eventId', isEqualTo: eventId)
          .get();

      return querySnapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException(
        'Erro ao buscar tasks da campanha: ${e.toString()}',
      );
    }
  }
  */

  Future<List<TaskModel>> getTasksByEventId(String eventId) async {
    try {
      final querySnapshot = await _tasksCollection
          .where('eventId', isEqualTo: eventId)
          .orderBy('createdAt', descending: true) // agora funciona
          .get();

      return querySnapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Erro ao buscar tasks da campanha: ${e.toString()}');
      throw DatabaseException(
        'Erro ao buscar tasks da campanha: ${e.toString()}',
      );
    }
  }

  /// Busca tasks criadas por um usuário específico
  Future<List<TaskModel>> getTasksByCreator(String userId) async {
    try {
      final querySnapshot = await _tasksCollection
          .where('createdBy', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException(
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
      final querySnapshot = await _tasksCollection
          .where('eventId', isEqualTo: eventId)
          .where('status', isEqualTo: status.value)
          .orderBy('createdAt', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException(
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
      final querySnapshot = await _tasksCollection
          .where('eventId', isEqualTo: eventId)
          .where('priority', isEqualTo: priority.value)
          .orderBy('createdAt', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException(
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

      // Note: Validation should be done by repository/controller before calling service

      // Atualiza o timestamp
      final updatedTask = task.withUpdatedTimestamp();

      // Salva no Firestore
      await _tasksCollection.doc(task.id).update(updatedTask.toFirestore());

      return updatedTask;
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Erro ao atualizar task: ${e.toString()}');
    }
  }

  /// Atualiza o status de uma task
  Future<TaskModel> updateTaskStatus(String taskId, TaskStatus status) async {
    try {
      final task = await getTaskById(taskId);
      if (task == null) {
        throw DatabaseException('Task não encontrada');
      }

      final updatedTask = task.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );

      return await updateTask(updatedTask);
    } catch (e) {
      if (e is DatabaseException || e is ValidationException) rethrow;
      throw DatabaseException(
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
      final task = await getTaskById(taskId);
      if (task == null) {
        throw DatabaseException('Task não encontrada');
      }

      final updatedTask = task
          .copyWith(
            microtaskCount: microtaskCount,
            completedMicrotasks: completedMicrotasks,
            updatedAt: DateTime.now(),
          )
          .updateStatusFromMicrotasks();

      return await updateTask(updatedTask);
    } catch (e) {
      if (e is DatabaseException || e is ValidationException) rethrow;
      throw DatabaseException(
        'Erro ao atualizar contadores da task: ${e.toString()}',
      );
    }
  }

  /// Incrementa o contador de microtasks
  Future<TaskModel> incrementMicrotaskCount(String taskId) async {
    try {
      final task = await getTaskById(taskId);
      if (task == null) {
        throw DatabaseException('Task não encontrada');
      }

      final updatedTask = task.incrementMicrotaskCount();
      return await updateTask(updatedTask);
    } catch (e) {
      if (e is DatabaseException || e is ValidationException) rethrow;
      throw DatabaseException(
        'Erro ao incrementar contador de microtasks: ${e.toString()}',
      );
    }
  }

  /// Decrementa o contador de microtasks
  Future<TaskModel> decrementMicrotaskCount(String taskId) async {
    try {
      final task = await getTaskById(taskId);
      if (task == null) {
        throw DatabaseException('Task não encontrada');
      }

      final updatedTask = task.decrementMicrotaskCount();
      return await updateTask(updatedTask);
    } catch (e) {
      if (e is DatabaseException || e is ValidationException) rethrow;
      throw DatabaseException(
        'Erro ao decrementar contador de microtasks: ${e.toString()}',
      );
    }
  }

  /// Incrementa o contador de microtasks concluídas
  Future<TaskModel> incrementCompletedMicrotasks(String taskId) async {
    try {
      final task = await getTaskById(taskId);
      if (task == null) {
        throw DatabaseException('Task não encontrada');
      }

      final updatedTask = task
          .incrementCompletedMicrotasks()
          .updateStatusFromMicrotasks();
      return await updateTask(updatedTask);
    } catch (e) {
      if (e is DatabaseException || e is ValidationException) rethrow;
      throw DatabaseException(
        'Erro ao incrementar microtasks concluídas: ${e.toString()}',
      );
    }
  }

  /// Decrementa o contador de microtasks concluídas
  Future<TaskModel> decrementCompletedMicrotasks(String taskId) async {
    try {
      final task = await getTaskById(taskId);
      if (task == null) {
        throw DatabaseException('Task não encontrada');
      }

      final updatedTask = task
          .decrementCompletedMicrotasks()
          .updateStatusFromMicrotasks();
      return await updateTask(updatedTask);
    } catch (e) {
      if (e is DatabaseException || e is ValidationException) rethrow;
      throw DatabaseException(
        'Erro ao decrementar microtasks concluídas: ${e.toString()}',
      );
    }
  }

  /// Deleta uma task
  Future<void> deleteTask(String taskId) async {
    try {
      await _tasksCollection.doc(taskId).delete();
    } catch (e) {
      throw DatabaseException('Erro ao deletar task: ${e.toString()}');
    }
  }

  /// Deleta todas as tasks de uma campanha
  Future<void> deleteTasksByEventId(String eventId) async {
    try {
      final querySnapshot = await _tasksCollection
          .where('eventId', isEqualTo: eventId)
          .get();

      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw DatabaseException(
        'Erro ao deletar tasks da campanha: ${e.toString()}',
      );
    }
  }

  /// Stream para escutar mudanças em uma task
  Stream<TaskModel?> watchTask(String taskId) {
    return _tasksCollection.doc(taskId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return TaskModel.fromFirestore(doc);
    });
  }

  /// Stream para escutar mudanças nas tasks de uma campanha
  Stream<List<TaskModel>> watchTasksByEventId(String eventId) {
    return _tasksCollection
        .where('eventId', isEqualTo: eventId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList(),
        );
  }

  /// Busca tasks com filtros múltiplos
  Future<List<TaskModel>> getTasksWithFilters({
    required String eventId,
    TaskStatus? status,
    TaskPriority? priority,
    String? createdBy,
  }) async {
    try {
      Query query = _tasksCollection.where('eventId', isEqualTo: eventId);

      if (status != null) {
        query = query.where('status', isEqualTo: status.value);
      }

      if (priority != null) {
        query = query.where('priority', isEqualTo: priority.value);
      }

      if (createdBy != null && createdBy.isNotEmpty) {
        query = query.where('createdBy', isEqualTo: createdBy);
      }

      // Removido orderBy temporariamente para evitar problemas de índice
      query = query.orderBy('createdAt', descending: false);

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException(
        'Erro ao buscar tasks com filtros: ${e.toString()}',
      );
    }
  }
}
