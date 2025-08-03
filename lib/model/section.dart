import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_free_style/model/section_item.dart';

class Section {
  late String name;
  late String type;
  late List<SectionItem> items;

  Section.fromDocument(DocumentSnapshot document) {
    final data = document.data()! as Map<String, dynamic>;

    name = data['name']?.toString() ?? '';
    type = data['type']?.toString() ?? '';
    items = (data['items'] as List?)
            ?.whereType<Map<String, dynamic>>() // Filtra apenas mapas válidos
            .map((i) => SectionItem.fromMap(i))
            .toList() ?? [];
  }

  @override
  String toString() {
    return 'Section{name: $name, type: $type, items: $items}';
  }
}
