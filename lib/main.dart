import 'package:flutter/material.dart';
// YAHAN BADLAAV KIYA GAYA HAI: Package ka naam theek kiya gaya
import 'package:shopedits/home_page.dart';
import 'package:shopedits/pages/background_remover_page.dart';
import 'package:shopedits/pages/placeholder_page.dart';

void main() {
  runApp(const SnapToolsApp());
}

class SnapToolsApp extends StatelessWidget {
  const SnapToolsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop Edits - Free AI Image Editor',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurpleAccent,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(secondary: Colors.deepPurpleAccent),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/background-remover': (context) => const BackgroundRemoverPage(),
        '/change-background': (context) => const PlaceholderPage(title: 'Change Background'),
        '/image-resizer': (context) => const PlaceholderPage(title: 'Image Resizer'),
        '/id-card-maker': (context) => const PlaceholderPage(title: 'ID Card Maker'),
        // Yahan aap baaki tools ke routes add kar sakte hain
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
