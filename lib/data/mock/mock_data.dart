import 'dart:math';
import '../models/batch_model.dart';
import '../models/sensor_data_model.dart';
import '../models/post_model.dart';
import '../models/product_model.dart';

class MockData {
  static final _random = Random(42);

  // ─── Batches ───────────────────────────────────────────────────────────────
  static final List<BatchModel> batches = [
    BatchModel(
      id: 'B-001',
      name: 'الدفعة الأولى',
      breed: 'روس 308',
      totalBirds: 12000,
      currentBirds: 11820,
      ageInDays: 45,
      mortalityRate: 1.5,
      avgWeightKg: 2.45,
      status: 'active',
      farmName: 'مزرعة الأمل - أ',
      startDate: DateTime.now().subtract(const Duration(days: 45)),
      weeklyWeights: [0.17, 0.48, 1.02, 1.72, 2.32, 2.45],
      feedConversionRatio: 1.72,
    ),
    BatchModel(
      id: 'B-002',
      name: 'الدفعة الثانية',
      breed: 'كوب 500',
      totalBirds: 8500,
      currentBirds: 8432,
      ageInDays: 20,
      mortalityRate: 0.8,
      avgWeightKg: 0.85,
      status: 'active',
      farmName: 'مزرعة الأمل - ب',
      startDate: DateTime.now().subtract(const Duration(days: 20)),
      weeklyWeights: [0.16, 0.45, 0.85],
      feedConversionRatio: 1.58,
    ),
    BatchModel(
      id: 'B-003',
      name: 'الدفعة الثالثة',
      breed: 'هوبارد كلاسيك',
      totalBirds: 3300,
      currentBirds: 3294,
      ageInDays: 5,
      mortalityRate: 0.18,
      avgWeightKg: 0.12,
      status: 'new',
      farmName: 'مزرعة الأمل - أ',
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      weeklyWeights: [0.12],
      feedConversionRatio: 1.30,
    ),
  ];

  // ─── Sensor History (48 readings = last 24h, every 30min) ─────────────────
  static List<SensorReading> generateSensorHistory() {
    final now = DateTime.now();
    final readings = <SensorReading>[];
    for (int i = 47; i >= 0; i--) {
      final time = now.subtract(Duration(minutes: i * 30));
      final hour = time.hour;
      // Diurnal pattern: cooler at night, peaks at 14:00
      double baseTemp;
      if (hour >= 0 && hour < 6) {
        baseTemp = 29.5 + (hour / 6) * 1.5;
      } else if (hour >= 6 && hour < 14) {
        baseTemp = 31.0 + ((hour - 6) / 8) * 3.5;
      } else if (hour >= 14 && hour < 20) {
        baseTemp = 34.5 - ((hour - 14) / 6) * 3.0;
      } else {
        baseTemp = 31.5 - ((hour - 20) / 4) * 2.0;
      }
      final jitter = (_random.nextDouble() - 0.5) * 0.6;
      readings.add(SensorReading(
        timestamp: time,
        temperature: double.parse((baseTemp + jitter).toStringAsFixed(1)),
        humidity: double.parse((62.0 + _random.nextDouble() * 10).toStringAsFixed(1)),
        ammonia: double.parse((_random.nextDouble() * 5).toStringAsFixed(1)),
      ));
    }
    return readings;
  }

  // ─── Community Posts ───────────────────────────────────────────────────────
  static List<PostModel> posts = [
    PostModel(
      id: 'P-001',
      authorName: 'محمد العمري',
      authorInitials: 'م',
      authorColorIndex: 0,
      timeAgo: 'منذ ساعتين',
      content:
          'تجربتي مع سلالة روس 308 هذا الموسم كانت رائعة جداً! وصلنا إلى وزن 2.5 كجم في اليوم 45 مع معدل تحويل غذائي 1.72. أنصح الجميع بهذه السلالة في الطقس الحار 🌟',
      imageUrl: 'https://picsum.photos/seed/chickens1/400/250',
      likes: 124,
      commentsCount: 18,
      category: 'تجارب',
    ),
    PostModel(
      id: 'P-002',
      authorName: 'فاطمة الزهراء',
      authorInitials: 'ف',
      authorColorIndex: 1,
      timeAgo: 'منذ 5 ساعات',
      content:
          'سؤال للخبراء: ما هي أنسب درجة حرارة للكتاكيت في الأسبوع الأول؟ أجد تضارباً في المعلومات بين 32 و35 درجة. مزرعتي في منطقة حارة.',
      likes: 45,
      commentsCount: 32,
      category: 'أسئلة',
    ),
    PostModel(
      id: 'P-003',
      authorName: 'أحمد السيد',
      authorInitials: 'أ',
      authorColorIndex: 2,
      timeAgo: 'منذ يوم',
      content:
          '💡 نصيحة مهمة: في فصل الصيف، تأكد من التهوية الجيدة للحظيرة بين الساعة 2 و5 مساءً. استثمرت في 4 مراوح إضافية وانخفض معدل النفوق بنسبة 60% مقارنة بالصيف الماضي!',
      imageUrl: 'https://picsum.photos/seed/farm2/400/250',
      likes: 287,
      commentsCount: 54,
      category: 'نصائح',
    ),
    PostModel(
      id: 'P-004',
      authorName: 'عمر الراشد',
      authorInitials: 'ع',
      authorColorIndex: 3,
      timeAgo: 'منذ يومين',
      content:
          'معدلات التحويل الغذائي هذا الموسم تحسنت بنسبة 12٪ عن العام الماضي، والسر في جودة الأعلاف وتنظيم مواعيد التغذية بدقة. النتائج تتحدث عن نفسها 📈',
      likes: 93,
      commentsCount: 11,
      category: 'إنجازات',
    ),
    PostModel(
      id: 'P-005',
      authorName: 'سارة المنصور',
      authorInitials: 'س',
      authorColorIndex: 4,
      timeAgo: 'منذ 3 أيام',
      content:
          'مشاركة صور من مزرعتنا بعد التطوير الأخير - حظائر جديدة بتقنية التبريد التبخيري. الفرق كبير جداً في راحة الطيور وخاصة في الصيف 🏠',
      imageUrl: 'https://picsum.photos/seed/farm3/400/250',
      likes: 342,
      commentsCount: 67,
      category: 'مشاريع',
    ),
    PostModel(
      id: 'P-006',
      authorName: 'د. خالد المطيري',
      authorInitials: 'د',
      authorColorIndex: 5,
      timeAgo: 'منذ 4 أيام',
      content:
          '⚠️ تحذير هام: رصدنا حالات من مرض النيوكاسل في بعض المناطق القريبة. الرجاء التأكد من التحصين الكامل لقطعانكم وتطبيق إجراءات الأمن الحيوي الصارمة.',
      likes: 512,
      commentsCount: 89,
      category: 'تحذيرات',
    ),
  ];

  // ─── Market Products ───────────────────────────────────────────────────────
  static const List<ProductModel> products = [
    ProductModel(
      id: 'PR-001',
      name: 'كتاكيت روس 308 يومي',
      category: 'كتاكيت',
      price: 8.50,
      unit: 'كتكوت',
      rating: 4.8,
      reviewCount: 256,
      imageUrl: 'https://picsum.photos/seed/chick1/300/300',
      seller: 'مصفح للدواجن',
      badge: 'الأكثر طلباً',
    ),
    ProductModel(
      id: 'PR-002',
      name: 'كتاكيت كوب 500 يومي',
      category: 'كتاكيت',
      price: 9.00,
      unit: 'كتكوت',
      rating: 4.6,
      reviewCount: 183,
      imageUrl: 'https://picsum.photos/seed/chick2/300/300',
      seller: 'الوطنية للدواجن',
    ),
    ProductModel(
      id: 'PR-003',
      name: 'علف بادئ (0-10 أيام)',
      category: 'أعلاف',
      price: 285.0,
      unit: 'كيس 50 كجم',
      rating: 4.9,
      reviewCount: 412,
      imageUrl: 'https://picsum.photos/seed/feed1/300/300',
      seller: 'الرياض للأعلاف',
      badge: 'جودة ممتازة',
    ),
    ProductModel(
      id: 'PR-004',
      name: 'علف ناهض (11-24 يوم)',
      category: 'أعلاف',
      price: 275.0,
      unit: 'كيس 50 كجم',
      rating: 4.7,
      reviewCount: 298,
      imageUrl: 'https://picsum.photos/seed/feed2/300/300',
      seller: 'الرياض للأعلاف',
    ),
    ProductModel(
      id: 'PR-005',
      name: 'علف منهي (25+ يوم)',
      category: 'أعلاف',
      price: 265.0,
      unit: 'كيس 50 كجم',
      rating: 4.7,
      reviewCount: 267,
      imageUrl: 'https://picsum.photos/seed/feed3/300/300',
      seller: 'الرياض للأعلاف',
    ),
    ProductModel(
      id: 'PR-006',
      name: 'ذرة صفراء مطحونة',
      category: 'أعلاف',
      price: 180.0,
      unit: 'كيس 50 كجم',
      rating: 4.5,
      reviewCount: 145,
      imageUrl: 'https://picsum.photos/seed/corn1/300/300',
      seller: 'الحبوب العربية',
    ),
    ProductModel(
      id: 'PR-007',
      name: 'فيتامين سولو برو',
      category: 'أدوية',
      price: 45.0,
      unit: 'قارورة 1 لتر',
      rating: 4.8,
      reviewCount: 334,
      imageUrl: 'https://picsum.photos/seed/med1/300/300',
      seller: 'الخليج للأدوية البيطرية',
      badge: 'الأفضل مبيعاً',
    ),
    ProductModel(
      id: 'PR-008',
      name: 'مضاد حيوي أموكسيسيلين',
      category: 'أدوية',
      price: 85.0,
      unit: 'علبة 100 جم',
      rating: 4.6,
      reviewCount: 189,
      imageUrl: 'https://picsum.photos/seed/med2/300/300',
      seller: 'الخليج للأدوية البيطرية',
    ),
    ProductModel(
      id: 'PR-009',
      name: 'لقاح نيوكاسل LaSota',
      category: 'أدوية',
      price: 120.0,
      unit: '1000 جرعة',
      rating: 4.9,
      reviewCount: 521,
      imageUrl: 'https://picsum.photos/seed/vac1/300/300',
      seller: 'ميريال الشرق الأوسط',
      badge: 'ضروري',
    ),
    ProductModel(
      id: 'PR-010',
      name: 'سخان غازي كوب ذهبي',
      category: 'معدات',
      price: 850.0,
      unit: 'قطعة',
      rating: 4.7,
      reviewCount: 98,
      imageUrl: 'https://picsum.photos/seed/eq1/300/300',
      seller: 'تجهيزات المزارع',
    ),
    ProductModel(
      id: 'PR-011',
      name: 'مروحة تهوية 50 سم',
      category: 'معدات',
      price: 650.0,
      unit: 'قطعة',
      rating: 4.5,
      reviewCount: 76,
      imageUrl: 'https://picsum.photos/seed/eq2/300/300',
      seller: 'تجهيزات المزارع',
    ),
    ProductModel(
      id: 'PR-012',
      name: 'مسقى أوتوماتيك نيبل',
      category: 'معدات',
      price: 35.0,
      unit: 'قطعة',
      rating: 4.8,
      reviewCount: 432,
      imageUrl: 'https://picsum.photos/seed/eq3/300/300',
      seller: 'حلول الري',
      badge: 'وفر المياه',
    ),
  ];

  // ─── Report data ──────────────────────────────────────────────────────────
  static const List<double> weeklyFeedTons = [2.4, 2.8, 3.6, 4.1];
  static const List<double> weeklyMortalityPct = [0.5, 0.3, 0.2, 0.1];
  static const List<double> weeklyAvgWeightKg = [0.17, 0.48, 1.02, 1.72];
  static const List<double> weeklyEggCount = [0, 0, 0, 0]; // broilers, not layers

  static const Map<String, double> batchDistribution = {
    'روس 308': 49.4,
    'كوب 500': 34.9,
    'هوبارد': 13.6,
    'أخرى': 2.1,
  };
}
