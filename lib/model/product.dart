import 'package:cloud_firestore/cloud_firestore.dart';

/// Classe que representa um produto no sistema.
/// Os dados são carregados a partir de um documento do Firestore.
class Product {
  
  /// Construtor que inicializa os dados do produto com base em um documento Firestore.
  Product.fromDocument(DocumentSnapshot document) {
    // Converte o conteúdo do documento para um mapa de chave/valor.
    final data = document.data()! as Map<String, dynamic>;

    // Obtém o ID do documento (geralmente usado como identificador único no sistema).
    id = document.id;

    // Obtém o nome do produto. Caso esteja ausente ou nulo, usa string vazia como fallback.
    name = data['name'] as String? ?? '';

    // Obtém a descrição do produto. Também usa fallback em caso de ausência.
    description = data['description'] as String? ?? '';

    // Verifica se o campo 'images' existe e é uma lista.
    // Caso contrário, inicializa como uma lista vazia para evitar erros.
    final rawImages = data['images'];
    if (rawImages != null && rawImages is List) {
      images = List<String>.from(rawImages);
    } else {
      images = []; // Valor padrão seguro caso o campo esteja ausente ou inválido.
    }
  }

  /// ID único do produto (corresponde ao ID do documento no Firestore).
  late String id;

  /// Nome do produto.
  late String name;

  /// Descrição do produto.
  late String description;

  /// Lista de URLs das imagens do produto.
  late List<String> images;
}
