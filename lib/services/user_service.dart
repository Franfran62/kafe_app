import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> getCurrentUserId() async {
    final user = _auth.currentUser;
    return user?.uid;
  }

  Future<String> createAccount(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user!.uid;
  }

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> updateCredentials({String? newEmail, String? newPassword}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (newEmail != null && newEmail.isNotEmpty && newEmail != user.email) {
      await user.updateEmail(newEmail);
    }

    if (newPassword != null && newPassword.isNotEmpty) {
      await user.updatePassword(newPassword);
    }
  }
  
  Future<String?> uploadAvatar(File file) async {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return null;

      final ref = FirebaseStorage.instance.ref().child('avatars/$uid.jpg');
      await ref.putFile(file);
      return await ref.getDownloadURL();
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
