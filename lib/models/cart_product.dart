import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_free_style/models/item_size.dart';
import 'package:loja_free_style/models/product.dart';

class CartProduct extends ChangeNotifier {
  CartProduct({
    required this.id,
    required this.productID,
    required this.quantity,
    required this.size,
    required this.product,
  });

  CartProduct.fromProduct(this.product)
      : id = '',
        productID = product.id,
        quantity = 1,
        size = product.selectedSize!.name;

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

  ItemSize? get itemSize => product.findSize(size);

  num get unitPrice => itemSize?.price ?? 0;

  num get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': productID,
      'quantity': quantity,
      'size': size,
    };
  }

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

  bool get hasStock {
    final size = itemSize;
    if (size == null) return false;
    return size.stock >= quantity;
  }
}
