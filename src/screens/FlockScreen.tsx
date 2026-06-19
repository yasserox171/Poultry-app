import React, { useRef, useEffect } from 'react';
import { View, Text, StyleSheet, ScrollView, Animated } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import { MOCK_FLOCK } from '../data/mockData';

function ProgressBar({ value, max, color }: { value: number; max: number; color: string }) {
  const widthAnim = useRef(new Animated.Value(0)).current;
  useEffect(() => {
    Animated.timing(widthAnim, { toValue: (value / max) * 100, duration: 1000, useNativeDriver: false }).start();
  }, []);
  return (
    <View style={styles.progressBg}>
      <Animated.View style={[styles.progressFill, {
        width: widthAnim.interpolate({ inputRange: [0, 100], outputRange: ['0%', '100%'] }),
        backgroundColor: color,
      }]} />
    </View>
  );
}

export default function FlockScreen() {
  const fadeAnim = useRef(new Animated.Value(0)).current;
  const slideAnim = useRef(new Animated.Value(30)).current;

  useEffect(() => {
    Animated.parallel([
      Animated.timing(fadeAnim, { toValue: 1, duration: 600, useNativeDriver: true }),
      Animated.timing(slideAnim, { toValue: 0, duration: 600, useNativeDriver: true }),
    ]).start();
  }, []);

  const survivalRate = 100 - MOCK_FLOCK.mortalityRate;

  return (
    <View style={styles.root}>
      <LinearGradient colors={[Colors.primaryDark, Colors.primary]} style={styles.header}>
        <SafeAreaView edges={['top']}>
          <Text style={styles.title}>إدارة القطيع</Text>
          <View style={styles.heroCard}>
            <View style={styles.heroItem}>
              <Text style={styles.heroEmoji}>🐔</Text>
              <Text style={styles.heroValue}>{MOCK_FLOCK.totalBirds}</Text>
              <Text style={styles.heroLabel}>إجمالي الطيور</Text>
            </View>
            <View style={styles.heroDivider} />
            <View style={styles.heroItem}>
              <Text style={styles.heroEmoji}>📅</Text>
              <Text style={styles.heroValue}>يوم {MOCK_FLOCK.age}</Text>
              <Text style={styles.heroLabel}>العمر الحالي</Text>
            </View>
            <View style={styles.heroDivider} />
            <View style={styles.heroItem}>
              <Text style={styles.heroEmoji}>⚖️</Text>
              <Text style={styles.heroValue}>{MOCK_FLOCK.avgWeight} كغ</Text>
              <Text style={styles.heroLabel}>متوسط الوزن</Text>
            </View>
          </View>
        </SafeAreaView>
      </LinearGradient>

      <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
        <Animated.View style={{ opacity: fadeAnim, transform: [{ translateY: slideAnim }] }}>

          {/* Health status */}
          <View style={styles.healthCard}>
            <View style={styles.healthHeader}>
              <Text style={styles.sectionTitle}>الحالة الصحية</Text>
              <View style={styles.healthBadge}>
                <View style={styles.healthDot} />
                <Text style={styles.healthBadgeText}>ممتاز</Text>
              </View>
            </View>
            <View style={styles.healthMetrics}>
              <View style={styles.healthMetric}>
                <Text style={styles.healthMetricLabel}>نسبة النجاة</Text>
                <Text style={[styles.healthMetricValue, { color: Colors.success }]}>{survivalRate}%</Text>
                <ProgressBar value={survivalRate} max={100} color={Colors.success} />
              </View>
              <View style={styles.healthMetric}>
                <Text style={styles.healthMetricLabel}>نسبة النفوق</Text>
                <Text style={[styles.healthMetricValue, { color: Colors.danger }]}>{MOCK_FLOCK.mortalityRate}%</Text>
                <ProgressBar value={MOCK_FLOCK.mortalityRate} max={10} color={Colors.danger} />
              </View>
              <View style={styles.healthMetric}>
                <Text style={styles.healthMetricLabel}>أجسام فارقت</Text>
                <Text style={[styles.healthMetricValue, { color: Colors.warning }]}>{MOCK_FLOCK.mortalityCount}</Text>
                <ProgressBar value={MOCK_FLOCK.mortalityCount} max={MOCK_FLOCK.totalBirds} color={Colors.warning} />
              </View>
            </View>
          </View>

          {/* Nutrition */}
          <Text style={styles.sectionTitle}>التغذية والماء</Text>
          <View style={styles.nutritionGrid}>
            {[
              { icon: 'leaf', label: 'العليقة اليوم', value: MOCK_FLOCK.feedConsumptionKg, unit: 'كغ', color: Colors.primary },
              { icon: 'water', label: 'الماء اليوم', value: MOCK_FLOCK.waterConsumptionL, unit: 'لتر', color: Colors.accent },
              { icon: 'calculator', label: 'عليقة/طائر', value: (MOCK_FLOCK.feedConsumptionKg / MOCK_FLOCK.totalBirds * 1000).toFixed(0), unit: 'غ', color: Colors.secondary },
              { icon: 'droplet', label: 'ماء/طائر', value: (MOCK_FLOCK.waterConsumptionL / MOCK_FLOCK.totalBirds).toFixed(1), unit: 'لتر', color: Colors.primaryLight },
            ].map(item => (
              <View key={item.label} style={styles.nutritionTile}>
                <View style={[styles.nutritionIcon, { backgroundColor: item.color + '18' }]}>
                  <Ionicons name={item.icon as any} size={20} color={item.color} />
                </View>
                <Text style={[styles.nutritionValue, { color: item.color }]}>{item.value}</Text>
                <Text style={styles.nutritionUnit}>{item.unit}</Text>
                <Text style={styles.nutritionLabel}>{item.label}</Text>
              </View>
            ))}
          </View>

          {/* Batches */}
          <Text style={styles.sectionTitle}>الدفعات</Text>
          {MOCK_FLOCK.batches.map((batch, index) => (
            <View key={batch.id} style={styles.batchCard}>
              <View style={styles.batchHeader}>
                <View style={[styles.batchBadge, { backgroundColor: index === 0 ? Colors.primary : Colors.secondary }]}>
                  <Text style={styles.batchBadgeText}>{batch.name}</Text>
                </View>
                <View style={[styles.activeBadge, { backgroundColor: Colors.success + '20' }]}>
                  <View style={[styles.activeDot, { backgroundColor: Colors.success }]} />
                  <Text style={[styles.activeText, { color: Colors.success }]}>نشطة</Text>
                </View>
              </View>
              <View style={styles.batchDetails}>
                <View style={styles.batchDetail}>
                  <Ionicons name="egg" size={14} color={Colors.textMuted} />
                  <Text style={styles.batchDetailText}>{batch.count} طائر</Text>
                </View>
                <View style={styles.batchDetail}>
                  <Ionicons name="calendar" size={14} color={Colors.textMuted} />
                  <Text style={styles.batchDetailText}>يوم {batch.age}</Text>
                </View>
                <View style={styles.batchDetail}>
                  <Ionicons name="paw" size={14} color={Colors.textMuted} />
                  <Text style={styles.batchDetailText}>{batch.breed}</Text>
                </View>
              </View>
              <ProgressBar value={batch.age} max={42} color={index === 0 ? Colors.primary : Colors.secondary} />
              <View style={styles.batchProgress}>
                <Text style={styles.batchProgressText}>يوم {batch.age} / 42 يوم</Text>
                <Text style={styles.batchProgressPct}>{Math.round((batch.age / 42) * 100)}%</Text>
              </View>
            </View>
          ))}

          {/* Breed info */}
          <View style={styles.breedCard}>
            <Text style={styles.breedTitle}>🐓 معلومات السلالة</Text>
            <View style={styles.breedGrid}>
              {[
                { label: 'السلالة', value: MOCK_FLOCK.breed },
                { label: 'عمر الحصاد', value: '42 يوم' },
                { label: 'الوزن المستهدف', value: '2.5 كغ' },
                { label: 'معامل التحويل', value: '1.9' },
              ].map(item => (
                <View key={item.label} style={styles.breedItem}>
                  <Text style={styles.breedLabel}>{item.label}</Text>
                  <Text style={styles.breedValue}>{item.value}</Text>
                </View>
              ))}
            </View>
          </View>
        </Animated.View>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1, backgroundColor: Colors.background },
  header: { paddingHorizontal: 20, paddingBottom: 24 },
  title: { fontSize: 22, fontWeight: '800', color: Colors.white, paddingTop: 8, marginBottom: 14 },
  heroCard: { flexDirection: 'row', backgroundColor: 'rgba(0,0,0,0.18)', borderRadius: 16, padding: 16 },
  heroItem: { flex: 1, alignItems: 'center' },
  heroEmoji: { fontSize: 24, marginBottom: 4 },
  heroValue: { fontSize: 18, fontWeight: '800', color: Colors.white },
  heroLabel: { fontSize: 11, color: 'rgba(255,255,255,0.7)', marginTop: 3 },
  heroDivider: { width: 1, backgroundColor: 'rgba(255,255,255,0.25)', marginVertical: 8 },
  scrollContent: { padding: 16, paddingBottom: 30 },
  sectionTitle: { fontSize: 16, fontWeight: '800', color: Colors.textPrimary, marginBottom: 10, marginTop: 6 },
  healthCard: { backgroundColor: Colors.cardBg, borderRadius: 16, padding: 16, marginBottom: 16, shadowColor: Colors.shadow, shadowOffset: { width: 0, height: 3 }, shadowOpacity: 0.12, shadowRadius: 8, elevation: 3 },
  healthHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 14 },
  healthBadge: { flexDirection: 'row', alignItems: 'center', gap: 5, backgroundColor: Colors.success + '18', paddingHorizontal: 10, paddingVertical: 4, borderRadius: 10 },
  healthDot: { width: 7, height: 7, borderRadius: 4, backgroundColor: Colors.success },
  healthBadgeText: { fontSize: 12, color: Colors.success, fontWeight: '700' },
  healthMetrics: { gap: 12 },
  healthMetric: {},
  healthMetricLabel: { fontSize: 12, color: Colors.textMuted, marginBottom: 4, textAlign: 'right' },
  healthMetricValue: { fontSize: 18, fontWeight: '800', textAlign: 'right', marginBottom: 4 },
  progressBg: { height: 7, backgroundColor: Colors.border, borderRadius: 4, overflow: 'hidden' },
  progressFill: { height: '100%', borderRadius: 4 },
  nutritionGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: 10, marginBottom: 16 },
  nutritionTile: { width: '47%', flexGrow: 1, backgroundColor: Colors.cardBg, borderRadius: 14, padding: 14, alignItems: 'center', shadowColor: Colors.shadow, shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1, shadowRadius: 5, elevation: 2 },
  nutritionIcon: { width: 40, height: 40, borderRadius: 12, alignItems: 'center', justifyContent: 'center', marginBottom: 8 },
  nutritionValue: { fontSize: 22, fontWeight: '800' },
  nutritionUnit: { fontSize: 12, color: Colors.textMuted, fontWeight: '600' },
  nutritionLabel: { fontSize: 12, color: Colors.textMuted, marginTop: 3, textAlign: 'center' },
  batchCard: { backgroundColor: Colors.cardBg, borderRadius: 16, padding: 14, marginBottom: 12, shadowColor: Colors.shadow, shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1, shadowRadius: 5, elevation: 2 },
  batchHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 },
  batchBadge: { paddingHorizontal: 12, paddingVertical: 5, borderRadius: 10 },
  batchBadgeText: { color: Colors.white, fontWeight: '700', fontSize: 13 },
  activeBadge: { flexDirection: 'row', alignItems: 'center', gap: 4, paddingHorizontal: 8, paddingVertical: 3, borderRadius: 8 },
  activeDot: { width: 6, height: 6, borderRadius: 3 },
  activeText: { fontSize: 12, fontWeight: '700' },
  batchDetails: { flexDirection: 'row', gap: 14, marginBottom: 12 },
  batchDetail: { flexDirection: 'row', alignItems: 'center', gap: 4 },
  batchDetailText: { fontSize: 13, color: Colors.textSecondary, fontWeight: '600' },
  batchProgress: { flexDirection: 'row', justifyContent: 'space-between', marginTop: 5 },
  batchProgressText: { fontSize: 11, color: Colors.textMuted },
  batchProgressPct: { fontSize: 11, color: Colors.primary, fontWeight: '700' },
  breedCard: { backgroundColor: Colors.cardBg, borderRadius: 16, padding: 14, shadowColor: Colors.shadow, shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1, shadowRadius: 5, elevation: 2 },
  breedTitle: { fontSize: 15, fontWeight: '800', color: Colors.textPrimary, marginBottom: 12 },
  breedGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: 10 },
  breedItem: { width: '47%', flexGrow: 1, backgroundColor: Colors.surface, borderRadius: 10, padding: 10 },
  breedLabel: { fontSize: 11, color: Colors.textMuted, marginBottom: 3, textAlign: 'right' },
  breedValue: { fontSize: 15, fontWeight: '700', color: Colors.primary, textAlign: 'right' },
});
