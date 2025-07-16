import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de dados para representar um evento no sistema
/// Baseado na estrutura definida no SPEC_GERAL.md
class EventModel {
  final String id;
  final String name;
  final String description;
  final String tag;
  final String location;
  final String createdBy;
  final List<String> managers;
  final List<String> volunteers;
  final List<String> requiredSkills;
  final List<String> requiredResources;
  final EventStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EventModel({
    required this.id,
    required this.name,
    required this.description,
    required this.tag,
    required this.location,
    required this.createdBy,
    required this.managers,
    required this.volunteers,
    required this.requiredSkills,
    required this.requiredResources,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Cria uma instância de EventModel a partir de um Map (JSON)
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      tag: map['tag'] as String,
      location: map['location'] as String,
      createdBy: map['createdBy'] as String,
      managers: List<String>.from(map['managers'] as List),
      volunteers: List<String>.from(map['volunteers'] as List),
      requiredSkills: List<String>.from(map['requiredSkills'] as List),
      requiredResources: List<String>.from(map['requiredResources'] as List),
      status: EventStatus.fromString(map['status'] as String),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Cria uma instância de EventModel a partir de um DocumentSnapshot do Firestore
  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel.fromMap({'id': doc.id, ...data});
  }

  /// Converte a instância para um Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tag': tag,
      'location': location,
      'createdBy': createdBy,
      'managers': managers,
      'volunteers': volunteers,
      'requiredSkills': requiredSkills,
      'requiredResources': requiredResources,
      'status': status.value,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Converte para Map sem o ID (usado para criar documentos no Firestore)
  Map<String, dynamic> toFirestore() {
    final map = toMap();
    map.remove('id'); // Remove o ID pois será gerado pelo Firestore
    return map;
  }

  /// Cria uma cópia da instância com alguns campos alterados
  EventModel copyWith({
    String? id,
    String? name,
    String? description,
    String? tag,
    String? location,
    String? createdBy,
    List<String>? managers,
    List<String>? volunteers,
    List<String>? requiredSkills,
    List<String>? requiredResources,
    EventStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      tag: tag ?? this.tag,
      location: location ?? this.location,
      createdBy: createdBy ?? this.createdBy,
      managers: managers ?? List<String>.from(this.managers),
      volunteers: volunteers ?? List<String>.from(this.volunteers),
      requiredSkills: requiredSkills ?? List<String>.from(this.requiredSkills),
      requiredResources:
          requiredResources ?? List<String>.from(this.requiredResources),
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Cria uma nova instância com updatedAt atualizado para agora
  EventModel withUpdatedTimestamp() {
    return copyWith(updatedAt: DateTime.now());
  }

  /// Verifica se o usuário é gerenciador do evento
  bool isManager(String userId) {
    return managers.contains(userId);
  }

  /// Verifica se o usuário é voluntário do evento
  bool isVolunteer(String userId) {
    return volunteers.contains(userId);
  }

  /// Verifica se o usuário é participante (gerenciador ou voluntário)
  bool isParticipant(String userId) {
    return isManager(userId) || isVolunteer(userId);
  }

  /// Verifica se o usuário é o criador do evento
  bool isCreator(String userId) {
    return createdBy == userId;
  }

  /// Adiciona um voluntário ao evento
  EventModel addVolunteer(String userId) {
    if (volunteers.contains(userId)) return this;

    final newVolunteers = List<String>.from(volunteers)..add(userId);
    return copyWith(volunteers: newVolunteers).withUpdatedTimestamp();
  }

  /// Remove um voluntário do evento
  EventModel removeVolunteer(String userId) {
    if (!volunteers.contains(userId)) return this;

    final newVolunteers = List<String>.from(volunteers)..remove(userId);
    return copyWith(volunteers: newVolunteers).withUpdatedTimestamp();
  }

  /// Promove um voluntário a gerenciador
  EventModel promoteToManager(String userId) {
    if (managers.contains(userId)) return this;

    final newManagers = List<String>.from(managers)..add(userId);
    final newVolunteers = List<String>.from(volunteers)..remove(userId);

    return copyWith(
      managers: newManagers,
      volunteers: newVolunteers,
    ).withUpdatedTimestamp();
  }

  /// Remove um gerenciador (não pode remover o criador)
  EventModel removeManager(String userId) {
    if (userId == createdBy || !managers.contains(userId)) return this;

    final newManagers = List<String>.from(managers)..remove(userId);
    return copyWith(managers: newManagers).withUpdatedTimestamp();
  }

  /// Retorna o número total de participantes
  int get totalParticipants => managers.length + volunteers.length;

  /// Retorna o papel do usuário no evento
  UserRole getUserRole(String userId) {
    if (createdBy == userId) return UserRole.creator;
    if (managers.contains(userId)) return UserRole.manager;
    if (volunteers.contains(userId)) return UserRole.volunteer;
    return UserRole.none;
  }

  /// Valida se os dados do evento são válidos
  bool isValid() {
    return id.isNotEmpty &&
        name.isNotEmpty &&
        tag.isNotEmpty &&
        location.isNotEmpty &&
        createdBy.isNotEmpty &&
        managers.isNotEmpty &&
        managers.contains(createdBy);
  }

  /// Factory para criar um novo evento
  /// Note: ID, tag e timestamps devem ser definidos pelo service
  factory EventModel.create({
    required String id,
    required String name,
    required String description,
    required String tag,
    required String location,
    required String createdBy,
    required List<String> requiredSkills,
    required List<String> requiredResources,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    return EventModel(
      id: id,
      name: name,
      description: description,
      tag: tag,
      location: location,
      createdBy: createdBy,
      managers: [createdBy], // Criador é automaticamente gerenciador
      volunteers: [],
      requiredSkills: requiredSkills,
      requiredResources: requiredResources,
      status: EventStatus.active,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Converte para string para debug
  @override
  String toString() {
    return 'EventModel(id: $id, name: $name, tag: $tag, status: ${status.value}, participants: $totalParticipants)';
  }

  /// Implementa igualdade baseada no ID
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventModel && other.id == id;
  }

  /// Implementa hashCode baseado no ID
  @override
  int get hashCode => id.hashCode;

  /// Método para validar dados antes de salvar
  List<String> validate() {
    final errors = <String>[];

    if (id.isEmpty) {
      errors.add('ID é obrigatório');
    }

    if (name.isEmpty) {
      errors.add('Nome é obrigatório');
    } else if (name.length < 3) {
      errors.add('Nome deve ter pelo menos 3 caracteres');
    } else if (name.length > 100) {
      errors.add('Nome deve ter no máximo 100 caracteres');
    }

    if (description.length > 500) {
      errors.add('Descrição deve ter no máximo 500 caracteres');
    }

    if (tag.isEmpty) {
      errors.add('Tag é obrigatória');
    } else if (tag.length != 6) {
      errors.add('Tag deve ter exatamente 6 caracteres');
    }

    if (location.isEmpty) {
      errors.add('Localização é obrigatória');
    } else if (location.length > 200) {
      errors.add('Localização deve ter no máximo 200 caracteres');
    }

    if (createdBy.isEmpty) {
      errors.add('Criador é obrigatório');
    }

    if (managers.isEmpty) {
      errors.add('Deve haver pelo menos um gerenciador');
    }

    if (!managers.contains(createdBy)) {
      errors.add('Criador deve ser um gerenciador');
    }

    return errors;
  }

  /// Retorna há quanto tempo o evento foi criado
  String get createdTimeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} dia${difference.inDays > 1 ? 's' : ''} atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''} atrás';
    } else {
      return 'Agora mesmo';
    }
  }

  /// Retorna há quanto tempo o evento foi atualizado
  String get updatedTimeAgo {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} dia${difference.inDays > 1 ? 's' : ''} atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''} atrás';
    } else {
      return 'Agora mesmo';
    }
  }

  /// Verifica se o evento foi criado recentemente (últimas 24 horas)
  bool get isNewEvent {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inHours < 24;
  }

  /// Retorna uma versão resumida da descrição
  String get shortDescription {
    if (description.length <= 100) return description;
    return '${description.substring(0, 97)}...';
  }

  /// Retorna as habilidades como string formatada
  String get skillsText {
    if (requiredSkills.isEmpty) return 'Nenhuma habilidade específica';
    return requiredSkills.join(', ');
  }

  /// Retorna os recursos como string formatada
  String get resourcesText {
    if (requiredResources.isEmpty) return 'Nenhum recurso específico';
    return requiredResources.join(', ');
  }

  /// Atualiza o status do evento
  EventModel updateStatus(EventStatus newStatus) {
    return copyWith(status: newStatus).withUpdatedTimestamp();
  }

  /// Adiciona uma habilidade necessária
  EventModel addRequiredSkill(String skill) {
    if (requiredSkills.contains(skill)) return this;

    final newSkills = List<String>.from(requiredSkills)..add(skill);
    return copyWith(requiredSkills: newSkills).withUpdatedTimestamp();
  }

  /// Remove uma habilidade necessária
  EventModel removeRequiredSkill(String skill) {
    if (!requiredSkills.contains(skill)) return this;

    final newSkills = List<String>.from(requiredSkills)..remove(skill);
    return copyWith(requiredSkills: newSkills).withUpdatedTimestamp();
  }

  /// Adiciona um recurso necessário
  EventModel addRequiredResource(String resource) {
    if (requiredResources.contains(resource)) return this;

    final newResources = List<String>.from(requiredResources)..add(resource);
    return copyWith(requiredResources: newResources).withUpdatedTimestamp();
  }

  /// Remove um recurso necessário
  EventModel removeRequiredResource(String resource) {
    if (!requiredResources.contains(resource)) return this;

    final newResources = List<String>.from(requiredResources)..remove(resource);
    return copyWith(requiredResources: newResources).withUpdatedTimestamp();
  }
}

/// Enum para representar o status do evento
enum EventStatus {
  active('active'),
  completed('completed'),
  cancelled('cancelled');

  const EventStatus(this.value);
  final String value;

  static EventStatus fromString(String value) {
    return EventStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => EventStatus.active,
    );
  }

  String get displayName {
    switch (this) {
      case EventStatus.active:
        return 'Ativo';
      case EventStatus.completed:
        return 'Concluído';
      case EventStatus.cancelled:
        return 'Cancelado';
    }
  }
}

/// Enum para representar o papel do usuário no evento
enum UserRole {
  creator('creator'),
  manager('manager'),
  volunteer('volunteer'),
  none('none');

  const UserRole(this.value);
  final String value;

  String get displayName {
    switch (this) {
      case UserRole.creator:
        return 'Criador';
      case UserRole.manager:
        return 'Gerenciador';
      case UserRole.volunteer:
        return 'Voluntário';
      case UserRole.none:
        return 'Não participante';
    }
  }
}
