import '../constants/app_constants.dart';

/// Classe utilitária para validações de formulários
class Validators {
  /// Valida se o email tem formato válido
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-mail é obrigatório';
    }

    final emailRegex = RegExp(AppConstants.emailPattern);
    if (!emailRegex.hasMatch(value)) {
      return 'E-mail inválido';
    }

    return null;
  }

  /// Valida senha
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < AppConstants.passwordMinLength) {
      return 'Senha deve ter pelo menos ${AppConstants.passwordMinLength} caracteres';
    }

    if (value.length > AppConstants.passwordMaxLength) {
      return 'Senha deve ter no máximo ${AppConstants.passwordMaxLength} caracteres';
    }

    return null;
  }

  /// Valida confirmação de senha
  static String? validatePasswordConfirmation(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }

    if (value != password) {
      return 'Senhas não coincidem';
    }

    return null;
  }

  /// Valida nome
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }

    if (value.length < AppConstants.nameMinLength) {
      return 'Nome deve ter pelo menos ${AppConstants.nameMinLength} caracteres';
    }

    if (value.length > AppConstants.nameMaxLength) {
      return 'Nome deve ter no máximo ${AppConstants.nameMaxLength} caracteres';
    }

    return null;
  }

  /// Valida nome da Campanha
  static String? validateEventName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome da Campanha é obrigatório';
    }

    if (value.length < AppConstants.eventNameMinLength) {
      return 'Nome deve ter pelo menos ${AppConstants.eventNameMinLength} caracteres';
    }

    if (value.length > AppConstants.eventNameMaxLength) {
      return 'Nome deve ter no máximo ${AppConstants.eventNameMaxLength} caracteres';
    }

    return null;
  }

  /// Valida descrição da Campanha
  static String? validateEventDescription(String? value) {
    if (value != null &&
        value.length > AppConstants.eventDescriptionMaxLength) {
      return 'Descrição deve ter no máximo ${AppConstants.eventDescriptionMaxLength} caracteres';
    }

    return null;
  }

  /// Valida localização da Campanha
  static String? validateEventLocation(String? value) {
    if (value != null && value.length > AppConstants.eventLocationMaxLength) {
      return 'Localização deve ter no máximo ${AppConstants.eventLocationMaxLength} caracteres';
    }

    return null;
  }

  /// Valida código/tag da Campanha
  static String? validateEventTag(String? value) {
    if (value == null || value.isEmpty) {
      return 'Código da Campanha é obrigatório';
    }

    final tagRegex = RegExp(AppConstants.eventTagPattern);
    if (!tagRegex.hasMatch(value)) {
      return 'Código deve ter 6 caracteres alfanuméricos maiúsculos';
    }

    return null;
  }

  /// Valida nome da task
  static String? validateTaskName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome da tarefa é obrigatório';
    }

    if (value.length < AppConstants.taskNameMinLength) {
      return 'Nome deve ter pelo menos ${AppConstants.taskNameMinLength} caracteres';
    }

    if (value.length > AppConstants.taskNameMaxLength) {
      return 'Nome deve ter no máximo ${AppConstants.taskNameMaxLength} caracteres';
    }

    return null;
  }

  /// Valida descrição da task
  static String? validateTaskDescription(String? value) {
    if (value != null && value.length > AppConstants.taskDescriptionMaxLength) {
      return 'Descrição deve ter no máximo ${AppConstants.taskDescriptionMaxLength} caracteres';
    }

    return null;
  }

  /// Valida nome da microtask
  static String? validateMicrotaskName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome da microtarefa é obrigatório';
    }

    if (value.length < AppConstants.microtaskNameMinLength) {
      return 'Nome deve ter pelo menos ${AppConstants.microtaskNameMinLength} caracteres';
    }

    if (value.length > AppConstants.microtaskNameMaxLength) {
      return 'Nome deve ter no máximo ${AppConstants.microtaskNameMaxLength} caracteres';
    }

    return null;
  }

  /// Valida descrição da microtask
  static String? validateMicrotaskDescription(String? value) {
    if (value != null &&
        value.length > AppConstants.microtaskDescriptionMaxLength) {
      return 'Descrição deve ter no máximo ${AppConstants.microtaskDescriptionMaxLength} caracteres';
    }

    return null;
  }

  /// Valida horas estimadas
  static String? validateEstimatedHours(String? value) {
    if (value == null || value.isEmpty) {
      return 'Horas estimadas são obrigatórias';
    }

    final hours = double.tryParse(value);
    if (hours == null) {
      return 'Valor inválido';
    }

    if (hours < AppConstants.minEstimatedHours) {
      return 'Mínimo de ${AppConstants.minEstimatedHours} horas';
    }

    if (hours > AppConstants.maxEstimatedHours) {
      return 'Máximo de ${AppConstants.maxEstimatedHours} horas';
    }

    return null;
  }

  /// Valida se uma lista não está vazia
  static String? validateRequiredList(List<dynamic>? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }

    return null;
  }

  /// Valida se um valor não é nulo nem vazio
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }

    return null;
  }
}
