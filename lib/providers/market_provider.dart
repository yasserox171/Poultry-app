import 'package:flutter/material.dart';
import '../data/models/product_model.dart';
import '../data/mock/mock_data.dart';

class MarketProvider extends ChangeNotifier {
  final List<ProductModel> _allProducts = MockData.products;
  String _selectedCategory = 'الكل';
  String _searchQuery = '';
  int _cartCount = 0;

  List<ProductModel> get filteredProducts => _allProducts.where((p) {
        final catMatch = _selectedCategory == 'الكل' || p.category == _selectedCategory;
        final searchMatch = _searchQuery.isEmpty ||
            p.name.contains(_searchQuery) ||
            p.seller.contains(_searchQuery);
        return catMatch && searchMatch;
      }).toList();

  String get selectedCategory => _selectedCategory;
  int get cartCount => _cartCount;

  static const List<String> categories = [
    'الكل',
    'كتاكيت',
    'أعلاف',
    'أدوية',
    'معدات',
  ];

  void setCategory(String cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  void setSearch(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void addToCart() {
    _cartCount++;
    notifyListeners();
  }
}
