import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const ShopEditsApp());
}

class ShopEditsApp extends StatelessWidget {
  const ShopEditsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop Edits - AI Image Tools',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurpleAccent,
        scaffoldBackgroundColor: const Color(0xFF0F0F12),
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark)
            .copyWith(secondary: Colors.purpleAccent),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
