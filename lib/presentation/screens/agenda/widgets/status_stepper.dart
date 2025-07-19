import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/user_microtask_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentation/widgets/dialogs/confirmation_dialog.dart';

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

class _StatusStepperState extends State<StatusStepper>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  UserMicrotaskStatus? _animatingStatus;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildStep(
              stepNumber:
                  null, // Não é mais necessário, mas mantido para compatibilidade
              status: UserMicrotaskStatus.assigned,
              label: 'Atribuída',
              isFirst: true,
            ),
            _buildConnector(UserMicrotaskStatus.assigned),
            _buildStep(
              stepNumber: null,
              status: UserMicrotaskStatus.inProgress,
              label: 'Em Andamento',
            ),
            _buildConnector(UserMicrotaskStatus.inProgress),
            _buildStep(
              stepNumber: null,
              status: UserMicrotaskStatus.completed,
              label: 'Concluída',
              isLast: true,
            ),
          ],
        ),
        if (_isLoading) ...[
          const SizedBox(height: AppDimensions.spacingSm),
          const SizedBox(
            height: 2,
            child: LinearProgressIndicator(
              backgroundColor: AppColors.disabled,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
            ),
          ),
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
            onTapDown: isInteractive && !_isLoading
                ? (_) => _onTapDown(status)
                : null,
            onTapUp: isInteractive && !_isLoading
                ? (_) => _onTapUp(status)
                : null,
            onTapCancel: isInteractive && !_isLoading
                ? () => _onTapCancel()
                : null,
            onTap: isInteractive && !_isLoading
                ? () => _handleStatusTap(status)
                : null,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                final scale = _animatingStatus == status
                    ? _scaleAnimation.value
                    : 1.0;
                return Transform.scale(
                  scale: scale,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? AppColors.success : AppColors.disabled,
                      border: Border.all(
                        color: isActive
                            ? AppColors.success
                            : AppColors.disabled,
                        width: 2,
                      ),
                      boxShadow: isInteractive && !_isLoading
                          ? [
                              BoxShadow(
                                color:
                                    (isActive
                                            ? AppColors.success
                                            : AppColors.disabled)
                                        .withOpacity(0.3),
                                blurRadius: _animatingStatus == status ? 8 : 4,
                                spreadRadius: _animatingStatus == status
                                    ? 2
                                    : 0,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(child: _buildStepIcon(status, isActive)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive ? AppColors.success : AppColors.disabled,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepIcon(UserMicrotaskStatus status, bool isActive) {
    IconData iconData;
    switch (status) {
      case UserMicrotaskStatus.assigned:
        iconData = Icons.assignment;
        break;
      case UserMicrotaskStatus.inProgress:
        iconData = Icons.autorenew;
        break;
      case UserMicrotaskStatus.completed:
        iconData = Icons.check_circle;
        break;
      default:
        iconData = Icons.help_outline;
    }
    return Icon(
      iconData,
      size: 20,
      color: isActive ? Colors.white : Colors.grey[600],
    );
  }

  Widget _buildConnector(UserMicrotaskStatus fromStatus) {
    final isActive = _isStatusActive(fromStatus);

    return Container(
      height: 2,
      width: 40,
      margin: const EdgeInsets.only(bottom: 24), // Alinha com o círculo
      color: isActive ? AppColors.success : AppColors.disabled,
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
  /// Modificado para impedir regressão de status
  bool _isStatusInteractive(UserMicrotaskStatus status) {
    // assigned não é interativo (estado inicial)
    if (status == UserMicrotaskStatus.assigned) {
      return false; // Nunca permite voltar para assigned
    }

    // Progressão permitida apenas para frente
    if (status == UserMicrotaskStatus.inProgress) {
      return widget.currentStatus == UserMicrotaskStatus.assigned;
    }

    if (status == UserMicrotaskStatus.completed) {
      return widget.currentStatus == UserMicrotaskStatus.inProgress;
    }

    return false;
  }

  /// Manipula o início do toque (onTapDown)
  void _onTapDown(UserMicrotaskStatus status) {
    setState(() {
      _animatingStatus = status;
    });
    _animationController.forward();
  }

  /// Manipula o fim do toque (onTapUp)
  void _onTapUp(UserMicrotaskStatus status) {
    _animationController.reverse();
  }

  /// Manipula o cancelamento do toque
  void _onTapCancel() {
    _animationController.reverse();
    setState(() {
      _animatingStatus = null;
    });
  }

  /// Manipula o toque em um status
  /// Modificado para permitir apenas progressão para frente
  Future<void> _handleStatusTap(UserMicrotaskStatus tappedStatus) async {
    print('👆 [STATUS_STEPPER] Toque detectado:');
    print('   - status atual: ${widget.currentStatus.name}');
    print('   - status clicado: ${tappedStatus.name}');
    print('   - _isLoading: $_isLoading');
    print('   - timestamp: ${DateTime.now().toIso8601String()}');
    
    if (_isLoading) {
      print('⏳ [STATUS_STEPPER] Operação já em andamento, ignorando toque');
      return;
    }

    UserMicrotaskStatus? newStatus;

    // Determina o novo status baseado no status atual e no que foi clicado
    if (tappedStatus == UserMicrotaskStatus.inProgress) {
      if (widget.currentStatus == UserMicrotaskStatus.assigned) {
        print('🔄 [STATUS_STEPPER] Transição válida: assigned -> inProgress');
        // Progressão para in_progress
        // Solicitar confirmação do usuário
        final bool? confirmed = await ConfirmationDialog.show(
          context: context,
          title: 'Iniciar Microtarefa',
          content:
              'Tem certeza que deseja iniciar esta microtarefa? Isso indicará que você começou a trabalhar nela.',
          confirmText: 'Confirmar',
          cancelText: 'Cancelar',
          icon: Icons.play_circle,
          iconColor: AppColors.success,
          confirmButtonColor: AppColors.success,
        );

        print('💬 [STATUS_STEPPER] Resposta do diálogo de confirmação: $confirmed');
        if (confirmed != true) {
          print('❌ [STATUS_STEPPER] Usuário cancelou a operação');
          return; // Usuário cancelou a operação
        }

        newStatus = UserMicrotaskStatus.inProgress;
      } else {
        print('🚫 [STATUS_STEPPER] Transição inválida: ${widget.currentStatus.name} -> inProgress');
        return; // Não permite outras transições
      }
    } else if (tappedStatus == UserMicrotaskStatus.completed) {
      if (widget.currentStatus == UserMicrotaskStatus.inProgress) {
        print('🔄 [STATUS_STEPPER] Transição válida: inProgress -> completed');
        // Progressão para completed
        // Solicitar confirmação do usuário
        final bool? confirmed = await ConfirmationDialog.show(
          context: context,
          title: 'Concluir Microtarefa',
          content:
              'Tem certeza que deseja marcar esta microtarefa como concluída?',
          confirmText: 'Confirmar',
          cancelText: 'Cancelar',
          icon: Icons.check_circle,
          iconColor: AppColors.success,
          confirmButtonColor: AppColors.success,
        );

        print('💬 [STATUS_STEPPER] Resposta do diálogo de confirmação: $confirmed');
        if (confirmed != true) {
          print('❌ [STATUS_STEPPER] Usuário cancelou a operação');
          return; // Usuário cancelou a operação
        }

        newStatus = UserMicrotaskStatus.completed;
      } else {
        print('🚫 [STATUS_STEPPER] Transição inválida: ${widget.currentStatus.name} -> completed');
        return; // Não permite pular etapas ou regredir
      }
    } else {
      print('🚫 [STATUS_STEPPER] Status não permitido para transição: ${tappedStatus.name}');
      return; // Não permite outras transições
    }

    print('✅ [STATUS_STEPPER] Iniciando mudança de status para: ${newStatus!.name}');
    
    // Feedback visual durante a mudança
    setState(() {
      _isLoading = true;
      _animatingStatus = null;
    });
    _animationController.reset();

    try {
      print('📞 [STATUS_STEPPER] Chamando callback onStatusChanged...');
      await widget.onStatusChanged(newStatus);
      print('✅ [STATUS_STEPPER] Callback onStatusChanged executado com sucesso');
    } catch (e, stackTrace) {
      print('❌ [STATUS_STEPPER] Erro no callback onStatusChanged:');
      print('   - Tipo: ${e.runtimeType}');
      print('   - Mensagem: $e');
      print('   - Stack trace: $stackTrace');
      rethrow;
    } finally {
      if (mounted) {
        print('🏁 [STATUS_STEPPER] Finalizando operação, _isLoading = false');
        setState(() {
          _isLoading = false;
        });
      } else {
        print('⚠️ [STATUS_STEPPER] Widget não está mais montado');
      }
    }
  }
}
