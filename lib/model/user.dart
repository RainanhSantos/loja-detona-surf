import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({required this.email, required this.password, this.name, this.confirmPassword, this.id});

User.fromDocument(DocumentSnapshot document) {
  id = document.id;
  final data = document.data() as Map<String, dynamic>?;

  if (data != null) {
    name = data['name'] as String?;
    email = data['email'] as String? ?? '';
  } else {
    name = null;
    email = '';
  }
}


  late String? id;
  late String? name;
  late String email;
  late String password;
  late String? confirmPassword;
  bool admin = false;

  DocumentReference get firestoreRef =>
    FirebaseFirestore.instance.doc('users/$id');

    CollectionReference get cartReference => 
      firestoreRef.collection('cart');

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
