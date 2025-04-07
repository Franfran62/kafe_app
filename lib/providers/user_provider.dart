import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _ready = false;

  User? get user => _user;
  bool get isReady => _ready;


  UserProvider() {
    _auth.authStateChanges().listen((User? firebaseUser) {
      _user = firebaseUser;
      _ready = true;
      notifyListeners();
    });
  }

  bool get isAuthenticated => _user != null;

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
