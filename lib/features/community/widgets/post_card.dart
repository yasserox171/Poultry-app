import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/post_model.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final int index;

  const PostCard({super.key, required this.post, required this.index});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with SingleTickerProviderStateMixin {
  late AnimationController _likeController;

  static const List<Color> _avatarColors = [
    Color(0xFF1B5E20),
    Color(0xFF880E4F),
    Color(0xFF0D47A1),
    Color(0xFF4A148C),
    Color(0xFFBF360C),
    Color(0xFF004D40),
  ];


  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _likeController.dispose();
    super.dispose();
  }

  Color get _catColor {
    final map = <String, Color>{
      'تجارب': const Color(0xFF1B5E20),
      'أسئلة': const Color(0xFF0D47A1),
      'نصائح': const Color(0xFF4A148C),
      'إنجازات': const Color(0xFFBF360C),
      'مشاريع': const Color(0xFF004D40),
      'تحذيرات': const Color(0xFFE53935),
    };
    return map[widget.post.category] ?? AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final avatarColor = _avatarColors[post.authorColorIndex % _avatarColors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: avatarColor,
                  radius: 22,
                  child: Text(post.authorInitials,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.authorName,
                          style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.bold)),
                      Text(post.timeAgo,
                          style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textHint)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _catColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(post.category,
                      style: GoogleFonts.cairo(fontSize: 11, color: _catColor, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(post.content,
                style: GoogleFonts.cairo(fontSize: 14, color: AppColors.textPrimary, height: 1.5)),
          ),
          // Image
          if (post.imageUrl != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(0)),
              child: Image.network(
                post.imageUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 180,
                  color: Colors.grey.shade100,
                  child: const Center(child: Icon(Icons.image_not_supported_outlined, color: Colors.grey, size: 40)),
                ),
              ),
            ),
          ],
          // Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Row(
              children: [
                _ActionButton(
                  icon: post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  label: '${post.likes}',
                  color: post.isLiked ? Colors.red : AppColors.textSecondary,
                  onTap: () {
                    setState(() {
                      if (post.isLiked) {
                        post.likes--;
                      } else {
                        post.likes++;
                      }
                      post.isLiked = !post.isLiked;
                    });
                    _likeController.forward(from: 0);
                  },
                ),
                _ActionButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: '${post.commentsCount}',
                  color: AppColors.textSecondary,
                  onTap: () {},
                ),
                _ActionButton(
                  icon: Icons.share_outlined,
                  label: 'مشاركة',
                  color: AppColors.textSecondary,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: widget.index * 80))
        .slideY(begin: 0.15, curve: Curves.easeOut);
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 4),
            Text(label, style: GoogleFonts.cairo(fontSize: 13, color: color)),
          ],
        ),
      ),
    );
  }
}
