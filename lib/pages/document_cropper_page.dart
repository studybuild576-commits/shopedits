import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/image_display.dart';
import 'package:image/image.dart' as img_lib;
import 'package:universal_html/html.dart' as html;

class DocumentCropperPage extends StatefulWidget {
  const DocumentCropperPage({super.key});

  @override
  _DocumentCropperPageState createState() => _DocumentCropperPageState();
}

class _DocumentCropperPageState extends State<DocumentCropperPage> {
  Uint8List? _original;
  Uint8List? _cropped;
  int x = 0, y = 0, width = 500, height = 500;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _original = await image.readAsBytes();
      setState(() => _cropped = null);
      cropImage();
    }
  }

  void cropImage() {
    if (_original == null) return;
    final decoded = img_lib.decodeImage(_original!)!;
    final croppedImg = img_lib.copyCrop(decoded, x, y, width, height);
    _cropped = Uint8List.fromList(img_lib.encodeJpg(croppedImg));
    setState(() {});
  }

  void downloadCropped() {
    if (_cropped == null) return;
    final base64Data = base64Encode(_cropped!);
    final anchor = html.AnchorElement(href: "data:image/jpeg;base64,$base64Data")
      ..setAttribute("download", "cropped_doc.jpg")
      ..click();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Document Cropper")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ImageDisplay(title: "Original", imageBytes: _original, onPick: pickImage),
                ImageDisplay(title: "Cropped", imageBytes: _cropped, isResult: true),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: Slider(value: x.toDouble(), min: 0, max: 1000, label: "X", onChanged: (val) => setState(() => x = val.toInt()))),
                Expanded(child: Slider(value: y.toDouble(), min: 0, max: 1000, label: "Y", onChanged: (val) => setState(() => y = val.toInt()))),
              ],
            ),
            Row(
              children: [
                Expanded(child: Slider(value: width.toDouble(), min: 50, max: 2000, label: "Width", onChanged: (val) => setState(() => width = val.toInt()))),
                Expanded(child: Slider(value: height.toDouble(), min: 50, max: 2000, label: "Height", onChanged: (val) => setState(() => height = val.toInt()))),
              ],
            ),
            ElevatedButton(onPressed: cropImage, child: const Text("Crop")),
            const SizedBox(height: 10),
            if (_cropped != null)
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text("Download Cropped"),
                onPressed: downloadCropped,
              ),
          ],
        ),
      ),
    );
  }
}
