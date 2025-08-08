import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loja_free_style/models/product.dart';
import 'package:loja_free_style/screens/edit_product/components/image_source_sheet.dart';

class ImagesForm extends StatefulWidget {
  const ImagesForm({super.key, required this.product});

  final Product product;

  @override
  State<ImagesForm> createState() => _ImagesFormState();
}

class _ImagesFormState extends State<ImagesForm> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  List<dynamic> get images => widget.product.images;

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: images,
      builder: (state) {
        final pages = images.map<Widget>((image) {
          return Stack(
            fit: StackFit.expand,
            children: [
              if (image is String)
                Image.network(image, fit: BoxFit.cover)
              else
                Image.file(image as File, fit: BoxFit.cover),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.remove_circle),
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      images.remove(image);
                      state.didChange(images);
                    });
                  },
                ),
              ),
            ],
          );
        }).toList()
          ..add(
            Material(
              color: Colors.grey[100],
              child: IconButton(
                icon: const Icon(Icons.add_a_photo),
                color: Theme.of(context).primaryColor,
                iconSize: 50,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => ImageSourceSheet(
                    ),
                  );
                },
              ),
            ),
          );

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      setState(() => currentPage = index);
                    },
                    itemBuilder: (_, index) => pages[index],
                  ),
                  if (currentPage > 0)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_back_ios, color: Colors.black54),
                        ),
                      ),
                    ),
                  if (currentPage < pages.length - 1)
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_forward_ios, color: Colors.black54),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Deslize para o lado para ver mais',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
      validator: (images) {
        if (images == null || images.isEmpty) {
          return 'Adicione ao menos uma imagem';
        }
        return null;
      },
    );
  }
}
