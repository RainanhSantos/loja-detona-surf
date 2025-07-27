import 'package:flutter/material.dart';
import 'package:loja_free_style/model/product.dart';

/// Widget que exibe um produto em formato de card com imagem e nome.
class ProductListTile extends StatelessWidget {
  /// Construtor exige um produto como parâmetro.
  const ProductListTile({
    super.key,
    required this.product,
  });

  /// Objeto do tipo Product que contém os dados a serem exibidos.
  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed('/product', arguments: product);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4), // Borda levemente arredondada.
        ),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(8), // Espaçamento interno.
          child: Row(
            children: [
              // Mostra a imagem principal do produto (se existir)
              AspectRatio(
                aspectRatio: 1,
                child: product.images.isNotEmpty
                    ? Image.network(
                        Uri.encodeFull(product.images.first), // Corrige URLs com acentos
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Mostra ícone padrão caso a imagem falhe
                          debugPrint('Erro ao carregar imagem: ${product.images.first}');
                          return const Icon(Icons.broken_image);
                        },
                      )
                    : const Icon(Icons.image_not_supported), // Caso a lista esteja vazia.
              ),
              const SizedBox(width: 12), // Espaço entre a imagem e o texto
              // Exibe o nome do produto
              const SizedBox(width: 16,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'A partir de',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      'R\$ 19.99',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
