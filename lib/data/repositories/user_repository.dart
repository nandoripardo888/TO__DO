import '../../core/exceptions/app_exceptions.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

/// Repositório responsável por operações relacionadas a usuários
/// Implementa o padrão Repository para abstrair o acesso aos dados
class UserRepository {
  final UserService _userService;

  UserRepository({UserService? userService}) 
      : _userService = userService ?? UserService();

  /// Busca um usuário pelo ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }

      return await _userService.getUserById(userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar usuário: ${e.toString()}');
    }
  }

  /// Busca múltiplos usuários pelos IDs
  Future<List<UserModel>> getUsersByIds(List<String> userIds) async {
    try {
      if (userIds.isEmpty) {
        return [];
      }

      return await _userService.getUsersByIds(userIds);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar usuários: ${e.toString()}');
    }
  }

  /// Busca usuários por email
  Future<List<UserModel>> searchUsersByEmail(String emailQuery) async {
    try {
      if (emailQuery.isEmpty) {
        return [];
      }

      return await _userService.searchUsersByEmail(emailQuery);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar usuários por email: ${e.toString()}');
    }
  }

  /// Busca usuários por nome
  Future<List<UserModel>> searchUsersByName(String nameQuery) async {
    try {
      if (nameQuery.isEmpty) {
        return [];
      }

      return await _userService.searchUsersByName(nameQuery);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar usuários por nome: ${e.toString()}');
    }
  }

  /// Atualiza informações do usuário
  Future<UserModel> updateUser(UserModel user) async {
    try {
      return await _userService.updateUser(user);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao atualizar usuário: ${e.toString()}');
    }
  }

  /// Cria ou atualiza um usuário
  Future<UserModel> createOrUpdateUser(UserModel user) async {
    try {
      return await _userService.createOrUpdateUser(user);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao criar/atualizar usuário: ${e.toString()}');
    }
  }

  /// Verifica se um usuário existe
  Future<bool> userExists(String userId) async {
    try {
      if (userId.isEmpty) {
        return false;
      }

      return await _userService.userExists(userId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao verificar existência do usuário: ${e.toString()}');
    }
  }

  /// Stream para monitorar mudanças em um usuário
  Stream<UserModel?> watchUser(String userId) {
    try {
      if (userId.isEmpty) {
        return Stream.value(null);
      }

      return _userService.watchUser(userId);
    } catch (e) {
      throw RepositoryException('Erro ao monitorar usuário: ${e.toString()}');
    }
  }

  /// Busca usuários recentes
  Future<List<UserModel>> getRecentUsers({int limit = 10}) async {
    try {
      return await _userService.getRecentUsers(limit: limit);
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar usuários recentes: ${e.toString()}');
    }
  }

  /// Busca usuários com filtro combinado (nome ou email)
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      if (query.isEmpty) {
        return [];
      }

      // Se contém @, busca por email, senão por nome
      if (query.contains('@')) {
        return await searchUsersByEmail(query);
      } else {
        return await searchUsersByName(query);
      }
    } catch (e) {
      if (e is AppException) rethrow;
      throw RepositoryException('Erro ao buscar usuários: ${e.toString()}');
    }
  }
}
