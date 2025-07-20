import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/volunteer_profile_model.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/microtask_repository.dart';
import '../../../data/services/event_service.dart';
import '../common/loading_widget.dart';
import 'volunteer_profile_modal.dart';

/// Dialog que carrega e exibe o perfil do voluntário
class VolunteerProfileDialog extends StatefulWidget {
  final String userId;
  final String? eventId;

  const VolunteerProfileDialog({
    super.key,
    required this.userId,
    this.eventId,
  });

  @override
  State<VolunteerProfileDialog> createState() => _VolunteerProfileDialogState();

  /// Mostra o dialog de perfil do voluntário
  static void show({
    required BuildContext context,
    required String userId,
    String? eventId,
  }) {
    showDialog(
      context: context,
      builder: (context) => VolunteerProfileDialog(
        userId: userId,
        eventId: eventId,
      ),
    );
  }
}

class _VolunteerProfileDialogState extends State<VolunteerProfileDialog> {
  final UserRepository _userRepository = UserRepository();
  final EventService _eventService = EventService();
  final MicrotaskRepository _microtaskRepository = MicrotaskRepository();

  UserModel? _user;
  VolunteerProfileModel? _profile;
  int _assignedMicrotasksCount = 0;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadVolunteerData();
  }

  Future<void> _loadVolunteerData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Carregar dados do usuário
      final user = await _userRepository.getUserById(widget.userId);
      if (user == null) {
        throw Exception('Usuário não encontrado');
      }

      // Carregar perfil do voluntário
      VolunteerProfileModel? profile;
      if (widget.eventId != null) {
        profile = await _eventService.getVolunteerProfile(widget.userId, widget.eventId!);
      }

      // Contar microtasks atribuídas
      int microtasksCount = 0;
      if (widget.eventId != null) {
        final microtasks = await _microtaskRepository.getMicrotasksByEventId(widget.eventId!);
        microtasksCount = microtasks
            .where((microtask) => microtask.assignedTo.contains(widget.userId))
            .length;
      }

      if (mounted) {
        setState(() {
          _user = user;
          _profile = profile;
          _assignedMicrotasksCount = microtasksCount;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Dialog(
        child: SizedBox(
          width: 200,
          height: 200,
          child: LoadingWidget(
            message: 'Carregando perfil do voluntário...',
          ),
        ),
      );
    }

    if (_error != null) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 48,
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              const Text(
                'Erro ao carregar perfil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingLg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Fechar'),
                  ),
                  ElevatedButton(
                    onPressed: _loadVolunteerData,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (_user == null) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.person_off_outlined,
                color: AppColors.textSecondary,
                size: 48,
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              const Text(
                'Voluntário não encontrado',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingLg),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fechar'),
              ),
            ],
          ),
        ),
      );
    }

    return VolunteerProfileModal(
      user: _user!,
      profile: _profile,
      assignedMicrotasksCount: _assignedMicrotasksCount,
    );
  }
}