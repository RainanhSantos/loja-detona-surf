import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_free_style/model/cart_product.dart';
import 'package:loja_free_style/model/product.dart';
import 'package:loja_free_style/model/user.dart';
import 'package:loja_free_style/model/user_manager.dart';

class CartManager extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<CartProduct> items = [];

  late User? user;

  num productsPrice = 0.0;

  CollectionReference get cartReference =>
      firestore.collection('users').doc(user?.id).collection('cart');

  void updateUser(UserManager userManager) {
    user = userManager.user;
    items.clear();

    if (user != null) {
      _loadCartItems();
    }
  }

  Future<void> _loadCartItems() async {
    final cartSnap = await cartReference.get();

    final futures = cartSnap.docs.map((d) async {
      final cartProduct = await CartProduct.fromDocument(d);
      cartProduct.addListener(_onItemUpdate);
      return cartProduct;
    });

    items = await Future.wait(futures);

    _onItemUpdate(); // Garante que o total seja recalculado após carregar os itens

    notifyListeners();
  }

  void addToCart(Product product) {
    try {
      final existing = items.firstWhere((p) => p.stackable(product));
      existing.increment();
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdate);
      items.add(cartProduct);

      user?.cartReference.add(cartProduct.toCartItemMap()).then((doc) {
        cartProduct.id = doc.id;
        notifyListeners();
        _onItemUpdate();
      });
    }
    notifyListeners();
  }

  void removeOfCart(CartProduct cartProduct) {
    items.removeWhere((p) =>
        p.id == cartProduct.id ||
        (p.productID == cartProduct.productID && p.size == cartProduct.size));

    if (cartProduct.id.isNotEmpty) {
      user?.cartReference.doc(cartProduct.id).delete();
    }

    cartProduct.removeListener(_onItemUpdate);
    notifyListeners();
  }

  void _onItemUpdate() {
    productsPrice = 0.0;
    final itemsCopy = List<CartProduct>.from(items);

    for (final cartProduct in itemsCopy) {
      if (cartProduct.quantity == 0) {
        removeOfCart(cartProduct);
      } else {
        productsPrice += cartProduct.totalPrice;
        _updateCartProduct(cartProduct);
      }
    }

    notifyListeners();
  }

  void _updateCartProduct(CartProduct cartProduct) {
    if (cartProduct.id.isNotEmpty) {
      user?.cartReference
          .doc(cartProduct.id)
          .set(cartProduct.toCartItemMap(), SetOptions(merge: true));
    }
  }

  bool get isCartValid {
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) return false;
    }
    return true;
  }
}
