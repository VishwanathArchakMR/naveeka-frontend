import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Instagram-like Post Detail Screen for Trails
/// Shows full post with comments, reactions, and actions
class TrailsPostDetailScreen extends StatefulWidget {
  final String postId;
  final Map<String, dynamic>? postData;

  const TrailsPostDetailScreen({
    Key? key,
    required this.postId,
    this.postData,
  }) : super(key: key);

  @override
  State<TrailsPostDetailScreen> createState() => _TrailsPostDetailScreenState();
}

class _TrailsPostDetailScreenState extends State<TrailsPostDetailScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLiked = false;
  bool _isSaved = false;
  int _likeCount = 1234;
  
  late AnimationController _likeAnimController;
  late Animation<double> _likeAnimation;

  @override
  void initState() {
    super.initState();
    _likeAnimController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _likeAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _likeAnimController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    _likeAnimController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
    _likeAnimController.forward(from: 0);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: Colors.black,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=${widget.postId.hashCode % 70}',
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'adventure_seeker',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () => _showMoreOptions(context),
              ),
            ],
          ),

          // Post Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Carousel
                SizedBox(
                  height: 400,
                  child: PageView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://source.unsplash.com/800x800/?travel,${widget.postId}${index}',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Action Buttons
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Like Button
                      GestureDetector(
                        onTap: _toggleLike,
                        child: AnimatedBuilder(
                          animation: _likeAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _likeAnimation.value,
                              child: Icon(
                                _isLiked ? Icons.favorite : Icons.favorite_border,
                                color: _isLiked ? Colors.red : Colors.white,
                                size: 28,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Comment Button
                      const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 26),
                      const SizedBox(width: 16),
                      
                      // Share Button
                      const Icon(Icons.send, color: Colors.white, size: 26),
                      
                      const Spacer(),
                      
                      // Save Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSaved = !_isSaved;
                          });
                          HapticFeedback.lightImpact();
                        },
                        child: Icon(
                          _isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),

                // Like Count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    '$_likeCount likes',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),

                // Caption
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      children: [
                        TextSpan(
                          text: 'adventure_seeker ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'Amazing sunset at Santorini! 🌅 The view was absolutely breathtaking. '
                                '#travel #sunset #santorini #greece #wanderlust',
                        ),
                      ],
                    ),
                  ),
                ),

                // Timestamp
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: Text(
                    '2 hours ago',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ),

                const Divider(color: Colors.grey, height: 1),

                // Comments Section
                _buildCommentsSection(),
              ],
            ),
          ),
        ],
      ),

      // Comment Input
      bottomNavigationBar: _buildCommentInput(),
    );
  }

  Widget _buildCommentsSection() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=$index'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'user_$index ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(
                            text: 'This looks amazing! I need to visit this place soon.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${index + 1}h',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${(index + 1) * 3} likes',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Reply',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border, size: 16, color: Colors.white),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(top: BorderSide(color: Colors.grey[800]!)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 12,
        right: 12,
        top: 8,
      ),
      child: SafeArea(
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=50'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _commentController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: InputBorder.none,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_commentController.text.isNotEmpty) {
                  // Post comment
                  _commentController.clear();
                  HapticFeedback.lightImpact();
                }
              },
              child: Text(
                'Post',
                style: TextStyle(
                  color: _commentController.text.isEmpty ? Colors.blue[700] : Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBottomSheetItem(Icons.link, 'Copy link'),
            _buildBottomSheetItem(Icons.share, 'Share to...'),
            _buildBottomSheetItem(Icons.qr_code, 'QR code'),
            _buildBottomSheetItem(Icons.report, 'Report'),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildBottomSheetItem(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        HapticFeedback.lightImpact();
      },
    );
  }
}
