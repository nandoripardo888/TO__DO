import 'dart:math';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Importando os models reais do projeto
import 'lib/data/models/user_model.dart';
import 'lib/data/models/event_model.dart';
import 'lib/data/models/volunteer_profile_model.dart';
import 'lib/data/services/user_service.dart';
import 'lib/data/services/event_service.dart';
import 'lib/core/constants/app_constants.dart';

/// Gerador de cenários de teste para o sistema ConTask
/// Cria usuários fictícios e os inscreve em eventos com habilidades aleatórias
class TestScenariosGenerator {
  final UserService _userService = UserService();
  final EventService _eventService = EventService();
  final Random _random = Random();
  final Uuid _uuid = const Uuid();

  // Lista de usuários criados para limpeza posterior
  final List<String> _createdUserIds = [];

  /// Lista de nomes fictícios para os usuários de teste
  static const List<String> _firstNames = [
    'Ana',
    'Bruno',
    'Carlos',
    'Diana',
    'Eduardo',
    'Fernanda',
    'Gabriel',
    'Helena',
    'Igor',
    'Julia',
    'Lucas',
    'Mariana',
    'Nicolas',
    'Olivia',
    'Pedro',
    'Rafaela',
    'Samuel',
    'Tatiana',
    'Victor',
    'Yasmin',
  ];

  static const List<String> _lastNames = [
    'Silva',
    'Santos',
    'Oliveira',
    'Souza',
    'Rodrigues',
    'Ferreira',
    'Alves',
    'Pereira',
    'Lima',
    'Gomes',
    'Costa',
    'Ribeiro',
    'Martins',
    'Carvalho',
    'Almeida',
    'Lopes',
    'Soares',
    'Fernandes',
    'Vieira',
    'Barbosa',
  ];

  /// Gera um nome completo aleatório
  String _generateRandomName() {
    final firstName = _firstNames[_random.nextInt(_firstNames.length)];
    final lastName = _lastNames[_random.nextInt(_lastNames.length)];
    return '$firstName $lastName';
  }

  /// Gera um email fictício baseado no nome
  String _generateEmail(String name) {
    final cleanName = name
        .toLowerCase()
        .replaceAll(' ', '.')
        .replaceAll(RegExp(r'[^a-z.]'), '');
    final domains = ['gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com'];
    final domain = domains[_random.nextInt(domains.length)];
    final randomNumber = _random.nextInt(999) + 1;
    return '$cleanName$randomNumber@$domain';
  }

  /// Seleciona habilidades aleatórias da lista padrão
  List<String> _selectRandomSkills() {
    final availableSkills = List<String>.from(AppConstants.defaultSkills);
    final numSkills = _random.nextInt(5) + 2; // Entre 2 e 6 habilidades
    final selectedSkills = <String>[];

    for (int i = 0; i < numSkills && availableSkills.isNotEmpty; i++) {
      final randomIndex = _random.nextInt(availableSkills.length);
      selectedSkills.add(availableSkills.removeAt(randomIndex));
    }

    return selectedSkills;
  }

  /// Seleciona recursos aleatórios da lista padrão
  List<String> _selectRandomResources() {
    final availableResources = List<String>.from(AppConstants.defaultResources);
    final numResources = _random.nextInt(4) + 1; // Entre 1 e 4 recursos
    final selectedResources = <String>[];

    for (int i = 0; i < numResources && availableResources.isNotEmpty; i++) {
      final randomIndex = _random.nextInt(availableResources.length);
      selectedResources.add(availableResources.removeAt(randomIndex));
    }

    return selectedResources;
  }

  /// Gera dias da semana aleatórios para disponibilidade
  List<String> _generateRandomAvailableDays() {
    final allDays = List<String>.from(AppConstants.weekDays);
    final numDays = _random.nextInt(5) + 2; // Entre 2 e 6 dias
    final selectedDays = <String>[];

    for (int i = 0; i < numDays && allDays.isNotEmpty; i++) {
      final randomIndex = _random.nextInt(allDays.length);
      selectedDays.add(allDays.removeAt(randomIndex));
    }

    return selectedDays;
  }

  /// Gera um horário de disponibilidade aleatório
  TimeRange _generateRandomTimeRange() {
    final startHour = _random.nextInt(12) + 6; // Entre 6h e 17h
    final endHour = startHour + _random.nextInt(8) + 2; // 2 a 9 horas depois
    final finalEndHour = endHour > 22 ? 22 : endHour; // Máximo até 22h

    final start = '${startHour.toString().padLeft(2, '0')}:00';
    final end = '${finalEndHour.toString().padLeft(2, '0')}:00';

    return TimeRange(start: start, end: end);
  }

  /// Cria 10 usuários fictícios usando o UserService
  Future<List<UserModel>> createTestUsers() async {
    print('🚀 Iniciando criação de 10 usuários de teste...');

    final users = <UserModel>[];

    for (int i = 0; i < 10; i++) {
      try {
        final userId = _uuid.v4();
        final name = _generateRandomName();
        final email = _generateEmail(name);
        final now = DateTime.now();

        // Criar usuário usando o model real
        final user = UserModel(
          id: userId,
          name: name,
          email: email,
          photoUrl: null, // Usuários de teste sem foto
          createdAt: now,
          updatedAt: now,
        );

        // Salvar usando o UserService
        await _userService.createOrUpdateUser(user);
        users.add(user);
        _createdUserIds.add(userId);

        print('✅ Usuário criado: ${user.name} (${user.email})');
      } catch (e) {
        print('❌ Erro ao criar usuário ${i + 1}: $e');
      }
    }

    print('🎉 Criação de usuários concluída! Total: ${users.length} usuários');
    return users;
  }

  /// Busca um evento pela tag usando EventService
  Future<EventModel?> getEventByTag(String eventTag) async {
    try {
      print('🔍 Buscando evento com tag: $eventTag');

      // Usar o EventService para buscar eventos
      // Como não há método específico para buscar por tag, vamos usar Firestore diretamente
      // mas mantendo a estrutura do EventModel
      final querySnapshot = await FirebaseFirestore.instance
          .collection(AppConstants.eventsCollection)
          .where('tag', isEqualTo: eventTag.toUpperCase())
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('❌ Evento não encontrado com a tag: $eventTag');
        return null;
      }

      final eventDoc = querySnapshot.docs.first;
      final event = EventModel.fromFirestore(eventDoc);
      print('✅ Evento encontrado: ${event.name}');
      return event;
    } catch (e) {
      print('❌ Erro ao buscar evento: $e');
      return null;
    }
  }

  /// Inscreve os usuários no evento usando EventService
  Future<void> enrollUsersInEvent(
    List<UserModel> users,
    String eventTag,
  ) async {
    print('🎯 Iniciando inscrição dos usuários no evento...');

    final event = await getEventByTag(eventTag);
    if (event == null) {
      print('❌ Não foi possível encontrar o evento. Abortando inscrições.');
      return;
    }

    int successCount = 0;

    for (final user in users) {
      try {
        // Verifica se o usuário já está inscrito
        if (event.volunteers.contains(user.id)) {
          print('⚠️  Usuário ${user.name} já está inscrito no evento');
          continue;
        }

        // Gera dados aleatórios para o perfil do voluntário
        final skills = _selectRandomSkills();
        final resources = _selectRandomResources();
        final availableDays = _generateRandomAvailableDays();
        final availableHours = _generateRandomTimeRange();
        final isFullTime =
            _random.nextBool() &&
            _random.nextInt(10) < 2; // 20% chance de ser full-time

        // Usar o EventService para criar o perfil de voluntário
        await _eventService.createVolunteerProfile(
          userId: user.id,
          eventId: event.id,
          userName: user.name,
          userEmail: user.email,
          availableDays: isFullTime ? [] : availableDays,
          availableHours: isFullTime
              ? const TimeRange(start: '00:00', end: '23:59')
              : availableHours,
          isFullTimeAvailable: isFullTime,
          skills: skills,
          resources: resources,
        );

        successCount++;
        print('✅ ${user.name} inscrito com sucesso!');
        print('   📋 Habilidades: ${skills.join(", ")}');
        print('   🛠️  Recursos: ${resources.join(", ")}');
        if (isFullTime) {
          print('   ⏰ Disponibilidade: Tempo integral');
        } else {
          print(
            '   ⏰ Disponibilidade: ${availableDays.join(", ")} (${availableHours.formatted})',
          );
        }
        print('');
      } catch (e) {
        print('❌ Erro ao inscrever ${user.name}: $e');
      }
    }

    print('📊 Resumo da inscrição:');
    print('   👥 Total de usuários: ${users.length}');
    print('   ✅ Inscrições bem-sucedidas: $successCount');
    print('   ❌ Falhas: ${users.length - successCount}');
  }

  /// Executa o cenário completo de teste usando models e services reais
  Future<void> runTestScenario(String eventTag) async {
    print('🎬 INICIANDO CENÁRIO DE TESTE');
    print('=' * 50);
    print('📅 Data/Hora: ${DateTime.now()}');
    print('🏷️  Tag do evento: $eventTag');
    print('=' * 50);
    print('');

    try {
      // Etapa 1: Criar usuários de teste usando UserService
      final users = await createTestUsers();

      if (users.isEmpty) {
        print('❌ Nenhum usuário foi criado. Abortando cenário.');
        return;
      }

      print('');
      print('-' * 30);
      print('');

      // Etapa 2: Inscrever usuários no evento usando EventService
      await enrollUsersInEvent(users, eventTag);

      print('');
      print('=' * 50);
      print('🎉 CENÁRIO DE TESTE CONCLUÍDO COM SUCESSO!');
      print('📊 Resumo:');
      print('   👥 Usuários criados: ${users.length}');
      print('   🎯 Evento: $eventTag');
      print('=' * 50);
    } catch (e) {
      print('');
      print('=' * 50);
      print('💥 ERRO NO CENÁRIO DE TESTE: $e');
      print('=' * 50);
    }
  }

  /// Remove os dados de teste criados usando os services reais
  Future<void> cleanupTestData() async {
    print('🧹 INICIANDO LIMPEZA DE DADOS DE TESTE');
    print(
      '⚠️  ATENÇÃO: Esta operação remove os usuários criados nesta sessão!',
    );
    print('=' * 60);

    try {
      int removedCount = 0;

      // Remove apenas os usuários criados nesta sessão
      for (final userId in _createdUserIds) {
        try {
          // Buscar e remover perfis de voluntário do usuário
          final profilesQuery = await FirebaseFirestore.instance
              .collection(AppConstants.volunteerProfilesCollection)
              .where('userId', isEqualTo: userId)
              .get();

          for (final profileDoc in profilesQuery.docs) {
            await profileDoc.reference.delete();
          }

          // Remover o usuário
          await FirebaseFirestore.instance
              .collection(AppConstants.usersCollection)
              .doc(userId)
              .delete();

          removedCount++;
          print('✅ Usuário $userId removido com seus perfis');
        } catch (e) {
          print('❌ Erro ao remover usuário $userId: $e');
        }
      }

      // Limpar a lista de usuários criados
      _createdUserIds.clear();

      print('=' * 60);
      print('🎉 LIMPEZA CONCLUÍDA!');
      print('📊 Resumo:');
      print('   🗑️  Usuários removidos: $removedCount');
      print('=' * 60);
    } catch (e) {
      print('❌ Erro durante limpeza: $e');
    }
  }
}

/// Função principal para executar o gerador de cenários
void main(List<String> args) async {
  if (args.isEmpty) {
    print('❌ Erro: Tag do evento é obrigatória!');
    print('💡 Uso: dart test_scenarios_generator.dart <TAG_DO_EVENTO>');
    print('💡 Exemplo: dart test_scenarios_generator.dart ABC123');
    return;
  }

  final eventTag = args[0];
  final generator = TestScenariosGenerator();

  // Executa o cenário de teste
  await generator.runTestScenario(eventTag);
}
