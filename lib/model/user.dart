import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({required this.email, required this.password, this.name, this.confirmPassword, this.id});

  late String? id;
  late String? name;
  late String email;
  late String password;
  late String? confirmPassword;

  DocumentReference get firestoreRef =>
    FirebaseFirestore.instance.doc('users/$id');

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'email': email,
    };
  }
}
