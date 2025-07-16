ONLY /LIB

lib
  core
    constants
      app_colors.dart
      app_constants.dart
      app_dimensions.dart
      app_strings.dart
    exceptions
      app_exceptions.dart
    theme
      app_theme.dart
    utils
      date_helpers.dart
      error_handler.dart
      form_validators.dart
      string_helpers.dart
      validators.dart
  data
    models
      event_model.dart
      microtask_model.dart
      task_model.dart
      user_microtask_model.dart
      user_model.dart
      volunteer_profile_model.dart
    repositories
      auth_repository.dart
      event_repository.dart
      microtask_repository.dart
      task_repository.dart
      user_repository.dart
    services
      assignment_service.dart
      auth_service.dart
      event_service.dart
      microtask_service.dart
      task_service.dart
      user_service.dart
  firebase_options.dart
  main.dart
  presentation
    controllers
      auth_controller.dart
      event_controller.dart
      task_controller.dart
    routes
      app_routes.dart
    screens
      assignment
        assignment_screen.dart
      auth
        login_screen.dart
        register_screen.dart
      event
        create_event_screen.dart
        create_tasks_screen.dart
        event_details_screen.dart
        join_event_screen.dart
        manage_volunteers_screen.dart
        track_tasks_screen.dart
      home
        home_screen.dart
      task
        create_microtask_screen.dart
        create_task_screen.dart
    widgets
      common
        confirmation_dialog.dart
        custom_app_bar.dart
        custom_button.dart
        custom_text_field.dart
        error_message_widget.dart
        error_widget.dart
        loading_widget.dart
        skill_chip.dart
      dialogs
        assignment_dialog.dart
        confirmation_dialog.dart
      event
        event_card.dart
        event_info_card.dart
        event_stats_widget.dart
        skill_chip.dart
      task
        microtask_card.dart
        task_card.dart
        task_progress_widget.dart
      volunteer
        volunteer_card.dart
        volunteer_list_widget.dart
  utils
    migration_utils.dart

┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
├─────────────────────────────────────────────────────────────┤
│  Controllers (AuthController, EventController, TaskController)│
│  ↓ (depend on repositories only)                           │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                            │
├─────────────────────────────────────────────────────────────┤
│  Repositories (coordinate between services)                │
│  ↓ (delegate to services)                                  │
│  Services (direct database/Firebase operations)            │
│  ↓ (use models for data structure)                         │
│  Models (pure data classes with validation & business logic)│
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                   EXTERNAL LAYER                           │
├─────────────────────────────────────────────────────────────┤
│  Firebase Firestore, Firebase Auth, External APIs          │
└─────────────────────────────────────────────────────────────┘
