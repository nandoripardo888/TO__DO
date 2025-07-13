/// Classe utilitária para validações de formulários
class FormValidators {
  FormValidators._();

  /// Valida se o campo não está vazio
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Campo'} é obrigatório';
    }
    return null;
  }

  /// Valida email
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-mail é obrigatório';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'E-mail inválido';
    }

    return null;
  }

  /// Valida senha
  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < minLength) {
      return 'Senha deve ter pelo menos $minLength caracteres';
    }

    return null;
  }

  /// Valida confirmação de senha
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }

    if (value != originalPassword) {
      return 'Senhas não coincidem';
    }

    return null;
  }

  /// Valida nome
  static String? name(String? value, {int minLength = 2, int maxLength = 100}) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome é obrigatório';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < minLength) {
      return 'Nome deve ter pelo menos $minLength caracteres';
    }

    if (trimmedValue.length > maxLength) {
      return 'Nome deve ter no máximo $maxLength caracteres';
    }

    // Verifica se contém apenas letras, espaços e alguns caracteres especiais
    final nameRegex = RegExp(r"^[a-zA-ZÀ-ÿ\s'-]+$");
    if (!nameRegex.hasMatch(trimmedValue)) {
      return 'Nome contém caracteres inválidos';
    }

    return null;
  }

  /// Valida nome de evento
  static String? eventName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome do evento é obrigatório';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < 3) {
      return 'Nome deve ter pelo menos 3 caracteres';
    }

    if (trimmedValue.length > 100) {
      return 'Nome deve ter no máximo 100 caracteres';
    }

    return null;
  }

  /// Valida descrição
  static String? description(String? value, {int maxLength = 500}) {
    if (value != null && value.length > maxLength) {
      return 'Descrição deve ter no máximo $maxLength caracteres';
    }

    return null;
  }

  /// Valida localização
  static String? location(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Localização é obrigatória';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length > 200) {
      return 'Localização deve ter no máximo 200 caracteres';
    }

    return null;
  }

  /// Valida tag/código de evento
  static String? eventTag(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Código do evento é obrigatório';
    }

    final trimmedValue = value.trim().toUpperCase();

    if (trimmedValue.length != 6) {
      return 'Código deve ter exatamente 6 caracteres';
    }

    // Verifica se contém apenas letras e números
    final tagRegex = RegExp(r'^[A-Z0-9]+$');
    if (!tagRegex.hasMatch(trimmedValue)) {
      return 'Código deve conter apenas letras e números';
    }

    return null;
  }

  /// Valida lista não vazia
  static String? nonEmptyList(List<dynamic>? list, {String? fieldName}) {
    if (list == null || list.isEmpty) {
      return '${fieldName ?? 'Lista'} não pode estar vazia';
    }
    return null;
  }

  /// Valida horário
  static String? timeRange(String? startTime, String? endTime) {
    if (startTime == null || startTime.isEmpty) {
      return 'Horário de início é obrigatório';
    }

    if (endTime == null || endTime.isEmpty) {
      return 'Horário de fim é obrigatório';
    }

    // Converte strings para comparação
    final start = _parseTime(startTime);
    final end = _parseTime(endTime);

    if (start == null) {
      return 'Horário de início inválido';
    }

    if (end == null) {
      return 'Horário de fim inválido';
    }

    if (start.isAfter(end) || start.isAtSameMomentAs(end)) {
      return 'Horário de início deve ser anterior ao horário de fim';
    }

    return null;
  }

  /// Valida URL
  static String? url(String? value, {bool required = false}) {
    if (!required && (value == null || value.trim().isEmpty)) {
      return null;
    }

    if (value == null || value.trim().isEmpty) {
      return 'URL é obrigatória';
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value.trim())) {
      return 'URL inválida';
    }

    return null;
  }

  /// Valida telefone (formato brasileiro)
  static String? phone(String? value, {bool required = false}) {
    if (!required && (value == null || value.trim().isEmpty)) {
      return null;
    }

    if (value == null || value.trim().isEmpty) {
      return 'Telefone é obrigatório';
    }

    // Remove caracteres não numéricos
    final numbersOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Verifica se tem 10 ou 11 dígitos (telefone brasileiro)
    if (numbersOnly.length < 10 || numbersOnly.length > 11) {
      return 'Telefone deve ter 10 ou 11 dígitos';
    }

    return null;
  }

  /// Combina múltiplos validadores
  static String? combine(List<String? Function()> validators) {
    for (final validator in validators) {
      final result = validator();
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  /// Valida se o valor está dentro de um range numérico
  static String? numberRange(
    String? value, {
    required double min,
    required double max,
    String? fieldName,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Campo'} é obrigatório';
    }

    final number = double.tryParse(value.trim());
    if (number == null) {
      return '${fieldName ?? 'Campo'} deve ser um número válido';
    }

    if (number < min || number > max) {
      return '${fieldName ?? 'Campo'} deve estar entre $min e $max';
    }

    return null;
  }

  /// Valida comprimento mínimo e máximo
  static String? length(
    String? value, {
    int? min,
    int? max,
    String? fieldName,
  }) {
    if (value == null) {
      return '${fieldName ?? 'Campo'} é obrigatório';
    }

    final length = value.length;

    if (min != null && length < min) {
      return '${fieldName ?? 'Campo'} deve ter pelo menos $min caracteres';
    }

    if (max != null && length > max) {
      return '${fieldName ?? 'Campo'} deve ter no máximo $max caracteres';
    }

    return null;
  }

  /// Método auxiliar para converter string de tempo em DateTime
  static DateTime? _parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) return null;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        return null;
      }

      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (e) {
      return null;
    }
  }
}
