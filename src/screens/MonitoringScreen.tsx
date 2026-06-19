import React, { useRef, useEffect, useState } from 'react';
import { View, Text, StyleSheet, ScrollView, Animated, Dimensions } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { LineChart } from 'react-native-chart-kit';
import { Colors } from '../constants/colors';
import AnimatedGauge from '../components/AnimatedGauge';
import { useLiveData } from '../hooks/useLiveData';

const { width: SCREEN_WIDTH } = Dimensions.get('window');
const CHART_WIDTH = SCREEN_WIDTH - 40;

interface MetricTileProps {
  icon: string;
  label: string;
  value: string;
  unit: string;
  color: string;
  live?: boolean;
}

function MetricTile({ icon, label, value, unit, color, live }: MetricTileProps) {
  const pulseAnim = useRef(new Animated.Value(1)).current;
  useEffect(() => {
    if (live) {
      Animated.loop(
        Animated.sequence([
          Animated.timing(pulseAnim, { toValue: 0.3, duration: 700, useNativeDriver: true }),
          Animated.timing(pulseAnim, { toValue: 1, duration: 700, useNativeDriver: true }),
        ])
      ).start();
    }
  }, [live]);

  return (
    <View style={[styles.metricTile, { borderTopColor: color }]}>
      <View style={[styles.metricIcon, { backgroundColor: color + '18' }]}>
        <Ionicons name={icon as any} size={20} color={color} />
      </View>
      <Text style={styles.metricValue}><Text style={{ color }}>{value}</Text> <Text style={styles.metricUnit}>{unit}</Text></Text>
      <Text style={styles.metricLabel}>{label}</Text>
      {live && (
        <View style={styles.livePill}>
          <Animated.View style={[styles.liveDot, { opacity: pulseAnim, backgroundColor: Colors.success }]} />
          <Text style={styles.liveLabel}>مباشر</Text>
        </View>
      )}
    </View>
  );
}

export default function MonitoringScreen() {
  const liveData = useLiveData();
  const fadeAnim = useRef(new Animated.Value(0)).current;
  const [chartTab, setChartTab] = useState<'temp' | 'humidity'>('temp');

  useEffect(() => {
    Animated.timing(fadeAnim, { toValue: 1, duration: 700, useNativeDriver: true }).start();
  }, []);

  const tempAlert = liveData.temperature > 35;
  const tempWarn = liveData.temperature > 30;

  const chartData = {
    labels: Array.from({ length: 8 }, (_, i) => {
      const h = new Date().getHours() - 7 + i;
      return `${((h + 24) % 24).toString().padStart(2, '0')}`;
    }),
    datasets: [{
      data: chartTab === 'temp'
        ? liveData.tempHistory.slice(-8).map(v => parseFloat(v.toFixed(1)))
        : liveData.humidityHistory.slice(-8).map(v => parseFloat(v.toFixed(1))),
      color: () => chartTab === 'temp' ? Colors.primary : Colors.accent,
      strokeWidth: 3,
    }],
  };

  return (
    <View style={styles.root}>
      <LinearGradient
        colors={[Colors.primaryDark, Colors.primary]}
        style={styles.header}
      >
        <SafeAreaView edges={['top']}>
          <View style={styles.headerContent}>
            <Text style={styles.title}>مراقبة البيئة</Text>
            <View style={styles.liveBadge}>
              <View style={styles.liveDotHeader} />
              <Text style={styles.liveBadgeText}>مباشر</Text>
            </View>
          </View>
        </SafeAreaView>
      </LinearGradient>

      <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.scrollContent}>
        <Animated.View style={{ opacity: fadeAnim }}>
          {/* Main gauge */}
          <View style={styles.gaugeSection}>
            <View style={styles.gaugeCard}>
              <AnimatedGauge
                value={liveData.temperature}
                min={10}
                max={45}
                unit="°م"
                label="درجة الحرارة"
                size={220}
                warnAbove={30}
                dangerAbove={35}
              />
            </View>
            <View style={styles.gaugeCard}>
              <AnimatedGauge
                value={liveData.humidity}
                min={20}
                max={100}
                unit="%"
                label="الرطوبة"
                size={220}
                warnAbove={75}
                dangerAbove={85}
              />
            </View>
          </View>

          {/* Alert */}
          {tempAlert && (
            <View style={[styles.alertBox, { borderColor: Colors.danger }]}>
              <Ionicons name="warning" size={20} color={Colors.danger} />
              <View style={{ flex: 1 }}>
                <Text style={styles.alertTitle}>تحذير حرارة حرجة!</Text>
                <Text style={styles.alertDesc}>الحرارة {liveData.temperature.toFixed(1)}°م — افتح نظام التهوية فوراً وأضف ماء بارد</Text>
              </View>
            </View>
          )}

          {/* Metrics grid */}
          <Text style={styles.sectionTitle}>المعطيات البيئية</Text>
          <View style={styles.metricsGrid}>
            <MetricTile icon="thermometer" label="الحرارة" value={liveData.temperature.toFixed(1)} unit="°م" color={tempAlert ? Colors.danger : Colors.primary} live />
            <MetricTile icon="water" label="الرطوبة" value={liveData.humidity.toString()} unit="%" color={Colors.accent} live />
            <MetricTile icon="cloud" label="ثاني أكسيد الكربون" value={liveData.co2.toString()} unit="ppm" color={liveData.co2 > 600 ? Colors.danger : Colors.secondary} live />
            <MetricTile icon="wind" label="التهوية" value={liveData.ventilation.toString()} unit="%" color={Colors.primaryLight} live />
            <MetricTile icon="sunny" label="الإضاءة" value="20" unit="لكس" color={Colors.accentLight} />
            <MetricTile icon="flame" label="الإجهاد الحراري" value={tempAlert ? 'حرج' : tempWarn ? 'متوسط' : 'منخفض'} unit="" color={tempAlert ? Colors.danger : tempWarn ? Colors.warning : Colors.success} />
          </View>

          {/* Chart */}
          <Text style={styles.sectionTitle}>التطور الزمني</Text>
          <View style={styles.chartCard}>
            <View style={styles.chartTabs}>
              <Text
                style={[styles.chartTab, chartTab === 'temp' && styles.chartTabActive]}
                onPress={() => setChartTab('temp')}
              >
                الحرارة
              </Text>
              <Text
                style={[styles.chartTab, chartTab === 'humidity' && styles.chartTabActive]}
                onPress={() => setChartTab('humidity')}
              >
                الرطوبة
              </Text>
            </View>
            <LineChart
              data={chartData}
              width={CHART_WIDTH - 24}
              height={160}
              chartConfig={{
                backgroundColor: Colors.cardBg,
                backgroundGradientFrom: Colors.cardBg,
                backgroundGradientTo: Colors.cardBg,
                decimalPlaces: 1,
                color: (opacity = 1) => chartTab === 'temp'
                  ? `rgba(46,125,50,${opacity})`
                  : `rgba(255,143,0,${opacity})`,
                labelColor: () => Colors.textMuted,
                style: { borderRadius: 12 },
                propsForDots: { r: '4', strokeWidth: '2', stroke: chartTab === 'temp' ? Colors.primary : Colors.accent },
              }}
              bezier
              style={styles.chart}
              withShadow={false}
              fromZero={false}
            />
          </View>

          {/* Optimal ranges reference */}
          <View style={styles.referenceCard}>
            <Text style={styles.referenceTitle}>📋 النطاقات المثالية</Text>
            {[
              { label: 'درجة الحرارة', range: '18 – 24°م', warn: '24 – 30°م', danger: '> 30°م' },
              { label: 'الرطوبة', range: '60 – 70%', warn: '70 – 80%', danger: '> 80%' },
              { label: 'CO₂', range: '< 400 ppm', warn: '400 – 600 ppm', danger: '> 600 ppm' },
            ].map(item => (
              <View key={item.label} style={styles.referenceRow}>
                <Text style={styles.refLabel}>{item.label}</Text>
                <View style={styles.refBadges}>
                  <View style={[styles.refBadge, { backgroundColor: Colors.success + '22' }]}>
                    <Text style={[styles.refBadgeText, { color: Colors.success }]}>{item.range}</Text>
                  </View>
                  <View style={[styles.refBadge, { backgroundColor: Colors.warning + '22' }]}>
                    <Text style={[styles.refBadgeText, { color: Colors.warning }]}>{item.warn}</Text>
                  </View>
                  <View style={[styles.refBadge, { backgroundColor: Colors.danger + '22' }]}>
                    <Text style={[styles.refBadgeText, { color: Colors.danger }]}>{item.danger}</Text>
                  </View>
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
  headerContent: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingTop: 8 },
  title: { fontSize: 22, fontWeight: '800', color: Colors.white },
  liveBadge: { flexDirection: 'row', alignItems: 'center', backgroundColor: 'rgba(255,255,255,0.2)', paddingHorizontal: 10, paddingVertical: 4, borderRadius: 10, gap: 5 },
  liveDotHeader: { width: 8, height: 8, borderRadius: 4, backgroundColor: '#4AFF72' },
  liveBadgeText: { color: Colors.white, fontWeight: '700', fontSize: 12 },
  scrollContent: { padding: 16, paddingBottom: 30 },
  gaugeSection: { flexDirection: 'row', justifyContent: 'space-around', backgroundColor: Colors.cardBg, borderRadius: 20, padding: 16, marginBottom: 14, shadowColor: Colors.shadow, shadowOffset: { width: 0, height: 3 }, shadowOpacity: 0.12, shadowRadius: 8, elevation: 3 },
  gaugeCard: { alignItems: 'center' },
  alertBox: { flexDirection: 'row', alignItems: 'center', gap: 10, padding: 14, borderRadius: 14, borderWidth: 1.5, backgroundColor: Colors.danger + '10', marginBottom: 14 },
  alertTitle: { fontSize: 14, fontWeight: '800', color: Colors.danger },
  alertDesc: { fontSize: 12, color: Colors.danger, opacity: 0.8, marginTop: 2, textAlign: 'right' },
  sectionTitle: { fontSize: 16, fontWeight: '800', color: Colors.textPrimary, marginBottom: 10, marginTop: 6 },
  metricsGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: 10, marginBottom: 16 },
  metricTile: { width: '30%', flexGrow: 1, backgroundColor: Colors.cardBg, borderRadius: 14, padding: 12, borderTopWidth: 3, shadowColor: Colors.shadow, shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1, shadowRadius: 5, elevation: 2 },
  metricIcon: { width: 36, height: 36, borderRadius: 10, alignItems: 'center', justifyContent: 'center', marginBottom: 8 },
  metricValue: { fontSize: 16, fontWeight: '800', textAlign: 'right' },
  metricUnit: { fontSize: 11, color: Colors.textMuted, fontWeight: '500' },
  metricLabel: { fontSize: 11, color: Colors.textMuted, marginTop: 3, textAlign: 'right' },
  livePill: { flexDirection: 'row', alignItems: 'center', gap: 3, marginTop: 5 },
  liveDot: { width: 6, height: 6, borderRadius: 3 },
  liveLabel: { fontSize: 10, color: Colors.success, fontWeight: '700' },
  chartCard: { backgroundColor: Colors.cardBg, borderRadius: 16, padding: 12, marginBottom: 14, shadowColor: Colors.shadow, shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1, shadowRadius: 6, elevation: 2 },
  chartTabs: { flexDirection: 'row', gap: 10, marginBottom: 10 },
  chartTab: { fontSize: 13, color: Colors.textMuted, fontWeight: '600', paddingHorizontal: 12, paddingVertical: 5, borderRadius: 8 },
  chartTabActive: { backgroundColor: Colors.primary + '18', color: Colors.primary },
  chart: { borderRadius: 12 },
  referenceCard: { backgroundColor: Colors.cardBg, borderRadius: 16, padding: 14, shadowColor: Colors.shadow, shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1, shadowRadius: 5, elevation: 2 },
  referenceTitle: { fontSize: 14, fontWeight: '800', color: Colors.textPrimary, marginBottom: 10 },
  referenceRow: { marginBottom: 10 },
  refLabel: { fontSize: 13, color: Colors.textSecondary, fontWeight: '700', marginBottom: 4, textAlign: 'right' },
  refBadges: { flexDirection: 'row', gap: 6, flexWrap: 'wrap' },
  refBadge: { paddingHorizontal: 8, paddingVertical: 3, borderRadius: 8 },
  refBadgeText: { fontSize: 11, fontWeight: '700' },
});
