import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<_Tool> tools = const [
    _Tool('Background Remover', 'cut', '/background-remover'),
    _Tool('Change Background', 'photo_library', '/change-background'),
    _Tool('Resize Image', 'photo_size_select_large', '/resize-image'),
    _Tool('ID Card Maker', 'badge', '/id-card-maker'),
    _Tool('Passport Photo', 'camera_alt', '/passport-photo'),
    _Tool('Document Cropper', 'content_cut', '/document-cropper'),
    _Tool('Green Screen', 'grass', '/green-screen'),
    _Tool('Format Converter', 'swap_horiz', '/format-converter'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📸 ShopEdits - All AI Tools'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 6,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        int crossAxisCount = 4;
        if (constraints.maxWidth < 1200) crossAxisCount = 3;
        if (constraints.maxWidth < 800) crossAxisCount = 2;
        if (constraints.maxWidth < 500) crossAxisCount = 1;

        return Padding(
          padding: const EdgeInsets.all(24),
          child: GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: tools
                .map((tool) => _ToolCard(
                      title: tool.title,
                      icon: tool.icon,
                      route: tool.route,
                    ))
                .toList(),
          ),
        );
      }),
    );
  }
}

class _Tool {
  final String title;
  final String icon;
  final String route;
  const _Tool(this.title, this.icon, this.route);
}

class _ToolCard extends StatelessWidget {
  final String title;
  final String icon;
  final String route;
  const _ToolCard({required this.title, required this.icon, required this.route, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(16),
      hoverColor: Colors.deepPurpleAccent.withOpacity(0.2),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getIconData(icon), size: 48, color: Colors.deepPurpleAccent),
            const SizedBox(height: 16),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'cut':
        return Icons.cut;
      case 'photo_library':
        return Icons.photo_library;
      case 'photo_size_select_large':
        return Icons.photo_size_select_large;
      case 'badge':
        return Icons.badge;
      case 'camera_alt':
        return Icons.camera_alt;
      case 'content_cut':
        return Icons.content_cut;
      case 'grass':
        return Icons.grass;
      case 'swap_horiz':
        return Icons.swap_horiz;
      default:
        return Icons.image;
    }
  }
}
