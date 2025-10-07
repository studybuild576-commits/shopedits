// lib/widgets/image_container.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  final Uint8List? imageBytes;
  final VoidCallback onTap;

  const ImageContainer({
    super.key,
    this.imageBytes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: imageBytes != null
                ? Image.memory(imageBytes!, fit: BoxFit.contain)
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined,
                            size: 60, color: Colors.grey[600]),
                        const SizedBox(height: 16),
                        Text('Tap to Upload Image',
                            style:
                                TextStyle(color: Colors.grey[700], fontSize: 16)),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
