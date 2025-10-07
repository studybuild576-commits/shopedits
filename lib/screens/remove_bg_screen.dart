// lib/screens/remove_bg_screen.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/api_service.dart'; // ApiService को इम्पोर्ट करें
import '../widgets/info_card.dart';
import '../widgets/image_container.dart';
import '../widgets/result_container.dart';

class RemoveBgScreen extends StatefulWidget {
  const RemoveBgScreen({super.key});

  @override
  State<RemoveBgScreen> createState() => _RemoveBgScreenState();
}

class _RemoveBgScreenState extends State<RemoveBgScreen> {
  Uint8List? _originalImage;
  Uint8List? _processedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _originalImage = bytes;
        _processedImage = null;
      });
    }
  }

  Future<void> _removeBackground() async {
    if (_originalImage == null) {
      Fluttertoast.showToast(msg: "Please upload an image first.");
      return;
    }
    setState(() {
      _isLoading = true;
      _processedImage = null;
    });

    final result = await ApiService.removeBackground(_originalImage!);

    setState(() {
      _processedImage = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 800;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const InfoCard(
                title: 'High-Quality Background Remover',
                subtitle:
                    'Upload an image to automatically remove the background with professional-grade quality.',
                icon: Icons.auto_fix_high,
              ),
              const SizedBox(height: 20),
              isSmallScreen
                  ? Column(
                      children: [
                        ImageContainer(
                          imageBytes: _originalImage,
                          onTap: _pickImage,
                        ),
                        const SizedBox(height: 20),
                        ResultContainer(
                          imageBytes: _processedImage,
                          isLoading: _isLoading,
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ImageContainer(
                            imageBytes: _originalImage,
                            onTap: _pickImage,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ResultContainer(
                            imageBytes: _processedImage,
                            isLoading: _isLoading,
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _removeBackground,
                icon: const Icon(Icons.rocket_launch),
                label: const Text('Remove Background'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
