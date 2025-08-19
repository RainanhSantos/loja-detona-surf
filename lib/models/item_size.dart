class ItemSize {
  String name;
  num price;
  int stock;

  ItemSize(this.name, this.price, this.stock);

  ItemSize.empty()
      : name = '',
        price = 0,
        stock = 0;

  ItemSize.fromMap(Map<String, dynamic> map)
      : name = map['name']?.toString() ?? '',
        price = (map['price'] is int)
            ? (map['price'] as int).toDouble()
            : (map['price'] as num? ?? 0),
        stock = (map['stock'] as num?)?.toInt() ?? 0;


  bool get hasStock => stock > 0;

  ItemSize clone() => ItemSize(name, price, stock);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'stock': stock,
    };
  }

  @override
  String toString() {
    return 'ItemSize{name: $name, price: $price, stock: $stock}';
  }
}
