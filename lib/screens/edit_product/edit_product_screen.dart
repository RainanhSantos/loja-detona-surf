import 'package:flutter/material.dart';
import 'package:loja_free_style/models/product.dart';
import 'package:loja_free_style/screens/edit_product/components/images_form.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Anúncio'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ImagesForm(product: product,),
        ],
      ),
    );
  }
}