import 'dart:io';
import 'test_scenarios_generator.dart';

/// Script simplificado para executar cenários de teste
/// Permite execução interativa ou via parâmetros
void main(List<String> args) async {
  print('🎯 GERADOR DE CENÁRIOS DE TESTE - ConTask');
  print('=' * 50);

  String? eventTag;

  // Se a tag foi passada como argumento, usa ela
  if (args.isNotEmpty) {
    eventTag = args[0].toUpperCase();
  } else {
    // Caso contrário, solicita interativamente
    print('📝 Digite a tag do evento (6 caracteres alfanuméricos):');
    stdout.write('Tag: ');
    eventTag = stdin.readLineSync()?.toUpperCase();
  }

  // Valida a tag
  if (eventTag == null || eventTag.isEmpty) {
    print('❌ Tag do evento é obrigatória!');
    exit(1);
  }

  if (eventTag.length != 6) {
    print('❌ A tag deve ter exatamente 6 caracteres!');
    exit(1);
  }

  if (!RegExp(r'^[A-Z0-9]{6}$').hasMatch(eventTag)) {
    print('❌ A tag deve conter apenas letras maiúsculas e números!');
    exit(1);
  }

  print('');
  print('🚀 Iniciando geração de cenário para o evento: $eventTag');
  print('');

  final generator = TestScenariosGenerator();

  try {
    await generator.runTestScenario(eventTag);
  } catch (e) {
    print('💥 Erro fatal: $e');
    exit(1);
  }
}
