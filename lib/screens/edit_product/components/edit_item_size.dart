import 'package:flutter/material.dart';
import 'package:loja_free_style/common/custom_icon_button.dart';
import 'package:loja_free_style/models/item_size.dart';

class EditItemSize extends StatelessWidget {
  const EditItemSize({
    super.key,
    this.size,
    this.onRemove,
    this.onMoveDown,
    this.onMoveUp,
  });

  final ItemSize? size;
  final VoidCallback? onRemove;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size?.name ?? '',
            decoration: const InputDecoration(
              labelText: 'Título',
              isDense: true,
            ),
            validator: (name){
              if(name!.isEmpty){
                return 'Inválido';
              } return null;
            },
            onChanged: (name) => size?.name = name,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size != null ? size!.stock.toString() : '0',
            decoration: const InputDecoration(
              labelText: 'Estoque',
              isDense: true,
            ),
            validator: (stock){
              if(int.tryParse(stock!) == null){
                return 'Inválido';
              } return null;
            },
            keyboardType: TextInputType.number,
            onChanged: (stock) => size?.stock = int.tryParse(stock) ?? 0,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 40,
          child: TextFormField(
            initialValue: size != null ? size!.price.toStringAsFixed(2) : '0.00',
            decoration: const InputDecoration(
              labelText: 'Preço',
              isDense: true,
              prefixText: 'R\$ ',
            ),
            validator: (price){
              if(num.tryParse(price!) == null){
                return 'Inválido';
              } return null;
            },
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (price) => size?.price = num.tryParse(price) ?? 0,
          ),
        ),
        CustomIconButton(
          iconData: Icons.remove,
          color: Colors.red,
          onTap: onRemove ?? (){},
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_up,
          color: Colors.black,
          onTap: onMoveUp ?? (){}, 
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_down,
          color: Colors.black,
          onTap: onMoveDown ?? (){},
        ),
      ],
    );
  }
}
