import 'package:flutter/material.dart';
import 'package:loja_free_style/models/product.dart';
import 'package:loja_free_style/screens/edit_product/components/images_form.dart';
import 'package:loja_free_style/screens/edit_product/components/sizes_form.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen({super.key, Product? p})
      : editing = (p != null), product = (p != null) ? p.clone() : Product();

  final Product product;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final bool editing;


  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Editar Anúncio' : 'Criar anúncio'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // título e ícone de volta visíveis
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            ImagesForm(product: product),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Título
                  TextFormField(
                    initialValue: product.name,
                    decoration: const InputDecoration(
                      hintText: 'Título',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    validator: (name) {
                      if (name == null || name.trim().length < 6) {
                        return 'Título muito curto';
                      }
                      return null;
                    },
                    onSaved: (name) => product.name = name ?? '',
                  ),

                  const SizedBox(height: 4),

                  // Preço inicial
                  Text(
                    'A partir de R\$ ...',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'Descrição',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // Descrição
                  TextFormField(
                    initialValue: product.description,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: 'Descrição',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    validator: (desc) {
                      if (desc == null || desc.trim().length < 10) {
                        return 'Descrição muito curta';
                      }
                      return null;
                    },
                    onSaved: (desc) => product.description = desc ?? '',
                  ),

                  const SizedBox(height: 16),

                  // Formulário de tamanhos
                  SizesForm(product: product),

                  const SizedBox(height: 20),

                  // Botão Salvar
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState?.save();

                          product.save();
                          
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        disabledBackgroundColor: primaryColor.withAlpha(100),
                      ),
                      child: const Text(
                        'Salvar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
