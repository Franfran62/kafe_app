import 'package:flutter/material.dart';

class FormPlayer extends StatelessWidget {
  final bool isRegister;
  final bool isLogin;
  final bool isEdit;
  final GlobalKey<FormState> formKey;

  final TextEditingController? nameController;
  final TextEditingController? firstnameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  final VoidCallback onSubmit;

  const FormPlayer({
    super.key,
    required this.formKey,
    required this.onSubmit,
    this.nameController,
    this.firstnameController,
    required this.emailController,
    required this.passwordController,
    this.isRegister = false,
    this.isLogin = false,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [

          // Champ Avatar (uniquement en édition de profil)
          if (isEdit)
            Column(
              children: [
                const Text("Avatar (bientôt 👤)"),
                const SizedBox(height: 10),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, size: 30),
                ),
                const SizedBox(height: 20),
              ],
            ),

          // Nom (uniquement en édition et création de profil)
          if (isRegister || isEdit)
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nom"),
              validator: (value) => value!.isEmpty ? "Champ requis" : null,
            ),

          // Prénom (uniquement en édition et création de profil)
          if (isRegister || isEdit)
            TextFormField(
              controller: firstnameController,
              decoration: const InputDecoration(labelText: "Prénom"),
              validator: (value) => value!.isEmpty ? "Champ requis" : null,
            ),

          // Email (always)
          if (!isEdit)
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
              validator: (value) => value!.isEmpty ? "Champ requis" : null,
            ),

          // Mot de passe (always)
          TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: "Mot de passe"),
            obscureText: true,
            validator: (value) =>
                value!.length < 6 ? "Minimum 6 caractères" : null,
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: onSubmit,
            child: Text(
              isRegister
                  ? "Créer mon compte"
                  : isLogin
                      ? "Se connecter"
                      : "Enregistrer les modifications",
            ),
          )
        ],
      ),
    );
  }
}
