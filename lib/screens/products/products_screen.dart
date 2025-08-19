import 'package:flutter/material.dart';
import 'package:loja_free_style/common/custom_drawer/custom_drawer.dart';
import 'package:loja_free_style/models/product_manager.dart';
import 'package:loja_free_style/models/user_manager.dart';
import 'package:loja_free_style/screens/products/components/product_list_tile.dart';
import 'package:loja_free_style/screens/products/components/search_dialog.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 211, 118, 130),
                Color.fromARGB(255, 253, 181, 168),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent, // deixa o gradiente visível
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop(); // volta para a tela anterior
              },
            ),
            title: Consumer<ProductManager>(
              builder: (_, productManager, __) {
                if (productManager.search.isEmpty) {
                  return const Text(
                    'Produtos',
                    style: TextStyle(
                      fontFamily: 'Playwrite',
                    ),
                  );
                } else {
                  return LayoutBuilder(
                    builder: (_, constraints) {
                      return GestureDetector(
                        onTap: () async {
                          final search = await showDialog<String>(
                            context: context,
                            builder: (_) => SearchDialog(
                              initialText: productManager.search,
                            ),
                          );
                          if (search != null) {
                            productManager.search = search;
                          }
                        },
                        child: Container(
                          width: constraints.biggest.width,
                          alignment: Alignment.center,
                          child: Text(
                            productManager.search,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            centerTitle: true,
            actions: [
              Consumer<ProductManager>(
                builder: (_, productManager, __) {
                  if (productManager.search.isEmpty) {
                    return IconButton(
                      onPressed: () async {
                        final search = await showDialog<String>(
                          context: context,
                          builder: (_) => SearchDialog(
                            initialText: productManager.search,
                          ),
                        );
                        if (search != null) {
                          productManager.search = search;
                        }
                      },
                      icon: const Icon(Icons.search),
                    );
                  } else {
                    return IconButton(
                      onPressed: () {
                        productManager.search = '';
                      },
                      icon: const Icon(Icons.close),
                    );
                  }
                },
              ),
              Consumer<UserManager>(
                builder: (_, userManager, __) {
                  if (userManager.adminEnabled) {
                    return IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/edit_product');
                      },
                      icon: const Icon(Icons.add),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) {
          final filteredProducts = productManager.filteredProducts;
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 211, 118, 130),
                  Color.fromARGB(255, 253, 181, 168),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: filteredProducts.length,
              itemBuilder: (_, index) {
                return ProductListTile(product: filteredProducts[index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed('/cart');
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
