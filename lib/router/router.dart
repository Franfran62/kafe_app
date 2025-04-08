import 'package:go_router/go_router.dart';
import 'package:kafe_app/screens/account_screen.dart';
import 'package:kafe_app/screens/fields_screen.dart';
import 'package:kafe_app/screens/game_screen.dart';
import 'package:kafe_app/screens/login_screen.dart';
import 'package:kafe_app/screens/register_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      name: "game_home",
      path: '/',
      builder: (context, state) => GameScreen(),
    ),
    GoRoute(
      name: "register",
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      name: "login",
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: "account",
      path: '/account',
      builder: (context, state) => const AccountScreen(), 
    ),
  ],
);

