import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart' as html;

class BackgroundRemoverPage extends StatefulWidget {
  const BackgroundRemoverPage({super.key});
  @override
  _BackgroundRemoverPageState createState() => _BackgroundRemoverPageState();
}

class _BackgroundRemoverPageState extends State<BackgroundRemoverPage> {
  Uint8List? _originalImageBytes;
  Uint8List? _processedImageBytes;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _originalImageBytes = bytes;
        _processedImageBytes = null;
        _errorMessage = '';
        removeBackground();
      });
    }
  }

  Future<void> removeBackground() async {
    if (_originalImageBytes == null) return;
    setState(() => _isLoading = true);

    const String apiUrl = 'https://rahul7273-shop-edits-images.hf.space/run/predict';

    try {
      final uri = Uri.parse(apiUrl);
      final base64Image = base64Encode(_originalImageBytes!);
      
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "fn_index": 0, // Batata hai ki Gradio ka pehla tool use karna hai
          "data": [ "data:image/png;base64,$base64Image" ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'][0].split(',').last;
        setState(() => _processedImageBytes = base64Decode(data));
      } else {
        setState(() => _errorMessage = 'Error: ${response.statusCode}. Backend returned an error.');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error: $e. Could not connect to the server.');
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  void downloadImage() {
    if (_processedImageBytes == null) return;
    final base64 = base64Encode(_processedImageBytes!);
    final anchor = html.AnchorElement(href: 'data:image/png;base64,$base64')
      ..setAttribute('download', 'removed_bg.png')
      ..click();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Background Remover')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ImageDisplay(title: 'Original', imageBytes: _originalImageBytes, onPick: pickImage),
                  ImageDisplay(title: 'Result', imageBytes: _processedImageBytes, isLoading: _isLoading, isResult: true),
                ],
              ),
              const SizedBox(height: 32),
              if (_processedImageBytes != null && !_isLoading)
                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text('Download Image'),
                  onPressed: downloadImage,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
                ),
              if (_errorMessage.isNotEmpty)
                Padding(padding: const EdgeInsets.only(top: 16), child: Text(_errorMessage, style: const TextStyle(color: Colors.red))),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper Widget (Aap ise alag file `lib/widgets.dart` mein bhi rakh sakte hain)
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
            width: 300,
            height: 300,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade700), borderRadius: BorderRadius.circular(12)),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : imageBytes != null
                    ? ClipRRect(borderRadius: BorderRadius.circular(11), child: Image.memory(imageBytes!))
                    : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(isResult ? Icons.auto_fix_high : Icons.add_photo_alternate_outlined, size: 60, color: Colors.grey), if (!isResult) const SizedBox(height: 8), if (!isResult) const Text("Click to Upload")])),
          ),
        ),
      ],
    );
  }
}
