class ProductModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final String unit;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String seller;
  final bool isAvailable;
  final String? badge;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.unit,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.seller,
    this.isAvailable = true,
    this.badge,
  });
}
