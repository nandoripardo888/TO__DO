import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/models/task_model.dart';
import '../../data/models/microtask_model.dart';
import '../../data/models/user_microtask_model.dart';
import '../../data/models/volunteer_profile_model.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/repositories/microtask_repository.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Estados possíveis do controller de tasks
enum TaskControllerState { initial, loading, loaded, error }

/// Controller responsável por gerenciar o estado das tasks e microtasks
class TaskController extends ChangeNotifier {
  final TaskRepository _taskRepository;
  final MicrotaskRepository _microtaskRepository;

  TaskController({
    TaskRepository? taskRepository,
    MicrotaskRepository? microtaskRepository,
  }) : _taskRepository = taskRepository ?? TaskRepository(),
       _microtaskRepository = microtaskRepository ?? MicrotaskRepository();

  // Estado atual
  TaskControllerState _state = TaskControllerState.initial;
  String? _errorMessage;
  bool _isLoading = false;

  // Dados das tasks
  List<TaskModel> _tasks = [];
  final Map<String, List<MicrotaskModel>> _microtasksByTask = {};
  final Map<String, List<UserMicrotaskModel>> _userMicrotasksByMicrotask = {};
  
  // Stream subscriptions para atualizações em tempo real
  StreamSubscription<List<TaskModel>>? _tasksStreamSubscription;
  final Map<String, StreamSubscription<List<UserMicrotaskModel>>> _userMicrotaskStreams = {};

  // Filtros
  TaskStatus? _statusFilter;
  TaskPriority? _priorityFilter;
  String? _creatorFilter;
  MicrotaskStatus? _microtaskStatusFilter;

  // Getters
  TaskControllerState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  List<TaskModel> get tasks => List.unmodifiable(_tasks);
  Map<String, List<MicrotaskModel>> get microtasksByTask =>
      Map.unmodifiable(_microtasksByTask);
  Map<String, List<UserMicrotaskModel>> get userMicrotasksByMicrotask =>
      Map.unmodifiable(_userMicrotasksByMicrotask);

  // Getters de filtros
  TaskStatus? get statusFilter => _statusFilter;
  TaskPriority? get priorityFilter => _priorityFilter;
  String? get creatorFilter => _creatorFilter;
  MicrotaskStatus? get microtaskStatusFilter => _microtaskStatusFilter;

  /// Carrega todas as tasks de uma campanha com stream de atualização automática
  Future<void> loadTasksByEventId(String eventId) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Cancela streams anteriores se existirem
      await _cancelAllStreams();

      // Inicia stream das tasks
      _tasksStreamSubscription = _taskRepository.watchTasksByEventId(eventId).listen(
        (tasks) async {
          _tasks = tasks;
          
          // Carrega microtasks para cada task
          await _loadMicrotasksForTasks();
          
          // Inicia streams de user_microtasks para atualização automática do progresso
          await _setupUserMicrotaskStreams(eventId);
          
          _setState(TaskControllerState.loaded);
        },
        onError: (error) {
          print('Erro no stream de tasks: ${error.toString()}');
          _setError('Erro ao carregar tasks: ${error.toString()}');
        },
      );
    } on AppException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Erro inesperado ao carregar tasks');
    } finally {
      _setLoading(false);
    }
  }

  /// Carrega tasks com filtros
  Future<void> loadTasksWithFilters({
    required String eventId,
    TaskStatus? status,
    TaskPriority? priority,
    String? createdBy,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      _statusFilter = status;
      _priorityFilter = priority;
      _creatorFilter = createdBy;

      final tasks = await _taskRepository.getTasksWithFilters(
        eventId: eventId,
        status: status,
        priority: priority,
        createdBy: createdBy,
      );
      _tasks = tasks;

      // Carrega microtasks para cada task
      await _loadMicrotasksForTasks();

      _setState(TaskControllerState.loaded);
    } on AppException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Erro inesperado ao carregar tasks com filtros');
    } finally {
      _setLoading(false);
    }
  }

  /// Cria uma nova task
  Future<bool> createTask({
    required String eventId,
    required String title,
    required String description,
    required TaskPriority priority,
    required String createdBy,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      await _taskRepository.createTask(
        eventId: eventId,
        title: title,
        description: description,
        priority: priority,
        createdBy: createdBy,
      );

      // Não adiciona à lista local - o stream irá detectar e atualizar automaticamente
      // Isso evita duplicação visual da task

      _setState(TaskControllerState.loaded);
      return true;
    } on AppException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado ao criar task');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Cria uma nova microtask
  Future<bool> createMicrotask({
    required String taskId,
    required String eventId,
    required String title,
    required String description,
    required List<String> requiredSkills,
    required List<String> requiredResources,
    DateTime? startDateTime,
    DateTime? endDateTime,
    required String priority,
    required int maxVolunteers,
    required String createdBy,
    String? notes,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      await _microtaskRepository.createMicrotask(
        taskId: taskId,
        eventId: eventId,
        title: title,
        description: description,
        requiredSkills: requiredSkills,
        requiredResources: requiredResources,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        priority: priority,
        maxVolunteers: maxVolunteers,
        createdBy: createdBy,
        notes: notes,
      );

      // Não adiciona à lista local - o stream irá detectar e atualizar automaticamente
      // Isso evita duplicação visual da microtask

      // Atualiza contador da task pai
      await _taskRepository.incrementMicrotaskCount(taskId);
      await _refreshTask(taskId);

      // Se a task estava como 'completed', muda para 'in_progress'
      final task = _tasks.where((t) => t.id == taskId).isNotEmpty
          ? _tasks.firstWhere((t) => t.id == taskId)
          : null;
      if (task != null && task.status == TaskStatus.completed) {
        await _taskRepository.updateTaskStatus(taskId, TaskStatus.inProgress);
        await _refreshTask(taskId);
      }

      _setState(TaskControllerState.loaded);
      return true;
    } on AppException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado ao criar microtask');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Atribui um voluntário a uma microtask
  Future<bool> assignVolunteerToMicrotask({
    required String microtaskId,
    required String userId,
    required String eventId,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      print("ABACAXIA1: assinando microtask");
      final updatedMicrotask = await _microtaskRepository.assignVolunteer(
        microtaskId: microtaskId,
        userId: userId,
        eventId: eventId,
      );

      // Atualiza na lista local
      _updateMicrotaskInList(updatedMicrotask);

      // Carrega relações usuário-microtask
      await _loadUserMicrotasksForMicrotask(microtaskId);

      _setState(TaskControllerState.loaded);
      return true;
    } on AppException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado ao atribuir voluntário');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Remove um voluntário de uma microtask
  Future<bool> unassignVolunteerFromMicrotask({
    required String microtaskId,
    required String userId,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final updatedMicrotask = await _microtaskRepository.unassignVolunteer(
        microtaskId: microtaskId,
        userId: userId,
      );

      // Atualiza na lista local
      _updateMicrotaskInList(updatedMicrotask);

      // Carrega relações usuário-microtask
      await _loadUserMicrotasksForMicrotask(microtaskId);

      _setState(TaskControllerState.loaded);
      return true;
    } on AppException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado ao remover voluntário');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Busca voluntários compatíveis com uma microtask
  Future<List<VolunteerProfileModel>> getCompatibleVolunteers({
    required String eventId,
    required String microtaskId,
  }) async {
    try {
      return await _microtaskRepository.getCompatibleVolunteers(
        eventId: eventId,
        microtaskId: microtaskId,
      );
    } on AppException catch (e) {
      _setError(e.message);
      return [];
    } catch (e) {
      _setError('Erro inesperado ao buscar voluntários compatíveis');
      return [];
    }
  }

  /// Atualiza o status individual de um usuário em uma microtask
  /// Utiliza Cloud Functions para garantir validação e propagação automática
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

      // Usa Cloud Functions para operações críticas de atualização de status
      final success = await _microtaskRepository
          .updateUserMicrotaskStatusWithCloudFunction(
            userId: userId,
            microtaskId: microtaskId,
            status: status,
          );

      if (!success) {
        _setError('Falha ao atualizar status da microtask');
        return false;
      }

      // Recarrega dados locais após atualização via Cloud Functions
      await _loadUserMicrotasksForMicrotask(microtaskId);
      
      final microtask = await _microtaskRepository.getMicrotaskById(
        microtaskId,
      );
      if (microtask != null) {
        _updateMicrotaskInList(microtask);
        await _refreshTask(microtask.taskId);
      }

      _setState(TaskControllerState.loaded);
      return true;
    } on AppException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado ao atualizar status do usuário');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Busca microtasks de uma task específica
  List<MicrotaskModel> getMicrotasksByTaskId(String taskId) {
    return _microtasksByTask[taskId] ?? [];
  }

  /// Busca relações usuário-microtask de uma microtask específica
  List<UserMicrotaskModel> getUserMicrotasksByMicrotaskId(String microtaskId) {
    return _userMicrotasksByMicrotask[microtaskId] ?? [];
  }

  /// Limpa os filtros
  void clearFilters() {
    _statusFilter = null;
    _priorityFilter = null;
    _creatorFilter = null;
    _microtaskStatusFilter = null;
    notifyListeners();
  }

  /// Aplica filtro de status de microtask
  void setMicrotaskStatusFilter(MicrotaskStatus? status) {
    _microtaskStatusFilter = status;
    notifyListeners();
  }

  /// Aplica filtro de status de task
  void setStatusFilter(TaskStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  /// Aplica filtro de prioridade de task
  void setPriorityFilter(TaskPriority? priority) {
    _priorityFilter = priority;
    notifyListeners();
  }

  /// Aplica filtro de criador de task
  void setCreatorFilter(String? creator) {
    _creatorFilter = creator;
    notifyListeners();
  }

  /// Retorna tasks filtradas baseado nos filtros ativos
  List<TaskModel> getFilteredTasks() {
    List<TaskModel> filtered = List.from(_tasks);

    // Aplicar filtro de status
    if (_statusFilter != null) {
      filtered = filtered.where((task) => task.status == _statusFilter).toList();
    }

    // Aplicar filtro de prioridade
    if (_priorityFilter != null) {
      filtered = filtered.where((task) => task.priority == _priorityFilter).toList();
    }

    // Aplicar filtro de criador
    if (_creatorFilter != null && _creatorFilter!.isNotEmpty) {
      filtered = filtered.where((task) => task.createdBy == _creatorFilter).toList();
    }

    return filtered;
  }

  /// Busca estatísticas das tasks
  Future<Map<String, dynamic>> getTaskStatistics(String eventId) async {
    try {
      return await _taskRepository.getTaskStatistics(eventId);
    } on AppException catch (e) {
      _setError(e.message);
      return {};
    } catch (e) {
      _setError('Erro inesperado ao calcular estatísticas');
      return {};
    }
  }

  /// Carrega microtasks para todas as tasks
  Future<void> _loadMicrotasksForTasks() async {
    _microtasksByTask.clear();

    for (final task in _tasks) {
      final microtasks = await _microtaskRepository.getMicrotasksByTaskId(
        task.id,
      );
      _microtasksByTask[task.id] = microtasks;

      // Carrega relações usuário-microtask para cada microtask
      for (final microtask in microtasks) {
        await _loadUserMicrotasksForMicrotask(microtask.id);
      }
    }
  }

  /// Carrega relações usuário-microtask para uma microtask específica
  Future<void> _loadUserMicrotasksForMicrotask(String microtaskId) async {
    final userMicrotasks = await _microtaskRepository
        .getUserMicrotasksByMicrotaskId(microtaskId);
    _userMicrotasksByMicrotask[microtaskId] = userMicrotasks;
  }

  /// Atualiza uma microtask na lista local
  void _updateMicrotaskInList(MicrotaskModel updatedMicrotask) {
    for (final taskId in _microtasksByTask.keys) {
      final microtasks = _microtasksByTask[taskId]!;
      final index = microtasks.indexWhere((m) => m.id == updatedMicrotask.id);
      if (index != -1) {
        microtasks[index] = updatedMicrotask;
        break;
      }
    }
  }

  /// Recarrega uma task específica
  Future<void> _refreshTask(String taskId) async {
    final task = await _taskRepository.getTaskById(taskId);
    if (task != null) {
      final index = _tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        _tasks[index] = task;
      }
    }
  }

  /// Define o estado de loading
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Define o estado
  void _setState(TaskControllerState state) {
    _state = state;
    notifyListeners();
  }

  /// Define uma mensagem de erro
  void _setError(String message) {
    _errorMessage = message;
    _setState(TaskControllerState.error);
  }

  /// Limpa a mensagem de erro
  void _clearError() {
    _errorMessage = null;
  }

  /// Configura streams de user_microtasks para atualização automática do progresso
  Future<void> _setupUserMicrotaskStreams(String eventId) async {
    // Cancela streams anteriores de user_microtasks
    await _cancelUserMicrotaskStreams();
    
    // Para cada microtask, cria um stream que escuta mudanças nas user_microtasks
    for (final taskId in _microtasksByTask.keys) {
      final microtasks = _microtasksByTask[taskId] ?? [];
      
      for (final microtask in microtasks) {
        // Cria um stream composto que escuta todas as user_microtasks desta microtask
        final streamKey = '${taskId}_${microtask.id}';
        
        _userMicrotaskStreams[streamKey] = _createUserMicrotaskStream(microtask.id)
            .listen(
          (userMicrotasks) async {
            // Atualiza cache local
            _userMicrotasksByMicrotask[microtask.id] = userMicrotasks;
            
            // Recalcula e atualiza o progresso da task automaticamente
            await _updateTaskProgressFromMicrotasks(taskId);
            
            // Notifica listeners sobre a mudança
            notifyListeners();
          },
          onError: (error) {
            print('Erro no stream de user_microtasks para microtask ${microtask.id}: $error');
          },
        );
      }
    }
  }
  
  /// Cria um stream que escuta mudanças nas user_microtasks de uma microtask específica
  Stream<List<UserMicrotaskModel>> _createUserMicrotaskStream(String microtaskId) {
    return _microtaskRepository.getUserMicrotasksByMicrotaskIdStream(microtaskId);
  }
  
  /// Atualiza o progresso de uma task baseado no status das suas microtasks
  Future<void> _updateTaskProgressFromMicrotasks(String taskId) async {
    try {
      final microtasks = _microtasksByTask[taskId] ?? [];
      if (microtasks.isEmpty) return;
      
      int totalMicrotasks = microtasks.length;
      int completedMicrotasks = 0;
      
      // Conta microtasks concluídas baseado nas user_microtasks
      for (final microtask in microtasks) {
        final userMicrotasks = _userMicrotasksByMicrotask[microtask.id] ?? [];
        
        // Uma microtask é considerada concluída se todos os usuários atribuídos completaram
        if (userMicrotasks.isNotEmpty) {
          final allCompleted = userMicrotasks.every((um) => um.status == UserMicrotaskStatus.completed);
          if (allCompleted) {
            completedMicrotasks++;
          }
        }
      }
      
      // Atualiza os contadores da task se necessário
      final currentTask = _tasks.firstWhere((t) => t.id == taskId);
      if (currentTask.microtaskCount != totalMicrotasks || 
          currentTask.completedMicrotasks != completedMicrotasks) {
        
        await _taskRepository.updateMicrotaskCounters(
          taskId: taskId,
          microtaskCount: totalMicrotasks,
          completedMicrotasks: completedMicrotasks,
        );
        
        // Atualiza a task local
        await _refreshTask(taskId);
      }
    } catch (e) {
      print('Erro ao atualizar progresso da task $taskId: $e');
    }
  }
  
  /// Cancela todos os streams ativos
  Future<void> _cancelAllStreams() async {
    await _tasksStreamSubscription?.cancel();
    _tasksStreamSubscription = null;
    
    await _cancelUserMicrotaskStreams();
  }
  
  /// Cancela apenas os streams de user_microtasks
  Future<void> _cancelUserMicrotaskStreams() async {
    for (final subscription in _userMicrotaskStreams.values) {
      await subscription.cancel();
    }
    _userMicrotaskStreams.clear();
  }
  
  /// Pausa as streams para economizar recursos quando a tela não está visível
  void pauseStreams() {
    _tasksStreamSubscription?.pause();
    for (final subscription in _userMicrotaskStreams.values) {
      subscription.pause();
    }
    print('TaskController: streams pausadas');
  }

  /// Retoma as streams quando a tela fica visível novamente
  void resumeStreams() {
    _tasksStreamSubscription?.resume();
    for (final subscription in _userMicrotaskStreams.values) {
      subscription.resume();
    }
    print('TaskController: streams retomadas');
  }

  @override
  void dispose() {
    _cancelAllStreams();
    super.dispose();
  }

  /// Limpa todos os dados
  void clear() {
    _cancelAllStreams();
    _tasks.clear();
    _microtasksByTask.clear();
    _userMicrotasksByMicrotask.clear();
    clearFilters();
    _setState(TaskControllerState.initial);
  }

}
