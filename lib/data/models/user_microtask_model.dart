import 'package:cloud_firestore/cloud_firestore.dart';

/// Enums para status individual do usuário na microtask
enum UserMicrotaskStatus {
  assigned('assigned'),
  inProgress('in_progress'),
  completed('completed'),
  cancelled('cancelled');

  const UserMicrotaskStatus(this.value);
  final String value;

  static UserMicrotaskStatus fromString(String value) {
    return UserMicrotaskStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => UserMicrotaskStatus.assigned,
    );
  }

  @override
  String toString() => value;
}

/// Modelo de dados para representar a relação entre um usuário e uma microtask
/// Controla o status individual de cada voluntário em uma microtask
/// Baseado na estrutura definida no SPEC_GERAL.md
class UserMicrotaskModel {
  final String id;
  final String userId;
  final String microtaskId;
  final String eventId;
  final UserMicrotaskStatus status;
  final DateTime assignedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final double? actualHours;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserMicrotaskModel({
    required this.id,
    required this.userId,
    required this.microtaskId,
    required this.eventId,
    required this.status,
    required this.assignedAt,
    this.startedAt,
    this.completedAt,
    this.actualHours,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Cria uma instância de UserMicrotaskModel a partir de um Map (JSON)
  factory UserMicrotaskModel.fromMap(Map<String, dynamic> map) {
    return UserMicrotaskModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      microtaskId: map['microtaskId'] as String,
      eventId: map['eventId'] as String,
      status: UserMicrotaskStatus.fromString(map['status'] as String),
      assignedAt: (map['assignedAt'] as Timestamp).toDate(),
      startedAt: map['startedAt'] != null
          ? (map['startedAt'] as Timestamp).toDate()
          : null,
      completedAt: map['completedAt'] != null
          ? (map['completedAt'] as Timestamp).toDate()
          : null,
      actualHours: (map['actualHours'] as num?)?.toDouble(),
      notes: map['notes'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Cria uma instância de UserMicrotaskModel a partir de um DocumentSnapshot do Firestore
  factory UserMicrotaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserMicrotaskModel.fromMap({'id': doc.id, ...data});
  }

  /// Converte a instância para um Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'microtaskId': microtaskId,
      'eventId': eventId,
      'status': status.value,
      'assignedAt': Timestamp.fromDate(assignedAt),
      'startedAt': startedAt != null ? Timestamp.fromDate(startedAt!) : null,
      'completedAt': completedAt != null
          ? Timestamp.fromDate(completedAt!)
          : null,
      'actualHours': actualHours,
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
  UserMicrotaskModel copyWith({
    String? id,
    String? userId,
    String? microtaskId,
    String? eventId,
    UserMicrotaskStatus? status,
    DateTime? assignedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    double? actualHours,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserMicrotaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      microtaskId: microtaskId ?? this.microtaskId,
      eventId: eventId ?? this.eventId,
      status: status ?? this.status,
      assignedAt: assignedAt ?? this.assignedAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      actualHours: actualHours ?? this.actualHours,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Cria uma nova instância com updatedAt atualizado para agora
  UserMicrotaskModel withUpdatedTimestamp() {
    return copyWith(updatedAt: DateTime.now());
  }

  /// Factory para criar uma nova relação usuário-microtask
  /// Note: ID e timestamps devem ser definidos pelo service
  factory UserMicrotaskModel.create({
    required String id,
    required String userId,
    required String microtaskId,
    required String eventId,
    required DateTime assignedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    return UserMicrotaskModel(
      id: id,
      userId: userId,
      microtaskId: microtaskId,
      eventId: eventId,
      status: UserMicrotaskStatus.assigned,
      assignedAt: assignedAt,
      notes: '',
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Valida se os dados da relação são válidos
  List<String> validate() {
    final errors = <String>[];

    if (userId.isEmpty) {
      errors.add('ID do usuário é obrigatório');
    }

    if (microtaskId.isEmpty) {
      errors.add('ID da microtask é obrigatório');
    }

    if (eventId.isEmpty) {
      errors.add('ID da campanha é obrigatório');
    }

    if (actualHours != null && actualHours! < 0) {
      errors.add('Horas trabalhadas não podem ser negativas');
    }

    if (startedAt != null && startedAt!.isBefore(assignedAt)) {
      errors.add('Data de início não pode ser anterior à data de atribuição');
    }

    if (completedAt != null &&
        startedAt != null &&
        completedAt!.isBefore(startedAt!)) {
      errors.add('Data de conclusão não pode ser anterior à data de início');
    }

    return errors;
  }

  /// Verifica se a relação é válida
  bool isValid() => validate().isEmpty;

  /// Verifica se o usuário completou a microtask
  bool get isCompleted => status == UserMicrotaskStatus.completed;

  /// Verifica se o usuário iniciou a microtask
  bool get isStarted => status == UserMicrotaskStatus.inProgress;

  /// Verifica se o usuário foi apenas atribuído (não iniciou)
  bool get isAssigned => status == UserMicrotaskStatus.assigned;

  /// Verifica se foi cancelado
  bool get isCancelled => status == UserMicrotaskStatus.cancelled;

  /// Marca como iniciado
  UserMicrotaskModel markAsStarted() {
    if (status == UserMicrotaskStatus.assigned ||
        status == UserMicrotaskStatus.completed) {
      final now = DateTime.now();
      return copyWith(
        status: UserMicrotaskStatus.inProgress,
        startedAt:
            startedAt ?? now, // Mantém a data original de início se já existir
        updatedAt: now,
      );
    }
    return this;
  }

  /// Marca como atribuído (regressão de Em Andamento para Atribuída)
  UserMicrotaskModel markAsAssigned() {
    if (status == UserMicrotaskStatus.inProgress) {
      final now = DateTime.now();
      return copyWith(
        status: UserMicrotaskStatus.assigned,
        startedAt: null, // Remove a data de início
        updatedAt: now,
      );
    }
    return this;
  }

  /// Marca como concluído
  UserMicrotaskModel markAsCompleted({double? actualHours}) {
    if (status == UserMicrotaskStatus.inProgress ||
        status == UserMicrotaskStatus.assigned) {
      final now = DateTime.now();
      return copyWith(
        status: UserMicrotaskStatus.completed,
        completedAt: now,
        actualHours: actualHours ?? this.actualHours,
        updatedAt: now,
      );
    }
    return this;
  }

  /// Marca como cancelado
  UserMicrotaskModel markAsCancelled() {
    final now = DateTime.now();
    return copyWith(status: UserMicrotaskStatus.cancelled, updatedAt: now);
  }

  /// Atualiza as notas
  UserMicrotaskModel updateNotes(String newNotes) {
    return copyWith(notes: newNotes, updatedAt: DateTime.now());
  }

  /// Atualiza as horas trabalhadas
  UserMicrotaskModel updateActualHours(double hours) {
    return copyWith(
      actualHours: hours >= 0 ? hours : 0,
      updatedAt: DateTime.now(),
    );
  }

  /// Calcula a duração do trabalho (se iniciado e concluído)
  Duration? get workDuration {
    if (startedAt != null && completedAt != null) {
      return completedAt!.difference(startedAt!);
    }
    return null;
  }

  /// Calcula a duração desde a atribuição até agora (se não concluído)
  Duration get durationSinceAssigned {
    final endTime = completedAt ?? DateTime.now();
    return endTime.difference(assignedAt);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserMicrotaskModel &&
        other.id == id &&
        other.userId == userId &&
        other.microtaskId == microtaskId &&
        other.eventId == eventId &&
        other.status == status;
  }

  @override
  int get hashCode {
    return Object.hash(id, userId, microtaskId, eventId, status);
  }

  @override
  String toString() {
    return 'UserMicrotaskModel(id: $id, userId: $userId, microtaskId: $microtaskId, status: $status)';
  }
}
