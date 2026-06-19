import React, { useRef, useEffect, useState } from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity, Animated, TextInput, KeyboardAvoidingView, Platform } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import PostCard from '../components/PostCard';
import { MOCK_POSTS, EXPERTS, MOCK_USER } from '../data/mockData';

const TABS = [
  { key: 'feed', label: 'المنشورات', icon: 'home' },
  { key: 'experts', label: 'خبراء', icon: 'school' },
  { key: 'tips', label: 'نصائح', icon: 'bulb' },
];

export default function CommunityScreen() {
  const [activeTab, setActiveTab] = useState('feed');
  const [postText, setPostText] = useState('');
  const [showCompose, setShowCompose] = useState(false);
  const fadeAnim = useRef(new Animated.Value(0)).current;
  const composeAnim = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    Animated.timing(fadeAnim, { toValue: 1, duration: 600, useNativeDriver: true }).start();
  }, []);

  useEffect(() => {
    Animated.timing(composeAnim, {
      toValue: showCompose ? 1 : 0,
      duration: 300,
      useNativeDriver: true,
    }).start();
  }, [showCompose]);

  return (
    <View style={styles.root}>
      <LinearGradient colors={[Colors.primaryDark, Colors.primary]} style={styles.header}>
        <SafeAreaView edges={['top']}>
          <View style={styles.headerTop}>
            <Text style={styles.title}>مجتمع المربين</Text>
            <View style={styles.membersInfo}>
              <View style={styles.onlineDot} />
              <Text style={styles.membersText}>1,247 عضو</Text>
            </View>
          </View>
          {/* Tabs */}
          <View style={styles.tabs}>
            {TABS.map(tab => (
              <TouchableOpacity
                key={tab.key}
                style={[styles.tab, activeTab === tab.key && styles.tabActive]}
                onPress={() => setActiveTab(tab.key)}
              >
                <Ionicons name={tab.icon as any} size={14} color={activeTab === tab.key ? Colors.white : 'rgba(255,255,255,0.7)'} />
                <Text style={[styles.tabText, activeTab === tab.key && styles.tabTextActive]}>{tab.label}</Text>
              </TouchableOpacity>
            ))}
          </View>
        </SafeAreaView>
      </LinearGradient>

      <Animated.View style={[{ flex: 1, opacity: fadeAnim }]}>
        {activeTab === 'feed' && (
          <FlatList
            data={MOCK_POSTS}
            keyExtractor={item => item.id}
            contentContainerStyle={styles.feedContent}
            showsVerticalScrollIndicator={false}
            ListHeaderComponent={
              <TouchableOpacity style={styles.composePrompt} onPress={() => setShowCompose(!showCompose)}>
                <Text style={styles.composeAvatar}>أح</Text>
                <Text style={styles.composePlaceholder}>شارك تجربتك أو اطرح سؤالاً...</Text>
                <Ionicons name="image-outline" size={20} color={Colors.textMuted} />
              </TouchableOpacity>
            }
            renderItem={({ item }) => <PostCard post={item} />}
          />
        )}

        {activeTab === 'experts' && (
          <FlatList
            data={EXPERTS}
            keyExtractor={item => item.id}
            contentContainerStyle={styles.feedContent}
            showsVerticalScrollIndicator={false}
            ListHeaderComponent={<Text style={styles.sectionTitle}>خبراء معتمدون</Text>}
            renderItem={({ item }) => (
              <View style={styles.expertCard}>
                <View style={styles.expertAvatarWrap}>
                  <Text style={styles.expertAvatarText}>{item.name.charAt(0)}</Text>
                  <View style={styles.expertBadge}>
                    <Ionicons name="checkmark" size={10} color={Colors.white} />
                  </View>
                </View>
                <View style={styles.expertInfo}>
                  <Text style={styles.expertName}>{item.name}</Text>
                  <Text style={styles.expertSpecialty}>{item.specialty}</Text>
                  <View style={styles.expertStats}>
                    <View style={styles.expertStat}>
                      <Ionicons name="star" size={12} color={Colors.accentLight} />
                      <Text style={styles.expertStatText}>{item.rating}</Text>
                    </View>
                    <View style={styles.expertStat}>
                      <Ionicons name="chatbubbles" size={12} color={Colors.textMuted} />
                      <Text style={styles.expertStatText}>{item.answers} إجابة</Text>
                    </View>
                  </View>
                </View>
                <TouchableOpacity style={styles.askBtn}>
                  <Text style={styles.askBtnText}>اسأل</Text>
                </TouchableOpacity>
              </View>
            )}
          />
        )}

        {activeTab === 'tips' && (
          <FlatList
            data={[
              { id: '1', icon: '🌡️', title: 'إدارة درجة الحرارة', content: 'في الأسبوع الأول: 33-35°م، ثم خفض 3°م كل أسبوع حتى الوصول لـ 21°م.' },
              { id: '2', icon: '💧', title: 'تقنية قطرة الماء', content: 'افحص مسطحات الماء يومياً. الماء النقي يرفع الإنتاجية 15% ويقلل الأمراض.' },
              { id: '3', icon: '🍽️', title: 'تقنية تقديم العليقة', content: 'قدم العليقة بكميات صغيرة ومتكررة لضمان نضارة الأكل وتحفيز الشهية.' },
              { id: '4', icon: '💉', title: 'جدول التطعيم', content: 'يوم 7: نيوكاسل. يوم 14: التهاب الحويصلة. يوم 21: الجمرة الخبيثة (حسب المنطقة).' },
              { id: '5', icon: '🏠', title: 'كثافة التربية', content: 'لا تتجاوز 25 كغ من الوزن الحي لكل متر مربع لضمان الرفاهية والإنتاجية.' },
              { id: '6', icon: '🌿', title: 'نظافة الفراش', content: 'أبقِ رطوبة الفراش بين 25-35%. الفراش الرطب يسبب أمراضاً جلدية وتنفسية.' },
            ]}
            keyExtractor={item => item.id}
            contentContainerStyle={styles.feedContent}
            showsVerticalScrollIndicator={false}
            ListHeaderComponent={<Text style={styles.sectionTitle}>نصائح ذهبية للمربي</Text>}
            renderItem={({ item }) => (
              <View style={styles.tipCard}>
                <Text style={styles.tipIcon}>{item.icon}</Text>
                <View style={styles.tipContent}>
                  <Text style={styles.tipTitle}>{item.title}</Text>
                  <Text style={styles.tipText}>{item.content}</Text>
                </View>
              </View>
            )}
          />
        )}
      </Animated.View>

      {/* FAB */}
      <TouchableOpacity style={styles.fab} onPress={() => setShowCompose(!showCompose)}>
        <Ionicons name={showCompose ? 'close' : 'add'} size={26} color={Colors.white} />
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1, backgroundColor: Colors.background },
  header: { paddingHorizontal: 20, paddingBottom: 14 },
  headerTop: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingTop: 8, marginBottom: 12 },
  title: { fontSize: 22, fontWeight: '800', color: Colors.white },
  membersInfo: { flexDirection: 'row', alignItems: 'center', gap: 5, backgroundColor: 'rgba(255,255,255,0.2)', paddingHorizontal: 10, paddingVertical: 5, borderRadius: 12 },
  onlineDot: { width: 7, height: 7, borderRadius: 4, backgroundColor: '#4AFF72' },
  membersText: { color: Colors.white, fontSize: 12, fontWeight: '700' },
  tabs: { flexDirection: 'row', gap: 8 },
  tab: { flexDirection: 'row', alignItems: 'center', gap: 5, paddingHorizontal: 14, paddingVertical: 7, borderRadius: 20, borderWidth: 1, borderColor: 'rgba(255,255,255,0.3)' },
  tabActive: { backgroundColor: 'rgba(255,255,255,0.25)', borderColor: 'rgba(255,255,255,0.5)' },
  tabText: { color: 'rgba(255,255,255,0.7)', fontSize: 12, fontWeight: '700' },
  tabTextActive: { color: Colors.white },
  feedContent: { padding: 14, paddingBottom: 80 },
  sectionTitle: { fontSize: 16, fontWeight: '800', color: Colors.textPrimary, marginBottom: 12 },
  composePrompt: { flexDirection: 'row', alignItems: 'center', backgroundColor: Colors.cardBg, borderRadius: 14, padding: 14, marginBottom: 14, gap: 10, shadowColor: Colors.shadow, shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1, shadowRadius: 5, elevation: 2 },
  composeAvatar: { width: 38, height: 38, borderRadius: 19, backgroundColor: Colors.primary, color: Colors.white, textAlign: 'center', lineHeight: 38, fontWeight: '800', fontSize: 15 },
  composePlaceholder: { flex: 1, color: Colors.textMuted, fontSize: 14, textAlign: 'right' },
  expertCard: { flexDirection: 'row', alignItems: 'center', backgroundColor: Colors.cardBg, borderRadius: 16, padding: 14, marginBottom: 10, shadowColor: Colors.shadow, shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1, shadowRadius: 5, elevation: 2 },
  expertAvatarWrap: { position: 'relative', marginRight: 12 },
  expertAvatarText: { width: 46, height: 46, borderRadius: 23, backgroundColor: Colors.primary, color: Colors.white, textAlign: 'center', lineHeight: 46, fontWeight: '800', fontSize: 20, overflow: 'hidden' },
  expertBadge: { position: 'absolute', bottom: 0, right: 0, width: 16, height: 16, borderRadius: 8, backgroundColor: Colors.success, alignItems: 'center', justifyContent: 'center', borderWidth: 2, borderColor: Colors.white },
  expertInfo: { flex: 1 },
  expertName: { fontSize: 14, fontWeight: '800', color: Colors.textPrimary, textAlign: 'right' },
  expertSpecialty: { fontSize: 12, color: Colors.textMuted, marginTop: 2, textAlign: 'right' },
  expertStats: { flexDirection: 'row', gap: 10, marginTop: 5, justifyContent: 'flex-end' },
  expertStat: { flexDirection: 'row', alignItems: 'center', gap: 3 },
  expertStatText: { fontSize: 11, color: Colors.textMuted, fontWeight: '600' },
  askBtn: { backgroundColor: Colors.primary + '18', borderRadius: 10, paddingHorizontal: 12, paddingVertical: 6, borderWidth: 1, borderColor: Colors.primary + '40' },
  askBtnText: { color: Colors.primary, fontWeight: '700', fontSize: 13 },
  tipCard: { flexDirection: 'row', backgroundColor: Colors.cardBg, borderRadius: 14, padding: 14, marginBottom: 10, gap: 12, shadowColor: Colors.shadow, shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1, shadowRadius: 5, elevation: 2 },
  tipIcon: { fontSize: 28 },
  tipContent: { flex: 1 },
  tipTitle: { fontSize: 14, fontWeight: '800', color: Colors.textPrimary, marginBottom: 4, textAlign: 'right' },
  tipText: { fontSize: 13, color: Colors.textSecondary, lineHeight: 20, textAlign: 'right' },
  fab: { position: 'absolute', bottom: 80, left: 20, width: 56, height: 56, borderRadius: 28, backgroundColor: Colors.primary, alignItems: 'center', justifyContent: 'center', shadowColor: Colors.primary, shadowOffset: { width: 0, height: 6 }, shadowOpacity: 0.4, shadowRadius: 12, elevation: 8 },
});
