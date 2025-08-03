import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_free_style/model/item_size.dart';

class Product extends ChangeNotifier {
  Product.fromDocument(DocumentSnapshot document) {
    final data = document.data()! as Map<String, dynamic>;

    id = document.id;
    name = data['name'] as String? ?? '';
    description = data['description'] as String? ?? '';

    final rawImages = data['images'];
    if (rawImages != null && rawImages is List) {
      images = List<String>.from(rawImages);
    } else {
      images = [];
    }

    sizes = (data['sizes'] as List<dynamic>? ?? [])
        .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
        .toList();

    _selectedSize = null;
  }

  late String id;
  late String name;
  late String description;
  late List<String> images;
  late List<ItemSize> sizes;

  ItemSize? _selectedSize;

  ItemSize? get selectedSize => _selectedSize;

  set selectedSize(ItemSize? value) {
    _selectedSize = value;
    notifyListeners();
  }

  int get totalStock{
    int stock = 0;
    for(final size in sizes){
      stock += size.stock;
    }
    return stock;
  }

  bool get hasStock{
    return totalStock > 0;
  }

  ItemSize? findSize(String name) {
    try {
      return sizes.firstWhere((s) => s.name == name);
    } catch (_) {
      return null;
    }
  }


}
