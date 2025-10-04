import 'package:flutter/material.dart';

/// Trails Feed Screen - Main feed with posts
class TrailsFeed extends StatefulWidget {
  const TrailsFeed({super.key});

  @override
  State<TrailsFeed> createState() => _TrailsFeedState();
}

class _TrailsFeedState extends State<TrailsFeed> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset > 200 && !_showFab) {
      setState(() => _showFab = true);
    } else if (_scrollController.offset <= 200 && _showFab) {
      setState(() => _showFab = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildAppBar(isDark),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildPostCard(context, index, isDark),
                  childCount: 10,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedScale(
        scale: _showFab ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: FloatingActionButton.extended(
          onPressed: () {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
          icon: const Icon(Icons.arrow_upward_rounded),
          label: const Text('Top'),
          backgroundColor: Colors.blue[600],
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDark) {
    return SliverAppBar(
      floating: true,
      snap: true,
      elevation: 0,
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      title: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [Colors.blue[400]!, Colors.purple[400]!],
        ).createShader(bounds),
        child: const Text(
          'Trails Feed',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list_rounded),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildPostCard(BuildContext context, int index, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [Colors.grey[900]!, Colors.grey[850]!]
              : [Colors.white, Colors.grey[100]!],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black45 : Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Hero(
                  tag: 'avatar_$index',
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[400]!, Colors.purple[400]!],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Traveler ${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        '2 hours ago',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz_rounded),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Amazing trail experience! The views were breathtaking and the journey was unforgettable. Can\'t wait to explore more trails.',
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: isDark ? Colors.grey[300] : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Image
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue[300]!, Colors.purple[300]!],
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.image_rounded,
                size: 64,
                color: Colors.white70,
              ),
            ),
          ),
          // Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildActionButton(Icons.favorite_border_rounded, '${index * 12}', isDark),
                const SizedBox(width: 16),
                _buildActionButton(Icons.comment_outlined, '${index * 3}', isDark),
                const SizedBox(width: 16),
                _buildActionButton(Icons.share_outlined, 'Share', isDark),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.bookmark_border_rounded),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, bool isDark) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDark ? Colors.grey[400] : Colors.grey[700],
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
