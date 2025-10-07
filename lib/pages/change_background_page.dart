import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart' as html;

class ChangeBackgroundPage extends StatefulWidget {
  const ChangeBackgroundPage({super.key});
  @override
  _ChangeBackgroundPageState createState() => _ChangeBackgroundPageState();
}

class _ChangeBackgroundPageState extends State<ChangeBackgroundPage> {
  Uint8List? _mainImageBytes;
  Uint8List? _bgImageBytes;
  Uint8List? _processedImageBytes;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<Uint8List?> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return await image.readAsBytes();
    }
    return null;
  }

  Future<void> changeBackground() async {
    if (_mainImageBytes == null) return;
    setState(() => _isLoading = true);

    const String apiUrl = 'https://rahul7273-shop-edits-images.hf.space/run/predict';

    try {
      final uri = Uri.parse(apiUrl);
      final base64Main = base64Encode(_mainImageBytes!);
      final base64Bg = _bgImageBytes != null ? base64Encode(_bgImageBytes!) : null;

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "fn_index": 1, // Batata hai ki Gradio ka doosra tool use karna hai
          "data": [
            "data:image/png;base64,$base64Main",
            _bgImageBytes != null ? "data:image/png;base64,$base64Bg" : null,
            "#FFFFFF" // Default color, abhi hum ise change nahi kar rahe
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'][0].split(',').last;
        setState(() => _processedImageBytes = base64Decode(data));
      } else {
        setState(() => _errorMessage = 'Error: ${response.statusCode}.');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error: $e.');
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  void downloadImage() {
    // ... download code
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Background')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Main Image Picker
                  ImagePickerBox(
                    title: "Main Image",
                    imageBytes: _mainImageBytes,
                    onPick: () async {
                      final bytes = await pickImage();
                      if (bytes != null) setState(() => _mainImageBytes = bytes);
                    },
                  ),
                  // Background Image Picker
                  ImagePickerBox(
                    title: "Background Image",
                    imageBytes: _bgImageBytes,
                    onPick: () async {
                      final bytes = await pickImage();
                      if (bytes != null) setState(() => _bgImageBytes = bytes);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading || _mainImageBytes == null ? null : changeBackground,
                child: const Text("Change Background"),
              ),
              const SizedBox(height: 20),
              // Result Image
              if (_isLoading) const CircularProgressIndicator(),
              if (_processedImageBytes != null)
                Image.memory(_processedImageBytes!, height: 250),
              if (_errorMessage.isNotEmpty) Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper Widget
class ImagePickerBox extends StatelessWidget {
  final String title;
  final Uint8List? imageBytes;
  final VoidCallback onPick;
  const ImagePickerBox({required this.title, this.imageBytes, required this.onPick, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        InkWell(
          onTap: onPick,
          child: Container(
            width: 250, height: 250,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: imageBytes != null ? Image.memory(imageBytes!) : const Icon(Icons.add_a_photo, size: 50),
          ),
        ),
      ],
    );
  }
}
