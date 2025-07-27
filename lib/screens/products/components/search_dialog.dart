import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {
  const SearchDialog({super.key, this.initialText});

  final String? initialText;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Align(
        alignment: Alignment.topCenter, // Posiciona no topo
        child: Container(
          margin: const EdgeInsets.only(top: 2, left: 4, right: 4), // Distância do topo
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            initialValue: initialText,
            textInputAction: TextInputAction.search,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Buscar',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              prefixIcon: IconButton(
                onPressed: (){
                  Navigator.of(context).pop();
                }, 
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            onFieldSubmitted: (text){
              Navigator.of(context).pop(text);
            },
          ),
        ),
      ),
    );
  }
}
