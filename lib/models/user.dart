import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:azlistview/azlistview.dart';

class User extends ISuspensionBean {
  User({
    required this.email,
    this.password,
    this.name,
    this.confirmPassword,
    this.id,
    this.tag,
  });

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

    tag = name != null && name!.isNotEmpty ? name![0].toUpperCase() : '#';
  }

  late String? id;
  late String? name;
  late String email;
  late String? password;
  late String? confirmPassword;
  bool admin = false;
  String? tag;

  @override
  String getSuspensionTag() => tag ?? '#';

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('users/$id');

  CollectionReference get cartReference =>
      firestoreRef.collection('cart');

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }
}
