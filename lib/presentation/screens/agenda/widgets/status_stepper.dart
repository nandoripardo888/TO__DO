import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/user_microtask_model.dart';

/// Componente de Status Stepper Horizontal para controle de status das microtasks
/// Conforme RN-02.4 e RN-03 do PRD - Design do Status Stepper e Lógica de Interação
class StatusStepper extends StatefulWidget {
  final UserMicrotaskStatus currentStatus;
  final Function(UserMicrotaskStatus) onStatusChanged;

  const StatusStepper({
    super.key,
    required this.currentStatus,
    required this.onStatusChanged,
  });

  @override
  State<StatusStepper> createState() => _StatusStepperState();
}

class _StatusStepperState extends State<StatusStepper> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildStep(
              stepNumber: 1,
              status: UserMicrotaskStatus.assigned,
              label: 'Atribuída',
              isFirst: true,
            ),
            _buildConnector(UserMicrotaskStatus.assigned),
            _buildStep(
              stepNumber: 2,
              status: UserMicrotaskStatus.inProgress,
              label: 'Em Andamento',
            ),
            _buildConnector(UserMicrotaskStatus.inProgress),
            _buildStep(
              stepNumber: null, // Usa ícone de check
              status: UserMicrotaskStatus.completed,
              label: 'Concluída',
              isLast: true,
            ),
          ],
        ),
        if (_isLoading) ...[
          const SizedBox(height: AppDimensions.spacingSm),
          const SizedBox(height: 2, child: LinearProgressIndicator()),
        ],
      ],
    );
  }

  Widget _buildStep({
    required int? stepNumber,
    required UserMicrotaskStatus status,
    required String label,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final isActive = _isStatusActive(status);
    final isInteractive = _isStatusInteractive(status);

    return Expanded(
      child: Column(
        children: [
          GestureDetector(
            onTap: isInteractive && !_isLoading
                ? () => _handleStatusTap(status)
                : null,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? const Color(0xFF6B46C1)
                    : Colors.transparent, // #6B46C1 - Roxo
                border: Border.all(
                  color: isActive ? const Color(0xFF6B46C1) : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: Center(child: _buildStepContent(stepNumber, isActive)),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive ? const Color(0xFF6B46C1) : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(int? stepNumber, bool isActive) {
    if (stepNumber != null) {
      return Text(
        stepNumber.toString(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.white : Colors.grey[600],
        ),
      );
    } else {
      // Ícone de check para o status completed
      return Icon(
        Icons.check,
        size: 18,
        color: isActive ? Colors.white : Colors.grey[600],
      );
    }
  }

  Widget _buildConnector(UserMicrotaskStatus fromStatus) {
    final isActive = _isStatusActive(fromStatus);

    return Container(
      height: 2,
      width: 40,
      margin: const EdgeInsets.only(bottom: 24), // Alinha com o círculo
      color: isActive ? const Color(0xFF6B46C1) : Colors.grey[300],
    );
  }

  /// Verifica se o status está ativo (preenchido)
  bool _isStatusActive(UserMicrotaskStatus status) {
    switch (widget.currentStatus) {
      case UserMicrotaskStatus.assigned:
        return status == UserMicrotaskStatus.assigned;
      case UserMicrotaskStatus.inProgress:
        return status == UserMicrotaskStatus.assigned ||
            status == UserMicrotaskStatus.inProgress;
      case UserMicrotaskStatus.completed:
        return true; // Todos os status ficam ativos quando completed
      case UserMicrotaskStatus.cancelled:
        return status ==
            UserMicrotaskStatus.assigned; // Apenas o primeiro fica ativo
    }
  }

  /// Verifica se o status é interativo (pode ser clicado)
  /// Conforme RN-03.2, RN-03.3 e RN-03.4
  bool _isStatusInteractive(UserMicrotaskStatus status) {
    // RN-03.2: assigned não é interativo (estado inicial)
    if (status == UserMicrotaskStatus.assigned) {
      // Permite regressão de in_progress para assigned (RN-03.4)
      return widget.currentStatus == UserMicrotaskStatus.inProgress;
    }

    // RN-03.3: Progressão permitida
    if (status == UserMicrotaskStatus.inProgress) {
      return widget.currentStatus == UserMicrotaskStatus.assigned ||
          widget.currentStatus ==
              UserMicrotaskStatus.completed; // Permite regressão
    }

    if (status == UserMicrotaskStatus.completed) {
      return widget.currentStatus == UserMicrotaskStatus.inProgress ||
          widget.currentStatus ==
              UserMicrotaskStatus.completed; // Permite desmarcar
    }

    return false;
  }

  /// Manipula o toque em um status
  /// Implementa as regras RN-03.3, RN-03.4 e RN-03.5
  Future<void> _handleStatusTap(UserMicrotaskStatus tappedStatus) async {
    if (_isLoading) return;

    UserMicrotaskStatus newStatus;

    // Determina o novo status baseado no status atual e no que foi clicado
    if (tappedStatus == UserMicrotaskStatus.assigned) {
      // Regressão para assigned (apenas de in_progress)
      if (widget.currentStatus == UserMicrotaskStatus.inProgress) {
        newStatus = UserMicrotaskStatus.assigned;
      } else {
        return; // Não permite outras transições para assigned
      }
    } else if (tappedStatus == UserMicrotaskStatus.inProgress) {
      if (widget.currentStatus == UserMicrotaskStatus.assigned) {
        // Progressão para in_progress
        newStatus = UserMicrotaskStatus.inProgress;
      } else if (widget.currentStatus == UserMicrotaskStatus.completed) {
        // Regressão de completed para in_progress
        newStatus = UserMicrotaskStatus.inProgress;
      } else {
        return; // Já está em in_progress
      }
    } else if (tappedStatus == UserMicrotaskStatus.completed) {
      if (widget.currentStatus == UserMicrotaskStatus.inProgress) {
        // Progressão para completed
        newStatus = UserMicrotaskStatus.completed;
      } else if (widget.currentStatus == UserMicrotaskStatus.completed) {
        // Desmarcar completed (volta para in_progress)
        newStatus = UserMicrotaskStatus.inProgress;
      } else {
        return; // Não permite pular etapas
      }
    } else {
      return;
    }

    // RN-03.6: Feedback visual durante a mudança
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onStatusChanged(newStatus);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
