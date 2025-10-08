import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TrailsActivityPage extends StatelessWidget {
  const TrailsActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(16, (i) => i);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Activity',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F1115),
              Color(0xFF0B0D12),
            ],
          ),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 16, 16, 32),
          itemBuilder: (context, index) => _ActivityTile(index: index),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: items.length,
        ).animate().fadeIn(duration: 350.ms, curve: Curves.easeOutCubic),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final int index;
  const _ActivityTile({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF151922),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage:
                NetworkImage('https://i.pravatar.cc/150?img=${(index % 60) + 1}'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                        text: 'user_$index ',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const TextSpan(text: 'liked your trail photo'),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${index + 1}h ago',
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://source.unsplash.com/100x100/?trail,travel,${index + 10}',
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
