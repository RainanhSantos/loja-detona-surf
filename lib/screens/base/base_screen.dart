import 'package:flutter/material.dart';
import 'package:loja_free_style/common/custom_drawer/custom_drawer.dart';
import 'package:loja_free_style/model/page_maneger.dart';
import 'package:loja_free_style/screens/home/home_screen.dart';
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
          HomeScreen(),
          ProductsScreen(),
          Scaffold(
            drawer: const CustomDrawer(),
            appBar: AppBar(title: const Text('Home3')),
          ),
        ],
      ),
    );
  }
}
