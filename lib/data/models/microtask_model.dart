import 'package:cloud_firestore/cloud_firestore.dart';

/// Enums para status das microtasks
enum MicrotaskStatus {
  pending('pending'),
  assigned('assigned'),
  inProgress('in_progress'),
  completed('completed'),
  cancelled('cancelled');

  const MicrotaskStatus(this.value);
  final String value;

  static MicrotaskStatus fromString(String value) {
    return MicrotaskStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => MicrotaskStatus.pending,
    );
  }

  @override
  String toString() => value;
}

/// Modelo de dados para representar uma microtask no sistema
/// Microtasks são as unidades de trabalho que podem ter múltiplos voluntários
/// Baseado na estrutura definida no SPEC_GERAL.md
class MicrotaskModel {
  final String id;
  final String taskId;
  final String eventId;
  final String title;
  final String description;
  final List<String> assignedTo;
  final int maxVolunteers;
  final List<String> requiredSkills;
  final List<String> requiredResources;
  final double estimatedHours;
  final String priority; // Usa string para compatibilidade com TaskPriority
  final MicrotaskStatus status;
  final String createdBy;
  final DateTime? assignedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MicrotaskModel({
    required this.id,
    required this.taskId,
    required this.eventId,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.maxVolunteers,
    required this.requiredSkills,
    required this.requiredResources,
    required this.estimatedHours,
    required this.priority,
    required this.status,
    required this.createdBy,
    this.assignedAt,
    this.startedAt,
    this.completedAt,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Cria uma instância de MicrotaskModel a partir de um Map (JSON)
  factory MicrotaskModel.fromMap(Map<String, dynamic> map) {
    return MicrotaskModel(
      id: map['id'] as String,
      taskId: map['taskId'] as String,
      eventId: map['eventId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      assignedTo: List<String>.from(map['assignedTo'] as List? ?? []),
      maxVolunteers: map['maxVolunteers'] as int? ?? 1,
      requiredSkills: List<String>.from(map['requiredSkills'] as List? ?? []),
      requiredResources: List<String>.from(
        map['requiredResources'] as List? ?? [],
      ),
      estimatedHours: (map['estimatedHours'] as num?)?.toDouble() ?? 0.0,
      priority: map['priority'] as String? ?? 'medium',
      status: MicrotaskStatus.fromString(map['status'] as String? ?? 'pending'),
      createdBy: map['createdBy'] as String,
      assignedAt: map['assignedAt'] != null
          ? (map['assignedAt'] as Timestamp).toDate()
          : null,
      startedAt: map['startedAt'] != null
          ? (map['startedAt'] as Timestamp).toDate()
          : null,
      completedAt: map['completedAt'] != null
          ? (map['completedAt'] as Timestamp).toDate()
          : null,
      notes: map['notes'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Cria uma instância de MicrotaskModel a partir de um DocumentSnapshot do Firestore
  factory MicrotaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MicrotaskModel.fromMap({'id': doc.id, ...data});
  }

  /// Converte a instância para um Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'eventId': eventId,
      'title': title,
      'description': description,
      'assignedTo': assignedTo,
      'maxVolunteers': maxVolunteers,
      'requiredSkills': requiredSkills,
      'requiredResources': requiredResources,
      'estimatedHours': estimatedHours,
      'priority': priority,
      'status': status.value,
      'createdBy': createdBy,
      'assignedAt': assignedAt != null ? Timestamp.fromDate(assignedAt!) : null,
      'startedAt': startedAt != null ? Timestamp.fromDate(startedAt!) : null,
      'completedAt': completedAt != null
          ? Timestamp.fromDate(completedAt!)
          : null,
      'notes': notes,
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
  MicrotaskModel copyWith({
    String? id,
    String? taskId,
    String? eventId,
    String? title,
    String? description,
    List<String>? assignedTo,
    int? maxVolunteers,
    List<String>? requiredSkills,
    List<String>? requiredResources,
    double? estimatedHours,
    String? priority,
    MicrotaskStatus? status,
    String? createdBy,
    DateTime? assignedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MicrotaskModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      eventId: eventId ?? this.eventId,
      title: title ?? this.title,
      description: description ?? this.description,
      assignedTo: assignedTo ?? List<String>.from(this.assignedTo),
      maxVolunteers: maxVolunteers ?? this.maxVolunteers,
      requiredSkills: requiredSkills ?? List<String>.from(this.requiredSkills),
      requiredResources:
          requiredResources ?? List<String>.from(this.requiredResources),
      estimatedHours: estimatedHours ?? this.estimatedHours,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      assignedAt: assignedAt ?? this.assignedAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Cria uma nova instância com updatedAt atualizado para agora
  MicrotaskModel withUpdatedTimestamp() {
    return copyWith(updatedAt: DateTime.now());
  }

  /// Factory para criar uma nova microtask
  factory MicrotaskModel.create({
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
  }) {
    final now = DateTime.now();

    return MicrotaskModel(
      id: '', // Será definido pelo Firestore
      taskId: taskId,
      eventId: eventId,
      title: title,
      description: description,
      assignedTo: [],
      maxVolunteers: maxVolunteers > 0 ? maxVolunteers : 1,
      requiredSkills: requiredSkills,
      requiredResources: requiredResources,
      estimatedHours: estimatedHours,
      priority: priority,
      status: MicrotaskStatus.pending,
      createdBy: createdBy,
      notes: notes ?? '',
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Valida se os dados da microtask são válidos
  List<String> validate() {
    final errors = <String>[];

    if (taskId.isEmpty) {
      errors.add('ID da task pai é obrigatório');
    }

    if (eventId.isEmpty) {
      errors.add('ID do evento é obrigatório');
    }

    if (title.isEmpty) {
      errors.add('Título da microtask é obrigatório');
    } else if (title.length < 3) {
      errors.add('Título deve ter pelo menos 3 caracteres');
    } else if (title.length > 100) {
      errors.add('Título deve ter no máximo 100 caracteres');
    }

    if (description.isEmpty) {
      errors.add('Descrição da microtask é obrigatória');
    } else if (description.length > 1000) {
      errors.add('Descrição deve ter no máximo 1000 caracteres');
    }

    if (maxVolunteers <= 0) {
      errors.add('Número máximo de voluntários deve ser maior que zero');
    }

    if (assignedTo.length > maxVolunteers) {
      errors.add('Número de voluntários atribuídos excede o máximo permitido');
    }

    if (estimatedHours < 0) {
      errors.add('Horas estimadas não podem ser negativas');
    }

    if (createdBy.isEmpty) {
      errors.add('Criador da microtask é obrigatório');
    }

    return errors;
  }

  /// Verifica se a microtask é válida
  bool isValid() => validate().isEmpty;

  /// Verifica se há vagas disponíveis para voluntários
  bool get hasAvailableSlots => assignedTo.length < maxVolunteers;

  /// Número de vagas disponíveis
  int get availableSlots => maxVolunteers - assignedTo.length;

  /// Verifica se a microtask está concluída
  bool get isCompleted => status == MicrotaskStatus.completed;

  /// Verifica se a microtask está em progresso
  bool get isInProgress => status == MicrotaskStatus.inProgress;

  /// Verifica se a microtask está pendente
  bool get isPending => status == MicrotaskStatus.pending;

  /// Verifica se a microtask foi cancelada
  bool get isCancelled => status == MicrotaskStatus.cancelled;

  /// Verifica se a microtask tem voluntários atribuídos
  bool get hasAssignedVolunteers => assignedTo.isNotEmpty;

  /// Verifica se um usuário específico está atribuído à microtask
  bool isAssignedTo(String userId) => assignedTo.contains(userId);

  /// Adiciona um voluntário à microtask
  MicrotaskModel assignVolunteer(String userId) {
    if (isAssignedTo(userId)) {
      return this; // Já está atribuído
    }

    if (!hasAvailableSlots) {
      return this; // Não há vagas disponíveis
    }

    final newAssignedTo = List<String>.from(assignedTo)..add(userId);
    final now = DateTime.now();

    return copyWith(
      assignedTo: newAssignedTo,
      status: MicrotaskStatus.assigned,
      assignedAt: assignedAt ?? now,
      updatedAt: now,
    );
  }

  /// Remove um voluntário da microtask
  MicrotaskModel unassignVolunteer(String userId) {
    if (!isAssignedTo(userId)) {
      return this; // Não está atribuído
    }

    final newAssignedTo = List<String>.from(assignedTo)..remove(userId);
    final now = DateTime.now();

    // Atualiza o status baseado no número de voluntários restantes
    MicrotaskStatus newStatus;
    if (newAssignedTo.isEmpty) {
      newStatus = MicrotaskStatus.pending;
    } else {
      newStatus = status; // Mantém o status atual se ainda há voluntários
    }

    return copyWith(
      assignedTo: newAssignedTo,
      status: newStatus,
      updatedAt: now,
    );
  }

  /// Marca a microtask como iniciada
  MicrotaskModel markAsStarted() {
    if (status == MicrotaskStatus.pending ||
        status == MicrotaskStatus.assigned) {
      final now = DateTime.now();
      return copyWith(
        status: MicrotaskStatus.inProgress,
        startedAt: startedAt ?? now,
        updatedAt: now,
      );
    }
    return this;
  }

  /// Marca a microtask como concluída
  MicrotaskModel markAsCompleted() {
    final now = DateTime.now();
    return copyWith(
      status: MicrotaskStatus.completed,
      completedAt: completedAt ?? now,
      updatedAt: now,
    );
  }

  /// Marca a microtask como cancelada
  MicrotaskModel markAsCancelled() {
    final now = DateTime.now();
    return copyWith(status: MicrotaskStatus.cancelled, updatedAt: now);
  }

  /// Atualiza as notas da microtask
  MicrotaskModel updateNotes(String newNotes) {
    return copyWith(notes: newNotes, updatedAt: DateTime.now());
  }

  /// Verifica se a microtask é compatível com as habilidades de um voluntário
  bool isCompatibleWith(List<String> volunteerSkills) {
    if (requiredSkills.isEmpty) return true;

    return requiredSkills.every((skill) => volunteerSkills.contains(skill));
  }

  /// Calcula a porcentagem de compatibilidade com as habilidades de um voluntário
  double getCompatibilityScore(List<String> volunteerSkills) {
    if (requiredSkills.isEmpty) return 1.0;

    final matchingSkills = requiredSkills
        .where((skill) => volunteerSkills.contains(skill))
        .length;
    return matchingSkills / requiredSkills.length;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MicrotaskModel &&
        other.id == id &&
        other.taskId == taskId &&
        other.eventId == eventId &&
        other.title == title &&
        other.description == description &&
        other.maxVolunteers == maxVolunteers &&
        other.estimatedHours == estimatedHours &&
        other.priority == priority &&
        other.status == status &&
        other.createdBy == createdBy;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      taskId,
      eventId,
      title,
      description,
      maxVolunteers,
      estimatedHours,
      priority,
      status,
      createdBy,
    );
  }

  @override
  String toString() {
    return 'MicrotaskModel(id: $id, title: $title, status: $status, assigned: ${assignedTo.length}/$maxVolunteers)';
  }
}
