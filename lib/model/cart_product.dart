import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_free_style/model/item_size.dart';
import 'package:loja_free_style/model/product.dart';

class CartProduct extends ChangeNotifier {
  CartProduct({
    required this.id,
    required this.productID,
    required this.quantity,
    required this.size,
    required this.product,
  });

  // Cria um CartProduct a partir de um produto, com id vazio até que o Firestore defina
  CartProduct.fromProduct(this.product)
      : id = '',
        productID = product.id,
        quantity = 1,
        size = product.selectedSize!.name;

  // Constrói a partir de um documento salvo no Firestore
  static Future<CartProduct> fromDocument(DocumentSnapshot document) async {
    final data = document.data()! as Map<String, dynamic>;

    final id = document.id;
    final String productID = data['pid'] as String;
    final int quantity = data['quantity'] as int;
    final String size = data['size'] as String;

    final productDoc =
        await FirebaseFirestore.instance.doc('products/$productID').get();

    final product = Product.fromDocument(productDoc);

    return CartProduct(
      id: id,
      productID: productID,
      quantity: quantity,
      size: size,
      product: product,
    );
  }

  String id; 
  final String productID;
  int quantity;
  final String size;
  final Product product;

  // Busca a variação de tamanho
  ItemSize? get itemSize => product.findSize(size);

  // Preço unitário
  num get unitPrice => itemSize?.price ?? 0;

  // Preço total
  num get totalPrice => unitPrice * quantity;

  // Transforma o item em mapa para salvar no Firestore
  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': productID,
      'quantity': quantity,
      'size': size,
    };
  }

  // Verifica se o produto pode ser empilhado no carrinho
  bool stackable(Product product) {
    return product.id == productID &&
        product.selectedSize != null &&
        product.selectedSize!.name == size;
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }

  // Verifica se ainda há estoque
  bool get hasStock {
    final size = itemSize;
    if (size == null) return false;
    return size.stock >= quantity;
  }
}
