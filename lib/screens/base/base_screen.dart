import 'package:flutter/material.dart';
import 'package:loja_free_style/common/custom_drawer/custom_drawer.dart';
import 'package:loja_free_style/models/page_maneger.dart';
import 'package:loja_free_style/models/user_manager.dart';
import 'package:loja_free_style/screens/admin_users/admin_users_screen.dart';
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
      child: Consumer<UserManager>(
        builder: (_, userManager, __){
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const HomeScreen(),
              const ProductsScreen(),
              Scaffold(
                drawer: const CustomDrawer(),
                appBar: AppBar(title: const Text('Home3')),
              ),
              Scaffold(
                drawer: const CustomDrawer(),
                appBar: AppBar(title: const Text('Home4')),
              ),
              if(userManager.adminEnabled)
              ...[
                AdminUsersScreen(),
                Scaffold(
                  drawer: const CustomDrawer(),
                  appBar: AppBar(title: const Text('Pedidos')),
                ),
              ]
            ],
          );
        },
      ),
    );
  }
}
