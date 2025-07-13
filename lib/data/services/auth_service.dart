import 'package:firebase_auth/firebase_auth.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../models/user_model.dart';

/// Serviço responsável pela autenticação com Firebase Auth
/// Implementa login com email/senha e Google Sign-In
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  /*caso implemente para ANDROID E IOS */
  //final GoogleSignIn _googleSignIn; = GoogleSignIn();

  /// Retorna o usuário atualmente logado
  User? get currentUser => _firebaseAuth.currentUser;

  /// Stream que monitora mudanças no estado de autenticação
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Verifica se há um usuário logado
  bool get isLoggedIn => currentUser != null;

  /// Retorna o UID do usuário atual
  String? get currentUserId => currentUser?.uid;

  /// Faz login com email e senha
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw ExceptionHandler.handleAuthException(e);
    } catch (e) {
      throw AuthException(
        'Erro inesperado durante o login',
        originalException: e,
      );
    }
  }

  /// Cria uma nova conta com email e senha
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw ExceptionHandler.handleAuthException(e);
    } catch (e) {
      throw AuthException(
        'Erro inesperado durante o cadastro',
        originalException: e,
      );
    }
  }

  /// Faz login com Google (compatível com Web e Mobile)
  Future<UserCredential> signInWithGoogle() async {
    try {
      /* ANDROID E AIOS
      if (kIsWeb) {
     */
      // Fluxo para Web
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // Adiciona escopos se necessário
      googleProvider.addScope('email');
      googleProvider.addScope('profile');

      // Faz login diretamente com popup no web
      final userCredential = await _firebaseAuth.signInWithPopup(
        googleProvider,
      );

      return userCredential;
      /* ANDROID E AIOS
      }
      else {
        // Fluxo para Mobile (Android/iOS)
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          throw const AuthException('Login com Google cancelado pelo usuário');
        }

        // Obtém os detalhes de autenticação
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Cria uma credencial do Firebase
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Faz login no Firebase com a credencial do Google
        final userCredential = await _firebaseAuth.signInWithCredential(
          credential,
        );

        return userCredential;
      }*/
    } on FirebaseAuthException catch (e) {
      throw ExceptionHandler.handleAuthException(e);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(
        'Erro durante login com Google',
        originalException: e,
      );
    }
  }

  /// Faz logout
  Future<void> signOut() async {
    try {
      // Faz logout do Google se estiver logado
      /*ANDROID E AIOS
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      */

      // Faz logout do Firebase
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException('Erro durante logout', originalException: e);
    }
  }

  /// Envia email de redefinição de senha
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw ExceptionHandler.handleAuthException(e);
    } catch (e) {
      throw AuthException(
        'Erro ao enviar email de redefinição',
        originalException: e,
      );
    }
  }

  /// Atualiza o perfil do usuário (nome e foto)
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AuthException('Usuário não está logado');
      }

      await user.updateDisplayName(displayName);
      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }

      // Recarrega o usuário para obter as informações atualizadas
      await user.reload();
    } on FirebaseAuthException catch (e) {
      throw ExceptionHandler.handleAuthException(e);
    } catch (e) {
      throw AuthException('Erro ao atualizar perfil', originalException: e);
    }
  }

  /// Atualiza o email do usuário
  Future<void> updateEmail(String newEmail) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AuthException('Usuário não está logado');
      }

      await user.verifyBeforeUpdateEmail(newEmail.trim());
    } on FirebaseAuthException catch (e) {
      throw ExceptionHandler.handleAuthException(e);
    } catch (e) {
      throw AuthException('Erro ao atualizar email', originalException: e);
    }
  }

  /// Atualiza a senha do usuário
  Future<void> updatePassword(String newPassword) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AuthException('Usuário não está logado');
      }

      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw ExceptionHandler.handleAuthException(e);
    } catch (e) {
      throw AuthException('Erro ao atualizar senha', originalException: e);
    }
  }

  /// Reautentica o usuário com email e senha
  Future<void> reauthenticateWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AuthException('Usuário não está logado');
      }

      final credential = EmailAuthProvider.credential(
        email: email.trim(),
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw ExceptionHandler.handleAuthException(e);
    } catch (e) {
      throw AuthException('Erro durante reautenticação', originalException: e);
    }
  }

  /// Deleta a conta do usuário
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AuthException('Usuário não está logado');
      }

      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw ExceptionHandler.handleAuthException(e);
    } catch (e) {
      throw AuthException('Erro ao deletar conta', originalException: e);
    }
  }

  /// Envia email de verificação
  Future<void> sendEmailVerification() async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AuthException('Usuário não está logado');
      }

      if (user.emailVerified) {
        throw const AuthException('Email já está verificado');
      }

      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw ExceptionHandler.handleAuthException(e);
    } catch (e) {
      throw AuthException(
        'Erro ao enviar verificação de email',
        originalException: e,
      );
    }
  }

  /// Recarrega as informações do usuário atual
  Future<void> reloadUser() async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AuthException('Usuário não está logado');
      }

      await user.reload();
    } catch (e) {
      throw AuthException('Erro ao recarregar usuário', originalException: e);
    }
  }

  /// Converte User do Firebase para UserModel
  UserModel? firebaseUserToUserModel(User? firebaseUser) {
    if (firebaseUser == null) return null;

    return UserModel.fromGoogleSignIn(
      uid: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      photoUrl: firebaseUser.photoURL,
    );
  }

  /// Verifica se o email está verificado
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  /// Retorna informações básicas do usuário atual
  Map<String, dynamic>? get currentUserInfo {
    final user = currentUser;
    if (user == null) return null;

    return {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'emailVerified': user.emailVerified,
      'creationTime': user.metadata.creationTime?.toIso8601String(),
      'lastSignInTime': user.metadata.lastSignInTime?.toIso8601String(),
    };
  }
}
