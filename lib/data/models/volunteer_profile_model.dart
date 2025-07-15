import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de dados para representar o perfil de um voluntário em um evento
/// Baseado na estrutura definida no SPEC_GERAL.md
class VolunteerProfileModel {
  final String id;
  final String userId;
  final String eventId;
  final List<String> availableDays;
  final TimeRange availableHours;
  final bool
  isFullTimeAvailable; // Disponibilidade integral (sem restrições de data/hora)
  final List<String> skills;
  final List<String> resources;
  final DateTime joinedAt;

  const VolunteerProfileModel({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.availableDays,
    required this.availableHours,
    required this.isFullTimeAvailable,
    required this.skills,
    required this.resources,
    required this.joinedAt,
  });

  /// Cria uma instância de VolunteerProfileModel a partir de um Map (JSON)
  factory VolunteerProfileModel.fromMap(Map<String, dynamic> map) {
    return VolunteerProfileModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      eventId: map['eventId'] as String,
      availableDays: List<String>.from(map['availableDays'] as List),
      availableHours: TimeRange.fromMap(
        map['availableHours'] as Map<String, dynamic>,
      ),
      isFullTimeAvailable: map['isFullTimeAvailable'] as bool? ?? false,
      skills: List<String>.from(map['skills'] as List),
      resources: List<String>.from(map['resources'] as List),
      joinedAt: (map['joinedAt'] as Timestamp).toDate(),
    );
  }

  /// Cria uma instância de VolunteerProfileModel a partir de um DocumentSnapshot do Firestore
  factory VolunteerProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VolunteerProfileModel.fromMap({'id': doc.id, ...data});
  }

  /// Converte a instância para um Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'eventId': eventId,
      'availableDays': availableDays,
      'availableHours': availableHours.toMap(),
      'isFullTimeAvailable': isFullTimeAvailable,
      'skills': skills,
      'resources': resources,
      'joinedAt': Timestamp.fromDate(joinedAt),
    };
  }

  /// Converte para Map sem o ID (usado para criar documentos no Firestore)
  Map<String, dynamic> toFirestore() {
    final map = toMap();
    map.remove('id'); // Remove o ID pois será gerado pelo Firestore
    return map;
  }

  /// Cria uma cópia da instância com alguns campos alterados
  VolunteerProfileModel copyWith({
    String? id,
    String? userId,
    String? eventId,
    List<String>? availableDays,
    TimeRange? availableHours,
    bool? isFullTimeAvailable,
    List<String>? skills,
    List<String>? resources,
    DateTime? joinedAt,
  }) {
    return VolunteerProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      eventId: eventId ?? this.eventId,
      availableDays: availableDays ?? List<String>.from(this.availableDays),
      availableHours: availableHours ?? this.availableHours,
      isFullTimeAvailable: isFullTimeAvailable ?? this.isFullTimeAvailable,
      skills: skills ?? List<String>.from(this.skills),
      resources: resources ?? List<String>.from(this.resources),
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  /// Verifica se o voluntário tem uma habilidade específica
  bool hasSkill(String skill) {
    return skills.contains(skill);
  }

  /// Verifica se o voluntário tem um recurso específico
  bool hasResource(String resource) {
    return resources.contains(resource);
  }

  /// Verifica se o voluntário está disponível em um dia específico
  bool isAvailableOnDay(String day) {
    return availableDays.contains(day);
  }

  /// Verifica se o voluntário está disponível em um horário específico
  bool isAvailableAtTime(String time) {
    return availableHours.contains(time);
  }

  /// Adiciona uma habilidade ao perfil
  VolunteerProfileModel addSkill(String skill) {
    if (skills.contains(skill)) return this;

    final newSkills = List<String>.from(skills)..add(skill);
    return copyWith(skills: newSkills);
  }

  /// Remove uma habilidade do perfil
  VolunteerProfileModel removeSkill(String skill) {
    if (!skills.contains(skill)) return this;

    final newSkills = List<String>.from(skills)..remove(skill);
    return copyWith(skills: newSkills);
  }

  /// Adiciona um recurso ao perfil
  VolunteerProfileModel addResource(String resource) {
    if (resources.contains(resource)) return this;

    final newResources = List<String>.from(resources)..add(resource);
    return copyWith(resources: newResources);
  }

  /// Remove um recurso do perfil
  VolunteerProfileModel removeResource(String resource) {
    if (!resources.contains(resource)) return this;

    final newResources = List<String>.from(resources)..remove(resource);
    return copyWith(resources: newResources);
  }

  /// Adiciona um dia de disponibilidade
  VolunteerProfileModel addAvailableDay(String day) {
    if (availableDays.contains(day)) return this;

    final newDays = List<String>.from(availableDays)..add(day);
    return copyWith(availableDays: newDays);
  }

  /// Remove um dia de disponibilidade
  VolunteerProfileModel removeAvailableDay(String day) {
    if (!availableDays.contains(day)) return this;

    final newDays = List<String>.from(availableDays)..remove(day);
    return copyWith(availableDays: newDays);
  }

  /// Atualiza o horário de disponibilidade
  VolunteerProfileModel updateAvailableHours(TimeRange newHours) {
    return copyWith(availableHours: newHours);
  }

  /// Verifica compatibilidade com habilidades necessárias
  bool isCompatibleWithSkills(List<String> requiredSkills) {
    if (requiredSkills.isEmpty) return true;
    return requiredSkills.any((skill) => skills.contains(skill));
  }

  /// Verifica compatibilidade com recursos necessários
  bool isCompatibleWithResources(List<String> requiredResources) {
    if (requiredResources.isEmpty) return true;
    return requiredResources.any((resource) => resources.contains(resource));
  }

  /// Verifica compatibilidade geral (habilidades E recursos)
  bool isCompatibleWith({
    List<String>? requiredSkills,
    List<String>? requiredResources,
  }) {
    final skillsMatch =
        requiredSkills == null ||
        requiredSkills.isEmpty ||
        isCompatibleWithSkills(requiredSkills);

    final resourcesMatch =
        requiredResources == null ||
        requiredResources.isEmpty ||
        isCompatibleWithResources(requiredResources);

    return skillsMatch && resourcesMatch;
  }

  /// Retorna as habilidades como string formatada
  String get skillsText {
    if (skills.isEmpty) return 'Nenhuma habilidade informada';
    return skills.join(', ');
  }

  /// Retorna os recursos como string formatada
  String get resourcesText {
    if (resources.isEmpty) return 'Nenhum recurso informado';
    return resources.join(', ');
  }

  /// Retorna os dias disponíveis como string formatada
  String get availableDaysText {
    if (availableDays.isEmpty) return 'Nenhum dia informado';

    final dayNames = {
      'monday': 'Segunda',
      'tuesday': 'Terça',
      'wednesday': 'Quarta',
      'thursday': 'Quinta',
      'friday': 'Sexta',
      'saturday': 'Sábado',
      'sunday': 'Domingo',
    };

    final translatedDays = availableDays
        .map((day) => dayNames[day] ?? day)
        .toList();

    return translatedDays.join(', ');
  }

  /// Retorna há quanto tempo o voluntário se juntou ao evento
  String get joinedTimeAgo {
    final now = DateTime.now();
    final difference = now.difference(joinedAt);

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

  /// Factory para criar um novo perfil de voluntário
  factory VolunteerProfileModel.create({
    required String userId,
    required String eventId,
    required List<String> availableDays,
    required TimeRange availableHours,
    bool isFullTimeAvailable = false,
    required List<String> skills,
    required List<String> resources,
  }) {
    return VolunteerProfileModel(
      id: '', // Será definido pelo Firestore
      userId: userId,
      eventId: eventId,
      availableDays: availableDays,
      availableHours: availableHours,
      isFullTimeAvailable: isFullTimeAvailable,
      skills: skills,
      resources: resources,
      joinedAt: DateTime.now(),
    );
  }

  /// Valida se os dados do perfil são válidos
  bool isValid() {
    return id.isNotEmpty &&
        userId.isNotEmpty &&
        eventId.isNotEmpty &&
        (isFullTimeAvailable ||
            (availableDays.isNotEmpty && availableHours.isValid()));
  }

  /// Método para validar dados antes de salvar
  List<String> validate() {
    final errors = <String>[];

    if (userId.isEmpty) {
      errors.add('ID do usuário é obrigatório');
    }

    if (eventId.isEmpty) {
      errors.add('ID do evento é obrigatório');
    }

    if (!isFullTimeAvailable) {
      if (availableDays.isEmpty) {
        errors.add('Pelo menos um dia de disponibilidade é obrigatório');
      }

      if (!availableHours.isValid()) {
        errors.add('Horário de disponibilidade inválido');
      }
    }

    return errors;
  }

  /// Retorna a disponibilidade como string formatada
  String get availabilityText {
    if (isFullTimeAvailable) {
      return 'Disponibilidade integral (qualquer horário)';
    }

    if (availableDays.isEmpty) return 'Disponibilidade não informada';

    return '$availableDaysText - ${availableHours.formatted}';
  }

  /// Verifica se o voluntário está disponível em um horário específico
  bool isAvailableAt(DateTime dateTime) {
    if (isFullTimeAvailable) return true;

    // Verifica o dia da semana
    final dayNames = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    final dayOfWeek = dayNames[dateTime.weekday - 1];

    if (!availableDays.contains(dayOfWeek)) return false;

    // Verifica o horário
    final timeString =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return availableHours.contains(timeString);
  }

  /// Verifica se o voluntário está disponível em um período
  bool isAvailableForPeriod(DateTime startDateTime, DateTime endDateTime) {
    if (isFullTimeAvailable) return true;

    // Para simplicidade, verifica apenas o horário de início
    // Em uma implementação mais robusta, verificaria todo o período
    return isAvailableAt(startDateTime);
  }

  /// Converte para string para debug
  @override
  String toString() {
    return 'VolunteerProfileModel(id: $id, userId: $userId, eventId: $eventId, skills: ${skills.length}, resources: ${resources.length})';
  }

  /// Implementa igualdade baseada no ID
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VolunteerProfileModel && other.id == id;
  }

  /// Implementa hashCode baseado no ID
  @override
  int get hashCode => id.hashCode;
}

/// Classe para representar um intervalo de tempo
class TimeRange {
  final String start;
  final String end;

  const TimeRange({required this.start, required this.end});

  /// Cria uma instância de TimeRange a partir de um Map
  factory TimeRange.fromMap(Map<String, dynamic> map) {
    return TimeRange(start: map['start'] as String, end: map['end'] as String);
  }

  /// Converte a instância para um Map
  Map<String, dynamic> toMap() {
    return {'start': start, 'end': end};
  }

  /// Verifica se um horário está dentro do intervalo
  bool contains(String time) {
    // Implementação simplificada - pode ser melhorada
    return time.compareTo(start) >= 0 && time.compareTo(end) <= 0;
  }

  /// Verifica se o intervalo é válido
  bool isValid() {
    return start.isNotEmpty && end.isNotEmpty && start.compareTo(end) < 0;
  }

  /// Retorna o intervalo formatado
  String get formatted => '$start - $end';

  @override
  String toString() => formatted;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}
