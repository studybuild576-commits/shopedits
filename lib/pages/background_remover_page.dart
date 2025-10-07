import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../widgets/image_display.dart';
import 'package:universal_html/html.dart' as html;

class BackgroundRemoverPage extends StatefulWidget {
  const BackgroundRemoverPage({super.key});

  @override
  _BackgroundRemoverPageState createState() => _BackgroundRemoverPageState();
}

class _BackgroundRemoverPageState extends State<BackgroundRemoverPage> {
  Uint8List? _originalImage;
  Uint8List? _resultImage;
  bool _isLoading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _originalImage = bytes;
        _resultImage = null;
      });
      await removeBackground();
    }
  }

  Future<void> removeBackground() async {
    if (_originalImage == null) return;
    setState(() => _isLoading = true);

    const url = 'https://huggingface.co/rahul7273-shop-edits-images/resolve/main/run/predict';
    try {
      final base64Img = base64Encode(_originalImage!);
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "fn_index": 0,
          "data": ["data:image/png;base64,$base64Img"]
        }),
      );

      if (response.statusCode == 200) {
        final resultBase64 = jsonDecode(response.body)['data'][0].split(',').last;
        setState(() => _resultImage = base64Decode(resultBase64));
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void downloadResult() {
    if (_resultImage == null) return;
    final base64Data = base64Encode(_resultImage!);
    final anchor = html.AnchorElement(href: "data:image/png;base64,$base64Data")
      ..setAttribute("download", "removed_bg.png")
      ..click();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Background Remover")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ImageDisplay(title: "Original", imageBytes: _originalImage, onPick: pickImage),
                ImageDisplay(title: "Result", imageBytes: _resultImage, isLoading: _isLoading, isResult: true),
              ],
            ),
            const SizedBox(height: 30),
            if (_resultImage != null)
              ElevatedButton.icon(
                onPressed: downloadResult,
                icon: const Icon(Icons.download),
                label: const Text("Download Image"),
              ),
          ],
        ),
      ),
    );
  }
}
