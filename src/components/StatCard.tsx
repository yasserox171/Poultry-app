import React, { useRef, useEffect } from 'react';
import { View, Text, StyleSheet, Animated, TouchableOpacity } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';

interface Props {
  label: string;
  value: string | number;
  unit?: string;
  icon: keyof typeof Ionicons.glyphMap;
  color?: string;
  trend?: 'up' | 'down' | 'stable';
  onPress?: () => void;
  live?: boolean;
  alert?: boolean;
}

export default function StatCard({ label, value, unit, icon, color = Colors.primary, trend, onPress, live, alert }: Props) {
  const scaleAnim = useRef(new Animated.Value(1)).current;
  const pulseAnim = useRef(new Animated.Value(1)).current;

  useEffect(() => {
    if (live) {
      Animated.loop(
        Animated.sequence([
          Animated.timing(pulseAnim, { toValue: 0.4, duration: 800, useNativeDriver: true }),
          Animated.timing(pulseAnim, { toValue: 1, duration: 800, useNativeDriver: true }),
        ])
      ).start();
    }
  }, [live]);

  const handlePressIn = () => {
    Animated.spring(scaleAnim, { toValue: 0.96, useNativeDriver: true }).start();
  };
  const handlePressOut = () => {
    Animated.spring(scaleAnim, { toValue: 1, useNativeDriver: true }).start();
  };

  const cardColor = alert ? Colors.danger : color;

  return (
    <TouchableOpacity
      activeOpacity={0.85}
      onPress={onPress}
      onPressIn={handlePressIn}
      onPressOut={handlePressOut}
    >
      <Animated.View style={[styles.card, { transform: [{ scale: scaleAnim }], borderLeftColor: cardColor }]}>
        <View style={[styles.iconWrap, { backgroundColor: cardColor + '1A' }]}>
          <Ionicons name={icon} size={22} color={cardColor} />
        </View>
        <View style={styles.content}>
          <Text style={styles.label}>{label}</Text>
          <View style={styles.valueRow}>
            <Text style={[styles.value, { color: cardColor }]}>{value}</Text>
            {unit && <Text style={styles.unit}> {unit}</Text>}
            {trend === 'up' && <Ionicons name="trending-up" size={14} color={Colors.danger} style={styles.trend} />}
            {trend === 'down' && <Ionicons name="trending-down" size={14} color={Colors.success} style={styles.trend} />}
          </View>
        </View>
        {live && (
          <View style={styles.liveContainer}>
            <Animated.View style={[styles.liveDot, { opacity: pulseAnim, backgroundColor: Colors.success }]} />
            <Text style={styles.liveText}>مباشر</Text>
          </View>
        )}
        {alert && (
          <View style={styles.alertBadge}>
            <Ionicons name="warning" size={14} color={Colors.danger} />
          </View>
        )}
      </Animated.View>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: Colors.cardBg,
    borderRadius: 16,
    padding: 14,
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
    borderLeftWidth: 4,
    shadowColor: Colors.shadow,
    shadowOffset: { width: 0, height: 3 },
    shadowOpacity: 0.12,
    shadowRadius: 8,
    elevation: 3,
  },
  iconWrap: {
    width: 44,
    height: 44,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 12,
  },
  content: {
    flex: 1,
  },
  label: {
    fontSize: 12,
    color: Colors.textMuted,
    fontWeight: '500',
    marginBottom: 3,
  },
  valueRow: {
    flexDirection: 'row',
    alignItems: 'baseline',
  },
  value: {
    fontSize: 22,
    fontWeight: '800',
  },
  unit: {
    fontSize: 13,
    color: Colors.textSecondary,
    fontWeight: '600',
  },
  trend: {
    marginLeft: 6,
  },
  liveContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
  },
  liveDot: {
    width: 7,
    height: 7,
    borderRadius: 4,
  },
  liveText: {
    fontSize: 11,
    color: Colors.success,
    fontWeight: '700',
  },
  alertBadge: {
    position: 'absolute',
    top: 10,
    right: 10,
  },
});
