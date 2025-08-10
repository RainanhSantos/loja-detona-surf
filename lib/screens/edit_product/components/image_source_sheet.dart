// image_source_sheet.dart
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  ImageSourceSheet({super.key, required this.onImageSelected});

  final Function(File) onImageSelected;
  final ImagePicker picker = ImagePicker();

  Future<void> editImage(String path, BuildContext context) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Editar Foto',
          toolbarColor: Colors.transparent,
          toolbarWidgetColor: Colors.transparent,
          statusBarColor: Colors.transparent,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          cropFrameStrokeWidth: 2,
          cropGridStrokeWidth: 1,
          hideBottomControls: false,
          showCropGrid: true,
        ),
        IOSUiSettings(
          title: 'Editar Foto',
          aspectRatioLockEnabled: false,
          resetButtonHidden: false,
          rotateButtonsHidden: false,
          doneButtonTitle: 'Confirmar',
          cancelButtonTitle: 'Cancelar',
        ),
      ],
    );

    if (croppedFile != null) {
      final File imageFile = File(croppedFile.path);
      onImageSelected(imageFile);
      Navigator.of(context).pop();  // Apenas fecha o sheet
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return SafeArea(
        child: BottomSheet(
          onClosing: () {},
          builder: (_) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                onPressed: () async {
                  final XFile? file = await picker.pickImage(source: ImageSource.camera);
                  if (file != null) {
                    await editImage(file.path, context);
                  }
                },
                child: const Text('Câmera', style: TextStyle(fontSize: 25, color: Colors.black)),
              ),
              const Divider(),
              TextButton(
                onPressed: () async {
                  final XFile? file = await picker.pickImage(source: ImageSource.gallery);
                  if (file != null) {
                    await editImage(file.path, context);
                  }
                },
                child: const Text('Galeria', style: TextStyle(fontSize: 25, color: Colors.black)),
              ),
            ],
          ),
        ),
      );
    } else {
      return SafeArea(
        child: CupertinoActionSheet(
          title: const Text('Selecionar foto para o item'),
          message: const Text('Escolha a origem da foto'),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                final XFile? file = await picker.pickImage(source: ImageSource.camera);
                if (file != null) {
                  onImageSelected(File(file.path));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Câmera'),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                final XFile? file = await picker.pickImage(source: ImageSource.gallery);
                if (file != null) {
                  onImageSelected(File(file.path));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Galeria'),
            ),
          ],
        ),
      );
    }
  }
}
