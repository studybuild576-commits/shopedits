import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  final String title;
  final Uint8List? imageBytes;
  final bool isLoading;
  final bool isResult;
  final VoidCallback? onPick;

  const ImageDisplay({required this.title, this.imageBytes, this.isLoading = false, this.isResult = false, this.onPick, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onPick,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade700), borderRadius: BorderRadius.circular(12)),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : imageBytes != null
                    ? ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.memory(imageBytes!))
                    : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(isResult ? Icons.auto_fix_high : Icons.add_photo_alternate_outlined, size: 60, color: Colors.grey),
                        if (!isResult) const SizedBox(height: 6),
                        if (!isResult) const Text("Click to Upload", style: TextStyle(color: Colors.grey)),
                      ])),
          ),
        ),
      ],
    );
  }
}
