import 'package:flutter/material.dart';

class ImageSourceSheet extends StatelessWidget {
  const ImageSourceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomSheet(
        onClosing: (){},
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: (){
      
              }, 
              child: const Text('Cêmera')
            ),
            TextButton(
              onPressed: (){
                
              }, 
              child: const Text('Galeria')
            ),
          ],
        ),
      ),
    );
  }
}