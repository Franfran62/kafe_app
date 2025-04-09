import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kafe_app/game/auth_game_controller.dart';
import 'package:kafe_app/widgets/form_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kafe_app/models/player.dart';
import 'package:kafe_app/services/player_service.dart';
import 'package:provider/provider.dart';
import 'package:kafe_app/providers/player_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _firstnameController = TextEditingController();

  final PlayerService _playerService = PlayerService();
  final AuthGameController _authGameController = AuthGameController();

  @override
  void initState() {
    super.initState();
    final player = Provider.of<PlayerProvider>(context, listen: false).player;
    if (player != null) {
      _nameController.text = player.name;
      _firstnameController.text = player.firstname;
      _emailController.text = player.email;
    } else {
      GoRouter.of(context).pushNamed("login");
    }
  }

  Future<void> editAccount() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authGameController.updateProfileFlow(
          context: context, 
          email: _emailController.text.trim(), 
          password: _passwordController.text.trim(), 
          name: _nameController.text.trim(),
          firstname: _firstnameController.text.trim(),  
        );
        GoRouter.of(context).pushNamed("game_home");
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : ${e.toString()}")),
        );
      }
    }
  }

  // Ne fonctionnera pas ,car pas de compte payant coté firebase, donc pas de storage
  Future<void> _pickAndUploadAvatar() async {
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Prendre une photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    await _authGameController.updateAvatar(
                      context: context,
                      file: File(pickedFile.path),
                    );
                    _showSnackAndRefresh();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choisir dans la galerie'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    await _authGameController.updateAvatar(
                      context: context,
                      file: File(pickedFile.path),
                    );
                    _showSnackAndRefresh();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackAndRefresh() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Avatar mis à jour")),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon profil"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).pushNamed("game_home");
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FormPlayer(
              formKey: _formKey,
              onSubmit: editAccount,
              isEdit: true,
              nameController: _nameController,
              firstnameController: _firstnameController,
              emailController: _emailController,
              passwordController: _passwordController,
              onAvatarTap: _pickAndUploadAvatar,
              avatarUrl: Provider.of<PlayerProvider>(context).player?.avatarUrl,
            ),
          ],
        ),
      ),
    );
  }
}
