class PostModel {
  final String id;
  final String authorName;
  final String authorInitials;
  final int authorColorIndex;
  final String timeAgo;
  final String content;
  final String? imageUrl;
  int likes;
  final int commentsCount;
  final String category;
  bool isLiked;

  PostModel({
    required this.id,
    required this.authorName,
    required this.authorInitials,
    required this.authorColorIndex,
    required this.timeAgo,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.commentsCount,
    required this.category,
    this.isLiked = false,
  });
}
