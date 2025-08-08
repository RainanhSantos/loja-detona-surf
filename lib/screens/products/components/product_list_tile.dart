import 'package:flutter/material.dart';
import 'package:loja_free_style/models/product.dart';

class ProductListTile extends StatelessWidget {

  const ProductListTile({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed('/product', arguments: product);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4), 
        ),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(8), 
          child: Row(
            children: [
          
              AspectRatio(
                aspectRatio: 1,
                child: product.images.isNotEmpty
                    ? Image.network(
                        Uri.encodeFull(product.images.first), 
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          
                          debugPrint('Erro ao carregar imagem: ${product.images.first}');
                          return const Icon(Icons.broken_image);
                        },
                      )
                    : const Icon(Icons.image_not_supported), 
              ),
              const SizedBox(width: 12), 
              
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
