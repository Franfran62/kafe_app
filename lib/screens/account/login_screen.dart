import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:kafe_app/game/auth_game_controller.dart';
import 'package:kafe_app/widgets/form_player.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthGameController _authGameController = AuthGameController();
  bool _isLoading = false;

  
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final logged = await _authGameController.loginFlow(
          context: context,
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if (mounted && logged) {
          GoRouter.of(context).pushNamed('game_home');
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : ${e.message}")),
        );
      } finally {
      if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion"),
      automaticallyImplyLeading: false,
      ),
      body: _isLoading
      ? const Center(child: CircularProgressIndicator())
      : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 22.0),
                child: Image.asset(
                  "assets/images/kafeiculteur.png",
                  width: MediaQuery.of(context).size.width / 2,
                  ),
              ),
              FormPlayer(
                formKey: _formKey,
                isLogin: true,
                emailController: _emailController,
                passwordController: _passwordController,
                onSubmit: _login,
              ),
          TextButton(
                onPressed: () {
                  GoRouter.of(context).goNamed("register");
                },
                child: const Text("Pas encore de compte ?"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

