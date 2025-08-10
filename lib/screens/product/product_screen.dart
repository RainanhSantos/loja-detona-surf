import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loja_free_style/models/cart_manager.dart';
import 'package:loja_free_style/models/product.dart';
import 'package:loja_free_style/models/user_manager.dart';
import 'package:loja_free_style/screens/product/components/size_widget.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, this.product});

  final Product? product;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final images = product?.images ?? [];
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(product?.name ?? 'Produto'),
          centerTitle: true,
          actions: [
            Consumer<UserManager>(
              builder: (_, userManager, __) {
                if (userManager.adminEnabled) {
                  return IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                        '/edit_product',
                        arguments: product,
                      );
                    },
                    icon: const Icon(Icons.edit),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            if (images.isNotEmpty)
              Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (_, index) {
                        final img = images[index];
                        if (img.startsWith('http') || img.startsWith('https')) {
                          return Image.network(
                            img,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        } else {
                          return Image.file(
                            File(img),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(images.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 12 : 8,
                        height: _currentIndex == index ? 12 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? primaryColor
                              : Colors.grey.withAlpha(120),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    product?.name ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A partir de',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    'R\$ 19.99',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Descrição',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product?.description ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Tamanhos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product!.sizes.map((s) {
                      return SizeWidget(size: s);
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Consumer2<UserManager, Product>(
                    builder: (_, userManager, product, __) {
                      return SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: product.selectedSize != null
                              ? () {
                                  if (userManager.isLoggedIn) {
                                    context.read<CartManager>().addToCart(product);
                                    Navigator.of(context).pushNamed('/cart');
                                  } else {
                                    Navigator.of(context).pushNamed('/login');
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          child: Text(
                            userManager.isLoggedIn
                                ? 'Adicionar ao Carrinho'
                                : 'Entre para Comprar',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
