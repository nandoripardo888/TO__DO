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

  /// Carrega todas as tasks de um evento
  Future<void> loadTasksByEventId(String eventId) async {
    try {
      _setLoading(true);
      _clearError();

      final tasks = await _taskRepository.getTasksByEventId(eventId);
      _tasks = tasks;

      // Carrega microtasks para cada task
      await _loadMicrotasksForTasks();

      _setState(TaskControllerState.loaded);
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

      final task = await _taskRepository.createTask(
        eventId: eventId,
        title: title,
        description: description,
        priority: priority,
        createdBy: createdBy,
      );

      // Adiciona à lista local
      _tasks.add(task);
      _microtasksByTask[task.id] = [];

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

      final microtask = await _microtaskRepository.createMicrotask(
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

      // Adiciona à lista local
      if (_microtasksByTask.containsKey(taskId)) {
        _microtasksByTask[taskId]!.add(microtask);
      } else {
        _microtasksByTask[taskId] = [microtask];
      }

      // Atualiza contador da task pai
      await _taskRepository.incrementMicrotaskCount(taskId);
      await _refreshTask(taskId);

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

      final updatedUserMicrotask = await _microtaskRepository
          .updateUserMicrotaskStatus(
            userId: userId,
            microtaskId: microtaskId,
            status: status,
            actualHours: actualHours,
            notes: notes,
          );

      // Atualiza na lista local
      if (_userMicrotasksByMicrotask.containsKey(microtaskId)) {
        final index = _userMicrotasksByMicrotask[microtaskId]!.indexWhere(
          (um) => um.userId == userId,
        );
        if (index != -1) {
          _userMicrotasksByMicrotask[microtaskId]![index] =
              updatedUserMicrotask;
        }
      }

      // Recarrega a microtask para pegar status atualizado
      final microtask = await _microtaskRepository.getMicrotaskById(
        microtaskId,
      );
      if (microtask != null) {
        _updateMicrotaskInList(microtask);
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

  /// Limpa todos os dados
  void clear() {
    _tasks.clear();
    _microtasksByTask.clear();
    _userMicrotasksByMicrotask.clear();
    clearFilters();
    _setState(TaskControllerState.initial);
  }
}
