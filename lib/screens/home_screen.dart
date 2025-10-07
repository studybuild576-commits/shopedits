// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'remove_bg_screen.dart';
import 'coming_soon_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📸 Shop Edits AI'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF6d28d9),
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: const Color(0xFF6d28d9),
          indicatorWeight: 3,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.cut), text: 'Remove BG'),
            Tab(icon: Icon(Icons.landscape), text: 'Change BG'),
            Tab(icon: Icon(Icons.aspect_ratio), text: 'Resize'),
            Tab(icon: Icon(Icons.transform), text: 'Convert'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          RemoveBgScreen(),
          ComingSoonScreen(featureName: 'Change Background', icon: Icons.landscape),
          ComingSoonScreen(featureName: 'Resize Image', icon: Icons.aspect_ratio),
          ComingSoonScreen(featureName: 'Format Converter', icon: Icons.transform),
        ],
      ),
    );
  }
}
