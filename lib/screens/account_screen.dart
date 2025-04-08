import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kafe_app/widgets/FormPlayer.dart';
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

  @override
  void initState() {
    super.initState();
    final player = Provider.of<PlayerProvider>(context, listen: false).player;
    if (player != null) {
      _nameController.text = player.name;
      _firstnameController.text = player.firstname;
      _emailController.text = player.email;
    }
  }

  Future<void> editAccount() async {
    if (_formKey.currentState!.validate()) {
      try {
        final playerProvider =
            Provider.of<PlayerProvider>(context, listen: false);
        final existingPlayer = playerProvider.player;

        if (existingPlayer != null && existingPlayer.uid.isNotEmpty) {
          final updatedPlayer = Player(
            uid: existingPlayer.uid,
            name: _nameController.text.trim().isNotEmpty
                ? _nameController.text.trim()
                : existingPlayer.name,
            firstname: _firstnameController.text.trim().isNotEmpty
                ? _firstnameController.text.trim()
                : existingPlayer.firstname,
            email: _emailController.text.trim().isNotEmpty
                ? _emailController.text.trim()
                : existingPlayer.email,
          );

          await _playerService.updatePlayer(updatedPlayer);

          GoRouter.of(context).pushNamed("game_home");
        }
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
    final uid = FirebaseAuth.instance.currentUser?.uid;

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
                  if (pickedFile != null)
                    await _uploadToStorage(pickedFile, uid!);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choisir dans la galerie'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null)
                    await _uploadToStorage(pickedFile, uid!);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadToStorage(XFile pickedFile, String uid) async {
    final storageRef = FirebaseStorage.instance.ref().child('avatars/$uid.jpg');
    await storageRef.putFile(File(pickedFile.path));
    final downloadUrl = await storageRef.getDownloadURL();

    await _playerService.updateAvatar(uid, downloadUrl);
    await Provider.of<PlayerProvider>(context, listen: false).loadPlayer(uid);

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
