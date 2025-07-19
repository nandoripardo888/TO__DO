/// Classe base para todas as exceções personalizadas da aplicação
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  const AppException(this.message, {this.code, this.originalException});

  @override
  String toString() => 'AppException: $message';
}

/// Exceções relacionadas à autenticação
class AuthException extends AppException {
  const AuthException(super.message, {super.code, super.originalException});

  @override
  String toString() => 'AuthException: $message';
}

/// Exceções relacionadas à rede/conectividade
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.originalException});

  @override
  String toString() => 'NetworkException: $message';
}

/// Exceções relacionadas ao Firestore
class FirestoreException extends AppException {
  const FirestoreException(
    super.message, {
    super.code,
    super.originalException,
  });

  @override
  String toString() => 'FirestoreException: $message';
}

/// Exceções relacionadas à validação de dados
class ValidationException extends AppException {
  const ValidationException(
    super.message, {
    super.code,
    super.originalException,
  });

  @override
  String toString() => 'ValidationException: $message';
}

/// Exceções relacionadas a campanhas
class EventException extends AppException {
  const EventException(super.message, {super.code, super.originalException});

  @override
  String toString() => 'EventException: $message';
}

/// Exceções relacionadas a tarefas
class TaskException extends AppException {
  const TaskException(super.message, {super.code, super.originalException});

  @override
  String toString() => 'TaskException: $message';
}

/// Exceções relacionadas a voluntários
class VolunteerException extends AppException {
  const VolunteerException(
    super.message, {
    super.code,
    super.originalException,
  });

  @override
  String toString() => 'VolunteerException: $message';
}

/// Exceções relacionadas a permissões
class PermissionException extends AppException {
  const PermissionException(
    super.message, {
    super.code,
    super.originalException,
  });

  @override
  String toString() => 'PermissionException: $message';
}

/// Exceções relacionadas ao cache/storage
class StorageException extends AppException {
  const StorageException(super.message, {super.code, super.originalException});

  @override
  String toString() => 'StorageException: $message';
}

/// Exceções relacionadas ao banco de dados
class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.code, super.originalException});

  @override
  String toString() => 'DatabaseException: $message';
}

/// Exceções relacionadas ao repositório
class RepositoryException extends AppException {
  const RepositoryException(
    super.message, {
    super.code,
    super.originalException,
  });

  @override
  String toString() => 'RepositoryException: $message';
}

/// Exceções relacionadas a operações não encontradas
class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.code, super.originalException});

  @override
  String toString() => 'NotFoundException: $message';
}

/// Exceções relacionadas a operações não autorizadas
class UnauthorizedException extends AppException {
  const UnauthorizedException(
    super.message, {
    super.code,
    super.originalException,
  });

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// Exceções relacionadas a conflitos de dados
class ConflictException extends AppException {
  final String resource;

  const ConflictException(
    this.resource, {
    String? customMessage,
    super.code,
    super.originalException,
  }) : super(customMessage ?? 'Conflict with resource: $resource');

  @override
  String toString() => 'ConflictException: $resource';
}

/// Classe utilitária para tratamento de exceções
class ExceptionHandler {
  /// Converte exceções do Firebase Auth em exceções personalizadas
  static AuthException handleAuthException(dynamic exception) {
    final errorString = exception.toString().toLowerCase();
    String userMessage;
    String? code;

    if (errorString.contains('user-not-found')) {
      userMessage = 'Usuário não encontrado. Verifique o e-mail digitado.';
      code = 'user-not-found';
    } else if (errorString.contains('wrong-password')) {
      userMessage = 'Senha incorreta. Tente novamente ou redefina sua senha.';
      code = 'wrong-password';
    } else if (errorString.contains('email-already-in-use')) {
      userMessage =
          'Este e-mail já está em uso. Tente fazer login ou use outro e-mail.';
      code = 'email-already-in-use';
    } else if (errorString.contains('weak-password')) {
      userMessage = 'Senha muito fraca. Use pelo menos 6 caracteres.';
      code = 'weak-password';
    } else if (errorString.contains('invalid-email')) {
      userMessage = 'E-mail inválido. Verifique o formato do e-mail.';
      code = 'invalid-email';
    } else if (errorString.contains('network-request-failed')) {
      userMessage =
          'Erro de conexão. Verifique sua internet e tente novamente.';
      code = 'network-request-failed';
    } else if (errorString.contains('too-many-requests')) {
      userMessage =
          'Muitas tentativas. Aguarde alguns minutos antes de tentar novamente.';
      code = 'too-many-requests';
    } else if (errorString.contains('user-disabled')) {
      userMessage =
          'Esta conta foi desabilitada. Entre em contato com o suporte.';
      code = 'user-disabled';
    } else if (errorString.contains('operation-not-allowed')) {
      userMessage = 'Operação não permitida. Entre em contato com o suporte.';
      code = 'operation-not-allowed';
    } else if (errorString.contains('invalid-credential')) {
      userMessage = 'Credenciais inválidas. Verifique e-mail e senha.';
      code = 'invalid-credential';
    } else {
      // Para erros não mapeados, inclui a mensagem original
      userMessage =
          'Erro de autenticação: ${_extractFirebaseErrorMessage(exception)}';
      code = 'unknown';
    }

    return AuthException(userMessage, code: code, originalException: exception);
  }

  /// Extrai a mensagem de erro do Firebase de forma mais limpa
  static String _extractFirebaseErrorMessage(dynamic exception) {
    final errorString = exception.toString();

    // Tenta extrair a mensagem entre colchetes ou após dois pontos
    final regex = RegExp(r'\[(.*?)\]|:\s*(.+)$');
    final match = regex.firstMatch(errorString);

    if (match != null) {
      return match.group(1) ?? match.group(2) ?? errorString;
    }

    return errorString;
  }

  /// Converte exceções do Firestore em exceções personalizadas
  static FirestoreException handleFirestoreException(dynamic exception) {
    final errorString = exception.toString().toLowerCase();
    String userMessage;
    String? code;

    if (errorString.contains('permission-denied')) {
      userMessage = 'Permissão negada. Você não tem acesso a este recurso.';
      code = 'permission-denied';
    } else if (errorString.contains('not-found')) {
      userMessage = 'Dados não encontrados. O item pode ter sido removido.';
      code = 'not-found';
    } else if (errorString.contains('already-exists')) {
      userMessage = 'Este item já existe. Tente usar um nome diferente.';
      code = 'already-exists';
    } else if (errorString.contains('unavailable')) {
      userMessage =
          'Serviço temporariamente indisponível. Tente novamente em alguns minutos.';
      code = 'unavailable';
    } else if (errorString.contains('deadline-exceeded')) {
      userMessage =
          'Operação demorou muito para responder. Verifique sua conexão.';
      code = 'deadline-exceeded';
    } else if (errorString.contains('resource-exhausted')) {
      userMessage = 'Limite de uso excedido. Tente novamente mais tarde.';
      code = 'resource-exhausted';
    } else {
      userMessage =
          'Erro no banco de dados: ${_extractFirebaseErrorMessage(exception)}';
      code = 'unknown';
    }

    return FirestoreException(
      userMessage,
      code: code,
      originalException: exception,
    );
  }

  /// Converte exceções de rede em exceções personalizadas
  static NetworkException handleNetworkException(dynamic exception) {
    final errorString = exception.toString().toLowerCase();
    String userMessage;

    if (errorString.contains('timeout')) {
      userMessage =
          'Conexão expirou. Verifique sua internet e tente novamente.';
    } else if (errorString.contains('host lookup failed')) {
      userMessage =
          'Não foi possível conectar ao servidor. Verifique sua internet.';
    } else if (errorString.contains('connection refused')) {
      userMessage = 'Servidor indisponível. Tente novamente mais tarde.';
    } else {
      userMessage =
          'Erro de conexão: ${_extractFirebaseErrorMessage(exception)}';
    }

    return NetworkException(userMessage, originalException: exception);
  }

  /// Método genérico para tratar qualquer exceção
  static AppException handleGenericException(dynamic exception) {
    if (exception is AppException) {
      return exception;
    }

    // Retorna uma exceção concreta em vez da classe abstrata
    return NetworkException(
      'Erro inesperado: ${_extractFirebaseErrorMessage(exception)}',
      originalException: exception,
    );
  }
}
