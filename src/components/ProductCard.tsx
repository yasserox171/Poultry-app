import React, { useRef, useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Animated } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';

interface Product {
  id: string;
  name: string;
  category: string;
  price: number;
  unit: string;
  image: string;
  inStock: boolean;
  brand: string;
  description: string;
}

export default function ProductCard({ product }: { product: Product }) {
  const [inCart, setInCart] = useState(false);
  const scaleAnim = useRef(new Animated.Value(1)).current;
  const cartAnim = useRef(new Animated.Value(1)).current;

  const handleAdd = () => {
    setInCart(prev => !prev);
    Animated.sequence([
      Animated.timing(cartAnim, { toValue: 1.3, duration: 100, useNativeDriver: true }),
      Animated.spring(cartAnim, { toValue: 1, useNativeDriver: true }),
    ]).start();
  };

  return (
    <Animated.View style={[styles.card, { transform: [{ scale: scaleAnim }] }]}>
      <View style={styles.imageContainer}>
        <Text style={styles.emoji}>{product.image}</Text>
        {!product.inStock && (
          <View style={styles.outOfStockOverlay}>
            <Text style={styles.outOfStockText}>نفد المخزون</Text>
          </View>
        )}
      </View>
      <View style={styles.info}>
        <Text style={styles.brand}>{product.brand}</Text>
        <Text style={styles.name} numberOfLines={2}>{product.name}</Text>
        <Text style={styles.unit}>{product.unit}</Text>
        <View style={styles.footer}>
          <View>
            <Text style={styles.price}>{product.price.toLocaleString('ar-DZ')}</Text>
            <Text style={styles.currency}>دج</Text>
          </View>
          <TouchableOpacity
            style={[styles.addBtn, inCart && styles.addBtnActive, !product.inStock && styles.addBtnDisabled]}
            onPress={product.inStock ? handleAdd : undefined}
            disabled={!product.inStock}
          >
            <Animated.View style={{ transform: [{ scale: cartAnim }] }}>
              <Ionicons
                name={inCart ? 'checkmark' : 'add'}
                size={20}
                color={Colors.white}
              />
            </Animated.View>
          </TouchableOpacity>
        </View>
      </View>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: Colors.cardBg,
    borderRadius: 16,
    overflow: 'hidden',
    width: '48%',
    marginBottom: 12,
    shadowColor: Colors.shadow,
    shadowOffset: { width: 0, height: 3 },
    shadowOpacity: 0.12,
    shadowRadius: 8,
    elevation: 3,
  },
  imageContainer: {
    backgroundColor: Colors.surface,
    height: 90,
    alignItems: 'center',
    justifyContent: 'center',
    position: 'relative',
  },
  emoji: {
    fontSize: 44,
  },
  outOfStockOverlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(0,0,0,0.5)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  outOfStockText: {
    color: Colors.white,
    fontWeight: '700',
    fontSize: 12,
  },
  info: {
    padding: 10,
  },
  brand: {
    fontSize: 10,
    color: Colors.textMuted,
    fontWeight: '600',
    marginBottom: 2,
  },
  name: {
    fontSize: 13,
    fontWeight: '700',
    color: Colors.textPrimary,
    marginBottom: 2,
    textAlign: 'right',
  },
  unit: {
    fontSize: 11,
    color: Colors.textMuted,
    marginBottom: 8,
    textAlign: 'right',
  },
  footer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-end',
  },
  price: {
    fontSize: 16,
    fontWeight: '800',
    color: Colors.primary,
  },
  currency: {
    fontSize: 10,
    color: Colors.textMuted,
    fontWeight: '600',
  },
  addBtn: {
    backgroundColor: Colors.primary,
    width: 34,
    height: 34,
    borderRadius: 10,
    alignItems: 'center',
    justifyContent: 'center',
  },
  addBtnActive: {
    backgroundColor: Colors.success,
  },
  addBtnDisabled: {
    backgroundColor: Colors.textMuted,
  },
});
