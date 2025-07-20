import 'package:flutter/material.dart';
import '../data/repositories/event_repository.dart';

/// Utilitários para migração de dados do banco
class MigrationUtils {
  static final EventRepository _eventRepository = EventRepository();

  /// Executa a migração de perfis de voluntários para incluir o campo assignedMicrotasksCount
  /// Este método deve ser executado uma única vez após a implementação do sistema de contagem
  static Future<bool> runVolunteerProfilesMigration() async {
    try {
      await _eventRepository.migrateVolunteerProfilesTaskCounts();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Recalcula os contadores para uma campanha específico
  static Future<bool> recalculateEventCounts(String eventId) async {
    try {
      await _eventRepository.recalculateEventVolunteerCounts(eventId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Recalcula o contador para um voluntário específico
  static Future<bool> recalculateVolunteerCount(
    String eventId,
    String userId,
  ) async {
    try {
      await _eventRepository.recalculateVolunteerMicrotaskCount(
        eventId,
        userId,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Mostra um diálogo para executar a migração
  static void showMigrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Migração de Dados'),
        content: const Text(
          'Esta operação irá migrar todos os perfis de voluntários existentes '
          'para incluir o campo de contagem de microtasks. Esta operação deve '
          'ser executada apenas uma vez.\n\n'
          'Deseja continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              _showMigrationProgress(context);
            },
            child: const Text('Executar Migração'),
          ),
        ],
      ),
    );
  }

  /// Mostra o progresso da migração
  static void _showMigrationProgress(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Executando Migração'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Migrando perfis de voluntários...'),
          ],
        ),
      ),
    );

    runVolunteerProfilesMigration().then((success) {
      Navigator.of(context).pop(); // Fecha o diálogo de progresso

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(success ? 'Sucesso' : 'Erro'),
          content: Text(
            success
                ? 'Migração executada com sucesso!'
                : 'Erro ao executar a migração. Verifique os logs.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  /// Mostra um diálogo para recalcular contadores de uma campanha
  static void showRecalculateEventDialog(BuildContext context, String eventId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recalcular Contadores'),
        content: const Text(
          'Esta operação irá recalcular os contadores de microtasks '
          'para todos os voluntários desta campanha baseado nas '
          'atribuições reais no banco de dados.\n\n'
          'Deseja continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();

              final success = await recalculateEventCounts(eventId);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Contadores recalculados com sucesso!'
                          : 'Erro ao recalcular contadores.',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Recalcular'),
          ),
        ],
      ),
    );
  }
}
