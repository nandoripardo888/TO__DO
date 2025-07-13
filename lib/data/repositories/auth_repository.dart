import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_constants.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Repositório responsável por gerenciar dados de autenticação
/// Combina Firebase Auth com Firestore para persistir dados do usuário
class AuthRepository {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Referência para a coleção de usuários no Firestore
  CollectionReference get _usersCollection => 
      _firestore.collection(AppConstants.usersCollection);

  /// Stream que monitora mudanças no estado de autenticação
  Stream<UserModel?> get authStateChanges {
    return _authService.authStateChanges.asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      
      try {
        // Busca os dados completos do usuário no Firestore
        final userDoc = await _usersCollection.doc(firebaseUser.uid).get();
        
        if (userDoc.exists) {
          return UserModel.fromFirestore(userDoc);
        } else {
          // Se não existe no Firestore, cria um novo registro
          final userModel = UserModel.fromGoogleSignIn(
            uid: firebaseUser.uid,
            name: firebaseUser.displayName ?? '',
            email: firebaseUser.email ?? '',
            photoUrl: firebaseUser.photoURL,
          );
          
          await _saveUserToFirestore(userModel);
          return userModel;
        }
      } catch (e) {
        // Em caso de erro, retorna dados básicos do Firebase Auth
        return _authService.firebaseUserToUserModel(firebaseUser);
      }
    });
  }

  /// Retorna o usuário atual
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = _authService.currentUser;
      if (firebaseUser == null) return null;

      final userDoc = await _usersCollection.doc(firebaseUser.uid).get();
      
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      }
      
      return null;
    } catch (e) {
      throw FirestoreException('Erro ao buscar usuário atual', originalException: e);
    }
  }

  /// Faz login com email e senha
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const AuthException('Erro ao obter dados do usuário após login');
      }

      // Busca ou cria o usuário no Firestore
      return await _getOrCreateUser(firebaseUser);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Erro durante login', originalException: e);
    }
  }

  /// Cria uma nova conta com email e senha
  Future<UserModel> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const AuthException('Erro ao obter dados do usuário após cadastro');
      }

      // Atualiza o nome no Firebase Auth
      await _authService.updateProfile(displayName: name);

      // Cria o modelo do usuário
      final userModel = UserModel.fromRegistration(
        uid: firebaseUser.uid,
        name: name,
        email: email,
      );

      // Salva no Firestore
      await _saveUserToFirestore(userModel);

      return userModel;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Erro durante cadastro', originalException: e);
    }
  }

  /// Faz login com Google
  Future<UserModel> signInWithGoogle() async {
    try {
      final credential = await _authService.signInWithGoogle();
      
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const AuthException('Erro ao obter dados do usuário após login com Google');
      }

      // Busca ou cria o usuário no Firestore
      return await _getOrCreateUser(firebaseUser);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Erro durante login com Google', originalException: e);
    }
  }

  /// Faz logout
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      throw AuthException('Erro durante logout', originalException: e);
    }
  }

  /// Envia email de redefinição de senha
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Erro ao enviar email de redefinição', originalException: e);
    }
  }

  /// Atualiza os dados do usuário
  Future<UserModel> updateUser(UserModel user) async {
    try {
      final updatedUser = user.withUpdatedTimestamp();
      
      // Atualiza no Firestore
      await _usersCollection.doc(user.id).update(updatedUser.toFirestore());
      
      // Atualiza no Firebase Auth se necessário
      final currentFirebaseUser = _authService.currentUser;
      if (currentFirebaseUser != null) {
        if (currentFirebaseUser.displayName != user.name) {
          await _authService.updateProfile(
            displayName: user.name,
            photoURL: user.photoUrl,
          );
        }
      }

      return updatedUser;
    } catch (e) {
      throw FirestoreException('Erro ao atualizar usuário', originalException: e);
    }
  }

  /// Deleta a conta do usuário
  Future<void> deleteAccount() async {
    try {
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        throw const AuthException('Usuário não está logado');
      }

      // Remove do Firestore
      await _usersCollection.doc(currentUser.uid).delete();
      
      // Remove do Firebase Auth
      await _authService.deleteAccount();
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Erro ao deletar conta', originalException: e);
    }
  }

  /// Busca um usuário por ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final userDoc = await _usersCollection.doc(userId).get();
      
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      }
      
      return null;
    } catch (e) {
      throw FirestoreException('Erro ao buscar usuário por ID', originalException: e);
    }
  }

  /// Busca um usuário por email
  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final querySnapshot = await _usersCollection
          .where('email', isEqualTo: email.trim().toLowerCase())
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        return UserModel.fromFirestore(querySnapshot.docs.first);
      }
      
      return null;
    } catch (e) {
      throw FirestoreException('Erro ao buscar usuário por email', originalException: e);
    }
  }

  /// Verifica se um email já está em uso
  Future<bool> isEmailInUse(String email) async {
    try {
      final user = await getUserByEmail(email);
      return user != null;
    } catch (e) {
      throw FirestoreException('Erro ao verificar email', originalException: e);
    }
  }

  /// Busca ou cria um usuário no Firestore baseado no Firebase User
  Future<UserModel> _getOrCreateUser(User firebaseUser) async {
    try {
      final userDoc = await _usersCollection.doc(firebaseUser.uid).get();
      
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      } else {
        // Cria um novo usuário no Firestore
        final userModel = UserModel.fromGoogleSignIn(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          photoUrl: firebaseUser.photoURL,
        );
        
        await _saveUserToFirestore(userModel);
        return userModel;
      }
    } catch (e) {
      throw FirestoreException('Erro ao buscar ou criar usuário', originalException: e);
    }
  }

  /// Salva um usuário no Firestore
  Future<void> _saveUserToFirestore(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).set(user.toFirestore());
    } catch (e) {
      throw FirestoreException('Erro ao salvar usuário no Firestore', originalException: e);
    }
  }

  /// Verifica se há um usuário logado
  bool get isLoggedIn => _authService.isLoggedIn;

  /// Retorna o ID do usuário atual
  String? get currentUserId => _authService.currentUserId;

  /// Envia email de verificação
  Future<void> sendEmailVerification() async {
    try {
      await _authService.sendEmailVerification();
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Erro ao enviar verificação de email', originalException: e);
    }
  }

  /// Verifica se o email está verificado
  bool get isEmailVerified => _authService.isEmailVerified;
}
