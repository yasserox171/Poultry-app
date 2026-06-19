import React, { useState, useRef, useEffect } from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, Animated, Dimensions } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { BarChart, PieChart } from 'react-native-chart-kit';
import { Colors } from '../constants/colors';
import { MOCK_REPORTS, MOCK_FLOCK } from '../data/mockData';

const { width: SCREEN_WIDTH } = Dimensions.get('window');
const CHART_WIDTH = SCREEN_WIDTH - 40;

export default function ReportsScreen() {
  const [period, setPeriod] = useState<'daily' | 'weekly' | 'monthly'>('weekly');
  const fadeAnim = useRef(new Animated.Value(0)).current;
  const countAnim = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    Animated.parallel([
      Animated.timing(fadeAnim, { toValue: 1, duration: 700, useNativeDriver: true }),
      Animated.timing(countAnim, { toValue: MOCK_FLOCK.totalBirds, duration: 1200, useNativeDriver: false }),
    ]).start();
  }, []);

  const pieData = [
    { name: 'أحياء', population: MOCK_FLOCK.totalBirds - MOCK_FLOCK.mortalityCount, color: Colors.success, legendFontColor: Colors.textSecondary, legendFontSize: 12 },
    { name: 'نافق', population: MOCK_FLOCK.mortalityCount, color: Colors.danger, legendFontColor: Colors.textSecondary, legendFontSize: 12 },
  ];

  const costData = [
    { name: 'العليقة', population: 65, color: Colors.primary, legendFontColor: Colors.textSecondary, legendFontSize: 12 },
    { name: 'الأدوية', population: 12, color: Colors.accent, legendFontColor: Colors.textSecondary, legendFontSize: 12 },
    { name: 'أخرى', population: 23, color: Colors.secondary, legendFontColor: Colors.textSecondary, legendFontSize: 12 },
  ];

  const barData = {
    labels: MOCK_REPORTS.weekly.labels,
    datasets: [{ data: MOCK_REPORTS.weekly.mortalityDaily }],
  };

  return (
    <View style={styles.root}>
      <LinearGradient colors={[Colors.primaryDark, Colors.primary]} style={styles.header}>
        <SafeAreaView edges={['top']}>
          <Text style={styles.title}>التقارير والإحصائيات</Text>
          {/* Hero stats */}
          <View style={styles.heroRow}>
            <View style={styles.heroItem}>
              <Animated.Text style={styles.heroValue}>
                {countAnim.interpolate({ inputRange: [0, MOCK_FLOCK.totalBirds], outputRange: ['0', MOCK_FLOCK.totalBirds.toString()] })}
              </Animated.Text>
              <Text style={styles.heroLabel}>إجمالي الطيور</Text>
            </View>
            <View style={styles.heroDivider} />
            <View style={styles.heroItem}>
              <Text style={styles.heroValue}>{MOCK_FLOCK.mortalityRate}%</Text>
              <Text style={styles.heroLabel}>نسبة النفوق</Text>
            </View>
            <View style={styles.heroDivider} />
            <View style={styles.heroItem}>
              <Text style={styles.heroValue}>{100 - MOCK_FLOCK.mortalityRate}%</Text>
              <Text style={styles.heroLabel}>نسبة البقاء</Text>
            </View>
          </View>
        </SafeAreaView>
      </LinearGradient>

      <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
        <Animated.View style={{ opacity: fadeAnim }}>
          {/* Period tabs */}
          <View style={styles.periodTabs}>
            {(['daily', 'weekly', 'monthly'] as const).map(p => (
              <TouchableOpacity
                key={p}
                style={[styles.periodTab, period === p && styles.periodTabActive]}
                onPress={() => setPeriod(p)}
              >
                <Text style={[styles.periodTabText, period === p && styles.periodTabTextActive]}>
                  {p === 'daily' ? 'يومي' : p === 'weekly' ? 'أسبوعي' : 'شهري'}
                </Text>
              </TouchableOpacity>
            ))}
          </View>

          {/* Summary cards */}
          <View style={styles.summaryGrid}>
            {[
              { icon: 'cash', label: 'الإيرادات', value: '487,500', unit: 'دج', color: Colors.success },
              { icon: 'receipt', label: 'التكاليف', value: '312,000', unit: 'دج', color: Colors.danger },
              { icon: 'trending-up', label: 'الربح', value: '175,500', unit: 'دج', color: Colors.primary },
              { icon: 'scale', label: 'متوسط الوزن', value: MOCK_FLOCK.avgWeight.toString(), unit: 'كغ', color: Colors.accent },
            ].map(item => (
              <View key={item.label} style={styles.summaryCard}>
                <View style={[styles.summaryIcon, { backgroundColor: item.color + '18' }]}>
                  <Ionicons name={item.icon as any} size={18} color={item.color} />
                </View>
                <Text style={[styles.summaryValue, { color: item.color }]}>{item.value}</Text>
                <Text style={styles.summaryUnit}>{item.unit}</Text>
                <Text style={styles.summaryLabel}>{item.label}</Text>
              </View>
            ))}
          </View>

          {/* Mortality bar chart */}
          <Text style={styles.sectionTitle}>النفوق اليومي (آخر أسبوع)</Text>
          <View style={styles.chartCard}>
            <BarChart
              data={barData}
              width={CHART_WIDTH - 24}
              height={160}
              yAxisLabel=""
              yAxisSuffix=""
              chartConfig={{
                backgroundColor: Colors.cardBg,
                backgroundGradientFrom: Colors.cardBg,
                backgroundGradientTo: Colors.cardBg,
                decimalPlaces: 0,
                color: (opacity = 1) => `rgba(211,47,47,${opacity})`,
                labelColor: () => Colors.textMuted,
                barPercentage: 0.7,
              }}
              style={styles.chart}
              showBarTops={false}
            />
          </View>

          {/* Feed bar chart */}
          <Text style={styles.sectionTitle}>استهلاك العليقة (كغ / يوم)</Text>
          <View style={styles.chartCard}>
            <BarChart
              data={{ labels: MOCK_REPORTS.weekly.labels, datasets: [{ data: MOCK_REPORTS.weekly.feedDaily }] }}
              width={CHART_WIDTH - 24}
              height={160}
              yAxisLabel=""
              yAxisSuffix="كغ"
              chartConfig={{
                backgroundColor: Colors.cardBg,
                backgroundGradientFrom: Colors.cardBg,
                backgroundGradientTo: Colors.cardBg,
                decimalPlaces: 0,
                color: (opacity = 1) => `rgba(46,125,50,${opacity})`,
                labelColor: () => Colors.textMuted,
                barPercentage: 0.7,
              }}
              style={styles.chart}
              showBarTops={false}
            />
          </View>

          {/* Pie charts */}
          <View style={styles.pieRow}>
            <View style={[styles.chartCard, { flex: 1 }]}>
              <Text style={styles.pieTitle}>توزيع القطيع</Text>
              <PieChart
                data={pieData}
                width={(CHART_WIDTH / 2) - 14}
                height={140}
                chartConfig={{ color: () => Colors.primary }}
                accessor="population"
                backgroundColor="transparent"
                paddingLeft="0"
                hasLegend={true}
                absolute
              />
            </View>
            <View style={[styles.chartCard, { flex: 1 }]}>
              <Text style={styles.pieTitle}>توزيع التكاليف</Text>
              <PieChart
                data={costData}
                width={(CHART_WIDTH / 2) - 14}
                height={140}
                chartConfig={{ color: () => Colors.primary }}
                accessor="population"
                backgroundColor="transparent"
                paddingLeft="0"
                hasLegend={true}
                absolute
              />
            </View>
          </View>

          {/* KPI grid */}
          <Text style={styles.sectionTitle}>مؤشرات الأداء الرئيسية</Text>
          <View style={styles.kpiGrid}>
            {[
              { label: 'معامل التحويل الغذائي', value: '1.92', status: 'good', target: '< 2.0' },
              { label: 'معدل الوفيات اليومي', value: '0.07%', status: 'good', target: '< 0.1%' },
              { label: 'كفاءة استهلاك العليقة', value: '93%', status: 'excellent', target: '> 90%' },
              { label: 'معدل النمو اليومي', value: '66 غ', status: 'good', target: '> 60 غ' },
            ].map(kpi => (
              <View key={kpi.label} style={styles.kpiCard}>
                <Text style={styles.kpiLabel}>{kpi.label}</Text>
                <Text style={[styles.kpiValue, { color: kpi.status === 'excellent' ? Colors.success : Colors.primary }]}>{kpi.value}</Text>
                <View style={styles.kpiFooter}>
                  <View style={[styles.kpiStatus, { backgroundColor: (kpi.status === 'excellent' ? Colors.success : Colors.primary) + '18' }]}>
                    <Text style={[styles.kpiStatusText, { color: kpi.status === 'excellent' ? Colors.success : Colors.primary }]}>
                      {kpi.status === 'excellent' ? 'ممتاز' : 'جيد'}
                    </Text>
                  </View>
                  <Text style={styles.kpiTarget}>هدف: {kpi.target}</Text>
                </View>
              </View>
            ))}
          </View>
        </Animated.View>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1, backgroundColor: Colors.background },
  header: { paddingHorizontal: 20, paddingBottom: 20 },
  title: { fontSize: 22, fontWeight: '800', color: Colors.white, paddingTop: 8, marginBottom: 14 },
  heroRow: { flexDirection: 'row', backgroundColor: 'rgba(0,0,0,0.18)', borderRadius: 14, padding: 14 },
  heroItem: { flex: 1, alignItems: 'center' },
  heroValue: { fontSize: 20, fontWeight: '800', color: Colors.white },
  heroLabel: { fontSize: 11, color: 'rgba(255,255,255,0.7)', marginTop: 3 },
  heroDivider: { width: 1, backgroundColor: 'rgba(255,255,255,0.25)', marginVertical: 4 },
  scrollContent: { padding: 16, paddingBottom: 30 },
  periodTabs: { flexDirection: 'row', backgroundColor: Colors.cardBg, borderRadius: 12, padding: 4, marginBottom: 16 },
  periodTab: { flex: 1, paddingVertical: 8, alignItems: 'center', borderRadius: 10 },
  periodTabActive: { backgroundColor: Colors.primary },
  periodTabText: { fontSize: 13, fontWeight: '700', color: Colors.textMuted },
  periodTabTextActive: { color: Colors.white },
  summaryGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: 10, marginBottom: 16 },
  summaryCard: { width: '47%', flexGrow: 1, backgroundColor: Colors.cardBg, borderRadius: 14, padding: 14, alignItems: 'center', shadowColor: Colors.shadow, shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1, shadowRadius: 5, elevation: 2 },
  summaryIcon: { width: 38, height: 38, borderRadius: 10, alignItems: 'center', justifyContent: 'center', marginBottom: 8 },
  summaryValue: { fontSize: 18, fontWeight: '800' },
  summaryUnit: { fontSize: 11, color: Colors.textMuted, fontWeight: '600' },
  summaryLabel: { fontSize: 12, color: Colors.textMuted, marginTop: 3, textAlign: 'center' },
  sectionTitle: { fontSize: 16, fontWeight: '800', color: Colors.textPrimary, marginBottom: 10, marginTop: 4 },
  chartCard: { backgroundColor: Colors.cardBg, borderRadius: 16, padding: 12, marginBottom: 14, shadowColor: Colors.shadow, shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1, shadowRadius: 6, elevation: 2 },
  chart: { borderRadius: 12 },
  pieRow: { flexDirection: 'row', gap: 10, marginBottom: 14 },
  pieTitle: { fontSize: 13, fontWeight: '800', color: Colors.textPrimary, marginBottom: 8, textAlign: 'center' },
  kpiGrid: { gap: 10 },
  kpiCard: { backgroundColor: Colors.cardBg, borderRadius: 14, padding: 14, shadowColor: Colors.shadow, shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1, shadowRadius: 5, elevation: 2 },
  kpiLabel: { fontSize: 13, color: Colors.textSecondary, fontWeight: '600', textAlign: 'right', marginBottom: 4 },
  kpiValue: { fontSize: 24, fontWeight: '800', textAlign: 'right' },
  kpiFooter: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginTop: 8 },
  kpiStatus: { paddingHorizontal: 8, paddingVertical: 3, borderRadius: 8 },
  kpiStatusText: { fontSize: 12, fontWeight: '700' },
  kpiTarget: { fontSize: 11, color: Colors.textMuted },
});
