import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart' as html;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapTools',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '📸 AI Background Remover'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Counter ki jagah, hamare app ke naye state variables
  Uint8List? _originalImageBytes;
  Uint8List? _processedImageBytes;
  bool _isLoading = false;
  String _errorMessage = '';

  // _incrementCounter ki jagah, hamare app ke naye functions
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _originalImageBytes = bytes;
        _processedImageBytes = null;
        _errorMessage = '';
        removeBackground(bytes);
      });
    }
  }

  Future<void> removeBackground(Uint8List imageBytes) async {
    setState(() { _isLoading = true; });

    // ‼️ YAHAN APNA HUGGING FACE URL PASTE KAREIN ‼️
    const String huggingFaceUrl = 'https://rahul7273-shop-edits-images.hf.space/run/predict';

    try {
      final uri = Uri.parse(huggingFaceUrl);
      final String base64Image = base64Encode(imageBytes);
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({ "data": ["data:image/png;base64,$base64Image"] }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final String base64Output = responseData['data'][0].split(',').last;
        setState(() { _processedImageBytes = base64Decode(base64Output); });
      } else {
        setState(() { _errorMessage = 'Error: ${response.statusCode}. Please try again.'; });
      }
    } catch (e) {
      setState(() { _errorMessage = 'An error occurred: $e. Check URL and server.'; });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  void downloadImage() {
    if (_processedImageBytes == null) return;
    final base64 = base64Encode(_processedImageBytes!);
    final anchor = html.AnchorElement(href: 'data:image/png;base64,$base64')
      ..setAttribute('download', 'background_removed.png')
      ..click();
  }

  @override
  Widget build(BuildContext context) {
    // Counter UI ki jagah, naya SnapTools UI
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : pickImage,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload Image to Remove Background'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ImageDisplay(title: 'Original', imageBytes: _originalImageBytes),
                    ImageDisplay(
                      title: 'Result',
                      imageBytes: _processedImageBytes,
                      isLoading: _isLoading,
                      isResult: true,
                    ),
                  ],
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(_errorMessage, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                  ),
                const SizedBox(height: 24),
                if (_processedImageBytes != null && !_isLoading)
                  ElevatedButton.icon(
                    onPressed: downloadImage,
                    icon: const Icon(Icons.download),
                    label: const Text('Download Result'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      // FloatingActionButton hata diya gaya hai
    );
  }
}

// Chhota helper widget taaki code saaf rahe
class ImageDisplay extends StatelessWidget {
  final String title;
  final Uint8List? imageBytes;
  final bool isLoading;
  final bool isResult;

  const ImageDisplay({
    super.key,
    required this.title,
    this.imageBytes,
    this.isLoading = false,
    this.isResult = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          height: 250,
          width: 250,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700),
            borderRadius: BorderRadius.circular(8),
            color: Colors.black26,
          ),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : imageBytes != null
                  ? ClipRRect(borderRadius: BorderRadius.circular(7), child: Image.memory(imageBytes!))
                  : Center(child: Icon(isResult ? Icons.auto_fix_high : Icons.image, size: 50, color: Colors.grey)),
        ),
      ],
    );
  }
}
