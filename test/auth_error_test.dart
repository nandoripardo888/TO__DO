import 'package:flutter_test/flutter_test.dart';
import 'package:contask/core/exceptions/app_exceptions.dart';

void main() {
  group('ExceptionHandler Tests', () {
    test('should handle user-not-found error correctly', () {
      final exception = Exception('[firebase_auth/user-not-found] There is no user record corresponding to this identifier.');
      
      final result = ExceptionHandler.handleAuthException(exception);
      
      expect(result, isA<AuthException>());
      expect(result.message, contains('Usuário não encontrado'));
      expect(result.message, contains('Verifique o e-mail digitado'));
      expect(result.code, equals('user-not-found'));
    });

    test('should handle wrong-password error correctly', () {
      final exception = Exception('[firebase_auth/wrong-password] The password is invalid.');
      
      final result = ExceptionHandler.handleAuthException(exception);
      
      expect(result, isA<AuthException>());
      expect(result.message, contains('Senha incorreta'));
      expect(result.message, contains('Tente novamente ou redefina'));
      expect(result.code, equals('wrong-password'));
    });

    test('should handle email-already-in-use error correctly', () {
      final exception = Exception('[firebase_auth/email-already-in-use] The email address is already in use.');
      
      final result = ExceptionHandler.handleAuthException(exception);
      
      expect(result, isA<AuthException>());
      expect(result.message, contains('Este e-mail já está em uso'));
      expect(result.message, contains('Tente fazer login ou use outro e-mail'));
      expect(result.code, equals('email-already-in-use'));
    });

    test('should handle network-request-failed error correctly', () {
      final exception = Exception('[firebase_auth/network-request-failed] A network error occurred.');
      
      final result = ExceptionHandler.handleAuthException(exception);
      
      expect(result, isA<AuthException>());
      expect(result.message, contains('Erro de conexão'));
      expect(result.message, contains('Verifique sua internet'));
      expect(result.code, equals('network-request-failed'));
    });

    test('should handle unknown error with original message', () {
      final exception = Exception('Some unknown firebase error');
      
      final result = ExceptionHandler.handleAuthException(exception);
      
      expect(result, isA<AuthException>());
      expect(result.message, contains('Erro de autenticação'));
      expect(result.code, equals('unknown'));
      expect(result.originalException, equals(exception));
    });

    test('should handle firestore permission-denied error correctly', () {
      final exception = Exception('[cloud_firestore/permission-denied] Missing or insufficient permissions.');
      
      final result = ExceptionHandler.handleFirestoreException(exception);
      
      expect(result, isA<FirestoreException>());
      expect(result.message, contains('Permissão negada'));
      expect(result.message, contains('Você não tem acesso a este recurso'));
      expect(result.code, equals('permission-denied'));
    });

    test('should handle network timeout error correctly', () {
      final exception = Exception('Connection timeout occurred');
      
      final result = ExceptionHandler.handleNetworkException(exception);
      
      expect(result, isA<NetworkException>());
      expect(result.message, contains('Conexão expirou'));
      expect(result.message, contains('Verifique sua internet'));
    });
  });
}
