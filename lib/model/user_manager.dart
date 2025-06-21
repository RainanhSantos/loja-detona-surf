import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_free_style/helpers/firebase_errors.dart';
import 'package:loja_free_style/model/user.dart' as model;

class UserManager extends ChangeNotifier {

  UserManager(){
    _loadCurrentUser();
  }

  final firebase_auth.FirebaseAuth auth = firebase_auth.FirebaseAuth.instance;

  late firebase_auth.User user;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> signIn({
    required model.User user,
    required void Function(String) onFail,
    required VoidCallback onSuccess, // VoidCallback = void Function()
  }) async {
    loading = true;
    try {
      final firebase_auth.UserCredential result = await auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      this.user = result.user!;
      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

Future<void> _loadCurrentUser() async {
  final firebase_auth.User? currentUser = auth.currentUser;

  if (currentUser != null) {
    user = currentUser;
  } 
  notifyListeners();
}


}
