import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:kafe_app/game/auth_game_controller.dart';
import 'package:kafe_app/providers/player_provider.dart';
import 'package:kafe_app/services/field_service.dart';
import 'package:kafe_app/widgets/field_name_modal.dart';
import 'package:kafe_app/widgets/form_player.dart';
import 'package:provider/provider.dart';
import '../../models/player.dart';
import '../../services/player_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthGameController _authController = AuthGameController();

  Future<void> _createAccount() async {
    if (_formKey.currentState!.validate()) {
      try {
        final fieldName = await showFieldNameModal(context, isFirst: true);
        if (fieldName == null) {
          return;
        }
        await _authController.registerFlow(
          context: context,
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim(),
          firstname: _firstnameController.text.trim(),
          fieldName: fieldName,
        );
        GoRouter.of(context).pushNamed("game_home"); 
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : ${e.toString()}")),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Future.microtask(() {
        GoRouter.of(context).pushReplacementNamed('/');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer un compte"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              FormPlayer(
                formKey: _formKey,
                isRegister: true,
                nameController: _nameController,
                firstnameController: _firstnameController,
                emailController: _emailController,
                passwordController: _passwordController,
                onSubmit: _createAccount,
              ),
              TextButton(
                onPressed: () {
                  GoRouter.of(context).goNamed("login");
                },
                child: const Text("Déjà un compte ?"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
