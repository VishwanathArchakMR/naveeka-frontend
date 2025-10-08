# Trails Complete Code Drop-in (Instagram-like UI)

This markdown contains complete Dart code for all requested Trails screens and widgets. Copy each section into corresponding files under lib/features/trails/presentation (and widgets). All screens are mobile-first, include smooth animations, gradients, rounded cards, immersive visuals, and story/feed patterns.

Note: One file (trails_post_detail.dart) already committed. Remaining files are below to paste-and-commit quickly if preferred.

---

## 1) trails_activity.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TrailsActivityScreen extends StatelessWidget {
  const TrailsActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(16, (i) => i);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Activity', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F1115), Color(0xFF0B0D12)],
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
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=${(index % 60) + 1}'),
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
                      TextSpan(text: 'user_$index ', style: const TextStyle(fontWeight: FontWeight.w700)),
                      const TextSpan(text: 'liked your trail photo'),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text('${index + 1}h ago', style: TextStyle(color: Colors.white70, fontSize: 12)),
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
          )
        ],
      ),
    );
  }
}
```

---

## 2) trails_profile_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TrailsProfileScreen extends StatelessWidget {
  final String userId;
  const TrailsProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final tabs = ['Grid', 'Reels', 'Tagged'];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F1115),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.w700)),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverToBoxAdapter(child: _Header(userId: userId)),
            SliverAppBar(
              backgroundColor: const Color(0xFF0F1115),
              pinned: true,
              toolbarHeight: 0,
              bottom: TabBar(
                tabs: tabs.map((t) => Tab(text: t)).toList(),
                indicatorColor: Colors.white,
              ),
            ),
          ],
          body: TabBarView(
            children: [
              _GridTab(key: const PageStorageKey('grid')),
              _ReelsTab(key: const PageStorageKey('reels')),
              _TaggedTab(key: const PageStorageKey('tagged')),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String userId;
  const _Header({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=${userId.hashCode % 70}'),
              ),
              const SizedBox(width: 24),
              _Metric(label: 'Posts', value: '182'),
              const SizedBox(width: 16),
              _Metric(label: 'Followers', value: '12.4k'),
              const SizedBox(width: 16),
              _Metric(label: 'Following', value: '286'),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Adventure Seeker', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Exploring trails and hidden gems around the world.', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _pillButton('Follow', primary: true)),
              const SizedBox(width: 8),
              Expanded(child: _pillButton('Message')),
              const SizedBox(width: 8),
              _roundIcon(Icons.person_add_alt),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 86,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => _Highlight(i: i),
            ),
          ).animate().fadeIn(duration: 300.ms),
        ],
      ),
    );
  }

  Widget _pillButton(String text, {bool primary = false}) => Container(
        height: 38,
        decoration: BoxDecoration(
          color: primary ? Colors.blueAccent : const Color(0xFF151922),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
      );

  Widget _roundIcon(IconData icon) => Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(color: const Color(0xFF151922), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon),
      );
}

class _Metric extends StatelessWidget {
  final String label; final String value;
  const _Metric({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      );
}

class _Highlight extends StatelessWidget {
  final int i; const _Highlight({required this.i});
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [Color(0xFFF58529), Color(0xFFDD2A7B), Color(0xFF8134AF)]),
            ),
            padding: const EdgeInsets.all(3),
            child: CircleAvatar(backgroundImage: NetworkImage('https://source.unsplash.com/100x100/?trail,$i')),
          ),
          const SizedBox(height: 6),
          Text('Trip $i', style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      );
}

class _GridTab extends StatelessWidget {
  const _GridTab({super.key});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(1),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 1, crossAxisSpacing: 1),
      itemBuilder: (_, i) => Image.network('https://source.unsplash.com/300x300/?nature,trail,$i', fit: BoxFit.cover),
      itemCount: 60,
    );
  }
}

class _ReelsTab extends StatelessWidget {
  const _ReelsTab({super.key});
  @override
  Widget build(BuildContext context) => Center(
        child: Text('Reels coming soon', style: TextStyle(color: Colors.white70)),
      );
}

class _TaggedTab extends StatelessWidget {
  const _TaggedTab({super.key});
  @override
  Widget build(BuildContext context) => Center(
        child: Text('Tagged trails', style: TextStyle(color: Colors.white70)),
      );
}
```

---

## 3) trails_create_post_flow.dart (enhanced)
```dart
import 'package:flutter/material.dart';

class TrailsCreatePostFlow extends StatefulWidget {
  const TrailsCreatePostFlow({super.key});

  @override
  State<TrailsCreatePostFlow> createState() => _TrailsCreatePostFlowState();
}

class _TrailsCreatePostFlowState extends State<TrailsCreatePostFlow> {
  int step = 0; // 0: pick, 1: edit, 2: caption
  final captionCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Create'),
        actions: [
          TextButton(
            onPressed: step < 2 ? () => setState(() => step++) : _share,
            child: Text(step < 2 ? 'Next' : 'Share'),
          )
        ],
      ),
      body: IndexedStack(
        index: step,
        children: [
          _PickStep(onPicked: () => setState(() => step = 1)),
          _EditStep(onDone: () => setState(() => step = 2)),
          _CaptionStep(controller: captionCtrl),
        ],
      ),
    );
  }

  void _share() {
    Navigator.pop(context, {'caption': captionCtrl.text});
  }
}

class _PickStep extends StatelessWidget {
  final VoidCallback onPicked;
  const _PickStep({required this.onPicked});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(1),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 1, crossAxisSpacing: 1),
            itemBuilder: (_, i) => GestureDetector(
              onTap: onPicked,
              child: Image.network('https://source.unsplash.com/300x300/?mountains,$i', fit: BoxFit.cover),
            ),
            itemCount: 60,
          ),
        ),
      ],
    );
  }
}

class _EditStep extends StatelessWidget {
  final VoidCallback onDone;
  const _EditStep({required this.onDone});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network('https://source.unsplash.com/800x800/?hiking,1', fit: BoxFit.cover),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _ToolIcon(icon: Icons.tune, label: 'Adjust'),
                      _ToolIcon(icon: Icons.filter_alt, label: 'Filter'),
                      _ToolIcon(icon: Icons.crop, label: 'Crop'),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Continue'),
            ),
          ),
        )
      ],
    );
  }
}

class _ToolIcon extends StatelessWidget {
  final IconData icon; final String label;
  const _ToolIcon({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, color: Colors.white), const SizedBox(height: 6), Text(label, style: const TextStyle(color: Colors.white70))],
      );
}

class _CaptionStep extends StatelessWidget {
  final TextEditingController controller;
  const _CaptionStep({required this.controller});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=2')),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: 5,
                minLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Write a caption…',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          value: true
