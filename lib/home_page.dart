import 'package:flutter/material.dart';
import 'widgets/tool_card.dart';
import 'widgets/review_section.dart';
import 'pages/background_remover_page.dart';
import 'pages/change_background_page.dart';
import 'pages/resize_image_page.dart';
import 'pages/id_card_page.dart';
import 'pages/passport_photo_page.dart';
import 'pages/document_crop_page.dart';
import 'pages/green_screen_page.dart';
import 'pages/format_converter_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = [
      {'icon': Icons.cut, 'title': 'Background Remover', 'page': const BackgroundRemoverPage()},
      {'icon': Icons.image_outlined, 'title': 'Change Background', 'page': const ChangeBackgroundPage()},
      {'icon': Icons.aspect_ratio, 'title': 'Resize Image', 'page': const ResizeImagePage()},
      {'icon': Icons.badge_outlined, 'title': 'ID Card Maker', 'page': const IDCardPage()},
      {'icon': Icons.photo_library_outlined, 'title': 'Passport Photo', 'page': const PassportPhotoPage()},
      {'icon': Icons.crop, 'title': 'Document Cropper', 'page': const DocumentCropPage()},
      {'icon': Icons.video_camera_back_outlined, 'title': 'Green Screen', 'page': const GreenScreenPage()},
      {'icon': Icons.swap_horiz, 'title': 'Format Converter', 'page': const FormatConverterPage()},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('📸 Shop Edits AI'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent.withOpacity(0.2),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 280,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/banner.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Your All-in-One AI Image Editing Studio',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              padding: const EdgeInsets.all(24),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                for (var tool in tools)
                  ToolCard(
                    icon: tool['icon'] as IconData,
                    title: tool['title'] as String,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => tool['page'] as Widget),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 40),
            const ReviewSection(),
          ],
        ),
      ),
    );
  }
}
