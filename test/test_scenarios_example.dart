import 'dart:math';

/// Exemplo simplificado do gerador de cenários de teste
/// Este arquivo demonstra a lógica sem dependências do Firebase
/// 
/// Para usar os models reais, execute: test_scenarios_generator.dart

class MockUser {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;

  MockUser({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  @override
  String toString() => 'MockUser(id: $id, name: $name, email: $email)';
}

class MockVolunteerProfile {
  final String userId;
  final String eventId;
  final List<String> skills;
  final List<String> resources;
  final Map<String, dynamic> availability;

  MockVolunteerProfile({
    required this.userId,
    required this.eventId,
    required this.skills,
    required this.resources,
    required this.availability,
  });

  @override
  String toString() {
    return 'MockVolunteerProfile(userId: $userId, eventId: $eventId, skills: $skills, resources: $resources)';
  }
}

class MockTestScenariosGenerator {
  final Random _random = Random();
  
  // Listas de dados fictícios
  final List<String> _firstNames = [
    'Ana', 'Bruno', 'Carlos', 'Diana', 'Eduardo', 'Fernanda',
    'Gabriel', 'Helena', 'Igor', 'Julia', 'Lucas', 'Mariana',
    'Nicolas', 'Olivia', 'Pedro', 'Rafaela', 'Samuel', 'Tatiana'
  ];
  
  final List<String> _lastNames = [
    'Silva', 'Santos', 'Oliveira', 'Souza', 'Rodrigues', 'Ferreira',
    'Alves', 'Pereira', 'Lima', 'Gomes', 'Costa', 'Ribeiro',
    'Martins', 'Carvalho', 'Almeida', 'Lopes', 'Soares', 'Fernandes'
  ];
  
  final List<String> _emailDomains = [
    'gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com'
  ];
  
  final List<String> _availableSkills = [
    'Organização', 'Comunicação', 'Liderança', 'Trabalho em equipe',
    'Criatividade', 'Resolução de problemas', 'Gestão de tempo',
    'Tecnologia', 'Design', 'Marketing', 'Educação', 'Saúde',
    'Logística', 'Vendas', 'Atendimento ao cliente', 'Programação'
  ];
  
  final List<String> _availableResources = [
    'Veículo próprio', 'Notebook', 'Smartphone', 'Câmera fotográfica',
    'Equipamento de som', 'Material de escritório', 'Ferramentas básicas',
    'Projetor', 'Carro', 'Moto', 'Bicicleta', 'Kit primeiros socorros'
  ];
  
  final List<String> _weekDays = [
    'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'
  ];

  /// Gera um nome completo aleatório
  String _generateRandomName() {
    final firstName = _firstNames[_random.nextInt(_firstNames.length)];
    final lastName = _lastNames[_random.nextInt(_lastNames.length)];
    return '$firstName $lastName';
  }

  /// Gera um email baseado no nome
  String _generateEmail(String name) {
    final cleanName = name.toLowerCase()
        .replaceAll(' ', '.')
        .replaceAll(RegExp(r'[^a-z.]'), '');
    final randomNumber = _random.nextInt(1000);
    final domain = _emailDomains[_random.nextInt(_emailDomains.length)];
    return '$cleanName$randomNumber@$domain';
  }

  /// Gera habilidades aleatórias
  List<String> _generateRandomSkills() {
    final skillCount = 2 + _random.nextInt(3); // 2-4 habilidades
    final shuffledSkills = List<String>.from(_availableSkills)..shuffle(_random);
    return shuffledSkills.take(skillCount).toList();
  }

  /// Gera recursos aleatórios
  List<String> _generateRandomResources() {
    final resourceCount = 1 + _random.nextInt(3); // 1-3 recursos
    final shuffledResources = List<String>.from(_availableResources)..shuffle(_random);
    return shuffledResources.take(resourceCount).toList();
  }

  /// Gera disponibilidade aleatória
  Map<String, dynamic> _generateRandomAvailability() {
    // 20% de chance de disponibilidade integral
    if (_random.nextDouble() < 0.2) {
      return {
        'type': 'integral',
        'description': 'Disponível em qualquer horário'
      };
    }
    
    // Disponibilidade específica
    final dayCount = 1 + _random.nextInt(4); // 1-4 dias
    final shuffledDays = List<String>.from(_weekDays)..shuffle(_random);
    final selectedDays = shuffledDays.take(dayCount).toList();
    
    final startHour = 6 + _random.nextInt(6); // 6-11h
    final endHour = 14 + _random.nextInt(6); // 14-19h
    
    return {
      'type': 'specific',
      'days': selectedDays,
      'startTime': '${startHour.toString().padLeft(2, '0')}:00',
      'endTime': '${endHour.toString().padLeft(2, '0')}:00',
    };
  }

  /// Cria usuários fictícios usando a lógica dos models reais
  List<MockUser> createTestUsers() {
    print('👥 Criando 10 usuários de teste (simulando UserService e UserModel)...');
    
    final users = <MockUser>[];
    
    for (int i = 1; i <= 10; i++) {
      final name = _generateRandomName();
      final email = _generateEmail(name);
      final user = MockUser(
        id: 'mock_user_${i.toString().padLeft(3, '0')}',
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );
      
      users.add(user);
      print('✅ Usuário criado: $name ($email) - ID: ${user.id}');
    }
    
    print('🎉 Criação de usuários concluída! Total: ${users.length} usuários');
    return users;
  }

  /// Inscreve usuários em um evento (simulando EventService e VolunteerProfileModel)
  void enrollUsersInEvent(List<MockUser> users, String eventTag) {
    print('\n📝 Inscrevendo usuários no evento usando EventService e VolunteerProfileModel...');
    print('🎯 Evento simulado: evento-$eventTag');
    print('');
    
    final profiles = <MockVolunteerProfile>[];
    
    for (final user in users) {
      final skills = _generateRandomSkills();
      final resources = _generateRandomResources();
      final availability = _generateRandomAvailability();
      
      final profile = MockVolunteerProfile(
        userId: user.id,
        eventId: 'event_$eventTag',
        skills: skills,
        resources: resources,
        availability: availability,
      );
      
      profiles.add(profile);
      
      print('✅ ${user.name} inscrito com sucesso!');
      print('   📋 Habilidades: ${skills.join(', ')}');
      print('   🛠️  Recursos: ${resources.join(', ')}');
      
      if (availability['type'] == 'integral') {
        print('   ⏰ Disponibilidade: ${availability['description']}');
      } else {
        final days = (availability['days'] as List<String>).join(', ');
        final timeRange = '${availability['startTime']} - ${availability['endTime']}';
        print('   ⏰ Disponibilidade: $days ($timeRange)');
      }
      print('');
    }
    
    print('📊 Resumo da inscrição:');
    print('   👥 Total de usuários: ${users.length}');
    print('   ✅ Inscrições bem-sucedidas: ${profiles.length}');
    print('   ❌ Falhas: 0');
  }

  /// Executa o cenário de teste completo (simulando a integração real)
  void runTestScenario(String eventTag) {
    print('🎬 INICIANDO CENÁRIO DE TESTE (SIMULAÇÃO)');
    print('=' * 50);
    print('📅 Data/Hora: ${DateTime.now()}');
    print('🏷️  Tag do evento: $eventTag');
    print('💡 Nota: Esta é uma simulação. Para usar models reais, execute test_scenarios_generator.dart');
    print('=' * 50);
    
    try {
      // 1. Criar usuários de teste
      final users = createTestUsers();
      
      print('\n' + '-' * 30);
      
      // 2. Simular busca de evento
      print('🔍 Buscando evento com tag: $eventTag (simulando EventModel)...');
      print('✅ Evento encontrado: Evento de Teste - $eventTag');
      
      // 3. Inscrever usuários no evento
      enrollUsersInEvent(users, eventTag);
      
      print('\n' + '=' * 50);
      print('🎉 CENÁRIO DE TESTE CONCLUÍDO COM SUCESSO!');
      print('📊 Resumo:');
      print('   👥 Usuários criados: ${users.length}');
      print('   🎯 Evento: Evento de Teste - $eventTag');
      print('   🏷️  Tag: $eventTag');
      print('=' * 50);
      
    } catch (e) {
      print('❌ Erro durante execução do cenário: $e');
    }
  }
}

void main(List<String> args) {
  final generator = MockTestScenariosGenerator();
  
  // Usar tag fornecida como argumento ou padrão
  final eventTag = args.isNotEmpty ? args[0] : 'TEST01';
  
  generator.runTestScenario(eventTag);
  
  print('\n💡 DICA: Para usar os models reais do projeto, execute:');
  print('   dart test_scenarios_generator.dart $eventTag');
}