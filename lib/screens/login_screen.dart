import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:kafe_app/providers/player_provider.dart';
import 'package:kafe_app/widgets/form_player.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Future.microtask(() {
        GoRouter.of(context).pushReplacementNamed('game_home');
      });
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          await Provider.of<PlayerProvider>(context, listen: false).loadPlayer(uid);
        }
        if (mounted) {
          GoRouter.of(context).pushNamed('game_home');
        }

      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : ${e.message}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion"),
      automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
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

