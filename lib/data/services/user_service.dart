import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../models/user_model.dart';

/// Serviço responsável por operações relacionadas a usuários
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _usersCollection;

  UserService() {
    _usersCollection = _firestore.collection('users');
  }

  /// Busca um usuário pelo ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      if (userId.isEmpty) {
        throw ValidationException('ID do usuário é obrigatório');
      }

      final doc = await _usersCollection.doc(userId).get();
      
      if (!doc.exists) {
        return null;
      }

      return UserModel.fromFirestore(doc);
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Erro ao buscar usuário: ${e.toString()}');
    }
  }

  /// Busca múltiplos usuários pelos IDs
  Future<List<UserModel>> getUsersByIds(List<String> userIds) async {
    try {
      if (userIds.isEmpty) {
        return [];
      }

      // Remove IDs duplicados e vazios
      final cleanIds = userIds.where((id) => id.isNotEmpty).toSet().toList();
      
      if (cleanIds.isEmpty) {
        return [];
      }

      // Firestore tem limite de 10 itens por consulta 'in'
      // Vamos dividir em chunks se necessário
      final users = <UserModel>[];
      const chunkSize = 10;
      
      for (int i = 0; i < cleanIds.length; i += chunkSize) {
        final chunk = cleanIds.skip(i).take(chunkSize).toList();
        
        final querySnapshot = await _usersCollection
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        
        final chunkUsers = querySnapshot.docs
            .map((doc) => UserModel.fromFirestore(doc))
            .toList();
        
        users.addAll(chunkUsers);
      }

      return users;
    } catch (e) {
      throw DatabaseException('Erro ao buscar usuários: ${e.toString()}');
    }
  }

  /// Busca usuários por email (para busca/filtro)
  Future<List<UserModel>> searchUsersByEmail(String emailQuery) async {
    try {
      if (emailQuery.isEmpty) {
        return [];
      }

      // Busca por email que comece com o termo
      final querySnapshot = await _usersCollection
          .where('email', isGreaterThanOrEqualTo: emailQuery.toLowerCase())
          .where('email', isLessThan: '${emailQuery.toLowerCase()}z')
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException('Erro ao buscar usuários por email: ${e.toString()}');
    }
  }

  /// Busca usuários por nome (para busca/filtro)
  Future<List<UserModel>> searchUsersByName(String nameQuery) async {
    try {
      if (nameQuery.isEmpty) {
        return [];
      }

      // Busca por nome que comece com o termo
      final querySnapshot = await _usersCollection
          .where('name', isGreaterThanOrEqualTo: nameQuery)
          .where('name', isLessThan: '${nameQuery}z')
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException('Erro ao buscar usuários por nome: ${e.toString()}');
    }
  }

  /// Atualiza informações do usuário
  Future<UserModel> updateUser(UserModel user) async {
    try {
      final validationErrors = user.validate();
      if (validationErrors.isNotEmpty) {
        throw ValidationException(
          'Dados inválidos: ${validationErrors.join(', ')}',
        );
      }

      await _usersCollection.doc(user.id).update(user.toFirestore());
      
      return user;
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Erro ao atualizar usuário: ${e.toString()}');
    }
  }

  /// Cria ou atualiza um usuário
  Future<UserModel> createOrUpdateUser(UserModel user) async {
    try {
      final validationErrors = user.validate();
      if (validationErrors.isNotEmpty) {
        throw ValidationException(
          'Dados inválidos: ${validationErrors.join(', ')}',
        );
      }

      await _usersCollection.doc(user.id).set(user.toFirestore(), SetOptions(merge: true));
      
      return user;
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Erro ao criar/atualizar usuário: ${e.toString()}');
    }
  }

  /// Verifica se um usuário existe
  Future<bool> userExists(String userId) async {
    try {
      if (userId.isEmpty) {
        return false;
      }

      final doc = await _usersCollection.doc(userId).get();
      return doc.exists;
    } catch (e) {
      throw DatabaseException('Erro ao verificar existência do usuário: ${e.toString()}');
    }
  }

  /// Stream para monitorar mudanças em um usuário
  Stream<UserModel?> watchUser(String userId) {
    if (userId.isEmpty) {
      return Stream.value(null);
    }

    return _usersCollection
        .doc(userId)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return null;
          return UserModel.fromFirestore(doc);
        });
  }

  /// Busca usuários recentes (últimos cadastrados)
  Future<List<UserModel>> getRecentUsers({int limit = 10}) async {
    try {
      final querySnapshot = await _usersCollection
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw DatabaseException('Erro ao buscar usuários recentes: ${e.toString()}');
    }
  }
}
