import 'package:cloud_firestore/cloud_firestore.dart';

/// Enums para status e prioridade das tasks
enum TaskStatus {
  pending('pending'),
  inProgress('in_progress'),
  completed('completed'),
  cancelled('cancelled');

  const TaskStatus(this.value);
  final String value;

  static TaskStatus fromString(String value) {
    return TaskStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TaskStatus.pending,
    );
  }

  @override
  String toString() => value;
}

enum TaskPriority {
  low('low'),
  medium('medium'),
  high('high');

  const TaskPriority(this.value);
  final String value;

  static TaskPriority fromString(String value) {
    return TaskPriority.values.firstWhere(
      (priority) => priority.value == value,
      orElse: () => TaskPriority.medium,
    );
  }

  @override
  String toString() => value;
}

/// Modelo de dados para representar uma task (organizadora) no sistema
/// Tasks servem como agrupadores organizacionais para microtasks
/// Baseado na estrutura definida no SPEC_GERAL.md
class TaskModel {
  final String id;
  final String eventId;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskStatus status;
  final String createdBy;
  final int microtaskCount;
  final int completedMicrotasks;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaskModel({
    required this.id,
    required this.eventId,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdBy,
    required this.microtaskCount,
    required this.completedMicrotasks,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Cria uma instância de TaskModel a partir de um Map (JSON)
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      eventId: map['eventId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      priority: TaskPriority.fromString(map['priority'] as String),
      status: TaskStatus.fromString(map['status'] as String),
      createdBy: map['createdBy'] as String,
      microtaskCount: map['microtaskCount'] as int? ?? 0,
      completedMicrotasks: map['completedMicrotasks'] as int? ?? 0,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Cria uma instância de TaskModel a partir de um DocumentSnapshot do Firestore
  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel.fromMap({'id': doc.id, ...data});
  }

  /// Converte a instância para um Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventId': eventId,
      'title': title,
      'description': description,
      'priority': priority.value,
      'status': status.value,
      'createdBy': createdBy,
      'microtaskCount': microtaskCount,
      'completedMicrotasks': completedMicrotasks,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Converte para formato do Firestore (sem o ID)
  Map<String, dynamic> toFirestore() {
    final map = toMap();
    map.remove('id');
    return map;
  }

  /// Cria uma cópia da instância com alguns campos alterados
  TaskModel copyWith({
    String? id,
    String? eventId,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    String? createdBy,
    int? microtaskCount,
    int? completedMicrotasks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      microtaskCount: microtaskCount ?? this.microtaskCount,
      completedMicrotasks: completedMicrotasks ?? this.completedMicrotasks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Cria uma nova instância com updatedAt atualizado para agora
  TaskModel withUpdatedTimestamp() {
    return copyWith(updatedAt: DateTime.now());
  }

  /// Factory para criar uma nova task
  /// Note: ID e timestamps devem ser definidos pelo service
  factory TaskModel.create({
    required String id,
    required String eventId,
    required String title,
    required String description,
    required TaskPriority priority,
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    return TaskModel(
      id: id,
      eventId: eventId,
      title: title,
      description: description,
      priority: priority,
      status: TaskStatus.pending,
      createdBy: createdBy,
      microtaskCount: 0,
      completedMicrotasks: 0,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Valida se os dados da task são válidos
  List<String> validate() {
    final errors = <String>[];

    if (eventId.isEmpty) {
      errors.add('ID da Campanha é obrigatório');
    }

    if (title.isEmpty) {
      errors.add('Título da task é obrigatório');
    } else if (title.length < 3) {
      errors.add('Título deve ter pelo menos 3 caracteres');
    } else if (title.length > 100) {
      errors.add('Título deve ter no máximo 100 caracteres');
    }

    if (description.isEmpty) {
      errors.add('Descrição da task é obrigatória');
    } else if (description.length > 500) {
      errors.add('Descrição deve ter no máximo 500 caracteres');
    }

    if (createdBy.isEmpty) {
      errors.add('Criador da task é obrigatório');
    }

    if (microtaskCount < 0) {
      errors.add('Número de microtasks não pode ser negativo');
    }

    if (completedMicrotasks < 0) {
      errors.add('Número de microtasks concluídas não pode ser negativo');
    }

    if (completedMicrotasks > microtaskCount) {
      errors.add(
        'Número de microtasks concluídas não pode ser maior que o total',
      );
    }

    return errors;
  }

  /// Verifica se a task é válida
  bool isValid() => validate().isEmpty;

  /// Calcula o progresso da task (0.0 a 1.0)
  double get progress {
    if (microtaskCount == 0) return 0.0;
    return completedMicrotasks / microtaskCount;
  }

  /// Verifica se a task está concluída
  bool get isCompleted => status == TaskStatus.completed;

  /// Verifica se a task está em progresso
  bool get isInProgress => status == TaskStatus.inProgress;

  /// Verifica se a task está pendente
  bool get isPending => status == TaskStatus.pending;

  /// Verifica se a task foi cancelada
  bool get isCancelled => status == TaskStatus.cancelled;

  /// Atualiza o status baseado no progresso das microtasks
  TaskModel updateStatusFromMicrotasks() {
    TaskStatus newStatus;

    if (completedMicrotasks == 0) {
      newStatus = TaskStatus.pending;
    } else if (completedMicrotasks == microtaskCount) {
      newStatus = TaskStatus.completed;
    } else {
      newStatus = TaskStatus.inProgress;
    }

    return copyWith(status: newStatus, updatedAt: DateTime.now());
  }

  /// Incrementa o contador de microtasks
  TaskModel incrementMicrotaskCount() {
    return copyWith(
      microtaskCount: microtaskCount + 1,
      updatedAt: DateTime.now(),
    );
  }

  /// Decrementa o contador de microtasks
  TaskModel decrementMicrotaskCount() {
    final newCount = microtaskCount > 0 ? microtaskCount - 1 : 0;
    final newCompleted = completedMicrotasks > newCount
        ? newCount
        : completedMicrotasks;

    return copyWith(
      microtaskCount: newCount,
      completedMicrotasks: newCompleted,
      updatedAt: DateTime.now(),
    );
  }

  /// Incrementa o contador de microtasks concluídas
  TaskModel incrementCompletedMicrotasks() {
    final newCompleted = completedMicrotasks < microtaskCount
        ? completedMicrotasks + 1
        : completedMicrotasks;

    return copyWith(
      completedMicrotasks: newCompleted,
      updatedAt: DateTime.now(),
    );
  }

  /// Decrementa o contador de microtasks concluídas
  TaskModel decrementCompletedMicrotasks() {
    final newCompleted = completedMicrotasks > 0 ? completedMicrotasks - 1 : 0;

    return copyWith(
      completedMicrotasks: newCompleted,
      updatedAt: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskModel &&
        other.id == id &&
        other.eventId == eventId &&
        other.title == title &&
        other.description == description &&
        other.priority == priority &&
        other.status == status &&
        other.createdBy == createdBy &&
        other.microtaskCount == microtaskCount &&
        other.completedMicrotasks == completedMicrotasks;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      eventId,
      title,
      description,
      priority,
      status,
      createdBy,
      microtaskCount,
      completedMicrotasks,
    );
  }

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, status: $status, progress: ${(progress * 100).toStringAsFixed(1)}%)';
  }
}
