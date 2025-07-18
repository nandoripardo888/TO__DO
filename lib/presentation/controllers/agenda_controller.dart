import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/models/user_microtask_model.dart';
import '../../data/models/microtask_model.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/user_microtask_repository.dart';
import '../../data/repositories/microtask_repository.dart';
import '../../data/repositories/task_repository.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Estados possíveis do controller da agenda
enum AgendaControllerState { initial, loading, loaded, error }

/// Controller responsável por gerenciar o estado da agenda do voluntário
/// Conforme especificação do PRD - Aba "AGENDA" para Voluntários
class AgendaController extends ChangeNotifier {
  final UserMicrotaskRepository _userMicrotaskRepository;
  final MicrotaskRepository _microtaskRepository;
  final TaskRepository _taskRepository;

  AgendaController({
    UserMicrotaskRepository? userMicrotaskRepository,
    MicrotaskRepository? microtaskRepository,
    TaskRepository? taskRepository,
  }) : _userMicrotaskRepository =
           userMicrotaskRepository ?? UserMicrotaskRepository(),
       _microtaskRepository = microtaskRepository ?? MicrotaskRepository(),
       _taskRepository = taskRepository ?? TaskRepository();

  // Estado atual
  AgendaControllerState _state = AgendaControllerState.initial;
  String? _errorMessage;
  bool _isLoading = false;
  bool _disposed = false;

  // Dados da agenda
  List<UserMicrotaskModel> _userMicrotasks = [];
  final Map<String, MicrotaskModel> _microtasksCache = {};
  final Map<String, TaskModel> _tasksCache = {};

  // Filtros
  UserMicrotaskStatus? _statusFilter;

  // Stream subscription para atualizações em tempo real
  StreamSubscription<List<UserMicrotaskModel>>? _userMicrotasksSubscription;

  // Getters
  AgendaControllerState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  List<UserMicrotaskModel> get userMicrotasks =>
      List.unmodifiable(_userMicrotasks);
  UserMicrotaskStatus? get statusFilter => _statusFilter;

  /// Carrega a agenda do voluntário para um evento específico com atualizações em tempo real
  /// Conforme RN-01.4 e RN-01.5 do PRD
  Future<void> loadAgenda({
    required String userId,
    required String eventId,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Cancela subscription anterior se existir
      await _userMicrotasksSubscription?.cancel();

      // Inicia stream para atualizações em tempo real
      _userMicrotasksSubscription = _userMicrotaskRepository
          .watchUserMicrotasksByEvent(userId: userId, eventId: eventId)
          .listen(
            (userMicrotasks) async {
              final previousMicrotasks = List<UserMicrotaskModel>.from(_userMicrotasks);
              _userMicrotasks = userMicrotasks;

              // Carrega dados das microtasks e tasks relacionadas
              await _loadRelatedData();

              // Detecta se houve mudança de status que requer reordenação
              _detectStatusChanges(previousMicrotasks, userMicrotasks);

              _setState(AgendaControllerState.loaded);
            },
            onError: (error) {
              print('Erro no stream de agenda: ${error.toString()}');
              _setError('Erro ao carregar agenda: ${error.toString()}');
            },
          );
    } on AppException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Erro inesperado ao carregar agenda');
    } finally {
      _setLoading(false);
    }
  }

  /// Atualiza o status de uma microtask do usuário
  /// Conforme RN-03 do PRD - Lógica de Interação do Usuário na Agenda
  Future<bool> updateUserMicrotaskStatus({
    required String userId,
    required String microtaskId,
    required UserMicrotaskStatus status,
    double? actualHours,
    String? notes,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      await _userMicrotaskRepository.updateUserMicrotaskStatus(
        userId: userId,
        microtaskId: microtaskId,
        status: status,
        actualHours: actualHours,
        notes: notes,
      );

      // O stream automaticamente atualizará a lista
      return true;
    } on AppException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado ao atualizar status');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Busca dados da microtask pelo ID (com cache)
  MicrotaskModel? getMicrotaskById(String microtaskId) {
    return _microtasksCache[microtaskId];
  }

  /// Busca dados da task pelo ID (com cache)
  TaskModel? getTaskById(String taskId) {
    return _tasksCache[taskId];
  }

  /// Aplica filtro por status
  void setStatusFilter(UserMicrotaskStatus? status) {
    _statusFilter = status;
    _safeNotifyListeners();
  }

  /// Limpa todos os filtros
  void clearFilters() {
    _statusFilter = null;
    _safeNotifyListeners();
  }

  /// Retorna a lista filtrada e ordenada de user microtasks
  /// Conforme RN-01.5: ordenação por status e data de atribuição
  List<UserMicrotaskModel> get filteredUserMicrotasks {
    List<UserMicrotaskModel> filtered;
    
    if (_statusFilter == null) {
      filtered = List.from(_userMicrotasks);
    } else {
      filtered = _userMicrotasks.where((um) => um.status == _statusFilter).toList();
    }
    
    // Ordena por status (assigned → in_progress → completed) e depois por data de atribuição
    filtered.sort((a, b) {
      // Primeiro critério: status
      final statusOrder = {
        UserMicrotaskStatus.assigned: 1,
        UserMicrotaskStatus.inProgress: 2,
        UserMicrotaskStatus.completed: 3,
      };
      
      final aStatusOrder = statusOrder[a.status] ?? 4;
      final bStatusOrder = statusOrder[b.status] ?? 4;
      
      if (aStatusOrder != bStatusOrder) {
        return aStatusOrder.compareTo(bStatusOrder);
      }
      
      // Segundo critério: data de atribuição (mais recente primeiro)
      return b.assignedAt.compareTo(a.assignedAt);
    });
    
    return filtered;
  }

  /// Recarrega a agenda (reinicia o stream)
  Future<void> refresh({
    required String userId,
    required String eventId,
  }) async {
    await loadAgenda(userId: userId, eventId: eventId);
  }

  /// Detecta mudanças de status que requerem reordenação
  void _detectStatusChanges(
    List<UserMicrotaskModel> previousMicrotasks,
    List<UserMicrotaskModel> newMicrotasks,
  ) {
    if (previousMicrotasks.isEmpty) return;
    
    // Cria um mapa para comparação rápida
    final previousMap = {
      for (final um in previousMicrotasks) um.microtaskId: um.status
    };
    
    // Verifica se alguma microtask mudou de status
    for (final newMicrotask in newMicrotasks) {
      final previousStatus = previousMap[newMicrotask.microtaskId];
      if (previousStatus != null && previousStatus != newMicrotask.status) {
        // Status mudou - a lista será reordenada automaticamente pelo getter filteredUserMicrotasks
        print('Status da microtask ${newMicrotask.microtaskId} mudou de $previousStatus para ${newMicrotask.status}');
        break;
      }
    }
  }

  /// Carrega dados relacionados (microtasks e tasks)
  Future<void> _loadRelatedData() async {
    final microtaskIds = _userMicrotasks.map((um) => um.microtaskId).toSet();

    // Carrega microtasks
    for (final microtaskId in microtaskIds) {
      if (!_microtasksCache.containsKey(microtaskId)) {
        final microtask = await _microtaskRepository.getMicrotaskById(
          microtaskId,
        );
        if (microtask != null) {
          _microtasksCache[microtaskId] = microtask;

          // Carrega task pai se não estiver no cache
          if (!_tasksCache.containsKey(microtask.taskId)) {
            final task = await _taskRepository.getTaskById(microtask.taskId);
            if (task != null) {
              _tasksCache[microtask.taskId] = task;
            }
          }
        }
      }
    }
  }

  /// Define o estado de loading
  void _setLoading(bool loading) {
    _isLoading = loading;
    _safeNotifyListeners();
  }

  /// Define o estado
  void _setState(AgendaControllerState newState) {
    _state = newState;
    _safeNotifyListeners();
  }

  /// Define uma mensagem de erro
  void _setError(String message) {
    _errorMessage = message;
    _setState(AgendaControllerState.error);
  }

  /// Limpa a mensagem de erro
  void _clearError() {
    _errorMessage = null;
  }

  /// Limpa todos os dados
  void clear() {
    _userMicrotasks.clear();
    _microtasksCache.clear();
    _tasksCache.clear();
    _statusFilter = null;
    _state = AgendaControllerState.initial;
    _errorMessage = null;
    _isLoading = false;
    _safeNotifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _userMicrotasksSubscription?.cancel();
    super.dispose();
  }

  void _safeNotifyListeners() {
    if (!_disposed) notifyListeners();
  }
}
