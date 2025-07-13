import 'package:flutter/foundation.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

/// Estados possíveis da autenticação
enum AuthState { initial, loading, authenticated, unauthenticated, error }

/// Controller responsável por gerenciar o estado de autenticação
/// Usa Provider para notificar mudanças na UI
class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  // Estado atual
  AuthState _state = AuthState.initial;
  UserModel? _currentUser;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  AuthState get state => _state;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated =>
      _state == AuthState.authenticated && _currentUser != null;
  bool get isUnauthenticated => _state == AuthState.unauthenticated;

  /// Inicializa o controller e monitora mudanças de autenticação
  void initialize() {
    _authRepository.authStateChanges.listen(
      (user) {
        _currentUser = user;
        if (user != null) {
          _setState(AuthState.authenticated);
        } else {
          _setState(AuthState.unauthenticated);
        }
      },
      onError: (error) {
        _setError('Erro ao monitorar autenticação: ${error.toString()}');
      },
    );
  }

  /// Faz login com email e senha
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final user = await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _currentUser = user;
      _setState(AuthState.authenticated);
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado durante o login');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Cria uma nova conta com email e senha
  Future<bool> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final user = await _authRepository.createUserWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );

      _currentUser = user;
      _setState(AuthState.authenticated);
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado durante o cadastro');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Faz login com Google
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();

      final user = await _authRepository.signInWithGoogle();

      _currentUser = user;
      _setState(AuthState.authenticated);
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado durante o login com Google');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Faz logout
  Future<void> signOut() async {
    try {
      _setLoading(true);
      _clearError();

      await _authRepository.signOut();

      _currentUser = null;
      _setState(AuthState.unauthenticated);
    } on AuthException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Erro inesperado durante o logout');
    } finally {
      _setLoading(false);
    }
  }

  /// Envia email de redefinição de senha
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      _setLoading(true);
      _clearError();

      await _authRepository.sendPasswordResetEmail(email);
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado ao enviar email de redefinição');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Atualiza os dados do usuário
  Future<bool> updateUser(UserModel updatedUser) async {
    try {
      _setLoading(true);
      _clearError();

      final user = await _authRepository.updateUser(updatedUser);
      _currentUser = user;
      notifyListeners();
      return true;
    } on FirestoreException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado ao atualizar usuário');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Deleta a conta do usuário
  Future<bool> deleteAccount() async {
    try {
      _setLoading(true);
      _clearError();

      await _authRepository.deleteAccount();

      _currentUser = null;
      _setState(AuthState.unauthenticated);
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado ao deletar conta');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Envia email de verificação
  Future<bool> sendEmailVerification() async {
    try {
      _setLoading(true);
      _clearError();

      await _authRepository.sendEmailVerification();
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Erro inesperado ao enviar verificação de email');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Recarrega os dados do usuário atual
  Future<void> refreshUser() async {
    try {
      if (_currentUser == null) return;

      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro ao recarregar usuário: $e');
    }
  }

  /// Verifica se um email já está em uso
  Future<bool> isEmailInUse(String email) async {
    try {
      return await _authRepository.isEmailInUse(email);
    } catch (e) {
      debugPrint('Erro ao verificar email: $e');
      return false;
    }
  }

  /// Define o estado de loading
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Define um erro
  void _setError(String error) {
    _errorMessage = error;
    _state = AuthState.error;
    notifyListeners();
  }

  /// Limpa o erro atual
  void _clearError() {
    _errorMessage = null;
    if (_state == AuthState.error) {
      _state = _currentUser != null
          ? AuthState.authenticated
          : AuthState.unauthenticated;
    }
    notifyListeners();
  }

  /// Define o estado atual
  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Limpa o erro manualmente (para ser chamado da UI)
  void clearError() {
    _clearError();
  }

  /// Verifica se o email está verificado
  bool get isEmailVerified => _authRepository.isEmailVerified;

  /// Retorna informações básicas do usuário para debug
  Map<String, dynamic>? get userInfo {
    if (_currentUser == null) return null;

    return {
      'id': _currentUser!.id,
      'name': _currentUser!.name,
      'email': _currentUser!.email,
      'hasPhoto': _currentUser!.hasPhoto,
      'isNewUser': _currentUser!.isNewUser,
    };
  }

  /// Método para validar dados antes de operações
  bool _validateUserData({String? name, String? email, String? password}) {
    if (name != null && name.trim().isEmpty) {
      _setError('Nome é obrigatório');
      return false;
    }

    if (email != null && email.trim().isEmpty) {
      _setError('E-mail é obrigatório');
      return false;
    }

    if (email != null && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _setError('E-mail inválido');
      return false;
    }

    if (password != null && password.length < 6) {
      _setError('Senha deve ter pelo menos 6 caracteres');
      return false;
    }

    return true;
  }

  /// Método de conveniência para login com validação
  Future<bool> signInWithValidation({
    required String email,
    required String password,
  }) async {
    if (!_validateUserData(email: email, password: password)) {
      return false;
    }

    return await signInWithEmailAndPassword(email: email, password: password);
  }

  /// Método de conveniência para cadastro com validação
  Future<bool> createUserWithValidation({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!_validateUserData(name: name, email: email, password: password)) {
      return false;
    }

    return await createUserWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
    );
  }
}
