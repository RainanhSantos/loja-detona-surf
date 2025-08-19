import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loja_free_style/models/item_size.dart';
import 'package:uuid/uuid.dart';

class Product extends ChangeNotifier {
  String id = '';
  String name = '';
  String description = '';
  List<String> images = [];
  List<ItemSize> sizes = [];
  List<dynamic> newImages = [];

  ItemSize? _selectedSize;
  ItemSize? get selectedSize => _selectedSize;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.doc('products/$id');
  Reference get storageRef => storage.ref().child('products').child(id);

  set selectedSize(ItemSize? value) {
    _selectedSize = value;
    notifyListeners();
  }

  Product({
    this.id = '',
    this.name = '',
    this.description = '',
    List<String>? images,
    List<ItemSize>? sizes,
  })  : images = images ?? [],
        sizes = sizes ?? [],
        _selectedSize = null {
    newImages = List.from(this.images);
  }

  Product.fromDocument(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>? ?? {};
    print("🔥 DATA DO FIRESTORE: $data");

    id = document.id;
    name = data['name'] as String? ?? '';
    description = data['description'] as String? ?? '';

    final rawImages = data['images'];
    images = (rawImages != null && rawImages is List)
        ? List<String>.from(rawImages)
        : [];

    sizes = (data['sizes'] as List<dynamic>? ?? [])
        .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
        .toList();

    newImages = List.from(images);
    _selectedSize = null;
  }

  int get totalStock {
    int stock = 0;
    for (final size in sizes) {
      stock += size.stock;
    }
    return stock;
  }

  bool get hasStock => totalStock > 0;

  num get basePrice {
    num lowest = double.infinity;
    for (final size in sizes) {
      if (size.hasStock && (size.price) < lowest) {
        lowest = size.price;
      }
    }
    return lowest == double.infinity ? 0 : lowest;
  }

  ItemSize? findSize(String name) {
    try {
      return sizes.firstWhere((s) => s.name == name);
    } catch (_) {
      return null;
    }
  }

  List<Map<String, dynamic>> exportSizeList() {
    return sizes.map((size) => size.toMap()).toList();
  }

  Future<void> save() async {
    
    final Map<String, dynamic> baseData = {
      'name': name,
      'description': description,
      'sizes': exportSizeList(),
    };

    if (id.isEmpty) {
      final doc = await firestore.collection('products').add(baseData);
      id = doc.id;
    } else {
      await firestoreRef.update(baseData);
    }

    final List<String> updateImages = [];

    if (newImages.isEmpty && images.isNotEmpty) {
      updateImages.addAll(images);
    } else {
      for (final newImage in newImages) {
        if (newImage is String && newImage.startsWith('http')) {
          updateImages.add(newImage);
        } else if (newImage is String && !newImage.startsWith('http')) {
          final file = File(newImage);
          final UploadTask task =
              storageRef.child(const Uuid().v1()).putFile(file);
          final TaskSnapshot snapshot = await task;
          final String url = await snapshot.ref.getDownloadURL();
          updateImages.add(url);
        } else if (newImage is File) {
          final UploadTask task =
              storageRef.child(const Uuid().v1()).putFile(newImage);
          final TaskSnapshot snapshot = await task;
          final String url = await snapshot.ref.getDownloadURL();
          updateImages.add(url);
        }
      }

      for (final image in images) {
        if (!updateImages.contains(image)) {
          if (image.startsWith('http') || image.startsWith('gs://')) {
            try {
              final ref = FirebaseStorage.instance.refFromURL(image);
              await ref.delete();
            } catch (e) {
              debugPrint('Falha ao deletar $image: $e');
            }
          }
        }
      }
    }

    await firestoreRef.update({
      'images': updateImages,
      'sizes': exportSizeList(),
    });

    images = updateImages;
    notifyListeners();
  }

  Product clone() {
    return Product(
      id: id,
      name: name,
      description: description,
      images: List.from(images),
      sizes: sizes.map((size) => size.clone()).toList(),
    );
  }
}
