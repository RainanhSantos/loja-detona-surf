import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loja_free_style/firebase_options.dart';
import 'package:loja_free_style/model/user_manager.dart';
import 'package:loja_free_style/screens/base/base_screen.dart';
import 'package:provider/provider.dart';


Future<void> main() async {

WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(const MyApp());

  final DocumentSnapshot document = await FirebaseFirestore.instance
    .collection('pedidos').doc('964E4Gt7CfgmeCsfQqnR').get();

    print(document.data());

}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (_) => UserManager(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Detona Surf',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 4, 125, 141),
          scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            elevation: 0,
          ),
        ),
        home: BaseScreen(),
      ),
    );
  }
}


