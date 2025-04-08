import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:kafe_app/models/field.dart';
import 'package:kafe_app/screens/account/account_screen.dart';
import 'package:kafe_app/screens/field/field_detail_screen.dart';
import 'package:kafe_app/screens/field/fields_screen.dart';
import 'package:kafe_app/screens/game_screen.dart';
import 'package:kafe_app/screens/account/login_screen.dart';
import 'package:kafe_app/screens/account/register_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      name: "game_home",
      path: '/',
      builder: (context, state) => GameScreen(),
      redirect: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return '/login';
        return null;
      },
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
    GoRoute(
      name: "field_detail",
      path: '/field/:id',
      builder: (context, state) {
        final field = state.extra as Field;
        return FieldDetailScreen(field: field);
}

),
  ],
);

