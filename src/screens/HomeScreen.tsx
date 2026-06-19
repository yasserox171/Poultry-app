import React, { useEffect, useRef } from 'react';
import {
  View, Text, StyleSheet, ScrollView, Animated,
  TouchableOpacity, StatusBar, Platform,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Colors } from '../constants/colors';
import StatCard from '../components/StatCard';
import ChickenWalk from '../components/ChickenWalk';
import { useLiveData } from '../hooks/useLiveData';
import { MOCK_FLOCK, MOCK_USER } from '../data/mockData';

export default function HomeScreen({ navigation }: any) {
  const liveData = useLiveData();
  const fadeAnim = useRef(new Animated.Value(0)).current;
  const slideAnim = useRef(new Animated.Value(30)).current;
  const notifAnim = useRef(new Animated.Value(1)).current;

  useEffect(() => {
    Animated.parallel([
      Animated.timing(fadeAnim, { toValue: 1, duration: 600, useNativeDriver: true }),
      Animated.timing(slideAnim, { toValue: 0, duration: 600, useNativeDriver: true }),
    ]).start();

    Animated.loop(
      Animated.sequence([
        Animated.timing(notifAnim, { toValue: 1.15, duration: 700, useNativeDriver: true }),
        Animated.timing(notifAnim, { toValue: 1, duration: 700, useNativeDriver: true }),
      ])
    ).start();
  }, []);

  const tempAlert = liveData.temperature > 35;

  return (
    <View style={styles.root}>
      <StatusBar barStyle="light-content" backgroundColor={Colors.primaryDark} />
      <LinearGradient
        colors={[Colors.primaryDark, Colors.primary, Colors.primaryLight]}
        start={{ x: 0, y: 0 }}
        end={{ x: 1, y: 1 }}
        style={styles.header}
      >
        <SafeAreaView edges={['top']}>
          <View style={styles.headerTop}>
            <View>
              <Text style={styles.greeting}>مرحباً، {MOCK_USER.name.split(' ')[0]} 👋</Text>
              <Text style={styles.farmName}>{MOCK_USER.farm} · {MOCK_USER.location}</Text>
            </View>
            <View style={styles.headerActions}>
              <Animated.View style={{ transform: [{ scale: notifAnim }] }}>
                <TouchableOpacity style={styles.iconBtn}>
                  <Ionicons name="notifications" size={22} color={Colors.white} />
                  {tempAlert && <View style={styles.notifBadge} />}
                </TouchableOpacity>
              </Animated.View>
              <TouchableOpacity style={styles.avatarBtn}>
                <Text style={styles.avatarText}>أح</Text>
              </TouchableOpacity>
            </View>
          </View>

          {/* Chicken walk animation */}
          <View style={styles.chickenContainer}>
            <ChickenWalk width={340} speed={4000} color="rgba(255,255,255,0.85)" />
          </View>

          {/* Quick summary bar */}
          <View style={styles.summaryBar}>
            <View style={styles.summaryItem}>
              <Text style={styles.summaryValue}>{MOCK_FLOCK.totalBirds}</Text>
              <Text style={styles.summaryLabel}>طائر</Text>
            </View>
            <View style={styles.summaryDivider} />
            <View style={styles.summaryItem}>
              <Text style={[styles.summaryValue, tempAlert && { color: Colors.accentLight }]}>
                {liveData.temperature.toFixed(1)}°م
              </Text>
              <Text style={styles.summaryLabel}>الحرارة</Text>
            </View>
            <View style={styles.summaryDivider} />
            <View style={styles.summaryItem}>
              <Text style={styles.summaryValue}>{liveData.humidity}%</Text>
              <Text style={styles.summaryLabel}>الرطوبة</Text>
            </View>
            <View style={styles.summaryDivider} />
            <View style={styles.summaryItem}>
              <Text style={styles.summaryValue}>يوم {MOCK_FLOCK.age}</Text>
              <Text style={styles.summaryLabel}>العمر</Text>
            </View>
          </View>
        </SafeAreaView>
      </LinearGradient>

      <ScrollView
        style={styles.scroll}
        contentContainerStyle={styles.scrollContent}
        showsVerticalScrollIndicator={false}
      >
        <Animated.View style={{ opacity: fadeAnim, transform: [{ translateY: slideAnim }] }}>

          {/* Alert banner */}
          {tempAlert && (
            <View style={styles.alertBanner}>
              <Ionicons name="warning" size={18} color={Colors.danger} />
              <Text style={styles.alertText}>تحذير: درجة الحرارة مرتفعة! ({liveData.temperature.toFixed(1)}°م)</Text>
            </View>
          )}

          {/* Stats */}
          <Text style={styles.sectionTitle}>نظرة سريعة</Text>
          <StatCard
            label="درجة الحرارة"
            value={liveData.temperature.toFixed(1)}
            unit="°م"
            icon="thermometer"
            color={tempAlert ? Colors.danger : Colors.primary}
            live
            alert={tempAlert}
            onPress={() => navigation.navigate('Monitoring')}
          />
          <StatCard
            label="الرطوبة"
            value={liveData.humidity}
            unit="%"
            icon="water"
            color={Colors.accent}
            live
            onPress={() => navigation.navigate('Monitoring')}
          />
          <StatCard
            label="عدد الطيور"
            value={MOCK_FLOCK.totalBirds}
            unit="طائر"
            icon="egg"
            color={Colors.secondary}
            onPress={() => navigation.navigate('Flock')}
          />
          <StatCard
            label="نسبة النفوق"
            value={MOCK_FLOCK.mortalityRate}
            unit="%"
            icon="trending-down"
            color={MOCK_FLOCK.mortalityRate > 3 ? Colors.danger : Colors.success}
            trend="stable"
            onPress={() => navigation.navigate('Reports')}
          />
          <StatCard
            label="استهلاك العليقة اليوم"
            value={MOCK_FLOCK.feedConsumptionKg}
            unit="كغ"
            icon="leaf"
            color={Colors.primaryDark}
          />

          {/* Quick actions */}
          <Text style={styles.sectionTitle}>وصول سريع</Text>
          <View style={styles.quickActions}>
            {[
              { icon: 'bar-chart', label: 'التقارير', screen: 'Reports', color: Colors.primary },
              { icon: 'storefront', label: 'المتجر', screen: 'Store', color: Colors.accent },
              { icon: 'people', label: 'المجتمع', screen: 'Community', color: Colors.secondary },
              { icon: 'pulse', label: 'المراقبة', screen: 'Monitoring', color: Colors.accentLight },
            ].map(item => (
              <TouchableOpacity
                key={item.screen}
                style={styles.quickBtn}
                onPress={() => navigation.navigate(item.screen)}
              >
                <View style={[styles.quickIcon, { backgroundColor: item.color + '1A' }]}>
                  <Ionicons name={item.icon as any} size={24} color={item.color} />
                </View>
                <Text style={styles.quickLabel}>{item.label}</Text>
              </TouchableOpacity>
            ))}
          </View>

          {/* Today's tip */}
          <View style={styles.tipCard}>
            <Text style={styles.tipHeader}>💡 نصيحة اليوم</Text>
            <Text style={styles.tipText}>
              تأكد من إضاءة قفص الدجاج 23 ساعة في الأسبوع الأول لتحفيز الأكل والنمو. قلل الإضاءة تدريجياً مع التقدم في العمر.
            </Text>
          </View>

        </Animated.View>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1, backgroundColor: Colors.background },
  header: { paddingHorizontal: 20, paddingBottom: 20 },
  headerTop: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingTop: 8 },
  greeting: { fontSize: 22, fontWeight: '800', color: Colors.white },
  farmName: { fontSize: 13, color: 'rgba(255,255,255,0.8)', marginTop: 2 },
  headerActions: { flexDirection: 'row', alignItems: 'center', gap: 10 },
  iconBtn: { width: 40, height: 40, borderRadius: 12, backgroundColor: 'rgba(255,255,255,0.2)', alignItems: 'center', justifyContent: 'center' },
  notifBadge: { position: 'absolute', top: 8, right: 8, width: 8, height: 8, borderRadius: 4, backgroundColor: Colors.danger, borderWidth: 1.5, borderColor: Colors.white },
  avatarBtn: { width: 40, height: 40, borderRadius: 20, backgroundColor: 'rgba(255,255,255,0.25)', alignItems: 'center', justifyContent: 'center', borderWidth: 2, borderColor: 'rgba(255,255,255,0.5)' },
  avatarText: { color: Colors.white, fontWeight: '800', fontSize: 14 },
  chickenContainer: { marginVertical: 8, overflow: 'hidden' },
  summaryBar: { flexDirection: 'row', backgroundColor: 'rgba(0,0,0,0.2)', borderRadius: 14, padding: 12, marginTop: 4 },
  summaryItem: { flex: 1, alignItems: 'center' },
  summaryValue: { fontSize: 16, fontWeight: '800', color: Colors.white },
  summaryLabel: { fontSize: 11, color: 'rgba(255,255,255,0.7)', marginTop: 2 },
  summaryDivider: { width: 1, backgroundColor: 'rgba(255,255,255,0.25)', marginVertical: 4 },
  scroll: { flex: 1 },
  scrollContent: { padding: 16, paddingBottom: 30 },
  alertBanner: { flexDirection: 'row', alignItems: 'center', backgroundColor: Colors.danger + '15', borderRadius: 12, padding: 12, marginBottom: 14, borderLeftWidth: 4, borderLeftColor: Colors.danger, gap: 8 },
  alertText: { flex: 1, color: Colors.danger, fontWeight: '700', fontSize: 13 },
  sectionTitle: { fontSize: 16, fontWeight: '800', color: Colors.textPrimary, marginBottom: 10, marginTop: 6 },
  quickActions: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 16 },
  quickBtn: { alignItems: 'center', width: '23%' },
  quickIcon: { width: 52, height: 52, borderRadius: 16, alignItems: 'center', justifyContent: 'center', marginBottom: 6 },
  quickLabel: { fontSize: 12, color: Colors.textSecondary, fontWeight: '600', textAlign: 'center' },
  tipCard: { backgroundColor: Colors.cardBg, borderRadius: 16, padding: 16, borderLeftWidth: 4, borderLeftColor: Colors.accent },
  tipHeader: { fontSize: 14, fontWeight: '800', color: Colors.accent, marginBottom: 6 },
  tipText: { fontSize: 13, color: Colors.textSecondary, lineHeight: 21, textAlign: 'right' },
});
