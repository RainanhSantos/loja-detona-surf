import 'package:flutter/material.dart';
import 'package:loja_free_style/common/custom_drawer/custom_drawer.dart';
import 'package:loja_free_style/model/page_maneger.dart';
import 'package:loja_free_style/screens/products/products_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {
  BaseScreen({super.key});

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManeger(pageController),
      child: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Scaffold(
            drawer: const CustomDrawer(),
            appBar: AppBar(
              title: const Text('Home1'),
              backgroundColor: const Color.fromARGB(255, 237, 99, 99),
            ),
          ),

          ProductsScreen(),

          Scaffold(
            drawer: const CustomDrawer(),
            appBar: AppBar(
              title: const Text('Home3'),
              backgroundColor: const Color.fromARGB(255, 237, 99, 99),
            ),
          ),
          Container(
            color: Colors.red,),
          Container(
            color: Colors.green,
          ),
          Container(
            color: Colors.yellow,
          ),
        ],
      ),
    );
  }
}
