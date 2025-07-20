import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:contask/data/services/cloud_functions_service.dart';
import 'package:contask/firebase_options.dart';

/// Arquivo de teste para as Firebase Cloud Functions
/// Execute com: flutter run test_cloud_functions.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print('🚀 Iniciando testes das Cloud Functions...');

  final cloudFunctionsService = CloudFunctionsService();

  // Teste 1: updateMicrotaskStatus
  await testUpdateMicrotaskStatus(cloudFunctionsService);

  // Teste 2: updateTaskStatus
  await testUpdateTaskStatus(cloudFunctionsService);

  // Teste 3: getTaskStatistics
  await testGetTaskStatistics(cloudFunctionsService);

  print('✅ Todos os testes concluídos!');
}

/// Testa a função updateMicrotaskStatus
Future<void> testUpdateMicrotaskStatus(CloudFunctionsService service) async {
  print('\n📝 Testando updateMicrotaskStatus...');

  try {
    // Substitua pelos IDs reais do seu projeto
    const userId = 'USER_ID_TESTE';
    const microtaskId = 'MICROTASK_ID_TESTE';
    const newStatus = 'in_progress';

    final success = await service.updateMicrotaskStatus(
      userId: userId,
      microtaskId: microtaskId,
      newStatus: newStatus,
    );

    if (success) {
      print('✅ updateMicrotaskStatus: Sucesso!');
    } else {
      print('❌ updateMicrotaskStatus: Falhou');
    }
  } catch (e) {
    print('❌ updateMicrotaskStatus: Erro - $e');
  }
}

/// Testa a função updateTaskStatus
Future<void> testUpdateTaskStatus(CloudFunctionsService service) async {
  print('\n📋 Testando updateTaskStatus...');

  try {
    // Substitua pelos IDs reais do seu projeto
    const taskId = 'TASK_ID_TESTE';
    const newStatus = 'in_progress';

    final success = await service.updateTaskStatus(
      taskId: taskId,
      newStatus: newStatus,
    );

    if (success) {
      print('✅ updateTaskStatus: Sucesso!');
    } else {
      print('❌ updateTaskStatus: Falhou');
    }
  } catch (e) {
    print('❌ updateTaskStatus: Erro - $e');
  }
}

/// Testa a função getTaskStatistics
Future<void> testGetTaskStatistics(CloudFunctionsService service) async {
  print('\n📊 Testando getTaskStatistics...');

  try {
    // Substitua pelo ID real da sua task
    const taskId = 'TASK_ID_TESTE';

    final statistics = await service.getTaskStatistics(taskId);

    print('✅ getTaskStatistics: Sucesso!');
    print('📈 Estatísticas recebidas:');
    print('   - Total: ${statistics.total}');
    print('   - Pendentes: ${statistics.pending}');
    print('   - Atribuídas: ${statistics.assigned}');
    print('   - Em progresso: ${statistics.inProgress}');
    print('   - Concluídas: ${statistics.completed}');
    print(
      '   - Taxa de progresso: ${statistics.progressPercentage.toStringAsFixed(2)}%',
    );
    print('   - Está completa: ${statistics.isCompleted}');
    print('   - Está em progresso: ${statistics.isInProgress}');
  } catch (e) {
    print('❌ getTaskStatistics: Erro - $e');
  }
}

/// Instruções de uso:
/// 
/// 1. Substitua os IDs de teste pelos IDs reais do seu projeto:
///    - USER_ID_TESTE: ID de um usuário real
///    - MICROTASK_ID_TESTE: ID de uma microtask real
///    - TASK_ID_TESTE: ID de uma task real
/// 
/// 2. Execute o arquivo com:
///    flutter run test_cloud_functions.dart
/// 
/// 3. Verifique os logs no console para ver os resultados
/// 
/// 4. Para testes mais avançados, você pode:
///    - Modificar os status testados
///    - Adicionar mais cenários de teste
///    - Testar com dados inválidos para verificar tratamento de erros