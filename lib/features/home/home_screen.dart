import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/batch_model.dart';
import '../../providers/sensor_provider.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToMonitor;
  const HomeScreen({super.key, this.onNavigateToMonitor});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _chickenController;

  @override
  void initState() {
    super.initState();
    _chickenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _chickenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sensor = context.watch<SensorProvider>();
    final totalBirds = MockData.batches.fold<int>(0, (s, b) => s + b.currentBirds);
    final activeBatches = MockData.batches.where((b) => b.status == 'active').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeader(sensor),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),
                _buildQuickStats(totalBirds, activeBatches, sensor),
                const SizedBox(height: 20),
                _buildTemperatureCard(sensor),
                const SizedBox(height: 20),
                _buildSectionTitle('دفعاتك النشطة'),
                const SizedBox(height: 12),
                ...MockData.batches
                    .where((b) => b.status != 'completed')
                    .map((b) => _BatchCard(batch: b))
                    .toList(),
                const SizedBox(height: 20),
                _buildAlertsSection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(SensorProvider sensor) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.headerGradient,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مرحباً،',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          'أحمد حسن 👋',
                          style: GoogleFonts.cairo(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'مزرعة الأمل • F-2024-001',
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('أ', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
                const SizedBox(height: 20),
                // Animated chicken banner
                _ChickenBanner(controller: _chickenController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(int totalBirds, int activeBatches, SensorProvider sensor) {
    return Row(
      children: [
        Expanded(child: _QuickStatTile(
          icon: Icons.egg_alt_rounded,
          label: 'إجمالي الطيور',
          value: _formatNumber(totalBirds),
          color: AppColors.primary,
        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.3)),
        const SizedBox(width: 12),
        Expanded(child: _QuickStatTile(
          icon: Icons.folder_special_rounded,
          label: 'الدفعات النشطة',
          value: '$activeBatches دفعات',
          color: AppColors.info,
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3)),
        const SizedBox(width: 12),
        Expanded(child: _QuickStatTile(
          icon: Icons.thermostat_rounded,
          label: 'الحرارة',
          value: '${sensor.temperature}°',
          color: sensor.temperature >= 35 ? AppColors.warning : AppColors.success,
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3)),
      ],
    );
  }

  Widget _buildTemperatureCard(SensorProvider sensor) {
    return GestureDetector(
      onTap: widget.onNavigateToMonitor,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('مراقبة الحظيرة',
                      style: GoogleFonts.cairo(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('${sensor.temperature}°C',
                          style: GoogleFonts.cairo(
                              color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: sensor.statusColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: sensor.statusColor),
                        ),
                        child: Text(sensor.temperatureStatus,
                            style: GoogleFonts.cairo(color: sensor.statusColor, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.water_drop, color: Colors.white54, size: 16),
                      const SizedBox(width: 4),
                      Text('رطوبة: ${sensor.humidity}٪',
                          style: GoogleFonts.cairo(color: Colors.white70, fontSize: 13)),
                      const SizedBox(width: 16),
                      Icon(Icons.air, color: Colors.white54, size: 16),
                      const SizedBox(width: 4),
                      Text('أمونيا: ${sensor.ammonia} ppm',
                          style: GoogleFonts.cairo(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Icon(Icons.chevron_left_rounded, color: Colors.white60, size: 28),
                const SizedBox(height: 4),
                Text('تفاصيل', style: GoogleFonts.cairo(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ],
        ),
      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.cairo(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildAlertsSection() {
    final alerts = [
      {'icon': Icons.warning_amber_rounded, 'color': AppColors.warning,
       'text': 'درجة حرارة مرتفعة في الحظيرة أ - تحقق الآن', 'time': 'منذ 10 دقائق'},
      {'icon': Icons.check_circle_rounded, 'color': AppColors.success,
       'text': 'تم إتمام التحصين للدفعة الأولى بنجاح', 'time': 'منذ ساعة'},
      {'icon': Icons.info_rounded, 'color': AppColors.info,
       'text': 'موعد وزن الدفعة الثانية غداً الساعة 8 صباحاً', 'time': 'منذ 3 ساعات'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('التنبيهات الأخيرة'),
        const SizedBox(height: 12),
        ...alerts.asMap().entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
            ),
            child: Row(
              children: [
                Icon(e.value['icon'] as IconData, color: e.value['color'] as Color, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.value['text'] as String,
                          style: GoogleFonts.cairo(fontSize: 13, color: AppColors.textPrimary)),
                      Text(e.value['time'] as String,
                          style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textHint)),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: 600 + e.key * 100)).slideX(begin: 0.1),
        )),
      ],
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}ك';
    return n.toString();
  }
}

class _ChickenBanner extends StatelessWidget {
  final AnimationController controller;
  const _ChickenBanner({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (_, __) => Transform.translate(
              offset: Offset(0, controller.value * -6),
              child: const Text('🐔', style: TextStyle(fontSize: 36)),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedBuilder(
            animation: controller,
            builder: (_, __) => Transform.translate(
              offset: Offset(0, (1 - controller.value) * -5),
              child: const Text('🐥', style: TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('كل ما تحتاجه لنجاح مشروعك',
                    style: GoogleFonts.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                Text('في تطبيق واحد 🌟',
                    style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _QuickStatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          Text(label,
              style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textSecondary),
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _BatchCard extends StatelessWidget {
  final BatchModel batch;
  const _BatchCard({required this.batch});

  @override
  Widget build(BuildContext context) {
    final progress = batch.ageInDays / 45.0;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Text('🐓', style: TextStyle(fontSize: 24))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(batch.name,
                        style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.bold)),
                    Text('${batch.breed} • ${batch.farmName}',
                        style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: batch.status == 'new' ? AppColors.info.withOpacity(0.15) : AppColors.success.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(batch.statusLabel,
                    style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: batch.status == 'new' ? AppColors.info : AppColors.success,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _BatchStat('الطيور', '${_fmt(batch.currentBirds)} طائر'),
              _vDivider(),
              _BatchStat('العمر', '${batch.ageInDays} يوم'),
              _vDivider(),
              _BatchStat('متوسط الوزن', '${batch.avgWeightKg} كجم'),
              _vDivider(),
              _BatchStat('النفوق', '${batch.mortalityRate}٪'),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppColors.divider,
              valueColor: const AlwaysStoppedAnimation(AppColors.primaryLight),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('تقدم الدورة', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textSecondary)),
              Text('${(progress * 100).toInt()}٪ (${batch.ageInDays}/45 يوم)',
                  style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 550.ms).slideY(begin: 0.2);
  }

  Widget _vDivider() => Container(height: 30, width: 1, color: AppColors.divider, margin: const EdgeInsets.symmetric(horizontal: 6));

  String _fmt(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}ك';
    return n.toString();
  }
}

class _BatchStat extends StatelessWidget {
  final String label;
  final String value;
  const _BatchStat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary), textAlign: TextAlign.center),
          Text(label, style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textSecondary), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
