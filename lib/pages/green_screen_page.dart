import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/image_display.dart';
import 'package:image/image.dart' as img_lib;
import 'package:universal_html/html.dart' as html;

class GreenScreenPage extends StatefulWidget {
  const GreenScreenPage({super.key});

  @override
  _GreenScreenPageState createState() => _GreenScreenPageState();
}

class _GreenScreenPageState extends State<GreenScreenPage> {
  Uint8List? _original;
  Uint8List? _result;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _original = await image.readAsBytes();
      setState(() => _result = null);
      applyGreenScreen();
    }
  }

  void applyGreenScreen() {
    if (_original == null) return;
    final decoded = img_lib.decodeImage(_original!)!;
    final greenImg = img_lib.Image(decoded.width, decoded.height);
    img_lib.fill(greenImg, img_lib.getColor(0, 255, 0));
    img_lib.copyInto(greenImg, decoded);
    _result = Uint8List.fromList(img_lib.encodePng(greenImg));
    setState(() {});
  }

  void downloadImage() {
    if (_result == null) return;
    final base64Data = base64Encode(_result!);
    final anchor = html.AnchorElement(href: "data:image/png;base64,$base64Data")
      ..setAttribute("download", "green_screen.png")
      ..click();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Green Screen")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ImageDisplay(title: "Original", imageBytes: _original, onPick: pickImage),
                ImageDisplay(title: "Result", imageBytes: _result, isResult: true),
              ],
            ),
            const SizedBox(height: 20),
            if (_result != null)
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text("Download"),
                onPressed: downloadImage,
              ),
          ],
        ),
      ),
    );
  }
}
