import React, { useState, useRef, useEffect } from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity, Animated, TextInput } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import ProductCard from '../components/ProductCard';
import { MOCK_PRODUCTS } from '../data/mockData';

const CATEGORIES = [
  { key: 'all', label: 'الكل' },
  { key: 'feed', label: 'العلائق' },
  { key: 'vaccine', label: 'اللقاحات' },
  { key: 'medicine', label: 'الأدوية' },
  { key: 'equipment', label: 'المعدات' },
];

export default function StoreScreen() {
  const [activeCategory, setActiveCategory] = useState('all');
  const [search, setSearch] = useState('');
  const fadeAnim = useRef(new Animated.Value(0)).current;
  const cartCount = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    Animated.timing(fadeAnim, { toValue: 1, duration: 600, useNativeDriver: true }).start();
  }, []);

  const filtered = MOCK_PRODUCTS.filter(p => {
    const matchCat = activeCategory === 'all' || p.category === activeCategory;
    const matchSearch = p.name.includes(search) || p.brand.includes(search);
    return matchCat && matchSearch;
  });

  return (
    <View style={styles.root}>
      <LinearGradient colors={[Colors.primaryDark, Colors.primary]} style={styles.header}>
        <SafeAreaView edges={['top']}>
          <View style={styles.headerTop}>
            <Text style={styles.title}>متجر الدواجن</Text>
            <TouchableOpacity style={styles.cartBtn}>
              <Ionicons name="cart" size={22} color={Colors.white} />
              <View style={styles.cartBadge}>
                <Text style={styles.cartBadgeText}>2</Text>
              </View>
            </TouchableOpacity>
          </View>

          {/* Search */}
          <View style={styles.searchBar}>
            <Ionicons name="search" size={18} color={Colors.textMuted} />
            <TextInput
              style={styles.searchInput}
              placeholder="ابحث عن منتج..."
              placeholderTextColor={Colors.textMuted}
              value={search}
              onChangeText={setSearch}
              textAlign="right"
            />
            {search.length > 0 && (
              <TouchableOpacity onPress={() => setSearch('')}>
                <Ionicons name="close-circle" size={18} color={Colors.textMuted} />
              </TouchableOpacity>
            )}
          </View>
        </SafeAreaView>
      </LinearGradient>

      {/* Categories */}
      <View style={styles.categories}>
        <FlatList
          data={CATEGORIES}
          horizontal
          showsHorizontalScrollIndicator={false}
          keyExtractor={item => item.key}
          contentContainerStyle={styles.categoryList}
          renderItem={({ item }) => (
            <TouchableOpacity
              style={[styles.categoryChip, activeCategory === item.key && styles.categoryChipActive]}
              onPress={() => setActiveCategory(item.key)}
            >
              <Text style={[styles.categoryText, activeCategory === item.key && styles.categoryTextActive]}>
                {item.label}
              </Text>
            </TouchableOpacity>
          )}
        />
      </View>

      <Animated.View style={[{ flex: 1, opacity: fadeAnim }]}>
        <FlatList
          data={filtered}
          numColumns={2}
          keyExtractor={item => item.id}
          contentContainerStyle={styles.productGrid}
          showsVerticalScrollIndicator={false}
          ListHeaderComponent={
            <Text style={styles.resultsText}>{filtered.length} منتج</Text>
          }
          ListEmptyComponent={
            <View style={styles.emptyState}>
              <Text style={styles.emptyEmoji}>🔍</Text>
              <Text style={styles.emptyText}>لا توجد نتائج</Text>
            </View>
          }
          renderItem={({ item }) => (
            <ProductCard product={item} />
          )}
          columnWrapperStyle={styles.columnWrapper}
        />
      </Animated.View>
    </View>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1, backgroundColor: Colors.background },
  header: { paddingHorizontal: 20, paddingBottom: 16 },
  headerTop: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingTop: 8, marginBottom: 12 },
  title: { fontSize: 22, fontWeight: '800', color: Colors.white },
  cartBtn: { position: 'relative' },
  cartBadge: { position: 'absolute', top: -6, right: -8, backgroundColor: Colors.danger, width: 16, height: 16, borderRadius: 8, alignItems: 'center', justifyContent: 'center' },
  cartBadgeText: { color: Colors.white, fontSize: 10, fontWeight: '800' },
  searchBar: { flexDirection: 'row', alignItems: 'center', backgroundColor: Colors.white, borderRadius: 12, paddingHorizontal: 12, paddingVertical: 8, gap: 8 },
  searchInput: { flex: 1, fontSize: 14, color: Colors.textPrimary },
  categories: { backgroundColor: Colors.cardBg, shadowColor: Colors.shadow, shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.08, shadowRadius: 4, elevation: 2 },
  categoryList: { paddingHorizontal: 14, paddingVertical: 10, gap: 8 },
  categoryChip: { paddingHorizontal: 16, paddingVertical: 7, borderRadius: 20, backgroundColor: Colors.surface, borderWidth: 1, borderColor: Colors.border },
  categoryChipActive: { backgroundColor: Colors.primary, borderColor: Colors.primary },
  categoryText: { fontSize: 13, fontWeight: '700', color: Colors.textSecondary },
  categoryTextActive: { color: Colors.white },
  productGrid: { padding: 16, paddingBottom: 30 },
  columnWrapper: { justifyContent: 'space-between' },
  resultsText: { fontSize: 13, color: Colors.textMuted, marginBottom: 12, textAlign: 'right', fontWeight: '600' },
  emptyState: { alignItems: 'center', padding: 40 },
  emptyEmoji: { fontSize: 48, marginBottom: 12 },
  emptyText: { fontSize: 16, color: Colors.textMuted, fontWeight: '600' },
});
