import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loja_free_style/firebase_options.dart';
import 'package:loja_free_style/model/product.dart';
import 'package:loja_free_style/model/product_manager.dart';
import 'package:loja_free_style/model/user_manager.dart';
import 'package:loja_free_style/screens/base/base_screen.dart';
import 'package:loja_free_style/screens/login/login_screen.dart';
import 'package:loja_free_style/screens/product/product_screen.dart';
import 'package:loja_free_style/screens/signup/signup_screens.dart';
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Detona Surf',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 237, 99, 99),
          scaffoldBackgroundColor: const Color.fromARGB(255, 237, 99, 99),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: const Color.fromARGB(255, 237, 99, 99),
          ),
        ),
        initialRoute: '/base',
        onGenerateRoute: (settings){
          switch(settings.name){
            case '/login':
              return MaterialPageRoute(
                builder: (_) => LoginScreen()
              );
            case '/signup':
              return MaterialPageRoute(
                builder: (_) => SignUpScreen()
              );
            case '/product':
              return MaterialPageRoute(
                builder: (_) => ProductScreen(
                  product: settings.arguments! as Product,
                )
              );
              case '/base':
              default:
                return MaterialPageRoute(
                  builder: (_) => BaseScreen()
              );
          }
        },
      ),
    );
  }
}


