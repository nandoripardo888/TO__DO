import 'package:flutter/material.dart';

/// Classe que define todas as cores utilizadas no aplicativo
/// Baseado no Design System especificado no SPEC_GERAL.md
class AppColors {
  // Cores Principais
  static const Color primary = Color(0xFF6B46C1); // Roxo principal
  static const Color secondary = Color(0xFFA78BFA); // Roxo claro
  
  // Cores de Fundo
  static const Color background = Color(0xFFFFFFFF); // Branco
  static const Color surface = Color(0xFFF9FAFB); // Branco levemente acinzentado
  static const Color cardBackground = Color(0xFFFFFFFF); // Branco para cards
  
  // Cores de Texto
  static const Color textPrimary = Color(0xFF374151); // Cinza escuro
  static const Color textSecondary = Color(0xFF6B7280); // Cinza médio
  static const Color textLight = Color(0xFF9CA3AF); // Cinza claro
  static const Color textOnPrimary = Color(0xFFFFFFFF); // Branco para texto em fundo roxo
  
  // Cores de Status
  static const Color success = Color(0xFF10B981); // Verde
  static const Color error = Color(0xFFEF4444); // Vermelho
  static const Color warning = Color(0xFFF59E0B); // Amarelo/Laranja
  static const Color info = Color(0xFF3B82F6); // Azul
  
  // Cores de Estado
  static const Color disabled = Color(0xFFD1D5DB); // Cinza para elementos desabilitados
  static const Color border = Color(0xFFE5E7EB); // Cinza para bordas
  static const Color divider = Color(0xFFF3F4F6); // Cinza muito claro para divisores
  
  // Cores de Prioridade (para tasks)
  static const Color priorityHigh = Color(0xFFEF4444); // Vermelho
  static const Color priorityMedium = Color(0xFFF59E0B); // Amarelo/Laranja
  static const Color priorityLow = Color(0xFF10B981); // Verde
  
  // Cores de Status de Task/Microtask
  static const Color statusPending = Color(0xFF6B7280); // Cinza
  static const Color statusInProgress = Color(0xFF3B82F6); // Azul
  static const Color statusCompleted = Color(0xFF10B981); // Verde
  static const Color statusCancelled = Color(0xFFEF4444); // Vermelho
  
  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Sombras
  static const Color shadowLight = Color(0x0F000000); // Sombra leve
  static const Color shadowMedium = Color(0x1A000000); // Sombra média
  static const Color shadowDark = Color(0x26000000); // Sombra escura
}
