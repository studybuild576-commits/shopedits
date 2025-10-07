import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img_lib;
import '../widgets/image_display.dart';
import 'package:universal_html/html.dart' as html;

class FormatConverterPage extends StatefulWidget {
  const FormatConverterPage({super.key});

  @override
  _FormatConverterPageState createState() => _FormatConverterPageState();
}

class _FormatConverterPageState extends State<FormatConverterPage> {
  Uint8List? _original;
  Uint8List? _converted;
  String _format = "PNG";

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _original = await image.readAsBytes();
      setState(() => _converted = null);
      convertFormat();
    }
  }

  void convertFormat() {
    if (_original == null) return;
    final decoded = img_lib.decodeImage(_original!)!;
    switch (_format) {
      case "PNG":
        _converted = Uint8List.fromList(img_lib.encodePng(decoded));
        break;
      case "JPEG":
        _converted = Uint8List.fromList(img_lib.encodeJpg(decoded));
        break;
      case "WEBP":
        _converted = Uint8List.fromList(img_lib.encodeWebp(decoded));
        break;
      default:
        _converted = Uint8List.fromList(img_lib.encodePng(decoded));
    }
    setState(() {});
  }

  void downloadImage() {
    if (_converted == null) return;
    final base64Data = base64Encode(_converted!);
    final anchor = html.AnchorElement(href: "data:image/$_format;base64,$base64Data")
      ..setAttribute("download", "converted_image.${_format.toLowerCase()}")
      ..click();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Format Converter")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ImageDisplay(title: "Original", imageBytes: _original, onPick: pickImage),
                ImageDisplay(title: "Converted", imageBytes: _converted, isResult: true),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _format,
              items: const [
                DropdownMenuItem(value: "PNG", child: Text("PNG")),
                DropdownMenuItem(value: "JPEG", child: Text("JPEG")),
                DropdownMenuItem(value: "WEBP", child: Text("WEBP")),
              ],
              onChanged: (val) {
                _format = val ?? "PNG";
                convertFormat();
              },
            ),
            const SizedBox(height: 20),
            if (_converted != null)
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
