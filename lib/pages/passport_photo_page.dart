import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img_lib;
import '../widgets/image_display.dart';
import 'package:universal_html/html.dart' as html;

class PassportPhotoPage extends StatefulWidget {
  const PassportPhotoPage({super.key});

  @override
  _PassportPhotoPageState createState() => _PassportPhotoPageState();
}

class _PassportPhotoPageState extends State<PassportPhotoPage> {
  Uint8List? _photo;
  Uint8List? _sheet;
  int _copies = 8;

  Future<void> pickPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _photo = await image.readAsBytes();
      setState(() => _sheet = null);
      generateSheet();
    }
  }

  void generateSheet() {
    if (_photo == null) return;

    final pWidth = 413;
    final pHeight = 531;
    final photoImg = img_lib.decodeImage(_photo!)!;
    final resized = img_lib.copyResize(photoImg, width: pWidth, height: pHeight);

    final cols = _copies == 4 ? 2 : 4;
    final rows = _copies == 4 ? 2 : 2;
    final sheetImg = img_lib.Image(pWidth * cols, pHeight * rows);
    img_lib.fill(sheetImg, img_lib.getColor(255, 255, 255));

    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        img_lib.copyInto(sheetImg, resized, dstX: x * pWidth, dstY: y * pHeight);
      }
    }
    _sheet = Uint8List.fromList(img_lib.encodeJpg(sheetImg));
    setState(() {});
  }

  void downloadSheet() {
    if (_sheet == null) return;
    final base64Data = base64Encode(_sheet!);
    final anchor = html.AnchorElement(href: "data:image/jpeg;base64,$base64Data")
      ..setAttribute("download", "passport_sheet.jpg")
      ..click();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Passport Photo Sheet")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ImageDisplay(title: "Photo", imageBytes: _photo, onPick: pickPhoto),
                ImageDisplay(title: "Sheet", imageBytes: _sheet, isResult: true),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButton<int>(
              value: _copies,
              items: const [DropdownMenuItem(value: 4, child: Text("4 Copies")), DropdownMenuItem(value: 8, child: Text("8 Copies"))],
              onChanged: (val) {
                _copies = val ?? 8;
                generateSheet();
              },
            ),
            const SizedBox(height: 20),
            if (_sheet != null)
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text("Download Sheet"),
                onPressed: downloadSheet,
              ),
          ],
        ),
      ),
    );
  }
}
