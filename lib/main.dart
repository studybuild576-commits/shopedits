import 'package:flutter/material.dart';
// YAHAN BADLAAV KIYA GAYA HAI: Relative paths ka istemaal kiya gaya hai
import 'home_page.dart';
import 'pages/background_remover_page.dart';
import 'pages/change_background_page.dart';
import 'pages/document_cropper_page.dart';
import 'pages/format_converter_page.dart';
import 'pages/green_screen_page.dart';
import 'pages/id_card_maker_page.dart';
import 'pages/passport_photo_page.dart';
import 'pages/resize_image_page.dart';


void main() {
  runApp(const ShopEditsApp());
}

class ShopEditsApp extends StatelessWidget {
  const ShopEditsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopEdits - AI Image Tools',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurpleAccent,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark)
            .copyWith(secondary: Colors.deepPurpleAccent),
        cardTheme: CardTheme(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
          titleMedium: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/background-remover': (context) => const BackgroundRemoverPage(),
        '/change-background': (context) => const ChangeBackgroundPage(),
        '/resize-image': (context) => const ResizeImagePage(),
        '/id-card-maker': (context) => const IDCardMakerPage(),
        '/passport-photo': (context) => const PassportPhotoPage(),
        '/document-cropper': (context) => const DocumentCropperPage(),
        '/green-screen': (context) => const GreenScreenPage(),
        '/format-converter': (context) => const FormatConverterPage(),
      },
    );
  }
}
```

---
### ## Ab Kya Karein?

1.  Upar diye gaye code ko `main.dart` file mein **paste** karein.
2.  File ko **save** karein.
3.  Changes ko **GitHub par `push` kar dein.**
    ```bash
    git add .
    git commit -m "Fix: Corrected import paths in main.dart"
    git push
    

