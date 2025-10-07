import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../widgets/image_display.dart';
import 'package:universal_html/html.dart' as html;

class ChangeBackgroundPage extends StatefulWidget {
  const ChangeBackgroundPage({super.key});

  @override
  _ChangeBackgroundPageState createState() => _ChangeBackgroundPageState();
}

class _ChangeBackgroundPageState extends State<ChangeBackgroundPage> {
  Uint8List? _mainImage;
  Uint8List? _bgImage;
  Uint8List? _result;
  bool _isLoading = false;

  Future<void> pickMain() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      _mainImage = await img.readAsBytes();
      setState(() => _result = null);
      await changeBackground();
    }
  }

  Future<void> pickBackground() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      _bgImage = await img.readAsBytes();
      setState(() {});
      await changeBackground();
    }
  }

  Future<void> changeBackground() async {
    if (_mainImage == null) return;
    setState(() => _isLoading = true);
    const url = 'https://huggingface.co/rahul7273-shop-edits-images/resolve/main/run/predict';

    try {
      final base64Main = base64Encode(_mainImage!);
      final base64Bg = _bgImage != null ? base64Encode(_bgImage!) : "";
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "fn_index": 1,
          "data": ["data:image/png;base64,$base64Main", "data:image/png;base64,$base64Bg"]
        }),
      );
      if (response.statusCode == 200) {
        final resultBase64 = jsonDecode(response.body)['data'][0].split(',').last;
        setState(() => _result = base64Decode(resultBase64));
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void downloadResult() {
    if (_result == null) return;
    final base64Data = base64Encode(_result!);
    final anchor = html.AnchorElement(href: "data:image/png;base64,$base64Data")
      ..setAttribute("download", "changed_bg.png")
      ..click();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Background")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ImageDisplay(title: "Main", imageBytes: _mainImage, onPick: pickMain),
                ImageDisplay(title: "Background", imageBytes: _bgImage, onPick: pickBackground),
                ImageDisplay(title: "Result", imageBytes: _result, isLoading: _isLoading, isResult: true),
              ],
            ),
            const SizedBox(height: 20),
            if (_result != null)
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
