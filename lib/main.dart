import 'package:flutter/material.dart';
import 'package:shopedits/home_page.dart';
import 'package:shopedits/pages/background_remover_page.dart';
import 'package:shopedits/pages/change_background_page.dart';
import 'package:shopedits/pages/id_card_maker_page.dart';
// Baaki pages ko yahan import karein...

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
        '/change-background': (context) => const ChangeBackgroundPage(),
        '/id-card-maker': (context) => const IDCardMakerPage(),
        // Yahan baaki tools ke routes add honge
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
