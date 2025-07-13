import 'dart:math';

/// Classe utilitária para manipulação de strings
class StringHelpers {
  /// Capitaliza a primeira letra de uma string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Capitaliza a primeira letra de cada palavra
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  /// Remove espaços extras e quebras de linha
  static String cleanText(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Trunca o texto se exceder o limite de caracteres
  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - suffix.length) + suffix;
  }

  /// Gera um código alfanumérico aleatório
  static String generateRandomCode(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  /// Gera um ID único baseado em timestamp e random
  static String generateUniqueId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(9999);
    return '${timestamp}_$random';
  }

  /// Valida se uma string contém apenas letras e espaços
  static bool isValidName(String text) {
    return RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(text);
  }

  /// Valida se uma string é um email válido
  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  /// Remove acentos de uma string
  static String removeAccents(String text) {
    const withAccents = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëÇçÌÍÎÏìíîïÙÚÛÜùúûüÿÑñ';
    const withoutAccents = 'AAAAAAaaaaaaOOOOOOooooooEEEEeeeeeCcIIIIiiiiUUUUuuuuyNn';
    
    String result = text;
    for (int i = 0; i < withAccents.length; i++) {
      result = result.replaceAll(withAccents[i], withoutAccents[i]);
    }
    return result;
  }

  /// Converte string para formato de busca (sem acentos, minúscula)
  static String toSearchFormat(String text) {
    return removeAccents(text.toLowerCase().trim());
  }

  /// Extrai iniciais de um nome
  static String getInitials(String name, {int maxInitials = 2}) {
    if (name.isEmpty) return '';
    
    final words = name.trim().split(' ');
    final initials = words
        .where((word) => word.isNotEmpty)
        .take(maxInitials)
        .map((word) => word[0].toUpperCase())
        .join();
    
    return initials;
  }

  /// Formata um número de telefone
  static String formatPhoneNumber(String phone) {
    // Remove todos os caracteres não numéricos
    final numbers = phone.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (numbers.length == 11) {
      // Formato: (XX) XXXXX-XXXX
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 7)}-${numbers.substring(7)}';
    } else if (numbers.length == 10) {
      // Formato: (XX) XXXX-XXXX
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 6)}-${numbers.substring(6)}';
    }
    
    return phone; // Retorna original se não conseguir formatar
  }

  /// Converte uma lista de strings em uma string separada por vírgulas
  static String joinWithComma(List<String> items) {
    return items.join(', ');
  }

  /// Converte uma string separada por vírgulas em lista
  static List<String> splitByComma(String text) {
    return text.split(',').map((item) => item.trim()).where((item) => item.isNotEmpty).toList();
  }

  /// Verifica se uma string está vazia ou contém apenas espaços
  static bool isNullOrEmpty(String? text) {
    return text == null || text.trim().isEmpty;
  }

  /// Verifica se uma string não está vazia
  static bool isNotNullOrEmpty(String? text) {
    return !isNullOrEmpty(text);
  }

  /// Conta o número de palavras em um texto
  static int countWords(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }

  /// Estima o tempo de leitura em minutos (baseado em 200 palavras por minuto)
  static int estimateReadingTime(String text) {
    final wordCount = countWords(text);
    return (wordCount / 200).ceil();
  }

  /// Converte uma string para slug (URL-friendly)
  static String toSlug(String text) {
    return removeAccents(text)
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  /// Mascara informações sensíveis (ex: email, telefone)
  static String maskSensitiveInfo(String text, {int visibleChars = 3}) {
    if (text.length <= visibleChars * 2) return text;
    
    final start = text.substring(0, visibleChars);
    final end = text.substring(text.length - visibleChars);
    final middle = '*' * (text.length - visibleChars * 2);
    
    return start + middle + end;
  }

  /// Converte bytes para string legível (KB, MB, GB)
  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Converte duração em segundos para string legível
  static String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${remainingSeconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${remainingSeconds}s';
    } else {
      return '${remainingSeconds}s';
    }
  }

  /// Pluraliza uma palavra baseada na quantidade
  static String pluralize(int count, String singular, String plural) {
    return count == 1 ? singular : plural;
  }

  /// Formata um número com separadores de milhares
  static String formatNumber(num number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]}.',
    );
  }

  /// Converte uma string para camelCase
  static String toCamelCase(String text) {
    final words = text.toLowerCase().split(RegExp(r'[\s_-]+'));
    if (words.isEmpty) return '';
    
    return words.first + words.skip(1).map(capitalize).join();
  }

  /// Converte uma string para snake_case
  static String toSnakeCase(String text) {
    return text
        .replaceAll(RegExp(r'([A-Z])'), '_\$1')
        .toLowerCase()
        .replaceAll(RegExp(r'^_'), '')
        .replaceAll(RegExp(r'[\s-]+'), '_');
  }
}
