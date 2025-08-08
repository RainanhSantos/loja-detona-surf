class SectionItem {
  SectionItem.fromMap(Map<String, dynamic> map) {
    image = map['image']?.toString() ?? '';
    product = map['product']?.toString() ?? '';
  }

  late String image;
  late String product;

  @override
  String toString() {
    return 'SectionItem{image: $image, product: $product}';
  }
}
