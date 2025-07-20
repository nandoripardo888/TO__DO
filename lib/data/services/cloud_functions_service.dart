import 'package:cloud_functions/cloud_functions.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Serviço para interagir com Firebase Cloud Functions
class CloudFunctionsService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Atualiza o status de uma microtask para um usuário específico
  ///
  /// [microtaskId] ID da microtask
  /// [newStatus] Novo status (assigned, in_progress, completed)
  /// [userId] ID do usuário
  ///
  /// Retorna true se a atualização foi bem-sucedida
  /// Lança [NetworkException] em caso de erro
  Future<bool> updateMicrotaskStatus({
    required String microtaskId,
    required String newStatus,
    required String userId,
  }) async {
    try {
      final callable = _functions.httpsCallable('updateMicrotaskStatus');

      final payload = {
        'microtaskId': microtaskId,
        'newStatus': newStatus,
        'userId': userId,
      };

      final result = await callable.call(payload);

      final data = result.data as Map<String, dynamic>;
      final success = data['success'] == true;

      return success;
    } on FirebaseFunctionsException catch (e) {
      throw NetworkException(
        e.message ?? 'Erro ao atualizar status da microtask',
        code: e.code,
        originalException: e,
      );
    } catch (e, stackTrace) {
      throw NetworkException(
        'Erro inesperado ao atualizar status da microtask: $e',
        originalException: e,
      );
    }
  }

  /// Atualiza o status de uma task
  ///
  /// [taskId] ID da task
  /// [newStatus] Novo status (pending, in_progress, completed)
  ///
  /// Retorna true se a atualização foi bem-sucedida
  /// Lança [NetworkException] em caso de erro
  Future<bool> updateTaskStatus({
    required String taskId,
    required String newStatus,
  }) async {
    try {
      final callable = _functions.httpsCallable('updateTaskStatus');

      final result = await callable.call({
        'taskId': taskId,
        'newStatus': newStatus,
      });

      final data = result.data as Map<String, dynamic>;
      return data['success'] == true;
    } on FirebaseFunctionsException catch (e) {
      throw NetworkException(
        e.message ?? 'Erro ao atualizar status da task',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw NetworkException(
        'Erro inesperado ao atualizar status da task: $e',
        originalException: e,
      );
    }
  }

  /// Obtém estatísticas de uma task
  ///
  /// [taskId] ID da task
  ///
  /// Retorna um mapa com as estatísticas da task
  /// Lança [NetworkException] em caso de erro
  Future<TaskStatistics> getTaskStatistics(String taskId) async {
    try {
      final callable = _functions.httpsCallable('getTaskStatistics');

      final result = await callable.call({'taskId': taskId});

      final data = result.data as Map<String, dynamic>;
      if (data['success'] == true) {
        return TaskStatistics.fromMap(data['statistics']);
      } else {
        throw NetworkException('Falha ao obter estatísticas da task');
      }
    } on FirebaseFunctionsException catch (e) {
      throw NetworkException(
        e.message ?? 'Erro ao obter estatísticas da task',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw NetworkException(
        'Erro inesperado ao obter estatísticas da task: $e',
        originalException: e,
      );
    }
  }
}

/// Classe para representar estatísticas de uma task
class TaskStatistics {
  final int total;
  final int pending;
  final int assigned;
  final int inProgress;
  final int completed;

  const TaskStatistics({
    required this.total,
    required this.pending,
    required this.assigned,
    required this.inProgress,
    required this.completed,
  });

  factory TaskStatistics.fromMap(Map<String, dynamic> map) {
    return TaskStatistics(
      total: map['total'] ?? 0,
      pending: map['pending'] ?? 0,
      assigned: map['assigned'] ?? 0,
      inProgress: map['in_progress'] ?? 0,
      completed: map['completed'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'pending': pending,
      'assigned': assigned,
      'in_progress': inProgress,
      'completed': completed,
    };
  }

  /// Calcula a porcentagem de progresso
  double get progressPercentage {
    if (total == 0) return 0.0;
    return (completed / total) * 100;
  }

  /// Verifica se a task está completa
  bool get isCompleted => total > 0 && completed == total;

  /// Verifica se a task está em progresso
  bool get isInProgress => inProgress > 0 || completed > 0;

  @override
  String toString() {
    return 'TaskStatistics(total: $total, pending: $pending, assigned: $assigned, inProgress: $inProgress, completed: $completed)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskStatistics &&
        other.total == total &&
        other.pending == pending &&
        other.assigned == assigned &&
        other.inProgress == inProgress &&
        other.completed == completed;
  }

  @override
  int get hashCode {
    return total.hashCode ^
        pending.hashCode ^
        assigned.hashCode ^
        inProgress.hashCode ^
        completed.hashCode;
  }
}
