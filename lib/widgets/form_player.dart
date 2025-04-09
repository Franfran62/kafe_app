import 'package:flutter/material.dart';

class FormPlayer extends StatelessWidget {
  final bool isRegister;
  final bool isLogin;
  final bool isEdit;
  final GlobalKey<FormState> formKey;

  final String? avatarUrl;
  final VoidCallback? onAvatarTap;

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
    this.avatarUrl,
    this.onAvatarTap
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
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => onAvatarTap?.call(),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                    child: avatarUrl == null ? const Icon(Icons.person, size: 50) : null,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),

          // Nom (uniquement en édition et création de profil)
          if (isRegister || isEdit)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nom"),
                validator: (value) => (!isEdit && value!.isEmpty) ? "Champ requis" : null,
              ),
            ),

          // Prénom (uniquement en édition et création de profil)
          if (isRegister || isEdit)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: firstnameController,
                decoration: const InputDecoration(labelText: "Prénom"),
                validator: (value) => (!isEdit && value!.isEmpty) ? "Champ requis" : null,
              ),
            ),

          // Email (always)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) => (!isEdit && value!.isEmpty) ? "Champ requis" : null,
              ),
            ),

          // Mot de passe (always)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Mot de passe"),
              obscureText: true,
              validator: (value) =>
                  (!isEdit && value!.length < 6) ? "Minimum 6 caractères" : null,
            ),
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
