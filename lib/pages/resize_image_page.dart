import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/image_display.dart';
import 'package:image/image.dart' as img_lib;
import 'package:universal_html/html.dart' as html;

class ResizeImagePage extends StatefulWidget {
  const ResizeImagePage({super.key});

  @override
  _ResizeImagePageState createState() => _ResizeImagePageState();
}

class _ResizeImagePageState extends State<ResizeImagePage> {
  Uint8List? _original;
  Uint8List? _resized;
  int _width = 1920;
  int _height = 1080;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _original = await image.readAsBytes();
      setState(() => _resized = null);
      resizeImage();
    }
  }

  void resizeImage() {
    if (_original == null) return;
    final decoded = img_lib.decodeImage(_original!)!;
    final resizedImg = img_lib.copyResize(decoded, width: _width, height: _height);
    _resized = Uint8List.fromList(img_lib.encodePng(resizedImg));
    setState(() {});
  }

  void downloadImage() {
    if (_resized == null) return;
    final base64Data = base64Encode(_resized!);
    final anchor = html.AnchorElement(href: "data:image/png;base64,$base64Data")
      ..setAttribute("download", "resized_image.png")
      ..click();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Resize Image")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ImageDisplay(title: "Original", imageBytes: _original, onPick: pickImage),
                ImageDisplay(title: "Resized", imageBytes: _resized, isResult: true),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: TextField(
                    decoration: const InputDecoration(labelText: "Width"),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => _width = int.tryParse(val) ?? 1920,
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 120,
                  child: TextField(
                    decoration: const InputDecoration(labelText: "Height"),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => _height = int.tryParse(val) ?? 1080,
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(onPressed: resizeImage, child: const Text("Resize"))
              ],
            ),
            const SizedBox(height: 20),
            if (_resized != null)
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text("Download Image"),
                onPressed: downloadImage,
              ),
          ],
        ),
      ),
    );
  }
}
