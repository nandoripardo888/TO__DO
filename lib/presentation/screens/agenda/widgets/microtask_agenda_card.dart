import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/user_microtask_model.dart';
import '../../../../data/models/microtask_model.dart';
import '../../../../data/models/task_model.dart';
import 'status_stepper.dart';

/// Componente de card reutilizável para exibir microtasks na agenda
/// Conforme REQ-02 do PRD - Componente da Microtarefa (Card da Agenda)
class MicrotaskAgendaCard extends StatelessWidget {
  final UserMicrotaskModel userMicrotask;
  final MicrotaskModel? microtask;
  final TaskModel? task;
  final Function(UserMicrotaskStatus) onStatusChanged;

  const MicrotaskAgendaCard({
    super.key,
    required this.userMicrotask,
    required this.microtask,
    required this.task,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: AppDimensions.spacingSm),
            _buildParentTaskInfo(),
            const SizedBox(height: AppDimensions.spacingSm),
            _buildDateTimeInfo(),
            if (microtask?.description.isNotEmpty == true) ...[
              const SizedBox(height: AppDimensions.spacingSm),
              _buildDescription(),
            ],
            const SizedBox(height: AppDimensions.spacingMd),
            const Divider(height: 1),
            const SizedBox(height: AppDimensions.spacingMd),
            _buildStatusStepper(),
          ],
        ),
      ),
    );
  }

  /// RN-02.1: Título da Microtarefa em destaque
  Widget _buildHeader() {
    return Text(
      microtask?.title ?? 'Microtask não encontrada',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF374151), // #374151
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// RN-02.2: Título da Tarefa Pai com menor destaque
  Widget _buildParentTaskInfo() {
    final taskTitle = task?.title ?? 'Task não encontrada';

    return Row(
      children: [
        Icon(
          Icons.folder_outlined,
          size: 16,
          color: const Color(0xFFA78BFA), // #A78BFA - Cor secundária
        ),
        const SizedBox(width: AppDimensions.spacingXs),
        Expanded(
          child: Text(
            'Pertence a: $taskTitle',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFA78BFA), // #A78BFA - Cor secundária
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// RN-02.3: Informações Temporais formatadas
  Widget _buildDateTimeInfo() {
    if (microtask?.startDateTime == null && microtask?.endDateTime == null) {
      return Row(
        children: [
          Icon(Icons.schedule_outlined, size: 16, color: Colors.grey[600]),
          const SizedBox(width: AppDimensions.spacingXs),
          Text(
            'Horário flexível',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      );
    }

    final startDateTime = microtask?.startDateTime;
    final endDateTime = microtask?.endDateTime;

    String dateTimeText = '';

    if (startDateTime != null && endDateTime != null) {
      // Formato: dd/mm/yyyy HH:MM - HH:MM
      final dateStr =
          '${startDateTime.day.toString().padLeft(2, '0')}/'
          '${startDateTime.month.toString().padLeft(2, '0')}/'
          '${startDateTime.year}';
      final startTimeStr =
          '${startDateTime.hour.toString().padLeft(2, '0')}:'
          '${startDateTime.minute.toString().padLeft(2, '0')}';
      final endTimeStr =
          '${endDateTime.hour.toString().padLeft(2, '0')}:'
          '${endDateTime.minute.toString().padLeft(2, '0')}';

      dateTimeText = '$dateStr $startTimeStr - $endTimeStr';
    } else if (startDateTime != null) {
      final dateStr =
          '${startDateTime.day.toString().padLeft(2, '0')}/'
          '${startDateTime.month.toString().padLeft(2, '0')}/'
          '${startDateTime.year}';
      final timeStr =
          '${startDateTime.hour.toString().padLeft(2, '0')}:'
          '${startDateTime.minute.toString().padLeft(2, '0')}';

      dateTimeText = 'Início: $dateStr $timeStr';
    }

    return Row(
      children: [
        Icon(Icons.schedule_outlined, size: 16, color: Colors.grey[600]),
        const SizedBox(width: AppDimensions.spacingXs),
        Expanded(
          child: Text(
            dateTimeText,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Descrição da microtask (opcional)
  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingSm),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.description_outlined, size: 16, color: Colors.grey[600]),
          const SizedBox(width: AppDimensions.spacingXs),
          Expanded(
            child: Text(
              microtask!.description,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// RN-02.4: Status Stepper Horizontal
  Widget _buildStatusStepper() {
    return StatusStepper(
      currentStatus: userMicrotask.status,
      onStatusChanged: onStatusChanged,
    );
  }
}
