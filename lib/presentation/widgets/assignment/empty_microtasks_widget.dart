import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Widget para exibir quando não há microtasks disponíveis
class EmptyMicrotasksWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const EmptyMicrotasksWidget({
    super.key,
    this.title = 'Nenhuma microtask disponível',
    this.message = 'Não há microtasks disponíveis para atribuição no momento.',
    this.icon = Icons.assignment_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            message,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}