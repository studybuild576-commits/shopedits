import 'package:flutter/material.dart';

class ReviewSection extends StatelessWidget {
  const ReviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = [
      {'name': 'Ankit', 'text': 'This tool is amazing! Background removal is super fast.'},
      {'name': 'Priya', 'text': 'Professional UI and easy to use. I love it!'},
      {'name': 'Rahul', 'text': 'AI features are mind-blowing. High-quality results!'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      color: const Color(0xFF1A1A2E),
      child: Column(
        children: [
          const Text('What Users Say', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              for (var rev in reviews)
                Card(
                  color: const Color(0xFF2A2A3D),
                  child: SizedBox(
                    width: 250,
                    height: 140,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('"${rev['text']}"', style: const TextStyle(fontSize: 14, color: Colors.white70), textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          Text('- ${rev['name']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}
