import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img_lib;
import '../widgets/image_display.dart';
import 'package:universal_html/html.dart' as html;

class IDCardMakerPage extends StatefulWidget {
  const IDCardMakerPage({super.key});

  @override
  _IDCardMakerPageState createState() => _IDCardMakerPageState();
}

class _IDCardMakerPageState extends State<IDCardMakerPage> {
  Uint8List? _photo;
  Uint8List? _idCard;
  String _name = "John Doe";
  String _role = "Developer";

  Future<void> pickPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _photo = await image.readAsBytes();
      setState(() => _idCard = null);
      generateIDCard();
    }
  }

  void generateIDCard() {
    if (_photo == null) return;

    final card = img_lib.Image(1200, 700);
    img_lib.fill(card, img_lib.getColor(255, 255, 255));

    final photoImg = img_lib.decodeImage(_photo!)!;
    final resizedPhoto = img_lib.copyResize(photoImg, width: 360, height: 360);
    img_lib.copyInto(card, resizedPhoto, dstX: 80, dstY: 170);

    img_lib.drawString(card, img_lib.arial_48, 500, 80, "COMPANY ID CARD");
    img_lib.drawString(card, img_lib.arial_24, 500, 300, "Name: $_name");
    img_lib.drawString(card, img_lib.arial_24, 500, 360, "Role: $_role");

    _idCard = Uint8List.fromList(img_lib.encodeJpg(card));
    setState(() {});
  }

  void downloadIDCard() {
    if (_idCard == null) return;
    final base64Data = base64Encode(_idCard!);
    final anchor = html.AnchorElement(href: "data:image/jpeg;base64,$base64Data")
      ..setAttribute("download", "id_card.jpg")
      ..click();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ID Card Maker")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ImageDisplay(title: "Photo", imageBytes: _photo, onPick: pickPhoto),
                ImageDisplay(title: "ID Card", imageBytes: _idCard, isResult: true),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: "Name"),
              onChanged: (val) => _name = val,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Role"),
              onChanged: (val) => _role = val,
            ),
            const SizedBox(height: 20),
            if (_idCard != null)
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text("Download ID Card"),
                onPressed: downloadIDCard,
              ),
          ],
        ),
      ),
    );
  }
}
