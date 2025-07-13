import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';

/// Classe responsável por definir todas as rotas da aplicação
class AppRoutes {
  // Nomes das rotas
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String createEvent = '/create-event';
  static const String joinEvent = '/join-event';
  static const String eventDetails = '/event-details';
  static const String createTasks = '/create-tasks';
  static const String manageVolunteers = '/manage-volunteers';
  static const String trackTasks = '/track-tasks';
  static const String profile = '/profile';

  /// Rota inicial da aplicação
  static const String initialRoute = login;

  /// Mapa de todas as rotas da aplicação
  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
      // Outras rotas serão adicionadas conforme implementadas
    };
  }

  /// Gerador de rotas para rotas dinâmicas
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return _createRoute(const LoginScreen());
      case register:
        return _createRoute(const RegisterScreen());
      case home:
        return _createRoute(const HomeScreen());

      // Rotas com parâmetros serão implementadas aqui
      // case eventDetails:
      //   final eventId = settings.arguments as String;
      //   return _createRoute(EventDetailsScreen(eventId: eventId));

      default:
        return _createRoute(const NotFoundScreen());
    }
  }

  /// Cria uma rota com animação personalizada
  static PageRoute<T> _createRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Navega para uma rota removendo todas as anteriores
  static void pushAndRemoveUntil(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Navega para uma rota substituindo a atual
  static void pushReplacement(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
  }

  /// Navega para uma rota
  static void push(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  /// Volta para a rota anterior
  static void pop(BuildContext context, [Object? result]) {
    Navigator.of(context).pop(result);
  }

  /// Verifica se pode voltar
  static bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  /// Navega para a tela de login removendo todas as rotas anteriores
  static void goToLogin(BuildContext context) {
    pushAndRemoveUntil(context, login);
  }

  /// Navega para a tela home removendo todas as rotas anteriores
  static void goToHome(BuildContext context) {
    pushAndRemoveUntil(context, home);
  }

  /// Navega para a tela de cadastro
  static void goToRegister(BuildContext context) {
    push(context, register);
  }

  /// Navega para a tela de criar evento
  static void goToCreateEvent(BuildContext context) {
    push(context, createEvent);
  }

  /// Navega para a tela de participar de evento
  static void goToJoinEvent(BuildContext context) {
    push(context, joinEvent);
  }

  /// Navega para os detalhes de um evento
  static void goToEventDetails(BuildContext context, String eventId) {
    push(context, eventDetails, arguments: eventId);
  }

  /// Navega para a tela de criar tasks
  static void goToCreateTasks(BuildContext context, String eventId) {
    push(context, createTasks, arguments: eventId);
  }

  /// Navega para a tela de gerenciar voluntários
  static void goToManageVolunteers(BuildContext context, String eventId) {
    push(context, manageVolunteers, arguments: eventId);
  }

  /// Navega para a tela de acompanhar tasks
  static void goToTrackTasks(BuildContext context, String eventId) {
    push(context, trackTasks, arguments: eventId);
  }

  /// Navega para a tela de perfil
  static void goToProfile(BuildContext context) {
    push(context, profile);
  }
}

/// Tela exibida quando uma rota não é encontrada
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página não encontrada')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Página não encontrada',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'A página que você está procurando não existe.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
