import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../exceptions/app_exceptions.dart';

/// Classe utilitária para tratamento de erros
class ErrorHandler {
  ErrorHandler._();

  /// Converte exceções do Firebase Auth em mensagens amigáveis
  static String handleFirebaseAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return 'Usuário não encontrado. Verifique o e-mail informado.';
      case 'wrong-password':
        return 'Senha incorreta. Tente novamente.';
      case 'email-already-in-use':
        return 'Este e-mail já está sendo usado por outra conta.';
      case 'weak-password':
        return 'A senha é muito fraca. Use pelo menos 6 caracteres.';
      case 'invalid-email':
        return 'E-mail inválido. Verifique o formato do e-mail.';
      case 'user-disabled':
        return 'Esta conta foi desabilitada. Entre em contato com o suporte.';
      case 'too-many-requests':
        return 'Muitas tentativas de login. Tente novamente mais tarde.';
      case 'operation-not-allowed':
        return 'Operação não permitida. Entre em contato com o suporte.';
      case 'invalid-credential':
        return 'Credenciais inválidas. Verifique e-mail e senha.';
      case 'account-exists-with-different-credential':
        return 'Já existe uma conta com este e-mail usando outro método de login.';
      case 'requires-recent-login':
        return 'Esta operação requer login recente. Faça login novamente.';
      case 'network-request-failed':
        return 'Erro de conexão. Verifique sua internet e tente novamente.';
      default:
        return 'Erro de autenticação: ${error.message ?? 'Erro desconhecido'}';
    }
  }

  /// Converte exceções do Firestore em mensagens amigáveis
  static String handleFirestoreError(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return 'Você não tem permissão para realizar esta operação.';
      case 'not-found':
        return 'Documento não encontrado.';
      case 'already-exists':
        return 'Este documento já existe.';
      case 'resource-exhausted':
        return 'Limite de operações excedido. Tente novamente mais tarde.';
      case 'failed-precondition':
        return 'Operação não pode ser realizada no estado atual.';
      case 'aborted':
        return 'Operação foi cancelada devido a conflito.';
      case 'out-of-range':
        return 'Parâmetros fora do intervalo válido.';
      case 'unimplemented':
        return 'Operação não implementada.';
      case 'internal':
        return 'Erro interno do servidor. Tente novamente.';
      case 'unavailable':
        return 'Serviço temporariamente indisponível. Tente novamente.';
      case 'data-loss':
        return 'Perda de dados detectada. Entre em contato com o suporte.';
      case 'unauthenticated':
        return 'Você precisa estar logado para realizar esta operação.';
      case 'deadline-exceeded':
        return 'Operação demorou muito para ser concluída. Tente novamente.';
      case 'cancelled':
        return 'Operação foi cancelada.';
      case 'invalid-argument':
        return 'Parâmetros inválidos fornecidos.';
      default:
        return 'Erro do banco de dados: ${error.message ?? 'Erro desconhecido'}';
    }
  }

  /// Converte exceções personalizadas da aplicação em mensagens amigáveis
  static String handleAppException(AppException error) {
    switch (error.runtimeType) {
      case ValidationException:
        return error.message;
      case NotFoundException:
        return error.message;
      case UnauthorizedException:
        return error.message;
      case DatabaseException:
        return 'Erro de banco de dados. Tente novamente.';
      case NetworkException:
        return 'Erro de conexão. Verifique sua internet e tente novamente.';
      case StorageException:
        return 'Erro de armazenamento. Tente novamente.';
      case RepositoryException:
        return 'Erro interno. Tente novamente.';
      default:
        return error.message;
    }
  }

  /// Método principal para tratar qualquer tipo de erro
  static String handleError(dynamic error) {
    if (error is FirebaseAuthException) {
      return handleFirebaseAuthError(error);
    } else if (error is FirebaseException) {
      return handleFirestoreError(error);
    } else if (error is AppException) {
      return handleAppException(error);
    } else if (error is Exception) {
      return 'Erro inesperado: ${error.toString()}';
    } else {
      return 'Erro desconhecido. Tente novamente.';
    }
  }

  /// Verifica se o erro é relacionado à rede
  static bool isNetworkError(dynamic error) {
    if (error is FirebaseAuthException) {
      return error.code == 'network-request-failed';
    } else if (error is FirebaseException) {
      return error.code == 'unavailable' || error.code == 'deadline-exceeded';
    } else if (error is NetworkException) {
      return true;
    }
    return false;
  }

  /// Verifica se o erro é relacionado à autenticação
  static bool isAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      return true;
    } else if (error is FirebaseException) {
      return error.code == 'unauthenticated';
    } else if (error is UnauthorizedException) {
      return true;
    }
    return false;
  }

  /// Verifica se o erro é relacionado à validação
  static bool isValidationError(dynamic error) {
    return error is ValidationException ||
        (error is FirebaseException && error.code == 'invalid-argument');
  }

  /// Verifica se o erro é temporário (pode ser resolvido tentando novamente)
  static bool isTemporaryError(dynamic error) {
    if (error is FirebaseAuthException) {
      return error.code == 'too-many-requests' || 
             error.code == 'network-request-failed';
    } else if (error is FirebaseException) {
      return error.code == 'unavailable' || 
             error.code == 'deadline-exceeded' ||
             error.code == 'resource-exhausted' ||
             error.code == 'aborted';
    } else if (error is NetworkException) {
      return true;
    }
    return false;
  }

  /// Gera sugestões de ação baseadas no tipo de erro
  static List<String> getErrorSuggestions(dynamic error) {
    final suggestions = <String>[];

    if (isNetworkError(error)) {
      suggestions.addAll([
        'Verifique sua conexão com a internet',
        'Tente novamente em alguns segundos',
        'Verifique se o Wi-Fi está funcionando',
      ]);
    } else if (isAuthError(error)) {
      suggestions.addAll([
        'Faça login novamente',
        'Verifique suas credenciais',
        'Entre em contato com o suporte se o problema persistir',
      ]);
    } else if (isValidationError(error)) {
      suggestions.addAll([
        'Verifique os dados informados',
        'Certifique-se de preencher todos os campos obrigatórios',
        'Verifique o formato dos dados',
      ]);
    } else if (isTemporaryError(error)) {
      suggestions.addAll([
        'Tente novamente em alguns minutos',
        'Verifique sua conexão',
        'Entre em contato com o suporte se o problema persistir',
      ]);
    } else {
      suggestions.addAll([
        'Tente novamente',
        'Reinicie o aplicativo se necessário',
        'Entre em contato com o suporte se o problema persistir',
      ]);
    }

    return suggestions;
  }

  /// Registra o erro para análise (pode ser expandido para usar serviços como Crashlytics)
  static void logError(dynamic error, {StackTrace? stackTrace, Map<String, dynamic>? context}) {
    // Por enquanto, apenas imprime no console
    // Em produção, isso deveria enviar para um serviço de monitoramento
    print('ERROR: $error');
    if (stackTrace != null) {
      print('STACK TRACE: $stackTrace');
    }
    if (context != null) {
      print('CONTEXT: $context');
    }
  }

  /// Cria uma mensagem de erro formatada para exibição
  static String formatErrorMessage(dynamic error, {String? context}) {
    final message = handleError(error);
    
    if (context != null) {
      return '$context: $message';
    }
    
    return message;
  }

  /// Verifica se deve mostrar detalhes técnicos do erro (apenas em desenvolvimento)
  static bool shouldShowTechnicalDetails() {
    // Em produção, isso deveria retornar false
    // Por enquanto, sempre mostra detalhes para facilitar o desenvolvimento
    return true;
  }

  /// Cria uma mensagem de erro com detalhes técnicos (se apropriado)
  static String createDetailedErrorMessage(dynamic error, {String? userMessage}) {
    final baseMessage = userMessage ?? handleError(error);
    
    if (shouldShowTechnicalDetails()) {
      return '$baseMessage\n\nDetalhes técnicos: ${error.toString()}';
    }
    
    return baseMessage;
  }
}
