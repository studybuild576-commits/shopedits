// lib/widgets/result_container.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';

class ResultContainer extends StatelessWidget {
  final Uint8List? imageBytes;
  final bool isLoading;

  const ResultContainer({
    super.key,
    this.imageBytes,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : imageBytes != null
                    ? Image.memory(imageBytes!, fit: BoxFit.contain)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_search,
                              size: 60, color: Colors.grey[600]),
                          const SizedBox(height: 16),
                          Text('Result will appear here',
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 16)),
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}
