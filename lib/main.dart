import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/controllers/event_controller.dart';
import 'presentation/controllers/task_controller.dart';
import 'presentation/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ConTaskApp());
}

class ConTaskApp extends StatelessWidget {
  const ConTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthController()..initialize(),
        ),
        ChangeNotifierProvider(create: (context) => EventController()),
        ChangeNotifierProvider(create: (context) => TaskController()),
      ],
      child: Consumer<AuthController>(
        builder: (context, authController, child) {
          return MaterialApp(
            title: 'ConTask',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,

            // Configuração de rotas
            initialRoute: _getInitialRoute(authController),
            routes: AppRoutes.routes,
            onGenerateRoute: AppRoutes.onGenerateRoute,

            // Builder para interceptar mudanças de autenticação
            builder: (context, child) {
              return _AuthWrapper(child: child!);
            },
          );
        },
      ),
    );
  }

  String _getInitialRoute(AuthController authController) {
    // Se está autenticado, vai para home, senão vai para login
    if (authController.isAuthenticated) {
      return AppRoutes.home;
    }
    return AppRoutes.login;
  }
}

/// Widget que monitora mudanças de autenticação e redireciona conforme necessário
class _AuthWrapper extends StatefulWidget {
  final Widget child;

  const _AuthWrapper({required this.child});

  @override
  State<_AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<_AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, _) {
        // Monitora mudanças no estado de autenticação apenas após o build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          final navigator = Navigator.maybeOf(context);
          if (navigator == null) return;

          final currentRoute = ModalRoute.of(context)?.settings.name;

          if (authController.isAuthenticated &&
              currentRoute == AppRoutes.login) {
            // Se está autenticado mas na tela de login, vai para home
            navigator.pushReplacementNamed(AppRoutes.home);
          } else if (authController.isUnauthenticated &&
              currentRoute != AppRoutes.login &&
              currentRoute != AppRoutes.register) {
            // Se não está autenticado mas não está na tela de login/cadastro, vai para login
            navigator.pushNamedAndRemoveUntil(
              AppRoutes.login,
              (route) => false,
            );
          }
        });

        return widget.child;
      },
    );
  }
}
