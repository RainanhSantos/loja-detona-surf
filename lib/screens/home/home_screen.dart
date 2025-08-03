import 'package:flutter/material.dart';
import 'package:loja_free_style/common/custom_drawer/custom_drawer.dart';
import 'package:loja_free_style/model/home_manager.dart';
import 'package:loja_free_style/screens/cart/components/section_staggered.dart';
import 'package:loja_free_style/screens/home/components/section_list.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 211, 118, 130),
                  Color.fromARGB(255, 253, 181, 168)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                snap: true,
                floating: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('Detona Surf'),
                  centerTitle: true,
                ),
                actions: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pushNamed('/cart'), 
                    icon: const Icon(Icons.shopping_cart),
                    color: Colors.black,
                  ),
                ],
              ),
              Consumer<HomeManager>(
                builder: (_, homeManager, __){
                  final List<Widget> children = homeManager.sections
                    .map<Widget>((section) {
                      switch(section.type){
                        case 'List':
                          return SectionList(section: section,);
                        case 'Staggered':
                          return SectionStaggered(section: section,);
                        default:
                          return Container();
                      }
                    }).toList();
                  
                  return SliverList(
                delegate: SliverChildListDelegate(children),
                  );
                }
              ),
            ],
          ),
        ],
      ),
    );
  }
}