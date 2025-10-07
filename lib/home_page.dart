import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📸 Shop Edits - All Tools'), centerTitle: true),
      body: GridView.count(
        crossAxisCount: 4,
        padding: const EdgeInsets.all(24),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: <Widget>[
          ToolCard(
            icon: Icons.cut,
            title: 'Background Remover',
            onTap: () => Navigator.pushNamed(context, '/background-remover'),
          ),
          ToolCard(
            icon: Icons.add_photo_alternate_outlined,
            title: 'Change Background',
            onTap: () => Navigator.pushNamed(context, '/change-background'),
          ),
          ToolCard(
            icon: Icons.badge_outlined,
            title: 'ID Card Maker',
            onTap: () => Navigator.pushNamed(context, '/id-card-maker'),
          ),
          // ... baaki tools ke liye cards
        ],
      ),
    );
  }
}

class ToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const ToolCard({required this.icon, required this.title, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 16),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
