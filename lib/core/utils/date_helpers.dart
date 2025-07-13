import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Classe utilitária para manipulação de datas
class DateHelpers {
  /// Formatador para data completa (dd/MM/yyyy)
  static final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy');

  /// Formatador para data e hora (dd/MM/yyyy HH:mm)
  static final DateFormat _dateTimeFormatter = DateFormat('dd/MM/yyyy HH:mm');

  /// Formatador para hora (HH:mm)
  static final DateFormat _timeFormatter = DateFormat('HH:mm');

  /// Formatador para data abreviada (dd/MM)
  static final DateFormat _shortDateFormatter = DateFormat('dd/MM');

  /// Formatador para mês e ano (MMM yyyy)
  static final DateFormat _monthYearFormatter = DateFormat('MMM yyyy', 'pt_BR');

  /// Converte DateTime para string no formato dd/MM/yyyy
  static String formatDate(DateTime date) {
    return _dateFormatter.format(date);
  }

  /// Converte DateTime para string no formato dd/MM/yyyy HH:mm
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormatter.format(dateTime);
  }

  /// Converte DateTime para string no formato HH:mm
  static String formatTime(DateTime time) {
    return _timeFormatter.format(time);
  }

  /// Converte DateTime para string no formato dd/MM
  static String formatShortDate(DateTime date) {
    return _shortDateFormatter.format(date);
  }

  /// Converte DateTime para string no formato MMM yyyy
  static String formatMonthYear(DateTime date) {
    return _monthYearFormatter.format(date);
  }

  /// Converte string no formato dd/MM/yyyy para DateTime
  static DateTime? parseDate(String dateString) {
    try {
      return _dateFormatter.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Converte string no formato dd/MM/yyyy HH:mm para DateTime
  static DateTime? parseDateTime(String dateTimeString) {
    try {
      return _dateTimeFormatter.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  /// Converte string no formato HH:mm para TimeOfDay
  static TimeOfDay? parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length == 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      // Ignora erro de parsing
    }
    return null;
  }

  /// Converte TimeOfDay para string no formato HH:mm
  static String timeOfDayToString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Retorna a diferença em dias entre duas datas
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  /// Retorna a diferença em horas entre dois DateTimes
  static double hoursBetween(DateTime from, DateTime to) {
    return to.difference(from).inMinutes / 60.0;
  }

  /// Verifica se uma data é hoje
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Verifica se uma data é amanhã
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Verifica se uma data é ontem
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Retorna uma string relativa para a data (hoje, ontem, amanhã, ou data formatada)
  static String getRelativeDateString(DateTime date) {
    if (isToday(date)) {
      return 'Hoje';
    } else if (isTomorrow(date)) {
      return 'Amanhã';
    } else if (isYesterday(date)) {
      return 'Ontem';
    } else {
      return formatDate(date);
    }
  }

  /// Retorna o início do dia (00:00:00)
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Retorna o fim do dia (23:59:59.999)
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Retorna o início da semana (segunda-feira)
  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  /// Retorna o fim da semana (domingo)
  static DateTime endOfWeek(DateTime date) {
    final daysToSunday = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysToSunday)));
  }

  /// Retorna o início do mês
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Retorna o fim do mês
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }

  /// Converte um dia da semana em string para número (1 = segunda, 7 = domingo)
  static int weekdayFromString(String weekday) {
    switch (weekday.toLowerCase()) {
      case 'monday':
      case 'segunda':
        return 1;
      case 'tuesday':
      case 'terça':
        return 2;
      case 'wednesday':
      case 'quarta':
        return 3;
      case 'thursday':
      case 'quinta':
        return 4;
      case 'friday':
      case 'sexta':
        return 5;
      case 'saturday':
      case 'sábado':
        return 6;
      case 'sunday':
      case 'domingo':
        return 7;
      default:
        return 1;
    }
  }

  /// Converte um número do dia da semana para string em português
  static String weekdayToString(int weekday) {
    switch (weekday) {
      case 1:
        return 'Segunda-feira';
      case 2:
        return 'Terça-feira';
      case 3:
        return 'Quarta-feira';
      case 4:
        return 'Quinta-feira';
      case 5:
        return 'Sexta-feira';
      case 6:
        return 'Sábado';
      case 7:
        return 'Domingo';
      default:
        return 'Segunda-feira';
    }
  }

  /// Converte um número do dia da semana para string abreviada
  static String weekdayToShortString(int weekday) {
    switch (weekday) {
      case 1:
        return 'Seg';
      case 2:
        return 'Ter';
      case 3:
        return 'Qua';
      case 4:
        return 'Qui';
      case 5:
        return 'Sex';
      case 6:
        return 'Sáb';
      case 7:
        return 'Dom';
      default:
        return 'Seg';
    }
  }
}
