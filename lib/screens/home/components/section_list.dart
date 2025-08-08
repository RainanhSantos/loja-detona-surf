import 'package:flutter/material.dart';
import 'package:loja_free_style/models/section.dart';
import 'package:loja_free_style/screens/cart/components/item_tile.dart';
import 'package:loja_free_style/screens/home/components/section_header.dart';

class SectionList extends StatelessWidget {
  const SectionList({super.key, required this.section});

  final Section section;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(section: section),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                return ItemTile(item: section.items[index]);
              },
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemCount: section.items.length,
            ),
          ),
        ],
      ),
    );
  }
}
