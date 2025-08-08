import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:loja_free_style/helpers/firebase_errors.dart';
import 'package:loja_free_style/models/user.dart' as model;

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  final firebase_auth.FirebaseAuth auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  model.User? user;

  bool _loading = false;
  bool get loading => _loading;
  bool get isLoggedIn => user != null;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  
  Future<void> signIn({
    required model.User user,
    required void Function(String) onFail,
    required VoidCallback onSuccess,
  }) async {
    loading = true;
    try {
      final firebase_auth.UserCredential result =
          await auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password ?? "",
      );

      await _loadCurrentUser(firebaseUser: result.user);

      final DocumentSnapshot docUser =
          await firestore.collection('users').doc(result.user!.uid).get();
      this.user = model.User.fromDocument(docUser);

      onSuccess();
    } on firebase_auth.FirebaseAuthException catch (e) {
      onFail(getErrorString(e.code));
    } catch (e) {
      onFail("Erro inesperado: $e");
    }
    loading = false;
  }

  
  Future<void> signUp({
    required model.User user,
    required void Function(String) onFail,
    required VoidCallback onSuccess,
  }) async {
    loading = true;
    try {
      final firebase_auth.UserCredential result =
          await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password?? '',
      );

      user.id = result.user?.uid;
      this.user = user;

      await user.saveData();

      onSuccess();
    } on firebase_auth.FirebaseAuthException catch (e) {
      onFail(getErrorString(e.code));
    } catch (e) {
      onFail("Erro inesperado: $e");
    }
    loading = false;
  }

  
  void signOut() {
    auth.signOut();
    user = null;
    notifyListeners();
  }

  
  Future<void> _loadCurrentUser({firebase_auth.User? firebaseUser}) async {
    final firebase_auth.User? currentUser = firebaseUser ?? auth.currentUser;

    if (currentUser != null) {
      final DocumentSnapshot docUser =
          await firestore.collection('users').doc(currentUser.uid).get();
      user = model.User.fromDocument(docUser);
      
      final docAdmin = await firestore.collection('admins').doc(user?.id).get();
      if(docAdmin.exists){
        user?.admin = true;
      }

      notifyListeners();
    }
  }

  bool get adminEnabled => user != null && user!.admin;
  
}
