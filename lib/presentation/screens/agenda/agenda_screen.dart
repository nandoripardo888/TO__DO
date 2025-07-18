import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../controllers/agenda_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_message_widget.dart';
import '../../../data/models/user_microtask_model.dart';
import 'widgets/microtask_agenda_card.dart';

/// Tela principal da aba AGENDA para voluntários
/// Conforme especificação do PRD - REQ-01: Nova Aba "AGENDA"
class AgendaScreen extends StatefulWidget {
  final String eventId;

  const AgendaScreen({super.key, required this.eventId});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> 
    with TickerProviderStateMixin {
  late AgendaController _agendaController;
  String? _currentUserId;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<UserMicrotaskModel> _previousMicrotasks = [];
  late AnimationController _reorderAnimationController;
  late Animation<double> _reorderAnimation;

  @override
  void initState() {
    super.initState();
    _agendaController = AgendaController();
    _reorderAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _reorderAnimation = CurvedAnimation(
      parent: _reorderAnimationController,
      curve: Curves.easeInOut,
    );
    _loadAgenda();
  }

  @override
  void dispose() {
    _reorderAnimationController.dispose();
    _agendaController.dispose();
    super.dispose();
  }

  void _loadAgenda() {
    final authController = Provider.of<AuthController>(context, listen: false);
    _currentUserId = authController.currentUser?.id;

    if (_currentUserId != null) {
      _agendaController.loadAgenda(
        userId: _currentUserId!,
        eventId: widget.eventId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _agendaController,
      child: Consumer<AgendaController>(
        builder: (context, controller, child) {
          return _buildBody(controller);
        },
      ),
    );
  }

  Widget _buildBody(AgendaController controller) {
    switch (controller.state) {
      case AgendaControllerState.initial:
      case AgendaControllerState.loading:
        return const LoadingWidget(message: 'Carregando sua agenda...');

      case AgendaControllerState.error:
        return ErrorMessageWidget(
          message: controller.errorMessage ?? 'Erro ao carregar agenda',
          onRetry: _loadAgenda,
        );

      case AgendaControllerState.loaded:
        return _buildLoadedContent(controller);
    }
  }

  Widget _buildLoadedContent(AgendaController controller) {
    final userMicrotasks = controller.filteredUserMicrotasks;

    if (userMicrotasks.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildFilterBar(controller),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _refreshAgenda(controller),
            child: _buildMicrotasksList(userMicrotasks, controller),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: AppDimensions.spacingLg),
          Text(
            'Nenhuma microtask atribuída',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Text(
            'Você ainda não possui microtasks\natribuídas neste evento.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(AgendaController controller) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_list, color: Colors.grey[600], size: 20),
          const SizedBox(width: AppDimensions.spacingSm),
          Text(
            'Filtrar por status:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    controller,
                    'Todos',
                    null,
                    controller.statusFilter == null,
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  _buildFilterChip(
                    controller,
                    'Atribuída',
                    UserMicrotaskStatus.assigned,
                    controller.statusFilter == UserMicrotaskStatus.assigned,
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  _buildFilterChip(
                    controller,
                    'Em Andamento',
                    UserMicrotaskStatus.inProgress,
                    controller.statusFilter == UserMicrotaskStatus.inProgress,
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  _buildFilterChip(
                    controller,
                    'Concluída',
                    UserMicrotaskStatus.completed,
                    controller.statusFilter == UserMicrotaskStatus.completed,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    AgendaController controller,
    String label,
    UserMicrotaskStatus? status,
    bool isSelected,
  ) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        controller.setStatusFilter(selected ? status : null);
      },
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : Colors.grey[700],
        fontSize: 12,
      ),
    );
  }

  Widget _buildMicrotasksList(
    List<UserMicrotaskModel> userMicrotasks,
    AgendaController controller,
  ) {
    // Detecta mudanças na lista para animações
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleListChanges(userMicrotasks);
    });

    return AnimatedList(
      key: _listKey,
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      initialItemCount: userMicrotasks.length,
      itemBuilder: (context, index, animation) {
        if (index >= userMicrotasks.length) {
          return const SizedBox.shrink();
        }
        
        final userMicrotask = userMicrotasks[index];
        final microtask = controller.getMicrotaskById(
          userMicrotask.microtaskId,
        );
        final task = microtask != null
            ? controller.getTaskById(microtask.taskId)
            : null;

        // Animação combinada: deslizamento horizontal + fade + escala
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeOutCubic)),
          ),
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation.drive(
                Tween(begin: 0.9, end: 1.0)
                  .chain(CurveTween(curve: Curves.easeOutCubic)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
                child: Container(
                  key: ValueKey('microtask_${userMicrotask.microtaskId}'),
                  child: MicrotaskAgendaCard(
                    userMicrotask: userMicrotask,
                    microtask: microtask,
                    task: task,
                    onStatusChanged: (newStatus) =>
                        _handleStatusChange(controller, userMicrotask, newStatus),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _refreshAgenda(AgendaController controller) async {
    if (_currentUserId != null) {
      await controller.refresh(
        userId: _currentUserId!,
        eventId: widget.eventId,
      );
    }
  }

  /// Detecta mudanças na lista e executa animações de reordenação
  void _handleListChanges(List<UserMicrotaskModel> newMicrotasks) {
    if (_previousMicrotasks.isEmpty) {
      _previousMicrotasks = List.from(newMicrotasks);
      return;
    }

    // Verifica se houve reordenação (mesmo tamanho, mas ordem diferente)
    if (_previousMicrotasks.length == newMicrotasks.length) {
      // Mapeia os IDs para verificar mudanças de posição
      final Map<String, int> oldPositions = {};
      for (int i = 0; i < _previousMicrotasks.length; i++) {
        oldPositions[_previousMicrotasks[i].microtaskId] = i;
      }
      
      bool hasReordering = false;
      List<Map<String, dynamic>> moves = [];
      
      // Detecta movimentos específicos
      for (int i = 0; i < newMicrotasks.length; i++) {
        final String id = newMicrotasks[i].microtaskId;
        final int? oldPos = oldPositions[id];
        
        if (oldPos != null && oldPos != i) {
          hasReordering = true;
          moves.add({
            'id': id,
            'from': oldPos,
            'to': i,
          });
        }
      }
      
      if (hasReordering) {
        _animateReordering(moves);
      }
    }
    
    _previousMicrotasks = List.from(newMicrotasks);
  }

  /// Executa animação de reordenação
  void _animateReordering(List<Map<String, dynamic>> moves) {
    // Primeiro, reseta e inicia a animação geral
    _reorderAnimationController.reset();
    _reorderAnimationController.forward();
    
    // Para cada item que mudou de posição, recria o item na lista animada
    for (final move in moves) {
      final String id = move['id'];
      final int from = move['from'];
      final int to = move['to'];
      
      // Encontra o índice atual na lista filtrada
      final currentIndex = _agendaController.filteredUserMicrotasks
          .indexWhere((um) => um.microtaskId == id);
      
      if (currentIndex >= 0) {
        // Obtém os dados necessários para recriar o item
        final userMicrotask = _agendaController.filteredUserMicrotasks[currentIndex];
        final microtask = _agendaController.getMicrotaskById(userMicrotask.microtaskId);
        final task = microtask != null
            ? _agendaController.getTaskById(microtask.taskId)
            : null;
        
        // Força a reconstrução do item com animação
        if (_listKey.currentState != null) {
          // Determina a direção do movimento (para cima ou para baixo)
          final bool movingUp = to < from;
          final Offset beginOffset = movingUp 
              ? const Offset(0.0, -1.0)  // Move para cima
              : const Offset(0.0, 1.0);  // Move para baixo
          
          // Recria o item com animação
          _listKey.currentState!.insertItem(
            currentIndex,
            duration: const Duration(milliseconds: 500),
          );
        }
      }
    }
  }

  Future<void> _handleStatusChange(
    AgendaController controller,
    UserMicrotaskModel userMicrotask,
    UserMicrotaskStatus newStatus,
  ) async {
    // Encontra o índice atual do item na lista
    final currentIndex = controller.filteredUserMicrotasks
        .indexWhere((um) => um.microtaskId == userMicrotask.microtaskId);
    
    if (currentIndex >= 0) {
      // Executa animação de feedback visual antes da atualização
      _reorderAnimationController.reset();
      _reorderAnimationController.forward();
      
      // Prepara o item para animação de saída se o status vai mudar
      // (isso vai fazer o item "deslizar" para fora antes de reaparecer na nova posição)
      if (_listKey.currentState != null && userMicrotask.status != newStatus) {
        // Determina a direção da animação baseada na mudança de status
        final bool movingUp = _getStatusPriority(newStatus) < _getStatusPriority(userMicrotask.status);
        
        // Animação de saída
        _listKey.currentState!.removeItem(
          currentIndex,
          (context, animation) => SlideTransition(
            position: animation.drive(
              Tween(begin: Offset.zero, end: movingUp ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0))
                .chain(CurveTween(curve: Curves.easeInCubic)),
            ),
            child: FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation.drive(
                  Tween(begin: 1.0, end: 0.8)
                    .chain(CurveTween(curve: Curves.easeInCubic)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
                  child: MicrotaskAgendaCard(
                    userMicrotask: userMicrotask,
                    microtask: controller.getMicrotaskById(userMicrotask.microtaskId),
                    task: controller.getTaskById(
                      controller.getMicrotaskById(userMicrotask.microtaskId)?.taskId ?? ''),
                    onStatusChanged: (newStatus) =>
                        _handleStatusChange(controller, userMicrotask, newStatus),
                  ),
                ),
              ),
            ),
          ),
          duration: const Duration(milliseconds: 300),
        );
      }
    }
    
    // Atualiza o status no backend
    final success = await controller.updateUserMicrotaskStatus(
      userId: userMicrotask.userId,
      microtaskId: userMicrotask.microtaskId,
      status: newStatus,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.errorMessage ?? 'Erro ao atualizar status'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
  
  /// Retorna a prioridade numérica do status para determinar a direção da animação
  int _getStatusPriority(UserMicrotaskStatus status) {
    switch (status) {
      case UserMicrotaskStatus.assigned:
        return 1;
      case UserMicrotaskStatus.inProgress:
        return 2;
      case UserMicrotaskStatus.completed:
        return 3;
      default:
        return 0;
    }
  }
}
