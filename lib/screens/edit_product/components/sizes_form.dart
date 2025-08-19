import 'package:flutter/material.dart';
import 'package:loja_free_style/common/custom_icon_button.dart';
import 'package:loja_free_style/models/item_size.dart';
import 'package:loja_free_style/models/product.dart';
import 'package:loja_free_style/screens/edit_product/components/edit_item_size.dart';

class SizesForm extends StatelessWidget {
  const SizesForm({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      initialValue: List.from(product.sizes),
      validator: (sizes) {
        if (sizes == null || sizes.isEmpty) {
          return 'Insira ao menos um tamanho';
        }
        return null;
      },
      // 🔥 garante que ao salvar o formulário, os tamanhos vão para o produto
      onSaved: (sizes) {
        if (sizes != null) {
          product.sizes = sizes;
        }
      },
      builder: (state) {
        final sizes = state.value ?? [];

        return Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Tamanhos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.add,
                  color: Colors.black,
                  onTap: () {
                    // Adiciona um ItemSize vazio
                    sizes.add(ItemSize.empty());
                    state.didChange(List.from(sizes));
                  },
                ),
              ],
            ),
            Column(
              children: sizes.map((size) {
                final index = sizes.indexOf(size);
                return EditItemSize(
                  key: ObjectKey(size),
                  size: size,
                  onRemove: () {
                    sizes.remove(size);
                    state.didChange(List.from(sizes));
                  },
                  onMoveUp: index > 0
                      ? () {
                          sizes.removeAt(index);
                          sizes.insert(index - 1, size);
                          state.didChange(List.from(sizes));
                        }
                      : null,
                  onMoveDown: index < sizes.length - 1
                      ? () {
                          sizes.removeAt(index);
                          sizes.insert(index + 1, size);
                          state.didChange(List.from(sizes));
                        }
                      : null,
                );
              }).toList(),
            ),
            if (state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  state.errorText ?? '',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
