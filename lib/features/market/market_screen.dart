import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/market_provider.dart';
import '../../data/models/product_model.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<MarketProvider>(
        builder: (context, market, _) {
          final products = market.filteredProducts;
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context, market),
              SliverToBoxAdapter(child: _buildSearchBar(context, market)),
              SliverToBoxAdapter(child: _buildCategoryChips(market)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                sliver: products.isEmpty
                    ? SliverFillRemaining(child: _EmptyState())
                    : SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => _ProductCard(product: products[i], index: i),
                          childCount: products.length,
                        ),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Consumer<MarketProvider>(
        builder: (_, market, __) => market.cartCount > 0
            ? FloatingActionButton.extended(
                onPressed: () {},
                backgroundColor: AppColors.primary,
                icon: const Icon(Icons.shopping_cart_rounded, color: Colors.white),
                label: Text('السلة (${market.cartCount})',
                    style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w600)),
              ).animate().scale(curve: Curves.elasticOut)
            : const SizedBox(),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, MarketProvider market) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 80,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.headerGradient,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
        ),
        title: Text('السوق', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
              onPressed: () {},
            ),
            if (market.cartCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Center(
                    child: Text('${market.cartCount}',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, MarketProvider market) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextField(
        onChanged: market.setSearch,
        decoration: InputDecoration(
          hintText: 'ابحث عن منتج...',
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.divider),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintStyle: GoogleFonts.cairo(color: AppColors.textHint),
        ),
        style: GoogleFonts.cairo(),
      ),
    );
  }

  Widget _buildCategoryChips(MarketProvider market) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: MarketProvider.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = MarketProvider.categories[i];
          final selected = market.selectedCategory == cat;
          return GestureDetector(
            onTap: () => market.setCategory(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: selected ? AppColors.primary : AppColors.divider),
                boxShadow: selected
                    ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))]
                    : [],
              ),
              child: Text(cat,
                  style: GoogleFonts.cairo(
                      fontSize: 13,
                      color: selected ? Colors.white : AppColors.textSecondary,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
            ),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final int index;
  const _ProductCard({required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: Image.network(
                  product.imageUrl,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 130,
                    color: AppColors.primary.withOpacity(0.1),
                    child: Center(
                      child: Text(_categoryEmoji(product.category),
                          style: const TextStyle(fontSize: 40)),
                    ),
                  ),
                ),
              ),
              if (product.badge != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(product.badge!,
                        style: GoogleFonts.cairo(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(product.seller,
                      style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textSecondary),
                      overflow: TextOverflow.ellipsis),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 14),
                      const SizedBox(width: 2),
                      Text('${product.rating}',
                          style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textSecondary)),
                      Text(' (${product.reviewCount})',
                          style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textHint)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${product.price.toStringAsFixed(0)} ج.م',
                              style: GoogleFonts.cairo(
                                  fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                          Text('/${product.unit}',
                              style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textHint)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => context.read<MarketProvider>().addToCart(),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: index * 60))
        .scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOut);
  }

  String _categoryEmoji(String cat) {
    switch (cat) {
      case 'كتاكيت': return '🐥';
      case 'أعلاف': return '🌾';
      case 'أدوية': return '💊';
      case 'معدات': return '🔧';
      default: return '📦';
    }
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text('لا توجد منتجات مطابقة',
              style: GoogleFonts.cairo(fontSize: 16, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
