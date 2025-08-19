import 'dart:io';
import 'package:flutter/cupertino.dart';
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

  List<String> get images => widget.product.images;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FormField<List<String>>(
        initialValue: List.from(images),
        autovalidateMode: AutovalidateMode.always,
        validator: (images) {
          if (images == null || images.isEmpty) {
            return 'Adicione ao menos uma imagem';
          }
          return null;
        },
        onSaved: (images) => widget.product.newImages = images ?? [],
        builder: (state) {
          void onImageSelected(File file) {
            final String path = file.path;

            state.value?.add(path);
            widget.product.images.add(path);

            state.didChange(List.from(state.value ?? []));
            setState(() {});
          }

          final pages = images.map<Widget>((image) {
            final imageWidget = (image.startsWith('http'))
                ? Image.network(image, fit: BoxFit.cover)
                : Image.file(File(image), fit: BoxFit.cover);

            return Stack(
              fit: StackFit.expand,
              children: [
                imageWidget,
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        images.remove(image);
                        widget.product.images.remove(image);
                        state.didChange(List.from(images));
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
                    if (Platform.isAndroid) {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => ImageSourceSheet(
                          onImageSelected: onImageSelected,
                        ),
                      );
                    } else {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (_) => ImageSourceSheet(
                          onImageSelected: onImageSelected,
                        ),
                      );
                    }
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
                            child: Icon(Icons.arrow_back_ios,
                                color: Colors.black54),
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
                            child: Icon(Icons.arrow_forward_ios,
                                color: Colors.black54),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 16, left: 16),
                    child: Text(
                      state.errorText ?? '',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                'Deslize para o lado para ver mais',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          );
        },
      ),
    );
  }
}
